/*
This is a SP Official campaign script for features in the single player game
*/
// ga_fade
// 
// wrapper function for FadeToBlackParty(), which fades out for all PCs in the current party
// if bFadeOut is TRUE, we fade out to black.  If not, we fade back in from black.

#include "_SCInclude_Overland"
	
void main(int bFadeOut)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	FadeToBlackParty(oPC, bFadeOut, 1.f);	
}