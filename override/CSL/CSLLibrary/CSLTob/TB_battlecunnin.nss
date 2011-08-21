///////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 4/28/2009											//
//	Name: TB_battlecunnin										//
//	Description: Grants a damage bouns based on Int to any 	//
//	any target that is usually vaild for a sneak attack. Ie: //
//	flanked or flatfooted.									//
///////////////////////////////////////////////////////////////
//#include "bot9s_include"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void BattleCunning(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "BATTLECUNNING", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "BATTLECUNNING" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6526);

	if (GetIsInCombat(oPC))
	{
		object oFoe = GetAttackTarget(oPC);

		if ((CSLIsFlankValid(oPC, oFoe)) || (!GetIsInCombat(oFoe)))
		{
			int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);

			if (nIntelligence < 1)
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
				DelayCommand(1.0f, BattleCunning( oPC, oToB, iSpellId, iSerial ));
				return;
			}

			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			int nWeapon = GetWeaponType(oWeapon);
			int nDamageType = CSLGetWeaponDamageType(oWeapon);

			effect eDamage = EffectDamageIncrease(nIntelligence, nDamageType);
			eDamage = SupernaturalEffect(eDamage);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
			DelayCommand(6.0f, BattleCunning( oPC, oToB, iSpellId, iSerial ));
		}
		else
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
			DelayCommand(1.0f, BattleCunning( oPC, oToB, iSpellId, iSerial ));
		}
	}
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
		DelayCommand(1.0f, BattleCunning( oPC, oToB, iSpellId, iSerial ));
	}
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if (!TOBCheckRecursive(6526, oPC))
	{
		BattleCunning( oPC ); //Only runs if the effect is no longer on the player.
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