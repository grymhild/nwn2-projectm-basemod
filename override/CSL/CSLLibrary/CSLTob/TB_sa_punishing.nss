//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/12/2009							//
//	Title: TB_sa_punishing						//
//	Description: While you are in this 		//
//	stance, you deal an extra 1d6 points of	//
//	damage with all melee attacks. You also //
//	take a –2 penalty to AC, because this 	//
//	fighting stance emphasizes power over a //
//	defensive posture.						//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "tob_x2_inc_itemprop"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void PunishingStance( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "PUNISHINGSTANCE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "PUNISHINGSTANCE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,90))
	{
		
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		if ((GetIsObjectValid(oWeapon) == FALSE) || (GetWeaponRanged(oWeapon) == TRUE))
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		}

		int nWeapon = GetWeaponType(oWeapon);
		int nDamageType;

		if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
		{
			nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
		}
		else if (nWeapon == WEAPON_TYPE_SLASHING)
		{
			nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
		}
		else nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;

		itemproperty iWeapon = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d6);
		CSLSafeAddItemProperty(oWeapon, iWeapon, 5.99f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

		effect eAC = EffectACDecrease(2);
		eAC = ExtraordinaryEffect(eAC);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
		DelayCommand(6.0f, PunishingStance(oPC, oToB, iSpellId, iSerial));
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
	
	PunishingStance(oPC, oToB);
}
