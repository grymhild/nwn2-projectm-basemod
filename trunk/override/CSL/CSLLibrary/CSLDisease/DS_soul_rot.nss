
//Soul Rot 	DC 23 		Incubation 1d8 days 	1d6 WIS, 1d6 CHA
//#include "spinc_common"

#include "_SCInclude_Disease"
#include "_SCInclude_Necromancy"
#include "_HkSpell"

void main()
{	
	
	object oPC = OBJECT_SELF;
	int nDC = 23;
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
		if(GetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED"))
		{
			// 2 saves in row, oPC recovers from the disease
			// Remove the disease and relevant locals.
			RemoveEffect(oPC, eDisease);
			DeleteLocalInt(oPC, "SPELL_SOUL_ROT_SAVED");
			CSLDeletePersistentVariable(oPC, "PRC_Has_Soul_Rot");
		}

		else
		{
			// Note down the successful save
			SetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED", TRUE);
		}
	}
	else
	{
		// Note down the failed save
		SetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED", FALSE);

		//Set int to signify disease
		CSLSetPersistentInt(oPC, "PRC_Has_Soul_Rot", 1);

		//Cause damage
		int nDam = d6();

		SCApplyAbilityDrainEffect( ABILITY_WISDOM, nDam, oPC, DURATION_TYPE_TEMPORARY, -1.0f);
		SCApplyAbilityDrainEffect( ABILITY_CHARISMA, nDam, oPC, DURATION_TYPE_TEMPORARY, -1.0f);
	}
}