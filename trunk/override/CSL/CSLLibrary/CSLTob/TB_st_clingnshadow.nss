//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/20/2009	Happy Birthday Josh!	//
//	Title: TB_st_clingnshadow					//
//	Description: Standard Action; On a		//
//	successful hit with this maneuver deal	//
//	1d6 extra damage and the enemey makes a //
//	fortitude save. If they fail they gain //
//	20% miss chance.						//
//////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 120);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(120, "STR");

	if (nHit > 0)
	{
		int nDamageType = CSLGetWeaponDamageType(oWeapon);
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = TOBGetManeuverDC(nWisdom, 0, 11);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			effect eVis = EffectVisualEffect(VFX_TOB_CLINGINGSHADOW);
			effect eMiss = EffectMissChance(20);
			effect eShadow = EffectLinkEffects(eVis, eMiss);
			eShadow = SupernaturalEffect(eShadow);
			effect eDamage = EffectDamage(d6(1), nDamageType);

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
				effect eDamage = EffectDamage(d6(1), nDamageType);
				DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			}
		}
	}
}
