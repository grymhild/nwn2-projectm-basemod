/*
This is a SP Official campaign script for features in the single player game
*/
// ga_talk_object.nss
/*
	This script allows you to speak to an object.
	Set a conversation, set Usable to True, and attach this script to the OnUsed event.
*/
// FAB 2/7
// ChazM 2/17/05
// BMA-OEI 9/17/05 added debug
// ChazM 6/19/05 - removed debug.  This script moved to the campaign.

void main()
{
	// DEBUG - superceded by gp_talk_object
	object oPC = GetFirstPC();
	//DebugPostString(oPC, "ga_talk_object: SCRIPT OUTDATED, QA PLEASE BUG THIS", 50, 50, 5.0f);
	//DebugPostString(oPC, "name: " + GetName(OBJECT_SELF), 55, 60, 5.0f);
	//DebugPostString(oPC, "tag: " + GetTag(OBJECT_SELF), 55, 70, 5.0f);
	//DebugPostString(oPC, "resref: " + GetResRef(OBJECT_SELF), 55, 80, 5.0f);

	object oUser = GetLastUsedBy();
	ActionStartConversation(oUser);
}