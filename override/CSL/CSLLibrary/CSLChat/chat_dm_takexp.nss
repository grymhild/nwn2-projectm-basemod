//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	if ( !GetIsObjectValid( oTarget )  )
	{
		SendMessageToPC(oDM, "ERROR: Target was Invalid, please select a target or send via a tell");
		return;
	}
	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 7);
	int nAppear = GetXP(oTarget)-StringToInt(sParameters);
	if (nAppear < 0) nAppear = 0;
	SetXP(oTarget, nAppear);
	SendMessageToPC(oDM, "<color=indianred>"+"You have removed "+ IntToString(StringToInt(sParameters))+" XP from "+GetName(oTarget) + "!"+"</color>");
}