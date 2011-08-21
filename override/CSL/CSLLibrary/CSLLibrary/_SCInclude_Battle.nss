/** @file
* @brief Include file for Nytir's Battle system
*
* 
* 
*
* @ingroup scinclude
* @author Nytir, Brian T. Meyer and others
*/



/* This was Nytirs Battle System originally, but likely being changed enough soas to be a different animal*/

#include "_CSLCore_ObjectVars"
#include "_CSLCore_Messages"
#include "_CSLCore_Strings"
#include "_CSLCore_Reputation"
#include "_CSLCore_Position"
#include "_CSLCore_Player"
// =================================================================
// Battle Settings
//
// Contain variables and methods required to orchestrate a battle
// Scope of the methods are area (caller) centered. You cannot call 
// the methods from outside the area to change the battle. The methods 
// are designed to be used in the area in dialogue/cutscene.
// 
// By Nytir
// =================================================================
// Local Variables

// Area
const string ARO_BCTRL = "BATTLECONTROL";
// Battle Control
const string BCS_BARMY = "ARMIES";
const string BCS_BVCDF = "VictoryDefeatScript";
const string BCI_BACTV = "BATTLEACTIVE";
const string BCI_ENGGD = "ARMIESENGAGED";
const string BCI_BFOW  = "FOGOFWAR";
const string BCO_BFOW  = "FOGS";
// Army Statistic
const string AMI_FCTN  = "_FACTION";
const string AMI_TTL   = "_TOTAL";
const string AMI_RSRV  = "_RESERVE";
const string AMI_SLMT  = "_SPAWNLIMIT";
const string AMI_SCNT  = "_SPAWNCOUNT";
const string AMI_DCNT  = "_DEATHCOUNT";
const string AMS_BSREF = "_STANDARDREF";
const string AMO_ENTRY = "_ENTRYPOINTS";
// Army Cover Fire 
const string ACL_LNCH  = "_LAUNCHLOCATIONS";
const string ACL_TRGT  = "_TARGETLOCATIONS";
const string ACS_BRR   = "_BARRAGE";
const string ACS_CTP   = "_CATAPULT";
const string ACI_FQN   = "_FREQUENCY";
const string ACI_CDN   = "_COOLDOWN";
const string ACI_QTY   = "_QUANTITY";
const string ACI_DMG   = "_DAMAGE";
const string ACI_SDC   = "_SAVEDC";
// Army Soldier Type
const string ATO_TMPLT = "_TYPE_TEMPLATES";
const string ATS_TMPLT = "_TYPE_RESREFS";
const string ATI_RSRV  = "_TYPE_RESERVES";
const string ATI_LVADJ = "_TYPE_LVADJUSTS";
const string ATI_PRCNT = "_TYPE_PERCENTAGES";
// Individual Soldier
const string BSS_ARMY  = "ARMY";
const string BSI_ROUTE = "ATTACKROUTE";
const string BSI_ARNXT = "ATTACKROUTENEXT";
const string BSS_HBS   = "HEARTBEAT";
const string BSS_ODS   = "ONDEATH";
// PC
const string PCI_KCNT  = "KOCOUNT";
const string PCI_KTTL  = "KOTOTAL";
// Official
const string OFI_NTRSR = "X2_L_NOTREASURE";
// =================================================================
// Tags & resrefs
const string VFX_SMOKE = "n2_fx_fire_smoke";
const string SFX_BTTL  = "sfx_battle";
const string PLC_IP    = "plc_ipoint ";
const string PLC_BC    = "plc_battlecontrol";
const string WP_EP     = "wp_ep_"; //wp_ep_armyname
const string WP_AR     = "wp_r";   //wp_rx_armyname_x
// Scripts
const string SCR_PL_HB = "DexBattle_pl_heartbeat";  //SCR_PL_HB
const string SCR_CR_HB = "DexBattle_cr_heartbeat";
const string SCR_CR_OD = "DexBattle_cr_ondeath";
const string SCR_EX_VD = "DexBattle_victorydefeat";
// =================================================================
// Prototypes
// =================================================================

// Battle Preparation
/*
object GetBattleControl( object oThingInTargetArea = OBJECT_SELF );
string EntryPointTag(string sArmy);
string AttackPointTag(string sArmy, int iR, int iN);
int GetNearestAttackRoute(string sArmy, object oEP);
void MapAttackRoute(string sArmy);
void CreateLaunchPoint(string sArmy, object oPTA, object oPTB);
void SetupLaunchPoint(string sArmy);
void CreateTemplate(string sArmy);
// Special effects
int GetFogOfWar();
void SetFogOfWar(int iOn);
void CreateFogOfWar();
void RemoveFogOfWar();
void StartBattleSFX();
void StopBattleSFX();
void ResetKOCount();
// Army Settings
void DestroyTroop(string sArmy);
void DeleteArmy(string sArmy, int iDestroy=TRUE);
void CreateArmy(string sArmy, int iFct, int iRsrv, int iLmt);
void AddSoldier(string sArmy, string sRes, int iPrcnt, int iLvAdj=-1);
void ReinforceArmy(string sArmy, int iAmt);
void ShowArmyStat(string sArmy, object oPC);
int GetIsArmyAnnihilated(string sArmy);
int GetIsAnnihilated(object oPC, int iRpt);
// Cover Fire Settings
void SetCoverFire(string sName, int iF, int iN, int iD, int iDC);
void SetBarrage(string sArmy, int iF=3, int iN=20, int iD=1, int iDC=10);
void SetCatapult(string sArmy, int iF=5, int iN=4, int iD=5, int iDC=10);
void DeleteCoverFire(string sName);
void DeleteBarrage(string sArmy);
void DeleteCatapult(string sArmy);
int GetIsCoverFireSet(string sName);
int GetIsBarrageSet(string sArmy);
int GetIsCatapultSet(string sArmy);
// Battle Settings
int GetIsBattleActive();
void SetBattleActive(int iBol);
void AbortBattle();
void BeginBattle(string sVD="");
void ShowBattleStat(object oPC, string sTtl="", string sSrc="");

void DEXBattle_setupReuptation();
void DEXBattle_AdjustReputationFactionWide( object oFactionRep1, object oFactionRep2 );
void DEXBattle_AdjustReputationIndivdual( object oPC, object oFactionRep );

// Battle Control
int SpawnProbablity(string sArmy, int iN, int iTR, int iRD);
void SpawnSoldier(string sArmy, int iN, string sFG="");
void SpawnPlatoon(string sArmy);
void ApplyCatapultEffect(location lLoc, int iFac, int iD, int iDC);
void FireCatapult(location lSrc, location lTrg, int iFac, int iD, int iDC);
void FireArrow(location lSrc, location lTrg, int iFac, int iD, int iDC, int iF=FALSE);
void LaunchCoverFire(string sArmy, string sType);
void BattleControlHB();
// Battle Spawn
void ReportCasualty(object oBS = OBJECT_SELF);
void IncKOCount(object oBS = OBJECT_SELF);
void BattleCharge(object oBS = OBJECT_SELF);
void BattleSpawnHB();
void BattleSpawnOD();
*/

// =================================================================
// Battle Control Object (Private Use)
// =================================================================

// Get the battle control object (invisible placeable)(ipoint).
// Create one if missing. Battle control monitors the battlefield 
// and performs all neccessary administration using heartbeat script.
// Originally planned to use Area heartbeat to act as Battle control
// but SetEventHandler does not work on area
object GetBattleControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oAR = GetArea( oThingInTargetArea );
	object oBC = GetLocalObject( oAR, ARO_BCTRL );
	if( !GetIsObjectValid(oBC) )
	{
		SendMessageToPC( GetFirstPC(), "Battle Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oBC = CSLCreatePlacable(PLC_IP, oThingInTargetArea, PLC_BC);
		// Register New Battle Control
		SetPlotFlag(oBC, TRUE);
		SetEventHandler(oBC, SCRIPT_PLACEABLE_ON_HEARTBEAT, SCR_PL_HB);
		SetLocalObject(oAR, ARO_BCTRL, oBC);
	}
	return oBC;
}
// =================================================================
// Battle Preparations (Private Use)
// =================================================================

// Construct a tag of Entry Point
// wp_ep_armyname
string EntryPointTag(string sArmy)
{
	return WP_EP + sArmy;
}

// Construct a tag of a point of an Attack Route
// wp_rx_armyname_x
// iR : route number
// iN : attack route stage
string AttackPointTag(string sArmy, int iR, int iN)
{
	return WP_AR + IntToString(iR) +"_"+ sArmy +"_"+ IntToString(iN);
}
// =================================================================

// Find the nearest Attack Route to Entry Point
int GetNearestAttackRoute(string sArmy, object oEP)
{
	int    iN  = 0;
	int    iAR = iN;
	string sTG = AttackPointTag(sArmy, iN, 0);
	object oPT = GetNearestObjectByTag(sTG, oEP);
	float  fPT = GetDistanceBetween(oEP, oPT);
	float  fAR = fPT;
	while( GetIsObjectValid(oPT) ){
		if( fPT < fAR ){ iAR = iN; fAR = fPT; }
		// Next
		iN ++;
		sTG = AttackPointTag(sArmy, iN, 0);
		oPT = GetNearestObjectByTag(sTG, oEP);
		fPT = GetDistanceBetween(oEP, oPT);
	}
	return iAR;
}
// Collect Information about Entry Points and Attack Route
// Map Entry Points to Attack Route
void MapAttackRoute(string sArmy)
{
	object oBC = GetBattleControl();
	int    iN  = 1;
	string sTG = EntryPointTag(sArmy);
	object oEP = GetNearestObjectByTag(sTG, oBC, iN);

	CSLDataArray_DeleteObject(oBC, sArmy + AMO_ENTRY, FALSE);
	CSLMyDebug("Map Attack Route", sArmy);
	
	while( GetIsObjectValid(oEP) ){
		int iAR = GetNearestAttackRoute(sArmy, oEP);
		SetLocalInt(oEP, BSI_ROUTE, iAR);
		CSLDataArray_PushObject(oBC, sArmy + AMO_ENTRY, oEP);
		
		//CSLMyDebugLog("Map Entry Point " +IntToString(iN));
		//CSLMyDebugLog(" to Route " +IntToString(iAR));
		//CSLMyDebugFlush(sArmy);
		// Next
		iN ++;
		oEP = GetNearestObjectByTag(sTG, oBC, iN);
	}
}
// =================================================================

// Calculate A Set of Points for Launching missiles
void CreateLaunchPoint(string sArmy, object oPTA, object oPTB)
{
	object oBC  = GetBattleControl();
	vector vPTA = GetPosition(oPTA);
	vector vPTB = GetPosition(oPTB);
	vector vSrc = Vector();
	vector vTrg = Vector();
	float  fSMT = 1.5f;
	float  fTMT = 0.6f;
	
	vTrg.x = vPTA.x + (vPTB.x - vPTA.x) *fTMT;
	vTrg.y = vPTA.y + (vPTB.y - vPTA.y) *fTMT;
	vTrg.z = vPTA.z + (vPTB.z - vPTA.z) *fTMT;
	vSrc.x = vPTB.x + (vPTA.x - vPTB.x) *fSMT;
	vSrc.y = vPTB.y + (vPTA.y - vPTB.y) *fSMT;
	vSrc.z = vPTB.z + (vPTA.z - vPTB.z) *fSMT + 10.0f;
	location lSrc = Location(GetArea(oPTA), vSrc, 0.0f);
	location lTrg = Location(GetArea(oPTA), vTrg, 0.0f);
	CSLDataArray_PushLocation(oBC, sArmy + ACL_LNCH, lSrc);
	CSLDataArray_PushLocation(oBC, sArmy + ACL_TRGT, lTrg);
	
	//CSLMyDebugLog(CSLFormatLocation(lSrc) +" >> ");
	//CSLMyDebugLog(CSLFormatLocation(lTrg));
	//CSLMyDebugFlush(sArmy);
}

// Setup Launch Points for barrages and catapults
// base on the location of Entry Points
void SetupLaunchPoint(string sArmy){
	object oBC = GetBattleControl();
	int    iAX = CSLDataArray_LengthString(oBC, BCS_BARMY);
	int    iEC = CSLDataArray_LengthObject(oBC, sArmy + AMO_ENTRY);
	int    iFC = GetLocalInt(oBC, sArmy + AMI_FCTN);
	int    iAR;
	int    iEP;
	
	CSLDataArray_DeleteLocation(oBC, sArmy + ACL_LNCH);
	CSLDataArray_DeleteLocation(oBC, sArmy + ACL_TRGT);
	CSLMyDebug("Setup Launch Points", sArmy);
	
	for( iAR=0; iAR<iAX; iAR++ ){
		string sTrg = CSLDataArray_GetString(oBC, BCS_BARMY, iAR);
		string sTag = EntryPointTag(sTrg);
		int    iTFC = GetLocalInt(oBC, sTrg + AMI_FCTN);
		
		if( iFC != iTFC ){
			for( iEP=0; iEP<iEC; iEP++ ){
				object oEP = CSLDataArray_GetObject(oBC, sArmy + AMO_ENTRY, iEP);
				object oPT = GetNearestObjectByTag(sTag, oEP);
				CreateLaunchPoint(sArmy, oEP, oPT);
			}
		}
	}
}
// =================================================================

// Create Soldier Templates for the Amry. They are used for further copying
void CreateTemplate(string sArmy)
{
	object oBC = GetBattleControl();
	object oEP = CSLDataArray_CycleObject(oBC, sArmy + AMO_ENTRY);
	int    iFC = GetLocalInt(oBC, sArmy + AMI_FCTN);
	int    iTP = CSLDataArray_LengthString(oBC, sArmy + ATS_TMPLT);
	int    iAL = CSLGetPCAverageLevel();
	int    iN;
	// Destroy Old Templates
	CSLDataArray_DeleteObject(oBC, sArmy + ATO_TMPLT, TRUE);
	// Go thru all Templates
	for( iN=0; iN<iTP; iN++ )
	{
		int    iAdj = CSLDataArray_GetInt(oBC, sArmy + ATI_LVADJ, iN);
		string sRef = CSLDataArray_GetString(oBC, sArmy + ATS_TMPLT, iN);
		string sTag = sRef +"_"+ IntToString(iN);
		object oBP  = CSLCreateCreature(sRef, oEP, sTag);
		// Set hidden
		SetPlotFlag(oBP, TRUE);
		SetScriptHidden(oBP, TRUE, TRUE);
		// Adjust Level
		if( iAdj >= 0 ){ 
			CSLLevelUpCreature(oBP, (iAL*iAdj/100), TRUE); 
			ForceRest(oBP);	
		}
		//ChangeToStandardFaction(oBP, iFC);
		CSLDataArray_PushObject(oBC, sArmy + ATO_TMPLT, oBP);
		//CSLMyDebugLog("Create template " +sTag);
		//CSLMyDebugLog(" Level " +IntToString(GetTotalLevels(oBP,TRUE)));
		//CSLMyDebugFlush(sArmy);
	}
}
// =================================================================

// Get Fog of War Effect
int GetFogOfWar()
{
	object oBC = GetBattleControl();
	return GetLocalInt(oBC, BCI_BFOW);
}
// Set Fog of War Effect
void SetFogOfWar(int iOn)
{
	object oBC = GetBattleControl();
	SetLocalInt(oBC, BCI_BFOW, iOn);
}
// Create Fog of War Effect
void CreateFogOfWar()
{
	if( !GetFogOfWar() )
	{ 
		return;
	}
	object oBC  = GetBattleControl();
	int    iA   = CSLDataArray_LengthString(oBC, BCS_BARMY);
	int    iTyp = OBJECT_TYPE_PLACED_EFFECT;
	int    iS   = 10/iA;
	int    iN, iM;
	//CSLMyDebug("Create Fog Of War", "Battle Control");
	CSLDataArray_DeleteObject(oBC, BCO_BFOW, TRUE);
	for( iN=0; iN<iA; iN++ )
	{
		string sArmy = CSLDataArray_GetString(oBC, BCS_BARMY, iN);
		for( iM=0; iM<iS; iM++ )
		{
			location lLoc = CSLDataArray_CycleLocation(oBC, sArmy + ACL_TRGT);
			lLoc = CSLGetOffsetLocation(lLoc, 0.0f, 0.0f, -8.0f);
			lLoc = CSLGetDeviatedLocation(lLoc);
			object oFOW = CreateObject(iTyp, VFX_SMOKE, lLoc, FALSE, VFX_SMOKE);
			CSLDataArray_PushObject(oBC, BCO_BFOW, oFOW);
		}
	}
}
// Remove Fog of War Effect
void RemoveFogOfWar()
{
	object oBC  = GetBattleControl();
	CSLDataArray_DeleteObject(oBC, BCO_BFOW, TRUE);
}
// -------------------------------------------------------

// Start Battle Sound Effect
void StartBattleSFX()
{
	object oBC = GetBattleControl();
	object oFX = GetNearestObjectByTag(SFX_BTTL, oBC); 
	SoundObjectPlay(oFX);
}
// Stop Battle Sound Effect
void StopBattleSFX()
{
	object oBC = GetBattleControl();
	object oFX = GetNearestObjectByTag(SFX_BTTL, oBC); 
	SoundObjectStop(oFX);
}
// -------------------------------------------------------

// Reset KO Count
void ResetKOCount()
{
	object oFM = GetFirstFactionMember(GetFirstPC(), FALSE);
	while( GetIsObjectValid(oFM) ){
		if( GetIsPC(oFM) || GetIsOwnedByPlayer(oFM) || GetIsRosterMember(oFM) )
		{
			SetLocalInt(oFM, PCI_KCNT, 0);
		}
		oFM = GetNextFactionMember(GetFirstPC(), FALSE);
	}
}
// =================================================================
// Army Cover Fire Settings (Public)
// =================================================================

// Setup Cover Fire
void SetCoverFire(string sName, int iF, int iN, int iD, int iDC)
{
	object oBC = GetBattleControl();
	SetLocalInt(oBC, sName + ACI_FQN, iF);
	SetLocalInt(oBC, sName + ACI_CDN, iF);
	SetLocalInt(oBC, sName + ACI_QTY, iN);
	SetLocalInt(oBC, sName + ACI_DMG, iD);
	SetLocalInt(oBC, sName + ACI_SDC, iDC);
}

// Delete Cover Fire
void DeleteCoverFire(string sName)
{
	object oBC = GetBattleControl();
	DeleteLocalInt(oBC, sName + ACI_FQN);
	DeleteLocalInt(oBC, sName + ACI_CDN);
	DeleteLocalInt(oBC, sName + ACI_QTY);
	DeleteLocalInt(oBC, sName + ACI_DMG);
	DeleteLocalInt(oBC, sName + ACI_SDC);
}
// Get Is Cover Fire set
int GetIsCoverFireSet(string sName)
{
	object oBC = GetBattleControl();
	return GetLocalInt(oBC, sName + ACI_QTY) > 0;
}
// -------------------------------------------------------

// Setup Barrage for sArmy
// iF  : Cool Down time (in rounds)
// iN  : No of arrows
// iD  : Damage (how many d6)
// iDC : Save DC
void SetBarrage(string sArmy, int iF=3, int iN=20, int iD=1, int iDC=10)
{
	SetCoverFire(sArmy + ACS_BRR, iF, iN, iD, iDC);
}
// Delete Barrage for sArmy
void DeleteBarrage(string sArmy)
{
	DeleteCoverFire(sArmy + ACS_BRR);
}
// Get Is Barrage set for sArmy
int GetIsBarrageSet(string sArmy)
{
	return GetIsCoverFireSet(sArmy + ACS_BRR);
}
// -------------------------------------------------------

// Setup Catapult for sArmy
// iF  : Cool Down time (in rounds)
// iN  : No of projectile
// iD  : Damage (how many d6)
// iDC : Save DC
void SetCatapult(string sArmy, int iF=5, int iN=4, int iD=5, int iDC=10)
{
	SetCoverFire(sArmy + ACS_CTP, iF, iN, iD, iDC);
}
// Delete Catapult for sArmy
void DeleteCatapult(string sArmy)
{
	DeleteCoverFire(sArmy + ACS_CTP);
}
// Get Is Catapult set for sArmy
int GetIsCatapultSet(string sArmy)
{
	return GetIsCoverFireSet(sArmy + ACS_CTP);
}
// =================================================================
// Army Setting (Public)
// =================================================================

// Destroy sArmy's existing troops
void DestroyTroop(string sArmy)
{
	object oBC  = GetBattleControl();
	int    iN   = 1;
	int    iTyp = OBJECT_TYPE_CREATURE;
	object oTrg = GetNearestObject(iTyp, oBC, iN);
	while( GetIsObjectValid(oTrg) ){
		if( !GetIsOwnedByPlayer(oTrg) && !GetIsPC(oTrg) )
		{
			if( GetLocalString(oTrg, BSS_ARMY) == sArmy )
			{
				CSLMyDebug("Destroy "+GetTag(oTrg), sArmy);
				DestroyObject(oTrg);
			}
		}
		iN ++;
		oTrg = GetNearestObject(iTyp, oBC, iN);
	}
}
// Delete an army
// sArmy 	: Army Name
// iDestroy : Destroy existing troops if true
void DeleteArmy(string sArmy, int iDestroy=TRUE)
{
	object oBC = GetBattleControl();
	int    iID = CSLDataArray_FindString(oBC, BCS_BARMY, sArmy);
	// Unregister Army
	if( iID >= 0 ){ CSLDataArray_RemoveString(oBC, BCS_BARMY, iID); }
	// Destroy soldiers
	if( iDestroy ){ DestroyTroop(sArmy); }
	// Delete Class data
	CSLDataArray_DeleteObject(oBC, sArmy + ATO_TMPLT, TRUE);
	CSLDataArray_DeleteString(oBC, sArmy + ATS_TMPLT);
	CSLDataArray_DeleteInt(oBC, sArmy + ATI_RSRV);
	CSLDataArray_DeleteInt(oBC, sArmy + ATI_PRCNT);
	CSLDataArray_DeleteInt(oBC, sArmy + ATI_LVADJ);
	// Delete Statistical data
	CSLDataArray_DeleteObject(oBC, sArmy + AMO_ENTRY);
	DeleteLocalString(oBC, sArmy + AMS_BSREF);
	DeleteLocalInt(oBC, sArmy + AMI_FCTN);
	DeleteLocalInt(oBC, sArmy + AMI_SLMT);
	DeleteLocalInt(oBC, sArmy + AMI_SCNT);
	DeleteLocalInt(oBC, sArmy + AMI_DCNT);
	DeleteLocalInt(oBC, sArmy + AMI_TTL);
	DeleteLocalInt(oBC, sArmy + AMI_RSRV);
	// Delete Cover Fire Data
	CSLDataArray_DeleteLocation(oBC, sArmy + ACL_LNCH);
	CSLDataArray_DeleteLocation(oBC, sArmy + ACL_TRGT);
	DeleteBarrage(sArmy);
	DeleteCatapult(sArmy);
	CSLMyDebug("Destroyed", sArmy);
}
// -------------------------------------------------------

// Create a new army (Overwrites army with the same name)
//
// sArmy : Army Name
// iFct  : which faction the army belongs to
// iRsrv : how many troops the army has in total
// iLmt	 : how many troops the army can command at one time
//
// e.g. CreateArmy("Enemy", 0, 100, 10); 
// creates an Enemy army with 100 men and attacks in waves of 10
//
// note: must call AddSoldier afterward to add soldier type
// to the army. 
void CreateArmy(string sArmy, int iFct, int iRsrv, int iLmt)
{
	object oBC = GetBattleControl();
	DeleteArmy(sArmy);
	CSLDataArray_PushString(oBC, BCS_BARMY, sArmy);
	SetLocalInt(oBC, sArmy + AMI_FCTN, iFct);
	SetLocalInt(oBC, sArmy + AMI_TTL , iRsrv);
	SetLocalInt(oBC, sArmy + AMI_SLMT, iLmt);
	SetLocalInt(oBC, sArmy + AMI_RSRV, 0);
	SetLocalInt(oBC, sArmy + AMI_DCNT, 0);
	SetLocalInt(oBC, sArmy + AMI_SCNT, 0);
	CSLMyDebug("Created", sArmy);
}
// Add a soldier type to the army
//
// sArmy  : Army Name
// sRes   : ResRef for the type
// iPrcnt : The percentage of this type in the army 
//          If total percentage (include previously added type)
//          exceeds 100, the excess will be ignored
// iLvAdj : Level adjustment (relative to PC), -1 for no adjustment
//
// e.g. AddSolider("Enemy", "c_skeleton", 50); 
//      AddSolider("Enemy", "c_zombie", 55); 
// makes the Enemy Army consists of skeletons and zombies (50/50)
// the 5% excess of zombie is ignored
void AddSoldier(string sArmy, string sRes, int iPrcnt, int iLvAdj=-1)
{
	object oBC = GetBattleControl();
	int    iRS = GetLocalInt(oBC, sArmy + AMI_RSRV);
	int    iTT = GetLocalInt(oBC, sArmy + AMI_TTL);
	int    iP  = (iTT * iPrcnt/100); // calculate allocation
	int    iQ  = (iTT - iRS);        // calculate reserve left
	// exceed reserve, use what's left
	if( iP > iQ ){ iP = iQ; }
	// if army not exist or reserve out, iP = 0, nothing happens
	if( iP > 0 )
	{
		CSLDataArray_PushString(oBC, sArmy + ATS_TMPLT , sRes);
		CSLDataArray_PushInt(oBC, sArmy + ATI_RSRV , iP);
		CSLDataArray_PushInt(oBC, sArmy + ATI_LVADJ, iLvAdj);
		CSLDataArray_PushInt(oBC, sArmy + ATI_PRCNT, iPrcnt);
		CSLIncrementLocalInt(oBC, sArmy + AMI_RSRV, iP);
		CSLMyDebug("Adds "+ IntToString(iP) +" "+ sRes, sArmy);
	}
}
// -------------------------------------------------------

// sArmy  : Army Name
// sRes   : ResRef for the Battle Standard
void SetBattleStandard(string sArmy, string sRes)
{
	object oBC = GetBattleControl();
	SetLocalString(oBC, sArmy + AMS_BSREF, sRes);
}
// -------------------------------------------------------

// Reinforce an army (divided among soldier types)
// sArmy : Army Name
// iAmt  : Reinforcement
void ReinforceArmy(string sArmy, int iAmt)
{
	object oBC = GetBattleControl();
	int    iTP = CSLDataArray_LengthString(oBC, sArmy + ATS_TMPLT);
	int    iQ  = iAmt;
	int    iN;
	CSLMyDebugSeperator();
	CSLMyDebug("Reinforced by " + IntToString(iAmt), sArmy);
	// Go thru all known types and allocate
	for( iN=0; iN<iTP; iN++ )
	{
		string sRF = CSLDataArray_GetString(oBC, sArmy + ATS_TMPLT, iN);
		int    iRS = CSLDataArray_GetInt(oBC, sArmy + ATI_RSRV, iN);
		int    iPC = CSLDataArray_GetInt(oBC, sArmy + ATI_PRCNT, iN);
		int    iP  = (iAmt * iPC/100);
		if( iP > iQ ){ iP = iQ; }
		CSLDataArray_SetInt(oBC, sArmy + ATI_RSRV, iN, (iRS+iP));
		CSLIncrementLocalInt(oBC, sArmy + AMI_RSRV, iP);
		iQ -= iP;
		CSLMyDebug(IntToString(iP)+ " allocated to " + sRF, sArmy);
	}
	CSLIncrementLocalInt(oBC, sArmy + AMI_TTL, iAmt);
}
// -------------------------------------------------------

// Print army statistics
void ShowArmyStat(string sArmy, object oPC)
{
	object oBC = GetBattleControl();
	string sST = "";
	int    iFC = GetLocalInt(oBC, sArmy + AMI_FCTN);
	int    iSL = GetLocalInt(oBC, sArmy + AMI_SLMT);
	int    iSC = GetLocalInt(oBC, sArmy + AMI_SCNT);
	int    iSD = GetLocalInt(oBC, sArmy + AMI_DCNT);
	int    iTT = GetLocalInt(oBC, sArmy + AMI_TTL);
	int    iRS = GetLocalInt(oBC, sArmy + AMI_RSRV);
	int    iTP = CSLDataArray_LengthString(oBC, sArmy + ATS_TMPLT);
	int    iRM = iRS + iSC;
	int    iN;

	sST += "\n"+ CSLBoldText(CSLColorText(sArmy,COLOR_YELLOW_DARK)) +"\n\n";
	sST += "Faction : " +CSLGetStandardFactionName(iFC)+"\n";
	sST += "Troops : " +IntToString(iRM) +"/"+ IntToString(iTT)+"\n";
	sST += "Casualties : " +IntToString(iSD)+"\n";
	sST += "Deployed : " +IntToString(iSC)+"/"+ IntToString(iSL)+"\n\n";
	sST += "Reserves : " +IntToString(iRS)+"\n";
	for( iN=0; iN<iTP; iN++ ){
		string sCRF = CSLDataArray_GetString(oBC, sArmy + ATS_TMPLT, iN);
		int    iCRS = CSLDataArray_GetInt(oBC, sArmy + ATI_RSRV, iN);
		sST += sCRF +" : "+ IntToString(iCRS) +"\n";
	}
	CSLMessage_ShowReport(oPC, sST, "");
}
// -------------------------------------------------------

// Get is Army Annihilated
// Return TRUE if Annihilated
int GetIsArmyAnnihilated(string sArmy)
{
	object oBC = GetBattleControl();
	int    iRS = GetLocalInt(oBC, sArmy + AMI_RSRV);
	int    iSC = GetLocalInt(oBC, sArmy + AMI_SCNT);
	return (iRS + iSC) <= 0;
}
// Is all armies of factional reputation Annihilated
// oPC Annihilated
// oPC  : PC
// iRpt : REPUTATION_TYPE_*
int GetIsAnnihilated(object oPC, int iRpt)
{
	object oBC = GetBattleControl();
	object oPC = GetFirstPC(FALSE);
	int    iA  = CSLDataArray_LengthString(oBC, BCS_BARMY);
	int    iN;
	for( iN=0; iN<iA; iN++ ){
		string sArmy = CSLDataArray_GetString(oBC, BCS_BARMY, iN);
		int    iFct  = GetLocalInt(oBC, sArmy + AMI_FCTN);
		if( CSLGetFactionDisposition(iFct, oPC) == iRpt ){
			if( !GetIsArmyAnnihilated(sArmy) ){ return FALSE; }
		}
	}
	return TRUE;
}
// =================================================================
// Battle Flow Control (Public)
// =================================================================

// Is Battle Active?
int GetIsBattleActive()
{
	return GetLocalInt(GetBattleControl(), BCI_BACTV);
}
// Set Battle Active/Inactive
void SetBattleActive(int iBol)
{
	object oBC = GetBattleControl();
	if( iBol )
	{
		ResetKOCount();
		CreateFogOfWar();
		StartBattleSFX();
	}
	else
	{
		RemoveFogOfWar();
		StopBattleSFX();
	}
	SetLocalInt(oBC, BCI_BACTV, iBol);
}
// -------------------------------------------------------

void DEXBattle_AdjustReputationFactionWide( object oFactionRep1, object oFactionRep2 )
{
	// need to get the
	AdjustReputation(oFactionRep1, oFactionRep2, -100); // hostile
	//ClearPersonalReputationWithFaction(oFactionRep1, oFactionRep); // neutral
	//AdjustReputation(oFactionRep1, oFactionRep2, +100); // Friendly
}

void DEXBattle_AdjustReputationIndivdual( object oPC, object oFactionRep )
{
	AdjustReputation(oPC, oFactionRep, -100); // hostile
	//ClearPersonalReputation(oPC, oFactionRep); // neutral
	//AdjustReputation(oPC, oFactionRep, +100); // Friendly
}

void DEXBattle_setupReuptation()
{
	object oBC = GetObjectByTag( PLC_BC );
	if ( oBC == OBJECT_INVALID )
	{ 
		return;
	}
	
	object oFactionRepArmy1;
	object oFactionRepArmy2;
	object oFactionRepArmy3;
	object oFactionRepArmy4;
	object oFactionRepArmy5;
	
	string sArmy1 = CSLDataArray_GetString(oBC, BCS_BARMY, 0);
	if ( sArmy1 != "" )
	{
		oFactionRepArmy1 = CSLDataArray_GetObject(oBC, sArmy1 + ATO_TMPLT, 0); // change all these to my custom handlers below
	}
	string sArmy2 = CSLDataArray_GetString(oBC, BCS_BARMY, 1);
	if ( sArmy2 != "" )
	{
		oFactionRepArmy2 = CSLDataArray_GetObject(oBC, sArmy2 + ATO_TMPLT, 0);
	}
	string sArmy3 = CSLDataArray_GetString(oBC, BCS_BARMY, 2);
	if ( sArmy3 != "" )
	{
		oFactionRepArmy3 = CSLDataArray_GetObject(oBC, sArmy3 + ATO_TMPLT, 0);
	}
	string sArmy4 = CSLDataArray_GetString(oBC, BCS_BARMY, 3);
	if ( sArmy4 != "" )
	{
		oFactionRepArmy4 = CSLDataArray_GetObject(oBC, sArmy4 + ATO_TMPLT, 0);
	}
	string sArmy5 = CSLDataArray_GetString(oBC, BCS_BARMY, 4);
	if ( sArmy5 != "" )
	{
		oFactionRepArmy5 = CSLDataArray_GetObject(oBC, sArmy5 + ATO_TMPLT, 0);
	}

	//CSLMessageSendToAllPC("Rep Changing for " + sArmy1 + sArmy2 + sArmy3 + sArmy4 + sArmy5 );
	
	// make all armies dislike each other
	//Army 1
	if ( sArmy1 != "" )
	{
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy1, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy1, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy1, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy1, oFactionRepArmy5 );
		}
	}

	//Army 2
	if ( sArmy2 != "" )
	{
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy2, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy2, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy2, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy2, oFactionRepArmy5 );
		}
	}
	
	//Army 3
	if ( sArmy3 != "" )
	{
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy3, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy3, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy3, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy3, oFactionRepArmy5 );
		}
	}
	
	//Army 4
	if ( sArmy4 != "" )
	{
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy4, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy4, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy4, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy4, oFactionRepArmy5 );
		}
	}
	
	//Army 5
	if ( sArmy5 != "" )
	{
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy5, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy5, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy5, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationFactionWide(oFactionRepArmy5, oFactionRepArmy5 );
		}
	}
	
	// now loop thru the pc's and do the same so they each relate to the armies based on the above
	
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{
		if ( sArmy1 != "" )
		{
			DEXBattle_AdjustReputationIndivdual(oFactionRepArmy5, oFactionRepArmy5 );
		}
		if ( sArmy2 != "" )
		{
			DEXBattle_AdjustReputationIndivdual(oFactionRepArmy5, oFactionRepArmy2 );
		}
		if ( sArmy3 != "" )
		{
			DEXBattle_AdjustReputationIndivdual(oFactionRepArmy5, oFactionRepArmy3 );
		}
		if ( sArmy4 != "" )
		{
			DEXBattle_AdjustReputationIndivdual(oFactionRepArmy5, oFactionRepArmy4 );
		}
		if ( sArmy5 != "" )
		{
			DEXBattle_AdjustReputationIndivdual(oFactionRepArmy5, oFactionRepArmy5 );
		}
		oPC = GetNextPC();
	}
}


// Aborts the battle
void AbortBattle()
{
	if( !GetIsBattleActive() )
	{
		return;
	}
	
	object oBC = GetBattleControl();
	// Stop Battle
	CSLMyDebugSeperator();
	SetBattleActive(FALSE);
	SetLocalInt(GetModule(), OFI_NTRSR, FALSE);
	// Destroy all armies
	while( CSLDataArray_LengthString(oBC, BCS_BARMY) > 0 )
	{
		DeleteArmy(CSLDataArray_GetString(oBC, BCS_BARMY, 0), TRUE);
	}
	CSLMessageSendToAllPC("Battle Aborted");
}


// Begins the battle
// sVD : Vicotry/Defeat script (Default will be used if empty)
void BeginBattle(string sVD="")
{
	if( GetIsBattleActive() )
	{
		return;
	}
	
	object oBC = GetBattleControl();
	// Initiate Armies
	int iA = CSLDataArray_LengthString(oBC, BCS_BARMY);
	int iN;
	for( iN=0; iN<iA; iN++ )
	{
		string sArmy = CSLDataArray_GetString(oBC, BCS_BARMY, iN);
		CSLMyDebugSeperator();
		AssignCommand( oBC, MapAttackRoute(sArmy) );
		AssignCommand( oBC, SetupLaunchPoint(sArmy) );
		AssignCommand( oBC, CreateTemplate(sArmy) );
	}
	AssignCommand( oBC, DEXBattle_setupReuptation() );
	
	// Start Battle
	CSLMyDebugSeperator();
	SetLocalString(oBC, BCS_BVCDF, sVD);
	SetLocalInt(GetModule(), OFI_NTRSR, TRUE);
	SetBattleActive( TRUE );
	CSLMessageSendToAllPC("Battle Begins");
}




	

// -------------------------------------------------------

// Show the battle's statistics
// sTtl : Title
// sSrc : script to run when ok is clicked
void ShowBattleStat(object oPC, string sTtl="", string sSrc="")
{
	object oBC = GetBattleControl();
	object oFM = GetFirstFactionMember(oPC, FALSE);
	int    iA  = CSLDataArray_LengthString(oBC, BCS_BARMY);
	string sST = "";
	int    iN;
	if( sTtl != "" ){ 
		sST += CSLBoldText(CSLColorText(sTtl, COLOR_YELLOW_DARK))+"\n\n"; 
	}
	if( iA > 0 )
	{
		sST += CSLBoldText(CSLColorText("Army Statistics", COLOR_ORANGE))+"\n\n"; 
	}
	for( iN=0; iN<iA; iN++ )
	{
		string sArmy = CSLDataArray_GetString(oBC, BCS_BARMY, iN);
		int    iFC   = GetLocalInt(oBC, sArmy + AMI_FCTN);
		int    iTT   = GetLocalInt(oBC, sArmy + AMI_TTL);
		int    iSD   = GetLocalInt(oBC, sArmy + AMI_DCNT);
		sST += CSLBoldText(sArmy) +"\n";
		sST += "Faction : "+ CSLGetStandardFactionName(iFC) +"\n";
		sST += "Troops : "+ IntToString(iTT) +"\n";
		sST += "Casualties : "+ IntToString(iSD) +"\n\n";
	}
	if( GetIsObjectValid(oFM) )
	{
		sST += CSLBoldText(CSLColorText("Personal Statistics", COLOR_ORANGE))+"\n\n"; 
	}
	while( GetIsObjectValid(oFM) )
	{
		sST += CSLBoldText(GetName(oFM))+"\n";
		sST += "Kills : "+ IntToString(GetLocalInt(oFM, PCI_KCNT)) +"\n";
		sST += "Total : "+ IntToString(GetLocalInt(oFM, PCI_KTTL)) +"\n\n";
		oFM = GetNextFactionMember(oPC, FALSE);
	}
	CSLMessage_ShowReport(oPC, sST, sSrc);
}



// Get a Spawn Probablity Test Result
// sArmy : Army
// iN    : Soldier Type ID
// iTR   : total reserve left
// iRD   : P = Type Reserve/ Total Reserve if true
//         P = 1 for Type Reserve > 0 if false
// Return TRUE if passed the Probablity Test
int GetSpawnProbablity(string sArmy, int iN, int iTR, int iRD){
	object oBC = GetBattleControl();
	int    iRS = CSLDataArray_GetInt(oBC, sArmy + ATI_RSRV, iN);
	if( iRD ){ 
		return (Random(iTR)+1 <= iRS ); 
	}
	return (iRS > 0);
}
// Spawns a Soldier
// sArmy : Army
// iN    : Soldier Type ID
// iFC   : Faction to join
void SpawnSoldier(string sArmy, int iN, string sFG=""){
	object oBC = GetBattleControl();
	object oBP = CSLDataArray_GetObject(oBC, sArmy + ATO_TMPLT, iN);
	int    iRS = CSLDataArray_GetInt(oBC, sArmy + ATI_RSRV, iN);
	string sTG = GetTag(oBP) +"_"+ IntToString(iRS);
	object oEP = CSLDataArray_CycleObject(oBC, sArmy + AMO_ENTRY);
	object oBS = CopyObject(oBP, GetLocation(oEP), OBJECT_INVALID, sTG);
	int    iAR = GetLocalInt(oEP, BSI_ROUTE);
	if( !GetIsObjectValid(oBS) )
	{
		// CopyObject does not return the new object properly after 
		// I installed MOTB. This is plan B.
		oBS = GetNearestObjectByTag(sTG, oEP);
	}
	// Update statistics
	CSLDataArray_SetInt(oBC, sArmy + ATI_RSRV, iN, (iRS-1) ); //Type Reserve
	CSLIncrementLocalInt(oBC, sArmy + AMI_RSRV, -1);           //Total Reserve
	CSLIncrementLocalInt(oBC, sArmy + AMI_SCNT, 1);            //Spawn Count
	// Set Up soldier
	SetLocalInt(oBS, BSI_ARNXT, 0);
	SetLocalInt(oBS, BSI_ROUTE, iAR);
	SetLocalString(oBS, BSS_ARMY, sArmy);
	SetLocalString(oBS, BSS_HBS, GetEventHandler(oBS, CREATURE_SCRIPT_ON_HEARTBEAT));
	SetLocalString(oBS, BSS_ODS, GetEventHandler(oBS, CREATURE_SCRIPT_ON_DEATH));
	SetEventHandler(oBS, CREATURE_SCRIPT_ON_HEARTBEAT, SCR_CR_HB);
	SetEventHandler(oBS, CREATURE_SCRIPT_ON_DEATH, SCR_CR_OD);
	if( sFG != "" )
	{
		object oFG = CreateItemOnObject(sFG, oBS);
		SetDroppableFlag(oFG, FALSE);
		FeatAdd(oBS, FEAT_MONKEY_GRIP, FALSE);
		AssignCommand(oBS, ActionEquipItem(oFG, INVENTORY_SLOT_LEFTHAND));
	}
	CSLMyDebug("Spawn "+ sTG, sArmy);
	// Remove protection
	DelayCommand(0.5f, ExecuteScript(SCR_CR_HB, oBS));
	DelayCommand(1.0f, SetImmortal(oBS, FALSE));
	DelayCommand(1.0f, SetPlotFlag(oBS, FALSE));
	DelayCommand(1.5f, SetScriptHidden(oBS, FALSE));
}
// -------------------------------------------------------
// Spawn a Platoon for the army
// Spawn 0-5 soldiers per call depends on availability
void SpawnPlatoon(string sArmy){
	object oBC = GetBattleControl();
	string sFG = GetLocalString(oBC, sArmy + AMS_BSREF);
	int    iSL = GetLocalInt(oBC, sArmy + AMI_SLMT);
	int    iSC = GetLocalInt(oBC, sArmy + AMI_SCNT);
	int    iTR = GetLocalInt(oBC, sArmy + AMI_RSRV);
	int    iTP = CSLDataArray_LengthString(oBC, sArmy + ATS_TMPLT);
	int    iPL = 5; //platoon limit
	int    iCL = 3; //cycle limit
	int    iN  = 0;
	// Cycle all soldier types and spawn randomly
	while( (iTR>0) && (iSC<iSL) && (iPL>0) ){
		if( GetSpawnProbablity(sArmy, iN, iTR, (iCL>0)) ){ 
			if( iTR%10 == 0 ){
				SpawnSoldier(sArmy, iN, sFG);
			}else{
				SpawnSoldier(sArmy, iN);
			}
			iSC ++;
			iTR --;
			iPL --;
		}
		iN ++;
		//One cycle passed
		if( iN >= iTP ){
			iCL --; 
			iN = 0;
		}
	}
}
// =================================================================

// Apply Catapult Effect
// lLoc : Location
// iFac : Faction of Catapult (will not harm friendly)
// iD   : Damage Dices (d6)
// iDC  : Save DC
void ApplyCatapultEffect(location lLoc, int iFac, int iD, int iDC)
{
	int    iN   = 1;
	int    iDF  = iD/4;
	int    iDB  = iDF*3;
	int    iTyp = OBJECT_TYPE_CREATURE;
	object oTrg = GetNearestObjectToLocation(iTyp, lLoc, iN);
	float  fDis = GetDistanceBetweenLocations(lLoc, GetLocation(oTrg));
	float  fRad = 18.0f;
	effect eKnc = EffectKnockdown();
	// Go trhu all creature within damage radius
	while( GetIsObjectValid(oTrg) && (fDis < fRad) )
	{
		if( CSLGetFactionDisposition(iFac, oTrg) == REPUTATION_TYPE_ENEMY ){
			// Allows a relfex save
			if( ReflexSave(oTrg, iDC) == 0 ){
				effect eDamF = EffectDamage(d6(iDF), DAMAGE_TYPE_FIRE);
				effect eDamB = EffectDamage(d6(iDB), DAMAGE_TYPE_BLUDGEONING);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamF, oTrg);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamB, oTrg);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnc, oTrg, 4.0f);
				if ( !GetIsImmune( oTrg, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oTrg, "CSL_KNOCKDOWN",  4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
			}
		}
		iN ++;
		oTrg = GetNearestObjectToLocation(iTyp, lLoc, iN);
		fDis = GetDistanceBetweenLocations(lLoc, GetLocation(oTrg));
    }
}
// Fire a Catapult
// lSrc : Source Location
// lTrg : Target Location
// iFac : Faction of Catapult (will not harm friendly)
// iD   : Damage Dices (d6)
// iDC  : Save DC
void FireCatapult(location lSrc, location lTrg, int iFac, int iD, int iDC){
	int	   iSpl = SPELL_CATAPULT;
	int    iMtm = METAMAGIC_ANY;
	int	   iPth = PROJECTILE_PATH_TYPE_BALLISTIC_THROWN;
	object oInv = OBJECT_INVALID;
	object oTrg = CSLGetRandomHostileByDisposition(lTrg, iFac);
	float  fTrv = GetProjectileTravelTime(lSrc, lTrg, iPth);
	// Create a visual effect (no damage)
	// Apply the effect when the projectile hit the ground
	SpawnSpellProjectile(oInv, oTrg, lSrc, lTrg, iSpl, iPth);
	DelayCommand(fTrv, ApplyCatapultEffect(lTrg, iFac, iD, iDC));
}
// Fire an Arrow
// lSrc : Source Location
// lTrg : Target Location
// iFac : Faction of Catapult (will not harm friendly)
// iD   : Damage Dices (d6)
// iDC  : Save DC
// iF   : Flame Arrow if true
void FireArrow(location lSrc, location lTrg, int iFac, int iD, int iDC, int iF=FALSE){
	int	   iBIt = BASE_ITEM_LONGBOW;
	int	   iTyp = DAMAGE_TYPE_PIERCING;
	int	   iAtt = OVERRIDE_ATTACK_RESULT_MISS;
	int	   iPth = PROJECTILE_PATH_TYPE_BALLISTIC_LAUNCHED;
	object oInv = OBJECT_INVALID;
	object oTrg = CSLGetRandomHostileByDisposition(lTrg, iFac);
	if( iF ){ iTyp = DAMAGE_TYPE_FIRE; }
	if( GetIsObjectValid(oTrg) ){
		lTrg = GetLocation(oTrg);
		// Allows a relfex save
		if( ReflexSave(oTrg, iDC) == 0 ){
			effect eDam = EffectDamage(d6(iD), iTyp);
			float  fTrv = GetProjectileTravelTime(lSrc, lTrg, iPth);
			iAtt = OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL;
			DelayCommand(fTrv, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTrg));
		}
	}
	SpawnItemProjectile(oInv, oTrg, lSrc, lTrg, iBIt, iPth, iAtt, iTyp);
}
// Launch Cover Fire
// Nothing happens if cover fire is not set
// sArmy : Army
// sType : Cover Fire Type
void LaunchCoverFire(string sArmy, string sType){
	if( !GetIsCoverFireSet(sArmy + sType) ){ return; }
	object oBC = GetBattleControl();
	string sVN = sArmy + sType;
	int    iFC = GetLocalInt(oBC, sArmy + AMI_FCTN);
	int    iDC = GetLocalInt(oBC, sVN + ACI_SDC);
	int    iFQ = GetLocalInt(oBC, sVN + ACI_FQN);
	int    iD  = GetLocalInt(oBC, sVN + ACI_DMG);
	int    iN  = GetLocalInt(oBC, sVN + ACI_QTY);
	if( GetLocalInt(oBC, sVN + ACI_CDN) > 0 ){ 
		// Cool Down
		CSLIncrementLocalInt(oBC, sVN + ACI_CDN, -1);
		return;
	}else{
		// Reset Cool Down and launch
		SetLocalInt(oBC, sVN + ACI_CDN, iFQ);
		while( iN > 0 ){
			location lSrc = CSLDataArray_CycleLocation(oBC, sArmy + ACL_LNCH);
			location lTrg = CSLDataArray_CycleLocation(oBC, sArmy + ACL_TRGT);
			if( sType == ACS_BRR ){ FireArrow(lSrc, lTrg, iFC, iD, iDC); }
			if( sType == ACS_CTP ){ FireCatapult(lSrc, lTrg, iFC, iD, iDC); }
			iN --;
		}
	}
}
// =================================================================
// Battle Control Heart Beat
void BattleControlHB()
{
	if( !GetIsBattleActive() ){ return; }
	
	object oBC = OBJECT_SELF;
	string sVD = GetLocalString(oBC, BCS_BVCDF);
	int    iA  = CSLDataArray_LengthString(oBC, BCS_BARMY);
	int    iN;
	
	int iHeartbeatCounter = GetLocalInt( oBC, "SC_HB_Counter");
	if ( iHeartbeatCounter < 0 )
	{
		iHeartbeatCounter = 0;
	}
	//iHeartbeatCounter  = CSLGetMax( iHeartbeatCounter , 0 );

	
	// Do the standard stuff for all armies
	CSLMyDebugSeperator();
	CSLMyDebug("Upkeep", "Battle Control");
	//for( iN=0; iN<iA; iN++ )
	//{
		string sArmy = CSLDataArray_GetString(oBC, BCS_BARMY, iHeartbeatCounter);
		SpawnPlatoon(sArmy);
		LaunchCoverFire(sArmy, ACS_BRR); //Barrage
		LaunchCoverFire(sArmy, ACS_CTP); //Catapult
	//}
	
	
	iHeartbeatCounter += 1;	
	if ( iHeartbeatCounter >= iA )
	{
		iHeartbeatCounter = 0;
	}
	SetLocalInt( oBC, "SC_HB_Counter", iHeartbeatCounter  );
	
	// Check for victory/defeat
	if( sVD != "" )
	{
		// Custom script defined
		ExecuteScript(sVD, oBC);
	}else{
		// Run default script
		ExecuteScript(SCR_EX_VD, oBC);
	}
}
// =================================================================
// Battle Spawn Events
// =================================================================

// Tell Battle control I am dead
void ReportCasualty(object oBS = OBJECT_SELF)
{
	object oBC = GetBattleControl();
	string sAR = GetLocalString(oBS, BSS_ARMY);
	//Update Statistics
	CSLIncrementLocalInt(oBC, sAR + AMI_SCNT, -1); //Spawn Count
	CSLIncrementLocalInt(oBC, sAR + AMI_DCNT, 1);  //Death Count
	CSLMyDebug(GetTag(oBS) +" Despawn", sAR);
}

// Increase killer's KO Count, use in On Death Script
void IncKOCount(object oBS = OBJECT_SELF)
{
	object oKiller = GetLastKiller();
	if( GetIsObjectValid(GetMaster(oKiller)) ){
		//Add associates' kills to master's count
		oKiller = GetMaster(oKiller);
	}
	if( GetIsPC(oKiller)
	||  GetIsOwnedByPlayer(oKiller)
	||  GetIsRosterMember(oKiller) )
	{
		int    iKCnt = CSLIncrementLocalInt(oKiller, PCI_KCNT, 1);
		int    iKTtl = CSLIncrementLocalInt(oKiller, PCI_KTTL, 1);
		//int    iTVol = TALKVOLUME_SHOUT;
		string sBCry = IntToString(iKCnt)+" !";
		//AssignCommand(oKiller, SpeakString(sBCry, iTVol) );
		SendChatMessage( oKiller, OBJECT_INVALID, CHAT_MODE_SHOUT, sBCry, FALSE);
	}
}

// Attack nearest hostile or follow attack route
void BattleCharge(object oBS = OBJECT_SELF)
{
	if( GetIsInCombat(oBS) ){ return; }
	
	int    iAR = GetLocalInt(oBS, BSI_ROUTE);
	int    iNX = GetLocalInt(oBS, BSI_ARNXT);
	string sAR = GetLocalString(oBS, BSS_ARMY);
	string sTG = AttackPointTag(sAR, iAR, iNX);
	object oAR = GetNearestObjectByTag(sTG, oBS);
	object oHT = CSLGetNearestHostile(oBS);
	
	// Attack hostile
	if( GetIsObjectValid(oHT) ){
		float fAR = GetDistanceToObject(oAR)*6;
		float fHT = GetDistanceToObject(oHT);
		if( fHT < fAR ){
			AssignCommand(oBS, ActionAttack(oHT) );
			return;
		}
	}
	// Follow Attack Route
	if( GetIsObjectValid(oAR) ){
		if( CSLMoveToObject(oBS, oAR, TRUE) ){
			iNX ++;
			sTG = AttackPointTag(sAR, iAR, iNX);
			oAR = GetNearestObjectByTag(sTG, oBS);
			if( GetIsObjectValid(oAR) ){
				// Move to next stage of attack route
				SetLocalInt(oBS, BSI_ARNXT, iNX);
				CSLMoveToObject(oBS, oAR, TRUE);
			}
		}
	}
}
// =================================================================
void BattleSpawnHB()
{
	object oBS = OBJECT_SELF;
	DelayCommand( 0.1,BattleCharge(oBS) );
	// Execute original heartbeat
	ExecuteScript(GetLocalString(oBS, BSS_HBS), oBS);
}

void BattleSpawnOD()
{
	object oBS = OBJECT_SELF;
	ReportCasualty(oBS);
	IncKOCount(oBS);
	// Execute original on death
	ExecuteScript(GetLocalString(oBS, BSS_ODS), oBS);
}