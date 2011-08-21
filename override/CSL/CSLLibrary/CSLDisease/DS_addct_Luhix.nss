//::///////////////////////////////////////////////
//:: Name 	Addiction: Luhix
//:: FileName sp_addct_lhx.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Luhix

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
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_Luhix_DC");

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
		(!CSLGetPersistentInt(oPC, "PRC_LuhixSatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d8(1), oPC, DURATION_TYPE_TEMPORARY,  -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_WISDOM, d8(1), oPC, DURATION_TYPE_TEMPORARY,  -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, d6(1), oPC, DURATION_TYPE_TEMPORARY,  -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_STRENGTH, d6(1), oPC, DURATION_TYPE_TEMPORARY,  -1.0f, FALSE);

		CSLDeletePersistentVariable(oPC, "PRC_PreviousLuhixSave");
	}

	else
	{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousLuhixSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = SupernaturalEffect(EffectDisease(DISEASE_LUHIX_ADDICTION));

			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_LUHIX)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousLuhixSave");
						break;
					}
				}

				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_reviousLuhixSave", 1);
		}
	}

	//Handle DC increase from addiction.
	if(!CSLGetPersistentInt(oPC, "PRC_LuhixSatiation"))
	{
		CSLSetPersistentInt(oPC, "PRC_Addiction_Luhix_DC", (nDC + 5));
	}

	//Remove the int, as it only lasts 1 day
	CSLDeletePersistentVariable(oPC, "PRC_LuhixSatiation");
}
