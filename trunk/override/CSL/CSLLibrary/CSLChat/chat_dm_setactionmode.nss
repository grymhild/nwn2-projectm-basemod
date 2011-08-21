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

	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 11 );
	SetActionMode( oTarget, StringToInt(sParameters), TRUE );   			  
	SendMessageToPC(oDM, "<color=indianred>"+"Action for "+GetName(oTarget) + " is "+ CSLTargetActionModeToString(oTarget)+""+"</color>");
}