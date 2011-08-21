//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/18/2009						//
//	Title: TB_st_swarming						//
//	Description: As part of this maneuver, //
// you make a single melee attack against //
// an opponent. If this attack hits, you 	//
// deal normal melee damage, and any ally //
// who threatens your target can 		//
// immediately make an attack against him. //
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GenerateFriends(object oTarget)
{
	object oPC = OBJECT_SELF;
	location lTarget = GetLocation(oTarget);
	float fRange;

	fRange = CSLGetMeleeRange(oTarget);

	if (fRange < FeetToMeters(8.0f)) //Maximum distance the engine allows a melee attack at.
	{
		fRange = FeetToMeters(8.0f);
	}

	object oFriend;
	int n;

	n = 1;
	oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget);

	while (GetIsObjectValid(oFriend))
	{
		if ((oFriend != oPC) && (!GetIsReactionTypeHostile(oFriend, oPC)))
		{
			SetLocalObject(oPC, "SwarmingAlly" + IntToString(n), oFriend);
			n++;
		}

		if (n > 6)
		{
			break;
		}

		oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget);
	}
}

void CleanUp()
{
	object oPC = OBJECT_SELF;

	DeleteLocalObject(oPC, "SwarmingAlly1");
	DeleteLocalObject(oPC, "SwarmingAlly2");
	DeleteLocalObject(oPC, "SwarmingAlly3");
	DeleteLocalObject(oPC, "SwarmingAlly4");
	DeleteLocalObject(oPC, "SwarmingAlly5");
	DeleteLocalObject(oPC, "SwarmingAlly6");
}

void Attack(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	float fDist = GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget);
	float fRange = CSLGetMeleeRange(oPC);

	fRange = CSLGetMeleeRange(oPC);

	if (fRange < FeetToMeters(8.0f))
	{
		fRange = FeetToMeters(8.0f);
	}

	if (GetIsObjectValid(oTarget) && (fDist <= fRange))
	{
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	}
}

void SwarmingAssault(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oFriend1 = GetLocalObject(oPC, "SwarmingAlly1");
	object oFriend2 = GetLocalObject(oPC, "SwarmingAlly2");
	object oFriend3 = GetLocalObject(oPC, "SwarmingAlly3");
	object oFriend4 = GetLocalObject(oPC, "SwarmingAlly4");
	object oFriend5 = GetLocalObject(oPC, "SwarmingAlly5");
	object oFriend6 = GetLocalObject(oPC, "SwarmingAlly6");

	if (GetIsObjectValid(oFriend1))
	{
		AssignCommand(oFriend1, Attack(oTarget));
	}

	if (GetIsObjectValid(oFriend2))
	{
		AssignCommand(oFriend2, Attack(oTarget));
	}

	if (GetIsObjectValid(oFriend3))
	{
		AssignCommand(oFriend3, Attack(oTarget));
	}

	if (GetIsObjectValid(oFriend4))
	{
		AssignCommand(oFriend4, Attack(oTarget));
	}

	if (GetIsObjectValid(oFriend5))
	{
		AssignCommand(oFriend5, Attack(oTarget));
	}

	if (GetIsObjectValid(oFriend6))
	{
		AssignCommand(oFriend6, Attack(oTarget));
	}

	DelayCommand(0.1f, CleanUp());
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
	
	object oTarget = TOBGetManeuverObject(oToB, 200);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(200, "STR");

	if (nHit > 0)
	{
		GenerateFriends(oTarget);
		DelayCommand(0.1f, SwarmingAssault(oTarget));
	}
}
