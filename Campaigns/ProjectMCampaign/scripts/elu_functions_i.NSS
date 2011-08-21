#include "csl_sort_i"
#include "_HkSpell"
#include "csl_core_i"
#include "hcr2_debug_i"
#include "_SCInclude_Class"

const string SKILL_LEVELS_BOUGHT = "SKILL_LEVELS_BOUGHT";
const string LAST_SELECTED_CLASS = "LAST_SELECTED_CLASS";
const string CLASS_DATA_POINT = "CLASS_DATA_POINT";
const string PRELEVELUP_FLAG = "PRELEVELUP_FLAG";
const string CANCELLEVELUP_FLAG = "CANCELLEVELUP_FLAG";
const string RACIAL_ECL = "RACIAL_ECL";
const string LVL_STATBUMP = "LVL_STATBUMP";

//Returns the minimum XP required to attain nLevel
int GetMinimumXPRequiredForLevel(int nLevel, object oChar)
{
	if (nLevel == 1)
		return 0;
	int nECL = GetLocalInt(oChar, RACIAL_ECL);
	int nMin = ((nLevel+nECL) - 1) * (nLevel+nECL) * 500;
	return nMin;
}

int GetConBonusPoints(object oChar)
{
	int nConAdj = StringToInt(Get2DAString("racialsubtypes", "ConAdjust", GetSubRace(oChar)));
	int nPurchasedCon = 0;
	if (GetLocalInt(oChar, LVL_STATBUMP) == 3)
		nPurchasedCon = 1;
	int nConScore = GetAbilityScore(oChar, ABILITY_CONSTITUTION, TRUE) + nConAdj + nPurchasedCon;
	int nBonusPoints = (nConScore / 2) - 5;
	return nBonusPoints;
}

int GetIntBonusPoints(object oChar)
{
	int nIntAdj = StringToInt(Get2DAString("racialsubtypes", "IntAdjust", GetSubRace(oChar)));
	int nPurchasedInt = 0;
	if (GetLocalInt(oChar, LVL_STATBUMP) == 4)
		nPurchasedInt = 1;
	int nIntScore = GetAbilityScore(oChar, ABILITY_INTELLIGENCE, TRUE) + nIntAdj + nPurchasedInt;
	int nBonusPoints = (nIntScore / 2) - 5;
	return nBonusPoints;
}

//The purpose of this function is to load specific 2DA related data
//onto a specific data point to avoid using Get2DAString calls from
//gui script, which can cause slow GUIs.
void LoadClass2DAData()
{
	WriteTimestampedLogEntry("Starting LoadClass2DAData...");
	object oCDP = CSLGetDataPoint(CLASS_DATA_POINT);
	int nCount = GetNum2DARows("classes");
	int i;
	for (i = 0; i < nCount; i++)
	{
		string sPlayerClass = Get2DAString("classes", "PlayerClass", i);
		if (sPlayerClass == "1")
		{
			string sStrRefID = Get2DAString("classes", "Name", i);
			string sRowName = GetStringByStrRef(StringToInt(sStrRefID));
			SetLocalString(oCDP, IntToString(i), sRowName);
		}
	}
	WriteTimestampedLogEntry("Finished LoadClass2DAData...");
}

int GetCasterLevelAdjustment(object oPC, int nBestCasterClass, int nLevel, int nClass1, int nClass2, int nClass3, int nClass4,
						   int nClassLvl1, int nClassLvl2, int nClassLvl3, int nClassLvl4, int nSelectedClass)
{
	int nAdj = 0;
	int nSelectedClassLvl = nClassLvl1;
	if (nSelectedClass == nClass2)
		nSelectedClassLvl = nClassLvl2;
	else if (nSelectedClass == nClass3)
		nSelectedClassLvl = nClassLvl3;
	else if (nSelectedClass == nClass4)
		nSelectedClassLvl = nClassLvl4;

	string sSpGain = Get2DAString("classes", "SpellGainTable", nSelectedClass);

	if (sSpGain != "****")
	{
		nAdj = StringToInt(Get2DAString(sSpGain, "NumSpellLevels", nSelectedClassLvl - 1)) > 0;
		if (nBestCasterClass != nSelectedClass && nBestCasterClass != 255)
			nAdj = 0;
	}
	else
	{
		string sBonusCasterLvlTable = Get2DAString("classes", "BonusSpellCasterLevelTable", nSelectedClass);

		if (sBonusCasterLvlTable != "****")
		{
			nAdj = StringToInt(Get2DAString(sBonusCasterLvlTable, "GrantsBonusSpellcasterLevel", nSelectedClass - 1)) > 0;
			if (nAdj > 0)
			{
				string sFeatMap = Get2DAString("classes", "BonusCasterFeatByClassMap", nSelectedClass);
				int nSpellCasterFeat = StringToInt(Get2DAString(sFeatMap, "SpellCasterFeat", nBestCasterClass));
				if (nSpellCasterFeat <= 0 || GetHasFeat(nSpellCasterFeat, oPC, TRUE) == FALSE)
					nAdj = 0;
			}
		}
	}
	return nAdj;
}

int GetAdjustedSpellLevel(object oPC, int nAdjBestCasterLvl, int nBestCasterClass, int nWis, int nInt, int nCha)
{
	int nSpellLevel = 0;
	string sSpGain = Get2DAString("classes", "SpellGainTable", nBestCasterClass);
	if (sSpGain != "****")
	{
		nSpellLevel = StringToInt(Get2DAString(sSpGain, "NumSpellLevels", nAdjBestCasterLvl)) - 1;
		string sSpellStat = Get2DAString("classes", "SpellAbil", nBestCasterClass);
		int nSpellAbl = nWis;
		if (sSpellStat == "INT")
			nSpellAbl = nInt;
		else if (sSpellStat == "CHA")
			nSpellAbl = nCha;

		if (nSpellAbl - 10 < nSpellLevel)
			nSpellLevel = nSpellAbl - 10;
	}
	return nSpellLevel;
}

int GetAdjustedBAB(object oPC, int nSelectedClass, int nPreSelectedClassLvl)
{
	int nPreSelectedBAB;
	string sBAB = Get2DAString("classes", "AttackBonusTable", nSelectedClass);
	if (nPreSelectedClassLvl > 0)
		nPreSelectedBAB = StringToInt(Get2DAString(sBAB, "BAB", nPreSelectedClassLvl - 1));
	int nSelectedBAB = StringToInt(Get2DAString(sBAB, "BAB", nPreSelectedClassLvl));
	int nBAB = GetBaseAttackBonus(oPC);
	return nBAB + (nSelectedBAB - nPreSelectedBAB);
}

int GetAdjustedSave(object oPC, int nSelectedClass, int nPreSelectedClassLvl, string sSaveThrowTable, string sSave)
{
	int nPreSelectedSaveThrow = 0;
	if (nPreSelectedClassLvl > 0)
		nPreSelectedSaveThrow = StringToInt(Get2DAString(sSaveThrowTable,sSave, nPreSelectedClassLvl - 1));
	int nSelectedSaveThrow = StringToInt(Get2DAString(sSaveThrowTable,sSave, nPreSelectedClassLvl));
	return (nSelectedSaveThrow - nPreSelectedSaveThrow);
}

int GetAdjustedFortSave(object oPC, int nSelectedClass, int nPreSelectedClassLvl, string sSaveThrowTable)
{
	int nAdjSave = GetAdjustedSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable, "FortSave");
	return GetFortitudeSavingThrow(oPC) + nAdjSave;
}

int GetAdjustedRefSave(object oPC, int nSelectedClass, int nPreSelectedClassLvl, string sSaveThrowTable)
{
	int nAdjSave = GetAdjustedSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable, "RefSave");
	return GetReflexSavingThrow(oPC) + nAdjSave;
}

int GetAdjustedWillSave(object oPC, int nSelectedClass, int nPreSelectedClassLvl, string sSaveThrowTable)
{
	int nAdjSave = GetAdjustedSave(oPC, nSelectedClass, nPreSelectedClassLvl, sSaveThrowTable, "WillSave");
	return GetWillSavingThrow(oPC) + nAdjSave;
}

int HasAsAddedFeat(object oPC, int nFeatID)
{
	int nAddedFeatCount = GetLocalInt(oPC, "AddedFeatCount");
	int i;
	string sFeatID = IntToString(nFeatID);
	for(i = 0; i < nAddedFeatCount; i++)
	{
		string sAddedFeat = GetLocalString(oPC, "AddedFeat" + IntToString(i));
		if (sAddedFeat == sFeatID)
			return TRUE;
	}
	return FALSE;
}

string GetClassSummaryText(object oChar)
{
	string sText = "Class: ";
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	sText += GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", nSelectedClassID))) + "\n\n";
	int nHP = GetConBonusPoints(oChar) + StringToInt(Get2DAString("classes", "HitDie", nSelectedClassID));
	if (GetHasFeat(FEAT_TOUGHNESS, oChar))
		nHP += 1;
	else if (HasAsAddedFeat(oChar, FEAT_TOUGHNESS))
		nHP +=  GetHitDice(oChar) + 1;
	//TODO: check for epic toughness and other HP adding feats.
	sText += "Hit Points Gained: +" + IntToString(nHP) + "\n";	
	return sText;
}

