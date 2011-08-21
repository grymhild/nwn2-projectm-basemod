//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/2/2009									//
//	Title: TB_desertdodge									//
//	Description: If you move at least 10 feet from	//
//	your original position, you gain a +1 dodge 	//
//	bonus to AC and deal an extra 1 point of fire 	//
//	damage with any attack you make with a Desert	//
//	Wind weapon.									//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_variables"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void RunDWD(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "RUNDWD", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "RUNDWD" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "DWDLoc");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6504);

	if (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f))
	{
		object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
		eAC = SupernaturalEffect(eAC);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);

		if (TOBGetIsDesertWindWeapon(oMyWeapon) == TRUE)
		{
			effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 6.0f);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RunDWD( oPC, oToB, iSpellId, iSerial ));
}

void RunDWDLocation()
{
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	
	SetLocalLocation(oPC, "DWDLoc", GetLocation(oPC));
	DelayCommand(6.0f, RunDWDLocation());
}


void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6504, oPC))
	{
		RunDWD(); //Only runs if the effect is no longer on the player.
		DelayCommand(5.8f, RunDWDLocation());
	}
}

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}
