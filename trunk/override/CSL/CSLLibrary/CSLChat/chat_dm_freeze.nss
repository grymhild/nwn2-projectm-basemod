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

	if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)))//these commands may not be used on dms
	{
		SetCommandable(FALSE, oTarget);
		SendMessageToPC(oTarget, "<color=indianred>"+"You have been frozen by a DM!"+"</color>");
		SendMessageToPC(oDM, "<color=indianred>"+"You have frozen "+ GetName(oTarget) + "!"+"</color>");
	}
	else
	{
		FloatingTextStringOnCreature("<color=indianred>"+"You cannot freeze DMs!"+"</color>", oDM);
	}
}