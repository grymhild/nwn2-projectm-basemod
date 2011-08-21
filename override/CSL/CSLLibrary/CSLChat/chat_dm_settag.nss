//::////////////////////////////////////////////////////////////////////////:://
//:: chat_dm_settag.nss
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	if ( sParameters != "" && GetIsObjectValid( oTarget ) )
	{
		SetTag( oTarget, CSLNth_GetNthElement( sParameters, 1, " ") );
		SendMessageToPC( oDM, GetName(oTarget)+" had their tag set to "+GetTag(oTarget) );
	}

}