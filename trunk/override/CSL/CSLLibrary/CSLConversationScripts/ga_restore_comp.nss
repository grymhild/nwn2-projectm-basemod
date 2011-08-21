/*
This is a SP Official campaign script for features in the single player game
*/
// ga_restore_comp()
/* 
   Restores companions to the party that were stored using ga_store_comp.
*/
// TDE 7/13/06 - Created script
		
#include "_SCInclude_Group"

object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

void CheckToAdd(string sRosterName)
{
	string sGlobal = "00_" + sRosterName + "IsInParty";
	
	if ( GetGlobalInt(sGlobal) == 1  ) 
		AddRosterMemberToParty(sRosterName, oPC);
}

void main()
{
	CheckToAdd("ammon_jerro");
	CheckToAdd("bishop");
	CheckToAdd("casavir");
	CheckToAdd("construct");
	CheckToAdd("elanee");
	CheckToAdd("grobnar");
	CheckToAdd("khelgar");
	CheckToAdd("neeshka");
	CheckToAdd("qara");
	CheckToAdd("sand");
	CheckToAdd("shandra");
	CheckToAdd("zhjaeve");
}