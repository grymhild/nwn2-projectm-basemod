#include "elu_feats_i"

void main(string sScreen, int nFeatID)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sFeatID = IntToString(nFeatID);

	string sIndex;
	int nAddedFeatCount = GetLocalInt(oChar, "AddedFeatCount");
	int i, bFound;
	for(i = 0; i < nAddedFeatCount; i++)
	{
		sIndex = IntToString(i);
		string sIndexFeatID = GetLocalString(oChar, "AddedFeat" + sIndex);
		if (!bFound &&  sIndexFeatID == sFeatID)
		{
			int nAddType = GetLocalInt(oChar, "AddedFeat" + sIndex);
			if (sScreen != "SCREEN_LEVELUP_BONUS_FEATS" && nAddType == 1 || nAddType == -1)
				return;
			else
			{
				bFound = TRUE;
				object oLB1 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST");
				object oLB2 = CSLGetListBoxObject(oChar, sScreen, "CUSTOM_ADDED_FEAT_LIST");
				string sRowName = "FEAT" + sFeatID;
				CSLRemoveListBoxRow(oLB2, sRowName);
				if (sScreen == "SCREEN_LEVELUP_BONUS_FEATS")
				{
					object oLB3 = CSLGetListBoxObject(oChar, "SCREEN_LEVELUP_NORMAL_FEATS", "CUSTOM_ADDED_FEAT_LIST");
					CSLRemoveListBoxRow(oLB3, sRowName);
				}
				CSLSetListBoxRowVisible(oLB1, sRowName, 1);
				CSLRefreshListBox(oLB2);
				CSLRefreshListBox(oLB1);
				SetGUIObjectHidden(OBJECT_SELF, sScreen, "CUSTOM_AVAILABLE_FEAT_LIST", FALSE);
				int nBonusFeatCount = GetLocalInt(oChar, "BonusFeatCount") + 1;
				SetLocalInt(oChar, "BonusFeatCount", nBonusFeatCount);
				SetGUIObjectText(OBJECT_SELF, sScreen, "POINT_POOL_TEXT", -1, IntToString(nBonusFeatCount));
			}
		}
		if (bFound && i < nAddedFeatCount - 1)
		{
			string sNextFeatID = GetLocalString(oChar, "AddedFeat" + IntToString(i+1));
			SetLocalString(oChar, "AddedFeat" + sIndex, sNextFeatID);
		}
	}
	DeleteLocalString(oChar, "AddedFeat" + sIndex);
	SetLocalInt(oChar, "AddedFeatCount", nAddedFeatCount - 1);
}