//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/27/2009									//
//	Title: TB_st_sgarrote								//
//	Description: As part of this maneuver, you 		//
// create a strand of shadow that you hurl at an	//
// opponent. The strand wraps around the target’s //
// throat and chokes it. As part of this maneuver, //
// you make a ranged touch attack against a 		//
// creature within range. If your attack is 		//
// successful, your opponent takes 5d6 points of 	//
// damage. In addition, it must make a successful //
// Fortitude save (DC 13 + your Wis modifier) or 	//
// become flat-footed until the start of its next //
// turn. This strike has no effect against 		//
// nonliving creatures, such as constructs and 	//
// undead.											//
//////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_armor"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 134);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	int nRace = GetRacialType(oTarget);

	if (nRace != RACIAL_TYPE_CONSTRUCT && nRace != RACIAL_TYPE_ELEMENTAL && nRace != RACIAL_TYPE_UNDEAD)
	{
		int nHit = TouchAttackRanged(oTarget);

		if (nHit > 0)
		{
			int nDamage;

			if (nHit == 1)
			{
				nDamage = d6(5);
			}
			else nDamage = d6(10);

			effect eDamage = EffectDamage(nDamage);
			float fDelay = CSLGetSpellEffectDelay(GetLocation(oPC), oTarget);

			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nDC = TOBGetManeuverDC(nWisdom, 0, 13);
			int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

			if (nFort == 0)
			{
				int nAC = GetAC(oTarget);
				int nFlat = CSLGetFlatFootedAC(oTarget);
				int nGarrote = nAC - nFlat; // Bringing its AC down to flat-footed.
				effect eGarrote = EffectACDecrease(nGarrote);
				eGarrote = SupernaturalEffect(eGarrote);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGarrote, oTarget, 6.0f);
				SetLocalInt(oTarget, "OverrideFlatFootedAC", 1);
				DelayCommand(6.0f, DeleteLocalInt(oTarget, "OverrideFlatFootedAC"));
			}
		}
	}
	else SendMessageToPC(oPC, "<color=red>Shadow Garrote is ineffective aginst unliving creatures!</color>");

	effect eAttack = EffectVisualEffect(VFX_TOB_SHCHOKE);

	CSLWatchOpponent(oTarget, oPC);
	CSLPlayCustomAnimation_Void(oPC, "Throw", 0);
	DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eAttack, oTarget));
	TOBExpendManeuver(134, "STR");
}
