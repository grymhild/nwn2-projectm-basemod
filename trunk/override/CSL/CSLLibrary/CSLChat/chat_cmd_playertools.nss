//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_DMFI"

void main()
{
	object oPC = CSLGetChatSender();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	string sParameters = CSLGetChatParameters();
	
	if ( GetStringLowerCase(sParameters) == "off" )
	{
		//SetLocalInt(oPC, "CHAT_THROWINGVOICE", FALSE);
		SetLocalInt(oPC, DMFI_PC_UI_STATE, FALSE);
		CloseGUIScreen( oPC, SCREEN_DMFI_PLAYER );
		SendMessageToPC( oPC, "Player tools disabled");
	}
	else
	{
		DisplayGuiScreen(oPC, SCREEN_DMFI_PLAYER, FALSE, "dmfiplayerui.xml");
		SetLocalInt(oPC, DMFI_PC_UI_STATE, TRUE);
		SendMessageToPC( oPC, "Player tools enabled");
	}
}