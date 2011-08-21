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
	
	int iOldXPScale = GetModuleXPScale();
	SetModuleXPScale( StringToInt(sParameters) );
	int iNewXPScale = GetModuleXPScale();
	
	if ( iOldXPScale != iNewXPScale )
	{
		SendMessageToPC(oDM, "XP for module changed from "+IntToString(iOldXPScale)+" to "+IntToString(iNewXPScale) );
	}
	else
	{
		SendMessageToPC(oDM, "XP for module is still "+IntToString(iOldXPScale)+" and was not changed" );
	}
	//CSLGiveLevel(oTarget, oDM, );

}