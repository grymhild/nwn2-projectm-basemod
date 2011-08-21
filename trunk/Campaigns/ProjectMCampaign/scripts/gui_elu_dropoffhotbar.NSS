#include "elu_hotbar_i"

void main(string sButtonID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);	
	DeleteLocalString(oChar, DATA_HOTBARBUTTON + sButtonID);
}