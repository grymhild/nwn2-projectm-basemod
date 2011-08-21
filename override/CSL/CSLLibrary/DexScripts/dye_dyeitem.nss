void main(int iColorGroup, int iColorToDye)
{
    object oPC = OBJECT_SELF;
    object oChest = GetObjectByTag("StoreStash",0);

    int iItemToDye = GetLocalInt(oPC, "ItemTypeToDye");
    int iMaterialToDye = GetLocalInt(oPC, "ComponentToDye");
    //int iColorGroup = GetLocalInt(oPC, "ColorGroup");
    //int iColorToDye = GetLocalInt(oPC, "ColorToDye");

    int iColor = (iColorGroup * 8) + iColorToDye;
    object oItem = GetItemInSlot(iItemToDye, oPC);

    if (GetIsObjectValid(oItem)) {
        // Set armor to being edited
        SetLocalInt(oItem, "mil_EditingItem", TRUE);

        // Copy item to the chest
        object oInChest = CopyItem(oItem, oChest, TRUE);
        DestroyObject(oItem);

        // Dye the item
        object oDyedItem = CopyItemAndModify(oInChest, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);
        DestroyObject(oInChest);

        // Copy the armor back to the PC
        object oOnPC = CopyItem(oDyedItem, oPC, TRUE);
        DestroyObject(oDyedItem);

        // Equip the armor
       DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oOnPC, iItemToDye)));

       // Set armor editable again
       DelayCommand(3.0f, DeleteLocalInt(oOnPC, "mil_EditingItem"));
    }
}
