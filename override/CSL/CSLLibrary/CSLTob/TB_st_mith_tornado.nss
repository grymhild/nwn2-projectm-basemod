//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/10/2009								//
//	Title: TB_st_mith_tornado						//
//	Description: Allows the player to make an	//
//	attack against two targets he threatens.	//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_fx"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GenerateFoes(object oPC, object oToB, object oTarget)
{
	float fRange = CSLGetMeleeRange(oPC);
	location lPC = GetLocation(oPC);

	int n;
	object oFoe;

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (oTarget != oFoe) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			if (GetObjectSeen(oFoe, oPC) || GetObjectHeard(oFoe, oPC))
			{
				SetLocalObject(oToB, "MithralTornadoFoe" + IntToString(n), oFoe);
				n++;

				if (n > 10)//Only so many that I can manually keep track of.
				{
					break;
				}
			}
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
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
	
	object oTarget = TOBGetManeuverObject(oToB, 89);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2);

	GenerateFoes(oPC, oToB, oTarget);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBStrikeTrailEffect(oWeapon, nHit, 2.0f);
	CSLPlayCustomAnimation_Void(oPC, "*whirlwind", 0);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(89, "STR");

	object oFoe1 = GetLocalObject(oToB, "MithralTornadoFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		int nHit1 = TOBStrikeAttackRoll(oWeapon, oFoe1, 2);

		CSLStrikeAttackSound(oWeapon, oFoe1, nHit1, 0.3f);
		DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit1, oFoe1));
	}

	object oFoe2 = GetLocalObject(oToB, "MithralTornadoFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe2, 2);

		CSLStrikeAttackSound(oWeapon, oFoe2, nHit2, 0.4f);
		DelayCommand(0.5f, TOBStrikeWeaponDamage(oWeapon, nHit2, oFoe2));
	}

	object oFoe3 = GetLocalObject(oToB, "MithralTornadoFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe3, 2);

		CSLStrikeAttackSound(oWeapon, oFoe3, nHit3, 0.5f);
		DelayCommand(0.6f, TOBStrikeWeaponDamage(oWeapon, nHit3, oFoe3));
	}

	object oFoe4 = GetLocalObject(oToB, "MithralTornadoFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		int nHit4 = TOBStrikeAttackRoll(oWeapon, oFoe4, 2);

		CSLStrikeAttackSound(oWeapon, oFoe4, nHit4, 0.6f);
		DelayCommand(0.7f, TOBStrikeWeaponDamage(oWeapon, nHit4, oFoe4));
	}

	object oFoe5 = GetLocalObject(oToB, "MithralTornadoFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		int nHit5 = TOBStrikeAttackRoll(oWeapon, oFoe5, 2);

		CSLStrikeAttackSound(oWeapon, oFoe5, nHit5, 0.7f);
		DelayCommand(0.8f, TOBStrikeWeaponDamage(oWeapon, nHit5, oFoe5));
	}

	object oFoe6 = GetLocalObject(oToB, "MithralTornadoFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		int nHit6 = TOBStrikeAttackRoll(oWeapon, oFoe6, 2);

		CSLStrikeAttackSound(oWeapon, oFoe6, nHit6, 0.8f);
		DelayCommand(0.9f, TOBStrikeWeaponDamage(oWeapon, nHit6, oFoe6));
	}

	object oFoe7 = GetLocalObject(oToB, "MithralTornadoFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		int nHit7 = TOBStrikeAttackRoll(oWeapon, oFoe7, 2);

		CSLStrikeAttackSound(oWeapon, oFoe7, nHit7, 0.9f);
		DelayCommand(1.0f, TOBStrikeWeaponDamage(oWeapon, nHit7, oFoe7));
	}

	object oFoe8 = GetLocalObject(oToB, "MithralTornadoFoe7");

	if (GetIsObjectValid(oFoe8))
	{
		int nHit8 = TOBStrikeAttackRoll(oWeapon, oFoe8, 2);

		CSLStrikeAttackSound(oWeapon, oFoe8, nHit8, 1.0f);
		DelayCommand(1.1f, TOBStrikeWeaponDamage(oWeapon, nHit8, oFoe8));
	}

	object oFoe9 = GetLocalObject(oToB, "MithralTornadoFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		int nHit9 = TOBStrikeAttackRoll(oWeapon, oFoe9, 2);

		CSLStrikeAttackSound(oWeapon, oFoe9, nHit9, 1.1f);
		DelayCommand(1.2f, TOBStrikeWeaponDamage(oWeapon, nHit9, oFoe9));
	}

	object oFoe10 = GetLocalObject(oToB, "MithralTornadoFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		int nHit10 = TOBStrikeAttackRoll(oWeapon, oFoe10, 2);

		CSLStrikeAttackSound(oWeapon, oFoe10, nHit10, 1.2f);
		DelayCommand(1.3f, TOBStrikeWeaponDamage(oWeapon, nHit10, oFoe10));
	}

	DeleteLocalObject(oToB, "MithralTornadoFoe1");
	DeleteLocalObject(oToB, "MithralTornadoFoe2");
	DeleteLocalObject(oToB, "MithralTornadoFoe3");
	DeleteLocalObject(oToB, "MithralTornadoFoe4");
	DeleteLocalObject(oToB, "MithralTornadoFoe5");
	DeleteLocalObject(oToB, "MithralTornadoFoe6");
	DeleteLocalObject(oToB, "MithralTornadoFoe7");
	DeleteLocalObject(oToB, "MithralTornadoFoe8");
	DeleteLocalObject(oToB, "MithralTornadoFoe9");
	DeleteLocalObject(oToB, "MithralTornadoFoe10");
}
