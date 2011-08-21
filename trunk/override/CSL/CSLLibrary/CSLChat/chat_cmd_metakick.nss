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

	if ((nChannel==4) || (nChannel==20)) // MUST KICK IN TELL CHANNEL
	{
		string sKey = CSLGetMyPlayerName(oPC);
		if (GetLocalString(oPC, "FKY_CHT_META_GRP")==sKey) // ONLY LEADER CAN KICK
		{
			if (GetLocalString(oTarget, "FKY_CHT_META_GRP")==sKey)
			{
				DeleteLocalString(oTarget, "FKY_CHT_META_GRP"); // KICK THEM
				string sInvite = "<color=orange>"+"You have been kicked from the metachannel!"+"</color>";
				FloatingTextStringOnCreature(sInvite, oTarget, FALSE);
				CSLSendMetaNotice(sKey, GetName(oTarget)+" has been kicked from the metachannel.");
			}
			else 
			{
				FloatingTextStringOnCreature("<color=indianred>"+"Invalid Command! "+ GetName(oTarget) +" is not a member of your metachannel!"+"</color>", oPC, FALSE);
			}
		}
		else
		{
			FloatingTextStringOnCreature("<color=indianred>"+"Invalid Command! Only the leader can kick."+"</color>", oPC, FALSE);
		}
	}
	else
	{
		FloatingTextStringOnCreature("<color=indianred>"+"Invalid Command! You must kick with a tell."+"</color>", oPC, FALSE);
	}

}