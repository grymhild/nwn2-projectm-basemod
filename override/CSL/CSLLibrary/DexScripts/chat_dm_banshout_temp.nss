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

	SDB_SetIsShoutBanned(oTarget, TRUE);//temp ban em
	SendMessageToPC(oTarget, "<color=indianred>"+"You have been temporarily banned from using the shout channel. If you feel this was a mistake, please contact a DM. You can still use the !lfg command up to 3 times. The ban will be lifted after the server resets."+"</color>");//tell em
	SendMessageToPC(oDM, "<color=indianred>"+"You have temp banned "+GetName(oTarget) +" from the shout channel."+"</color>");
	if (GetLocalString(oTarget, "FKY_CHT_BANREASON")=="") 
	{
		SetLocalString(oTarget, "FKY_CHT_BANREASON", "DMBanned by " + GetName(oDM));
	}
}