//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

#include "_SCInclude_Chat"
#include "_CSLCore_Environment"
void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	if ( !GetIsObjectValid(oTarget) )
	{
		oTarget = oDM;
	}
	
	if ( GetStringLowerCase(sParameters) == "help")
	{
		string sMessage = "DM_clientextender Commands"+"\n";
		sMessage += "  PerAreaMap NoEnviron NoDoors NoTraps NoCreatures NoPathing None help ( - removes)"+"\n";
		//SendMessageToPC(oDM, sMessage );
		CSLInfoBox( oDM, "Client Extender Commands", "Client Extender Commands for DMs", sMessage );
		return;
	}
	
	int iClientSettings = GetLocalInt( GetModule(), "SCLIENTEXTENDERPROPS");
	
	string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
	string sValue = CSLTrim(CSLNth_GetLast());

	while( sValue != "" )
	{
		//SendMessageToPC(oDM, "vars CLIENTEXT_PER_AREA_MAP_CONTROLS="+IntToString(CLIENTEXT_PER_AREA_MAP_CONTROLS)+" CLIENTEXT_NO_MAP_ENVIRON="+IntToString(CLIENTEXT_NO_MAP_ENVIRON)+" CLIENTEXT_NO_MAP_DOORS="+IntToString(CLIENTEXT_NO_MAP_DOORS)+" CLIENTEXT_NO_MAP_TRAPS="+IntToString(CLIENTEXT_NO_MAP_TRAPS)+" CLIENTEXT_NO_MAP_CREATURES="+IntToString(CLIENTEXT_NO_MAP_CREATURES)+" CLIENTEXT_NO_MAP_PATHING="+IntToString(CLIENTEXT_NO_MAP_PATHING)		  );
		
		if ( sValue == "none" ) { iClientSettings = CLIENTEXT_NONE; } 
		
		else if ( sValue == "perareamap" ) { iClientSettings |= CLIENTEXT_PER_AREA_MAP_CONTROLS; }
		else if ( sValue == "-perareamap" ) { iClientSettings &= ~CLIENTEXT_PER_AREA_MAP_CONTROLS; }
		
		else if ( sValue == "noenviron" ) { iClientSettings |= CLIENTEXT_NO_MAP_ENVIRON; }
		else if ( sValue == "-noenviron" ) { iClientSettings &= ~CLIENTEXT_NO_MAP_ENVIRON; }
		
		else if ( sValue == "nodoors" ) { iClientSettings |= CLIENTEXT_NO_MAP_DOORS; }
		else if ( sValue == "-nodoors" ) { iClientSettings &= ~CLIENTEXT_NO_MAP_DOORS; }
		
		else if ( sValue == "notraps" ) { iClientSettings |= CLIENTEXT_NO_MAP_TRAPS; }
		else if ( sValue == "-notraps" ) { iClientSettings &= ~CLIENTEXT_NO_MAP_TRAPS; }
		
		else if ( sValue == "nocreatures" ) { iClientSettings |= CLIENTEXT_NO_MAP_CREATURES; }
		else if ( sValue == "-nocreatures" ) { iClientSettings &= ~CLIENTEXT_NO_MAP_CREATURES; }
		
		else if ( sValue == "nopathing" ) { iClientSettings |= CLIENTEXT_NO_MAP_PATHING; }
		else if ( sValue == "-nopathing" ) { iClientSettings &= ~CLIENTEXT_NO_MAP_PATHING; }
				
		//SendMessageToPC(oDM, "Working on ["+ sValue+"] resulting in "+IntToString(iClientSettings)  );
		
		// get the next parameter
		sNewParameters = CSLNth_Shift(sNewParameters, " ");
		sValue = CSLTrim(CSLNth_GetLast());
	}
	
	string sQuote = CSLGetQuote();
	CSLFillInChatBox( "/t "+sQuote+"Pain"+sQuote, oDM );

	
	SendMessageToPC(oDM, "Setting client extender properties using " + sParameters +  " to the state "+CSLClientExtStateToString( iClientSettings ) );

	CSLClientExtSetModulePlayerProperties( iClientSettings );
}