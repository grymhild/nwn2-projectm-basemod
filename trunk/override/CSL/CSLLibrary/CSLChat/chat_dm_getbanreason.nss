//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	string sKey = GetLocalString(oTarget, "FKY_CHT_BANREASON");
	if (sKey=="")
	{
		SendMessageToPC(oDM, "<color=indianred>"+"There is no listed reason for the shout ban. This means that it was done at least one reset ago, and the player in question is permabanned. This was probably not done lightly, so proceed with caution."+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Reason for ban: "+ sKey + "</color>");
	}
}