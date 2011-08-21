/*
This is a SP Official campaign script for features in the single player game
*/
// ga_fade_duration
// 
// wrapper function for FadeToBlackParty(), which fades out for all PCs in the current party
// if bFadeOut is TRUE, we fade out to black.  If not, we fade back in from black.
// Fade lasts for fDuration. If fDuration is 0.0, the fade is a default 1 second.
// DBR 1/17/06 (stolen from ga_fade)
	
#include "_SCInclude_Overland"
	
void main(int bFadeOut, float fDuration)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	if (fDuration==0.0f)  //handle defaults
	{
		fDuration=1.0f;
	}
	FadeToBlackParty(oPC, bFadeOut, fDuration);	
}