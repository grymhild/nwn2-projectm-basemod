//::///////////////////////////////////////////////
//:: Divine Protection
//:: NW_S2_DivProt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Makes the target creature invisible to hostile
	creatures unless they make a Will Save to ignore
	the Sanctuary Effect
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	int iDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + GetLevelByClass(CLASS_TYPE_CLERIC);
	effect eSanc = EffectSanctuary(iDC);
	
	effect eLink = EffectLinkEffects(eVis, eSanc);
	//eLink = EffectLinkEffects(eLink, eDur);
	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_PROTECTION, FALSE));

	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	//Enter Metamagic conditions
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
}