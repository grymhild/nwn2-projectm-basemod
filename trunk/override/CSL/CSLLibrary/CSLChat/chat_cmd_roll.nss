//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_CSLCore_Visuals"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	int iResult = CSLRollStringtoInt( sParameters );
	
	
	if ( CSLGetIsDM( oPC ) )
	{
		object oTarget = CSLGetChatTarget();
		if ( GetIsObjectValid( oTarget ) )
		{
			oPC = oTarget;
		}
	}
	
	DelayCommand(2.0, AssignCommand(oPC, SpeakString(ESCAPE_STRING+"<color=white>"+GetName(oPC)+" rolled ["+"</color>"+"<color=palegreen>"+sParameters+"</color>"+"<color=white>"+"] and got ["+"</color>"+"<color=cornflowerblue>"+IntToString(iResult)+"</color>"+"]")));

}