//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/12/2009								//
//	Title: TB_st_sn_blade							//
//	Description: You attempt a Concentration 	//
//	check as part of this maneuver, using the 	//
//	target creature’s AC as the DC of the check.//
//	You then make a single melee attack against //
//	your target. The attack is also part of this//
//	maneuver. If your Concentration check		//
//	succeeds, the target is flat-footed against	//
//	your attack, and you deal an extra 1d6		//
//	points of damage. If your check fails, your //
//	attack is made with a –2 penalty and deals //
//	normal damage.								//
//////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void SapphireNightmareBlade(object oTarget, object oWeapon)
{
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit, FALSE, FALSE);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(1)));
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
	
	object oTarget = TOBGetManeuverObject(oToB, 72);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRanks = GetSkillRank(SKILL_CONCENTRATION);
	int nFoeAC = GetAC(oTarget);
	int nD20 = d20(1);
	int nConcentration = nD20 + nRanks;

	SendMessageToPC(oPC, "<color=chocolate>Sapphire Nightmare Blade: Concentration : " + "(" + IntToString(nRanks) + " + " + IntToString(nD20) + " = " + IntToString(nConcentration) + ") vs. " + GetName(oTarget) + "'s AC : (" + IntToString(nFoeAC) + ").</color>");

	if (nConcentration >= nFoeAC)
	{
		CSLOverrideAttackRollAC(oTarget, 2);
		DelayCommand(1.5f, TOBRemoveAttackRollOverride(oTarget, 1));

		effect eSNB = EffectVisualEffect(VFX_TOB_SNBLADE);

		DelayCommand(1.0f, SapphireNightmareBlade(oTarget, oWeapon));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSNB, oPC, 6.0f);
		TOBExpendManeuver(72, "STR");
	}
	else
	{
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, -2);

		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		TOBBasicAttackAnimation(oWeapon, nHit);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
		TOBExpendManeuver(72, "STR");
	}
}