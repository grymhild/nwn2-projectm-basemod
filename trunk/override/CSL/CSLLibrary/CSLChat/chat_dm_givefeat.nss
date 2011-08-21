//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

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

	FeatAdd( oTarget, StringToInt(sParameters), TRUE );   			  
	SendMessageToPC(oDM, "<color=indianred>"+"Added feat "+ IntToString(StringToInt(sParameters))+" to "+GetName(oTarget) + "!"+"</color>");

}