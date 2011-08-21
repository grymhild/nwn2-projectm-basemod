/*
This is a SP Official campaign script for features in the single player game
*/
//ga_append_stores
//This adds the inventory of a second store to an existing store.
//sTargetTag	- The Tag of the store you want to add the items to.
//sResRef		- The ResRef of the store blueprint that you want to add the items to.
//NLC 6/10/08

#include "_CSLCore_Items"

/*This function is used to refresh oStore with all of the items in the store
blueprint sStoreResRef. This will basically check to see if the items in the store 
with resref sStoreResRef exist in oStore, and spawn them if not. */
object RefreshStore(object oStore, string sStoreResRef)
{
	if(!GetIsObjectValid(oStore))
		return OBJECT_INVALID;
	
	object oNewStore = CreateObject(OBJECT_TYPE_STORE, sStoreResRef, GetLocation(oStore));
	if(GetIsObjectValid(oNewStore))
	{
		object oItem = GetFirstItemInInventory(oNewStore);
		while(GetIsObjectValid(oItem))
		{
			string sResRef = GetResRef(oItem);
			
			if( !CSLHasItemByTag(oStore, sResRef) )	//If the store passed in does not have the item in the blueprint
			{
				object oNewItem = CopyItem(oItem, oStore, TRUE);	//Create it.
				if(GetInfiniteFlag(oItem))
				{
					SetInfiniteFlag(oNewItem, TRUE);
				}
			}
			oItem = GetNextItemInInventory(oNewStore);
		}
		
		DestroyObject(oNewStore);
		return oStore;
	}
	
	else
	{
		//PrettyDebug("Store ResRef did not return a valid object");
		return OBJECT_INVALID;
	}
}

void main(string sTargetTag, string sResRef)
{
	object oStore = GetObjectByTag(sTargetTag);
	RefreshStore(oStore, sResRef);
}