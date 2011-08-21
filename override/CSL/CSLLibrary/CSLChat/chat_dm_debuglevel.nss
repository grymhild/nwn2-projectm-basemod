//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_CSLCore_Messages"

void main()
{
	object oDM = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	
	sParameters = GetStringUpperCase( CSLNth_Shift(sParameters, " ") );
	string sValue = CSLTrim(CSLNth_GetLast());
	
	if ( sValue == "HELP" || sValue == "" )
	{
		string sMessage = "DM_DebugLevel 0-10 ( What shows up depends on scripts )"+"\n";
		sMessage += "  0 Turned Off"+"\n";
		sMessage += "  5 Heartbeats"+"\n";
		sMessage += "  8 Spell Debugging"+"\n";
		sMessage += "  10 AI Debugging"+"\n";
		sMessage += "<b>Methods</b> (optional):\n";
		sMessage += "  FirstPC - Sends all messages to FirstPC\n";
		sMessage += "  Memory - Sends all messages to a variable\n";
		sMessage += "  Log - Sends messages to Log Text File\n";
		sMessage += "  Shouter - Messages are sent as shouts by designated shouter\n";
		sMessage += "  Broadcast - sends test messages to everyone on server\n";
		sMessage += "  Area - sends test messages to all in same area\n";
		sMessage += "  Source - sends test messages to source of message ( default )\n";
		sMessage += "  MainTester - Sets all test messages to only go to target/self \n";
		
		sMessage += "  TestersOnly - Sets it so only those set as tester see messages \n";
		sMessage += "  -TestersOnly - Sets it so only those everyone sees messages \n";
		
		sMessage += "  Tester - Sets target/self as tester \n";
		sMessage += "  -Tester - UnSets target/self as tester \n";
		sMessage += "\n  Off - turns off debugging completely \n";
		//SendMessageToPC(oDM, sMessage );
		CSLInfoBox( oDM, "Dm DebugLevel Commands", "DebugLevel Commands for DMs", sMessage );
		return;
	}
	
	
	while( sValue != "" )
	{
		
		if ( sValue == "OFF" )
		{
			CSLSetDebuggingLevel( 0 );
		}
		else if ( sValue == "MAINTESTER" )
		{
			CSLSetDebugMethod( "MainTester" );
			CSLAssignMainTester( oTarget );
		}
		else if ( sValue == "TESTER"  )
		{
			CSLSetAsTester( oTarget, TRUE );
		}
		else if ( sValue == "-TESTER" )
		{
			CSLSetAsTester( oTarget, FALSE );
		}
		else if ( sValue == "TESTERSONLY"  )
		{
			CSLSetDebugToTestersOnly( TRUE );
		}
		else if ( sValue == "-TESTERSONLY" )
		{
			CSLSetDebugToTestersOnly( FALSE );
		}
		else if ( CSLGetIsNumber(sValue) )
		{
			CSLSetDebuggingLevel( StringToInt( sValue ) );
		}
		else
		{
			CSLSetDebugMethod( sValue );
		}
	
		// get the next parameter
		sParameters = CSLNth_Shift(sParameters, " ");
		sValue = CSLTrim(CSLNth_GetLast());
	}
	
	if ( CSLGetDebugToTestersOnly( ) )
	{
		SendMessageToPC(oDM, "Message Level for only Testers is "+IntToString( CSLGetDebuggingLevel() )+" "+CSLGetDebugMethod() );
	}
	else
	{
		SendMessageToPC(oDM, "Message Level for everyone is "+IntToString( CSLGetDebuggingLevel() )+" "+CSLGetDebugMethod() );	
	}
		
	
	

}