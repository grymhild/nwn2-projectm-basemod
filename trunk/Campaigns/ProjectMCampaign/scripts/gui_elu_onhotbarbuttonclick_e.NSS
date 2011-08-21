#include "elu_hotbar_i"

void main(string sButtonID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	SendMessageToPC(oChar, "HotbarButtonID: " + sButtonID);
	string sButtonData = GetLocalString(oChar, DATA_HOTBARBUTTON + sButtonID);
	string sMsg = "ButtonType: ";
	if (sButtonData != "")
	{
		int nIndex = FindSubString(sButtonData, ":", 0);
		string sData = GetStringLeft(sButtonData, nIndex);
		string sButtonType = GetStringLeft(sData, 1);
		string sID = GetStringRight(sData, GetStringLength(sData) - 1);	
		if (sButtonType == "S")
			 sMsg += "SKILL\nSkillID: " + sID;
		else if (sButtonType == "I")
			 sMsg += "ITEM\nObjectID: " + sID;
		else if (sButtonType == "P")
		{
			sData = GetStringRight(sButtonData, GetStringLength(sButtonData) - (nIndex+1));
			nIndex = FindSubString(sData, ":", 0);
			string sClassIndex = GetStringLeft(sData, nIndex);
			string sMetaMagicID = GetStringRight(sData, GetStringLength(sData) - (nIndex+1));
			sMsg += "SPELL\nSpellID: " + sID + "\nClassIndex: " + sClassIndex + "\nMetaMagicID: " + sMetaMagicID;
		}
		else if (sButtonType == "F")
			sMsg += "FEAT\nFeatID: " + sID; 
		else if (sButtonType == "B")
			sMsg += "BARDSONG\nSongID: " + sID;
		else if (sButtonType == "M")
			sMsg += "MODE\nModeID: " + sID;
	}
	else
		sMsg += "EMPTY"; 
	SendMessageToPC(oChar, sMsg);
}