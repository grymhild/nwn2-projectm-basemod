//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/7/2009								//
//	Title: TB_st_searing_charge					//
//	Description: As part of this maneuver, you //
// charge an opponent within range. You fly 	//
// while charging. Your charge attack is 		//
// resolved normally. On a successful hit, you //
// deal an extra 5d6 points of fire damage to //
// the target of your charge.					//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "tob_x2_inc_itemprop"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void SearingCharge(object oWeapon, object oTarget)
{
	object oPC = OBJECT_SELF;
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, 2);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.43f);
	CSLPlayCustomAnimation_Void(oPC, "*leapattack", 0);
	DelayCommand(0.53f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

	if (nHit > 0)
	{
		effect eFire = EffectDamage(d6(5), DAMAGE_TYPE_FIRE);

		DelayCommand(0.53f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
	}
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 24);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

	if ((GetDistanceBetween(oPC, oTarget) >= FeetToMeters(10.0f)) && (!GetWeaponRanged(oWeapon)))
	{
		if (GetDistanceBetween(oPC, oTarget) <= FeetToMeters(30.0f))
		{
			location lTarget = GetLocation(oTarget);

			if (CSLLineOfEffect(oPC, lTarget, TRUE) && LineOfSightObject(oPC, oTarget))
			{
				itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
				effect eAC = EffectACDecrease(2);
				eAC = ExtraordinaryEffect(eAC);

				ClearAllActions();
				TOBClearStrikes();
				CSLSafeAddItemProperty(oWeapon, ipVis, 6.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				DelayCommand(4.9f, JumpToLocation(lTarget));
				DelayCommand(1.02f, SetScriptHidden(oPC, TRUE));
				DelayCommand(4.95f, SetScriptHidden(oPC, FALSE));
				DelayCommand(5.0f, SearingCharge(oWeapon, oTarget));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
				CSLPlayCustomAnimation_Void(oPC, "leapup", 0);
				TOBExpendManeuver(24, "STR");
			}
			else SendMessageToPC(oPC, "<color=red>You do not have line of sight or effect to the target.</color>");
		}
		else SendMessageToPC(oPC, "<color=red>The target is out of range.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>You must be at least ten feet away from the target and equipped with a melee weapon to make a charge.</color>");
}
