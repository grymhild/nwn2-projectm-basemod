//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/14/2009												//
//	Title: TB_st_daunting											//
//	Description: As part of this maneuver, you make a melee 	//
// attack against an opponent you threaten. If this attack 	//
// hits, your foe must make a Will save with a DC equal to the //
// damage you deal or become shaken for 1 minute.				//
//////////////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_fx"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "tob_i0_spells"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

effect EffectShaken()
{
	effect eShaken;
	effect eAttack = EffectAttackDecrease(2);
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	eShaken = EffectLinkEffects(eAttack, eSaves);
	eShaken = EffectLinkEffects(eShaken, eSkill);
	eShaken = ExtraordinaryEffect(eShaken);

	return eShaken;
}

void DauntingStrike(object oTarget)
{
	object oPC = OBJECT_SELF;
	int nDC = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nWill = HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC);

	if (nWill == 0)
	{
		effect eDaunting = EffectShaken();

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaunting, oTarget, 6.0f);
	}
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 34);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oPC, "bot9s_StrikeTotal", 0);
	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(5.0f, SetLocalInt(oPC, "bot9s_StrikeTotal", 0));
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	CSLPlayCustomAnimation_Void(oPC, "*powerattack", 0);
	TOBStrikeTrailEffect(oWeapon, nHit, 1.0f);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(34, "STR");

	if (nHit > 0)
	{	// Delayed so that the old damage total can be cleared properly before the new total.
		DelayCommand(0.4f, DauntingStrike(oTarget));
	}
}
