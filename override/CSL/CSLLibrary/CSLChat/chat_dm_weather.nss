//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

#include "_SCInclude_Chat"
#include "_SCInclude_Weather"
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
	///ExecuteScript("DexBattle_Start", oDM);
	
	
	// SCWeather_Display( oTarget, oDM ); 
	if ( GetStringLowerCase(sParameters) == "help")
	{
		string sMessage = "DM_Weather Commands"+"\n";
		sMessage += "  type: Rain, Snow, Wind, Acidic, Fiery, Hail, Flood, Thunder, Sandstorm ( -before to remove)"+"\n";
		sMessage += "  Power: off, weak, light, medium, heavy, stormy"+"\n";
		sMessage += "      or 0,   1,    2,     3,      4,     5"+"\n";
		sMessage += "  Atmospere: clear, haze, fog, smoke, black, red, green"+"\n";
		sMessage += "  Dangers: lightning, explode, boulders, tornados, gusts ( -before to remove)"+"\n";
		sMessage += "  Danger Frequency: sporadic, rare, seldom, often"+"\n";
		//SendMessageToPC(oDM, sMessage );
		CSLInfoBox( oDM, "Weather Chat Commands", "Weather Chat Commands for DMs", sMessage );
		return;
	}
	
	int bFlood = FALSE;
	
	string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
	string sValue = CSLTrim(CSLNth_GetLast());
	int iWeatherState = GetLocalInt( GetArea(oTarget), "CSL_WEATHERSTATE");
	int iCurrentPower = CSLEnviroGetEnviroStatePower( iWeatherState );
	while( sValue != "" )
	{
		//SendMessageToPC(oDM, "Working on ["+ sValue+"]" );
		if ( sValue == "none" ) { iWeatherState = CSL_WEATHER_TYPE_NONE; } 
		
		else if ( sValue == "wind" )
		{
			iWeatherState |= CSL_WEATHER_TYPE_WIND;
			if ( iCurrentPower == WEATHER_POWER_OFF )
			{
				iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
				iCurrentPower = WEATHER_POWER_MEDIUM;
			}
		}
		else if ( sValue == "-wind" ) { iWeatherState &= ~CSL_WEATHER_TYPE_WIND; }
		else if ( sValue == "rain" )
		{
			iWeatherState |= CSL_WEATHER_TYPE_RAIN;
			iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
			iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
			if ( iCurrentPower == WEATHER_POWER_OFF )
			{
				iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
				iCurrentPower = WEATHER_POWER_MEDIUM;
			}
		}
		else if ( sValue == "-rain" )
		{
			iWeatherState &= ~CSL_WEATHER_TYPE_RAIN;
		}
		else if ( sValue == "snow" )
		{
			iWeatherState |= CSL_WEATHER_TYPE_SNOW;
			iWeatherState &= ~CSL_WEATHER_TYPE_RAIN;
			iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
			if ( iCurrentPower == WEATHER_POWER_OFF )
			{
				iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
				iCurrentPower = WEATHER_POWER_MEDIUM;
			}
			
		}
		else if ( sValue == "-snow" )
		{
			iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
		}
		else if ( sValue == "sandfog" || sValue == "sand" || sValue == "sandstorm" )
		{
			iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_SAND );
			iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
			iWeatherState &= ~CSL_WEATHER_TYPE_RAIN;
			if ( iCurrentPower == WEATHER_POWER_OFF )
			{
				iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
				iCurrentPower = WEATHER_POWER_MEDIUM;
			}
		}
		else if ( sValue == "-sandfog" || sValue == "-sand" || sValue == "-sandstorm" )
		{
			iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_NONE );
		}
		else if ( sValue == "acidic" )
		{
			iWeatherState |= CSL_WEATHER_TYPE_ACIDIC;
			iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_ACIDIC );
		}
		else if ( sValue == "-acidic" )
		{
			iWeatherState &= ~CSL_WEATHER_TYPE_ACIDIC;
		}
		else if ( sValue == "fiery" )
		{
			iWeatherState |= CSL_WEATHER_TYPE_FIERY;
			iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FIERY );
		}
		else if ( sValue == "-fiery" )
		{ 
			iWeatherState &= ~CSL_WEATHER_TYPE_FIERY;
		}
		else if ( sValue == "hail" ) { iWeatherState |= CSL_WEATHER_TYPE_HAIL; }
		else if ( sValue == "-hail" ) { iWeatherState &= ~CSL_WEATHER_TYPE_HAIL; }
		else if ( sValue == "flood" )  {  iWeatherState |= CSL_WEATHER_TYPE_FLOOD; bFlood = TRUE; }
		else if ( sValue == "-flood" )  {  iWeatherState &= ~CSL_WEATHER_TYPE_FLOOD; bFlood = FALSE; }
		else if ( sValue == "thunder" ) { iWeatherState |= CSL_WEATHER_TYPE_THUNDER; }
		else if ( sValue == "-thunder" ) { iWeatherState &= ~CSL_WEATHER_TYPE_THUNDER; }
		
		
		
		
		else if ( sValue == "off" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_OFF );
		}
		else if ( sValue == "weak" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_WEAK );
			iCurrentPower = WEATHER_POWER_WEAK;
		}
		else if ( sValue == "light" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_LIGHT );
			iCurrentPower = WEATHER_POWER_LIGHT;
		}
		else if ( sValue == "medium" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
			iCurrentPower = WEATHER_POWER_MEDIUM;
		}
		else if ( sValue == "heavy" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_HEAVY );
			iCurrentPower = WEATHER_POWER_HEAVY;
		}
		else if ( sValue == "stormy" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_STORMY );
			iCurrentPower = WEATHER_POWER_STORMY;
		}
		
		else if ( sValue == "0" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_OFF );
		}
		else if ( sValue == "1" )
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_WEAK );
			iCurrentPower = WEATHER_POWER_WEAK;
		}
		else if ( sValue == "2" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_LIGHT );
			iCurrentPower = WEATHER_POWER_LIGHT;
		}
		else if ( sValue == "3" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_MEDIUM );
			iCurrentPower = WEATHER_POWER_MEDIUM;
		}
		else if ( sValue == "4" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_HEAVY );
			iCurrentPower = WEATHER_POWER_HEAVY;
		}
		else if ( sValue == "5" ) 
		{
			iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_STORMY );
			iCurrentPower = WEATHER_POWER_STORMY;
		}
		
		else if ( sValue == "lightning" || sValue == "lightening" ) { iWeatherState |= CSL_WEATHER_RANDOMLIGHTNING; }
		else if ( sValue == "-lightning" || sValue == "-lightening" ) { iWeatherState &= ~CSL_WEATHER_RANDOMLIGHTNING; }
		else if ( sValue == "explode" ) { iWeatherState |= CSL_WEATHER_RANDOMEXPLODE; }
		else if ( sValue == "-explode" ) { iWeatherState &= ~CSL_WEATHER_RANDOMEXPLODE; }
		else if ( sValue == "boulders" || sValue == "boulder" ) { iWeatherState |= CSL_WEATHER_RANDOMBOULDERS; }
		else if ( sValue == "-boulders" || sValue == "-boulder" ) { iWeatherState &= ~CSL_WEATHER_RANDOMBOULDERS; }
		else if ( sValue == "tornados" || sValue == "tornado" ) { iWeatherState |= CSL_WEATHER_RANDOMTORNADOS; }
		else if ( sValue == "-tornados" || sValue == "-tornado" ) { iWeatherState &= ~CSL_WEATHER_RANDOMTORNADOS; }
		else if ( sValue == "gusts" || sValue == "gust" ) { iWeatherState |= CSL_WEATHER_RANDOMGUSTS; }
		else if ( sValue == "-gusts" || sValue == "-gust" ) { iWeatherState &= ~CSL_WEATHER_RANDOMGUSTS; }
		
		else if ( sValue == "sporadic" )
		{
			iWeatherState &= CSL_WEATHER_RANDOM_RARELY; 
			iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
			iWeatherState &= ~CSL_WEATHER_RANDOM_OFTEN; 
		}
		else if ( sValue == "rare" )
		{
			iWeatherState |= CSL_WEATHER_RANDOM_RARELY; 
			iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
			iWeatherState &= ~CSL_WEATHER_RANDOM_OFTEN; 
		}
		else if ( sValue == "seldom" )
		{
			iWeatherState &= ~CSL_WEATHER_RANDOM_RARELY; 
			iWeatherState |= CSL_WEATHER_RANDOM_SELDOM;
			iWeatherState &= ~CSL_WEATHER_RANDOM_OFTEN;
		}
		else if ( sValue == "often" )
		{
			iWeatherState &= ~CSL_WEATHER_RANDOM_RARELY; 
			iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
			iWeatherState |= CSL_WEATHER_RANDOM_OFTEN; 
		}
		else if ( sValue == "clear" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_NONE ); }
		else if ( sValue == "haze" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_HAZE ); }
		else if ( sValue == "fog" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG ); }
		else if ( sValue == "whitefog" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG ); }
		else if ( sValue == "fogwhite" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG ); }
		else if ( sValue == "smoke" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_SMOKE ); }
		else if ( sValue == "blackfog" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_BLACK ); }
		else if ( sValue == "fogblack" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_BLACK ); }
		else if ( sValue == "black" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_BLACK ); }
		else if ( sValue == "redfog" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FIERY ); }
		else if ( sValue == "fogred" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FIERY ); }
		else if ( sValue == "red" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FIERY ); }
		else if ( sValue == "greenfog" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_ACIDIC ); }
		else if ( sValue == "foggreen" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_ACIDIC ); }
		else if ( sValue == "green" ) { iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_ACIDIC ); }
		
		
		
		// get the next parameter
		sNewParameters = CSLNth_Shift(sNewParameters, " ");
		sValue = CSLTrim(CSLNth_GetLast());
	}
	
	if ( bFlood == TRUE )
	{
		int iWeatherPower = CSLEnviroGetEnviroStatePower( GetLocalInt( GetArea(oTarget), "CSL_WEATHERSTATE")  );
		float fWaterLevel = CSLGetZFromObject( oTarget );
		SetLocalFloat( GetArea(oTarget), "CSL_WATERFLOODHEIGHT", fWaterLevel );
	}
	
	SendMessageToPC(oDM, "Setting weather using " + sParameters +  " on Area " + GetName( GetArea(oTarget) ) + " to the state "+CSLWeatherStateToString( iWeatherState ) );

	CSLEnviroSetWeather( GetArea(oTarget), iWeatherState );
	//SendMessageToPC(oDM, "Complete" );
	
}