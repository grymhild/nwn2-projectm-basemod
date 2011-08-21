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

	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 11 );
	FeatRemove( oTarget, StringToInt(sParameters) );   			  
	SendMessageToPC(oDM, "<color=indianred>"+"Removed feat "+ IntToString(StringToInt(sParameters))+" to "+GetName(oTarget) + "!"+"</color>");
}