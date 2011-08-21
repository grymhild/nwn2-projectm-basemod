//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/17/2009								//
//	Title: TB_bo_scything								//
//	Description: You make a melee attack against an//
// enemy you are currently attacking. If this 	//
// attack hits you immediately make a free attack //
// at your highest attack bonus against a different//
// enemy that you threaten. You must be actively //
// engaged in an attack action to initiate this 	//
// maneuver.										//
//////////////////////////////////////////////////////
//#include "bot9s_inc_fx"
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

	if (GetIsObjectValid(oFoe) && !HkSwiftActionIsActive(oPC)	&& (fDist <= fRange))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nHit = TOBStrikeAttackRoll(oWeapon, oFoe);

		TOBStrikeTrailEffect(oWeapon, nHit, 2.0f);
		CSLPlayCustomAnimation_Void(oPC, "*whirlwind", 0);
		CSLStrikeAttackSound(oWeapon, oFoe, nHit, 0.2f);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oFoe));

		location lPC = GetLocation(oPC);
		object oFoe2;

		oFoe2 = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFoe2))
		{
			if ((oFoe != oFoe2) && (GetIsReactionTypeHostile(oFoe2, oPC)))
			{
				break;
			}
			else oFoe2 = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}

		float fDistance = GetDistanceBetween(oPC, oFoe2);

		if (GetDistanceBetween(oPC, oFoe2) > fRange)
		{
			oFoe2 = OBJECT_INVALID;
		}

		if (GetIsObjectValid(oFoe2) && (nHit > 0))
		{
			int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe2);

			CSLStrikeAttackSound(oWeapon, oFoe2, nHit2, 0.3f);
			DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit2, oFoe2));
		}

		TOBRunSwiftAction(91, "B");
		TOBExpendManeuver(91, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Scything Blade.</color>");
}
