//::///////////////////////////////////////////////
//:: Arcane Infusion
//:: cmi_s2_arcinfus
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: August 12, 2008
//:://////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"
//#include "_CSLCore_Items"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	

	float fDuration = RoundsToSeconds(GetLevelByClass(CLASS_DAGGERSPELL_MAGE, OBJECT_SELF));
	itemproperty nItemProp1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6);
	itemproperty nItemProp2 = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);

	object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
	{
		CSLSafeAddItemProperty(oWeapon1, nItemProp1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		CSLSafeAddItemProperty(oWeapon1, nItemProp2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
	{
		CSLSafeAddItemProperty(oWeapon2, nItemProp1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		CSLSafeAddItemProperty(oWeapon2, nItemProp2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
}