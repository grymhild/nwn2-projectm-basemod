//::///////////////////////////////////////////////
//:: Greater Endurance
//:: NW_S0_GrCatGr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Raises targets Con by 8
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/07/05 NWN2 3.5)

#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_FT_grtbearsendu();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_BEARS_ENDURANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eRaise;
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BEAR_ENDURANCE );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	
	int nRaise = 8;
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_BEARS_ENDURANCE, FALSE));

	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	CSLUnstackSpellEffects(oTarget, iSpellId);
	CSLUnstackSpellEffects(oTarget, SPELL_BEARS_ENDURANCE, "Bear's Endurance");
	CSLUnstackSpellEffects(oTarget, SPELL_MASS_BEAR_ENDURANCE, "Mass Bear's Endurance");
	
	//Set Adjust Ability Score effect
	eRaise = EffectAbilityIncrease(ABILITY_CONSTITUTION, nRaise);
	effect eLink = EffectLinkEffects(eRaise, eVis);
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX

	CSLConstitutionBugCheck( oTarget );	
	
	HkPostCast(oCaster);
}