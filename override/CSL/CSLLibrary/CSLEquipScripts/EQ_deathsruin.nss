//::///////////////////////////////////////////////
//:: Death's Ruin
//:: cmi_s2_deathsruin
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 3, 2008
//:://////////////////////////////////////////////

#include "_CSLCore_Items"

void main()
{		
		float fDuration = HoursToSeconds(24);

		object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	    if (GetIsObjectValid(oWeapon1))
	    {
			CSLSafeAddItemProperty(oWeapon1, ItemPropertyBonusFeat(393) , fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);	
		}	
		else if (GetIsObjectValid(oWeapon2))
		{
			CSLSafeAddItemProperty(oWeapon2, ItemPropertyBonusFeat(393), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);			
		}
		else
		{	
			object oBracer = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);
			if (GetIsObjectValid(oBracer))
		    {
				CSLSafeAddItemProperty(oBracer, ItemPropertyBonusFeat(393), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);			
			}			
		}		
				
}