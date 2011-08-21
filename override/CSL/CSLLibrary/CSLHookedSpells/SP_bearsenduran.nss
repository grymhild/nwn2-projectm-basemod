//::///////////////////////////////////////////////
//:: [Bear's Endurance]
//:: [NW_S0_BearEndur.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Gives the target 4 Constitution.
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_AbilityBuff"




void main()
{
	//scSpellMetaData = SCMeta_SP_bearsenduran();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BEARS_ENDURANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	object oTarget = HkGetSpellTarget();

	if (CSLCheckNonStackingSpell(oTarget, SPELL_GREATER_BEARS_ENDURANCE, "Greater Bear's Endurance")) {return;}
	if (CSLCheckNonStackingSpell(oTarget, SPELL_Chasing_Perfection, "Chasing Perfection")) return;
	
	CSLUnstackSpellEffects(oTarget, SPELL_BEARS_ENDURANCE);
	CSLUnstackSpellEffects(oTarget, SPELL_MASS_BEAR_ENDURANCE, "Mass Bear's Endurance");

	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	int iStatModifier = 4;
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BEARS_ENDURANCE, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HoursToSeconds(24);
	
	SCStatBuff( oTarget, ABILITY_CONSTITUTION, iStatModifier, fDuration, iDurType );

	CSLConstitutionBugCheck( oTarget );
	
	/*
	object oCaster = OBJECT_SELF;
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	if (CSLCheckNonStackingSpell(oTarget, SPELL_GREATER_BEARS_ENDURANCE, "Greater Bear's Endurance")) return;
	CSLUnstackSpellEffects(oTarget, GetSpellId());
	CSLUnstackSpellEffects(oTarget, SPELL_MASS_BEAR_ENDURANCE, "Mass Bear's Endurance");
	int nModify = 4;
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BEARS_ENDURANCE, FALSE));
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration( oCaster )));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BEAR_ENDURANCE);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, nModify));
	// BABA YAGA DURATION EDIT
	if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HoursToSeconds(24);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	*/
	
	
	HkPostCast(oCaster);
}

