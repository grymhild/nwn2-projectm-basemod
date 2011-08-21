//::///////////////////////////////////////////////
//:: Divine Trickery
//:: NW_S2_DivTrick.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the user a bonus to Search, Disable Traps,
	Move Silently, Open Lock , Pick Pockets
	Set Trap for 5 Turns + Chr Mod
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	object oTarget = HkGetSpellTarget();
	int iDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA);
	int iLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
	iLevel = 1 + iLevel/2;

	//Declare major variables
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, iLevel);
	effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, iLevel);
	effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, iLevel);
	effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, iLevel);
	effect ePick = EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND, iLevel);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, iLevel);
	effect ePers = EffectSkillIncrease(SKILL_DIPLOMACY, iLevel);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	//Link Effects
	effect eLink = EffectLinkEffects(eSearch, eDisable);
	eLink = EffectLinkEffects(eLink, eMove);
	eLink = EffectLinkEffects(eLink, eOpen);
	eLink = EffectLinkEffects(eLink, ePick);
	eLink = EffectLinkEffects(eLink, eHide);
	eLink = EffectLinkEffects(eLink, ePers);
	eLink = EffectLinkEffects(eLink, eDur);

	effect eVis = EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE );
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_TRICKERY, FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}