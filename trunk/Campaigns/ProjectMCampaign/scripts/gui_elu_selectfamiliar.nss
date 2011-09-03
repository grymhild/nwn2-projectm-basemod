#include "elu_fam_ancom_i"

void main(string sRowName)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	SetLocalString(oChar, FAMILIAR_LAST_SELECTED, sRowName);
}