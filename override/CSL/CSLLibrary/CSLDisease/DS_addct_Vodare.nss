//::///////////////////////////////////////////////
//:: Name 	Addiction: Vodare
//:: FileName sp_addct_vdr.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Vodare

Author: 	Tenjac
Created: 	5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"

#include "_SCInclude_Disease"
#include "_SCInclude_Necromancy"
#include "_HkSpell"

void main()
{	
	
	object oPC = OBJECT_SELF;
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_Vodare_DC");
	int nSatiation = CSLGetPersistentInt(oPC, "PRC_VodareSatiation");

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
		(!CSLGetPersistentInt(oPC, "PRC_VodareSatiation")))
	{
		//1d6 Dex, 1d6 Wis, 1d2 Con
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d6(1), oPC,DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_WISDOM, d6(1), oPC,DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, d2(1), oPC,DURATION_TYPE_TEMPORARY, -1.0f, FALSE);

		CSLDeletePersistentVariable(oPC, "PRC_PreviousVodareSave");
	}

	else
	{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousVodareSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = SupernaturalEffect(EffectDisease(DISEASE_VODARE_ADDICTION));

			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousVodareSave");
						break;
					}
				}

				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_PreviousVodareSave", 1);
		}
	}

	//Handle DC increase from addiction.
	if(!CSLGetPersistentInt(oPC, "PRC_VodareSatiation"))
	{
		CSLSetPersistentInt(oPC, "PRC_Addiction_Vodare_DC", (nDC + 5));
	}

	//Decrement satiation
	nSatiation--;
	CSLSetPersistentInt(oPC, "PRC_VodareSatiation", nSatiation);
}