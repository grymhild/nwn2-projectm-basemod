/*
Filename:           hcr2_torch
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Jan. 21st, 2007
Summary:
HCR2 hcr2_torch item script.
This script fires via tag based scripting for the OnEquip, OnUnEquip events for this item.

-----------------
Revision: v1.04
Added code to handle item on acquire event

*/

#include "hcr2_torchesandlanterns_i"
#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the item is equipped
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_EQUIP)
    {
        h2_EquippedLightSource(FALSE);
    }
    // * This code runs when the item is unequipped
    // * Note that this event fires for PCs only
    else if (nEvent == X2_ITEM_EVENT_UNEQUIP)
    {
        h2_UnEquipLightSource(FALSE);
    }
	else if (nEvent == X2_ITEM_EVENT_ACQUIRE)
	{
		object oPC = GetModuleItemAcquiredBy();
		object oItem = GetModuleItemAcquired();
		object oAcquiredFrom = GetModuleItemAcquiredFrom();
		if (GetObjectType(oAcquiredFrom) == OBJECT_TYPE_STORE)
		{
			CreateItemOnObject(GetResRef(oItem), oPC, GetItemStackSize(oItem), "", FALSE);
			DestroyObject(oItem);			
		}
	}
}