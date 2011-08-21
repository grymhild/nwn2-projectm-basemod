#include "pawninclude"

//Scans the entire inventory of characters entering them module, including containers, and adds any item not sold by the standard merchants and not already in the pawn shop's inventory to th pawn shop's inventory
//Another script makes the pawn shop's acquired inventory infinite
//The pawn shop is not interested in super-uber or hacker items

void PawnShopScan(object oPC)
{
    object oPawnShop=GetObjectByTag("Store_PawnShop",0), oStoreStash=GetObjectByTag("StoreStash",0);
    object oItem, oContainerItem, oCopiedItem;
    int nCount, ItemValue, ItemType;

	//SendMessageToPC (oPC, "Your inventory was just scanned for possible custom-item additions to the Pawn Shop's inventory.  Don't worry it only copies things.");
	SendMessageToPC (GetFirstPC(), "Pawn Shop:\nStoreStash Name: " + GetName(oStoreStash) + ", Pawn Shop Name: " + GetName(oPawnShop));
	SendMessageToPC (GetFirstPC(), "StoreStash Tag: " + GetTag(oStoreStash) + ", Pawn Shop Tag: " + GetTag(oPawnShop));
	SendMessageToPC (GetFirstPC(), "Pawn Shop: Scanning Inventory");

    //Scan Inventory
    oItem=GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem)==TRUE)
    {
		SendMessageToPC (GetFirstPC(), "Inv Item: " + GetName(oItem));
		//Bags too
        if (GetHasInventory(oItem)==TRUE)
        {
			//Scan the Bag
            oContainerItem=GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oContainerItem)==TRUE)
            {
				SendMessageToPC (GetFirstPC(), "Bag Item: " + GetName(oContainerItem));
				//Pawn Shop don't want overly uber stuff
                ItemValue=GetGoldPieceValue(oContainerItem);
                if (ItemValue>0 && ItemValue<16777217)
                {
					//Check that either if the resRef is not in the module or that the item properties are different
                    if (ItemRegistered(oContainerItem, oStoreStash)<2)
                    {
						//See if the Pawn Shop doesn't already have this Item.
                        //if (DupeCheck(oContainerItem, oPawnShop)==0)
						if (1==1) //GetNextItemInInventory for stores is broken (Obsidian)!!
                        {
							//After all that dupe checking, Add the Item to the Pawn Shop!
                            oCopiedItem=CopyItem(oContainerItem, oPawnShop, TRUE);
							//Remove Curses, etc, ID the Item, Recharge charges, make ammo a full stack, etc..
                            FilterItem(oCopiedItem);
							SendMessageToPC (GetFirstPC(), "Bag Item Added to Pawn Shop");
                        }
                    }
                }
                oContainerItem=GetNextItemInInventory(oItem);
            }
        }
		//Don't forget the bag itself (also non-bag items)!!
        ItemValue=GetGoldPieceValue(oItem);
		//Super-Uber filter
        if (ItemValue>0 && ItemValue<16777217)
        {
			//Check if module has item
            if (ItemRegistered(oItem, oStoreStash)<2)
            {
				//Dupe-Check against pawn-shop
                //if (DupeCheck(oItem, oPawnShop)==0)
				if (1==1) //GetNextItemInInventory for stores is broken (Obsidian)!!
                {
                    oCopiedItem=CopyItem(oItem, oPawnShop, TRUE);
                    FilterItem(oCopiedItem);
					SendMessageToPC (GetFirstPC(), "Inv Item Added to Pawn Shop");
                }
            }
        }
        oItem=GetNextItemInInventory(oPC);
    }

	SendMessageToPC (GetFirstPC(), "Pawn Shop: Scanning equipped items");

	//Scan equipped items now!  Not even airport scanners are this vigilant!
    for ( nCount = 0; nCount < NUM_INVENTORY_SLOTS; nCount++ )
    {
        oItem = GetItemInSlot(nCount,oPC);
        if (GetIsObjectValid(oItem)==TRUE)
        {
			SendMessageToPC (GetFirstPC(), "Equip Item: " + GetName(oItem));
			//Super-Uber filter
            ItemValue=GetGoldPieceValue(oItem);
            if (ItemValue>0 && ItemValue<16777217)
            {
				//Check if module has item
                if (ItemRegistered(oItem, oStoreStash)<2)
                {
					//Dupe-Check against pawn-shop's existing inventory
					//if (DupeCheck(oItem, oPawnShop)==0)
					if (1==1) //GetNextItemInInventory for stores is broken (Obsidian)!!
                    {
                        oCopiedItem=CopyItem(oItem, oPawnShop, TRUE);
                        FilterItem(oCopiedItem);
						SendMessageToPC (GetFirstPC(), "Equip Item Added to Pawn Shop");
                    }
                }
            }
        }
    }
	SendMessageToPC (GetFirstPC(), "Pawn Shop: Done with scan");
}