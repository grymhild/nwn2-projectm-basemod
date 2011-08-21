//#include "_CSLEvent_Mod_i"
#include "hcr2_core_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onplayerdying");

	object oPC = GetLastPlayerDying();
	int nPlayerState = h2_GetPlayerState(oPC);
	h2_LogPlayerState(oPC, nPlayerState);
    if (nPlayerState != H2_PLAYER_STATE_DEAD)
        h2_SetPlayerState(oPC, H2_PLAYER_STATE_DYING);

    ExecuteScript("hcr2_bleedsystemopy",OBJECT_SELF);
}