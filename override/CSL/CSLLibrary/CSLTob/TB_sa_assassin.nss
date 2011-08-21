//////////////////////////////////////////////////////////
// Author: Drammel										//
// Date: 8/26/2009										//
// Title: TB_sa_assassin									//
// Description: While you are in this stance, you gain //
// the sneak attack ability, if you do not already have//
// it, which deals an extra 2d6 points of damage. If 	//
// you already have the sneak attack class feature,	//
// your existing sneak attack ability deals an extra 	//
// 2d6 points of damage. See the rogue class feature 	//
// (PH 50) for a complete description of sneak attack.	//
//////////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AssassinsStance(object oPC = OBJECT_SELF)
{

	if (hkStanceGetHasActive(oPC,116))
	{
		object oTarget;

		if (GetIsObjectValid(GetAttemptedAttackTarget()))
		{
			oTarget = GetAttemptedAttackTarget();
		}
		else oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

		if ((CSLIsTargetValidForSneakAttack(oTarget, oPC)) || (!GetIsInCombat(oTarget)))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nDamageType = CSLGetWeaponDamageType(oWeapon);
			int nDamaged6 = d6(2);
			int nDamage = CSLGetDamageBonusConstantFromNumber(nDamaged6);
			effect eAssassin = EffectDamageIncrease(nDamage, nDamageType);
			eAssassin = ExtraordinaryEffect(eAssassin);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAssassin, oPC, 1.0f);
		}

		DelayCommand(1.0f, AssassinsStance(oPC));
	}
}


void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	AssassinsStance(oPC);
}