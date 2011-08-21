#include "_CSLEvent_Mod_i"
#include "hcr2_core_i"
#include "elu_hotbar_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onunacquireitem");

	object oPC = GetModuleItemLostBy();
	object oItem = GetModuleItemLost();

	// ignore this, is being dropped/removed via a special script
	if ( GetLocalInt(oItem, "ItemDestroyed") ) { return; }

	//object oFinder = GetItemPossessor(oItem);
	//object oWeapon = GetLastWeaponUsed(oPC);

	CSLDropItemAndMakePlaceable(oPC, oItem);

	h2_RemoveAddedOnHitProperty(oItem);
	ClearHotbarButtonItemData(oPC, oItem);
	ExecuteScript("x2_mod_def_unaqu",OBJECT_SELF);
}