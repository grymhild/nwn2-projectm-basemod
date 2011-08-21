#include "elu_functions_i"

void main(int nFeatID, string sScreen)
{		
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	int nSelectedFeat = GetLocalInt(oControlledChar, "SELECTED_FEAT");
	if (nSelectedFeat == nFeatID || nFeatID == -1)
		return;
	SetLocalInt(oControlledChar, "SELECTED_FEAT", nFeatID);
	
	string sFeatName = GetStringByStrRef(StringToInt(Get2DAString("feat", "feat", nFeatID)));
	string sDescription = GetStringByStrRef(StringToInt(Get2DAString("feat", "Description", nFeatID)));
	string sImage = Get2DAString("feat", "Icon", nFeatID) + ".tga";		
		
	SetGUITexture(OBJECT_SELF, sScreen, "INFOPANE_IMAGE", sImage);
	SetGUIObjectText(OBJECT_SELF, sScreen, "INFOPANE_TITLE", -1, sFeatName);
	SetGUIObjectText(OBJECT_SELF, sScreen, "INFOPANE_TEXT", -1, sDescription);
}