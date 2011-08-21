// ga_destroy_item
/*
    This takes an item from a player
        sItemTag    = This is the string name of the item's tag
        nQuantity   = The number of items to destroy. -1 is all of the Player's items of that tag.
        nPCFaction  = Take from the whole PC faction
*/
// FAB 9/30
// DBR 8/10/6
// NLC 9/9/08 - And, after 3 years, this works with stacked items.

//#include "nw_i0_plot"

int DestroyItems(object oTarget,string sItem,int nNumItems)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem) == TRUE && ( nCount < nNumItems || nNumItems == -1 ) )
    {
        if (GetTag(oItem) == sItem)
        {
            int nRemainingToDestroy = nNumItems - nCount;
			int nStackSize = GetNumStackedItems(oItem);
			
			if( nStackSize <= nRemainingToDestroy || nNumItems == -1 )
			{
				DestroyObject(oItem,0.1f);
				nCount += nStackSize;
			}
            else
			{
				int nNewStackSize = nStackSize - nRemainingToDestroy;
				SetItemStackSize(oItem, nNewStackSize);
				nCount += nStackSize;
				break;
			}
        }
        oItem = GetNextItemInInventory(oTarget);
    }
   return nCount;
}



void main(string sItemTag,int nQuantity,int bPCFaction)
{
    int nTotalItem;
    int nNewQuantity = nQuantity;
    object oPCF,oPC = (GetPCSpeaker()==OBJECT_INVALID?GetFirstPC():GetPCSpeaker());
    object oItem;       // Items in inventory

    if ( bPCFaction == 0 )
    {
        if ( nQuantity < 0 )    // Destroy all instances of the item
        {
            //nTotalItem = CSLGetNumItems( oPC,sItemTag );
            DestroyItems( oPC,sItemTag,-1 );
        }
        else
        {
           DestroyItems( oPC,sItemTag,nQuantity );
        }
    }
    else    // For multiple players
    {
        oPCF = GetFirstFactionMember(oPC,FALSE);
        while (( GetIsObjectValid(oPCF) )&&( nNewQuantity > 0 || nQuantity < 0 ))
        {
            if ( nQuantity < 0 )    // Destroy all instances of the item
            {
                //nTotalItem = CSLGetNumItems( oPCF,sItemTag );
                DestroyItems( oPCF,sItemTag,-1 );
            }
            else
            {
				//nTotalItem = CSLGetNumItems( oPCF,sItemTag );
				//int nStackSize = GetNumStackedItems(oItem);
				//nQuantity -= nTotalItem;
				//if (nQuantity<0)
				//{
				//	nTotalItem+=nQuantity;
				//	nQuantity=0;
				//}
                nNewQuantity -= DestroyItems( oPCF,sItemTag,nNewQuantity );
            }
            oPCF = GetNextFactionMember(oPC,FALSE);
        }
    }
}