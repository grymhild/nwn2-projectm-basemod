//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: Halloween 2009							//
//	Title: TB_st_wm_charge								//
//	Description: As part of this maneuver, you 	//
// charge an opponent. In addition, all allies 	//
// within 30 feet of you at the beginning of your //
// turn can also charge this target as an immediate//
// action. You and allied creatures do not block 	//
// each other when determining if you can charge. //
// Your charge attack deals an extra 50 points of //
// damage, and those of your allies each deal an 	//
// extra 25 points of damage. For each ally who 	//
// charges, counting yourself, your charge attack //
// and those of your allies are made with a 		//
// cumulative +2 bonus (in addition to the normal //
// bonus provided by charging). An opponent struck //
// by you and at least one other ally is stunned 	//
// for 1 round. 							//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "tob_x0_i0_position"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void FriendCharge(object oAlly, location lAlly)
{// Not a real charge, but oh well, beats UI scripting.
	if (GetIsObjectValid(oAlly))
	{
		AssignCommand(oAlly, TOBClearStrikes());
		AssignCommand(oAlly, ClearAllActions());

		if (GetIsLocationValid(lAlly))
		{
			AssignCommand(oAlly, JumpToLocation(lAlly));
		}
		else
		{
			location lNew = CalcSafeLocation(oAlly, lAlly, FeetToMeters(5.0f), FALSE, TRUE);
			AssignCommand(oAlly, JumpToLocation(lNew));
		}
	}
}

void RallyFriends(object oTarget, location lPC)
{
	object oPC = OBJECT_SELF;
	float fDist = GetDistanceBetween(oPC, oTarget);
	float fFive = FeetToMeters(5.0f);
	float fFacing = GetFacing(oPC);
	float fGirth = CSLGetGirth(oTarget);
	float fOpposite = CSLGetOppositeDirection(fFacing);
	location lFlank = CSLGetOppositeLocation(oPC, fGirth + fDist + 1.4f); //Includes a little larger than the standard PC sized square.
	location lLeft = CSLGetLeftLocation(oPC, fFive);
	location lRight = CSLGetRightLocation(oPC, fFive);
	location lFlankLeft = CSLGenerateNewLocationFromLocation(lLeft, fGirth, fFacing, fOpposite);
	location lFlankRight = CSLGenerateNewLocationFromLocation(lRight, fGirth, fFacing, fOpposite);
	object oFriend1 = GetLocalObject(oPC, "WMCAlly1");
	object oFriend2 = GetLocalObject(oPC, "WMCAlly2");
	object oFriend3 = GetLocalObject(oPC, "WMCAlly3");
	object oFriend4 = GetLocalObject(oPC, "WMCAlly4");
	object oFriend5 = GetLocalObject(oPC, "WMCAlly5");
	object oFriend6 = GetLocalObject(oPC, "WMCAlly6");
	object oSneak;

	if (GetIsObjectValid(oFriend1) && (CSLGetTotalSneakDice(oFriend1,oPC) > 0))// Move a Sneak attacker into a flanking position with the PC.
	{
		oSneak = oFriend1;
	}
	else if (GetIsObjectValid(oFriend2) && (CSLGetTotalSneakDice(oFriend2,oPC) > 0))
	{
		oSneak = oFriend2;
	}
	else if (GetIsObjectValid(oFriend3) && (CSLGetTotalSneakDice(oFriend3,oPC) > 0))
	{
		oSneak = oFriend3;
	}
	else if (GetIsObjectValid(oFriend4) && (CSLGetTotalSneakDice(oFriend4,oPC) > 0))
	{
		oSneak = oFriend4;
	}
	else if (GetIsObjectValid(oFriend5) && (CSLGetTotalSneakDice(oFriend5,oPC) > 0))
	{
		oSneak = oFriend5;
	}
	else if (GetIsObjectValid(oFriend6) && (CSLGetTotalSneakDice(oFriend6,oPC) > 0))
	{
		oSneak = oFriend6;
	}

	FriendCharge(oFriend1, lRight);
	FriendCharge(oFriend2, lFlankRight);
	FriendCharge(oFriend3, lLeft);
	FriendCharge(oFriend4, lFlankLeft);
	FriendCharge(oFriend5, lFlank);
	FriendCharge(oFriend6, lPC);
	DelayCommand(0.1f, FriendCharge(oSneak, lFlank));
}

void GenerateFriends(location lPC)
{
	object oPC = OBJECT_SELF;
	float fRange = FeetToMeters(30.0f);
	object oFriend, oWeapon, oArmor;
	int n, nBase, nClothy, nAction, nBonus;

	n = 1;
	oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFriend))
	{
		oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
		oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oFriend);
		nBase = GetBaseItemType(oWeapon);
		nAction = GetCurrentAction(oFriend);

		if ((GetArmorRank(oArmor) == ARMOR_RANK_NONE) && (GetLevelByClass(CLASS_TYPE_MONK, oFriend) < 1))
		{
			nClothy = 1;
		}
		else if ((GetLevelByClass(CLASS_TYPE_BARD, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_WARLOCK, oFriend) > 0))
		{
			nClothy = 1;
		}
		else nClothy = 0;

		//Filter out people that don't want to be close to the target.
		if ((oPC != oFriend) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (!GetWeaponRanged(oWeapon)) && (nClothy == 0) && (nBase != BASE_ITEM_MAGICSTAFF) && (nBase != BASE_ITEM_MAGICROD) && (nBase != BASE_ITEM_MAGICWAND) && (nAction != ACTION_CASTSPELL) && (nAction != ACTION_ITEMCASTSPELL) && (nAction != ACTION_USEOBJECT))
		{
			nBonus = GetLocalInt(oPC, "WMCBonus");

			SetLocalObject(oPC, "WMCAlly" + IntToString(n), oFriend);
			SetLocalInt(oPC, "WMCBonus", nBonus + 2);
			n++;
		}

		if (n > 6)
		{
			break;
		}

		oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}
}

void CleanUp(object oTarget)
{
	object oPC = OBJECT_SELF;

	DeleteLocalInt(oPC, "WMCBonus");
	DeleteLocalInt(oTarget, "WMCStun");
	DeleteLocalObject(oPC, "WMCAlly1");
	DeleteLocalObject(oPC, "WMCAlly2");
	DeleteLocalObject(oPC, "WMCAlly3");
	DeleteLocalObject(oPC, "WMCAlly4");
	DeleteLocalObject(oPC, "WMCAlly5");
	DeleteLocalObject(oPC, "WMCAlly6");
}

void Attack(object oTarget, object oLeader)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

	if (GetIsObjectValid(oTarget))
	{
		int nBonus = GetLocalInt(oLeader, "WMCBonus");
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2 + nBonus);

		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, 25));

		if (nHit > 0)
		{
			int nStun = GetLocalInt(oTarget, "WMCStun");

			SetLocalInt(oTarget, "WMCStun", nStun + 1);

			if (GetLocalInt(oTarget, "WMCStun") > 1)
			{
				effect eStun = EffectStunned();
				effect eVis = EffectVisualEffect(VFX_TOB_STARS);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
			}
		}
	}
}

void WarMastersCharge(object oTarget, object oPC)
{
	object oFriend1 = GetLocalObject(oPC, "WMCAlly1");
	object oFriend2 = GetLocalObject(oPC, "WMCAlly2");
	object oFriend3 = GetLocalObject(oPC, "WMCAlly3");
	object oFriend4 = GetLocalObject(oPC, "WMCAlly4");
	object oFriend5 = GetLocalObject(oPC, "WMCAlly5");
	object oFriend6 = GetLocalObject(oPC, "WMCAlly6");

	if (GetIsObjectValid(oFriend1))
	{
		AssignCommand(oFriend1, Attack(oTarget, oPC));
	}

	if (GetIsObjectValid(oFriend2))
	{
		AssignCommand(oFriend2, Attack(oTarget, oPC));
	}

	if (GetIsObjectValid(oFriend3))
	{
		AssignCommand(oFriend3, Attack(oTarget, oPC));
	}

	if (GetIsObjectValid(oFriend4))
	{
		AssignCommand(oFriend4, Attack(oTarget, oPC));
	}

	if (GetIsObjectValid(oFriend5))
	{
		AssignCommand(oFriend5, Attack(oTarget, oPC));
	}

	if (GetIsObjectValid(oFriend6))
	{
		AssignCommand(oFriend6, Attack(oTarget, oPC));
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
	
	object oTarget = TOBGetManeuverObject(oToB, 204);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	location lPC = GetLocation(oPC);

	GenerateFriends(lPC);
	RallyFriends(oTarget, lPC);
	WarMastersCharge(oTarget, oPC);

	int nBonus = GetLocalInt(oPC, "WMCBonus");
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2 + nBonus);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, 50));
	TOBExpendManeuver(204, "STR");

	if (nHit > 0)
	{
		int nStun = GetLocalInt(oTarget, "WMCStun");

		SetLocalInt(oTarget, "WMCStun", nStun + 1);

		if (GetLocalInt(oTarget, "WMCStun") > 1)
		{
			effect eStun = EffectStunned();
			effect eVis = EffectVisualEffect(VFX_TOB_STARS);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
		}
	}

	CleanUp(oTarget);
}
