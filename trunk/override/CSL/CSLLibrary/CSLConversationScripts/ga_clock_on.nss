// ga_clock_on(int bAllPlayers)
/*
	Description: Turns clock on for speaker or for all players
	
*/
// ChazM 6/1/07

#include "_CSLCore_Time"

void main(int bAllPlayers)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	if (bAllPlayers)
	{
		CSLSetClockOnForAllPlayers(TRUE);
	}
	else
	{
		CSLSetClockOnForPlayer(oPC, TRUE);
	}
}