void CollectItems();
void ProcessItems();

object oPawnFairy=OBJECT_SELF;

void main()
{
    if (GetLocalInt(oPawnFairy, "Processing")!=1)
    {
        CollectItems();
        SetLocalInt(oPawnFairy, "Processing", 1);
        ProcessItems();
        SetLocalInt(oPawnFairy, "Processing", 0);
     }
}

void CollectItems()
{
    object oItem = GetNearestObject(OBJECT_TYPE_ITEM);

    if (oItem != OBJECT_INVALID)
    {
        ActionMoveToObject(oItem);
        ActionPickUpItem(oItem);
    }
}

void ProcessItems()
{
    object oItem, oContainerItem, oCopiedItem;

    //Move collected items to the pawn shop
    oItem=GetFirstItemInInventory(oPawnFairy);
    while (GetIsObjectValid(oItem)==TRUE)
    {
        if (GetHasInventory(oItem)==TRUE)
        {
            oContainerItem=GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oContainerItem)==TRUE)
            {
                DestroyObject(oContainerItem,0.0);
                oContainerItem=GetNextItemInInventory(oItem);
            }
        }

        DestroyObject(oItem);
        oItem=GetNextItemInInventory(oPawnFairy);
    }
}