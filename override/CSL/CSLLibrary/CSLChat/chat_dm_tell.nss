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

	CSLSetChatSuppress( TRUE );
	// sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 5);
	SendChatMessage(CSLGetChatMessenger(), oTarget, CHAT_MODE_TELL, "<color=YellowGreen>"+sParameters );
	SendChatMessage(CSLGetChatMessenger(), oDM, CHAT_MODE_TELL, " <color=pink>" + GetName(oTarget) + ":<color=YellowGreen> "+sParameters );
}