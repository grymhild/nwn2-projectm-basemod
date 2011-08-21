//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/18/2009							//
//	Title: TB_st_bloodletting 				//
//	Description: As part of this maneuver, //
// you make a single melee attack. If this //
// attack hits, your opponent takes 4 	//
// points of Constitution damage in 		//
// addition to your attack's normal damage.//
// A successful Fortitude save (DC 15 + 	//
// your Wisdom modifier) reduces this 	//
// Constitution damage to 2 points, 		//
// although the foe still takes full normal//
// melee damage.							//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 118);

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
	TOBExpendManeuver(118, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = TOBGetManeuverDC(nWisdom, 0, 15);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 8;
			}
			else nNumber = 4;

			effect eVis = EffectVisualEffect(VFX_TOB_BLOODLETTING);
			effect eBloodletting = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
			eBloodletting = SupernaturalEffect(eBloodletting);
			eBloodletting = SetEffectSpellId(eBloodletting, -1);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBloodletting, oTarget);
			DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_CONSTITUTION));
		}
		else if (GetHasFeat(6818, oTarget)) // Mettle
		{
			return;
		}
		else
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 4;
			}
			else nNumber = 2;

			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
			effect eBloodletting = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
			eBloodletting = SupernaturalEffect(eBloodletting);
			eBloodletting = SetEffectSpellId(eBloodletting, -1);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBloodletting, oTarget);
			DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_CONSTITUTION));
		}
	}
}
