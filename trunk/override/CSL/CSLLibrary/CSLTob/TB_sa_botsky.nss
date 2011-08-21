//////////////////////////////////////////////////////
// Author: Drammel									//
// Date: 10/28/2009								//
// Title: TB_sa_botsky								//
// Description: You gain immunity to entanglement //
// and from the effects of traps. You must keep at //
// least one hand empty while using this stance. 	//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void BalanceOnTheSky( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "BALANCEONTHESKY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "BALANCEONTHESKY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,117))
	{
		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

		if (!GetIsObjectValid(oOffHand))
		{
			effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
			effect eTraps = EffectImmunity(IMMUNITY_TYPE_TRAP);
			effect eBalance = EffectLinkEffects(eEntangle, eTraps);
			eBalance = SupernaturalEffect(eBalance);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBalance, oPC, 6.0f);
		}

		DelayCommand(6.0f, BalanceOnTheSky(oPC, oToB, iSpellId, iSerial));
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
	
	BalanceOnTheSky(oPC, oToB);
}
