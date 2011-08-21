//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 7/30/2009									//
//	Title: TB_st_shadowbt								//
//	Description: As part of this maneuver, you make //
// a single melee attack against an opponent. 	//
//	Unlike on a normal attack, you roll 2d20 and 	//
//	select which of the two die results to use. If //
//	you use the higher die result, resolve your 	//
//	attack as normal. (Your mystic double misses, 	//
//	but your true attack might hit.) If you use the //
// lower die result, or if both die results are the//
//	same, your attack deals an extra 1d6 points of //
//	cold damage as both the mystic double’s attack	//
//	and your true weapon strike home.				//
//////////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ShadowBladeTechnique(object oTarget, object oWeapon, int nHighLow)
{
	object oPC = OBJECT_SELF;

	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit, FALSE, FALSE);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

	if ((nHighLow == 0) && (nHit > 0))
	{
		effect eCold = EffectDamage(d6(1), DAMAGE_TYPE_COLD);
		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
		effect eLink = EffectLinkEffects(eCold, eVis);

		DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
	}

	DelayCommand(0.01f, TOBRemoveAttackRollOverride(oPC, 2));
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 132);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nD20roll1 = d20(1);
	int nD20roll2 = d20(1);
	int nRollPref = GetLocalInt(oToB, "SBTRollPref");
	int nHigh, nLow;

	if (nD20roll1 >= nD20roll2)
	{
		nHigh = nD20roll1;
		nLow = nD20roll2;
	}
	else
	{
		nHigh = nD20roll2;
		nLow = nD20roll1;
	}

	SendMessageToPC(oPC, "<color=chocolate>Shadow Blade Technique: High Roll: " + IntToString(nHigh) + " Low Roll: " + IntToString(nLow) + "</color>");

	effect eShadowBlade = EffectVisualEffect(VFX_TOB_SHADOWBT);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadowBlade, oPC, 1.34f);

	if (nRollPref == 0)
	{
		CSLOverrideD20Roll(oPC, nLow);
		DelayCommand(0.1f, ShadowBladeTechnique(oTarget, oWeapon, 0));
	}
	else
	{
		CSLOverrideD20Roll(oPC, nHigh);
		DelayCommand(0.1f, ShadowBladeTechnique(oTarget, oWeapon, 1));
	}

	TOBExpendManeuver(132, "STR");
}
