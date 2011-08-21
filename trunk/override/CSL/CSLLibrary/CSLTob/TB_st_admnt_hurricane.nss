//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/27/2009							//
//	Title: TB_st_admnt_hurricane					//
//	Description: You make two melee attacks 	//
// against each adjacent opponent you threaten //
// when you initiate this maneuver. You receive//
// a +4 bonus on each of these attacks, which //
// are otherwise made with your highest attack //
// bonus. 								//
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
				SetLocalObject(oToB, "AdamantineHurricaneFoe" + IntToString(n), oFoe);
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
	
	object oTarget = TOBGetManeuverObject(oToB, 77);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 4);
	int nHit0 = TOBStrikeAttackRoll(oWeapon, oTarget, 4);

	GenerateFoes(oPC, oToB, oTarget);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit0, 0.2f);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 1.2f);
	TOBStrikeTrailEffect(oWeapon, nHit, 2.0f);
	CSLPlayCustomAnimation_Void(oPC, "*whirlwind", 0);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	DelayCommand(1.3f, TOBStrikeWeaponDamage(oWeapon, nHit0, oTarget));
	TOBExpendManeuver(77, "STR");

	object oFoe1 = GetLocalObject(oToB, "AdamantineHurricaneFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		int nHit1 = TOBStrikeAttackRoll(oWeapon, oFoe1, 4);
		int nHit11 = TOBStrikeAttackRoll(oWeapon, oFoe1, 4);

		CSLStrikeAttackSound(oWeapon, oFoe1, nHit1, 0.3f);
		CSLStrikeAttackSound(oWeapon, oFoe1, nHit11, 1.3f);
		DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit1, oFoe1));
		DelayCommand(1.4f, TOBStrikeWeaponDamage(oWeapon, nHit11, oFoe1));
	}

	object oFoe2 = GetLocalObject(oToB, "AdamantineHurricaneFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe2, 4);
		int nHit12 = TOBStrikeAttackRoll(oWeapon, oFoe2, 4);

		CSLStrikeAttackSound(oWeapon, oFoe2, nHit2, 0.4f);
		CSLStrikeAttackSound(oWeapon, oFoe2, nHit12, 1.4f);
		DelayCommand(0.5f, TOBStrikeWeaponDamage(oWeapon, nHit2, oFoe2));
		DelayCommand(1.5f, TOBStrikeWeaponDamage(oWeapon, nHit12, oFoe2));
	}

	object oFoe3 = GetLocalObject(oToB, "AdamantineHurricaneFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe3, 4);
		int nHit13 = TOBStrikeAttackRoll(oWeapon, oFoe3, 4);

		CSLStrikeAttackSound(oWeapon, oFoe3, nHit3, 0.5f);
		CSLStrikeAttackSound(oWeapon, oFoe3, nHit13, 1.5f);
		DelayCommand(0.6f, TOBStrikeWeaponDamage(oWeapon, nHit3, oFoe3));
		DelayCommand(1.6f, TOBStrikeWeaponDamage(oWeapon, nHit13, oFoe3));
	}

	object oFoe4 = GetLocalObject(oToB, "AdamantineHurricaneFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		int nHit4 = TOBStrikeAttackRoll(oWeapon, oFoe4, 4);
		int nHit14 = TOBStrikeAttackRoll(oWeapon, oFoe4, 4);

		CSLStrikeAttackSound(oWeapon, oFoe4, nHit14, 1.6f);
		CSLStrikeAttackSound(oWeapon, oFoe4, nHit4, 0.6f);
		DelayCommand(1.7f, TOBStrikeWeaponDamage(oWeapon, nHit14, oFoe4));
		DelayCommand(0.7f, TOBStrikeWeaponDamage(oWeapon, nHit4, oFoe4));
	}

	object oFoe5 = GetLocalObject(oToB, "AdamantineHurricaneFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		int nHit5 = TOBStrikeAttackRoll(oWeapon, oFoe5, 4);
		int nHit15 = TOBStrikeAttackRoll(oWeapon, oFoe5, 4);

		CSLStrikeAttackSound(oWeapon, oFoe5, nHit15, 1.7f);
		CSLStrikeAttackSound(oWeapon, oFoe5, nHit5, 0.7f);
		DelayCommand(1.8f, TOBStrikeWeaponDamage(oWeapon, nHit15, oFoe5));
		DelayCommand(0.8f, TOBStrikeWeaponDamage(oWeapon, nHit5, oFoe5));
	}

	object oFoe6 = GetLocalObject(oToB, "AdamantineHurricaneFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		int nHit6 = TOBStrikeAttackRoll(oWeapon, oFoe6, 4);
		int nHit16 = TOBStrikeAttackRoll(oWeapon, oFoe6, 4);

		CSLStrikeAttackSound(oWeapon, oFoe6, nHit6, 0.8f);
		CSLStrikeAttackSound(oWeapon, oFoe6, nHit16, 1.8f);
		DelayCommand(1.9f, TOBStrikeWeaponDamage(oWeapon, nHit16, oFoe6));
		DelayCommand(0.9f, TOBStrikeWeaponDamage(oWeapon, nHit6, oFoe6));
	}

	object oFoe7 = GetLocalObject(oToB, "AdamantineHurricaneFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		int nHit7 = TOBStrikeAttackRoll(oWeapon, oFoe7, 4);
		int nHit17 = TOBStrikeAttackRoll(oWeapon, oFoe7, 4);

		CSLStrikeAttackSound(oWeapon, oFoe7, nHit7, 0.9f);
		CSLStrikeAttackSound(oWeapon, oFoe7, nHit17, 1.9f);
		DelayCommand(1.0f, TOBStrikeWeaponDamage(oWeapon, nHit7, oFoe7));
		DelayCommand(2.0f, TOBStrikeWeaponDamage(oWeapon, nHit17, oFoe7));
	}

	object oFoe8 = GetLocalObject(oToB, "AdamantineHurricaneFoe7");

	if (GetIsObjectValid(oFoe8))
	{
		int nHit8 = TOBStrikeAttackRoll(oWeapon, oFoe8, 4);
		int nHit18 = TOBStrikeAttackRoll(oWeapon, oFoe8, 4);

		CSLStrikeAttackSound(oWeapon, oFoe8, nHit8, 1.0f);
		CSLStrikeAttackSound(oWeapon, oFoe8, nHit18, 2.0f);
		DelayCommand(1.1f, TOBStrikeWeaponDamage(oWeapon, nHit8, oFoe8));
		DelayCommand(2.1f, TOBStrikeWeaponDamage(oWeapon, nHit18, oFoe8));
	}

	object oFoe9 = GetLocalObject(oToB, "AdamantineHurricaneFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		int nHit9 = TOBStrikeAttackRoll(oWeapon, oFoe9, 4);
		int nHit19 = TOBStrikeAttackRoll(oWeapon, oFoe9, 4);

		CSLStrikeAttackSound(oWeapon, oFoe9, nHit9, 1.1f);
		CSLStrikeAttackSound(oWeapon, oFoe9, nHit19, 2.1f);
		DelayCommand(1.2f, TOBStrikeWeaponDamage(oWeapon, nHit9, oFoe9));
		DelayCommand(2.2f, TOBStrikeWeaponDamage(oWeapon, nHit19, oFoe9));
	}

	object oFoe10 = GetLocalObject(oToB, "AdamantineHurricaneFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		int nHit10 = TOBStrikeAttackRoll(oWeapon, oFoe10, 4);
		int nHit20 = TOBStrikeAttackRoll(oWeapon, oFoe10, 4);

		CSLStrikeAttackSound(oWeapon, oFoe10, nHit10, 1.2f);
		CSLStrikeAttackSound(oWeapon, oFoe10, nHit20, 2.2f);
		DelayCommand(1.3f, TOBStrikeWeaponDamage(oWeapon, nHit10, oFoe10));
		DelayCommand(2.3f, TOBStrikeWeaponDamage(oWeapon, nHit20, oFoe10));
	}

	DeleteLocalObject(oToB, "AdamantineHurricaneFoe1");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe2");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe3");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe4");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe5");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe6");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe7");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe8");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe9");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe10");
}
