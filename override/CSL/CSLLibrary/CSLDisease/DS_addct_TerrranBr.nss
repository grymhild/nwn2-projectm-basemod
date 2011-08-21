//::///////////////////////////////////////////////
//:: Name 	Addiction: Terran Brandy
//:: FileName sp_addct_tb.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Terran Brandy

Author: 	Tenjac
Created: 	5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Name 	Addiction: Sannish
//:: FileName sp_addct_snh.nss
//:://////////////////////////////////////////////
/** Script for addiction to the drug Sannish

Author: 	Tenjac
Created: 	5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
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
	int nDC 	= CSLGetPersistentInt(oPC, "PRC_Addiction_TerranBrandy_DC");
	int nSatiation = CSLGetPersistentInt(oPC, "PRC_TerranBrandySatiation");

	//make save vs nasty bad things or have satiation
	if(!HkSavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER ) && (!CSLGetPersistentInt(oPC, "PRC_TerranBrandySatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		SCApplyAbilityDrainEffect( ABILITY_DEXTERITY, d3(1), oPC, DURATION_TYPE_TEMPORARY, -1.0f, FALSE);

		CSLDeletePersistentVariable(oPC, "PRC_PreviousTerranBrandySave");
	}

	else
	{
		//Two successful saves
		if(CSLGetPersistentInt(oPC, "PRC_PreviousTerranBrandySave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = SupernaturalEffect(EffectDisease(DISEASE_TERRAN_BRANDY_ADDICTION));

			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						CSLDeletePersistentVariable(oPC, "PRC_PreviousTerranBrandySave");
						break;
					}
				}

				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			CSLSetPersistentInt(oPC, "PRC_PreviousTerranBrandySave", 1);
		}
	}

	//Handle DC increase from addiction.
	if(!CSLGetPersistentInt(oPC, "PRC_TerranBrandySatiation"))
	{
		CSLSetPersistentInt(oPC, "PRC_Addiction_TerranBrandy_DC", (nDC + 5));
	}

	//Decrement satiation
	nSatiation--;
	CSLSetPersistentInt(oPC, "PRC_TerranBrandySatiation", nSatiation);
}