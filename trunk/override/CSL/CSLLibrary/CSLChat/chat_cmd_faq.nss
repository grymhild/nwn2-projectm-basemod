//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script           chat_cmd_lfp                                         :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_DynamConvos"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	CSLOpenNextDlg(oPC, GetFirstItemInInventory(oPC), "seed_faq", TRUE, FALSE);
}