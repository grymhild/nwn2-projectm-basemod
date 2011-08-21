//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/29/2009							//
//	Title: TB_bo_rage_mongoose						//
//	Description: You make a flurry of deadly 	//
// attacks. After initiating this boost, you 	//
// can make two additional attacks with each 	//
// weapon you wield (to a maximum of four extra//
// attacks if you wield two or more weapons). //
// These extra attacks are made at your highest//
// attack bonus for each of your respective 	//
// weapons. 							//
//////////////////////////////////////////////////
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
	
	object oFoe = GetAttemptedAttackTarget();
	int nAppearance = GetAppearanceType(oFoe); //Index number of the target in appearance.2da
	float fHitDist = CSLGetHitDistance(oFoe);
	float fRange = CSLGetMeleeRange(oPC) + fHitDist;
	float fDist = GetDistanceBetween(oPC, oFoe) - CSLGetGirth(oFoe);

	if (GetIsObjectValid(oFoe) && fDist <= fRange && !HkSwiftActionIsActive(oPC) )
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		int nHit = TOBStrikeAttackRoll(oWeapon, oFoe);
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe);

		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		CSLStrikeAttackSound(oWeapon, oFoe, nHit, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oFoe));
		DelayCommand(0.5f, TOBStrikeWeaponDamage(oWeapon, nHit2, oFoe));

		if (GetIsObjectValid(oOffHand))
		{
			int nHit1 = TOBStrikeAttackRoll(oOffHand, oFoe);
			int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe);

			CSLStrikeAttackSound(oOffHand, oFoe, nHit, 0.3f);
			DelayCommand(0.4f, TOBStrikeWeaponDamage(oOffHand, nHit, oFoe));
			DelayCommand(0.6f, TOBStrikeWeaponDamage(oOffHand, nHit3, oFoe));
		}

		if (GetLocalInt(oToB, "TimeStandsActive") == 1) // Allowed accoring to "The Sage".
		{
			int nHit5 = TOBStrikeAttackRoll(oWeapon, oFoe);
			int nHit6 = TOBStrikeAttackRoll(oWeapon, oFoe);

			TOBBasicAttackAnimation(oWeapon, nHit5, TRUE);
			CSLStrikeAttackSound(oWeapon, oFoe, nHit5, 0.6f);
			DelayCommand(0.7f, TOBStrikeWeaponDamage(oWeapon, nHit5, oFoe));
			DelayCommand(0.7f, TOBStrikeWeaponDamage(oWeapon, nHit6, oFoe));

			if (GetIsObjectValid(oOffHand))
			{
				int nHit7 = TOBStrikeAttackRoll(oOffHand, oFoe);
				int nHit8 = TOBStrikeAttackRoll(oOffHand, oFoe);

				CSLStrikeAttackSound(oOffHand, oFoe, nHit7, 0.7f);
				DelayCommand(0.8f, TOBStrikeWeaponDamage(oOffHand, nHit7, oFoe));
				DelayCommand(0.8f, TOBStrikeWeaponDamage(oOffHand, nHit7, oFoe));
			}
		}

		TOBRunSwiftAction(180, "B");
		TOBExpendManeuver(180, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Raging Mongoose.</color>");
}
