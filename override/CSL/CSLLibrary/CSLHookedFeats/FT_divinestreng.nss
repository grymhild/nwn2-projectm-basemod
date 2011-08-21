//::///////////////////////////////////////////////
//:: Divine Strength
//:: NW_S2_DivStr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cleric gains +2 to strength +1 for every 3 levels
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 4, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eStr;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	int iCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
	int nModify = (iCasterLevel/3) + 2;
	int iDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA);
	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_STRENGTH, FALSE));

	//Apply effects and VFX to target
	eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
	effect eLink = EffectLinkEffects(eStr, eDur);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}