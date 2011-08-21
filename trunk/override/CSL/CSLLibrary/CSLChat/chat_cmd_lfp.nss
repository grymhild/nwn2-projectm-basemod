//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script           chat_cmd_lfp                                         :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_Playerlist"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	CSLPlayerList_SetLookingForParty( oPC );
	
	
}