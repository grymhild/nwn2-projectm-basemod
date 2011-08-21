//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/10/2009								//
//	Title: TB_st_broken_shield						//
//	Description: As part of this maneuver, make //
// a single melee attack. This attack deals an //
// extra 4d6 points of damage. In addition, the//
// target must make a Reflex save (DC 14 + your//
// Str modifier) or become flatfooted until the//
// start of his next turn.						//
//////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_armor"
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_feats"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 114);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, TOBBasicAttackAnimation(oWeapon, nRoll));
	DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(4)));
	TOBExpendManeuver(114, "STR");

	if (nRoll > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 14);
		int nReflex = HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC);

		if ((nReflex == 0) && (!GetHasFeat(FEAT_UNCANNY_DODGE, oTarget)))
		{
			int nAC = GetAC(oTarget);
			int nFlat = CSLGetFlatFootedAC(oTarget);
			int nPenalty = nAC - nFlat;

			CSLOverrideAttackRollAC(oTarget, 2);
			DelayCommand(6.0f, TOBRemoveAttackRollOverride(oTarget, 1));

			if (nPenalty > 0)
			{
				effect eBroken = EffectACDecrease(nPenalty);
				eBroken = ExtraordinaryEffect(eBroken);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBroken, oTarget, 6.0f);
			}
		}

		if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
		{
			effect eFallingSun = TOBFallingSunAttack(oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
		}
	}
}
