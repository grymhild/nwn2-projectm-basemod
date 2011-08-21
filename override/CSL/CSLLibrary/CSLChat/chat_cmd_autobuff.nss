//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	if ( CSLGetIsInTown(oPC) )
	{
		// fast buffing in town
		HkAutoBuff( oPC, oPC, TRUE, 10, FALSE, FALSE );
	}
	else
	{
		HkAutoBuff( oPC, oPC, FALSE, 10, FALSE, FALSE );
	}
	/*
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
	*/
}