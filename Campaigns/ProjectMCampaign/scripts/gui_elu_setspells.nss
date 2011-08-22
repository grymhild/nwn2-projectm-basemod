#include "elu_spells_i"
#include "_CSLCore_Magic"

void CreateSpellListListBoxRow(object oChar, int nSpellID, string sName, string sIcon, string sLevel)
{	
	object oLB1 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_ADDED_SPELL_LIST_ + sLevel);
	object oLB2 = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel);
	int bKnown = GetSpellKnown(oChar, nSpellID);
	
	if (!GetIsObjectValid(oLB1))
		h2_LogMessage(H2_LOG_DEBUG, "olB1 was not valid");
	
	string sSpellID = IntToString(nSpellID);
	string sRowName =  sSpellID;
	string sTextFields = "SPELL_TEXT=" + sName;
	string sTextures = "SPELL_IMAGE=" + sIcon + ".tga";
	string sVariables = "0=" + sSpellID;	
	CSLAddListBoxRow(oLB1, sRowName, sTextFields, sTextures, sVariables, "", bKnown);
	CSLAddListBoxRow(oLB2, sRowName, sTextFields, sTextures, sVariables, "", !bKnown);		
}

void ProcessSpellbook(object oChar, object oSpellBook, int iStartRow, int iEndRow, int nBannedSchool)
{
	int i = 0;
	int iCurrent;
	int maxIterations = 75;
	for (iCurrent = iStartRow; iCurrent <= iEndRow; iCurrent++) 
	{
		if (i > maxIterations)
		{
			DelayCommand(0.1, ProcessSpellbook(oChar, oSpellBook, iCurrent, iEndRow, nBannedSchool));
			return;
		}
		int nSpellID = CSLDataTableGetRowByIndex(oSpellBook, iCurrent);
		string sDoNotShow = Get2DAString("spells", "DoNotShowOnLevelUp", nSpellID);
		if (sDoNotShow != "1")
		{
			int nSpellSchool = CSLGetSchoolByInitial(Get2DAString("spells", "School", nSpellID));
			if (nSpellSchool != nBannedSchool)
			{
				string sName = CSLDataTableGetStringByRow(oSpellBook, "Name", nSpellID);							
				string sIcon = Get2DAString("spells", "IconResRef", nSpellID);			
				string sLevel = CSLDataTableGetStringByRow(oSpellBook, "Level", nSpellID);						
				CreateSpellListListBoxRow(oChar, nSpellID, sName, sIcon, sLevel);								
			}
		}				
		i++;
	}
	
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	string spGain = Get2DAString("classes", "SpellGainTable", nSelectedClassID);	
	int nHighestGainLevel = 0;
	int nTotalLevels = CSLGetLevelsByClass(oChar, nSelectedClassID); 
	for (i = 0; i < 10; i++)
	{
		string sLevel = IntToString(i);		
		object oLB = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_ADDED_SPELL_LIST_ + sLevel);	
		CSLRefreshListBox(oLB);
		oLB = CSLGetListBoxObject(oChar, SCREEN_LEVELUP_SPELLS, CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel);
		CSLRefreshListBox(oLB);
		
		if (Get2DAString(spGain, "SpellLevel" + sLevel, nTotalLevels) != "")
			nHighestGainLevel = i;
	}	
	SetLocalInt(oChar, DONE_PROCESSING_SPELLS, 1);	
	UpdateSpellListBoxes(oChar, nHighestGainLevel);
	
	if (nTotalLevels == 0 && nSelectedClassID == 10)
		AddAllCantrips(oChar);	//Wizards get all cantrips for free
	
	SetGUIObjectHidden(oChar, SCREEN_LEVELUP_SPELLS, "SPELL_LEVEL_GRID", FALSE);
	h2_LogMessage(H2_LOG_DEBUG, "Finshed executing all delayed actions in gui_elu_setspells.");
}



void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executing gui_elu_setspells");	
	object oChar = GetControlledCharacter(OBJECT_SELF);
	int nSelectedClassID = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	int nBannedSchool = -1;
	if (nSelectedClassID == 10) //Leveling up as a wizard check for school specialization
		nBannedSchool = CSLGetBannedSchool(GetLocalInt(oChar, "SC_iSpellSchool"));
	object oSpellBook = CSLGetSpellBookByClass( nSelectedClassID ); 
	if (GetIsObjectValid(oSpellBook))
	{
		int iEndRow = CSLDataTableCount( oSpellBook )-2;
		int i;
		for (i = 0; i < 10; i++)
		{
			string sLevel = IntToString(i);
			CSLCreateListBoxObject(oChar, "SCREEN_LEVELUP_SPELLS", CUSTOM_ADDED_SPELL_LIST_ + sLevel, "SPELL_ACTION,SPELL_IMAGE,SPELL_TEXT");
			CSLCreateListBoxObject(oChar, "SCREEN_LEVELUP_SPELLS", CUSTOM_AVAILABLE_SPELL_LIST_ + sLevel, "SPELL_ACTION,SPELL_IMAGE,SPELL_TEXT");
			int nSpells = GetInitialSpellsAvailableByClassAndLevel(oChar, nSelectedClassID, i);
			SetLocalInt(oChar, SPELL_LEVEL + sLevel, nSpells);
		}	
		ProcessSpellbook(oChar, oSpellBook, 0, iEndRow, nBannedSchool);
	}
	else
		WriteTimestampedLogEntry("Spellbook for classID: " + IntToString(nSelectedClassID) + " was not valid.");
}