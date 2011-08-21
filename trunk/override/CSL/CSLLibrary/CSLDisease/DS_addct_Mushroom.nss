//::///////////////////////////////////////////////
//:: Name 	Addiction: Mushroom Powder
//:: FileName sp_addct_msh.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Mushroom Powder

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
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_Mushroom_DC");
	int nSatiation = CSLGetPersistentInt(oPC, "PRC_MushroomSatiation");

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
		(!CSLGetPersistentInt(oPC, "PRC_MushroomSatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d4(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		SCApplyAbilityDrainEffect( ABILITY_WISDOM, d4(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);

		CSLDeletePersistentVariable(oPC, "PRC_PreviousMushroomSave");
	}

	else
	{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousMushroomSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);

			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_MUSHROOM_POWDER)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousMushroomSave");
						break;
					}
				}

				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_PreviousMushroomSave", 1);
		}
	}

	//Handle DC increase from addiction.
	if(!CSLGetPersistentInt(oPC, "PRC_MushroomSatiation"))
	{
		CSLSetPersistentInt(oPC, "PRC_Addiction_Mushroom_DC", (nDC + 5));
	}

	//Decrement satiation
	nSatiation--;
	CSLSetPersistentInt(oPC, "PRC_MushroomSatiation", nSatiation);
}