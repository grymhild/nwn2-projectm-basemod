//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/22/2009							//
//	Title: TB_st_clever_pos					//
//	Description: As part of this maneuver, //
//	you make a single melee attack against a//
//	target. If your attack hits, the target //
//	takes damage normally and must make a 	//
//	Reflex save (DC 12 + your Dex modifier).//
//	If this save fails, you swap positions //
//	with the target.						//
//////////////////////////////////////////////
//#include "tob_i0_spells"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 99);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "SettingSunStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(99, "STR");

	if (nHit > 0)
	{
		int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
		int nDC = TOBGetManeuverDC(nDex, 0, 12);
		int nReflex = HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC);

		if (nReflex == 0)
		{
			location lPC = GetLocation(oPC);
			location lTarget = GetLocation(oTarget);

			AssignCommand(oTarget, DelayCommand(0.31, JumpToLocation(lPC)));
			DelayCommand(0.31, JumpToLocation(lTarget));
		}
	}
}
