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
	
	if ( GetIsObjectValid(oTarget) )
	{
		string sLastName  = CSLNth_Shift(sParameters, " ");
		string sFirstName = CSLNth_GetLast();
		//sParameters = CSLNth_Shift(sParameters, " ");
		//string sValue = CSLNth_GetLast();
		
		SendMessageToPC(oDM, "DM_setname " + GetName(oTarget) +  " to " + sParameters + "!");
		SetFirstName(oTarget, sFirstName);
		SetLastName(oTarget, sLastName);
	}
}