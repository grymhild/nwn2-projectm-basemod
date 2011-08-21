//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/15/2009								//
//	Title: TB_ct_rapid_counter						//
//	Description: This maneuver allows you to 	//
// make a free attack against a reckless enemy.//
// When a foe provokes an attack of opportunity//
// from you, you initiate this maneuver. As 	//
// part of this maneuver, you make an immediate//
// melee attack against the foe that provoked //
// the attack of opportunity. This attack does //
// not replace the normal attack of opportunity//
// you receive.								//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void RCAttack(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	FloatingTextStringOnCreature("<color=cyan>*Rapid Counter!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void RapidCounter(object oPC, object oToB)
{
	if (hkCounterGetHasActive(oPC,70))
	{
		object oTarget = GetLastDamager(oPC);
		location lOld = GetLocalLocation(oPC, "RapidCounter_loc");
		location lTarget = GetLocation(oTarget);
		float fDist = GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget);
		float fRange = CSLGetMeleeRange(oTarget);
		float fOld = GetDistanceBetweenLocations(lTarget, lOld);
		int nProvoke;

		nProvoke = 0;

		if ((fOld <= fRange) && (fDist > fRange))
		{
			nProvoke = 1;
		}
		else if ((GetCurrentAction(oPC) == ACTION_CASTSPELL) && (fDist <= fRange) && (GetLocalInt(oPC, "bot9s_maneuver_running") < 1))
		{
			nProvoke = 1;
		}
		else if ((GetCurrentAction(oPC) == ACTION_TAUNT) && (fDist <= fRange))
		{
			nProvoke = 1;
		}

		if (nProvoke == 1)
		{
			RCAttack(oTarget);
			TOBRunSwiftAction(70, "C");
		}
		else DelayCommand(1.0f, RapidCounter(oPC, oToB));
	}
	else
	{
		DeleteLocalLocation(oPC, "RapidCounter_loc");
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
	
	location lPC = GetLocation(oPC);

	TOBExpendManeuver(70, "C");
	SetLocalLocation(oPC, "RapidCounter_loc", lPC);
	RapidCounter(oPC, oToB);
}
