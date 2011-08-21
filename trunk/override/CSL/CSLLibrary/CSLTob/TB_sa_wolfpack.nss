//////////////////////////////////////////////////////
// Author: Drammel									//
// Date: 10/30/2009								//
// Title: TB_sa_wolfpack								//
// Description: While you are in this stance, the //
// target of your attacks loses any benefit it 	//
// might have had from concealment. Additionally, //
// your opponent gains a vulnerability to the 	//
// attacks of your weapon equal to your skill in 	//
// Taunt. Your allies also benefit from this 	//
// stance, although the vulnerability placed on 	//
// your target is specific to your weapon. 		//
//////////////////////////////////////////////////////
//#include "bot9s_inc_feats"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void WolfPackTactics( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "WOLFPACKTACTICS", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "WOLFPACKTACTICS" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,186))
	{
		
		object oFoe = GetAttemptedAttackTarget();

		if (GetIsObjectValid(oFoe))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nDamageType = CSLGetWeaponDamageType(oWeapon);
			int nTaunt = CSLGetJumpSkill(oPC);
			effect eNegate = EffectConcealmentNegated();
			effect eDecrease = EffectDamageImmunityDecrease(nDamageType, nTaunt);
			effect eWolfPack = EffectLinkEffects(eNegate, eDecrease);
			eWolfPack = ExtraordinaryEffect(eWolfPack);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolfPack, oFoe, 6.0f);
		}

		DelayCommand(6.0f, WolfPackTactics(oPC, oToB, iSpellId, iSerial));
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
	
	WolfPackTactics( oPC);
}