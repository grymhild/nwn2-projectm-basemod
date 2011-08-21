//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	string sMessage  = CSLListItemProperties( oTarget );
	SendMessageToPC(oDM, sMessage );
	
	
	CSLInfoBox( oDM, "Item Properties", GetName(oTarget)+" Item Properties", sMessage );
}