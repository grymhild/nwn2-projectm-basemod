#include "forge_include"

void main (int PropertyType=-1, int PropertySubType=-1)
{
	object oPC=GetPCSpeaker(), oItem;
	itemproperty ExistingItemProperty;
	
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);
	oItem=GetLocalObject(oPC, "Forge_Item");

	//Filter Item Property
	if (GetIsObjectValid(oItem)==TRUE)
	{
		if (PropertyType<0) PropertyType=GetLocalInt(oPC, "Forge_ItemPropertyType");
		if (PropertyType>-1)
		{
			if (PropertySubType<0) PropertySubType=GetLocalInt(oPC, "Forge_ItemPropertySubType");
		}
		else
		{
			return;
		}
	}
	else
	{
		return;
	}
	
	//Find if Item has a property of the same type and subtype
	SendMessageToPC(GetFirstPC(), "Property To Remove: Type=" + IntToString(PropertyType) + " SubType=" + IntToString(PropertySubType));
	ExistingItemProperty=FindItemProperty(oItem, PropertyType, PropertySubType);
	if (GetIsItemPropertyValid(ExistingItemProperty)==TRUE)
	{
		//If so, remove it
		SendMessageToPC(GetFirstPC(), "Property Removed");
		RemoveItemProperty(oItem, ExistingItemProperty);
	}
}