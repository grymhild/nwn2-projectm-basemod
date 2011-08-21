//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	
	if ( sParameters == "here" )
	{
		CSLDMPortHere( oTarget, oDM );
	}
	else if  ( sParameters == "jail" )
	{
		if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget))) AssignCommand(oTarget, JumpToLocation(GetLocation(GetWaypointByTag(LOCATION_JAIL))));
	}
	else if  ( sParameters == "leader" )
	{
		if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget))) AssignCommand(oTarget, JumpToObject(GetFactionLeader(oTarget)));
	}
	else if  ( sParameters == "there" )
	{
		CSLDMPortThere( oTarget, oDM );
	}
	else if  ( sParameters == "town" )
	{
		if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)))
		{
			AssignCommand(oTarget, JumpToLocation(GetLocation(GetWaypointByTag(LOCATION_TOWN))));
		}
	}
	else
	{
		AssignCommand(oDM, JumpToLocation(GetLocation(GetObjectByTag(sParameters ))));
	}
}