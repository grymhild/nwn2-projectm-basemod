//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "seed_db_inc"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	string sKey = CSLGetMyPublicCDKey(oTarget);
	SDB_SetIsShoutBanned(oTarget, FALSE);
	DeleteLocalString(oTarget, "FKY_CHT_BANREASON");//delete the reason they were banned and by whom
	SendMessageToPC(oTarget, "<color=indianred>"+"Your ban from using the shout channel has been lifted."+"</color>");
	SendMessageToPC(oDM, "<color=indianred>"+"You have unbanned "+ GetName(oTarget) +" from the shout channel."+"</color>");
}