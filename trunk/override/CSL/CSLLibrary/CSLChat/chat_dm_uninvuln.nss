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

	if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)) || (oTarget==oDM))
	{
		SetPlotFlag(oTarget, FALSE);
		if (oTarget==oDM)
		{
			SendMessageToPC(oDM, "<color=indianred>"+"You are no longer invulnerable."+"</color>");
		}
		else
		{
			SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is no longer invulnerable."+"</color>");
			SendMessageToPC(oTarget, "<color=indianred>"+"You are no longer invulnerable."+"</color>");
		}
	}

}