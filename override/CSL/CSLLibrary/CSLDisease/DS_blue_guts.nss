
//Blueguts 	DC14 	Incubation 1d3 days 		1d4 Str dam
//#include "prc_alterations"
//#include "spinc_common"

#include "_SCInclude_Disease"
#include "_SCInclude_Necromancy"
#include "_HkSpell"

void main()
{	
	
	object oPC = OBJECT_SELF;
	int nDC = 14;
	effect eDisease = GetFirstEffect(oPC);

	while(GetIsEffectValid(eDisease))
	{
		if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
		break;

		eDisease = GetNextEffect(oPC);

	}// end while - loop through all effects

	// Do the save

	if(HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE))
	{
		// Get the value of the previous save
		if(GetLocalInt(oPC, "SPELL_BLUE_GUTS_SAVED"))
		{
			// 2 saves in row, oPC recovers from the disease
			// Remove the disease and relevant locals.
			RemoveEffect(oPC, eDisease);
			DeleteLocalInt(oPC, "SPELL_BLUE_GUTS_SAVED");
			CSLDeletePersistentVariable(oPC, "PRC_Has_Blue_Guts");
		}

		else
		{
			// Note down the successful save
			SetLocalInt(oPC, "SPELL_BLUE_GUTS_SAVED", TRUE);
		}
	}
	else
	{
		// Note down the failed save
		SetLocalInt(oPC, "SPELL_BLUE_GUTS_SAVED", FALSE);

		CSLSetPersistentInt(oPC, "PRC_Has_Blue_Guts", 1);

		//Cause damage
		int nDam = d4();

		SCApplyAbilityDrainEffect( ABILITY_STRENGTH, nDam, oPC, DURATION_TYPE_TEMPORARY, -1.0f);
	}
}