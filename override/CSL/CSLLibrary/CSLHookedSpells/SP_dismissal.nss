//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All summoned creatures within 30ft of caster
	make a save and SR check or be banished
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_dismissal();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DISMISSAL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oMaster;
	effect eVis = EffectVisualEffect(VFX_HIT_AOE_ABJURATION);
	effect eDeath = EffectLinkEffects(eVis, EffectDeath(FALSE, TRUE, TRUE));
	int nBaseSpellDC = HkGetSpellSaveDC() + iSpellPower;
	int nAdjustedSpellDC;
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		oMaster = GetMaster(oTarget);
		if ((GetIsObjectValid(oMaster) && CSLSpellsIsTarget(oMaster, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) || CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			if (CSLGetIsDismissable(oTarget, TRUE))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DISMISSAL));
				nAdjustedSpellDC = nBaseSpellDC - GetHitDice(oTarget);
				if (!HkResistSpell(oCaster, oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, nAdjustedSpellDC)) {
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				}
			}
		}
		//Get next creature in the shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	
	HkPostCast(oCaster);
}

