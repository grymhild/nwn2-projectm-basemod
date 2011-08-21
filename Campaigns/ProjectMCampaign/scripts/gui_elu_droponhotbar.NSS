#include "elu_hotbar_i"

void main(string sButtonID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);		
	SetLocalString(oChar, LAST_HOTBARBUTTON_DROP, sButtonID);
}