//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	if ( GetStringLowerCase(sParameters) == "off" )
	{
		SCVoiceThrowing( oPC, FALSE );
		SendMessageToPC( oPC, "Voice throwing disabled");
	}
	else
	{
		SCVoiceThrowing( oPC, TRUE );
		SendMessageToPC( oPC, "Voice throwing enabled");
	}
}