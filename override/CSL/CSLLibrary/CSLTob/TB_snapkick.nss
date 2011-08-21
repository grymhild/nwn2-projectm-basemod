//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: TB_snapkick								//
//	Description: Activates Snap Kick mode. While in//
//	this mode, all attack rolls take a -2 penalty	//
//	and you deal an extra unarmed attack that deals //
//	your base unarmed damage + 1/2 STR.				//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void SnapKick(object oWeapon, object oTarget)
{
	if (GetCurrentHitPoints(oTarget) > 0)
	{
		object oPC = OBJECT_SELF;
		effect eDamage = CSLSnapKickDamage();
		int nRoll = TOBStrikeAttackRoll(oWeapon, oTarget);

		CSLStrikeAttackSound(oWeapon, oTarget, nRoll, 0.17f, FALSE);
		CSLPlayCustomAnimation_Void(oPC, "snapkick", 0);

		if (nRoll > 0)
		{
			DelayCommand(0.17f, SpawnBloodHit(oTarget, nRoll, oPC));
			DelayCommand(0.17f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
		}
	}
}

void SnapKickMode( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SNAPKICKMODE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SNAPKICKMODE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

	if (GetWeaponRanged(oWeapon))
	{
		ActionUnequipItem(oWeapon);
	}

	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		object oTarget = GetAttemptedAttackTarget();

		if (GetIsInCombat(oPC) && (GetIsObjectValid(oTarget)) && (GetDistanceToObject(oTarget) <= FeetToMeters(8.0f)) && (GetCurrentAction(oPC) == ACTION_ATTACKOBJECT))
		{
			effect eDecrease = EffectAttackDecrease(2);
			eDecrease = ExtraordinaryEffect(eDecrease);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDecrease, oPC, 6.0f);
			DelayCommand(5.2, SnapKick(oWeapon, oTarget));
			DelayCommand(6.0f, SnapKickMode(oPC, oToB, iSpellId, iSerial));
		}
		else DelayCommand(0.1f, SnapKickMode(oPC, oToB, iSpellId, iSerial));
		//SendMessageToPC(oPC, "<color=red>Snap Kick mode was canceled.</color>");
	}
	else FloatingTextStringOnCreature("<color=cyan>*Snap Kick mode was deactivated.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
}

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	if (GetIsObjectValid(oToB))
	{
		if (GetLocalInt(oToB, "SnapKick") == 0)
		{
			FloatingTextStringOnCreature("<color=cyan>*Snap Kick mode activated*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			SetLocalInt(oToB, "SnapKick", 1);
			SnapKickMode(oPC, oToB);
		}
		else if (GetLocalInt(oToB, "SnapKick") == 1)
		{
			SetLocalInt(oToB, "SnapKick", 0);
		}
	}
	// else CreateItemOnObject("tob", oPC, 1);
}