//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/27/2009							//
//	Title: TB_st_dn_blade							//
//	Description: You attempt a Concentration	//
// check as part of this maneuver, using the 	//
// target creature's AC as the DC of the check.//
// You then make a single melee attack against //
// your target. This attack is also made as 	//
// part of this maneuver. If your Concentration//
// check succeeds, this melee attack deals 	//
// four times the normal melee damage. If your //
// check fails, your attack is made with a -2 //
// penalty and deals only normal melee damage. //
// If your strike is a critical hit, you stack //
// the multipliers as normal.					//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DiamondNightmareBlade(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit, FALSE, FALSE);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, 0, FALSE, FALSE, 4));
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
	
	object oTarget = TOBGetManeuverObject(oToB, 58);

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

	SendMessageToPC(oPC, "<color=chocolate>Diamond Nightmare Blade: Concentration : " + "(" + IntToString(nRanks) + " + " + IntToString(nD20) + " = " + IntToString(nConcentration) + ") vs. " + GetName(oTarget) + "'s AC : (" + IntToString(nFoeAC) + ").</color>");

	if (nConcentration >= nFoeAC)
	{
		effect eDNB = EffectVisualEffect(VFX_TOB_DNBLADE);

		DelayCommand(1.0f, DiamondNightmareBlade(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDNB, oPC, 6.0f);
		TOBExpendManeuver(58, "STR");
	}
	else
	{
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, -2);

		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		TOBBasicAttackAnimation(oWeapon, nHit);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
		TOBExpendManeuver(58, "STR");
	}
}
