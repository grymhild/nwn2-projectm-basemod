//#include "_SCUtility"
#include "_SCInclude_Battle"
#include "_SCInclude_faction"

//#include "seed_faction_inc"



const float SC_FACING_NORTH = 0.0;
const float SC_FACING_NORTHEAST= 45.0;
const float SC_FACING_EAST = 90.0;
const float SC_FACING_SOUTHEAST = 135.0;
const float SC_FACING_SOUTH = 180.0;
const float SC_FACING_SOUTHWEST = 225.0;
const float SC_FACING_WEST = 270.0;
const float SC_FACING_NORTHWEST = 315.0;

void DEXBattle_makeWP( string pathname, int iRow, float iFacing, string strName );
vector DEXBattle_getWP( string pathname, int iRow );
void DEXBattle_setUpNECastleWayPoints( string strArmy );
void DEXBattle_setUpNWCastleWayPoints( string strArmy );
void DEXBattle_setUpFieldWayPoints( string strArmy );
void DEXBattle_PrepareCastle( string strCastleName );
void DEXBattleClearWaypoints();
void DestroyCastleNWDecorations();
void DEXBattleDestroyByTag( string sTagName );
void DestroyCastleNEDecorations();
void DEXBattle_CreateArmy( int iArmySize, int iMaxAtOnce, int iRelativeToPCLevel, string strFactionName, int iFactionGroup, string strSoldiers = "", int iSoldierPerc = 0, string strArchers = "", int iArcherPerc = 0, string strSeargeants = "", int iSeargeantPerc = 0, string strBattleStandard = "");
void DEXBattle_setupAssaultBanners();


//SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", "1" );
//SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NW_FACTION", "2" );

string DEXBattle_getHeldBanner( string sFAID )
{
	if      (  sFAID == "1" ) { return "nw_it_bann212"; } // Fallen Angels
	else if (  sFAID == "2" ) { return "nw_it_bann203"; } // Order
	else if (  sFAID == "3" ) { return "nw_it_bann205"; } // TB
	else if (  sFAID == "4" ) { return "nw_it_bann206"; } // Triad
	else if (  sFAID == "5" ) { return "nw_it_bann202"; } // PKR
	// nw_it_bann201 is Legion which is dead

	// defaulted
	return "nw_it_bann207";
}

string DEXBattle_getPlacedBanner( string sFAID )
{
	if      (  sFAID == "1" ) { return "plc_mc_bann212"; } // Fallen Angels
	else if (  sFAID == "2" ) { return "plc_mc_bann203"; } // Order
	else if (  sFAID == "3" ) { return "plc_mc_bann205"; } // TB
	else if (  sFAID == "4" ) { return "plc_mc_bann206"; } // Triad
	else if (  sFAID == "5" ) { return "plc_mc_bann202"; } // PKR
	// plc_mc_bann201 is Legion which is dead

	// defaulted
	return "nw_it_bann207";
}




string DEXBattle_getCastleDefender( string strCastleName = "NW" ) // Castle is NW and NE, returns which faction is in control of said castle
{
	if (  strCastleName == "NW" )
	{
		return GetLocalString( GetModule(), "SC_BATTLE_CASTLE_NW_FACTION" );
	}
	else if (  strCastleName == "NE" )
	{
		return GetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION" );
	}
	return "";
}




void main()
{

	DelayCommand(0.5, DEXBattle_setupAssaultBanners() );

		// 30 max at a time i think
	// clean up old way points, perhaps move this to battle ending script
	DelayCommand(0.1, DEXBattleClearWaypoints() );
		
	DelayCommand(1.1,DEXBattle_PrepareCastle( "NE" ) );
	DelayCommand(2.1,DEXBattle_PrepareCastle( "NW" ) );
	
	
	//DelayCommand(0.1, DEXBattle_setUpNWCastleWayPoints( "faction1" ) );
	//DelayCommand(0.5, DEXBattle_setUpNECastleWayPoints( "faction3" ) );
	//DelayCommand(1.1, DEXBattle_setUpFieldWayPoints( "faction3" ) );
	
	//DelayCommand(3.0, DEXBattle_CreateArmy( 100, 6, 80, "faction1", STANDARD_FACTION_ARMY1, "btl_legion_soldier", 50, "btl_legion_archer", 40, "btl_legion_commander", 10,   DEXBattle_getHeldBanner( "1" ) ) );
	//DelayCommand(4.0, DEXBattle_CreateArmy( 100, 4, 100, "faction1", STANDARD_FACTION_ARMY1, "btl_order_soldier", 50, "btl_order_archer", 40, "btl_order_commander", 10,  DEXBattle_getHeldBanner( "2" ) ) );
	//DelayCommand(5.0, DEXBattle_CreateArmy( 100, 4, 80, "faction3", STANDARD_FACTION_ARMY3, "btl_tb_soldier", 50, "btl_tb_archer", 40, "btl_tb_commander", 10,  DEXBattle_getHeldBanner( "3" ) ) );
	//DelayCommand(6.0, DEXBattle_CreateArmy( 100, 6, 80, "faction2", STANDARD_FACTION_ARMY2, "btl_triad_soldier", 50, "btl_triad_archer", 40, "btl_triad_commander", 10, DEXBattle_getHeldBanner( "4" ) ) );
	//DelayCommand(7.0, DEXBattle_CreateArmy( 100, 6, 100, "faction2", STANDARD_FACTION_ARMY2, "btl_pkr_soldier", 50, "btl_pkr_archer", 40, "btl_pkr_commander", 10,  DEXBattle_getHeldBanner( "5" ) ) );
	
	
	
	
	
	
	
	//Fog of war On (Optional)
	DelayCommand(10.0,SetFogOfWar(TRUE));
	//Start the battle
	DelayCommand(11.0,BeginBattle());
	
	
	//BeginBattle("Custom_victory_condition_script"); (Alternative)
}




// sets up the castle and the waypoints, and dresses it up for battle
void DEXBattle_PrepareCastle( string strCastleName )
{
	string sDefender = DEXBattle_getCastleDefender( strCastleName );
	object oArea = GetObjectByTag( "Battleground" );
	string sPlacedBanner = DEXBattle_getPlacedBanner( sDefender );
	string sHeldBanner = DEXBattle_getHeldBanner( sDefender );
	
	if ( sDefender == "" )
	{
		// does not have a defender
		if (DEBUGGING >= 6) { CSLDebug("No Defender for "+strCastleName ); }
		
		return;
	}

	if ( strCastleName == "NW" )
	{	
		
		// PLC_CastleNWBanner
		if (DEBUGGING >= 6) { CSLDebug("Creating Banners for NW" ); }
		
		

		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 96.67221f, 320.01f, 60.39382f ), SC_FACING_SOUTHEAST), FALSE, "SC_CastleBannerNW01"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 96.99248f, 279.618f, 60.39382f ), SC_FACING_SOUTHEAST), FALSE, "SC_CastleBannerNW02"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 117.6808, 269.307, 60.39382 ), SC_FACING_NORTHWEST), FALSE, "SC_CastleBannerNW03"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 117.048f, 249.9838f, 60.39382f ), SC_FACING_SOUTHWEST), FALSE, "SC_CastleBannerNW04"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 127.0289f, 249.5991f, 60.39382f ), SC_FACING_SOUTH), FALSE, "SC_CastleBannerNW05"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector(136.869f, 249.6803f, 60.39382f ), SC_FACING_SOUTH), FALSE, "SC_CastleBannerNW06"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 146.2794f, 249.9012f, 60.39382f ), SC_FACING_SOUTHEAST), FALSE, "SC_CastleBannerNW07"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector(146.3179f, 269.4406f, 60.39382f ), SC_FACING_NORTHEAST), FALSE, "SC_CastleBannerNW08"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 166.5903f, 270.0356f, 60.39382f ), SC_FACING_SOUTHEAST), FALSE, "SC_CastleBannerNW09"), 1.5, 1.5, 1.5 );
		SetScale( CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 166.3794f, 319.5442f, 60.39382f ), SC_FACING_SOUTHEAST), FALSE, "SC_CastleBannerNW10"), 1.5, 1.5, 1.5 );
	
		CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 131.889f, 304.4986f, 45.28875f ), SC_FACING_EAST), FALSE, "SC_NWCastleBannerMain");

		if (DEBUGGING >= 6) { CSLDebug("Finished Creating Banners for NW" ); }		
		
		DEXBattle_setUpNWCastleWayPoints( "faction"+sDefender ) ;
	}
	else if ( strCastleName == "NE" )
	{
		if (DEBUGGING >= 6) { CSLDebug("Finished Creating Banners for NE" ); }
		
		DestroyCastleNEDecorations();
		
		CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, Vector( 274.0967f, 304.535f, 64.15f ), SC_FACING_EAST), FALSE, "SC_NECastleBannerMain");
	
	
		DEXBattle_setUpNECastleWayPoints( "faction"+sDefender );
	}
	
	
	string sFactionString = ""; //DEXBattle_getFactionString( sDefender );
	int iFactionConstant = 1; // DEXBattle_getFactionConstant( sDefender );
	
	if (DEBUGGING >= 6) { CSLDebug("Creating Army faction"+sDefender+" with "+sFactionString ); }
	DEXBattle_CreateArmy( 100, 6, 80, "faction"+sDefender, iFactionConstant, "btl_"+sFactionString+"_soldier", 50, "btl_"+sFactionString+"_archer", 40, "btl_"+sFactionString+"_commander", 10, sHeldBanner );
	
	
	
}

void DestroyCastleNEDecorations()
{
	DEXBattleDestroyByTag( "SC_NECastleBannerMain" );
}


void DestroyCastleNWDecorations()
{
		DEXBattleDestroyByTag( "SC_CastleBannerNW01" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW02" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW03" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW04" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW05" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW06" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW07" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW08" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW09" );
		DEXBattleDestroyByTag( "SC_CastleBannerNW10" );
		
		DEXBattleDestroyByTag( "SC_NWCastleBannerMain" );
}



void DEXBattleDestroyByTag( string sTagName )
{
	object oCreatedBanner;
	oCreatedBanner = GetObjectByTag( sTagName );
	
	while( GetIsObjectValid( oCreatedBanner ) )
	{
		DestroyObject( oCreatedBanner, 0.1f, FALSE);
		oCreatedBanner = GetObjectByTag( sTagName );
	}
}

//object DEXBattleCreateBanner( string sBanner, string sTagName, location oArea, float iX, float iY, float iZ, float iFacing, float iScaling )
//{
//	DEXBattleDestroyByTag( sTagName );
//	object oCreatedBanner;
//
//	return oCreatedBanner;
//}

void DEXBattle_CreateArmy( int iArmySize, int iMaxAtOnce, int iRelativeToPCLevel, string strFactionName, int iFactionGroup, string strSoldiers = "", int iSoldierPerc = 0, string strArchers = "", int iArcherPerc = 0, string strSeargeants = "", int iSeargeantPerc = 0, string strBattleStandard = "")
{
	
	//	int STANDARD_FACTION_HOSTILE  = 0;
	//	int STANDARD_FACTION_COMMONER = 1;
	//	int STANDARD_FACTION_MERCHANT = 2;
	//	int STANDARD_FACTION_DEFENDER = 3;
	//	
	//	int STANDARD_FACTION_ARMY1 = 4;
	//	int STANDARD_FACTION_ARMY2 = 5;
	//	int STANDARD_FACTION_ARMY3 = 6;
	//	int STANDARD_FACTION_ARMY4 = 7;
	//	int STANDARD_FACTION_ARMY5 = 8;
	
	
	CreateArmy(strFactionName, iFactionGroup, iArmySize, iMaxAtOnce );
	//50% orc, Lv = 40% of Average PC Lv
	if ( strSoldiers != "" )
	{
		AddSoldier(strFactionName, strSoldiers, iSoldierPerc, iRelativeToPCLevel );
	}
	//10% chief, Lv = 50% of Average PC Lv
	if ( strArchers != "" )
	{
		AddSoldier(strFactionName, strArchers, iArcherPerc, iRelativeToPCLevel );
	}
	//40% goblin, Lv = 40% of Average PC Lv
	if ( strSeargeants != "" )
	{
		AddSoldier(strFactionName, strSeargeants, iSeargeantPerc, iRelativeToPCLevel+10 );
	}
	//Enemy fires 20 arrows every 3 round, damage = 1d6 (Piercing), reflex save
	//DC = 25 (Optional)
	SetBarrage(strFactionName, 3, 20, 1, 35);
	//Enemy fires 4 catapults every 5 round, damage = 5d6 (Bludgeoning and fire)
	//+ knock down, reflex save DC = 25 (Optional)
	SetCatapult(strFactionName, 5, 4, 5, 35);
	//Battle standard (Optional)
	
	if ( strBattleStandard != "" )
	{
		SetBattleStandard(strFactionName, strBattleStandard);
	}


}

void DEXBattleClearWaypoints()
{
	object oArea = GetObjectByTag( "Battleground" );
	object oCurrentObject;
	oCurrentObject = GetFirstObjectInArea( oArea );
	
	while(GetIsObjectValid(oCurrentObject))
	{
		if ( GetObjectType( oCurrentObject) == OBJECT_TYPE_WAYPOINT  )
		{
			if ( (GetStringLeft( GetTag( oCurrentObject ), 6 ) == "wp_ep_") || (GetStringLeft( GetTag( oCurrentObject ), 4 ) == "wp_r") )
			{
				DestroyObject( oCurrentObject, 1.5f, FALSE);
			}
		}
		oCurrentObject = GetNextObjectInArea( oArea );
	}

	// Iterate the objects in the area
	

	
}


void DEXBattle_setupAssaultBanners()
{
// *
// This needs to do the following steps

//	Figure out which banners are not in play, factions with a castle do not have a banner show up

// Points 1-5 in following groups along bottom ( south of map )
// 	M is west of center
// 	N is far west corner
// 	P is east of center
// 	Q is far east corner
	
//	Loop from 1-5, one for each faction, assuming only 5 for now, only place if not castle
	
//	Use a counter to increment when placed
	
//	Create the banner in the subfunction
// 

	string sNEDefender = DEXBattle_getCastleDefender( "NE" );
	string sNWDefender = DEXBattle_getCastleDefender( "NW" );

	object oArea = GetObjectByTag( "Battleground" );

	
	//string sHeldBanner = DEXBattle_getHeldBanner( sDefender );

	int iFaction;
	string sFaction;
	string sPlacedBanner;
	int iFlagPosition = 0; // prevents skipping of spots
	for( iFaction = 1; iFaction <= 5; iFaction++ )
	{
		sFaction = IntToString( iFaction );
		if ( sFaction != sNEDefender && sFaction != sNWDefender ) 
		{
			iFlagPosition++;
			sPlacedBanner = DEXBattle_getPlacedBanner( sFaction );
			// CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", Location(oArea, DEXBattle_getWP( pathname, iRow ), iFacing), FALSE, strName);
			DEXBattleDestroyByTag( "SC_DEXBattleAssaultFaction_" + sFaction ); // make sure we don't readd these in
			CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, DEXBattle_getWP( "M", iFlagPosition ), SC_FACING_EAST), FALSE, "SC_DEXBattleAssaultFaction_" + sFaction );
			CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, DEXBattle_getWP( "N", iFlagPosition ), SC_FACING_EAST), FALSE, "SC_DEXBattleAssaultFaction_" + sFaction );
			CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, DEXBattle_getWP( "P", iFlagPosition ), SC_FACING_EAST), FALSE, "SC_DEXBattleAssaultFaction_" + sFaction );
			CreateObject(OBJECT_TYPE_PLACEABLE, sPlacedBanner, Location(oArea, DEXBattle_getWP( "Q", iFlagPosition ), SC_FACING_EAST), FALSE, "SC_DEXBattleAssaultFaction_" + sFaction );

		}
		//object oTrg = CSLGetCreatureNearLocation(lLoc, iN);
		//if( !GetIsObjectValid(oTrg) ){ return OBJECT_INVALID; }
		//if( CSLGetFactionDisposition(iFct, oTrg) == iRpt ){ return oTrg; }
	}



}

 
void DEXBattle_setUpNWCastleWayPoints( string strArmy ) 
{
	// make spawn points
	DEXBattle_makeWP( "A", 0, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "A", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "B", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "B", 3, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "A", 3, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "A", 4, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "B", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	
	// Path to Center
	DEXBattle_makeWP( "A", 4, SC_FACING_NORTH,"wp_r0_"+strArmy+"_0");
	DEXBattle_makeWP( "A", 5, SC_FACING_NORTH,"wp_r0_"+strArmy+"_1");
	DEXBattle_makeWP( "B", 4, SC_FACING_NORTH,"wp_r0_"+strArmy+"_2");
	DEXBattle_makeWP( "C", 1, SC_FACING_NORTH,"wp_r0_"+strArmy+"_3");
	DEXBattle_makeWP( "C", 2, SC_FACING_NORTH,"wp_r0_"+strArmy+"_4");
	
	// Center to other castle
	DEXBattle_makeWP( "C", 2, SC_FACING_NORTH,"wp_r1_"+strArmy+"_0");
	DEXBattle_makeWP( "G", 3, SC_FACING_NORTH,"wp_r1_"+strArmy+"_1");
	DEXBattle_makeWP( "G", 4, SC_FACING_NORTH,"wp_r1_"+strArmy+"_2");
	DEXBattle_makeWP( "F", 2, SC_FACING_NORTH,"wp_r1_"+strArmy+"_3");
	DEXBattle_makeWP( "F", 1, SC_FACING_NORTH,"wp_r1_"+strArmy+"_4");
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH,"wp_r1_"+strArmy+"_5");
	
	// Center to Pass 
	DEXBattle_makeWP( "C", 2, SC_FACING_NORTH,"wp_r2_"+strArmy+"_0");
	DEXBattle_makeWP( "G", 1, SC_FACING_NORTH,"wp_r2_"+strArmy+"_1");
	DEXBattle_makeWP( "H", 1, SC_FACING_NORTH,"wp_r2_"+strArmy+"_2");
	
	// Pass to Front
	DEXBattle_makeWP( "H", 1, SC_FACING_NORTH,"wp_r3_"+strArmy+"_0");
	DEXBattle_makeWP( "J", 6, SC_FACING_NORTH,"wp_r3_"+strArmy+"_1");
	DEXBattle_makeWP( "J", 5, SC_FACING_NORTH,"wp_r3_"+strArmy+"_2");
	DEXBattle_makeWP( "J", 4, SC_FACING_NORTH,"wp_r3_"+strArmy+"_3");
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r3_"+strArmy+"_4");
	
	
	
	// Second path out from castle
	DEXBattle_makeWP( "A", 3, SC_FACING_NORTH,"wp_r4_"+strArmy+"_0");
	DEXBattle_makeWP( "A", 5, SC_FACING_NORTH,"wp_r4_"+strArmy+"_1");
	DEXBattle_makeWP( "B", 3, SC_FACING_NORTH,"wp_r4_"+strArmy+"_2");
	DEXBattle_makeWP( "B", 2, SC_FACING_NORTH,"wp_r4_"+strArmy+"_3");
	DEXBattle_makeWP( "D", 2, SC_FACING_NORTH,"wp_r4_"+strArmy+"_4");
	DEXBattle_makeWP( "D", 3, SC_FACING_NORTH,"wp_r4_"+strArmy+"_5");
	DEXBattle_makeWP( "D", 4, SC_FACING_NORTH,"wp_r4_"+strArmy+"_6");
	DEXBattle_makeWP( "E", 1, SC_FACING_NORTH,"wp_r4_"+strArmy+"_7");
	DEXBattle_makeWP( "E", 2, SC_FACING_NORTH,"wp_r4_"+strArmy+"_8");
	DEXBattle_makeWP( "E", 3, SC_FACING_NORTH,"wp_r4_"+strArmy+"_9");
	DEXBattle_makeWP( "E", 4, SC_FACING_NORTH,"wp_r4_"+strArmy+"_10");
	DEXBattle_makeWP( "E", 5, SC_FACING_NORTH,"wp_r4_"+strArmy+"_11");
	DEXBattle_makeWP( "E", 6, SC_FACING_NORTH,"wp_r4_"+strArmy+"_12");
	DEXBattle_makeWP( "J", 2, SC_FACING_NORTH,"wp_r4_"+strArmy+"_13");
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r4_"+strArmy+"_14");
	
	// Center back up and over
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_0");
	DEXBattle_makeWP( "J", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_1");
	DEXBattle_makeWP( "K", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_2");
	DEXBattle_makeWP( "I", 6, SC_FACING_NORTH,"wp_r5_"+strArmy+"_3");
	DEXBattle_makeWP( "I", 5, SC_FACING_NORTH,"wp_r5_"+strArmy+"_4");
	DEXBattle_makeWP( "I", 4, SC_FACING_NORTH,"wp_r5_"+strArmy+"_5");
	DEXBattle_makeWP( "I", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_6");
	DEXBattle_makeWP( "I", 2, SC_FACING_NORTH,"wp_r5_"+strArmy+"_7");
	DEXBattle_makeWP( "I", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_8");
	DEXBattle_makeWP( "F", 4, SC_FACING_NORTH,"wp_r5_"+strArmy+"_9");
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_10");
	
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_0");
	DEXBattle_makeWP( "I", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_1");
	DEXBattle_makeWP( "I", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_2");
	DEXBattle_makeWP( "I", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_3");
	DEXBattle_makeWP( "I", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_4");
	DEXBattle_makeWP( "I", 5, SC_FACING_NORTH,"wp_r6_"+strArmy+"_5");
	DEXBattle_makeWP( "I", 6, SC_FACING_NORTH,"wp_r6_"+strArmy+"_6");
	DEXBattle_makeWP( "J", 5, SC_FACING_NORTH,"wp_r6_"+strArmy+"_7");
	DEXBattle_makeWP( "J", 6, SC_FACING_NORTH,"wp_r6_"+strArmy+"_8");
	DEXBattle_makeWP( "H", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_9");
	DEXBattle_makeWP( "G", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_10");
	DEXBattle_makeWP( "C", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_11");
	DEXBattle_makeWP( "C", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_12");
	DEXBattle_makeWP( "B", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	
}


void DEXBattle_setUpNECastleWayPoints( string strArmy ) 
{
	// make spawn points
	DEXBattle_makeWP( "F", 1, SC_FACING_WEST, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "F", 2, SC_FACING_WEST, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "F", 4, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "I", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "F", 6, SC_FACING_NORTH, "wp_ep_"+strArmy );
	
	
	// Path to Center
	DEXBattle_makeWP( "F", 1, SC_FACING_NORTH,"wp_r0_"+strArmy+"_0");
	DEXBattle_makeWP( "F", 2, SC_FACING_NORTH,"wp_r0_"+strArmy+"_1");
	DEXBattle_makeWP( "G", 4, SC_FACING_NORTH,"wp_r0_"+strArmy+"_2");
	DEXBattle_makeWP( "G", 2, SC_FACING_NORTH,"wp_r0_"+strArmy+"_3");
	DEXBattle_makeWP( "C", 2, SC_FACING_NORTH,"wp_r0_"+strArmy+"_4");
	DEXBattle_makeWP( "C", 1, SC_FACING_NORTH,"wp_r0_"+strArmy+"_5");
	DEXBattle_makeWP( "B", 4, SC_FACING_NORTH,"wp_r0_"+strArmy+"_6");
	
	// down the path on the soutneast
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_0");
	DEXBattle_makeWP( "I", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_1");
	DEXBattle_makeWP( "I", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_2");
	DEXBattle_makeWP( "I", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_3");
	DEXBattle_makeWP( "I", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_4");
	DEXBattle_makeWP( "I", 5, SC_FACING_NORTH,"wp_r6_"+strArmy+"_5");
	DEXBattle_makeWP( "I", 6, SC_FACING_NORTH,"wp_r6_"+strArmy+"_6");
	DEXBattle_makeWP( "J", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_7");
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_8");
	
	// up the path on the southwest
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_9");
	DEXBattle_makeWP( "J", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_10");
	DEXBattle_makeWP( "E", 6, SC_FACING_NORTH,"wp_r6_"+strArmy+"_11");
	DEXBattle_makeWP( "E", 5, SC_FACING_NORTH,"wp_r6_"+strArmy+"_12");
	DEXBattle_makeWP( "E", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "B", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
}


void DEXBattle_setUpFieldWayPoints( string strArmy ) 
{
	// make spawn points
	DEXBattle_makeWP( "L", 1, SC_FACING_WEST, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "L", 2, SC_FACING_WEST, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "J", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "K", 1, SC_FACING_NORTH, "wp_ep_"+strArmy );
	DEXBattle_makeWP( "K", 2, SC_FACING_NORTH, "wp_ep_"+strArmy );
	
	// up the path on the southwest
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_9");
	DEXBattle_makeWP( "J", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_10");
	DEXBattle_makeWP( "E", 6, SC_FACING_NORTH,"wp_r6_"+strArmy+"_11");
	DEXBattle_makeWP( "E", 5, SC_FACING_NORTH,"wp_r6_"+strArmy+"_12");
	DEXBattle_makeWP( "E", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "E", 1, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 4, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 3, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "D", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	DEXBattle_makeWP( "B", 2, SC_FACING_NORTH,"wp_r6_"+strArmy+"_13");
	
		// Center back up and over
	DEXBattle_makeWP( "J", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_0");
	DEXBattle_makeWP( "J", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_1");
	DEXBattle_makeWP( "K", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_2");
	DEXBattle_makeWP( "I", 6, SC_FACING_NORTH,"wp_r5_"+strArmy+"_3");
	DEXBattle_makeWP( "I", 5, SC_FACING_NORTH,"wp_r5_"+strArmy+"_4");
	DEXBattle_makeWP( "I", 4, SC_FACING_NORTH,"wp_r5_"+strArmy+"_5");
	DEXBattle_makeWP( "I", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_6");
	DEXBattle_makeWP( "I", 2, SC_FACING_NORTH,"wp_r5_"+strArmy+"_7");
	DEXBattle_makeWP( "I", 1, SC_FACING_NORTH,"wp_r5_"+strArmy+"_8");
	DEXBattle_makeWP( "F", 4, SC_FACING_NORTH,"wp_r5_"+strArmy+"_9");
	DEXBattle_makeWP( "F", 3, SC_FACING_NORTH,"wp_r5_"+strArmy+"_10");

}

void DEXBattle_makeWP( string pathname, int iRow, float iFacing, string strName ) 
{
	object oArea = GetObjectByTag( "Battleground" );
	CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", Location(oArea, DEXBattle_getWP( pathname, iRow ), iFacing), FALSE, strName);
}

vector DEXBattle_getWP( string pathname, int iRow ) 
{
	vector vWPLocation; // Vector( X, Y, H(Z) );
	
	if ( pathname == "A" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(114.0f, 302.0f, 32.3172f);
				break;
			case 2: vWPLocation = Vector(141.0f, 300.0f, 32.3172f);
				break;
			case 3: vWPLocation = Vector(129.0f, 286.0f, 32.3172f);
				break;
			case 4: vWPLocation = Vector(134.0f, 286.0f, 32.3172f);
				break;
			case 5: vWPLocation = Vector(149.0f, 274.0f, 32.3172f);
				break;
		}
	}
	else if  ( pathname == "B" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(111.0f, 250.0f, 32.10502f);
				break;
			case 2: vWPLocation = Vector(126.0f, 242.0f, 32.06816f);
				break;
			case 3: vWPLocation = Vector(149.0f, 264.0f, 32.3172f);
				break;
			case 4: vWPLocation = Vector(156.0f, 264.0f, 32.3172f);
				break;
			case 5: vWPLocation = Vector(156.0f, 240.0f, 32.06253f);
				break;
			case 6: vWPLocation = Vector(154.0f, 217.0f, 32.31372f);
				break;
			case 7: vWPLocation = Vector(170.0f, 204.0f, 32.20717f);
				break;
			case 8: vWPLocation = Vector(189.0f, 188.0f, 32.325f);
				break;
		}
	}
	else if  ( pathname == "C" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(158.0f, 250.0f, 29.4181f);
				break;
			case 2: vWPLocation = Vector(180.0f, 230.0f, 7.88719f);
				break;
		}
	}
	else if  ( pathname == "D" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(94.0f, 228.0f, 32.3172f);
				break;
			case 2: vWPLocation = Vector(118.0f, 213.0f, 30.91722f);
				break;
			case 3: vWPLocation = Vector(110.0f, 192.0f, 26.60208f);
				break;
			case 4: vWPLocation = Vector(110.0f, 175.0f, 24.3147f);
				break;
		}
	}
	else if  ( pathname == "E" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(143.0f, 173.0f, 25.05135f);
				break;
			case 2: vWPLocation = Vector(125.0f, 153.0f, 13.1785f);
				break;
			case 3: vWPLocation = Vector(114.0f, 138.0f, 11.18322f);
				break;
			case 4: vWPLocation = Vector(118.0f, 123.0f, 13.208f);
				break;
			case 5: vWPLocation = Vector(138.0f, 118.0f, 12.44963f);
				break;
			case 6: vWPLocation = Vector(164.0f, 120.0f, 2.43942f);
				break;
		}
	}
	else if  ( pathname == "F" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(254.0f, 286.0f, 32.31252f);
				break;
			//case 2: vWPLocation = Vector(189.0f, 188.0f, 32.325f);
			case 2: vWPLocation = Vector( 217.7287, 188.4473, 32.31372 );
				break;
			//case 3: vWPLocation = Vector(277.0f, 208.0f, 32.3125f);
			case 3: vWPLocation = Vector( 277.0f, 203.105f, 32.3125f );
				break;
			case 4: vWPLocation = Vector(292.0f, 201.0f, 31.7886f);
				break;
			case 5: vWPLocation = Vector(253.0f, 199.0f, 32.31373f);
				break;
			case 6: vWPLocation = Vector(292.0f, 201.0f, 31.7886f);
				break;
		}
	}
	else if  ( pathname == "G" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(197.0f, 209.0f, 6.64706f);
				break;
			case 2: vWPLocation = Vector(198.0f, 220.0f, 6.64706f);
				break;
			case 3: vWPLocation = Vector(185.0f, 232.0f, 6.75564f);
				break;
			case 4: vWPLocation = Vector(225.0f, 248.0f, 11.26591f);
				break;
			case 5: vWPLocation = Vector(190.0f, 259.0f, 6.24861f);
				break;
			case 6: vWPLocation = Vector(189.0f, 288.0f, 6.63451f);
				break;
			case 7: vWPLocation = Vector(195.0f, 310.0f, 6.64706f);
				break;
			case 8: vWPLocation = Vector(210.0f, 310.0f, 6.64706f);
				break;
			case 9: vWPLocation = Vector(210.0f, 288.0f, 6.63451f);
				break;
			case 10: vWPLocation = Vector(210.0f, 259.0f, 6.24861f);
				break;
		}
	}
	else if  ( pathname == "H" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(203.0f, 176.0f, 0.35367f);
				break;
		}
	}
	else if  ( pathname == "I" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(280.0f, 185.0f, 28.60405f);
				break;
			case 2: vWPLocation = Vector(257.0f, 161.0f, 22.684f);
				break;
			case 3: vWPLocation = Vector(292.0f, 155.0f, 11.32641f);
				break;
			case 4: vWPLocation = Vector(288.0f, 137.0f, 11.3921f);
				break;
			case 5: vWPLocation = Vector(258.0f, 127.0f, 0.9707f);
				break;
			case 6: vWPLocation = Vector(242.0f, 121.0f, -0.5528f);
				break;
			case 7: vWPLocation = Vector(257.0f, 143.0f, 11.5389f);
				break;
		}
	}
	else if  ( pathname == "J" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(205.0f, 115.0f, 1.81f);
				break;
			case 2: vWPLocation = Vector(179.0f, 133.0f, 0.46735f);
				break;
			case 3: vWPLocation = Vector(196.0f, 132.0f, 0.40201f);
				break;
			case 4: vWPLocation = Vector(223.0f, 126.0f, 0.46962f);
				break;
			case 5: vWPLocation = Vector(238.0f, 138.0f, 0.07876f);
				break;
			case 6: vWPLocation = Vector(225.0f, 156.0f, 0.40492f);
				break;
		}
	}
	else if  ( pathname == "K" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(218.0f, 95.0f, 0.59118f);
				break;
			case 2: vWPLocation = Vector(227.0f, 87.0f, 1.22f);
				break;
		}
	}
	else if  ( pathname == "L" )
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(177.0f, 94.0f, 0.60679f);
				break;
			case 2: vWPLocation = Vector(165.0f, 86.0f, 0.5625f);
				break;
		}
	}
	else if  ( pathname == "M" )  // flag spawn point 1 around the pavilion on the west of center
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector(164.2423f, 87.34422f, 0.6918437f );
				break;
			case 2: vWPLocation = Vector( 164.7941f, 91.89837f, 0.5385817f );
				break;
			case 3: vWPLocation = Vector( 167.77f, 95.37877f, 0.3574989f );
				break;
			case 4: vWPLocation = Vector( 172.0346f, 97.11746f, 0.6078432f );
				break;
			case 5: vWPLocation = Vector( 177.0387f, 96.66402f, 0.6078432f );
				break;
		}
	}
	else if  ( pathname == "N" )  // flag spawn point 2 farwest corner
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector( 83.32422f, 92.46558f, 27.58971f );
				break;
			case 2: vWPLocation = Vector( 83.87598f, 97.01973f, 26.71795f );
				break;
			case 3: vWPLocation = Vector( 86.85191f, 100.5001f, 26.3014f );
				break;
			case 4: vWPLocation = Vector( 91.11647f, 102.2388f, 25.60355f );
				break;
			case 5: vWPLocation = Vector( 96.12061f, 101.7854f, 24.90973f );
				break;
		}
	}
	else if  ( pathname == "P" ) // flag spawn point 3 on east side of center
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector( 232.4212f, 84.93631f, 0.5625f );
				break;
			case 2: vWPLocation = Vector( 231.3269f, 90.60218f, 0.3362595f );
				break;
			case 3: vWPLocation = Vector( 227.9319f, 95.16777f, 0.2618789f );
				break;
			case 4: vWPLocation = Vector( 223.073f, 97.24092f, 0.5511472f );
				break;
			case 5: vWPLocation = Vector( 219.2346f, 97.04309f, 0.6058385f );
				break;
		}
	}
	else if  ( pathname == "Q" ) // flag spawn point 3 on far east corner
	{
		switch ( iRow )
		{
			case 1: vWPLocation = Vector( 298.2077f, 92.56932f, 14.10437f );
				break;
			case 2: vWPLocation = Vector( 298.7595f, 97.12347f, 14.07997f );
				break;
			case 3: vWPLocation = Vector( 301.7354f, 100.6039f, 14.77814f );
				break;
			case 4: vWPLocation = Vector( 306.0f, 102.3426f, 16.12151f );
				break;
			case 5: vWPLocation = Vector( 311.0041f, 101.8891f, 17.51549f );
				break;
		}
	}
	
	

	
	return vWPLocation;
}