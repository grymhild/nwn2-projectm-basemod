/*
This is a SP Official campaign script for features in the single player game
*/
// ga_store_comp()
/* 
   Stores the names of the current companions in the party so that they can be restored later with ga_restore_comp.
*/
// TDE 7/13/06 - Created script
		
#include "_SCInclude_Group"

void CheckInParty(string sRosterName)
{
	string sGlobal = "00_" + sRosterName + "IsInParty";
	if ( IsInParty(sRosterName) ) 
		SetGlobalInt(sGlobal, 1);
	else SetGlobalInt(sGlobal, 0);
}

void main()
{
	CheckInParty("ammon_jerro");
	CheckInParty("bishop");
	CheckInParty("casavir");
	CheckInParty("construct");
	CheckInParty("elanee");
	CheckInParty("grobnar");
	CheckInParty("khelgar");
	CheckInParty("neeshka");
	CheckInParty("qara");
	CheckInParty("sand");
	CheckInParty("shandra");
	CheckInParty("zhjaeve");
}