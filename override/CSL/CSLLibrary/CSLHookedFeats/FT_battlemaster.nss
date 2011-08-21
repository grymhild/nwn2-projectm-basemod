//::///////////////////////////////////////////////
//:: Battle Mastery
//:: NW_S2_BatMast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	1st to 5th Level
		+1 Hit, Con, Dex, Damage
		Damage Reduction of 2/+5
	6th to 10th Level
		+2 Hit, Con, Dex, Damage
		Damage Reduction of 4/+5
	11th to 15th Level
		+3 Hit, Con, Dex, Damage
		Damage Reduction of 6/+5
	16 and up
		+4 Hit, Con, Dex, Damage
		Damage Reduction of 8/+5
*/

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;

	//Determine bonus amount

	object oCaster = OBJECT_SELF;
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	int iBonus = CSLGetMin(5, 1 + (iSpellPower-1) / 5);

	// Have to seperate damage due to epic levels.
	int nDamBonus = iBonus;
	if (nDamBonus > 5) nDamBonus += 10;

	//Link effects
	effect eLink = EffectAttackIncrease(iBonus);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, iBonus));
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, iBonus));
	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nDamBonus, DAMAGE_TYPE_BLUDGEONING ));
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(iBonus * 2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	//Fire cast spell at event for the specified target
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABILITY_BATTLE_MASTERY, FALSE));

	//Determined duration
	int iDuration = GetAbilityModifier(ABILITY_CHARISMA) + 5;
	//Apply effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_HOLY), oCaster);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

}