//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/10/2009									//
//	Title: TB_ct_lightning_rec							//
//	Description: If one of your melee attacks 		//
// misses, you can initiate this maneuver to reroll//
// that attack roll with a +2 bonus. Most of this //
// function's work is handled in TOBStrikeAttackRoll. //
//////////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void LightningRecovery(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "LIGHTNINGRECOVERY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "LIGHTNINGRECOVERY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}

	if (hkCounterGetHasActive(oPC,86))
	{
		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else TOBManageCombatOverrides(TRUE);

		DelayCommand(6.0f, LightningRecovery(oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		TOBProtectedClearCombatOverrides(oPC);
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

	SetLocalInt(oPC, "LightningRecovery", 1);
	TOBExpendManeuver(86, "C");
	LightningRecovery(oPC, oToB);
}
