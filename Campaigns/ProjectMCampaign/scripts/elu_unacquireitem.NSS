#include "elu_hotbar_i"

void main()
{
	object oPC = GetModuleItemLostBy();
	object oItem = GetModuleItemLost();
	ClearHotbarButtonItemData(oPC, oItem);
	ExecuteScript("x2_mod_def_unaqu", OBJECT_SELF);
}