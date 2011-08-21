int ItemRegistered(object oItem, object oStoreStash);
void FilterItem(object oItem);
int DupeCheck(object oItem, object oPawnShop);
int ItemsEqual(object oItem1, object oItem2);

//********************************************************************************

//Checks if the Item's ResRef is already in the module's templates or in the global templates (By trying to create the item from scratch using the resRef).
//Return Values: 0 - ResRef not registered at all, 1 - ResRef Registered but properties are Different, 2-(Discontinued), 3- ResRef Registered and Properties are the same.
int ItemRegistered(object oItem, object oStoreStash)
{
    int CSLHasItemByTag;
    string ResRef;
    object oCopiedItem;

    if  (oStoreStash==OBJECT_INVALID) oStoreStash=GetObjectByTag("StoreStash",0);

    ResRef=GetResRef(oItem);
    if (ResRef=="")
    {
        CSLHasItemByTag=0;
    }
    else
    {
        oCopiedItem=CreateItemOnObject(ResRef, oStoreStash, 1);
        if (ItemsEqual(oItem, oCopiedItem)==1) CSLHasItemByTag=3; else CSLHasItemByTag=1;
        DestroyObject(oCopiedItem);
    }
    return CSLHasItemByTag;
}

//********************************************************************************

//Remedy Plot, Cursed, unDroppable, Stolen, Unidentified, Partially Charged, and Partial Ammo stack Items.  Calling code should only call this for an already copied item, not on a PC's original inventory.
void FilterItem(object oItem)
{
    if (GetPlotFlag(oItem)==TRUE) SetPlotFlag(oItem, FALSE);
    if (GetItemCursedFlag(oItem)==TRUE) SetItemCursedFlag(oItem, FALSE);
    if (GetDroppableFlag(oItem)==FALSE) SetDroppableFlag(oItem, TRUE);
    if (GetStolenFlag(oItem)==TRUE) SetStolenFlag(oItem, FALSE);
    if (GetIdentified(oItem)==FALSE) SetIdentified(oItem, TRUE);
    SetItemCharges(oItem, 50);
    if (GetBaseItemType(oItem)==BASE_ITEM_ARROW) SetItemStackSize(oItem, 99); else SetItemStackSize(oItem, 1);
}

//********************************************************************************

//Checks if the Pawn Shop already hosts this item.
int DupeCheck(object oItem, object oPawnShop)
{
    object oDupeItem;
    int Dupe=0;

    if (oPawnShop==OBJECT_INVALID) oPawnShop=GetObjectByTag("Store_PawnShop",0);

    oDupeItem=GetFirstItemInInventory(oPawnShop);
    while(GetIsObjectValid(oDupeItem)==TRUE && Dupe==0)
    {
		//SendMessageToPC (GetFirstPC(), "Pawn Item: " + GetName(oDupeItem));
        if (ItemsEqual(oItem, oDupeItem)==1) Dupe=1;
        oDupeItem=GetNextItemInInventory(oPawnShop);
    }

    return Dupe;
}

//********************************************************************************

//Compare two items.
int ItemsEqual(object oItem1, object oItem2)
{
    itemproperty Property1, Property2;
    int Equal=1;

	//Start With Tags
    if (GetTag(oItem1)==GetTag(oItem2))
    {
		//Next check template ResRef
        if (GetResRef(oItem1)==GetResRef(oItem2))
        {
			//Now check the values (This should almost always prevent a property by property compare if there are any differences)
            if (GetGoldPieceValue(oItem1)==GetGoldPieceValue(oItem2) || GetItemStackSize(oItem1)!=GetItemStackSize(oItem2))
            {
                Property1=GetFirstItemProperty(oItem1);
                Property2=GetFirstItemProperty(oItem2);
				//Compare properties
                while (GetIsItemPropertyValid(Property1)==TRUE && GetIsItemPropertyValid(Property2)==TRUE && Equal==1)
                {
					//Property Type
                    if (GetItemPropertyType(Property1)==GetItemPropertyType(Property2))
                    {
						//Property Subtype
                        if (GetItemPropertySubType(Property1)==GetItemPropertySubType(Property2))
                        {
							//Param1
                            if (GetItemPropertyParam1(Property1)==GetItemPropertyParam1(Property2))
                            {
								//Param1Value
                                if (GetItemPropertyParam1Value(Property1)!=GetItemPropertyParam1Value(Property2)) Equal=0;
                            }
                            else
                            {
                                Equal=0;
                            }
                        }
                        else
                        {
                            Equal=0;
                        }
                    }
                    else
                    {
                        Equal=0;
                    }
                    Property1=GetNextItemProperty(oItem1);
                    Property2=GetNextItemProperty(oItem2);
                }
            }
            else
            {
                Equal=0;
            }
        }
        else
        {
            Equal=0;
        }
    }
    else
    {
        Equal=0;
    }
    return Equal;
}

//********************************************************************************