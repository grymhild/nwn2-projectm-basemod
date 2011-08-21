//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_Macro"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oDM, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	CSLMacro_Display( oTarget, oDM );
	
	return;	
}