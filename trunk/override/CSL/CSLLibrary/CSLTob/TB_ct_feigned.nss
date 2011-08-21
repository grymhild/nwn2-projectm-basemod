//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/31/2009								//
//	Title: TB_ct_feigned							//
//	Description: When your enemy makes an attack//
// of opportunity against you and if her attack//
// misses, she provokes an attack of 			//
// opportunity from you. If her attack of 		//
// opportunity hits you, she provokes an attack//
// of opportunity from any of your allies who //
// threaten her.								//
//////////////////////////////////////////////////
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
		if ((oFriend != oPC) && (!GetIsReactionTypeHostile(oFriend, oPC)))
		{
			SetLocalObject(oPC, "FeignedOpeningAlly" + IntToString(n), oFriend);
			n++;
		}

		if (n > 6)
		{
			break;
		}

		oFriend = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oPC, n);
	}
}

void FOAttack(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	FloatingTextStringOnCreature("<color=cyan>*Feigned Opening!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void FeignedOpening(object oTarget, float fRange)
{
	object oPC = OBJECT_SELF;

	if (hkCounterGetHasActive(oPC,102))
	{
		object oAttacked = GetAttackTarget(oTarget);
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oToB = CSLGetDataStore(oPC);
		location lOld = GetLocalLocation(oPC, "FeignedOpening_loc");
		location lTarget = GetLocation(oTarget);
		float fDist = GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget);
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
			int nMyHp = GetLocalInt(oToB, "FeignedOpeningHP");
			int nMyHp2 = GetCurrentHitPoints(oPC);

			if ((nMyHp > nMyHp2) && (GetLastDamager(oPC) == oTarget))
			{
				FOAttack(oTarget);
				TOBRunSwiftAction(102, "C");
			}
			else if (GetLastDamager(oPC) == oTarget)
			{
				TOBRunSwiftAction(102, "C");

				float fAllyDist, fAllyRange;
				object oFriend1 = GetLocalObject(oPC, "FeignedOpeningAlly1");

				if (GetIsObjectValid(oFriend1))
				{
					fAllyDist = GetDistanceBetween(oFriend1, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend1);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend1, FOAttack(oTarget));
					}
				}

				object oFriend2 = GetLocalObject(oPC, "FeignedOpeningAlly2");

				if (GetIsObjectValid(oFriend2))
				{
					fAllyDist = GetDistanceBetween(oFriend2, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend2);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend2, FOAttack(oTarget));
					}
				}

				object oFriend3 = GetLocalObject(oPC, "FeignedOpeningAlly3");

				if (GetIsObjectValid(oFriend3))
				{
					fAllyDist = GetDistanceBetween(oFriend3, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend3);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend3, FOAttack(oTarget));
					}
				}

				object oFriend4 = GetLocalObject(oPC, "FeignedOpeningAlly4");

				if (GetIsObjectValid(oFriend4))
				{
					fAllyDist = GetDistanceBetween(oFriend4, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend4);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend4, FOAttack(oTarget));
					}
				}

				object oFriend5 = GetLocalObject(oPC, "FeignedOpeningAlly5");

				if (GetIsObjectValid(oFriend5))
				{
					fAllyDist = GetDistanceBetween(oFriend5, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend1);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend5, FOAttack(oTarget));
					}
				}

				object oFriend6 = GetLocalObject(oPC, "FeignedOpeningAlly6");

				if (GetIsObjectValid(oFriend6))
				{
					fAllyDist = GetDistanceBetween(oFriend6, oTarget);
					fAllyRange = CSLGetMeleeRange(oFriend6);

					if (fAllyDist <= fAllyRange)
					{
						AssignCommand(oFriend6, FOAttack(oTarget));
					}
				}
			}
		}
		else DelayCommand(1.0f, FeignedOpening(oTarget, fRange));
	}
	else
	{
		DeleteLocalLocation(oPC, "FeignedOpening_loc");
		DeleteLocalInt(oPC, "FeignedOpeningHP");
		DeleteLocalInt(oPC, "FeignedOpeningAlly1");
		DeleteLocalInt(oPC, "FeignedOpeningAlly2");
		DeleteLocalInt(oPC, "FeignedOpeningAlly3");
		DeleteLocalInt(oPC, "FeignedOpeningAlly4");
		DeleteLocalInt(oPC, "FeignedOpeningAlly5");
		DeleteLocalInt(oPC, "FeignedOpeningAlly6");
	}
}

void RunRound()
{
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	location lPC = GetLocation(oPC);

	SetLocalLocation(oPC, "FeignedOpening_loc", lPC);
	SetLocalInt(oToB, "FeignedOpeningHP", GetCurrentHitPoints(oPC));
	DelayCommand(1.0f, RunRound());
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
	
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	if (GetIsReactionTypeHostile(oTarget, oPC))
	{
		location lPC = GetLocation(oPC);
		float fRange = CSLGetMeleeRange(oTarget);

		TOBExpendManeuver(102, "C");
		AssignCommand(oPC, GenerateFriends());
		SetLocalLocation(oPC, "FeignedOpening_loc", lPC);
		SetLocalInt(oToB, "FeignedOpeningHP", GetCurrentHitPoints(oPC));
		DelayCommand(0.5f, RunRound());
		FeignedOpening(oTarget, fRange);
	}
	else SendMessageToPC(oPC, "<color=red>You can only select a hostile enemy with this maneuver.</color>");
}
