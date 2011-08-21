/*
This is a SP Official campaign script for features in the single player game
*/
// ga_influence( int nCompanion, int nChange )
/* This adjusts the influence rating of the companion to the PC (the players as a whole technically).
   The influence rating is based on a scale between -100(worst) and 100(best). (0 being neutral)

   Parameters:
     int nCompanion  = This is the integer value of the companion to adjust. (See ginc_companions)
     int nChange     = This is the amount to adjust influence by.

	1	Khelgar
	2	Neeshka
	3	Elanee
	4	Qara
	5	Sand
	6	Grobnar
	7	Casavir
	8	Bishop
	9	ShandraJerro
	10	Construct
	11	Zhjaeve
	12	AmmonJerro
	13  Bevil
*/
// FAB 10/4
// ChazM 5/4/05
// BMA 5/5/05 ginc_companions id look up
// BMA-OEI 8/22/05 added companion id table
// ChazM 12/16/05 added bevil
// ChazM 4/18/06 prepped for adding influence indicator
// ChazM 4/25/06 added string ref constants
// ChazM 5/1/06 fixed "temp text" bug.
// EPF 7/10/06 - added debug strings for balance testing
// BMA-OEI 7/10/06 -- Updated to use GetInfluenceByNumber()
		
#include "_SCInclude_Group"
#include "_CSLCore_Messages"

const int	STRING_REF_LOST_INFLUENCE 	= 178842;
const int	STRING_REF_GAINED_INFLUENCE = 178841;

int GetCompanionNameStringRef( int nCompanion )
{
	// companions str refs are 178843 - 178855
	return ( 178842 + nCompanion );
}

void main( int nCompanion, int nChange )
{
	if ( nChange == 0 )
	{
		//PrettyError( "ga_influence: companion " + IntToString(nCompanion) + " no influence change" );
		return;
	}
	
	int nOldInfluence = GetInfluenceByNumber( nCompanion );
	IncInfluenceByNumber( nCompanion, nChange );
	int nNewInfluence = GetInfluenceByNumber( nCompanion );
	
	string sOut;
	int nDelta = nNewInfluence - nOldInfluence; //nChange; // Actual nDelta may not == nChange
	if ( nDelta > 0 )
	{
		sOut = GetStringByStrRef( STRING_REF_GAINED_INFLUENCE );
	}
	else
	{
		sOut = GetStringByStrRef( STRING_REF_LOST_INFLUENCE );
	}
	sOut += " " + GetStringByStrRef(GetCompanionNameStringRef(nCompanion)) + ": " + IntToString(nDelta);
	
    object oPC = ( GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker() );
	SendMessageToPC( oPC, sOut );
	//PrettyDebug( sOut );
	//PrettyDebug("Total influence with " + GetStringByStrRef(GetCompanionNameStringRef(nCompanion)) + " = " + IntToString(nNewInfluence));
}