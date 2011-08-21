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

	SetPlotFlag(oTarget, TRUE);
	if (oTarget==oDM)
	{
		SendMessageToPC(oDM, "<color=indianred>"+"You are now invulnerable."+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is now invulnerable."+"</color>");
		SendMessageToPC(oTarget, "<color=indianred>"+"You are now invulnerable."+"</color>");
	}

}