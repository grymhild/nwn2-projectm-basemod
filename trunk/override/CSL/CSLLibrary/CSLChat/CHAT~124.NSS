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

	if ((DMS_HEAR_META && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_META && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_META && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_META && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM))))
	{
		DeleteLocalInt(oDM, "FKY_CHT_IGNOREMETA");
		SendMessageToPC(oDM, "<color=indianred>"+"You are no longer ignoring meta channels."+"</color>");
	}

}