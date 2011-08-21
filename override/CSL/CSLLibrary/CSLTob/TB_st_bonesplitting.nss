//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/8/2009							//
//	Title: TB_st_bonesplitting					//
//	Description: As part of this maneuver, //
// you make a single melee attack. If your //
// attack hits, the target takes normal 	//
// damage as well as 2 points of 			//
// Constitution damage.					//
//////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 143);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(143, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
	{
		int nNumber;

		if (nHit == 2) // According the the Rules Compendium this does get multiplied.
		{
			nNumber = 4;
		}
		else nNumber = 2;

		effect eSplit = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
		eSplit = ExtraordinaryEffect(eSplit);
		eSplit = SetEffectSpellId(eSplit, -1);

		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSplit, oTarget);
		DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_CONSTITUTION));
	}
}
