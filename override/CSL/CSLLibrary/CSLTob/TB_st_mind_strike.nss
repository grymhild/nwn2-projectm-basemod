//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 9/7/2009										//
//	Title: TB_st_mind_strike								//
//	Description: As part of this maneuver, make a melee //
// attack. If this attack hits, your target must make a//
// Will save (DC 14 + your Str modifier) or take 1d4 	//
// points of Wisdom damage. The target ignores the		//
// Wisdom damage on a successful save but still takes //
// weapon damage normally.								//
//////////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_constants"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 65);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	TOBExpendManeuver(65, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 14);
		int nWill = HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC);

		int nNonLiving;

		if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
		{
			nNonLiving = 1;
		}
		else nNonLiving = 0;

		if ((nWill == 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = d4(2);
			}
			else nNumber = d4();

			effect eVis = EffectVisualEffect(VFX_TOB_MINDSTRIKE);
			effect eDamage = EffectAbilityDecrease(ABILITY_WISDOM, nNumber);
			eDamage = ExtraordinaryEffect(eDamage);
			eDamage = SetEffectSpellId(eDamage, -1);

			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
			DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_WISDOM));
		}
		else if (GetHasFeat(6818, oTarget))
		{
			return; //Mettle
		}
		else
		{
			DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
		}
	}
}
