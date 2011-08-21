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

	if (!GetCommandable(oTarget)) SetCommandable(TRUE, oTarget);
	SendMessageToPC(oTarget, "<color=indianred>"+"You have been unfrozen!"+"</color>");
	SendMessageToPC(oDM, "<color=indianred>"+"You have unfrozen "+ GetName(oTarget) + "."+"</color>");
}