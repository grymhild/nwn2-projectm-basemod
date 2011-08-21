//::///////////////////////////////////////////////
//:: Name 	Addiction: Devil Weed
//:: FileName sp_addct_dw.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Devil Weed

Author: 	Tenjac
Created: 	5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Name 	Addiction: Baccaran
//:: FileName sp_addct_bac.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Baccaran

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
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_Devilweed_DC");
	int nSatiation = CSLGetPersistentInt(oPC, "PRC_DevilweedSatiation") ;

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) && (nSatiation < 1))

	{
		//1d3 Dex
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d3(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);
		CSLDeletePersistentVariable(oPC, "PRC_PreviousDevilweedSave");
	}

		else
		{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousDevilweedSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);


			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousDevilweedSave");
						break;
					}
				}
				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_PreviousDevilweedSave", 1);
		}

		//Handle DC increase from addiction.
		if(nSatiation < 1)
		{
			CSLSetPersistentInt(oPC, "PRC_Addiction_Devilweed_DC", (nDC + 5));
		}

		//Decrement satiation
		nSatiation--;
		CSLSetPersistentInt(oPC, "PRC_DevilweedSatiation", nSatiation);
	}
}