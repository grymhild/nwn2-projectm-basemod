///////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/19/2009									//
//	Title: TB_st_pouncing								//
//	Description: As part of initiating this maneuver,//
// you make a charge attack. Instead of making a 	//
// single attack at the end of your charge, you can //
// make a full attack. The bonus on your attack roll//
// for making a charge attack applies to all your 	//
// attack rolls.									//
///////////////////////////////////////////////////////
//#include "bot9s_inc_feats"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void PouncingCharge(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f, int bAnimate = TRUE)
{
	if (bAnimate == TRUE)
	{
		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f + fDelay);
		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
	}

	DelayCommand(0.3f + fDelay, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

	if (GetHasFeat(FEAT_TIGER_BLOODED))
	{
		DelayCommand(0.3f + fDelay, TOBTigerBlooded(OBJECT_SELF, oWeapon, oTarget));
	}
}



void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 176);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	TOBExpendManeuver(176, "STR");

	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2);

	PouncingCharge(oWeapon, oTarget, nHit);

	int nRHandAttacks, nLHandAttacks;
	int nBAB = GetTRUEBaseAttackBonus(oPC);

	switch (nBAB)
	{
		case 0:	nRHandAttacks = 1; break;
		case 1:	nRHandAttacks = 1; break;
		case 2:	nRHandAttacks = 1; break;
		case 3:	nRHandAttacks = 1; break;
		case 4:	nRHandAttacks = 1; break;
		case 5:	nRHandAttacks = 1; break;
		case 6:	nRHandAttacks = 2; break;
		case 7:	nRHandAttacks = 2; break;
		case 8:	nRHandAttacks = 2; break;
		case 9:	nRHandAttacks = 2; break;
		case 10:nRHandAttacks = 2; break;
		case 11:nRHandAttacks = 3; break;
		case 12:nRHandAttacks = 3; break;
		case 13:nRHandAttacks = 3; break;
		case 14:nRHandAttacks = 3; break;
		case 15:nRHandAttacks = 3; break;
		case 16:nRHandAttacks = 4; break;
		case 17:nRHandAttacks = 4; break;
		case 18:nRHandAttacks = 4; break;
		case 19:nRHandAttacks = 4; break;
		case 20:nRHandAttacks = 5; break;
		case 21:nRHandAttacks = 5; break;
		case 22:nRHandAttacks = 5; break;
		case 23:nRHandAttacks = 5; break;
		case 24:nRHandAttacks = 5; break;
		default:nRHandAttacks = 6; break;
	}

	if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
	{
		if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oPC, TRUE))
		{
			int nBAB2 = GetTRUEBaseAttackBonus(oPC);

			switch (nBAB2)
			{
				case 0:	nLHandAttacks = 1; break;
				case 1:	nLHandAttacks = 1; break;
				case 2:	nLHandAttacks = 1; break;
				case 3:	nLHandAttacks = 1; break;
				case 4:	nLHandAttacks = 1; break;
				case 5:	nLHandAttacks = 1; break;
				case 6:	nLHandAttacks = 2; break;
				case 7:	nLHandAttacks = 2; break;
				case 8:	nLHandAttacks = 2; break;
				case 9:	nLHandAttacks = 2; break;
				case 10:nLHandAttacks = 2; break;
				case 11:nLHandAttacks = 3; break;
				case 12:nLHandAttacks = 3; break;
				case 13:nLHandAttacks = 3; break;
				case 14:nLHandAttacks = 3; break;
				case 15:nLHandAttacks = 3; break;
				case 16:nLHandAttacks = 4; break;
				case 17:nLHandAttacks = 4; break;
				case 18:nLHandAttacks = 4; break;
				case 19:nLHandAttacks = 4; break;
				case 20:nLHandAttacks = 5; break;
				case 21:nLHandAttacks = 5; break;
				case 22:nLHandAttacks = 5; break;
				case 23:nLHandAttacks = 5; break;
				case 24:nLHandAttacks = 5; break;
				default:nLHandAttacks = 6; break;
			}
		}
		else if (GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_GREATER_TWO_WEAPON_FIGHTING, oPC))
		{
			nLHandAttacks = 3;
		}
		else if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_IMPROVED_TWO_WEAPON_FIGHTING, oPC))
		{
			nLHandAttacks = 2;
		}
		else nLHandAttacks = 1;
	}
	else nLHandAttacks = 0;

	if (nLHandAttacks > 0)
	{
		int nLeft1 = TOBStrikeAttackRoll(oOffHand, oTarget, 2);
		PouncingCharge(oOffHand, oTarget, nLeft1, 0.1f, FALSE);
	}

	if (nRHandAttacks > 1) // Two attacks.
	{
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oTarget, -3);
		PouncingCharge(oWeapon, oTarget, nHit2, 1.0f, FALSE);
	}

	if (nLHandAttacks > 1)
	{
		int nLeft2 = TOBStrikeAttackRoll(oOffHand, oTarget, -3);
		PouncingCharge(oOffHand, oTarget, nLeft2, 1.1f, FALSE);
	}

	if (nRHandAttacks > 2) // Three attacks.
	{
		int nHit3 = TOBStrikeAttackRoll(oWeapon, oTarget, -8);
		PouncingCharge(oWeapon, oTarget, nHit3, 2.0f);
	}

	if (nLHandAttacks > 2)
	{
		int nLeft3 = TOBStrikeAttackRoll(oOffHand, oTarget, -8);
		PouncingCharge(oOffHand, oTarget, nLeft3, 2.1f, FALSE);
	}

	if (nRHandAttacks > 3) // Four attacks.
	{
		int nHit4 = TOBStrikeAttackRoll(oWeapon, oTarget, -13);
		PouncingCharge(oWeapon, oTarget, nHit4, 3.0f, FALSE);
	}

	if (nLHandAttacks > 3)
	{
		int nLeft4 = TOBStrikeAttackRoll(oOffHand, oTarget, -13);
		PouncingCharge(oOffHand, oTarget, nLeft4, 3.1f, FALSE);
	}

	if (nRHandAttacks > 4) // Five attacks.
	{
		int nHit5 = TOBStrikeAttackRoll(oWeapon, oTarget, -18);
		PouncingCharge(oWeapon, oTarget, nHit5, 4.0f, FALSE);
	}

	if (nLHandAttacks > 4)
	{
		int nLeft5 = TOBStrikeAttackRoll(oOffHand, oTarget, -18);
		PouncingCharge(oOffHand, oTarget, nLeft5, 4.1f, FALSE);
	}

	if (nRHandAttacks > 5) // Six attacks.
	{
		int nHit6 = TOBStrikeAttackRoll(oWeapon, oTarget, -23);
		PouncingCharge(oWeapon, oTarget, nHit6, 5.0f);
	}

	if (nLHandAttacks > 5)
	{
		int nLeft6 = TOBStrikeAttackRoll(oOffHand, oTarget, -23);
		PouncingCharge(oOffHand, oTarget, nLeft6, 5.1f, FALSE);
	}
}
