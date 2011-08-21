//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/14/2009												//
//	Title: TB_st_lingering											//
//	Description: You make a single melee attack that deals an 	//
// extra 2d6 points of fire damage. In addition, if your strike//
// hits, the flames upon your weapon bind to the target, which //
// takes an extra 2d6 points of fire damage each round at the //
// start of its turn for 3 rounds.							//
//////////////////////////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 19);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(19, "STR");

	if (nHit > 0)
	{
		effect eVis = EffectVisualEffect(VFX_DUR_FIRE);
		effect eFire = EffectDamage(d6(2), DAMAGE_TYPE_FIRE);
		effect eLingering = EffectDamageOverTime(d6(2), 6.0f, DAMAGE_TYPE_FIRE);
		eLingering = SupernaturalEffect(eLingering);

		DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
		DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 18.0f));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLingering, oTarget, 21.0f);
	}
}
