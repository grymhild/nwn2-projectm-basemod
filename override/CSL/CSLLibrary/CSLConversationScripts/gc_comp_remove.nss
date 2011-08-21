// gc_comp_remove
// 
// returns TRUE if the companion with tag sCompanion is both in the party and can be removed at this point.
//
// EPF 6/15/05	
// EPF 11/30/05	 -- fixing to work with companions
	
#include "_SCInclude_Group"
	
int StartingConditional(string sCompanion)
{
	object oPC = GetPCSpeaker();
	object oComp = CSLGetTarget(sCompanion);

	string sRoster = GetRosterNameFromObject(oComp);
	if(!GetIsRosterMemberAvailable(sRoster) && GetIsRosterMemberSelectable(sRoster))
	{
		return TRUE;
	}

	return FALSE;
}