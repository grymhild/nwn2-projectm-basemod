//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 3/31/2009										//
//	Title: TB_rapidassualt								//
//	Description: During the first round of combat in	//
//	an encounter you gain +1d6 to melee weapon damage.	//
//////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "tob_x2_inc_itemprop"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void RapidAssault(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "RAPIDASSAULT", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "RAPIDASSAULT" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}	

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6511);

	if (GetLocalInt(oToB, "Encounter") == 1)
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

		if (GetCurrentHitPoints(oPC) > 0)
		{
			itemproperty iWeapon = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d6);
			CSLSafeAddItemProperty(oWeapon, iWeapon, 6.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RapidAssault(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6511, oPC))
	{
		RapidAssault(); //Only runs if the effect is no longer on the player.
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
	
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}