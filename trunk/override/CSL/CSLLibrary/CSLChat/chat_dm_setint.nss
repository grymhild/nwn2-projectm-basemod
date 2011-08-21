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
	sParameters = CSLNth_Shift(sParameters, " ");
	string sVar = CSLNth_GetLast();
	sParameters = CSLNth_Shift(sParameters, " ");
	string sValue = CSLNth_GetLast();
	SetLocalInt(oTarget, sVar, StringToInt(sValue));
	SendMessageToPC(oDM, "SetLocalInt " + sVar +  " to " + sValue + " on " + GetName(oTarget));
}