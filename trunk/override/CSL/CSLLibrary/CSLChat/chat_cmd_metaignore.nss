//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();

	 CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_LISTEN, VOICE_CHAT_YES);

}