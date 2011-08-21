#include "csl_listbox_i"
#include "elu_functions_i"

const string SCREEN_LEVELUP_SPELLS = "SCREEN_LEVELUP_SPELLS";
const string CUSTOM_ADDED_SPELL_LIST_ = "CUSTOM_ADDED_SPELL_LIST_";
const string CUSTOM_AVAILABLE_SPELL_LIST_ = "CUSTOM_AVAILABLE_SPELL_LIST_";
const string SPELL_LEVEL = "SpellLevel";
const string DONE_PROCESSING_SPELLS = "DONE_PROCESSING_SPELLS";
const string ADDED_SPELL_COUNT = "ADDED_SPELL_COUNT";
const string ADDED_SPELL = "ADDED_SPELL";
const string REMOVED_SPELL = "REMOVED_SPELL";


void SetSpellPoolPointsAvailableByLevel(object oChar, int nLevel, int nPoints)
{
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	if (nSelectedClassID == 10) //Wizard is hardcoded
		SetLocalInt(oChar, SPELL_LEVEL + "0", nPoints);
	else
		SetLocalInt(oChar, SPELL_LEVEL + IntToString(nLevel), nPoints);
}

int GetSpellPoolPointsAvailableByLevel(object oChar, int nLevel)
{
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	if (nSelectedClassID == 10) //Wizard is hardcoded
		return GetLocalInt(oChar, SPELL_LEVEL + "0");
	return GetLocalInt(oChar, SPELL_LEVEL + IntToString(nLevel));
}

void ClearAddedSpells(object oChar)
{
	int nAddedSpellCount = GetLocalInt(oChar, ADDED_SPELL_COUNT);
	int i;
	for(i = 0; i < nAddedSpellCount; i++)	
		DeleteLocalInt(oChar, ADDED_SPELL + IntToString(i));
	DeleteLocalString(oChar, REMOVED_SPELL);
	DeleteLocalInt(oChar, ADDED_SPELL_COUNT);
}

string GetSpellSummaryText(object oChar)
{
	string sText = "Spells (Added):\n";
	int i;
	int nAddedSpellCount = GetLocalInt(oChar, ADDED_SPELL_COUNT);
	if (nAddedSpellCount > 0)
	{
		for (i = 0; i < nAddedSpellCount; i++)
		{		
			int nSpellID = GetLocalInt(oChar, ADDED_SPELL + IntToString(i));
			sText += GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellID))) + "\n";			
		}
	}
	else
		sText += "(none)\n";
	
	sText += "\nSpells (Removed):\n";
	string sRemoved = GetLocalString(oChar, REMOVED_SPELL);
	if (sRemoved != "")	
		sText += GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", StringToInt(sRemoved)))) + "\n";	
	else
		sText += "(none)\n";
	
	return sText;
}

void AddSpell(object oChar, int nLevel, int nSpellID)
{
	int nSpellPoints = GetSpellPoolPointsAvailableByLevel(oChar, nLevel);
	int bReAddRemovedSpell = (GetLocalString(oChar, REMOVED_SPELL) == IntToString(nSpellID));
	
	if (nSpellPoints > 0 || bReAddRemovedSpell)
	{	
		string sLevel = IntToString(nLevel);
		object oLB1 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel);
		object oLB2 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_ADDED_SPELL_LIST_ + sLevel);		
		
		if (!bReAddRemovedSpell)
		{
			int nAddedSpellCount = GetLocalInt(oChar, ADDED_SPELL_COUNT);
			SetLocalInt(oChar, ADDED_SPELL + IntToString(nAddedSpellCount), nSpellID);			
			SetLocalInt(oChar, ADDED_SPELL_COUNT, nAddedSpellCount + 1);
		}
		else
			DeleteLocalString(oChar, REMOVED_SPELL);
			
		string sSpellID = IntToString(nSpellID);
		CSLSetListBoxRowVisible(oLB1, sSpellID, FALSE);
		CSLSetListBoxRowVisible(oLB2, sSpellID, TRUE);
		nSpellPoints = nSpellPoints - 1;
		SetSpellPoolPointsAvailableByLevel(oChar, nLevel, nSpellPoints);
		SetGUIObjectText(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "POINT_POOL_TEXT", -1, IntToString(nSpellPoints));
		CSLRefreshListBox(oLB1);
		CSLRefreshListBox(oLB2);
	}
}

int CanSwapSpells(object oChar, int nLevel, int nSelectedClassID)
{
	if (GetLocalString(oChar, REMOVED_SPELL) != "")
		return FALSE;
	if (nSelectedClassID == 10) //Wizard is hardcoded, wizards cannot swap spells
		return FALSE;
	int nMinLvl = StringToInt(Get2DAString("classes", "SpellSwapMinLvl", nSelectedClassID));
	int nLevels = CSLGetLevelsByClass(oChar, nSelectedClassID) + 1;
	if (nLevels < nMinLvl)
		return FALSE; //not high enough in class levels to swap spells for this class
	int nLvlInterval = StringToInt(Get2DAString("classes", "SpellSwapLvlInterval", nSelectedClassID));
	
	if ((nLevels - nMinLvl) % (nLvlInterval + 1) != 0)
		return FALSE; //not reached the next interval in which spells are allowed to be swapped for this class.
	string sSpKnown = Get2DAString("classes", "SpellKnownTable", nSelectedClassID);
	int nLvlDiff = StringToInt(Get2DAString("classes", "SpellSwapLvlDiff", nSelectedClassID));
	int i;
	int nHighestLvl = 0;
	for(i = 0; i < 10; i++)
	{
		if (Get2DAString(sSpKnown, "SpellLevel" + IntToString(i), nLevels - 1) != "")		
			nHighestLvl = i;
		else
			break;
	}
	if (nLevel > nHighestLvl - nLvlDiff) 
		return FALSE;	//The level attempting to be removed is higher than the allowable level differece
	return TRUE;
}

void RemoveSpell(object oChar, int nLevel, int nSpellID)
{
	int nSpellPoints = GetSpellPoolPointsAvailableByLevel(oChar, nLevel);
	int nAddedSpellCount = GetLocalInt(oChar, ADDED_SPELL_COUNT);
	int i;
	int bFound = FALSE;
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	if (nLevel == 0 && nSelectedClassID == 10)
		return;	//Wizards cant remove cantrips
	for(i = 0; i < nAddedSpellCount; i++)
	{
		string s = IntToString(i);
		if (nSpellID == GetLocalInt(oChar, ADDED_SPELL + s))					
			bFound = TRUE;
		if (bFound)
		{
			if ( i < nAddedSpellCount - 1)			
				SetLocalInt(oChar, ADDED_SPELL + s, GetLocalInt(oChar, ADDED_SPELL + IntToString(i+1)));			
			else
				DeleteLocalInt(oChar, ADDED_SPELL + s);
		}
	}
	if (bFound)	
		SetLocalInt(oChar, ADDED_SPELL_COUNT, nAddedSpellCount - 1);			
	else if (CanSwapSpells(oChar, nLevel, nSelectedClassID))
		SetLocalString(oChar, REMOVED_SPELL, IntToString(nSpellID));
	else
		return;
	
	string sLevel = IntToString(nLevel);
	object oLB1 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel);
	object oLB2 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_ADDED_SPELL_LIST_ + sLevel);		
	string sSpellID = IntToString(nSpellID);
	CSLSetListBoxRowVisible(oLB1, sSpellID, TRUE);
	CSLSetListBoxRowVisible(oLB2, sSpellID, FALSE);
	nSpellPoints += 1;
	SetSpellPoolPointsAvailableByLevel(oChar, nLevel, nSpellPoints);
	SetGUIObjectText(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "POINT_POOL_TEXT", -1, IntToString(nSpellPoints));
	CSLRefreshListBox(oLB1);
	CSLRefreshListBox(oLB2);	
}

void UpdateSpellListBoxes(object oChar, int nLevel)
{
	int i;
	for (i = 0; i < 10; i++)
	{
		string s = IntToString(i);
		int bHidden = (nLevel != i);		
		SetGUIObjectHidden(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, CUSTOM_ADDED_SPELL_LIST_ + s, bHidden);
		SetGUIObjectHidden(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, CUSTOM_AVAILABLE_SPELL_LIST_ + s, bHidden);		
	}
	int nPoints = GetSpellPoolPointsAvailableByLevel(oChar, nLevel);
	SetGUIObjectText(OBJECT_SELF, SCREEN_LEVELUP_SPELLS, "POINT_POOL_TEXT", -1, IntToString(nPoints));
}

int GetInitialSpellsAvailableByClassAndLevel(object oChar, int nClass, int nSpellLevel)
{
	int nLevels = CSLGetLevelsByClass(oChar, nClass);
	if (nClass == 10) //Wizards are hardcoded. 2 spells per level or 3 _ Intmodifier 1st level spells at Level 1.
	{
		if (nLevels == 0)
			return 3 + GetIntBonusPoints(oChar);
		else
			return 2;
	}
	
	string spKnown = Get2DAString("classes", "SpellKnownTable", nClass);
	if (spKnown != "")
	{
		if (nLevels == 0)
			return StringToInt(Get2DAString(spKnown, SPELL_LEVEL + IntToString(nSpellLevel), nLevels));
		else
		{
			int nPrev = StringToInt(Get2DAString(spKnown, SPELL_LEVEL + IntToString(nSpellLevel), nLevels - 1));
			int nCurr = StringToInt(Get2DAString(spKnown, SPELL_LEVEL + IntToString(nSpellLevel), nLevels));
			return nCurr - nPrev;			
		}
	}
	return 0;
}

void AssignPurchasedSpells(object oChar)
{
	string sRemoved = GetLocalString(oChar, REMOVED_SPELL);
	int nRemovedSpellID = StringToInt(sRemoved);
	int nClassPosition = 1;
	int i;	
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	if (GetClassByPosition(2, oChar) == nSelectedClassID)
		nClassPosition = 2;
	else if (GetClassByPosition(3, oChar) == nSelectedClassID)
		nClassPosition = 3;
	else if (GetClassByPosition(4, oChar) == nSelectedClassID)
		nClassPosition = 4;
	
	//Yes despite the fact the GetClassByPosition retiursn values ranging from 1-4, 
	//SetSpells Known wants positons numbers from 0-3, so subtract 1.
	nClassPosition -= 1;
	SetSpellKnown(oChar, nClassPosition, nRemovedSpellID, FALSE, TRUE);
	
	int nAddedSpellCount = GetLocalInt(oChar, ADDED_SPELL_COUNT);
	for(i = 0; i < nAddedSpellCount; i++)
	{
		int nSpellID = GetLocalInt(oChar, ADDED_SPELL + IntToString(i));
		SetSpellKnown(oChar, nClassPosition, nSpellID, TRUE, TRUE);
	}
}
