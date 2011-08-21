#include "elu_fam_ancom_i"

void FilterCompanionListBox(object oChar, string sListBoxScreen, string sListBoxName, string sButtonName, int nFilterFeatID)
{
	int nRowCount = GetNum2DARows("hen_companion");
	int i = 0;
	string sFirstRow = "";
	for(i = 0; i < nRowCount; i++)
	{
		string sRowName = Get2DAString("hen_companion", "BASERESREF_PREFIX", i) + "1";
		int nFeatID = StringToInt(Get2DAString("hen_companion", "FeatID2", i));
		if (nFeatID != nFilterFeatID)
		{
			RemoveListBoxRow(OBJECT_SELF, sListBoxScreen, sListBoxName, sRowName);
		}
		else
		{
			string sTextFields = "COMPANION_TEXTFIELD=" + GetStringByStrRef(StringToInt(Get2DAString("hen_companion", "STRREF", i)));
			string sTextures = "";
			string sVariables = "0=" + GetStringLeft(sRowName, GetStringLength(sRowName) - 1) + ";";
			ModifyListBoxRow(OBJECT_SELF, sListBoxScreen, sListBoxName, sRowName, sTextFields, sTextures, sVariables, "");
		}
	}
	SetGUIObjectHidden(OBJECT_SELF, sListBoxScreen, sListBoxName, FALSE);
	SetGUIObjectHidden(OBJECT_SELF, sListBoxScreen, sButtonName, FALSE);

	SetGUIObjectDisabled(OBJECT_SELF, sListBoxScreen, sButtonName, TRUE);

	DeleteLocalString(oChar, ANIMAL_COMPANION_LAST_SELECTED);
	DeleteLocalString(oChar, FAMILIAR_LAST_SELECTED);

	h2_LogMessage(H2_LOG_DEBUG, "Finished executing gui_elu_setcompanion");
}

void main(int nLaunchMode)
{
	h2_LogMessage(H2_LOG_DEBUG, "Executing gui_elu_setcompanion ");
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);

	int nFilterFeat = -1;
	if (nLaunchMode == 1 || nLaunchMode == 2)
	{
		if (HasAsAddedFeat(oControlledChar, 8987)) //check for Improved Familiar Feat
			nFilterFeat = 8987;
		if (HasAsAddedFeat(oControlledChar, 8989) || (GetHasFeat(8989, oControlledChar, TRUE) && HasAsAddedFeat(oControlledChar, FEAT_SUMMON_FAMILIAR))) //check for Craft Construct Feat
			nFilterFeat = 8989;
		if (HasAsAddedFeat(oControlledChar, 8991)) //check for Elemental Familiar Feat
			nFilterFeat = 8991;

		if (nFilterFeat == -1 && nLaunchMode == 2)
			return;
		if (nLaunchMode == 2)
		{	//I close this because it was auto-opened, but I also added a impproved familiar type of feat, so I dont want the default list.
			CloseGUIScreen(OBJECT_SELF, "SCREEN_LEVELUP_FAMILIAR");
			return;
		}
		//nLaunchMode = 1 and an Enhanced Familiar feat was added

		FilterCompanionListBox(oControlledChar, "SCREEN_LEVELUP_FAMILIARX3", "COMPANION_LIST", "CHOICE_NEXT", nFilterFeat);
		return;
	}
	else
	{
		if (HasAsAddedFeat(oControlledChar, 2168)) //check for Improved Companion
			nFilterFeat = 2168;
		if (HasAsAddedFeat(oControlledChar, 8990)) //check for Elemental Companion Feat
			nFilterFeat = 8990;
		if (HasAsAddedFeat(oControlledChar, 8988)) //check for Dragon Companion Feat
			nFilterFeat = 8988;
		if (HasAsAddedFeat(oControlledChar, 3704)) //check for Telthor Companion
			nFilterFeat = 3704;
	}
	string sButton = "CHOICE_NEXT2";
	if (HasAsAddedFeat(oControlledChar, 199)) //check for Summon Companion feat, if present this is first time launch,
		sButton = "CHOICE_NEXT";

	FilterCompanionListBox(oControlledChar, "SCREEN_LEVELUP_ANIMAL", "COMPANION_LIST", sButton, nFilterFeat);
}