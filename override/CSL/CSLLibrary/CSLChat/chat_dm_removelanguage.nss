//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
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
	
	if ( CSLLanguageLearned( oTarget, sParameters ) )
	{
		CSLLanguageRemove( oTarget, sParameters, TRUE );   			  
		SendMessageToPC(oDM, "<color=indianred>"+"Removed Language "+ sParameters+" from "+GetName(oTarget) + "!"+"</color>");
	}
}