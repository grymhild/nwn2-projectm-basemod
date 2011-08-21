//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	string sMessage = SCCacheStatsToString( oPC );
	
	//SendMessageToPC(oPC, sMessage );
	
	CSLInfoBox( oPC, "Casting Stats", GetName(oPC)+ " Casting Stats", sMessage );
}