//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/23/2009							//
//	Title: TB_st_bl_charge						//
//	Description: As part of this maneuver, //
//	you charge an opponent. You do not 		//
//	provoke attacks of opportunity for 		//
//	moving as part of this charge. If your //
//	charge attack hits, it deals an extra 10//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 188);

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
	DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nRoll, oTarget, 10));
	TOBExpendManeuver(188, "STR");
}
