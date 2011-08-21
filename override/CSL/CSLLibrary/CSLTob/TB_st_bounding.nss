//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/7/2009								//
//	Title: TB_st_bounding							//
//	Description: As part of this maneuver, make //
// a double move. After you move, you can also //
// make a melee attack. You gain a +2 bonus on //
// this attack. This maneuver is considered a //
// charge attack when determining if feats and //
// other abilities apply to your attack.		//
//////////////////////////////////////////////////
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
	
	object oTarget = TOBGetManeuverObject(oToB, 56);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = TOBStrikeAttackRoll(oWeapon, oTarget, 2);

	CSLStrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, TOBBasicAttackAnimation(oWeapon, nRoll));
	DelayCommand(0.4f, TOBStrikeWeaponDamage(oWeapon, nRoll, oTarget));
	TOBExpendManeuver(56, "STR");
}
