/*
This is a SP Official campaign script for features in the single player game
*/

//ga_append_stores
//This adds the inventory of a second store to an existing store.
//sTargetTag	- The Tag of the store you want to add the items to.
//sResRef		- The ResRef of the store blueprint that you want to copy the items from.
//NLC 6/10/08 

/*This function appends the items in blueprint sResRef to oStore.
The primary function of this is to add the items in a store blueprint to a store that exists 
in the game world. It will return the appended store. */
object AppendStore(object oStore, string sStoreResRef)
{
	if(!GetIsObjectValid(oStore))
		return OBJECT_INVALID;
	
	object oNewStore = CreateObject(OBJECT_TYPE_STORE, sStoreResRef, GetLocation(oStore));
	if(GetIsObjectValid(oNewStore))
	{
		object oItem = GetFirstItemInInventory(oNewStore);
		while(GetIsObjectValid(oItem))
		{
			//PrettyDebug("Adding: " + GetName(oItem));
			object oNewItem = CopyItem(oItem, oStore, TRUE);
			if(GetInfiniteFlag(oItem))
			{
				SetInfiniteFlag(oNewItem, TRUE);
			}
			oItem = GetNextItemInInventory(oNewStore);
			//PrettyDebug("Next Adding: " + GetResRef(oItem));
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
	AppendStore(oStore, sResRef);
}