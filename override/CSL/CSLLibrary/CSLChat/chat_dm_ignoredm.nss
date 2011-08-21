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
	
	if ((DM_PLAYERS_HEAR_DM && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_PLAYERS_HEAR_DM && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM))))
	{
		SetLocalInt(oDM, "FKY_CHT_IGNOREDM", TRUE);//they will not receive dm messages
		SendMessageToPC(oDM, "<color=indianred>"+"You are now ignoring dm channel."+"</color>");
	}

}