//::///////////////////////////////////////////////
//:: Wholeness of Body
//:: NW_S2_Wholeness
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The monk is able to heal twice his level in HP
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes =84100;
	//Declare major variables
	int iLevel = GetLevelByClass(CLASS_TYPE_MONK, OBJECT_SELF) * 2;
	effect eHeal = EffectHeal(iLevel);
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WHOLENESS_OF_BODY, FALSE));
	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
}