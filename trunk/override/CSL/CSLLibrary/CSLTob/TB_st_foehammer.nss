//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/31/2009								//
//	Title: TB_st_foehammer							//
//	Description: As part of this maneuver, you //
// make a single melee attack. This attack 	//
// deals an extra 2d6 points of damage and 	//
// automatically overcomes damage reduction.	//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 40);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2), TRUE));
	TOBExpendManeuver(40, "STR"); //Wow another Devoted Spirit maneuver that's identical to another discipline Crusaders already have!
}
