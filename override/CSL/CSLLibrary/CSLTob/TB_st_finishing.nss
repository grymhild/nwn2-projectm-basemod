///////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/17/2009								//
//	Title: TB_st_finishing									//
//	Description: As part of this maneuver, you make a//
// melee attack against a creature. This attack 	//
// deals an extra 4d6 points of damage. If the 	//
// target’s current hit points are less than its 	//
// full normal hit points, the attack instead deals //
// an extra 6d6 points of damage. If its hit points //
// are equal to or less than one-half its full 	//
// normal hit points, the attack instead deals an 	//
// extra 14d6 points of damage.					//
///////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 82);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);
	int nMax = GetMaxHitPoints(oTarget);
	int nHalf = nMax / 2;
	int nHp = GetCurrentHitPoints(oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(82, "STR");

	if (nHp <= nHalf)
	{
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(14)));
	}
	else if (nHp < nMax)
	{
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	}
	else DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(4)));
}
