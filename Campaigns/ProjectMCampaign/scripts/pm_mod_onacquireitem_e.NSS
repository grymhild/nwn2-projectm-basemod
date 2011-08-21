#include "_CSLEvent_Mod_i"
#include "hcr2_debug_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onacquireitem");

    CSLEvent_Mod_OnAcquireItem();

    ExecuteScript("x2_mod_def_aqu", OBJECT_SELF);

}