//////////////////////////////////////////////
// Author: Drammel							//
// Date: 9/1/2009							//
// Title: TB_sa_tactics_otw					//
// Description: When you flank a foe, you 	//
// and allies who flank the enemy with you //
// gain a bonus on damage rolls against 	//
// that opponent equal to 1/2 your 		//
// initiator level.						//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
//#include "bot9s_include"
//#include "tob_x0_i0_position"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void TacticsOfTheWolf(int nBonus, object oPC = OBJECT_SELF)
{
	if (hkStanceGetHasActive(oPC,202))
	{
		object oTarget = GetAttackTarget(oPC);
		object oFlanker, oWeapon;
		location lPC = GetLocation(oPC);
		float fWeapon = CSLGetMeleeRange(oPC);
		float fFace = GetFacing(oPC); // Doesn't appear to update sometimes. Possibly the reason that normal sneak attacks can sometimes miss from a perfect flank and hit from odd places sometimes.
		float fFoeGirth = CSLGetGirth(oTarget);
		float fRange = FeetToMeters(30.0f) + fFoeGirth;
		float fFoeDist = GetDistanceBetween(oPC, oTarget);
		float fFlankerRange, fDistance, fFlankerFace, fMaxFlankDistance;
		int nFlankFace, nDamageType;
		effect eWolf;

		oFlanker = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
		{
			fFlankerRange = CSLGetMeleeRange(oFlanker);
			fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
			fDistance = GetDistanceBetween(oPC, oFlanker);
			fFlankerFace = GetFacing(oFlanker);
			nFlankFace = CSLIsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
		}

		while (GetIsObjectValid(oFlanker))
		{
			if (GetLocalInt(oFlanker, "OverrideFlank") == 1)
			{
				oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFlanker);
				nDamageType = CSLGetWeaponDamageType(oWeapon);
				eWolf = EffectDamageIncrease(nBonus, nDamageType);
				eWolf = ExtraordinaryEffect(eWolf);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolf, oFlanker, 1.0f);
			}
			else if ((!GetIsReactionTypeHostile(oFlanker, oPC)) && (oFlanker != oPC) && (nFlankFace == FALSE) && (fDistance <= fMaxFlankDistance) && (fDistance > fFoeDist) && (GetIsObjectValid(oTarget)) && (GetAttackTarget(oFlanker) == oTarget))
			{
				oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFlanker);
				nDamageType = CSLGetWeaponDamageType(oWeapon);
				eWolf = EffectDamageIncrease(nBonus, nDamageType);
				eWolf = ExtraordinaryEffect(eWolf);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolf, oFlanker, 1.0f);
			}
			else if (oPC == oFlanker)
			{
				oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFlanker);
				nDamageType = CSLGetWeaponDamageType(oWeapon);
				eWolf = EffectDamageIncrease(nBonus, nDamageType);
				eWolf = ExtraordinaryEffect(eWolf);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolf, oFlanker, 1.0f);
			}

			oFlanker = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);

			if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
			{
				fFlankerRange = CSLGetMeleeRange(oFlanker);
				fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
				fDistance = GetDistanceBetween(oPC, oFlanker);
				fFlankerFace = GetFacing(oFlanker);
				nFlankFace = CSLIsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
			}
		}

		DelayCommand(1.0f, TacticsOfTheWolf(nBonus,oPC));
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
	
	int nTactics = TOBGetInitiatorLevel(oPC) / 2;
	int nOfThe = CSLGetDamageBonusConstantFromNumber(nTactics);

	TacticsOfTheWolf(nOfThe, oPC);
}