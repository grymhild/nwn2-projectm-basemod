//////////////////////////////////////////
// Author: Drammel						//
// Date: 6/26/2009						//
// Title: TB_sa_mspirit					//
// Description: With each successful	//
//	attack the player heals the weakest //
//	memeber of the party within 30ft.	//
//////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_combat_overrides"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void MartialSpirit( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "MARTIALSPIRIT", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "MARTIALSPIRIT" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}

	if (hkStanceGetHasActive(oPC,44))
	{
		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else
		{
			TOBManageCombatOverrides(TRUE);
		}

		DelayCommand(6.0f, MartialSpirit(oPC, oToB, iSpellId, iSerial));
	}
	else TOBProtectedClearCombatOverrides(oPC);
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
	
	MartialSpirit(oPC, oToB);
}
