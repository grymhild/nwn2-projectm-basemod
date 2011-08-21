//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/20/2009								//
//	Title: TB_bo_mongoose							//
//	Description: You make a flurry of deadly 	//
// attacks. After initiating this boost, you 	//
// can make one additional attack with each 	//
// weapon you wield (to a maximum of two extra //
// attacks if you wield two or more weapons). //
// These extra attacks are made at your highest//
// attack bonus for each of your respective 	//
// weapons. All of these attacks must be 		//
// directed against the same opponent.			//
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

	if (GetIsObjectValid(oFoe) && ( !HkSwiftActionIsActive(oPC) )	&& (fDist <= fRange))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		int nHit = TOBStrikeAttackRoll(oWeapon, oFoe);

		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		CSLStrikeAttackSound(oWeapon, oFoe, nHit, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oFoe));

		if (GetIsObjectValid(oOffHand))
		{
			int nHit1 = TOBStrikeAttackRoll(oOffHand, oFoe);

			CSLStrikeAttackSound(oOffHand, oFoe, nHit, 0.3f);
			DelayCommand(0.4f, TOBStrikeWeaponDamage(oOffHand, nHit, oFoe));
		}

		if (GetLocalInt(oToB, "TimeStandsActive") == 1) // Allowed accoring to "The Sage".
		{
			int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe);

			TOBBasicAttackAnimation(oWeapon, nHit3, TRUE);
			CSLStrikeAttackSound(oWeapon, oFoe, nHit3, 0.4f);
			DelayCommand(0.5f, TOBStrikeWeaponDamage(oWeapon, nHit, oFoe));

			if (GetIsObjectValid(oOffHand))
			{
				int nHit4 = TOBStrikeAttackRoll(oOffHand, oFoe);

				CSLStrikeAttackSound(oOffHand, oFoe, nHit4, 0.5f);
				DelayCommand(0.6f, TOBStrikeWeaponDamage(oOffHand, nHit4, oFoe));
			}
		}

		TOBRunSwiftAction(167, "B");
		TOBExpendManeuver(167, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Dancing Mongoose.</color>");
}
