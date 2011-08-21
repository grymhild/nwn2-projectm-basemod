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

	DeleteLocalInt(oTarget, "FKY_CHT_BANDM");
	SendMessageToPC(oTarget, "<color=indianred>"+"Your ban from use of the DM channel has been lifted."+"</color>");
	SendMessageToPC(oDM, "<color=indianred>"+"You have unbanned "+ GetName(oTarget) +" from the DM channel."+"</color>");
}