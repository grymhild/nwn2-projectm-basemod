/*
This is a SP Official campaign script for features in the single player game
*/
// ga_add_companion(string sTarget)
/* This script adds the specified roster character as a companion to the party.
   
   Parameters:
     string sTarget  = Roster Name of the companion to add. (this is usually the same as the tag)

*/
// ChazM 4/14
// BMA 4/28/05 - added GetTarget()
// ChazM 12/1 - changed to work w/ companions, not henchmen.
// ChazM 12/1 - will attempt to add sTarget creature to the roster (as a tag or else template)
// DBR   12/2 - Changed params to AddCompanionToRoster (ResRef was not passed)

#include "_SCInclude_Group"
#include "_CSLCore_Messages"



void main(string sTarget)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	string sResRef = sTarget;
	// add companion to roster if necessary
	// standard companions will already be in roster (add in module load)
	// so we could ignore the problem of their resref being different from the tag for now.
	// but this will handle that case if the module event isn't adding them to roster
	if (GetCompanionNumberByTag(sTarget) != 0)
		sResRef = "co_"	+ sResRef;

	AddCompanionToRoster(sTarget, sTarget, sResRef);
	AddRosterMemberToParty(sTarget, oPC);
}