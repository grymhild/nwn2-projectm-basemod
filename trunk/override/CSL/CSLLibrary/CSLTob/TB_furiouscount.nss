///////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 5/12/2009											//
//	Name: TB_furiouscount									//
//	Description: Grants a bonus to attack and damage based on//
//	the amount of points in the delayed damage pool.		//
///////////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void FuriousCounterstrike(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "FURIOUSCOUNTERSTRIKE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "FURIOUSCOUNTERSTRIKE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	int nPool = GetLocalInt(oToB, "DDPool");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, iSpellId);

	if ((nPool > 0) && (GetIsInCombat(oPC)))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nDamageType = CSLGetWeaponDamageType(oWeapon);
		int nDamagePool;

		if ((nPool > 0) && (nPool <= 9))
		{
			nDamagePool = DAMAGE_BONUS_1;
		}
		else if ((nPool > 9) && (nPool <= 14))
		{
			nDamagePool = DAMAGE_BONUS_2;
		}
		else if ((nPool > 14) && (nPool <= 19))
		{
			nDamagePool = DAMAGE_BONUS_3;
		}
		else if ((nPool > 19) && (nPool <= 24))
		{
			nDamagePool = DAMAGE_BONUS_4;
		}
		else if ((nPool > 24) && (nPool <= 29))
		{
			nDamagePool = DAMAGE_BONUS_5;
		}
		else if ((nPool > 29) && (nPool <= 34))
		{
			nDamagePool = DAMAGE_BONUS_6;
		}
		else if ((nPool > 34) && (nPool <= 39))
		{
			nDamagePool = DAMAGE_BONUS_7;
		}
		else if (nPool > 39)
		{
			nDamagePool = DAMAGE_BONUS_8;
		}

		effect eAttack = EffectAttackIncrease(nPool);
		effect eDamage = EffectDamageIncrease(nDamagePool, nDamageType);
		effect eFurious = EffectLinkEffects(eAttack, eDamage);
		eFurious = SupernaturalEffect(eFurious);
		eFurious = SetEffectSpellId(eFurious, iSpellId);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFurious, oPC, 6.0f, iSpellId);
	}
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f, iSpellId);
	
	DelayCommand(6.0f, FuriousCounterstrike(oPC, oToB, iSpellId, iSerial) );
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6532, oPC))
	{
		FuriousCounterstrike( oPC, oToB, 6532); //Only runs if the effect is no longer on the player.
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