//::///////////////////////////////////////////////
//:: Name 	Addiction: Agony
//:: FileName sp_addct_ag.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Agony

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
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_Agony_DC");

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
		(!CSLGetPersistentInt(oPC, "PRC_AgonySatiation")))
	{
		//1d6 Dex, 1d6 Wis, 1d6 Con
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d6(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_WISDOM, d6(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, d6(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);

		CSLDeletePersistentVariable(oPC, "PRC_PreviousAgonySave");
	}

	else
	{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousAgonySave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);

			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_AGONY)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousAgonySave");
						break;
					}
				}
				eDisease = GetNextEffect(OBJECT_SELF);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_PreviousAgonySave", 1);
		}
	}

	//Handle DC increase from addiction.
	if(!CSLGetPersistentInt(oPC, "PRC_AgonySatiation"))
	{
		CSLSetPersistentInt(oPC, "PRC_Addiction_Agony_DC", (nDC + 5));
	}

	//Remove the int, as it only lasts 1 day
	CSLDeletePersistentVariable(oPC, "PRC_AgonySatiation");
}

