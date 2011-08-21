/*
Filename:           hcr2_bleedsystemopy
System:             bleed system (player dying event hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Dec. 10th, 2006
Summary:

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_PLAYER_DYING, oPC) function that is called from hcr2_playerdying_e.

To make this script execute, a string variable, named OnPlayerDyingX where X is a number that indicates
the order in which you want this player dying script to execute.
It should be assigned the value "hcr2_bleedsystemopy" under the variables section of Module properties.

-----------------
Revision: v1.01
Added support for ceasing hostile NPC actions when dying.

Revision: v1.03
Commented out call to h2_StayDownFool
(causes too much lag)

Revision: v1.04
Re-added call to h2_StayDownFool, if H2_STAY_DOWN_FIX is
set to TRUE (default value is off/FALSE)

Revision: v1.06
Added some logging.
*/

#include "hcr2_bleedsystem_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed hcr2_bleedsystemopy");
	object oPC = GetLastPlayerDying();
//	UnpossessFamiliar(oPC);

	int nPlayerState = h2_GetPlayerState(oPC);
	h2_LogPlayerState(oPC, nPlayerState);
    if (nPlayerState == H2_PLAYER_STATE_DYING)
	{
		h2_BeginPlayerBleeding(oPC);
		h2_SignalAttackerTargetIsDown(oPC);
		if (H2_STAY_DOWN_FIX)
			h2_StayDownFool(oPC);
	}
}