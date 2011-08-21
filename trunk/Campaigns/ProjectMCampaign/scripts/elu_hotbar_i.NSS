
const string LAST_HOTBARBUTTON_DROP = "LAST_HOTBARBUTTON_DROP";
const string DATA_HOTBARBUTTON = "DATA_HOTBARBUTTON";
const string HOTBAR_BUTTON_ID = "HOTBAR_BUTTON_ID";

void ClearHotbarButtonItemData(object oChar, object oLostItem)
{
	string sObjectID = "I" + IntToString(ObjectToInt(oLostItem));
	int i = 0;
	object oSave = oChar;
	if (GetIsOwnedByPlayer(oChar))
		oSave = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);
	//120 is the max count of hotbar buttons
	//ex there are 10 rows of 12 hotbar buttons.
	for(i = 0; i < 120; i++)
	{		
		string sButtonData = GetLocalString(oSave, DATA_HOTBARBUTTON + IntToString(i));
		if (sButtonData != "")
		{
			int nIndex = FindSubString(sButtonData, ":", 0);
			if (GetStringLeft(sButtonData, nIndex) == sObjectID)
				DeleteLocalString(oSave, DATA_HOTBARBUTTON + IntToString(i));			
		}		
	}
}

object GetHotBarButtonPresser()
{
	return GetControlledCharacter(OBJECT_SELF);		
}

string GetHotBarButtonData()
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sButtonID = GetLocalString(oChar, HOTBAR_BUTTON_ID);
	object oSave = oChar;
	if (GetIsOwnedByPlayer(oChar))
		oSave = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);	
	return GetLocalString(oSave, DATA_HOTBARBUTTON + sButtonID);
}

void SetHotBarButtonData(string sButtonData)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);	
	string sButtonID = GetLocalString(oChar, LAST_HOTBARBUTTON_DROP);
	object oSave = oChar;
	if (GetIsOwnedByPlayer(oChar))
		oSave = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);	
	SetLocalString(oSave, DATA_HOTBARBUTTON + sButtonID, sButtonData);
	DeleteLocalString(oChar, LAST_HOTBARBUTTON_DROP);
}

void RemoveHotBarButtonData(string sButtonID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	object oSave = oChar;
	if (GetIsOwnedByPlayer(oChar))
		oSave = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);	
	DeleteLocalString(oSave, DATA_HOTBARBUTTON + sButtonID);
}

int GetIsHotBarButtonEmpty()
{
	string sButtonData = GetHotBarButtonData();		
	return (sButtonData == "");
}

int GetHotBarButtonSkillID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "S")
		return -1;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return StringToInt(sID);	
}

int GetHotBarButtonBardSongID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "B")
		return -1;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return StringToInt(sID);	
}

int GetHotBarButtonModeID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "M")
		return -1;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return StringToInt(sID);	
}

object GetHotBarButtonItem()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return OBJECT_INVALID;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "I")
		return OBJECT_INVALID;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return IntToObject(StringToInt(sID));	
}

int GetHotBarButtonSpellID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "P")
		return -1;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return StringToInt(sID);	
}

int GetHotBarButtonFeatID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "F")
		return -1;
	string sID = GetStringRight(sData, GetStringLength(sData) - 1);
	return StringToInt(sID);	
}

int GetHotBarButtonMetaMagicID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "P")
		return -1;
	sData = GetStringRight(sButtonData, GetStringLength(sButtonData) - (nIndex+1));
	nIndex = FindSubString(sData, ":", 0);
	string sMetaMagicID = GetStringRight(sData, GetStringLength(sData) - (nIndex+1));			
	return StringToInt(sMetaMagicID);	
}

int GetHotBarButtonSpellCasterClassID()
{
	string sButtonData = GetHotBarButtonData();
	if (sButtonData == "")
		return -1;
	int nIndex = FindSubString(sButtonData, ":", 0);
	string sData = GetStringLeft(sButtonData, nIndex);
	string sButtonType = GetStringLeft(sData, 1);
	if (sButtonType != "P")
		return -1;
	sData = GetStringRight(sButtonData, GetStringLength(sButtonData) - (nIndex+1));
	nIndex = FindSubString(sData, ":", 0);
	string sClassIndex = GetStringLeft(sData, nIndex);
	return StringToInt(sClassIndex);	
}