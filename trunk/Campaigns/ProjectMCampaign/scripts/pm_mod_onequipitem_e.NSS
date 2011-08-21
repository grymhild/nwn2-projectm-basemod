#include "_CSLEvent_Mod_i"
#include "hcr2_core_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onequipitem");

	CSLEvent_Mod_OnEquipItem();

	object oItem = GetPCItemLastEquipped();
	h2_AddOnHitProperty(oItem);
	ExecuteScript("x2_mod_def_equ", OBJECT_SELF);
}