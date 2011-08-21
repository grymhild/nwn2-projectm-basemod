//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sUrl = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	
	if ( !GetIsObjectValid( oTarget )  )
	{
		SendMessageToPC(oDM, "ERROR: No Url was sent, Target was Invalid");
	}
	else if ( sUrl == "" )
	{
		SendMessageToPC(oDM, "ERROR: No Url was sent, URL was empty");
	}
	else
	{
		CSLOpenUrl( sUrl, oTarget );
		SendMessageToPC(oDM, GetName(oTarget)+" Received the URL "+sUrl );
	}
}