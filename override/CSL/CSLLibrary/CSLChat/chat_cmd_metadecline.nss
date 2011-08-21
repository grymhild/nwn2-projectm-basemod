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

	string sInvite = GetLocalString(oPC, "FKY_CHT_META_INV");
                     if (sInvite != "") {
                        DeleteLocalString(oPC, "FKY_CHT_META_INV");//clear the invite
                        string sKey = "<color=orange>"+"Metachannel invite declined!"+"</color>";
                        CSLSendMetaNotice(sInvite, GetName(oPC)+" has declined an invitation to join the channel.");
                        FloatingTextStringOnCreature(sInvite, oPC, FALSE);
                     } else SendMessageToPC(oPC, "<color=indianred>"+"You have not receieved an invitation to a metachannel."+"</color>");

}