//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	string sMessage = SCCacheStatsToString( oTarget );
	
	SendMessageToPC(oDM, sMessage );
	
	CSLInfoBox( oDM, "Casting Stats", GetName(oTarget)+ " Casting Stats", sMessage );

}