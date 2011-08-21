
#include "elu_functions_i"

void main(int data)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	object oTarget = IntToObject(data);	
	SendMessageToPC(oChar, "fired gui_elu_useskill_e " + GetName(oTarget));
}