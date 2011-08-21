//////////////////////////////////////////
// Author: Drammel						//
// Date: 6/19/2009						//
// Title: TB_sa_huntersns					//
// Description: Grants the feat Scent	//
//	while the Stance is active.			//
//////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void HuntersSense( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "HUNTERSSENSE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "HUNTERSSENSE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,174))
	{
		if (!GetHasFeat(FEAT_SCENT, oPC))
		{
			CSLWrapperFeatAdd(oPC, FEAT_SCENT, FALSE);
		}
		DelayCommand(6.0f, HuntersSense(oPC, oToB, iSpellId, iSerial));
	}
	else FeatRemove(oPC, FEAT_SCENT);
}


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------

	if (!GetHasFeat(FEAT_SCENT, oPC))
	{
		HuntersSense(oPC, oToB);
	}
}
