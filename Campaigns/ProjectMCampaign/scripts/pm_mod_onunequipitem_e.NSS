#include "_CSLEvent_Mod_i"
#include "hcr2_core_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onunequipitem");

	object oItem = GetPCItemLastUnequipped();
	object oPC = GetPCItemLastUnequippedBy();

	if (GetLocalInt(oPC, "LOADING")) return;

	// fix for missing hide attributes from items
	//CSLApplyItemProperties( oPC, oItem );
	DeleteLocalInt( oPC, "SC_ITEM_CACHED");
	DelayCommand( 0.5f, CSLCacheCreatureItemInformation( oPC ) );

	cmi_player_unequip(oPC);

	CSLEnviroUnequip( oItem, oPC );

	h2_RemoveAddedOnHitProperty(oItem);
	ExecuteScript("x2_mod_def_unequ",OBJECT_SELF);
}