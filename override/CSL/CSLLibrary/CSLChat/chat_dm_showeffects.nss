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

	string sMessage  = CSLAllEffectsToString( oTarget );
	SendMessageToPC(oDM, sMessage );	
	
	CSLInfoBox( oDM, "Effects on ", GetName(oTarget)+" Item Properties", sMessage );

}