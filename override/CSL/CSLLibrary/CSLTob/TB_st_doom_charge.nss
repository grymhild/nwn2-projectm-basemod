//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/15/2009									//
//	Title: TB_st_doom_charge							//
//	Description: You must make a charge attack as 	//
// part of this maneuver. If your target is good 	//
// aligned, your attack deals an extra 6d6 points //
// of damage. In addition, if your charge attack 	//
// hits and the target is good-aligned, you become //
// wreathed in unholy energy. You gain damage 	//
// reduction 10/— until the beginning of your next //
// turn.											//
//////////////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 38);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2);
	int nAlign = GetAlignmentGoodEvil(oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.3f);
	DelayCommand(0.1f, TOBBasicAttackAnimation(oWeapon, nHit));
	TOBExpendManeuver(38, "STR");

	if (nAlign == ALIGNMENT_GOOD)
	{
		DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	}
	else DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

	if ((nAlign == ALIGNMENT_GOOD) && (nHit > 0))
	{
		effect eCharge = EffectVisualEffect(VFX_TOB_DOOMCHARGE);
		effect eDoom = EffectDamageReduction(10, DAMAGE_POWER_NORMAL, 0, DR_TYPE_EPIC);
		eDoom = ExtraordinaryEffect(eDoom);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDoom, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
	}
}
