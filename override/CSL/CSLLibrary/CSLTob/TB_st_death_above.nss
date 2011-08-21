//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/11/2009								//
//	Title: TB_st_death_above						//
//	Description: As part of this maneuver, you //
// attempt a DC 20 Jump check. If this check 	//
// succeeds, you can make a single melee attack//
// against an opponent that you were adjacent //
// to when you began this maneuver. This attack//
// occurs in the air as you soar over your 	//
// opponent, also as part of the maneuver. Your//
// attack deals an extra 4d6 points of damage, //
// and your opponent is considered flat-footed //
// against this attack. You then land behind 	//
// your target. If your Jump check fails, you //
// remain in the last square you occupied 	//
// before the Jump check and can make a single //
// attack normally. The maneuver is still		//
// considered expended.						//
//////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "tob_x0_i0_position"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DeathFromAbove(object oWeapon, object oTarget)
{
	object oPC = OBJECT_SELF;
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);
	float fSpace = GetDistanceBetween(oPC, oTarget);
	float fDist = CSLGetGirth(oTarget) + fSpace + 0.01f;
	location lTest = CSLGetOppositeLocation(oPC, fDist);
	location lLand;

	if (GetIsLocationValid(lTest))
	{
		lLand = lTest;
	}
	else lLand = CalcSafeLocation(oPC, lTest, FeetToMeters(5.0f), TRUE, FALSE);

	if (GetIsLocationValid(lLand))
	{
		DelayCommand(1.01f, JumpToLocation(lLand));
	}

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 1.43f);
	CSLPlayCustomAnimation_Void(oPC, "leapup", 0);
	DelayCommand(1.02f, CSLPlayCustomAnimation_Void(oPC, "*leapattack", 0));
	DelayCommand(1.53f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(4)));

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		DelayCommand(1.53f, TOBTigerBlooded(oPC, oWeapon, oTarget));
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
	
	object oTarget = TOBGetManeuverObject(oToB, 168);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nd20 = d20(1);
	int nJump = CSLGetJumpSkill();
	int nRoll = nd20 + nJump;
	int nDC = 20;

	SendMessageToPC(oPC, "<color=chocolate>" + GetName(oPC) + ": Taunt: (" + IntToString(nd20) + " + " + IntToString(nJump) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + "</color>");
	TOBExpendManeuver(168, "STR");

	if (nRoll >= nDC)
	{
		CSLOverrideAttackRollAC(oTarget, 2);
		DelayCommand(0.2f, TOBRemoveAttackRollOverride(oPC, 1));
		DelayCommand(0.1f, DeathFromAbove(oWeapon, oTarget));
	}
	else
	{
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		TOBBasicAttackAnimation(oWeapon, nHit);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

		if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
		{
			DelayCommand(0.3f, TOBTigerBlooded(oPC, oWeapon, oTarget));
		}
	}
}