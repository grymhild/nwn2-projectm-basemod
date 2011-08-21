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


	CSLNWN2EmoteWithSound(oPC, "clapping", 0, CSLSexString(oPC, "as_pl_tavclap1", "as_pl_tavclap2"));
}