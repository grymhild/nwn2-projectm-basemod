//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/10/2009								//
//	Title: TB_st_steel_wind						//
//	Description: Allows the player to make an	//
//	attack against two targets he threatens.	//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_fx"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 92);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBStrikeTrailEffect(oWeapon, nHit, 2.0f);
	CSLPlayCustomAnimation_Void(oPC, "*whirlwind", 0);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(92, "STR");

	location lPC = GetLocation(oPC);
	float fRange = CSLGetMeleeRange(oPC);
	object oTarget2;

	oTarget2 = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oTarget2))
	{
		if ((oTarget != oTarget2) && (GetIsReactionTypeHostile(oTarget2, oPC)))
		{
			break;
		}
		else oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}

	float fDistance = GetDistanceBetween(oPC, oTarget2);

	if (GetDistanceBetween(oPC, oTarget2) > fRange)
	{
		oTarget2 = OBJECT_INVALID;
	}

	if (GetIsObjectValid(oTarget2))
	{
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oTarget2);

		CSLStrikeAttackSound(oWeapon, oTarget2, nHit2, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit2, oTarget2));
	}
}
