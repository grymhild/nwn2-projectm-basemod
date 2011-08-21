//::///////////////////////////////////////////////
//:: Divine Wrath
//:: x2_s2_DivWrath
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The Divine Champion is able to channel a portion
	of their gods power once per day giving them a +3
	bonus on attack rolls, damage, and saving throws
	for a number of rounds equal to their Charisma
	bonus. They also gain damage reduction of +1/5.
	At 10th level, an additional +2 is granted to
	attack rolls and saving throws.

	Epic Progression
	Every five levels past 10 an additional +2
	on attack rolls, damage and saving throws is added. As well the damage
	reduction increases by 5 and the damage power required to penetrate
	damage reduction raises by +1 (to a maximum of /+5).

	3.5 Rules (NWN2):
	Once per day, a 5th-level divine champion can channel
	a portion of her patron deity's power to greatly enhance
	her own battle prowess.  She gains damage reduction 5/- and
	a +3 bonus on attack rolls, damage, and saving htorws for a
	number of rounds equal to her Charisma modifier (minimum 1
	round).
*/

#include "_HkSpell"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;

	object oTarget = OBJECT_SELF;
	float fDuration = RoundsToSeconds(CSLGetMax(0, GetAbilityModifier(ABILITY_CHARISMA, oTarget)));

	SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELLABILITY_DC_DIVINE_WRATH, FALSE));

	int iLevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oTarget) ;
	iLevel = CSLGetMax(0, iLevel/5 - 1);
	int nAttack = 3 + iLevel * 2; // +2 to attack every 5 levels past 5
	int iSave = 3 + iLevel * 2; // +2 to saves every 5 levels past 5
	int nDmgRed = CSLGetMax(5, CSLGetMin(7, iLevel) * 5);
	int iDamage = DAMAGE_BONUS_3;
	if      (iLevel>6) iDamage = DAMAGE_BONUS_17;
	else if (iLevel>5) iDamage = DAMAGE_BONUS_15;
	else if (iLevel>4) iDamage = DAMAGE_BONUS_13;
	else if (iLevel>3) iDamage = DAMAGE_BONUS_11;
	else if (iLevel>2) iDamage = DAMAGE_BONUS_9;
	else if (iLevel>1) iDamage = DAMAGE_BONUS_7;
	else if (iLevel>0) iDamage = DAMAGE_BONUS_5;

	effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAttack, ATTACK_BONUS_MISC));
	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(iDamage, DAMAGE_TYPE_DIVINE  ));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL,iSave, SAVING_THROW_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(nDmgRed, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_NONE));
	eLink = SupernaturalEffect(eLink);

	//CSLUnstackSpellEffects(oTarget, GetSpellId());

	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_HOLY), oTarget);
}