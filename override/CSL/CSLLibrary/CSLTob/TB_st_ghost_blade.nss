//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/6/2009								//
//	Title: TB_st_ghost_blade						//
//	Description: You attempt a Concentration 	//
//	check as part of this maneuver, using the 	//
//	target creature’s AC as the DC of the check.//
//	You then make a single melee attack against //
//	your target. The attack is also part of this//
//	maneuver. If your Concentration check		//
//	succeeds, the target is flat-footed against	//
//	your attack, and you deal an extra 1d6		//
//	points of damage. If your check fails, your //
//	attack is made with a –2 penalty and deals //
//	normal damage.								//
//////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GhostBlade(object oTarget, object oWeapon, int nHit)
{
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit, FALSE, FALSE);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
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
	
	object oTarget = TOBGetManeuverObject(oToB, 127);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	if (nHit > 0)
	{
		CSLOverrideAttackRollAC(oTarget, 2);
		DelayCommand(1.5f, TOBRemoveAttackRollOverride(oTarget, 1));

		effect eGhostBlade = EffectVisualEffect(VFX_TOB_GHOSTBLADE);

		DelayCommand(1.0f, GhostBlade(oTarget, oWeapon, nHit));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhostBlade, oPC, 3.0f);
		TOBExpendManeuver(127, "STR");
	}
}
