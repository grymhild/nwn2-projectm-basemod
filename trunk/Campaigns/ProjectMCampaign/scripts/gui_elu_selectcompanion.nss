#include "elu_fam_ancom_i"

void main(string sRowName, int nLaunchMode)
{
	string sScreen = "SCREEN_LEVELUP_ANIMAL";
	if (nLaunchMode == 1)
		sScreen = "SCREEN_LEVELUP_FAMILIARX3";

	object oChar = GetControlledCharacter(OBJECT_SELF);

	if (nLaunchMode == 1)
		SetLocalString(oChar, FAMILIAR_LAST_SELECTED, sRowName);
	//else
	//	SetLocalString(oChar, ANIMAL_COMPANION_LAST_SELECTED, sRowName);
}