

void main()
{
	SendMessageToPC(GetFirstPC(), "executed unequipskin");

	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, GetFirstPC());
	AssignCommand(GetFirstPC(), ActionUnequipItem(oSkin));
}