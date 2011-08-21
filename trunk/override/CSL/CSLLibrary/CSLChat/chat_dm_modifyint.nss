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
	int iReturnVal = CSLModifyLocalIntWithRollString(oTarget, sVar, sValue);
	SendMessageToPC(oDM, "Modified variable " + sVar +  " to " + IntToString(iReturnVal) + " on " + GetName(oTarget));
}