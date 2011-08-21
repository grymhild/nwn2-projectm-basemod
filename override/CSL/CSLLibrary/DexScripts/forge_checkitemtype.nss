int StartingConditional(int CheckItemType)
{
	object oPC=GetPCSpeaker();
	int ItemType=GetLocalInt(oPC, "Forge_ItemType");
	
	if (ItemType==CheckItemType) return TRUE; else return FALSE;
}