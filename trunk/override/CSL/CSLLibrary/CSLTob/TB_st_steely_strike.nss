//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/11/2009							//
//	Title: TB_st_steely_strike					//
//	Description: Gain a +4 on your attack	//
//	roll for this strike, but all enemies	//
//	except the target gain +4 to attack vs	//
//	you.									//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 93);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 4);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(93, "STR");

	// Cheap way of giving everyone else +4 to attack me.
	effect eAC = EffectACDecrease(4);
	eAC = ExtraordinaryEffect(eAC);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);

	if (GetAttackTarget(oTarget) == oPC)
	{
		effect eAttack = EffectAttackDecrease(4);
		eAttack = ExtraordinaryEffect(eAttack);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oTarget, 6.0f);
	}
}
