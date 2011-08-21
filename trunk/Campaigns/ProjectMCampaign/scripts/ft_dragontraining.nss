
void main()
{
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
	if (!GetIsObjectValid(oSkin))
	{
		SendMessageToPC(OBJECT_SELF, "Error FEAT_DRAGON_TRAINING needs a player skin to work properly.");
		WriteTimestampedLogEntry("Error FEAT_DRAGON_TRAINING needs a player skin to work properly.");
	}
	else
	{
		if (!GetLocalInt(oSkin, "FEAT_DRAGON_TRAINING"))
		{
			itemproperty ipac = ItemPropertyACBonusVsRace(RACIAL_TYPE_DRAGON, 4);
			AddItemProperty(DURATION_TYPE_PERMANENT, ipac, oSkin);
			SetLocalInt(oSkin, "FEAT_DRAGON_TRAINING", 1);
		}
	}
}