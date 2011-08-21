//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/15/2009												//
//	Title: TB_st_dazing											//
//	Description: As part of this maneuver, you make a melee 	//
// attack. If this attack hits, your target takes normal melee //
// damage and must make a Fort save (DC 15 + your Str modifier)//
// or be dazed for 1 round. 									//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 79);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(79, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = TOBGetManeuverDC(nStr, 0, 15);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
			effect eDazing = EffectDazed();
			eDazing = ExtraordinaryEffect(eDazing);

			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazing, oTarget, 6.0f);
		}
	}
}
