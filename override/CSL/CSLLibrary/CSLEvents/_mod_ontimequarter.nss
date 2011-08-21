#include "_CSLCore_Messages"
#include "_CSLCore_Time"
#include "_SCInclude_Events"
#include "_CSLCore_Player"

void main()
{
	object oModule = GetModule();
	int iElapsedQuarters = GetLocalInt( oModule, "CSL_CURRENT_ROUND" )/150;
	if (DEBUGGING >= 8) { CSLDebug( "quarter "+IntToString(iElapsedQuarters), GetFirstPC() ); }
	if ( CSLNWNX_Installed() ) // restarting requires NWNx
	{
		if (DEBUGGING >= 8) { CSLDebug( "nwnx installed", GetFirstPC() ); }
		string sServerMessage = GetLocalString(oModule, "SERVERMSG" );
		string sSessionNumber = GetLocalString(oModule, "SC_SESSIONNUMBER" );
		
		string sSessionName = GetLocalString(oModule, "SC_SESSIONNUMBER" );
		
		if ( sServerMessage != "" )
		{
			CSLShoutMsg( sServerMessage );
		}
		
		int iMaxUptime = SCGetMaxUptime();
		if ( iMaxUptime > 0 )
		{
			int iRemainingUptime = iMaxUptime - (iElapsedQuarters*15);
			if (DEBUGGING >= 8) { CSLDebug( "max iRemainingUptime= "+IntToString(iRemainingUptime), GetFirstPC() ); }
			
			
		
			if ( iRemainingUptime == 15 )
			{
				CSLShoutMsg("Server Session #" + sSessionName+" will end in 15 minutes.");
			}
			else
			{
				if ( iRemainingUptime > 0 )
				{
					CSLShoutMsg("Server Session #" + sSessionName+" will restart in " +CSLHoursMinutes(iRemainingUptime)+ ".");
				}
			}
		}
  	
  	}
  	
  	
}