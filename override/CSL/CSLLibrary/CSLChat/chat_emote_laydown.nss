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

	CSLPlayCustomAnimations( oPC, "laydownB,proneB", TRUE );
	//CSLNWN2Emote(oPC, "laydownB", "proneB", 2.3);
}