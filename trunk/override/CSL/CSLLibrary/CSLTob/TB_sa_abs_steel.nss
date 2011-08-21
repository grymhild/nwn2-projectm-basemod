//////////////////////////////////////////////////////
// Author: Drammel									//
// Date: 8/25/2009									//
// Title: TB_sa_abs_steel								//
// Description: While you are in this stance, you //
// gain a +10-foot enhancement bonus to your speed.//
// If you move at least 10 feet during your turn, //
// you gain a +2 dodge bonus to AC until the 		//
// beginning of your next turn.					//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AbsoluteSteel(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "ABSOLUTESTEEL", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "ABSOLUTESTEEL" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,76))
	{
		// Given that average speed is equal to one round = 30ft, this is roughly a 10ft per round increase.
		effect eSpeed = EffectMovementSpeedIncrease(33);
		eSpeed = ExtraordinaryEffect(eSpeed);
		location lAbsSteel = GetLocalLocation(oPC, "AbsoluteSteel");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lAbsSteel);

		if (fDist >= FeetToMeters(10.0f))
		{
			effect eAC = EffectACIncrease(2);
			eAC = ExtraordinaryEffect(eAC);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
		}

		SetLocalLocation(oPC, "AbsoluteSteel", lPC);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oPC, 6.0f);
		DelayCommand(6.0f, AbsoluteSteel(oPC, oToB, iSpellId, iSerial));
	}
	else DeleteLocalLocation(oPC, "AbsoluteSteel");
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
	
	
	SetLocalLocation(oPC, "AbsoluteSteel", GetLocation(oPC));
	AbsoluteSteel(oPC,oToB);
}
