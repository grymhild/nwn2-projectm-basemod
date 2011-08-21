//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	string sKey = GetLocalString(oPC, "FKY_CHT_META_GRP");
                     if (sKey != "") {
                        DeleteLocalString(oPC, "FKY_CHT_META_GRP"); // LEAVE GROUP
                        string sInvite = "<color=orange>"+"You have exited the metachannel!"+"</color>";
                        FloatingTextStringOnCreature(sInvite, oPC, FALSE);
                        CSLSendMetaNotice(sKey, GetName(oPC)+" has exited the metachannel.");
                     } else SendMessageToPC(oPC, "<color=indianred>"+"Invalid Command! You are not currently in a metachannel."+"</color>");

}