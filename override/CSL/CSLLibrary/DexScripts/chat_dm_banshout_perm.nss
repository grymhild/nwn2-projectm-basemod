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
	SDB_SetIsShoutBanned(oTarget, TRUE, TRUE);//perma shout ban em
	if (GetLocalString(oTarget, "FKY_CHT_BANREASON")=="") SetLocalString(oTarget, "FKY_CHT_BANREASON", "DMBanned by " + GetName(oDM));   //capture the reason they were banned and by whom
	SendMessageToPC(oTarget, "<color=indianred>"+"You have been permanently banned from using the shout channel. If you feel this was a mistake, please contact a DM. You can still use the !lfg command up to 3 times per reset."+"</color>");//tell em
	SendMessageToPC(oDM, "<color=indianred>"+"You have permanently banned "+ GetName(oTarget) +" from the shout channel."+"</color>");
}