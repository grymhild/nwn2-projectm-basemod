#include "elu_functions_i"

const string SPENT_SKILL_POINTS = "SPENT_SKILL_POINTS";
const string BASE_SKILL_POINTS = "BASE_SKILL_POINTS";
const string SKILL_DATA_POINT = "SKILL_DATA_POINT";

int GetGUIAvailableSkillPoints(object oChar)
{
	int nSpentPoints = GetLocalInt(oChar, SPENT_SKILL_POINTS);
	int nBaseSkillPoints = GetLocalInt(oChar, BASE_SKILL_POINTS);
	int nBonusPoints = GetIntBonusPoints(oChar);
	int nPointsRemaining = GetSkillPointsRemaining(oChar);
	int bSkilled = GetHasFeat(1773, oChar);
	int nInitialPoints = nBaseSkillPoints + nBonusPoints + nPointsRemaining + bSkilled;
	if (nInitialPoints <= 0)
		nInitialPoints = 1;
	return nInitialPoints - nSpentPoints;
}

void SetGUIUnAllocatedSkillPoints(int nPoints)
{
	string sPointPool = IntToString(nPoints);
	SetGUIObjectText(OBJECT_SELF, "SCREEN_LEVELUP_SKILLS", "POINT_POOL_TEXT", -1, sPointPool);
	int bDisabled = (nPoints > 5);
	SetGUIObjectDisabled(OBJECT_SELF, "SCREEN_LEVELUP_SKILLS","CHOICE_NEXT", bDisabled);
}

void AdjustGUISkillRank(object oChar, int nSkillID, int nCurSkillLevelsBought, int nCurSpentPoints, int nSkillLevelCost)
{
	nCurSpentPoints += nSkillLevelCost;
	nCurSkillLevelsBought += (nSkillLevelCost < 0 ? -1 : 1);
	SetLocalInt(oChar, SKILL_LEVELS_BOUGHT + IntToString(nSkillID), nCurSkillLevelsBought);
	SetLocalInt(oChar, SPENT_SKILL_POINTS, nCurSpentPoints);
	int nRank = GetSkillRank(nSkillID, oChar, TRUE);
	string sTextFields = "SKILL_RANK=" + IntToString(nRank + nCurSkillLevelsBought);
	ModifyListBoxRow(oChar, "SCREEN_LEVELUP_SKILLS", "CUSTOM_SKILLPANE_LIST",IntToString(nSkillID),sTextFields, "", "", "");
}

int HasSkillKnowledgeFeat(object oChar, string sSkillID)
{
	int nSkillID = StringToInt(sSkillID);
	switch (nSkillID)
	{
		case 1: return GetHasFeat(2296, oChar);
		case 2: return GetHasFeat(2297, oChar);
		case 3: return GetHasFeat(2298, oChar);
		case 4: return GetHasFeat(2299, oChar);
		case 5: return GetHasFeat(2300, oChar);
		case 6: return GetHasFeat(2301, oChar);
		case 7: return GetHasFeat(2302, oChar);
		case 8: return GetHasFeat(2303, oChar);
		case 9: return GetHasFeat(2304, oChar);
		case 10: return GetHasFeat(2305, oChar);
		case 11: return GetHasFeat(2306, oChar);
		case 12: return GetHasFeat(2307, oChar);
		case 13: return GetHasFeat(2308, oChar);
		case 14: return GetHasFeat(2309, oChar);
		case 15: return GetHasFeat(2310, oChar);
		case 16: return GetHasFeat(2311, oChar);
		case 17: return GetHasFeat(2312, oChar);
		case 18: return GetHasFeat(2313, oChar);
		case 19: return GetHasFeat(2314, oChar);
		case 20: return GetHasFeat(2315, oChar);
		case 21: return GetHasFeat(2316, oChar);
		case 22: return GetHasFeat(2317, oChar);
		case 23: return GetHasFeat(2318, oChar);
		case 24: return GetHasFeat(2319, oChar);
		case 25: return GetHasFeat(2320, oChar);
		case 26: return GetHasFeat(2321, oChar);
		case 27: return GetHasFeat(2322, oChar);
		case 28: return GetHasFeat(2323, oChar);
		case 29: return GetHasFeat(2324, oChar);
	}
	return FALSE;
}

int SpendSkillPoints(int nPointsRemaining, object oChar, string sClassSkill, string sSkillID)
{
	int nSkillLevelsBought = GetLocalInt(oChar, SKILL_LEVELS_BOUGHT + sSkillID);
	int nRank = GetSkillRank(StringToInt(sSkillID), oChar, TRUE);
	int nLevel = GetHitDice(oChar) + 1;
	int nSpentPoints = GetLocalInt(oChar, SPENT_SKILL_POINTS);
	//check for Skill Knowledge feats
	//if (sClassSkill == "0" && HasSkillKnowledgeFeat(oChar, sSkillID))
	//	sClassSkill = "1";
	if (sClassSkill == "1")
	{
		if (nRank + nSkillLevelsBought < nLevel + 3)
		{
			int nLevelsToBuy = (nLevel + 3) - (nRank + nSkillLevelsBought);
			if (nLevelsToBuy > nPointsRemaining)
				nLevelsToBuy = nPointsRemaining;
			nPointsRemaining -= nLevelsToBuy;
			SetLocalInt(oChar, SKILL_LEVELS_BOUGHT + sSkillID, nSkillLevelsBought + nLevelsToBuy);
			SetLocalInt(oChar, SPENT_SKILL_POINTS, nSpentPoints + nLevelsToBuy);
			string sTextFields = "SKILL_RANK=" + IntToString(nRank + nSkillLevelsBought + nLevelsToBuy);
			ModifyListBoxRow(oChar, "SCREEN_LEVELUP_SKILLS", "CUSTOM_SKILLPANE_LIST",sSkillID,sTextFields, "", "", "");
		}
	}
	else
	{
		if (nRank + nSkillLevelsBought < (nLevel + 3) / 2)
		{
			int bHasAbleLearner = GetHasFeat(1774, oChar);
			int nLevelsToBuy = ((nLevel + 3) / 2) - (nRank + nSkillLevelsBought);
			int nCost = (bHasAbleLearner ? 1 : 2);
			if (nLevelsToBuy > (nPointsRemaining / nCost))
				nLevelsToBuy = (nPointsRemaining / nCost);
			nPointsRemaining -= (nLevelsToBuy * nCost);
			SetLocalInt(oChar, SKILL_LEVELS_BOUGHT + sSkillID, nSkillLevelsBought + nLevelsToBuy);
			SetLocalInt(oChar, SPENT_SKILL_POINTS, nSpentPoints + (nLevelsToBuy * nCost));
			string sTextFields = "SKILL_RANK=" + IntToString(nRank + nSkillLevelsBought + nLevelsToBuy);
			ModifyListBoxRow(oChar, "SCREEN_LEVELUP_SKILLS", "CUSTOM_SKILLPANE_LIST",sSkillID,sTextFields, "", "", "");
		}
	}
	return nPointsRemaining;
}

void AssignPuchasedSkillLevels(object oChar)
{
	object oSDP =  GetObjectByTag(SKILL_DATA_POINT);
	//for each skill in oSDP
	int i = 0;
	string sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	while (sSkillValues != "")
	{
		int n1 = FindSubString(sSkillValues, ":");
		int n2 = FindSubString(sSkillValues, ":", n1+1);
		string sSkillID = GetSubString(sSkillValues, n1+1, n2-(n1+1));
		int nSkillLevelsBought = GetLocalInt(oChar, SKILL_LEVELS_BOUGHT + sSkillID);
		if (nSkillLevelsBought > 0)
		{
			int nRank = GetSkillRank(StringToInt(sSkillID), oChar, TRUE);
			WriteTimestampedLogEntry("Initial Skill rank " + sSkillID + ": " + IntToString(nRank));
			WriteTimestampedLogEntry("Value to be assigned: " + IntToString(nRank + nSkillLevelsBought));
			SetBaseSkillRank(oChar, StringToInt(sSkillID), nRank + nSkillLevelsBought,TRUE);
			nRank = GetSkillRank(StringToInt(sSkillID), oChar, TRUE);
			WriteTimestampedLogEntry("Rank post assignment: " + IntToString(nRank));
		}
		i++;
		sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	}
	//set skill points remaining
	int nSpentPoints = GetLocalInt(oChar, SPENT_SKILL_POINTS);
	int nSkillPointsRemaining = GetSkillPointsRemaining(oChar);
	nSkillPointsRemaining = nSkillPointsRemaining - nSpentPoints;
	if (nSkillPointsRemaining < 0)
	{
		string strMsg = GetName(oChar) + "_" + GetPCPlayerName(oChar);
		strMsg += " has overspent skill points, please have a DM review the character BIC file.";
		SendMessageToAllDMs(strMsg);
		WriteTimestampedLogEntry(strMsg);
		SendMessageToPC(oChar, strMsg);
		SetSkillPointsRemaining(oChar, 0);
	}
	else
		SetSkillPointsRemaining(oChar, nSkillPointsRemaining);
}

string GetSkillsSummaryText(object oChar)
{
	object oSDP = GetObjectByTag(SKILL_DATA_POINT);
	int i = 0;
	string sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	string sText = "Skills:\n";
	int bFoundSkills = FALSE;
	while (sSkillValues != "")
	{
		int n1 = FindSubString(sSkillValues, ":");
		string sSkillName = GetStringLeft(sSkillValues, n1);
		int n2 = FindSubString(sSkillValues, ":", n1+1);
		string sSkillID = GetSubString(sSkillValues, n1+1, n2-(n1+1));
		int nSkillLevelsBought = GetLocalInt(oChar, SKILL_LEVELS_BOUGHT + sSkillID);
		if (nSkillLevelsBought > 0)
		{
			sText += sSkillName + " + " + IntToString(nSkillLevelsBought) + "\n";
			bFoundSkills = TRUE;
		}
		i++;
		sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	}
	if (!bFoundSkills)
		sText += "(none)\n";
	return sText;
}

void AllocateSkillPoints(object oChar, int nClass)
{	//there is no skill package to use as a guide
	int i = 0;
	int nPointsRemaining = GetGUIAvailableSkillPoints(oChar);
	object oSDP =  GetObjectByTag(SKILL_DATA_POINT);
	string sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));

	while (nPointsRemaining > 0 && sSkillValues != "")
	{	//bump all class skills first
		int n1 = FindSubString(sSkillValues, ":");
		int n2 = FindSubString(sSkillValues, ":", n1+1);
		string sSkillID = GetSubString(sSkillValues, n1+1, n2-(n1+1));
		int n = FindSubString(sSkillValues, ";" + IntToString(nClass) + ";");
		if (n != -1)
			nPointsRemaining = SpendSkillPoints(nPointsRemaining, oChar, "1", sSkillID);
		i++;
		sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	}

	i = 0;
	sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	while (nPointsRemaining > 0 && sSkillValues != "")
	{	//now bump cross class skills
		int n1 = FindSubString(sSkillValues, ":");
		int n2 = FindSubString(sSkillValues, ":", n1+1);
		string sSkillID = GetSubString(sSkillValues, n1+1, n2-(n1+1));
		nPointsRemaining = SpendSkillPoints(nPointsRemaining, oChar, "0", sSkillID);
		i++;
		sSkillValues = GetLocalString(oSDP, "Skill" + IntToString(i));
	}
	SetGUIUnAllocatedSkillPoints(nPointsRemaining);
}

void AllocateSkillPointsByPackage(object oChar, string skillpackage, int nClass)
{
	int i = 0;
	int nPointsRemaining = GetGUIAvailableSkillPoints(oChar);
	int nSkillCount = GetNum2DARows(skillpackage);
	object oSDP =  GetObjectByTag(SKILL_DATA_POINT);
	while (nPointsRemaining > 0 && i < nSkillCount)
	{
		string sSkillID = Get2DAString(skillpackage, "SkillIndex", i);
		string sIndex = GetLocalString(oSDP, "SkillID" + sSkillID);
		string sSkillValues = GetLocalString(oSDP, "Skill" + sIndex);
	    int n = FindSubString(sSkillValues, ";" + IntToString(nClass) + ";");
		string cs = (n != -1) ? "1" : "0";
		nPointsRemaining = SpendSkillPoints(nPointsRemaining, oChar, cs, sSkillID);
		i++;
	}
	SetGUIUnAllocatedSkillPoints(nPointsRemaining);
}

void LoadClassSkill2DAData(int nClass, int nClassCount, int nSkillCount, object oSDP, object oCDP)
{
	string sClassID = GetVariableName(oCDP, nClass);
	string sSkillsTable = Get2DAString("classes", "SkillsTable", StringToInt(sClassID));
	int nSkillTableCount = GetNum2DARows(sSkillsTable);
	int k;
	int nClassCounter = GetLocalInt(GetModule(), "classcounter");

	if (nClassCounter == 0)
	  WriteTimestampedLogEntry("Starting LoadClassSkill2DAData...");
	for(k = 0; k < nSkillTableCount; k++)
	{
		string sSkill = Get2DAString(sSkillsTable, "SkillIndex", k);
		string sIndex = GetLocalString(oSDP, "SkillID" + sSkill);
		if (sIndex != "")
		{
			string sSkillValue;
			sSkillValue = GetLocalString(oSDP, "Skill" + sIndex);
			string sClassSkill = Get2DAString(sSkillsTable, "ClassSkill", k);
			if (sClassSkill == "1")
			{
				sSkillValue += sClassID + ";";
				SetLocalString(oSDP, "Skill" + sIndex, sSkillValue);
			}
		}
	}
	if (nClassCounter == nClassCount - 1) //zero indexed..
	{	//sort the skill values when all the classes are done
		WriteTimestampedLogEntry("Finished LoadClassSkill2DAData...");
		WriteTimestampedLogEntry("Sorting skills...");
		DelayCommand(0.1, CSLSort(oSDP,"Skill", "string", nSkillCount, "elu_skillsortdone"));
	}
	else
		SetLocalInt(GetModule(), "classcounter", nClassCounter + 1);
}


//The purpose of this function is to load specific 2DA related data
//onto a specific data point to avoid using Get2DAString calls from
//gui script, which can cause slow GUIs.
void LoadSkill2DAData()
{
	WriteTimestampedLogEntry("Starting LoadSkill2DAData...");
	object oSDP = CSLGetDataPoint(SKILL_DATA_POINT);
	int nCount = GetNum2DARows("skills");
	int j, nSkill, nSkillCounter;

	for (nSkill = 0; nSkill < nCount; nSkill++)
	{
		string sRemoved = Get2DAString("skills", "REMOVED", nSkill);
		if (sRemoved == "0")
		{

			string sIndex = IntToString(nSkillCounter);
			string sImage = Get2DAString("skills", "Icon", nSkill) + ".tga";
			string sRowName = GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", nSkill)));
			string sDescription = GetStringByStrRef(StringToInt(Get2DAString("skills", "Description", nSkill)));
			string sSkill = IntToString(nSkill);
			string sSkillValue = sRowName + ":" + sSkill + ":" + sImage + ";";
			SetLocalString(oSDP, "SkillID" + sSkill, sIndex);
			SetLocalString(oSDP, "SkillDesc" + sSkill, sDescription);
			SetLocalString(oSDP, "Skill" + sIndex, sSkillValue);
			nSkillCounter++;
		}
	}
	object oCDP = GetObjectByTag(CLASS_DATA_POINT);
	int nClassCount = GetVariableCount(oCDP);
	for(j = 0; j < nClassCount; j++)
	{
		DelayCommand(0.1, LoadClassSkill2DAData(j, nClassCount, nSkillCounter, oSDP, oCDP));
	}
	WriteTimestampedLogEntry("Finished LoadSkill2DAData...");
}

void ReMapSkills()
{
	WriteTimestampedLogEntry("Remapping skills...");
	//remap skillIDs to sorted index
	int i = 0;
	object oSDP = CSLGetDataPoint(SKILL_DATA_POINT);
	string sIndex = IntToString(i);
	string sSkillValue = GetLocalString(oSDP, "Skill" + sIndex);
	while(sSkillValue != "")
	{	
		int n1 = FindSubString(sSkillValue, ":",0);
		int n2 = FindSubString(sSkillValue, ":",n1+1);
		string sSkill = GetSubString(sSkillValue, n1+1, n2 - (n1+1));
		SetLocalString(oSDP, "SkillID" + sSkill, sIndex);
		i++;
		sIndex = IntToString(i);
		sSkillValue = GetLocalString(oSDP, "Skill" + sIndex);
	}
	WriteTimestampedLogEntry("Finished ReMapSkills...");
}