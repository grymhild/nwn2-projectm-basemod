//::///////////////////////////////////////////////
//::
//:: x0_s0_banishment.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All summoned creatures within 30ft of caster
	make a save and SR check or be banished
	+ As well any Outsiders being must make a
	save and SR check or be banished (up to
	2 HD creatures / level can be banished)
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_banishment();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BANISHMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
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
	int iSpellPower = HkGetSpellPower( oCaster );
	location lTarget = HkGetSpellTargetLocation();
	int nPool = 2 * iSpellPower;   // * the pool is the number of hit dice of creatures that can be banished
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while (GetIsObjectValid(oTarget)) {
		if (CSLGetIsDismissable(oTarget)) {
			if (nPool > 0) {
				if (oTarget!=oCaster && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
					SignalEvent(oTarget, EventSpellCastAt(oCaster, 430, TRUE));
					if (nPool >= GetHitDice(oTarget)) {
						if (!HkResistSpell(oCaster, oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC())) {
							nPool = nPool - GetHitDice(oTarget);
							HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ABJURATION), GetLocation(oTarget));
							if (CSLIsCreatureDestroyable(oTarget)) {
								effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
								effect eDeath = EffectDeath(FALSE, FALSE);
								DelayCommand(0.25, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
								DelayCommand(0.25, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
							}
						}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	
	HkPostCast(oCaster);
}

