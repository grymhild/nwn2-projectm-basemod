//////////////////////////////////////////
// Author: Drammel						//
// Date: 6/19/2009						//
// Title: TB_sa_stonefoot					//
// Description: Grants +2 AC as long as//
//	the player doesn't move.			//
//////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StonefootStance( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "STONEFOOTSTANCE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "STONEFOOTSTANCE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,163))
	{
		location lStonefoot = GetLocalLocation(oPC, "StonefootStance");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lStonefoot);

		if (fDist <= FeetToMeters(5.0f))
		{
			effect eAC = EffectACIncrease(2);
			eAC = ExtraordinaryEffect(eAC);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
			DelayCommand(6.0f, StonefootStance(oPC, oToB, iSpellId, iSerial));
		}
		else
		{
			DeleteLocalLocation(oPC, "StonefootStance");


			if (GetLocalInt(oToB, "Stance") == 163)
			{
				hkSetStance1(0,oPC);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance. Stonefoot Stance has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 163)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance. Stonefoot Stance has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "StonefootStance");
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
	
	SetLocalLocation(oPC, "StonefootStance", GetLocation(oPC));
	StonefootStance(oPC, oToB);
}
