//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	int nChannel = CSLGetChatChannel();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}


	if (((nChannel==4) ||(nChannel==20)) && GetIsObjectValid(oTarget))
	{
		string sTarget = CSLGetMyPlayerName(oTarget);
		if (GetLocalInt(oPC, "FKY_CHT_IGNORE" + sTarget)==TRUE)
		{
			string sPlayer = CSLGetMyPlayerName(oPC);
			DeleteLocalInt(oPC, "FKY_CHT_IGNORE" + sTarget);// IGNORE LIST STORED ON PC IGNORING
			SendMessageToPC(oPC, "<color=indianred>"+"You are no longer ignoring tells from "+ sTarget + "."+"</color>");
			SendMessageToPC(oTarget, "<color=indianred>" + sPlayer+" is no longer ignoring tells from you."+"</color>");
		}
		else 
		{
			FloatingTextStringOnCreature("<color=indianred>"+"You weren't ignoring "+ sTarget + "!"+"</color>", oPC, FALSE);
		}
	} 
	else 
	{
		FloatingTextStringOnCreature("<color=indianred>"+"Unignore commands must be sent as tells!"+"</color>", oPC, FALSE);
	}
}