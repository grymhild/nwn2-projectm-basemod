//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/17/2009									//
//	Title: TB_st_hamstring									//
//	Description: As part of this maneuver, you make a 	//
// single melee attack. If this attack hits, it deals //
// damage as normal. In addition, the target takes 1d8 //
// points of Dexterity damage and a –10-foot penalty to//
// speed for 1 minute. A successful Fortitude save (DC //
// 17 + your Str modifier) halves both the Dexterity 	//
// damage and the speed penalty.						//
//////////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 173);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(173, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 17);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		int nNonLiving, nImmune;

		if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
		{
			nNonLiving = 1;
		}
		else nNonLiving = 0;

		if ((!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
		{
			nImmune = 0;
		}
		else nImmune = 1;

		if ((nFort == 0) && (nNonLiving == 0))
		{
			int nNumber;

			if ((nHit == 2) && (nImmune == 0)) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = d8(2);
			}
			else nNumber = d8(1);

			effect eVis = EffectVisualEffect(VFX_TOB_HAMSTRING);
			effect eHamstring = EffectMovementSpeedDecrease(33);
			eHamstring = ExtraordinaryEffect(eHamstring);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.5f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHamstring, oTarget, 60.0f);
			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

			if (nImmune == 0)
			{
				effect eDamage = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				eDamage = ExtraordinaryEffect(eDamage);
				eDamage = SetEffectSpellId(eDamage, -1);

				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
				DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_DEXTERITY));
			}
		}
		else if (GetHasFeat(6818, oTarget))
		{
			return; //Mettle
		}
		else // Everything gets halved.
		{
			int nNumber;

			if ((nHit == 2) && (nImmune == 0)) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = d4(2);
			}
			else nNumber = d4(1);

			effect eVis = EffectVisualEffect(VFX_TOB_HAMSTRING);
			effect eHamstring = EffectMovementSpeedDecrease(17);
			eHamstring = ExtraordinaryEffect(eHamstring);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.5f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHamstring, oTarget, 60.0f);

			if (nImmune == 0)
			{
				effect eDamage = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				eDamage = ExtraordinaryEffect(eDamage);
				eDamage = SetEffectSpellId(eDamage, -1);

				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
				DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_DEXTERITY));
			}
		}

		if (GetHasFeat(FEAT_TIGER_BLOODED, oPC))
		{
			DelayCommand(0.3f, TOBTigerBlooded(oPC, oWeapon, oTarget));
		}
	}
}