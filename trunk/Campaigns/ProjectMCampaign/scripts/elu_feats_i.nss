#include "elu_functions_i"
#include "csl_listbox_i"

const string FEAT_DATA_POINT = "FEAT_DATA_POINT";
const string CLASS_FEAT_DATA_POINT = "CLASS_FEAT_DATA_POINT";

void ClearAddedFeats(object oPC)
{
	int nAddedFeatCount = GetLocalInt(oPC, "AddedFeatCount");
	int i;
	for(i = 0; i < nAddedFeatCount; i++)
	{
		DeleteLocalString(oPC, "AddedFeat" + IntToString(i));
		DeleteLocalInt(oPC, "AddedFeat" + IntToString(i));
	}
	DeleteLocalInt(oPC, "AddedFeatCount");
}

int MeetsFeatStatSaveBABPreReqs(object oPC, int nFeatID, int nBAB, int nStr, int nDex, int nCon, int nWis, int nInt, int nCha,
					  int nFortSave, int nRefSave, int nWillSave)
{
	int nPreReqValue = StringToInt(Get2DAString("feat", "MINATTACKBONUS", nFeatID));
	if (nBAB < nPreReqValue)
		return FALSE;

	//MinStat PreReqs
	nPreReqValue = StringToInt(Get2DAString("feat", "MINSTR", nFeatID));
	if (nStr < nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MINDEX", nFeatID));
	if (nDex < nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MINCON", nFeatID));
	if (nCon < nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MINWIS", nFeatID));
	if (nWis < nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MININT", nFeatID));
	if (nInt < nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MINCHA", nFeatID));
	if (nCha < nPreReqValue)
		return FALSE;
	//Max Stat PreReqs
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXSTR", nFeatID));
	if (nPreReqValue != 0 && nStr > nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXDEX", nFeatID));
	if (nPreReqValue != 0 && nDex > nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXCON", nFeatID));
	if (nPreReqValue != 0 && nCon > nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXWIS", nFeatID));
	if (nPreReqValue != 0 && nWis > nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXINT", nFeatID));
	if (nPreReqValue != 0 && nInt > nPreReqValue)
		return FALSE;
	nPreReqValue = StringToInt(Get2DAString("feat", "MAXCHA", nFeatID));
	if (nPreReqValue != 0 && nCha > nPreReqValue)
		return FALSE;

	//Min Saves
	string sMinSave = Get2DAString("feat", "MinFortSave", nFeatID);
	if (sMinSave != "" && StringToInt(sMinSave) > nFortSave)	
		return FALSE;	
	sMinSave = Get2DAString("feat", "MinRefSave", nFeatID);
	if (sMinSave != "" && StringToInt(sMinSave) > nRefSave)	
		return FALSE;	
	sMinSave = Get2DAString("feat", "MinWillSave", nFeatID);
	if (sMinSave != "" && StringToInt(sMinSave) > nWillSave)	
		return FALSE;	
	return TRUE;
}

int FeatClassInfoIsValid(object oPC, int nClassLevel, int nClass, string sFeatClassInfo, int bShowBonusFeats, int bShowNormalFeats)
{
	string sClass = "C" + IntToString(nClass) + "|";
 	int nIndex = FindSubString(sFeatClassInfo, sClass);
	if (nIndex != -1)
	{
		nIndex = nIndex + GetStringLength(sClass);
		string sList = GetSubString(sFeatClassInfo, nIndex, 1);
		nIndex += 2;
		int nIndex2 = FindSubString(sFeatClassInfo, "|", nIndex);
		int nGrantedOnLevel = StringToInt(GetSubString(sFeatClassInfo, nIndex, nIndex2 - nIndex));

		int nGrantedPrereq = -1;
		nIndex = nIndex2 + 1;
		nIndex2 = FindSubString(sFeatClassInfo, "|", nIndex);
		string sGrantedPrereq = GetSubString(sFeatClassInfo, nIndex, nIndex2 - nIndex);

		if (sGrantedPrereq != "" && sGrantedPrereq != "****")
			nGrantedPrereq = StringToInt(sGrantedPrereq);

		SetLocalString(oPC, "CurrentFeatListValue", sList);
		SetLocalInt(oPC, "CurrentFeatGrantedOnLevelValue", nGrantedOnLevel);
		SetLocalInt(oPC, "CurrentFeatGrantedPrereqValue", nGrantedPrereq);

		if (sList == "3")
			return FALSE;
		if (sList == "2" && !bShowBonusFeats)
			return FALSE;
		if (sList == "0" && !bShowNormalFeats)
			return FALSE;

		if (nGrantedOnLevel > 0)
		{
			if (nClassLevel != nGrantedOnLevel)
				return FALSE;
		}

		if (nGrantedPrereq > -1 && !GetHasFeat(nGrantedPrereq, oPC, TRUE))
			return FALSE;

		return TRUE;
	}
	return FALSE;
}

int HasValidClassForFeat(object oPC, int nFeatID, int nClassLevel, int nSelectedClass, string sFeatClassInfo, int bShowBonusFeats, int bShowNormalFeats)
{
	DeleteLocalString(oPC, "CurrentFeatListValue");
	DeleteLocalInt(oPC, "CurrentFeatGrantedOnLevelValue");
	DeleteLocalInt(oPC, "CurrentFeatGrantedPrereqValue");

	if (FeatClassInfoIsValid(oPC, nClassLevel, nSelectedClass, sFeatClassInfo, bShowBonusFeats, bShowNormalFeats))
		return TRUE;
	else
	{
		string sAllClassesCanUse = Get2DAString("feat", "ALLCLASSESCANUSE", nFeatID);
		if (sAllClassesCanUse == "1")
		{
			if (GetLocalString(oPC, "CurrentFeatListValue") != "3")
				SetLocalString(oPC, "CurrentFeatListValue", "A");
			return bShowNormalFeats;
		}
		return FALSE;
	}
}

int HasValidLevelForFeat(object oPC, int nFeatID, int nLevel, int nClass1, int nClass2, int nClass3, int nClass4,
									 int nClassLvl1, int nClassLvl2, int nClassLvl3, int nClassLvl4)
{   //There does not appear to be any evidence for the default NWN2 engine rules actually enforcing the MaxCR requirement.
	//int nMaxCR = StringToInt(Get2DAString("feat", "MAXCR", nFeatID));
	//if (nMaxCR > 0 && nLevel > nMaxCR)
	//	return FALSE;
	int nMaxLevel = StringToInt(Get2DAString("feat", "MaxLevel", nFeatID));
	if (nMaxLevel > 0 && nLevel > nMaxLevel)
		return FALSE;

	int nMinLevel = StringToInt(Get2DAString("feat", "MinLevel", nFeatID));
	if (nLevel < nMinLevel)
		return FALSE;
	string sMinLevelClass = Get2DAString("feat", "MinLevelClass", nFeatID);
	if (sMinLevelClass != "")
	{
		int nMinLevelClass = StringToInt(sMinLevelClass);
		if (nClass1 == nMinLevelClass && nClassLvl1 >= nMinLevel)
			return TRUE;
		if (nClass2 == nMinLevelClass && nClassLvl2 >= nMinLevel)
			return TRUE;
		if (nClass3 == nMinLevelClass && nClassLvl3 >= nMinLevel)
			return TRUE;
		if (nClass4 == nMinLevelClass && nClassLvl4 >= nMinLevel)
			return TRUE;
		return FALSE;
	}
	return TRUE;
}


void AddFeatIndex(object oListBoxObj, int nFeatID, string sCategory)
{
	string sFeatName = GetStringByStrRef(StringToInt(Get2DAString("feat", "feat", nFeatID)));
	string sImage = Get2DAString("feat", "Icon", nFeatID) + ".tga";
	string sFeat = IntToString(nFeatID);
	string sRowName = "FEAT" + sFeat;
	string sTextFields = "FEAT_TEXT=" + sFeatName + ";";
	string sTextures = "FEAT_IMAGE=" + sImage + ";";
	string sVariables = "0=" + sRowName + ";1=" + sFeat + ";";
	string sHideUnHide = "FEAT_IMAGE=unhide;FEAT_TEXT=unhide;FEAT_ACTION=unhide;";
	CSLAddListBoxRow(oListBoxObj, sRowName, sTextFields, sTextures, sVariables, sHideUnHide, 1, sCategory);
	SetLocalInt(GetModule(), "FEATSAREAVAILABLE", TRUE);
}

int HasValidSkillsPreReqsForFeat(object oPC, int nFeatID)
{
	int nSkill = StringToInt(Get2DAString("feat", "REQSKILL", nFeatID));
	if (nSkill > 0)
	{
		string sMaxSkill = Get2DAString("feat", "ReqSkillMaxRanks", nFeatID);
		string sMinSkill = Get2DAString("feat", "ReqSkillMinRanks", nFeatID);
		int nMinSkill = (sMinSkill != "****" && sMinSkill != "" ? StringToInt(sMinSkill) : 0);
		int nMaxSkill = (sMaxSkill != "****" && sMaxSkill != "" ? StringToInt(sMaxSkill) : 255);
		int nSkillLevelsBought = GetLocalInt(oPC, SKILL_LEVELS_BOUGHT + IntToString(nSkill));
		int nRanks = GetSkillRank(nSkill,oPC, TRUE) + nSkillLevelsBought;
		if (nRanks < nMinSkill || nRanks > nMaxSkill)
			return FALSE;
		nSkill = StringToInt(Get2DAString("feat", "REQSKILL2", nFeatID));
		if (nSkill > 0)
		{
			sMaxSkill = Get2DAString("feat", "ReqSkillMaxRanks2", nFeatID);
			sMinSkill = Get2DAString("feat", "ReqSkillMinRanks2", nFeatID);
			nMinSkill = (sMinSkill != "****" && sMinSkill != "" ? StringToInt(sMinSkill) : 0);
			nMaxSkill = (sMaxSkill != "****" && sMaxSkill != "" ? StringToInt(sMaxSkill) : 255);
			nSkillLevelsBought = GetLocalInt(oPC, SKILL_LEVELS_BOUGHT + IntToString(nSkill));
			nRanks = GetSkillRank(nSkill,oPC, TRUE) + nSkillLevelsBought;
			if (nRanks < nMinSkill || nRanks > nMaxSkill)
				return FALSE;
		}
	}
	return TRUE;
}

string GetCategoryText(string sCategoryText)
{
	if (sCategoryText == "GENERAL_FT_CAT")
		return GetStringByStrRef(112967); //General Feats
	if (sCategoryText == "PROFICIENCY_FT_CAT")
		return GetStringByStrRef(112968); //Proficiency Feats
	if (sCategoryText == "SPELLCASTING_FT_CAT")
		return GetStringByStrRef(112969); //Spellcasting Feats
	if (sCategoryText == "METAMAGIC_FT_CAT")
		return GetStringByStrRef(112970); //Metamagic Feats
	if (sCategoryText == "ITEMCREATION_FT_CAT")
		return  GetStringByStrRef(112971); //Item Creation Feats
	if (sCategoryText == "DIVINE_FT_CAT")
		return  GetStringByStrRef(112972); //Divine Feats
	if (sCategoryText == "SKILLNSAVE_FT_CAT")
		return  GetStringByStrRef(112973); //Skill and Save Feats
	if (sCategoryText == "CLASSABILITY_FT_CAT")
		return  GetStringByStrRef(112977); //Class Ability Feats
	if (sCategoryText == "EPIC_FT_CAT")
		return  GetStringByStrRef(185467); //Epic Feats
	if (sCategoryText == "HERITAGE_FT_CAT")
		return  GetStringByStrRef(225360); //Heritage Feats
	return "";
}


int HasValidFeatPreReqs(object oPC, int nFeatID)
{
	//check AND feat prereqs,
	string sPreReqFeat = Get2DAString("feat", "PREREQFEAT1", nFeatID);
	int nPreReqFeat = StringToInt(sPreReqFeat);
	if (sPreReqFeat != "")
	{
		if (GetHasFeat(nPreReqFeat,oPC, TRUE) == FALSE && HasAsAddedFeat(oPC, nPreReqFeat) == FALSE)
			return FALSE;
		sPreReqFeat = Get2DAString("feat", "PREREQFEAT2", nFeatID);
		nPreReqFeat = StringToInt(sPreReqFeat);
		if (sPreReqFeat != "")
			if (GetHasFeat(nPreReqFeat,oPC,TRUE) == FALSE && HasAsAddedFeat(oPC, nPreReqFeat) == FALSE)
				return FALSE;
	}
	//check OR feat prereqs
	sPreReqFeat = Get2DAString("feat", "OrReqFeat0", nFeatID);
	nPreReqFeat = StringToInt(sPreReqFeat);
	if (sPreReqFeat != "")
	{
		int bHasFeat = GetHasFeat(nPreReqFeat,oPC,TRUE);
		if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
			return TRUE;
		sPreReqFeat = Get2DAString("feat", "OrReqFeat1", nFeatID);
		nPreReqFeat = StringToInt(sPreReqFeat);
		if (sPreReqFeat != "")
		{
			if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
				return TRUE;
			sPreReqFeat = Get2DAString("feat", "OrReqFeat2", nFeatID);
			nPreReqFeat = StringToInt(sPreReqFeat);
			if (sPreReqFeat != "")
			{
				if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
					return TRUE;
				sPreReqFeat = Get2DAString("feat", "OrReqFeat3", nFeatID);
				nPreReqFeat = StringToInt(sPreReqFeat);
				if (sPreReqFeat != "")
				{
					if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
						return TRUE;
					sPreReqFeat = Get2DAString("feat", "OrReqFeat4", nFeatID);
					nPreReqFeat = StringToInt(sPreReqFeat);
					if (sPreReqFeat != "")
					{
						if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
							return TRUE;
						sPreReqFeat = Get2DAString("feat", "OrReqFeat5", nFeatID);
						nPreReqFeat = StringToInt(sPreReqFeat);
						if (sPreReqFeat != "")
						{
							if (GetHasFeat(nPreReqFeat,oPC,TRUE) == TRUE || HasAsAddedFeat(oPC, nPreReqFeat) == TRUE)
								return TRUE;
						}
					}
				}
			}
		}
		return FALSE;
	}
	return TRUE;
}

void SetupFeatsListBox(object oPC, int bBonusFeatScreen)
{
	WriteTimestampedLogEntry("SetupFeatsListBox");
	string sScreen = "SCREEN_LEVELUP_NORMAL_FEATS";
	if (bBonusFeatScreen)
		sScreen = "SCREEN_LEVELUP_BONUS_FEATS";
	string sListBox = "CUSTOM_AVAILABLE_FEAT_LIST";
	object oLBAvailableFeats = CSLGetListBoxObject(oPC, sScreen, sListBox);
	int nHeaderCount = GetLocalInt(oLBAvailableFeats, HEADER_COUNT);
	int i = 0;
	string sHeaderIndex;
	int bFeatsPresentToCheck = FALSE;
	for(i = 0; i < nHeaderCount; i++)
	{
		sHeaderIndex = IntToString(i);
		int nChildRows = GetLocalInt(oLBAvailableFeats, HEADER_CHILD_ROWS + sHeaderIndex);
		int j;
		for(j = 0; j < nChildRows; j++)
		{
			bFeatsPresentToCheck = TRUE;
			string sVar = HEADER + sHeaderIndex + CHILDROW + IntToString(j);
			string sRowName = GetLocalString(oLBAvailableFeats, sVar + CRNAME);
			int nFeatID = StringToInt(GetSubString(sRowName, 4, GetStringLength(sRowName) - 4));
			int bMeetsValidFeatPreReqs = HasValidFeatPreReqs(oPC, nFeatID);
			if (!bMeetsValidFeatPreReqs || HasAsAddedFeat(oPC, nFeatID) == TRUE)
				SetLocalInt(oLBAvailableFeats, sVar + CRVISIBLE, FALSE);
		}
	}
	if (bFeatsPresentToCheck == FALSE)
		WriteTimestampedLogEntry("WARNING SetUpFeatsListBox: No child row feats for any feat headers have been set.");
	
	CSLRefreshListBox(oLBAvailableFeats);
	object oLBAddedFeats = CSLGetListBoxObject(oPC, sScreen, "CUSTOM_ADDED_FEAT_LIST");
	CSLRefreshListBox(oLBAddedFeats);

	int nBonusFeatCount = GetLocalInt(oPC, "BonusFeatCount");
	SetGUIObjectText(OBJECT_SELF, sScreen, "POINT_POOL_TEXT", -1, IntToString(nBonusFeatCount));

	SetGUIObjectHidden(GetOwnedCharacter(oPC), sScreen, sListBox, FALSE);
	SetGUIObjectHidden(GetOwnedCharacter(oPC), sScreen, "CUSTOM_ADDED_FEAT_LIST", FALSE);
	WriteTimestampedLogEntry("SetupFeatsListBox finished");
}

void AddAvailableFeats(object oPC, int bShowBonusFeats, int bShowNormalFeats, int nLevel,
		int nClass1, int nClass2, int nClass3, int nClass4, int nClassLvl1, int nClassLvl2, int nClassLvl3, int nClassLvl4,
		int nSpellLevel, int nCasterLevel, int nSelectedClass, int nSelectedClassLvl,
		int nBAB, int nStr, int nDex, int nCon, int nWis, int nInt, int nCha, int nFortSave, int nRefSave, int nWillSave, 
		object oLBBonusAvailableFeats, object oLBBonusAddedFeats, object oLBNormalAvailableFeats, object oLBNormalAddedFeats, 
		int nLastVarProcessed, int nSegmentSize)
{

	object oFDP = CSLGetDataPoint(FEAT_DATA_POINT);
	int nCount = GetVariableCount(oFDP);
	int nIndex = 0;

	for(nIndex = nLastVarProcessed; nIndex < nLastVarProcessed + nSegmentSize; nIndex++)
	{
		if (nIndex >= nCount)
			break;

		string sFeatData = GetVariableValueString(oFDP, nIndex);
		int n1 = FindSubString(sFeatData, "|");
		int n2 = FindSubString(sFeatData, "|", n1+1);
		string sFeatID = GetSubString(sFeatData, n1+1, n2-(n1+1));
		int nFeatID = StringToInt(sFeatID);

		if (GetHasFeat(nFeatID, oPC, TRUE))
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Already has feat.");			
			continue;
		}
		
		//This must be checked before auto granted feats because it sets the value of "CurrentFeatListValue"
		int bClassValid = HasValidClassForFeat(oPC, nFeatID, nSelectedClassLvl, nSelectedClass, sFeatData, bShowBonusFeats, bShowNormalFeats);		
		if (!bClassValid)
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does not have valid class.");
			continue;
		}
		
		//Autogranted feats must be checked first before normla prereq logic, because it is possible
		//to allow a class to be given a feat at a specific level without them otherwise meeting prereqs for it.
		string sCategory = Get2DAString("feat", "FeatCategory", nFeatID);
		//WriteTimestampedLogEntry("FeatID: " + sFeatID + " FeatCategory=" + sCategory);
		string sCurrentFeatList = GetLocalString(oPC, "CurrentFeatListValue");			
		if (sCurrentFeatList == "3")
		{
			int nCurrentFeatGrantedOnLevel = GetLocalInt(oPC, "CurrentFeatGrantedOnLevelValue");
			int nCurrentFeatGrantedPrereq = GetLocalInt(oPC, "CurrentFeatGrantedPrereqValue");
			if (nCurrentFeatGrantedOnLevel == nSelectedClassLvl && GetHasFeat(nCurrentFeatGrantedPrereq, oPC, TRUE))
			{
				int nAddedFeatCount = GetLocalInt(oPC, "AddedFeatCount");
				SetLocalString(oPC, "AddedFeat" + IntToString(nAddedFeatCount), IntToString(nFeatID));
				SetLocalInt(oPC, "AddedFeat" + IntToString(nAddedFeatCount), -1);
				nAddedFeatCount++;
				SetLocalInt(oPC, "AddedFeatCount", nAddedFeatCount);

				if (bShowBonusFeats)
					AddFeatIndex(oLBBonusAddedFeats, nFeatID, sCategory);
				if (bShowNormalFeats)
					AddFeatIndex(oLBNormalAddedFeats, nFeatID, sCategory);
				continue; //Because this was awarded above, we can skip the prereq logic and move to the next one.
			}			
		}
				
		string bPreReqEpic = Get2DAString("feat", "PreReqEpic", nFeatID);
		if (bPreReqEpic == "1" && nLevel < 21)
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Not Epic.");
			continue;
		}

		int bLevelValid = HasValidLevelForFeat(oPC, nFeatID, nLevel, nClass1, nClass2, nClass3, nClass4, nClassLvl1, nClassLvl2, nClassLvl3, nClassLvl4);
		if (!bLevelValid)
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does not have valid level.");
			continue;
		}

		string sMinSpellLvl = Get2DAString("feat", "MINSPELLLVL", nFeatID);
		if (sMinSpellLvl != "" && nSpellLevel < StringToInt(sMinSpellLvl))
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does not have minimum spell level needed.");
			continue;
		}
		
		string sMinCasterLvl = Get2DAString("feat", "MINCASTERLVL", nFeatID);
		if (sMinCasterLvl != "" && nCasterLevel < StringToInt(sMinCasterLvl))
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does not have minimum caster level needed.");
			continue;
		}							
		
		string  sAlignRestrict = Get2DAString("feat", "AlignRestrict", nFeatID);
		if (sAlignRestrict != "")
		{
			int nAlignRestrict = StringToInt(sAlignRestrict);
			if (nAlignRestrict == GetAlignmentLawChaos(oPC) || nAlignRestrict == GetAlignmentGoodEvil(oPC))
			{
				//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does Not have correct alignment.");
				continue;
			}
		}
		
		int bMeetsPreReqs = MeetsFeatStatSaveBABPreReqs(oPC, nFeatID, nBAB, nStr, nDex, nCon, nWis, nInt, nCha, nFortSave, nRefSave, nWillSave);
		if (!bMeetsPreReqs)
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Failed Stat, BAB or Save checks..");
			continue;
		}
		
		int bMeetsSkillPreReqs = HasValidSkillsPreReqsForFeat(oPC, nFeatID);
		if (!bMeetsSkillPreReqs)
		{
			//WriteTimestampedLogEntry("FeatID: " + sFeatID + " prereq failed. Does not meet skill requirements.");
			continue;
		}
		
		if (bShowBonusFeats && (sCurrentFeatList == "2" || sCurrentFeatList == "1"))
			AddFeatIndex(oLBBonusAvailableFeats, nFeatID, sCategory);
		if (bShowNormalFeats && (sCurrentFeatList == "0" || sCurrentFeatList == "1" || sCurrentFeatList == "A"))
			AddFeatIndex(oLBNormalAvailableFeats, nFeatID, sCategory);
	}

	if (nIndex < nCount)
	{
		DelayCommand(0.01, 	AddAvailableFeats(oPC, bShowBonusFeats, bShowNormalFeats, nLevel,
			nClass1, nClass2, nClass3, nClass4, nClassLvl1, nClassLvl2, nClassLvl3, nClassLvl4,
			nSpellLevel, nCasterLevel, nSelectedClass, nSelectedClassLvl,
			nBAB, nStr, nDex, nCon, nWis, nInt, nCha, nFortSave, nRefSave, nWillSave,
			oLBBonusAvailableFeats, oLBBonusAddedFeats, oLBNormalAvailableFeats, oLBNormalAddedFeats,
			nIndex, nSegmentSize));
	}
	else
	{		
		if (GetLocalInt(GetModule(), "FEATSAREAVAILABLE") == FALSE)
			WriteTimestampedLogEntry("WARNING: AddAvailableFeats, all feats failed prereq logic, no feats available to take.");
		DeleteLocalInt(GetModule(), "FEATSAREAVAILABLE");
		WriteTimestampedLogEntry("AddAvailableFeats finished.");
		DelayCommand(0.01, SetupFeatsListBox(oPC, bShowBonusFeats));
	}
}

int GetHasBonusFeatsThisLevel(object oPC)
{
	int nSelectedClass = GetLocalInt(oPC, LAST_SELECTED_CLASS);
	int nSelectedClassLvl = GetLevelByClass(nSelectedClass, oPC);
	string sBonusFeatTable = Get2DAString("classes", "BonusFeatsTable", nSelectedClass);
	int bFeat = StringToInt(Get2DAString(sBonusFeatTable, "Bonus", nSelectedClassLvl));
	return (bFeat > 0);
}


string GetFeatSummaryText(object oPC)
{
	int nAddedFeatCount = GetLocalInt(oPC, "AddedFeatCount");
	int i;
	string sText = "Feats:\n";
	if (nAddedFeatCount > 0)
	{
		for(i = 0; i < nAddedFeatCount; i++)
		{
			string sFeatID = GetLocalString(oPC, "AddedFeat" + IntToString(i));
			int nFeatID = StringToInt(sFeatID);
			string sFeatName = GetStringByStrRef(StringToInt(Get2DAString("feat", "feat", nFeatID)));
			sText += sFeatName + "\n";
		}
	}
	else
		sText += "(none)\n";
	return sText;
}

void AssignPurchasedFeats(object oPC)
{
	int nAddedFeatCount = GetLocalInt(oPC, "AddedFeatCount");
	int i;
	for(i = 0; i < nAddedFeatCount; i++)
	{
		string sFeatID = GetLocalString(oPC, "AddedFeat" + IntToString(i));
		int nAddType = GetLocalInt(oPC, "AddedFeat" + IntToString(i));
		if (nAddType == -1)
			continue;
		int nFeatID = StringToInt(sFeatID);
		int bFeatAdded = FeatAdd(oPC, nFeatID, FALSE);
		//if (!bFeatAdded)
		//	WriteTimestampedLogEntry("Feat " + sFeatID + " failed to get added to " + GetPCPlayerName(oPC) + "_" + GetName(oPC));
	}
	ClearAddedFeats(oPC);
}

void FeatSort()
{
	object oMod = GetModule();
	object oFDP = CSLGetDataPoint(FEAT_DATA_POINT);
	int nCount = GetLocalInt(oMod, "GENERAL_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"GENERAL_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "PROFICIENCY_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"PROFICIENCY_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "SPELLCASTING_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"SPELLCASTING_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "METAMAGIC_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"METAMAGIC_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "ITEMCREATION_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"ITEMCREATION_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "DIVINE_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"DIVINE_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "SKILLNSAVE_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"SKILLNSAVE_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "CLASSABILITY_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"CLASSABILITY_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "EPIC_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"EPIC_FT_CAT","string",nCount, "elu_featsortdone"));
	nCount = GetLocalInt(oMod, "HERITAGE_FT_CATCount");
	DelayCommand(0.01, CSLSort(oFDP,"HERITAGE_FT_CAT","string",nCount, "elu_featsortdone"));
}

void LoadFeat2DASegment(int nSegmentSize)
{
	int nCount = GetNum2DARows("feat");
	int nFeat;
	int nTotalCounter = GetLocalInt(GetModule(), "DataRowCount");
	int nLastRowProcessed = GetLocalInt(GetModule(), "LastRowProcessed");
	string sFeat, sFeatValue, sIndex, sImage, sDescription, sRowName, sCategory, sRemoved, sAllClassesCanUse, sPreReqInfo;
	int bComplete = 0;
	object oCFDP = CSLGetDataPoint(CLASS_FEAT_DATA_POINT);
	object oFDP = CSLGetDataPoint(FEAT_DATA_POINT);
	for (nFeat = nLastRowProcessed; nFeat < nLastRowProcessed + nSegmentSize; nFeat++)
	{
		if (nFeat > nCount)
		{
			bComplete = 1;
			break;
		}
		sRemoved = Get2DAString("feat", "REMOVED", nFeat);
		if (sRemoved!="0")
			continue;
		sAllClassesCanUse = Get2DAString("feat", "ALLCLASSESCANUSE", nFeat);
		sFeat = IntToString(nFeat);
		string sFeatClassData = GetLocalString(oCFDP, "FeatID" + sFeat);

		if (sFeatClassData == "" && sAllClassesCanUse != "1")
			continue;

		sCategory = Get2DAString("feat", "FeatCategory", nFeat);
		if (sCategory == "****" || sCategory == "" || sCategory == "RACIALABILITY_FT_CAT" || sCategory == "BACKGROUND_FT_CAT" ||
			sCategory == "HISTORY_FT_CAT" || sCategory == "TEAMWORK_FT_CAT")
			continue;

		int nCounter = GetLocalInt(GetModule(), sCategory + "Count");
		nTotalCounter++;
		sIndex = IntToString(nCounter);
		sRowName = GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", nFeat)));
		sFeatValue = sRowName + "|" + sFeat + "|";
		sFeatValue += sFeatClassData;
		SetLocalString(oFDP, sCategory + sIndex, sFeatValue);
		nCounter++;
		SetLocalInt(GetModule(), sCategory + "Count", nCounter);
	}
	SetLocalInt(GetModule(), "DataRowCount", nTotalCounter);
	SetLocalInt(GetModule(), "LastRowProcessed", nFeat);
	if (!bComplete)
		DelayCommand(0.01, LoadFeat2DASegment(nSegmentSize));
	else
	{
		WriteTimestampedLogEntry("Total Feats Scanned: " + IntToString(nTotalCounter));
		FeatSort();
	}
}


//The purpose of this function is to load specific 2DA related data
//onto a specific data point to avoid using Get2DAString calls from
//gui script, which can cause slow GUIs.
void LoadFeat2DAData()
{
	WriteTimestampedLogEntry("Starting LoadFeat2DAData");
	DelayCommand(0.01, LoadFeat2DASegment(200));
}

//This function loads all of the cls_feat_***.2da info that is needed for the given sClassID
void LoadClassFeatMap(string sClassID, int nClassIndex, int nClassCount)
{
	string sFeatsTable = Get2DAString("classes", "FeatsTable", StringToInt(sClassID));
	int nFeatTableCount = GetNum2DARows(sFeatsTable);
	int k = 0;
	object oCFDP = CSLGetDataPoint(CLASS_FEAT_DATA_POINT);
	for(k = 0; k < nFeatTableCount; k++)
	{
		string sFeat = Get2DAString(sFeatsTable, "FeatIndex", k);
		if (sFeat == "****" || sFeat =="")
			continue;
		string sFeatData = GetLocalString(oCFDP, "FeatID" + sFeat);
		string sList = Get2DAString(sFeatsTable, "List", k);
		string sGrantedOnLevel = Get2DAString(sFeatsTable, "GrantedOnLevel",k);
		string sGrantedPrereq = Get2DAString(sFeatsTable, "GrantedPrereq",k);
		string sData = "C" + sClassID + "|" + sList + "|" + sGrantedOnLevel + "|" + sGrantedPrereq + "|";
		sFeatData += sData;
		SetLocalString(oCFDP, "FeatID" + sFeat, sFeatData);
	}
	if (nClassIndex + 1 == nClassCount)
	{
		WriteTimestampedLogEntry("Finished all class feat maps");
		LoadFeat2DAData();
	}
}

//This function loads all of the cls_feat_***.2da info that is needed.
void LoadClassFeatData()
{
	WriteTimestampedLogEntry("Starting LoadClassFeatData");
	int j;
	object oCDP = GetObjectByTag(CLASS_DATA_POINT);
	int nClassCount = GetVariableCount(oCDP);
	for(j = 0; j < nClassCount; j++)
	{
		string sClassID = GetVariableName(oCDP, j);
		DelayCommand(0.01, LoadClassFeatMap(sClassID, j, nClassCount));
	}
}

void AddFeat(object oChar, string sScreen, int nFeatID)
{
	int nAddedFeatCount = GetLocalInt(oChar, "AddedFeatCount");
	SetLocalString(oChar, "AddedFeat" + IntToString(nAddedFeatCount), IntToString(nFeatID));
	object oLB1, oLB2, oLB3;
	if (sScreen == "SCREEN_LEVELUP_BONUS_FEATS")
	{
		SetLocalInt(oChar, "AddedFeat" + IntToString(nAddedFeatCount), 1);
		oLB3 = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_ADDED_FEAT_LIST");
	}
	nAddedFeatCount++;
	SetLocalInt(oChar, "AddedFeatCount", nAddedFeatCount);
	oLB1 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST");
	oLB2 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_ADDED_FEAT_LIST");
	string sRowName = "FEAT" + IntToString(nFeatID);
	string sTextFields = CSLGetListBoxRowValue(oLB1, sRowName, TextFields);
	string sTextures = CSLGetListBoxRowValue(oLB1, sRowName, Textures);
	string sVariables = CSLGetListBoxRowValue(oLB1, sRowName, Variables);
	string sHideUnhide = CSLGetListBoxRowValue(oLB1, sRowName, HideUnhide);
	string sHeader = Get2DAString("feat", "FeatCategory", nFeatID);
	CSLSetListBoxRowVisible(oLB1, sRowName, 0);
	CSLAddListBoxRow(oLB2, sRowName, sTextFields, sTextures, sVariables, sHideUnhide, 1, sHeader);
	if (sScreen == "SCREEN_LEVELUP_BONUS_FEATS")
		CSLAddListBoxRow(oLB3, sRowName, sTextFields, sTextures, sVariables, sHideUnhide, 1, sHeader);
	int nBonusFeatCount = GetLocalInt(oChar, "BonusFeatCount") - 1;
	SetLocalInt(oChar, "BonusFeatCount", nBonusFeatCount);
}


void AllocateFeatsByPackage(object oPC, string sPackage, string sScreen)
{
	int nRowCount = GetNum2DARows(sPackage);
	int i;
	object oLB = CSLGetListBoxObject(oPC, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST");
	for (i = 0; i < nRowCount; i++)
	{
		string sFeatID = Get2DAString(sPackage, "FeatIndex", i);
		if (sFeatID != "")
		{
			string sRowName = "FEAT" + sFeatID;
			string sVar = GetLocalString(oLB, sRowName);
			if (sVar != "")
			{
				int bVisible = GetLocalInt(oLB, sVar + CRVISIBLE);
				if (bVisible)
				{
					AddFeat(oPC, sScreen, StringToInt(sFeatID));
					if (GetLocalInt(oPC, "BonusFeatCount") <= 0)
						return;
				}
			}
		}
	}
}

void AllocateFeats(object oPC, string sScreen)
{
	object oLB = CSLGetListBoxObject(oPC, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST");
	int nHeaderCount = GetLocalInt(oLB, HEADER_COUNT);
	int i, j, nChildRows;
	string sHeaderIndex, sVar;
	for(i = 0; i < nHeaderCount; i++)
	{
		sHeaderIndex = IntToString(i);
		nChildRows = GetLocalInt(oLB, HEADER_CHILD_ROWS + sHeaderIndex);
		for(j = 0; j < nChildRows; j++)
		{
			sVar = HEADER + sHeaderIndex + CHILDROW + IntToString(j);
			int bVisible = GetLocalInt(oLB, sVar + CRVISIBLE);
			if (bVisible)
			{
				string sRowName = GetLocalString(oLB, sVar + CRNAME);
				string sFeatID =  GetSubString(sRowName, 4, GetStringLength(sRowName) - 4);
				AddFeat(oPC, sScreen, StringToInt(sFeatID));
				if (GetLocalInt(oPC, "BonusFeatCount") <= 0)
					return;
			}
		}
	}
}

