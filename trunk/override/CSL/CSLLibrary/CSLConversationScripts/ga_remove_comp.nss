// ga_remove_comp(string sHenchmanTag)
/* This script removes a henchman from the party.

   Parameters:
     string sTarget = Tag of the henchman to remove. If blank, remove dialog OWNER.
                      If NPC is not a henchman of the PC, do nothing.
*/
// ChazM 4/14/05
// BMA 4/28/05
// ChazM 8/3/05	- use SCRemoveHenchmanByTag()
// EPF 11/30/05	- making compatible with companions.

#include "_SCInclude_AI"
#include "_CSLCore_Messages"

void main(string sCompanionTag)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oCompanion = CSLGetTarget(sCompanionTag);
	string sRosterTag = GetRosterNameFromObject(oCompanion);
	if(SCIsHenchman(oCompanion, oPC))
	{
		SCRemoveHenchmanByTag(oPC, sCompanionTag);	
	}
	else
	{

		RemoveRosterMemberFromParty(sRosterTag, oPC);
	}	
}		