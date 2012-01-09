//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/28/2009									//
//	Title: TB_st_soaring_raptor						//
//	Description: With a carefully timed leap, you 	//
// jump over the target’s defenses and attack it 	//
// from an unexpected angle. You can use this 		//
// maneuver only against a foe of a larger size 	//
// category than yours. As part of this maneuver, 	//
// you make a Jump check with a DC equal to your 	//
// foe's AC. If this check succeeds, you also make //
// a melee attack as part of this maneuver. If the //
// check fails, you cannot make this attack and the//
// maneuver is still considered expended. You gain	//
// a +4 bonus on the attack roll and deal an extra //
// 6d6 points of damage if your attack hits.		//
//////////////////////////////////////////////////////
//#include "bot9s_inc_feats"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 181);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	int nMySize = GetCreatureSize(oPC);
	int nFoeSize = GetCreatureSize(oTarget);

	if (nMySize > nFoeSize)
	{
		SendMessageToPC(oPC, "<color=red>This maneuver can only be initiated against a target at least one size category larger than you are.</color>");
		return;
	}

	int nd20 = d20(1);
	int nJump = CSLGetJumpSkill();
	int nRoll = nd20 + nJump;
	int nDC = GetAC(oTarget);

	SendMessageToPC(oPC, "<color=chocolate>Soaring Raptor Strike: Taunt: (" + IntToString(nd20) + " + " + IntToString(nJump) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + ".</color>");
	TOBExpendManeuver(181, "STR");

	if (nRoll >= nDC)
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 4);

		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 1.43f);
		CSLPlayCustomAnimation_Void(oPC, "leapup", 0);
		DelayCommand(1.02f, CSLPlayCustomAnimation_Void(oPC, "*leapattack", 0));
		DelayCommand(1.53f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));

		if ((GetHasFeat(FEAT_TIGER_BLOODED, oPC)) && (nHit > 0))
		{
			DelayCommand(1.53f, TOBTigerBlooded(oPC, oWeapon, oTarget));
		}
	}
	else SendMessageToPC(oPC, "<color=red>You failed your Taunt check.</color>");
}