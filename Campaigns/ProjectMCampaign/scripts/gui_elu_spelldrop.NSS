#include "elu_hotbar_i"

void main(string sSpellID, string sClassIndex, string sMetaMagicID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);	
	string sButtonID = GetLocalString(oChar, LAST_HOTBARBUTTON_DROP);
	string sButtonData = "P" + sSpellID + ":" + sClassIndex + ":" + sMetaMagicID; //add other data as needed
	SetLocalString(oChar, DATA_HOTBARBUTTON + sButtonID, sButtonData);
	DeleteLocalString(oChar, LAST_HOTBARBUTTON_DROP);	
}