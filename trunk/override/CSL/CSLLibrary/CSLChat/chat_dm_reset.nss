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
	
	if ( GetIsSinglePlayer()  )
	{
		SendMessageToPC(oDM,"Reloading Module, please stay logged in while it reloads");
		DelayCommand(6.0f, StartNewModule( GetName(GetModule()) ));
		return;
	}
	int nRemain = ( GetLocalInt(GetModule(), "CSL_CURRENT_ROUND")/10 )+2;
	SetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME", nRemain);
}