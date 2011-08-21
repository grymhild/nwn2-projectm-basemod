//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/8/2009									//
//	Title: TB_st_obscuring								//
//	Description: As a standard action, you can make //
// a single melee attack. If it hits, your opponent//
// takes normal melee damage plus an extra 5d6 	//
// points of damage. She must also make a 			//
// successful Fortitude save (DC 14 + your Wis 	//
// modifier) or suffer a 50% miss chance on all 	//
// melee and ranged attacks for 1 round. A 		//
// successful save negates the miss chance, but not//
// the extra damage.								//
//////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_constants"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 130);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(130, "STR");

	if (nHit > 0)
	{
		int nDamageType = CSLGetWeaponDamageType(oWeapon);
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = TOBGetManeuverDC(nWisdom, 0, 14);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			effect eVis = EffectVisualEffect(VFX_TOB_CLINGINGSHADOW);
			effect eMiss = EffectMissChance(50);
			effect eShadow = EffectLinkEffects(eVis, eMiss);
			eShadow = SupernaturalEffect(eShadow);
			effect eDamage = EffectDamage(d6(5), nDamageType);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oTarget, 6.0f);
			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}
		else
		{
			if (GetHasFeat(6818, oTarget)) // Mettle
			{
				return;
			}
			else
			{
				effect eDamage = EffectDamage(d6(5), nDamageType);
				DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			}
		}
	}
}
