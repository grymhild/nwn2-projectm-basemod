//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/30/2009							//
//	Title: TB_st_wr_hammer 						//
//	Description: As part of this maneuver, you //
// make a single, devastating strike against an//
// opponent. The raw force of this blow knocks //
// him senseless. Your attack deals an extra 	//
// 6d6 points of damage and stuns your opponent//
// for six seconds. 						//
//////////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 205);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenHammerike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenHammerike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, TOBBasicAttackAnimation(oWeapon, nRoll));
	DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(6)));
	TOBExpendManeuver(205, "STR");

	if ((nRoll > 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_STUN)))
	{
		effect eVis = EffectVisualEffect(VFX_TOB_STARS);
		effect eHammer = EffectStunned();
		eHammer = ExtraordinaryEffect(eHammer);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHammer, oTarget, 6.0f);
	}
}
