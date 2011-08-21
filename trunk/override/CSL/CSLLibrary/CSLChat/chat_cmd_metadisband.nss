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

	 if (GetLocalString(oPC, "FKY_CHT_META_GRP")==CSLGetMyPlayerName(oPC)) CSLDisbandMetaChannel(oPC);

}