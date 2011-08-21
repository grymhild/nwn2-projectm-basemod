#include "elu_feats_i"

void main(string sScreen)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	if (GetLocalInt(oChar, "BonusFeatCount") <= 0)
		return;
	int nClass = GetLocalInt(oChar, LAST_SELECTED_CLASS);
	string packageline = Get2DAString("classes", "Package", nClass);
	int bAllocateByPackage;
	if (packageline != "")
	{
		string featpackage = Get2DAString("packages", "FeatPref2DA", StringToInt(packageline));
		if (featpackage != "")
		{
			AllocateFeatsByPackage(oChar, featpackage, sScreen);
			bAllocateByPackage = TRUE;			
		}
	}
	if (!bAllocateByPackage)
	{
		WriteTimestampedLogEntry("WARNING: There is no feat package associated with ClassID: " + IntToString(nClass));
		AllocateFeats(oChar, sScreen);
	}
		
	object oLB1 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST");
	object oLB2 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_ADDED_FEAT_LIST");
	int nBonusFeatCount = GetLocalInt(oChar, "BonusFeatCount");	
	SetGUIObjectText(OBJECT_SELF, sScreen, "POINT_POOL_TEXT", -1, IntToString(nBonusFeatCount));
	CSLRefreshListBox(oLB2);	
	if (nBonusFeatCount > 0)
		CSLRefreshListBox(oLB1);
	else
		SetGUIObjectHidden(OBJECT_SELF, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST", TRUE);
}