//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 8/26/2009										//
//	Title: TB_st_flesh_ripper								//
//	Description: As part of this maneuver, you make a 	//
// melee attack against a single opponent. If this 	//
// attack hits, the target must make a successful 	//
// Fortitude save (DC 13 + your Str modifier) or take a//
// –4 penalty on attacks and to AC for 1 round. If your//
// attack is a critical hit, these penalties last for a//
// number of rounds equal to your weapon’s critical 	//
// multiplier. Your target takes normal damage from 	//
// your attack regardless of the result of the save. 	//
// This maneuver functions only against creatures that //
// are vulnerable to critical hits.					//
//////////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_attack"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_maneuvers"
//#include "_HkSpell"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 170);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(170, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 13);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if ((nFort == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			int nDuration;

			if (nHit == 2)
			{
				nDuration = CSLGetCriticalMultiplier(oWeapon) * 6;
			}
			else nDuration = 6;

			effect eAttack = EffectAttackDecrease(4);
			effect eAC = EffectACDecrease(4);
			effect eFleshRipper = EffectLinkEffects(eAttack, eAC);
			eFleshRipper = ExtraordinaryEffect(eFleshRipper);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFleshRipper, oTarget, IntToFloat(nDuration));
		}

		if (GetHasFeat(FEAT_TIGER_BLOODED, oPC))
		{
			DelayCommand(0.3f, TOBTigerBlooded(oPC, oWeapon, oTarget));
		}
	}
}
