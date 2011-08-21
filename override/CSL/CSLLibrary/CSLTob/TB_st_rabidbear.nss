//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/6/2009								//
//	Title: TB_st_rabidbear							//
//	Description: As part of this maneuver, you //
// make a single melee attack. You gain a +4 	//
// bonus on this attack roll and deal an extra //
// 10d6 points of damage. After completing this//
// maneuver, you take a –4 penalty to AC until //
// the start of your next turn. 			//
//////////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 178);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 4);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	CSLPlayCustomAnimation_Void(oPC, "*powerattack", 0);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(10)));
	TOBExpendManeuver(178, "STR");

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		DelayCommand(0.3f, TOBTigerBlooded(oPC, oWeapon, oTarget));
	}

	effect eAC = EffectACDecrease(4);
	eAC = ExtraordinaryEffect(eAC);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
}
