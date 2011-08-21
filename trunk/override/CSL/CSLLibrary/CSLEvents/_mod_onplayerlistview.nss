#include "_SCInclude_Playerlist"
#include "_CSLCore_Config"

void main()
{
	object oPlayer = OBJECT_SELF;
	if ( !GetIsObjectValid(oPlayer) )
	{
		return;
	}
	
	int bIsTargetDm = CSLGetIsDM( oPlayer, FALSE );
	string sDescription = "";
	string sDMDescription = "";
	
	string sFaction = GetLocalString( oPlayer, "CSL_FACTIONNAME");
	
	// xp and level
	int iLevel = GetHitDice(oPlayer);
	
	int iHps = GetCurrentHitPoints(oPlayer);
	int iMaxHps = GetMaxHitPoints(oPlayer);
	
	int nXP = GetXP(oPlayer);
	int nNextXP = (( iLevel * ( iLevel + 1 )) / 2 * 1000 );
	int nXPForNextLevel = nNextXP - nXP;
	if (iLevel==30) nXPForNextLevel = 0;
	
	string sRaceName = CSLGetFullRaceName(oPlayer);
	string sName = GetFirstName(oPlayer)+" "+GetLastName(oPlayer);
	
	string sAccountName = GetFirstName(oPlayer)+" "+GetLastName(oPlayer);
	
	
	string sPublicCDKey = CSLGetMyPublicCDKey(oPlayer);
	string sPlayerName = CSLGetMyPlayerName(oPlayer);
	string sIPAddress = CSLGetMyIPAddress(oPlayer);
	
	/* Put whatever text you want to show up here */
	
	sDescription += sName;
	sDMDescription += sName;
	
	if ( sPlayerName != "" )
	{
		sDescription += "\n"+sPlayerName;
		sDMDescription += "\n"+sPlayerName;
	}
	
	// now the following only show up for players, omit if the person targeted is a DM at present
	if ( !bIsTargetDm )
	{
		sDescription += "\n"+sRaceName;
		sDMDescription += "\n"+sRaceName;
		if ( iHps < iMaxHps )
		{
			sDMDescription += "\n"+"Hps: "+IntToString(iHps)+"/"+IntToString(iMaxHps);
		}
		else
		{
			sDMDescription += "\n"+"Hps: "+IntToString(iHps);
		}
		sDescription += "\n"+"HD: "+IntToString(iLevel)+" "+CSLClassLevels(oPlayer, FALSE, FALSE );
		sDMDescription += "\n"+"HD: "+IntToString(iLevel)+" "+CSLClassLevels(oPlayer, FALSE, TRUE );
		
		
		int iPlayerKills = GetLocalInt(oPlayer, "SDB_PKER");
		int iPlayerKilleds = GetLocalInt(oPlayer, "SDB_PKED");
		if ( iPlayerKills > 0 || iPlayerKilleds > 0 )
		{
			sDescription += "\n"+"Kills: "+IntToString(iPlayerKills)+" / Killed "+IntToString(iPlayerKilleds );
			sDMDescription += "\n"+"Kills: "+IntToString(iPlayerKills)+" / Killed "+IntToString(iPlayerKilleds );
		}
		if ( sFaction != "" )
		{
			sDescription += "\n"+"Faction: "+sFaction;
			sDMDescription += "\n"+"Faction: "+sFaction;
		}
	}
	
	sDMDescription += "\n"+"Area: "+GetName( GetArea(oPlayer) );
	sDMDescription += "\n"+"XP: "+IntToString(nXP)+" / "+ IntToString(nNextXP);
	
	if ( GetLocalInt(oPlayer,"SCLIENTEXTENDER" ) )
	{
		sDMDescription += "\n"+"Client Extender: "+GetLocalString(oPlayer,"SCLIENTEXTENDERVERSION" );
	}

	

	
	
	
	//string sDescription = GetLocalString( oPlayer, "CSL_PLAYERLIST_DESCRIPTION");
	//string sDMDescription = GetLocalString( oPlayer, "CSL_PLAYERLIST_DMDESCRIPTION");
	
	SetLocalString( oPlayer, "CSL_PLAYERLIST_DESCRIPTION", sDescription);
	SetLocalString( oPlayer, "CSL_PLAYERLIST_DMDESCRIPTION", sDMDescription);
	
	/*
	object oMaster = GetLocalObject(oPlayer, "MASTER" );
	if ( !GetIsObjectValid(oMaster) )
	{
		oMaster = GetMaster(oSummon);
		if ( !GetIsObjectValid(oMaster) )
		{
			return;
		}
	}
	
	
	
	int iBonus = SCGetSummonBonus( oMaster);
	int nAshbound = FALSE;
	
	SCSummonBoost(oSummon, oMaster, iBonus );
	*/
}