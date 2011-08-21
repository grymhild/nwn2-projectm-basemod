//::///////////////////////////////////////////////
//:: Undeath to Death
//:: X2_S0_Undeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

	This spell slays 1d4 HD worth of undead creatures
	per caster level (maximum 20d4). Creatures with
	the fewest HD are affected first;

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On:  August 13, 2003
//:://////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




//#include "x2_inc_toollib"

const string BEENPROCESSED = "UNDEATH_CHECK";

void DoUndeadToDeath(object oCreature) {
	SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	SetLocalInt(oCreature, BEENPROCESSED, TRUE);
	if (!HkSavingThrow(SAVING_THROW_WILL, oCreature, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF)) {
		float fDelay = CSLRandomBetweenFloat(0.2f, 0.4f);
		if (!HkResistSpell(OBJECT_SELF, oCreature, fDelay)) {
			effect eDeath = EffectDamage(GetCurrentHitPoints(oCreature), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
			DelayCommand(fDelay+0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oCreature));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature));
		} else {
			DelayCommand(1.0f, DeleteLocalInt(oCreature, BEENPROCESSED));
		}
	} else {
		DelayCommand(1.0f, DeleteLocalInt(oCreature, BEENPROCESSED));
	}
}

void main()
{
	//scSpellMetaData = SCMeta_SP_undeathtodea();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNDEATH_TO_DEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 20 );

	location lLoc = HkGetSpellTargetLocation();

	int nLow = 9999;
	object oLow;
	
	int nHDLeft = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
	
	int nCurHD;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	while (GetIsObjectValid(oTarget) && nHDLeft >0)
	{
		if ( CSLGetIsUndead( oTarget ) )
		{
			nCurHD = GetHitDice(oTarget);
			if (nCurHD<=nHDLeft)
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					if (!GetLocalInt(oTarget, BEENPROCESSED) && !GetPlotFlag(oTarget) && !GetIsDead(oTarget))
					{
						if (GetHitDice(oTarget)<=nLow)
						{
							nLow = GetHitDice(oTarget);
							oLow = oTarget;
						}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius , lLoc);
		if (!GetIsObjectValid(oTarget))
		{
			if (GetIsObjectValid(oLow) && nHDLeft>=nLow)
			{
				DoUndeadToDeath(oLow);
				nHDLeft -= nLow;
				oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
			}
			oLow = OBJECT_INVALID;
			nLow = 9999;
		}
	}
	HkPostCast(oCaster);
 }

