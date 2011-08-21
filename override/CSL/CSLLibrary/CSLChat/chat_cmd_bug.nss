//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"


void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	if (GetLocalInt(oPC, "BUGREPORT")) // ONLY ONCE PER 3 MINUTES
	{
		SendMessageToPC(oPC, "You can only enter a bug report once every 3 minutes.");
		SetLocalInt(oPC, "BUGREPORT", 1);
		DelayCommand(180.0, DeleteLocalInt(oPC, "BUGREPORT"));
	}
	else 
	{
		DisplayInputBox(oPC, 0, "Your location is saved when reporting bugs. Stand as close as possible and face the issue being reported so a DM can port there later.", "gui_bugreport_ok", "gui_bugreport_cancel");
	}
}