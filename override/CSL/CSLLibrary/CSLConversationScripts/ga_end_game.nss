/*
This is a SP Official campaign script for features in the single player game
*/
// ga_end_game( string sEndMovie )
//
// TDE 10/2/08 - Added an instant party fade.

#include "_SCInclude_Overland"

void main( string sEndMovie )
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	FadeToBlackParty(oPC, TRUE, 0.0, 5.0, 0);	
	
	EndGame( sEndMovie );
}