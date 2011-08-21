#include "elu_fam_ancom_i"

void main(int nLaunchMode)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sSelected;
	if (nLaunchMode == 1)
	{
		sSelected = GetLocalString(oChar, FAMILIAR_LAST_SELECTED);
		SetFamiliarOverride(oChar, sSelected);
		CloseGUIScreen(oChar, "SCREEN_LEVELUP_FAMILIARX3");
	}
	else
	{
		sSelected = GetLocalString(oChar, ANIMAL_COMPANION_LAST_SELECTED);
		SetAnimalCompanionOverride(oChar, sSelected);
	}
}