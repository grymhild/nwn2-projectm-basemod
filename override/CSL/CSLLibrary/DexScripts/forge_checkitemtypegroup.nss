
int StartingConditional(string CheckItemTypeGroup)
{
	object oPC=GetPCSpeaker();
	string ItemType=GetLocalString(oPC, "Forge_ItemBaseTypeGroup");
	
	if (ItemType==CheckItemTypeGroup) return TRUE; else return FALSE;
}
