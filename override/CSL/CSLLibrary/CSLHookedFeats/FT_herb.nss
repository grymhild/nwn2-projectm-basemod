//::///////////////////////////////////////////////
//:: NW_S3_HERB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Various herbs to offer bonuses to the player using
	them.
	Belladonna:
	Garlic:
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	int nID = GetSpellId();
	// * Belladonna
	if (nID == 409)
	{
		object oTarget = HkGetSpellTarget();
		effect eVisual = EffectVisualEffect(VFX_IMP_AC_BONUS);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisual, oTarget);
		effect eACBonus = VersusRacialTypeEffect(EffectACIncrease(5), RACIAL_TYPE_SHAPECHANGER);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACBonus, oTarget, 60.0);

	}
	else
	// * Garlic; protection against Vampires
	// * Lowers charisma
	if (nID == 410)
	{
		object oTarget = HkGetSpellTarget();
		effect eAttackBonus = VersusRacialTypeEffect(EffectAttackIncrease(2), RACIAL_TYPE_UNDEAD);
		effect eCharisma = EffectAbilityDecrease(ABILITY_CHARISMA, 1);
		effect eVisual = EffectVisualEffect(VFX_IMP_AC_BONUS);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisual, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttackBonus, oTarget, 60.0);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharisma, oTarget, 60.0);

	}

}