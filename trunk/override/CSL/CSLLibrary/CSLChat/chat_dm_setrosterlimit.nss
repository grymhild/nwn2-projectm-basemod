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
	
	int iOldRosterLimit = GetRosterNPCPartyLimit();
	int iNewRosterLimit = iOldRosterLimit;
	
	if ( sParameters != "" && IntToString(StringToInt(sParameters)) == sParameters )
	{
		iNewRosterLimit = StringToInt(sParameters);
	}
	
	if ( iOldRosterLimit != iNewRosterLimit && iNewRosterLimit > 0 )
	{
		SetRosterNPCPartyLimit( iNewRosterLimit );
		SendMessageToPC(oDM, "<color=indianred>"+"Set Roster Limit of "+IntToString(iNewRosterLimit)+" from "+IntToString(iOldRosterLimit)+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Roster Limit is "+IntToString(iOldRosterLimit)+"</color>");
	}
}