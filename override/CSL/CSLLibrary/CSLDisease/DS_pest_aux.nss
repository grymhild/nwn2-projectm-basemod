//::///////////////////////////////////////////////
//:: Pestilence
//:: sp_pest_aux.nss
//:://////////////////////////////////////////////
/*
Disease 24h script for Pestilence.
Does check for recovery. Deals ability drain.
Removes the contagiousness aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 26, 2004
//:://////////////////////////////////////////////
//#include "spinc_common"
#include "_SCInclude_Disease"
#include "_SCInclude_Necromancy"


#include "_HkSpell"

void main()
{	
	
	//SpawnScriptDebugger();

	object oCaster = GetLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CASTER");
	int nDC 		= GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_DC");
	int nCasterLvl = GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_CASTERLVL");

	//Find the disease effect
	effect eDisease = GetFirstEffect(OBJECT_SELF);
	while(GetIsEffectValid(eDisease))
	{
		if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
			break;

		eDisease = GetNextEffect(OBJECT_SELF);
	}// end while - loop through all effects

	// Do the save
	if(HkSavingThrow(SAVING_THROW_FORT, OBJECT_SELF, nDC, SAVING_THROW_TYPE_DISEASE, oCaster))
	{
		// Get the value of the previous save
		//int bPrevSave = GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SAVED");
		if(GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SAVED"))
		{
			// 2 saves in row, OBJECT_SELF recovers from the disease
			// Remove the disease and relevant locals.
			RemoveEffect(OBJECT_SELF, eDisease);
			DeleteLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SAVED");

			// Remove the - now useless - locals
			DeleteLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_DC");
			DeleteLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_CASTERLVL");
			DeleteLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SPELLPENETRATION");
			DeleteLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CASTER");
			DeleteLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_DO_ONCE");
		}// end if - previous save was success
		else
		{
			// Note down the successful save
			SetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SAVED", TRUE);
		}// end else
	}// end if - successful save
	else
	{
		// Note down the failed save
		SetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SAVED", FALSE);

		//Cause damage
		int nDam = d4();
		//effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
		//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, OBJECT_SELF, 0.0f, FALSE, SPELL_PESTILENCE, nCasterLvl, oCaster);
		SCApplyAbilityDrainEffect(ABILITY_CONSTITUTION, nDam, OBJECT_SELF, DURATION_TYPE_PERMANENT, 0.0f, FALSE, SPELL_PESTILENCE, oCaster);
	}// end else - failed save
}