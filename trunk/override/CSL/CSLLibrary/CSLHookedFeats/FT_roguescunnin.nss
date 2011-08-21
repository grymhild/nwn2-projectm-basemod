//::///////////////////////////////////////////////
//:: Rogues Cunning AKA Potion of Extra Theiving
//:: NW_S0_ExtraThf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the user +10 Search, Disable Traps and
	Move Silently, Open Lock (+5), Pick Pockets
	Set Trap for 5 Turns
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_roguescunnin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	object oTarget = HkGetSpellTarget();
	//Declare major variables
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 10);
	effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, 10);
	effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 10);
	effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, 5);
	effect ePick = EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND, 10);
	effect eTrap = EffectSkillIncrease(SKILL_SET_TRAP, 10);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	//Link Effects
	effect eLink = EffectLinkEffects(eSearch, eDisable);
	eLink = EffectLinkEffects(eLink, eMove);
	eLink = EffectLinkEffects(eLink, eOpen);
	eLink = EffectLinkEffects(eLink, ePick);
	eLink = EffectLinkEffects(eLink, eTrap);
	eLink = EffectLinkEffects(eLink, eHide);
	eLink = EffectLinkEffects(eLink, eDur);

	effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(5));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}