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


	CSLNWN2EmoteWithSound(oPC, "victory", CSLPickOneInt(VOICE_CHAT_BATTLECRY1, VOICE_CHAT_BATTLECRY2, VOICE_CHAT_BATTLECRY3));
}