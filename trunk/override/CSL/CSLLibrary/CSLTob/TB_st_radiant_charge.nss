//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/15/2009									//
//	Title: TB_st_radiant_charge						//
//	Description: You must make a charge attack as 	//
// part of this maneuver. If the target is evil 	//
// aligned, your attack deals an extra 6d6 points //
// of damage. In addition, if your charge attack 	//
// hits and the target is evil-aligned, you become //
// wreathed in holy energy. You gain damage 		//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 45);

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
	TOBExpendManeuver(45, "STR");

	if (nAlign == ALIGNMENT_EVIL)
	{
		DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	}
	else DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

	if ((nAlign == ALIGNMENT_EVIL) && (nHit > 0))
	{
		effect eCharge = EffectVisualEffect(VFX_TOB_RADIANT_CHARGE);
		effect eRadiant = EffectDamageReduction(10, DAMAGE_POWER_NORMAL, 0, DR_TYPE_EPIC);
		eRadiant = ExtraordinaryEffect(eRadiant);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRadiant, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
	}
}
