//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
/*
	This code assumes a player does not have a really complicated builds, and will focus on the first class they took which can actually use the given spell which makes they syntax very easy.
*/
#include "_SCInclude_Chat"
#include "_SCInclude_Language"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	
	if ( !GetIsObjectValid( oTarget ) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE )
	{
		SendMessageToPC( oDM, "No Valid Target Selected" );
		return;
	}
	
	DelayCommand( 0.1f, CSLLanguagesListLearnedToMessage( oDM, oTarget ) );
}