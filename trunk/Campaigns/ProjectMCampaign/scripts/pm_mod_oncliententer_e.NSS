#include "_CSLEvent_Mod_i"
#include "hcr2_debug_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_oncliententer");
	CSLEvent_Mod_OnClientEnter();
}