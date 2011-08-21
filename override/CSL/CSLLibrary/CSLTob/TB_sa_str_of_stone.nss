//////////////////////////////////////////////
// Author: Drammel							//
// Date: 10/29/2009						//
// Title: TB_sa_str_of_stone					//
// Description: While you are in this 	//
// stance, you focus your efforts on 		//
// preventing any devastating attacks from //
// penetrating your defenses. You are 	//
// immune to critical hits while you are in//
// this stance. This stance immediately 	//
// ends if you move more than 5 feet for 	//
// any reason. 						//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StrengthOfStone( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "STRENGTHOFSTONE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "STRENGTHOFSTONE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,164))
	{
		location lStrStone = GetLocalLocation(oPC, "StrengthOfStone");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lStrStone);

		if (fDist <= FeetToMeters(5.0f))
		{
			effect eStrStone = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
			eStrStone = ExtraordinaryEffect(eStrStone);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrStone, oPC, 6.0f);
			DelayCommand(6.0f, StrengthOfStone(oPC, oToB, iSpellId, iSerial));
		}
		else
		{
			DeleteLocalLocation(oPC, "StrengthOfStone");


			if (GetLocalInt(oToB, "Stance") == 164)
			{
				hkSetStance1(0,oPC);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Strength of Stone. Strength of Stone has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 164)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Strength of Stone. Strength of Stone has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "StrengthOfStone");
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
	
	SetLocalLocation(oPC, "StrengthOfStone", GetLocation(oPC));
	StrengthOfStone(oPC, oToB);
}
