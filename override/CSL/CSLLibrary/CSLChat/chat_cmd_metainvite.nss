//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	int nChannel = CSLGetChatChannel();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	if ((nChannel==4) || (nChannel==20)) { // MUST INVITE IN TELL CHANNEL
                        string sKey = GetLocalString(oPC, "FKY_CHT_META_GRP");
                        if (sKey=="") sKey = CSLGetMyPlayerName(oPC); // THEY ARE NOT IN A METAGROUP AND ARE ATTEMPTING TO START ONE AS THE LEADER
                        if (GetLocalString(oTarget, "FKY_CHT_META_GRP")=="") { // THEY ARE NOT IN A METAGROUP
                           string sInvite = "<color=orange>"+"Metachannel invite received from "+ CSLGetMyPlayerName(oPC) + "!"+"</color>";
                           FloatingTextStringOnCreature(sInvite, oTarget, FALSE);
                           SetLocalString(oTarget, "FKY_CHT_META_INV", sKey); // WILL OVERWRITE LAST INVITE
                           sInvite = "<color=orange>"+"Metachannel invite sent!"+"</color>";
                           FloatingTextStringOnCreature(sInvite, oPC, FALSE);
                        } else { // THEY ARE ALREADY IN A METAGROUP
                           string sInvite = "<color=orange>" + GetName(oTarget) +" is already in a metachannel!"+"</color>";
                           FloatingTextStringOnCreature(sInvite, oPC, FALSE);
                        }
                     } else FloatingTextStringOnCreature("<color=indianred>"+"Invalid Command! You must invite with a tell."+"</color>", oPC, FALSE);

}