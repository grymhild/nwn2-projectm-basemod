//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/20/2009	Happy Birthday Josh!	//
//	Title: TB_sa_chld_shadow					//
//	Description: Stance; Applies a minus 4	//
//	penalty to attack rolls to an creature	//
//	that is not targeting the initiator of	//
//	this stance.							//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ChildofShadow( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "CHILDOFSHADOW", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "CHILDOFSHADOW" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,119))
	{
		location lPC = GetLocation(oPC);
		location lLast = GetLocalLocation(oPC, "ChildofShadow");

		if (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f))
		{
			effect eShadow = EffectConcealment(20);
			eShadow = SupernaturalEffect(eShadow);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oPC, 6.0f);
		}

		DelayCommand(6.0f, ChildofShadow(oPC, oToB, iSpellId, iSerial));
	}
}

void RunCoSLocation(object oPC = OBJECT_SELF)
{

	if ( hkStanceGetHasActive(oPC,119) )
	{
		SetLocalLocation(oPC, "ChildofShadow", GetLocation(oPC));
		DelayCommand(6.0f, RunCoSLocation(oPC));
	}
	else DeleteLocalLocation(oPC, "ChildofShadow");
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

	SetLocalLocation(oPC, "ChildofShadow", GetLocation(oPC));
	DelayCommand(5.8f, ChildofShadow(oPC, oToB));
	RunCoSLocation(oPC);
}