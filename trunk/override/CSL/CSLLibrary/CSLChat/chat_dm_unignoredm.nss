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
		DeleteLocalInt(oDM, "FKY_CHT_IGNOREDM");
		SendMessageToPC(oDM, "<color=indianred>"+"You are no longer ignoring dm channel."+"</color>");
	}

}