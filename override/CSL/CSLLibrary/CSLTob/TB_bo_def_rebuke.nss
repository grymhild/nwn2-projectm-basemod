//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/27/2009								//
//	Title: TB_bo_def_rebuke						//
//	Description: If an opponent 				//
// attacks anyone other than you in melee for //
// the duration of the maneuver, that attack 	//
// provokes an attack of opportunity from you. //
// Enemies you strike become aware of the 		//
// consequences of the maneuver.				//
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
	
	object oFoe = IntToObject(GetLocalInt(oToB, "Target"));

	if ( !HkSwiftActionIsActive(oPC))
	{
		object oFriend = GetAttackTarget(oFoe);

		if ((oFriend != oPC) && (oFriend != OBJECT_INVALID))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

			int nHit = TOBStrikeAttackRoll(oWeapon, oFoe);

			CSLStrikeAttackSound(oWeapon, oFoe, nHit, 0.2f);
			TOBBasicAttackAnimation(oWeapon, nHit);
			DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oFoe));
			AssignCommand(oFoe, ClearAllActions(TRUE));
			AssignCommand(oFoe, ActionAttack(oPC));
		}

		TOBRunSwiftAction(35, "B");
		TOBExpendManeuver(35, "B");
	}
}
