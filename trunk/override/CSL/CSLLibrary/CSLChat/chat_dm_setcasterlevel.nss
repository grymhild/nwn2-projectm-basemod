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
	
	if ( GetStringLowerCase(sParameters) == "real" )
	{
		SetLocalInt(oTarget, "CSL_UseTrueDMCasterLevel", TRUE );
	}
	
	if ( GetStringLowerCase(sParameters) == "boosted" )
	{
		SetLocalInt(oTarget, "CSL_UseTrueDMCasterLevel", FALSE );
	}
	
	int iParameters = StringToInt( sParameters );
	if ( sParameters == "" || sParameters != IntToString(iParameters) )
	{
		SendMessageToPC(oDM, "Proper usage is 'dm_setcasterlevel 0-60', please enter in a level to set after the command");	
		SendMessageToPC(oDM, "Setting to '0' unsets the override");
		SendMessageToPC(oDM, "Setting to 'Real' makes dm's ignore their boosted caster level");
		SendMessageToPC(oDM, "Setting to 'Boosted' makes dm's cast at level 60");
		return;
	}
	
	if ( iParameters == 0 )
	{
		DeleteLocalInt(oTarget, "HKPERM_CasterLevel");
		SendMessageToPC(oDM, "Casting Level set to defaults on " + GetName(oTarget));
	}
	else if ( iParameters > 60 )
	{
		SetLocalInt(oTarget, "HKPERM_CasterLevel", 60 );
		SendMessageToPC(oDM, "Casting Level set to " + IntToString( 60 ) + " on " + GetName(oTarget));
	
	}
	else if ( iParameters > 0 )
	{
		SetLocalInt(oTarget, "HKPERM_CasterLevel", iParameters );
		//SendMessageToPC(oDM, "SetLocalInt " + sVar +  " to " + sValue + " on " + GetName(oTarget));
		SendMessageToPC(oDM, "Casting Level set to " + IntToString( iParameters ) + " on " + GetName(oTarget));
	
	}
	
	
	
}