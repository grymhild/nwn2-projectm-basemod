#include "elu_hotbar_i"

void main(string sObjectID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);	
	string sButtonID = GetLocalString(oChar, LAST_HOTBARBUTTON_DROP);
	string sButtonData = "I" + sObjectID + ":"; //add other data as needed
	SetLocalString(oChar, DATA_HOTBARBUTTON + sButtonID, sButtonData);
}