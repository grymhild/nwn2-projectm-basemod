//////////////////////////////////////////////////////
// Author: Drammel									//
// Date: 10/27/2009								//
// Title: TB_sa_alacrity								//
// Description: While you are in this stance, you //
// can use one counter per round without taking an //
// immediate action. You cannot use the same 		//
// maneuver two times in a round. In essence, one //
// counter you use during the round does not 		//
// require an immediate action. If you have already//
// taken an immediate action within the past round,//
// you can still use this stance to initiate a 	//
// counter. 								//
//////////////////////////////////////////////////////

	/* Half of the work of this function is covered in bot9s_inc_maneuvers
	under the function TOBRunSwiftAction. */
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StanceOfAlacrity(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "STANCEOFALACRITY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "STANCEOFALACRITY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,73))
	{
		SetLocalInt(oToB, "AlacrityCounter", 0);
		SetLocalInt(oToB, "StanceOfAlacrity", 1);
		DelayCommand(6.0f, StanceOfAlacrity(oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oToB, "AlacrityCounter");
		DeleteLocalInt(oToB, "StanceOfAlacrity");
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
	
	StanceOfAlacrity(oPC,oToB);
}
