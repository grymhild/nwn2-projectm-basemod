// ga_give_inventory
/*
	This script takes items from sGiver's inventory and gives it to sReceiver.
	
	Parameters:
		string sGiver = Tag of object giving items.  Default is OWNER.
		string sReceiver = Tag of object receiving items.  Default is PC.
		int iInventoryContents = Which items to donate: 
			0 = All inventory items, equipped items and gold. (Giver must be creature)
			1 = All inventory items only. 
	        2 = All equipped items only. (Giver must be creature)
*/
// CGaw 3/10/06
// ChazM 3/15/06 - minor changes	


#include "_CSLCore_Items"
#include "_CSLCore_Messages"
	
void main(string sGiver, string sReceiver, int iInventoryContents)
{
	object oGiver = CSLGetTarget(sGiver, CSLTARGET_OWNER);
	object oReceiver = CSLGetTarget(sReceiver, CSLTARGET_PC);
	//PrettyDebug ("sGiver = " + GetName(oGiver));
	//PrettyDebug ("sReceiver = " + GetName(oReceiver));

	switch(iInventoryContents)
	{
		case 0: 
			CSLGiveEverything(oGiver, oReceiver);
			break;
		case 1:
			CSLGiveAllInventory(oGiver, oReceiver);
			break;
		case 2:
			CSLGiveAllEquippedItems(oGiver, oReceiver);
			break;
	}
}