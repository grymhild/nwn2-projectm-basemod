///////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/20/2009									//
//	Title: TB_st_flanking									//
//	Description: You can use this strike when you and//
// any number of allies flank an opponent you 		//
// designate. As part of this maneuver, you make a //
// melee attack against the flanked opponent. If 	//
// your attack hits, any ally flanking your foe can //
// immediately make a melee attack against that 	//
// creature. These extra attacks are not attacks of //
// opportunity. Your allies must be able to see you //
// to gain this benefit.							//
///////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GenerateFriends()
{
	object oPC = OBJECT_SELF;
	object oFriend;
	int n;

	n = 1;
	oFriend = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oPC, n);

	while (GetIsObjectValid(oFriend))
	{
		if ((oFriend != oPC) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (GetObjectSeen(oFriend, oPC)))
		{
			SetLocalObject(oPC, "FMAlly" + IntToString(n), oFriend);
		}

		if (n > 6)
		{
			break;
		}

		n++;
		oFriend = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oPC, n);
	}
}

void FMAttack(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void CleanUp()
{
	object oPC = OBJECT_SELF;

	DeleteLocalInt(oPC, "FMAlly1");
	DeleteLocalInt(oPC, "FMAlly2");
	DeleteLocalInt(oPC, "FMAlly3");
	DeleteLocalInt(oPC, "FMAlly4");
	DeleteLocalInt(oPC, "FMAlly5");
	DeleteLocalInt(oPC, "FMAlly6");
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
	
	object oTarget = TOBGetManeuverObject(oToB, 193);

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
	TOBExpendManeuver(193, "STR");

	if (nHit > 0)
	{
		AssignCommand(oPC, GenerateFriends());

		float fAllyDist, fAllyRange;
		object oFriend1 = GetLocalObject(oPC, "FMAlly1");

		if ((GetIsObjectValid(oFriend1)) && (CSLIsFlankValid(oFriend1, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend1, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend1);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend1, FMAttack(oTarget));
			}
		}

		object oFriend2 = GetLocalObject(oPC, "FMAlly2");

		if ((GetIsObjectValid(oFriend2)) && (CSLIsFlankValid(oFriend2, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend2, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend2);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend2, FMAttack(oTarget));
			}
		}

		object oFriend3 = GetLocalObject(oPC, "FMAlly3");

		if ((GetIsObjectValid(oFriend3)) && (CSLIsFlankValid(oFriend3, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend3, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend3);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend3, FMAttack(oTarget));
			}
		}

		object oFriend4 = GetLocalObject(oPC, "FMAlly4");

		if ((GetIsObjectValid(oFriend4)) && (CSLIsFlankValid(oFriend4, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend4, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend4);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend4, FMAttack(oTarget));
			}
		}

		object oFriend5 = GetLocalObject(oPC, "FMAlly5");

		if ((GetIsObjectValid(oFriend5)) && (CSLIsFlankValid(oFriend5, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend5, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend1);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend5, FMAttack(oTarget));
			}
		}

		object oFriend6 = GetLocalObject(oPC, "FMAlly6");

		if ((GetIsObjectValid(oFriend6)) && (CSLIsFlankValid(oFriend6, oTarget)))
		{
			fAllyDist = GetDistanceBetween(oFriend6, oTarget) - CSLGetGirth(oTarget);
			fAllyRange = CSLGetMeleeRange(oFriend6);

			if (fAllyDist <= fAllyRange)
			{
				AssignCommand(oFriend6, FMAttack(oTarget));
			}
		}

		DelayCommand(5.0f, CleanUp());
	}
}
