//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/30/2009											//
//	Title: TB_st_perfect											//
//	Description: You make a single melee attack as part of this //
// strike. If your attack hits, it deals an extra 100 points of//
// damage (in addition to your normal melee damage).			//
//////////////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_fx"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 94);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);
	effect eVis = EffectVisualEffect(VFX_TOB_PERFECT);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.7f);
	TOBStrikeTrailEffect(oWeapon, nHit, 0.34f);
	CSLPlayCustomAnimation_Void(oPC, "*cleave", 0);
	DelayCommand(0.8f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, 100));
	TOBExpendManeuver(94, "STR");
}
