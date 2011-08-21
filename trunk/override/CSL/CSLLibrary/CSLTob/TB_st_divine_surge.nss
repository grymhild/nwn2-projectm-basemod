//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/4/2009												//
//	Title: TB_st_divine_surge										//
//	Description: As part of this maneuver, you make a single 	//
// melee attack that deals an extra 8d8 points of damage.		//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 36);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);
	effect eVis = EffectVisualEffect(VFX_TOB_EYES_BLUE);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d8(8)));
	TOBExpendManeuver(36, "STR");
}
