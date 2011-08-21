//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY  ) )
	{
		return;
	}

	if ( GetStringLowerCase(sParameters) == "on" )
	{
		SendMessageToPC(oDM, "Set Area " + GetName(oDM) + " to Bash Mode") ;
		SetLocalInt( GetArea( oDM ), "SC_AREABASH", 1);
	}
	else
	{
		SetLocalInt( GetArea( oDM ), "SC_AREABASH", 0);
		SetLocalInt( GetArea( oTarget ), "SC_AREABASH", 0);
		SendMessageToPC(oDM, "Set Area " + GetName(oDM) + " to no longer be in Bash Mode") ;
	}

}