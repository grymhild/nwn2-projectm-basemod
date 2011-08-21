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


	CSLNWN2EmoteWithSound(oPC, "sigh", 0, CSLSexString(oPC, " as_pl_hangoverm1", " as_pl_hangoverf1"));
}