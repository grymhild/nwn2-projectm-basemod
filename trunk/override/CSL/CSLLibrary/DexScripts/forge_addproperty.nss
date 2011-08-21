#include "forge_include"

void main (int PropertyType=-1, int PropertySubType=-1, int PropertyValue=-1, int ExtraParamValue1=-1)
{
	object oPC=GetPCSpeaker(), oItem;
	itemproperty NewItemProperty, ExistingItemProperty;

	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);
	oItem=GetLocalObject(oPC, "Forge_Item");

	//Filter the perameters
	if (GetIsObjectValid(oItem)==TRUE)
	{
		if (PropertyType<0) PropertyType=GetLocalInt(oPC, "Forge_ItemPropertyType");
		if (PropertyType>-1)
		{
			if (PropertySubType<0) PropertySubType=GetLocalInt(oPC, "Forge_ItemPropertySubType");
			if (PropertyValue<0) PropertyValue=GetLocalInt(oPC, "Forge_ItemPropertyValue");
			if (ExtraParamValue1<0) ExtraParamValue1=GetLocalInt(oPC, "Forge_ItemExtraParamValue1");
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

	//Generate Item Property object for new or updated item property
	SendMessageToPC(GetFirstPC(), "Property To Add: Type=" + IntToString(PropertyType) + " SubType=" + IntToString(PropertySubType) + " PropertyValue=" + IntToString(PropertyValue) + " ExtraParamValue1=" + IntToString(ExtraParamValue1));
	NewItemProperty=GenerateItemProperty(PropertyType, PropertySubType, PropertyValue, ExtraParamValue1);
	if (GetIsItemPropertyValid(NewItemProperty)==TRUE)
	{
		//Find if Item has a property of the same type and subtype
		ExistingItemProperty=FindItemProperty(oItem, PropertyType, PropertySubType);
		if (GetIsItemPropertyValid(ExistingItemProperty)==TRUE)
		{
			//If so, remove it before adding the new property
			SendMessageToPC(GetFirstPC(), "Old Property of same type/subtype removed");
			RemoveItemProperty(oItem, ExistingItemProperty);
		}
		//Add new property
		SendMessageToPC(GetFirstPC(), "New Property Added");
		AddItemProperty(DURATION_TYPE_PERMANENT, NewItemProperty, oItem, 0.0);
	}
}