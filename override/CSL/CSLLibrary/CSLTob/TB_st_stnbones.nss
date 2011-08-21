//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/9/2009							//
//	Title: TB_st_stnbones						//
//	Description: Standard Action; On a		//
//	successful hit with this maneuver, gain	//
//	DR 5/adamantine.						//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 160);

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
	TOBExpendManeuver(160, "STR");

	if (nHit > 0)
	{
		effect eVis = EffectNWN2SpecialEffectFile("sp_stoneskin", oPC);
		effect eDR = EffectDamageReduction(5, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
		eDR = ExtraordinaryEffect(eDR);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	}
}
