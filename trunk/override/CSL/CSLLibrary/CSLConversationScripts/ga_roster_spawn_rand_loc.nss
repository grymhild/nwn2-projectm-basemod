//ga_roster_spawn_rand_loc
/*
	creates a list of roster names randomly disbursed in  a radius around a target
*/
// ChazM 12/5/05

#include "_CSLCore_Messages"
#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_Position"
	
	
void main(string sRosterNameList, string sTargetLocationTag, float fRadius)
{
	int nPos = 1;
	string sRosterName = CSLNth_GetNthElement(sRosterNameList, nPos);
	object oLocationObject = CSLGetTarget(sTargetLocationTag, CSLTARGET_OWNER);
	location lLocation = GetLocation(oLocationObject);
	object oSpawn;
 	location lRandLoc;

	while (sRosterName != "")
	{
		lRandLoc = CSLGetNearbyLocation(lLocation, fRadius, 0.0f);
		oSpawn = SpawnRosterMember(sRosterName, lRandLoc);	
		sRosterName = CSLNth_GetNthElement(sRosterNameList, ++nPos);
	}
}
	