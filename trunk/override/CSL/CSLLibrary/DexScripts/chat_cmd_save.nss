//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "seed_db_inc"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		SendMessageToPC(oPC, "Not Alive...");
		return;
	}
	//SendMessageToPC(oPC, "Saving...");
	SDB_UpdatePlayerStatus(oPC);

}