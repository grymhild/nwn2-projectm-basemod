//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:://////////////////////////////////////////////
/*
	Casts "Cause Fear" on multiple critters
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_scare();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SCARE;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_CAUSE_FEAR)
	{
		iSpellId = SPELL_CAUSE_FEAR;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR|SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = (iSpellId==SPELL_CAUSE_FEAR) ? 4 : CSLGetMin(10, HkGetSpellPower(oCaster));
	
	object oTarget = HkGetSpellTarget();
	object oOrigTgt = oTarget;
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(iCasterLevel));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	effect eScary = CSLGetFearEffect();
	// First, do the one we explicitly targeted, if any:
	if (GetIsObjectValid(oTarget))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
				if (!HkResistSpell(oCaster, oTarget))
				{
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
					{
						HkApplyEffectToObject(iDurType, eScary, oTarget, fDuration);
					}
				}
			}
		}
	}

	if (iSpellId==SPELL_CAUSE_FEAR) return; // SHARING THIS SCRIPT WITH CAUSE FEAR WHICH DOESN'T DO ADDITIONAL TARGETS SO EXIT NOW

	int nNumTargets = (iCasterLevel / 3);
	location lTarget = HkGetSpellTargetLocation();
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE); // | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget) && (nNumTargets > 0)) {
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && (oOrigTgt != oTarget)) {
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
				nNumTargets--;
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
				if(!HkResistSpell(oCaster, oTarget)) {
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FEAR)) {
						HkApplyEffectToObject(iDurType, eScary, oTarget, fDuration);
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE); // | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	HkPostCast(oCaster);
}

