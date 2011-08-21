#include "_CSLCore_Messages"
#include "_CSLCore_Time"
#include "_SCInclude_Events"
#include "_CSLCore_Player"

void main()
{
  	object oModule = GetModule();
  	int iElapsedMinutes = GetLocalInt( oModule, "CSL_CURRENT_ROUND" )/10;
  	if (DEBUGGING >= 8) { CSLDebug( "Minute "+IntToString(iElapsedMinutes), GetFirstPC() ); }
  	if (CSLNWNX_Installed()) // restarting requires NWNx
	{
		int iMaxUptime = SCGetMaxUptime();
		if (DEBUGGING >= 8) { CSLDebug( "max maxuptime= "+IntToString(iMaxUptime), GetFirstPC() ); }
		
		//GetLocalInt(oModule, "SC_SERVER_MAX_UPTIME" );
		if ( iMaxUptime > 0 )
		{
			int iRemainingUptime = iMaxUptime - iElapsedMinutes;
			if (DEBUGGING >= 8) { CSLDebug( "max iRemainingUptime= "+IntToString(iRemainingUptime), GetFirstPC() ); }
			
			string sSessionName = GetLocalString(oModule, "SC_SESSIONNUMBER" );
			
			if ( iRemainingUptime <= 0 )
			{
				// reboot now
				DelayCommand(4.0, NWNXSetString("SYSTEM", "RESET", "", 0, ""));
				CSLShoutMsg("Server Session #" + sSessionName+" is over. Thank you! Come again.");
				return;
			}
			else if ( iRemainingUptime == 1 )
			{
				object oPC = GetFirstPC();
				while (oPC!=OBJECT_INVALID)
				{
					DelayCommand(48.0, CSLMsgBox(oPC, "Server Session #" + sSessionName+" will end in 15 seconds. You will be booted before the reset. This is normal."));
					oPC = GetNextPC();
				}
				CSLShoutMsg("Server Session #" + sSessionName+" will end in 1 minute.");
				ExecuteScript("TG_KingCircle_OnCircleEnd", GetModule() );
				return;
			}
			else if ( iRemainingUptime == 5 )
			{
				CSLShoutMsg("Server Session #" + sSessionName+" will end in 5 minutes.");
			}
		}
  	}
  	
  	if ( !GetIsSinglePlayer() ) // this is just for PW's
  	{
  		DelayCommand( CSLRandomUpToFloat(15.0f),  SCBootInactivePlayers() );
  	}
  	
}