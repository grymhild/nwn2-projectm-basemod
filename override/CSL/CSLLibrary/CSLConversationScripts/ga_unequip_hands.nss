// ga_unequip_hands
/*
	unequip hands, and mark items so they can be restored
*/
// ChazM 6/27/06
// EPF 8/29/06 - uneqip offhand before main hand, else the offhand weapon is switched to the main
// hand by the engine.

#include "_CSLCore_Messages"
#include "_CSLCore_Items"

void main(string sOwner)
{
	object oOwner =  CSLGetTarget(sOwner);
	
	CSLRememberEquippedItem(oOwner, INVENTORY_SLOT_LEFTHAND);
	CSLUnequipSlot(oOwner, INVENTORY_SLOT_LEFTHAND);
	
	CSLRememberEquippedItem(oOwner, INVENTORY_SLOT_RIGHTHAND);
	CSLUnequipSlot(oOwner, INVENTORY_SLOT_RIGHTHAND);
}	