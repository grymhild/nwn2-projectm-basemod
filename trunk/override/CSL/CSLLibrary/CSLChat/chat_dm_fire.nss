//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

#include "_SCInclude_Chat"
#include "_SCInclude_Artillery"

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
	///ExecuteScript("DexBattle_Start", oDM);
	
	
	// SCWeather_Display( oTarget, oDM ); 
	if ( GetStringLowerCase(sParameters) == "help")
	{
		string sMessage = "DM_Fire Commands"+"\n";
		sMessage += "  Target Fires a projectile, optional parameters"+"\n";
		sMessage += "  Velocity kph: 50"+"\n";
		sMessage += "  Elevation Degrees: 0-90 45 default, 0 is up, 90 is horizontal  "+"\n";
		sMessage += "  Mass: 100 default, 1 and up in kilograms  "+"\n";
		//SendMessageToPC(oDM, sMessage );
		CSLInfoBox( oDM, "DM_Fire Chat Commands", "DM_Fire Chat Commands for DMs", sMessage );
		return;
	}
	
	
	string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
	string sVelocity = CSLTrim(CSLNth_GetLast());
	if ( sVelocity != "" )
	{
		SetLocalFloat( oTarget, "CSLARTILLERY_VELOCITY", StringToFloat(sVelocity) );
		
		string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
		string sElevation = CSLTrim(CSLNth_GetLast());
		if ( sElevation != "" )
		{
			SetLocalFloat( oTarget, "CSLARTILLERY_ELEVATION", StringToFloat(sElevation) );
			
			string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
			string sMass = CSLTrim(CSLNth_GetLast());
			if ( sMass != "" )
			{
				SetLocalFloat( oTarget, "CSLARTILLERY_PROJETILEMASS", StringToFloat(sMass) );
			}
		}
	}
	
	
	SCFireProjectile( oTarget );	
}