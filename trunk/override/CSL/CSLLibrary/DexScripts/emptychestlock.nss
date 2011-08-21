void main()
{
    object oChest;
    object oItem;

    oChest=OBJECT_SELF;

    SetLocked(oChest, TRUE);

    oItem=GetFirstItemInInventory(oChest);
    while(oItem!=OBJECT_INVALID)
        {
        DestroyObject(oItem,0.0);
        oItem=GetNextItemInInventory(oChest);
        }
}