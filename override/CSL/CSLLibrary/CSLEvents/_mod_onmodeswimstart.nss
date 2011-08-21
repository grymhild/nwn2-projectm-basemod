#include "_SCInclude_Mode"
#include "_CSLCore_Items"

void main()
{
   object oPC = OBJECT_SELF;
	if ( !GetIsObjectValid( oPC) )
	{
		return;
	}
	
	//SendMessageToPC( oPC, "Swim Mode Start Script");
	CSLHideHeldItems( oPC, 0.0f, ITEMS_SHOWN_INVISIBLE );
	
	CSLForceUnequip( oPC, GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), INVENTORY_SLOT_CLOAK );
	CSLForceUnequip( oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), INVENTORY_SLOT_CHEST );
	//ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST));
	//ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CLOAK));
	
}