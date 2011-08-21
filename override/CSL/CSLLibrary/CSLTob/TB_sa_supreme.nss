//////////////////////////////////////////
// Author: Drammel						//
// Date: 10/27/2009					//
// Title: TB_sa_supreme					//
// Description: While you are in this //
// stance, you gain damage reduction 	//
// 5/- against any opponent that does //
// not catch you flat-footed. To gain //
// this benefit, you must be proficient//
// with the weapon you carry. You gain //
// this benefit while unarmed only if //
// you have the Improved Unarmed Strike//
// feat. 						//
//////////////////////////////////////////
//#include "bot9s_armor"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void SupremeBladeParry( object oPC = OBJECT_SELF, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SUPREMEBLADEPARRY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SUPREMEBLADEPARRY" );
	}
	
	if (hkStanceGetHasActive(oPC,95))
	{

		if (!CSLGetIsFlatFooted(oPC))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

			if ((GetIsObjectValid(oWeapon)) || ((!GetIsObjectValid(oWeapon)) && (GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oPC))))
			{
				effect eSupreme = EffectDamageReduction(5, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
				eSupreme = ExtraordinaryEffect(eSupreme);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSupreme, oPC, 6.0f);
			}
		}

		DelayCommand(6.0f, SupremeBladeParry(oPC, iSpellId, iSerial));
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
	
	SupremeBladeParry(oPC);
}
