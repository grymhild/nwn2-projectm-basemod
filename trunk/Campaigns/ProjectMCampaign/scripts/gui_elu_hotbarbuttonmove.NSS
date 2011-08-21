#include "elu_hotbar_i"

void main(string sButtonID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sButtonMovedTo = GetLocalString(oChar, LAST_HOTBARBUTTON_DROP);
	string sButtonData = GetLocalString(oChar, DATA_HOTBARBUTTON + sButtonID);
	DeleteLocalString(oChar, DATA_HOTBARBUTTON + sButtonID);
	SetLocalString(oChar, DATA_HOTBARBUTTON + sButtonMovedTo, sButtonData);
}