#include "elu_feats_i"

void main(string sScreen, int nFeatID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);	
	
	AddFeat(oChar, sScreen, nFeatID);
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