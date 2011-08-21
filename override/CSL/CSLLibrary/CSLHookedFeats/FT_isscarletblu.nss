//::///////////////////////////////////////////////
//:: Name x2_sp_is_sblue
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Ioun Stone Power: Scarlet Blue
	Gives the user 1 hours worth of +2 Intelligence bonus.
	Cancels any other Ioun stone powers in effect
	on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//variables
	effect eVFX, eBonus, eLink, eEffect;

	//from any other ioun stones
	eEffect = GetFirstEffect(OBJECT_SELF);
	while (GetIsEffectValid(eEffect) == TRUE)
	{
			if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561)
			{
				RemoveEffect(OBJECT_SELF, eEffect);
			}
			eEffect = GetNextEffect(OBJECT_SELF);
	}

	//Apply new ioun stone effect
	eVFX = EffectVisualEffect(500);
	eBonus = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
	eLink = EffectLinkEffects(eVFX, eBonus);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 3600.0);

}