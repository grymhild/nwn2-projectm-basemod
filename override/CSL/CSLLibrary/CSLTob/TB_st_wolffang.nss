//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: TB_st_wolffang						//
//	Description: Standard Action; Allow the //
//	player to make an attack with each		//
//	weapon they have equipped. Will not	//
//	function if the player has a two-handed //
//	weapon.									//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 185);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	if (!CSLGetIsHeldWeaponTwoHanded(oPC))
	{
		SetLocalInt(oToB, "TigerClawStrike", 1);
		DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

		int nHit1 = TOBStrikeAttackRoll(oWeapon, oTarget);
		int nHit2 = TOBStrikeAttackRoll(oOffhand, oTarget);

		CSLStrikeAttackSound(oWeapon, oTarget, nHit1, 0.2f);
		CSLStrikeAttackSound(oOffhand, oTarget, nHit2, 0.3f);
		TOBBasicAttackAnimation(oWeapon, nHit1, TRUE);

		if (GetHasFeat(FEAT_TIGER_BLOODED, oPC))
		{
			DelayCommand(0.3f, TOBTigerBlooded(oPC, oWeapon, oTarget));
		}

		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit1, oTarget));
		DelayCommand(0.4f, TOBStrikeWeaponDamage(oOffhand, nHit2, oTarget));
		TOBExpendManeuver(185, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>You cannot use a two-haned grip on your weapon with this maneuver.</color>");
}
