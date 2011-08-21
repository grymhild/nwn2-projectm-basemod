//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/15/2009												//
//	Title: TB_st_disrupting										//
//	Description: As part of this maneuver, you make a melee 	//
// attack. If this attack hits, your target takes normal melee //
// damage and must make a Will save (DC 15 + your Str modifier)//
// or be unable to take any actions for 1 round. 			//
//////////////////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "tob_i0_spells"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 59);

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
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(59, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 15);
		int nWill = HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC);

		if (nWill == 0)
		{
			effect eVis = EffectVisualEffect(VFX_DUR_STUN);
			effect eDisrupting = EffectDazed();
			eDisrupting = ExtraordinaryEffect(eDisrupting);

			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisrupting, oTarget, 6.0f);
		}
	}
}
