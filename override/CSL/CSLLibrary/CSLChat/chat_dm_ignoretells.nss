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

	if ((DMS_HEAR_TELLS && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_TELLS && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM))))
	{
		SetLocalInt(oDM, "FKY_CHT_IGNORETELLS", TRUE);//they will not receive tells
		SendMessageToPC(oDM, "<color=indianred>"+"You are now ignoring tells."+"</color>");
	}

}