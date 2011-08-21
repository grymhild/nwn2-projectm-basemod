//////////////////////////////////////////////////
// Author: Drammel								//
// Date: 9/20/2009								//
// Title: TB_sa_step_moth 						//
// Description: While you are in this stance, //
// your speed drops to one third of its normal //
// value and you gain a +2 bonus to dexterity. //
// After you end this stance, if you are 		//
// equipped with a Shadow Hand weapon, for one //
// round your speed drops to two thirds of its //
// normal value and you gain a +8 bonus to 	//
// dexterity. 							//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StepOfTheDancingMoth( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "STEPOFTHEDANCINGMOTH", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "STEPOFTHEDANCINGMOTH" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,139))
	{
		effect eSlow = EffectMovementSpeedDecrease(33);
		effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
		effect eDancingMoth = EffectLinkEffects(eSlow, eDex);
		eDancingMoth = ExtraordinaryEffect(eDancingMoth);
		eDancingMoth = SetEffectSpellId(eDancingMoth, 6553);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDancingMoth, oPC, 5.99f);
		SetLocalInt(oPC, "DancingMoth", 1);
		DelayCommand(5.99f, DeleteLocalInt(oPC, "DancingMoth"));
		DelayCommand(6.0f, StepOfTheDancingMoth(oPC, oToB, iSpellId, iSerial));
	}
	else if (TOBGetIsShadowHandWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
	{
		effect eSlow = EffectMovementSpeedDecrease(67);
		effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 8);
		effect eDancingMoth = EffectLinkEffects(eSlow, eDex);
		eDancingMoth = ExtraordinaryEffect(eDancingMoth);
		eDancingMoth = SetEffectSpellId(eDancingMoth, 6553);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDancingMoth, oPC, 6.0f);
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

	if (GetLocalInt(oPC, "DancingMoth") == 0)
	{
		StepOfTheDancingMoth(oPC, oToB);
	}
	else SendMessageToPC(oPC, "<color=red>You must wait until next round before you can initiate Step of the Dancing Moth again.</color>");
}
