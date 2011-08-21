//This script opens the monster arena control-room doors for PCs only and then autocloses/locks them with half the normal delay.
void main()
{
    object oBench=OBJECT_SELF, oPC=GetLastOpenedBy(), oBenchOwner, oItem;
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	oItem=GetLocalObject(oPC, "Forge_Item");
	if (GetIsObjectValid(oItem)==TRUE)
	{
		SendMessageToPC(GetFirstPC(), "BenchOpen: Retrieving Registered forge Item (Tag=" + GetTag(oItem) + ") for PC (Name=" + GetName(oPC) + ")");
		CopyItem(oItem, oBench, FALSE);
	}
	else
	{
		SendMessageToPC(GetFirstPC(), "BenchOpen: No item registered on the forge for PC (Name=" + GetName(oPC) + ")");
	}
}