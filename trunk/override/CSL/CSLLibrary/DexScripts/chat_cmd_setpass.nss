//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "seed_db_inc"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	SDB_UpdateAccountPwd(oPC, sParameters);
}