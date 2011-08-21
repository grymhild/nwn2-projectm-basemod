//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/20/2009	Happy Birthday Josh!	//
//	Title: TB_sa_lead_charge					//
//	Description: Stance; Grants allies +2 vs//
//	will saves and +4 vs fear effects.		//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
//#include "bot9s_include"
//#include "tob_x2_inc_itemprop"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void LeadingtheCharge(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "LEADINGTHECHARGE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "LEADINGTHECHARGE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,195))
	{
		float fRange = FeetToMeters(60.0f);
		location lPC = GetLocation(oPC);
		location lFriend, lCurrent;
		object oFriend, oWeapon;
		itemproperty iWeapon;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		lFriend = GetLocalLocation(oFriend, "LeadingTheCharge");
		lCurrent = GetLocation(oFriend);

		while (GetIsObjectValid(oFriend))
		{
			if ((!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC) && (GetObjectHeard(oPC, oFriend)) && (lFriend != lCurrent) && (GetIsInCombat(oFriend)) && (!GetIsDead(oFriend)))
			{
				object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

				if (oRight == OBJECT_INVALID)
				{
					object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
					object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
					object oCrWeapon = GetLastWeaponUsed(oPC);
					object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oFriend); //Love for monks.

					if (GetIsObjectValid(oBite))
					{
						oWeapon = oBite;
					}
					else if (GetIsObjectValid(oRClaw))
					{
						oWeapon = oRClaw;
					}
					else if (GetIsObjectValid(oCrWeapon))
					{
						oWeapon = oCrWeapon;
					}
					else oWeapon = oArms;
				}
				else oWeapon = oRight;

				int nInitiator = TOBGetInitiatorLevel(oPC);
				int nDamage = CSLGetConstDamageBonusFromNumber(nInitiator);
				int nDamageType = CSLGetWeaponDamageType(oWeapon);

				iWeapon = ItemPropertyDamageBonus(nDamageType, nDamage);
				CSLSafeAddItemProperty(oWeapon, iWeapon, 6.0f);
				SetLocalLocation(oFriend, "LeadingTheCharge", lCurrent);
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
			lFriend = GetLocalLocation(oFriend, "LeadingTheCharge");
			lCurrent = GetLocation(oFriend);
		}
		DelayCommand(6.0f, LeadingtheCharge(oPC, oToB, iSpellId, iSerial));
	}
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
	
	LeadingtheCharge(oPC, oToB);
}