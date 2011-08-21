//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	int nRemain;
	int iCurrentMinute = ( GetLocalInt(GetModule(), "CSL_CURRENT_ROUND")/10 )+1;
	int iMaxUptime = GetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME");
	
	nRemain = CSLGetMax( iCurrentMinute, iMaxUptime+60 );
	SetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME", nRemain);
}