//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/6/2009							//
//	Title: TB_st_wl_charge 					//
//	Description: As part of this maneuver, //
//	you charge an opponent. You do not 		//
//	provoke attacks of opportunity for 		//
//	moving as part of this charge. If your //
//	charge attack hits, it deals an extra 35//
//	points of damage.						//
//////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 203);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = TOBStrikeAttackRoll(oWeapon, oTarget, 2);

	CSLStrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, TOBBasicAttackAnimation(oWeapon, nRoll));
	DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nRoll, oTarget, 35));
	TOBExpendManeuver(203, "STR");
}
