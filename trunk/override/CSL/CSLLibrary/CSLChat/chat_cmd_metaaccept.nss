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

	if (GetLocalString(oPC, "FKY_CHT_META_GRP")=="") { //THEY ARE NOT IN A METAGROUP
                       string sInvite = GetLocalString(oPC, "FKY_CHT_META_INV");
                        if (sInvite != "") {
                           CSLCheckIfNewChannel(sInvite);//if it's a new channel this adds the inviter
                           SetLocalString(oPC, "FKY_CHT_META_GRP", sInvite);//add them to the channel
                           string sKey = "<color=orange>"+"Metachannel invite accepted!"+"</color>";
                           FloatingTextStringOnCreature(sInvite, oPC, FALSE);
                           CSLSendMetaNotice(sInvite, GetName(oPC)+" has joined the metachannel.");
                        } else SendMessageToPC(oPC, "<color=indianred>"+"You have not receieved an invitation to a metachannel."+"</color>");
                     } else SendMessageToPC(oPC, "<color=indianred>"+"You are already in a metachannel! You must leave it before you can accept an invitation to another."+"</color>");

}