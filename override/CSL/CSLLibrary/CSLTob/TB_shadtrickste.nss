//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/29/2009									//
//	Title: TB_shadtrickste							//
//	Description: While in a Shadow Hand stance, gain//
//	+2 to the DC of illusion spells cast and +2 	//
//	damage to sneak attacks.						//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

// The boost to illusion spell DC is covered in the override of tob_i0_spells.

void ShadowTrickster( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SHADOWTRICKSTER", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SHADOWTRICKSTER" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6507);
	
	if ( hkStanceGetHasActive( oPC, 116, 117, 119, 122, 129, 139 ) )
	{
		object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oPC);

		if (CSLIsTargetValidForSneakAttack(oCreature, oPC))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			int nWeapon = CSLGetWeaponDamageType(oWeapon);
			effect eTrickster = EffectDamageIncrease(DAMAGE_BONUS_2, nWeapon);
			eTrickster = ExtraordinaryEffect(eTrickster);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrickster, oPC, 6.0f);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, ShadowTrickster(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6507, oPC))
	{
		ShadowTrickster(oPC); //Only runs if the effect is no longer on the player.
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