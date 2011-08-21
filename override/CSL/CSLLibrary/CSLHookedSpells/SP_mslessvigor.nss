//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_lsrVigor.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Vigor
	Conjuration (Healing)
	Level: Cleric 3, druid 3
	Components: V, S
	Range: Touch
	Target: Living creature touched
	Duration: 10 rounds + 1 round/level (max 25 rounds)
	
	Target gains fast healing 1 for 10 rounds + 1
	round/level (max 15).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//scSpellMetaData = SCMeta_SP_mslessvigor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_LESSER_VIGOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = CSLGetMin(15, HkGetSpellPower(oCaster));
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_MASS_LESSER_VIGOR);
	eLink = EffectLinkEffects(eLink, EffectRegenerate(1, 6.0));
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( 10+ HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lLocation = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			CSLUnstackSpellEffects(oTarget, GetSpellId());
			CSLUnstackSpellEffects(oTarget, SPELL_LESSER_VIGOR, "Lesser Vigor");
			CSLUnstackSpellEffects(oTarget, SPELL_MASS_LESSER_VIGOR, "Mass Lesser Vigor");
			if (!CSLCheckNonStackingSpell(oTarget, SPELL_VIGOROUS_CYCLE, "Vigorous Cycle")) {
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
				CSLRemovePermanencySpells(oTarget);
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}   

