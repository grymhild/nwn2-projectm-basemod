//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_DMFI"

void main()
{
	object oDM = CSLGetChatSender();
	//object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	string sParameters = CSLGetChatParameters();
	
	if ( GetStringLowerCase(sParameters) == "off" )
	{
		//SetLocalInt(oDM, "CHAT_THROWINGVOICE", FALSE);
		SetLocalInt(oDM, DMFI_PC_UI_STATE, FALSE);
		CloseGUIScreen( oDM, SCREEN_DMFI_TRGTOOL );
		CloseGUIScreen( oDM, SCREEN_DMFI_DM );
		SendMessageToPC( oDM, "DM tools disabled");
	}
	else
	{
		DisplayGuiScreen(oDM,SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
		DisplayGuiScreen(oDM, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
		SetLocalInt(oDM, DMFI_PC_UI_STATE, TRUE);
		SendMessageToPC( oDM, "DM tools enabled");
	}
	// CSLSetAsTester(  oTarget, FALSE );

}