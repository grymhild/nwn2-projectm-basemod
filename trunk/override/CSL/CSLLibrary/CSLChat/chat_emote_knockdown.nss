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

	CSLPlayCustomAnimations( oPC, "knockdownB,proneB", TRUE );

	// CSLNWN2Emote(oPC, "knockdownB", "proneB", 1.0);
}