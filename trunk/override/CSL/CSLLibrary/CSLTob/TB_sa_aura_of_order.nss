//////////////////////////////////////////////////
// Author: Drammel								//
// Date: 10/8/2009								//
// Title: TB_sa_aura_of_order						//
// Description: This stance allows you to treat//
// a potential d20 result as an 11. You use 	//
// this ability immediately when rolling a d20.//
// You use this ability once per round on 	//
// either an attack roll or a saving throw. 	//
// Using this ability does not take an action. //
//////////////////////////////////////////////////

	/* Most of the work of this function is handled in nw_i0_spells
	and bot9s_inc_maneuvers under the functions HkSavingThrow,
	HkGetReflexAdjustedDamage, and TOBStrikeAttackRoll. This script
	only sets the combat override state and 'once per round'
	status on the player.*/
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_combat_overrides"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AuraOfPerfectOrder( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "AURAOFPERFECTORDER", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "AURAOFPERFECTORDER" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,29))
	{
		SetLocalInt(oPC, "AuraOfPerfectOrderCheck", 1); // Status check to prevent extra callbacks of this function from running.

		if (GetLocalInt(oPC, "AuraOfPerfectOrder") == 1)
		{
			int nCHA;

			nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);

			if (nCHA < 0)
			{
				nCHA = 0;
			}

			if (nCHA > 0)
			{
				effect ePerfect = EffectSkillIncrease(SKILL_ALL_SKILLS, nCHA);
				ePerfect = ExtraordinaryEffect(ePerfect);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePerfect, oPC, 6.0f);
			}
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else TOBManageCombatOverrides(TRUE);

		SetLocalInt(oPC, "AuraOfPerfectOrder", 1);
		DelayCommand(6.0f, AuraOfPerfectOrder(oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "AuraOfPerfectOrder");
		DeleteLocalInt(oPC, "AuraOfPerfectOrderCheck");
		TOBProtectedClearCombatOverrides(oPC);
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

	if (GetLocalInt(oPC, "AuraOfPerfectOrderCheck") == 0)
	{
		effect eOrder = EffectVisualEffect(VFX_TOB_AURA_ORDER);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOrder, oPC, 6.0f);
		AuraOfPerfectOrder(oPC, oToB);
	}
}