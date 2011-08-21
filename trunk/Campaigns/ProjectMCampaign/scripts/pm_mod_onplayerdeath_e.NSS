//#include "_CSLEvent_Mod_i"

#include "hcr2_core_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onplayerdeath");

	object oPC = GetLastPlayerDied();
	SetLocalLocation(oPC, H2_LOCATION_LAST_DIED, GetLocation(oPC));
    h2_SetPlayerState(oPC, H2_PLAYER_STATE_DEAD);
    h2_RemoveEffects(oPC);

	ExecuteScript("hcr2_bleedsystemopd", OBJECT_SELF);

	if (h2_GetPlayerState(oPC) == H2_PLAYER_STATE_DEAD)
		DelayCommand(2.5f, DisplayGuiScreen( oPC, "SCREEN_DEATH_DEFAULT", FALSE ));
}