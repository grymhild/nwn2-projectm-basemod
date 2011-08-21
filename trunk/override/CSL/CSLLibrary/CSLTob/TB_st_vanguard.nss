//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: TB_st_vanguard						//
//	Description: Standard Action; On a		//
//	successful hit your allies gain +4 on	//
//	attacks vs the target until the start	//
//	of the player's next turn.				//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 53);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(53, "STR");

	if (nHit > 0)
	{
		effect eMinus = EffectACDecrease(4); //Okay it's not really a +4, but the only way to make it vs this specific target.
		eMinus = ExtraordinaryEffect(eMinus);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMinus, oTarget, 5.9f);
	}
}
