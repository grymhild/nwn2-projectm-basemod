//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/17/2009							//
//	Title: TB_st_deathinthedark					//
//	Description: As part of this maneuver, you //
// make a single melee attack. This attack 	//
// deals an extra 2d6 points of damage and 	//
// automatically overcomes damage reduction.	//
//////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_armor"
//#include "bot9s_inc_constants"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 123);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	if (CSLGetIsFlatFooted(oTarget))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);
		effect eVis = EffectVisualEffect(VFX_TOB_DOOMCHARGE);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
		TOBStrikeTrailEffect(oWeapon, nHit, 1.23f);
		CSLPlayCustomAnimation_Void(oPC, "*sneakattack", 0);
		TOBExpendManeuver(123, "STR");

		if (nHit > 0)
		{
			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nDC = TOBGetManeuverDC(nWisdom, 0, 17);
			int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

			if ((nFort == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
			{
				effect eHit = EffectVisualEffect(VFX_TOB_DEATHINTHEDARK);

				DelayCommand(1.34, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(15)));
				DelayCommand(1.34, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHit, oTarget, 3.0f));

			}
			else if (GetHasFeat(6818, oTarget))
			{
				// Mettle
			}
			else DelayCommand(1.34, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(5)));
		}
	}
	else SendMessageToPC(oPC, "<color=red>This maneuver can only be initiated against flat-footed opponents.</color>");
}
