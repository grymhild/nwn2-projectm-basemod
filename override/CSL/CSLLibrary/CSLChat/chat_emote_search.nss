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


	CSLNWN2EmoteWithSound(oPC, "search", VOICE_CHAT_SEARCH);
}