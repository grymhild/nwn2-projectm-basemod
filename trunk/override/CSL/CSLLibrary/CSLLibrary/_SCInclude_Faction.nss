/** @file
* @brief Include File for Dex Faction System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_Items"
//#include "nw_i0_plot"
#include "_CSLCore_Nwnx"
#include "seed_db_inc"
//#include "dmfi_inc_conv"


const int STANDARD_FACTION_ARMY1 = 4;
const int STANDARD_FACTION_ARMY2 = 5;
const int STANDARD_FACTION_ARMY3 = 6;
const int STANDARD_FACTION_ARMY4 = 7;
const int STANDARD_FACTION_ARMY5 = 8;

const string SDB_FACTION_TOMETAG      = "faction_tool";
const string SDB_FACTION_TOMERESREF   = "faction_tool";
const string SDB_TOME_OPTIONS = "SDB_TOME_OPTIONS";
const string SDB_TOME_LIST    = "SDB_TOME_LIST";
const string SDB_TOME_TARGET  = "SDB_TOME_TARGET";
const string SDB_TOME_PAGE    = "SDB_TOME_PAGE";
const string SDB_TOME_SPEAKER = "SDB_TOME_SPEAKER";
const string SDB_TOME_CONFIRM = "SDB_TOME_CONFIRM";

const int SDB_FACTION_COMMANDER_CNT   = 4;

const string SDB_FAID              = "SDB_FAID";
const string SDB_FAID_LIST         = "SDB_FAID_LIST";
const string SDB_FMID              = "SDB_FMID";
const string SDB_FACTION_AURA      = "SDB_FACTION_AURA_";
const string SDB_FACTION_AURA2     = "SDB_FACTION_AURA2_";
const string SDB_FACTION_NAME      = "SDB_FACTION_NAME_";
const string SDB_FACTION_RANK      = "SDB_FACTION_RANK";
const string SDB_FACTION_ANIMOSITY = "SDB_FACTION_ANIMOSITY";
const string SDB_FACTION_WP        = "SDB_FACTION_WP_";
const string SDB_FACTION_DIPLO     = "SDB_FACTION_DIPLO_";
const string SDB_FACTION_ARTIFACT  = "SDB_FACTION_ARTIFACT";
const string SDB_FACTION_ARTICOUNT = "SDB_FACTION_ARTICOUNT";
const string SDB_FACTION_BOSSNAME  = "SDB_FACTION_BOSSNAME";
const string SDB_FACTION_BOSSSKIN  = "SDB_FACTION_BOSSSKIN";
const string SDB_FACTION_ARTINAME  = "SDB_FACTION_ARTINAME";
const string SDB_FACTION_TITHE     = "SDB_FACTION_TITHE";


const string SDB_FACTION_MEMBER    = "Member";
const string SDB_FACTION_COMMANDER = "Commander";
const string SDB_FACTION_GENERAL   = "General";

const string SDB_DIPLO_FRIEND      = "Friend";
const string SDB_DIPLO_NEUTRAL     = "Neutral";
const string SDB_DIPLO_ENEMY       = "Enemy";



/*
string SDB_FactionAdd(object oPC, object oTomer); // oTomer IS AN OFFICER INVITING oPC
void   SDB_FactionApplyAura(object oPC);
int    SDB_FactionGetAura(string sFAID, string sRank="Noob"); // GET THE FACTION AURA
string SDB_FactionGetAuraSEF(string sFAID, string sRank="Noob"); // GET THE FACTION AURA
int    SDB_FactionGetAnimosity(string sFAID);
string SDB_FactionGetCastleWP(string sFAID);
string SDB_FactionGetFirst();
string SDB_FactionGetName(string sFAID); // GET THE FACTION NAME
string SDB_FactionGetNext();
string SDB_FactionGetRank(object oPC);
int    SDB_FactionHasRank(object oPC, string sRank = SDB_FACTION_MEMBER);
int    SDB_FactionIsMember(object oPC, string sFAID = "0"); // TRUE/FALSE IF IN FACTION, OPTIONALLY CHECK FOR SPECIFIC FACTION
void   SDB_FactionLoadData(); // LOAD MASTER FACTION DATA ON MODULE
void   SDB_FactionLoadDiplomacy(object oPC);
string SDB_FactionNewGeneral(object oCommander, object oGeneral);
void   SDB_FactionOnClientEnter(object oPC);
void   SDB_FactionOnModuleLoad();
void   SDB_FactionOnPCDeath(object oPC, object oKiller);
void   SDB_FactionOnPCRespawn(object oPC);
void   SDB_FactionOnPCRest(object oPC);
void   SDB_FactionReloadData(object oPC);
string SDB_FactionRemove(object oPC, object oTomer=OBJECT_INVALID); // oTomer IS AN OFFICER REMOVING oPC, ELSE REMOVING SELF
void   SDB_FactionSetDiplomacy(string sFAID, string sVsFAID, string sDiplomacy);
string SDB_FactionSetRank(object oPC, string sRank = SDB_FACTION_MEMBER);
string SDB_GetFAID(object oPC);
string SDB_GetFMID(object oPC); // GET THE FACTION MEMBER ID
int    SDB_InList(string sList, string sValue, string sDelim = "|");
void   SDB_ProcessAnimosity(object oPC, object oMember = OBJECT_INVALID);
string SDB_FactionDMAdd(object oPC, string sFAID, string sRank);
string SDB_FactionDMRemove(object oPC);

string DEXBattle_getFactionString( string sFAID );
int DEXBattle_getFactionConstant( string sFAID );
*/

/*
string DEXBattle_getFactionString( string sFAID );
string DEXBattle_getFactionFAID( string sFAID );
int DEXBattle_getFactionConstant( string sFAID );
string SDB_GetFMID(object oPC);
string SDB_GetFAID(object oPC);
void SDB_FactionReloadData(object oPC);
int SDB_FactionIsMember(object oPC, string sFAID = "0");
string SDB_FactionGetRank(object oPC);
int SDB_FactionHasRank(object oPC, string sRank = SDB_FACTION_MEMBER);
string SDB_FactionNewGeneral(object oCommander, object oGeneral);
string SDB_FactionSetRank(object oPC, string sRank = SDB_FACTION_MEMBER);
string SDB_FactionGetName(string sFAID);
string SDB_FactionGetCastleWP(string sFAID);
int SDB_FactionGetAnimosityBit(string sFAID);
int SDB_FactionGetAura(string sFAID, string sRank);
string SDB_FactionGetAuraSEF(string sFAID, string sRank="Noob");
void SDB_FactionApplyAura(object oPC);
void SDB_FactionSetArtifact(string sFAID, string sArtiFAID);
string SDB_FactionGetArtifact(string sFAID);
string SDB_FactionGetArtifactName(string sFAID);
int SDB_FactionGetArtifactCount(string sFAID);
string SDB_FactionGetBossName(string sFAID);
int SDB_FactionGetBossSkin(string sFAID);
int SDB_FactionGetTithe(string sFAID);
void SDB_FactionLoadData();
string SDB_FactionAdd(object oPC, object oTomer);
string SDB_FactionRemove(object oPC, object oTomer=OBJECT_INVALID);
void SDB_FactionOnPCDeath(object oPC, object oKiller);
void SDB_FactionSetDiplomacy(string sFAID, string sVsFAID, string sDiplomacy);
int SDB_InList(string sList, string sValue, string sDelim = "|");
void SDB_FactionLoadDiplomacy(object oPC);
string SDB_JoinFactionParty(object oPC);
void SDB_FactionOnClientEnter(object oPC);
void SDB_FactionOnModuleLoad();
void SDB_FactionOnPCRest(object oPC);
void SDB_FactionOnPCRespawn(object oPC);
int SDB_FactionGetAnimosity(string sFAID);
void SDB_ProcessAnimosity(object oPC, object oMember = OBJECT_INVALID);
void SDB_ProcessAnimosity(object oPC, object oMember = OBJECT_INVALID);
string SDB_FactionGetFirst();
string SDB_FactionGetNext();
string SDB_FactionDMAdd(object oPC, string sFAID, string sRank);
string SDB_FactionDMRemove(object oPC);
*/

string SDB_FactionGetName(string sFAID) { // GET THE FACTION NAME
   return GetLocalString(GetModule(), SDB_FACTION_NAME + sFAID);
}

string SDB_FactionGetCastleWP(string sFAID) { // GET THE FACTION CASTLE PORT WP
   return GetLocalString(GetModule(), SDB_FACTION_WP + sFAID);
}

int SDB_FactionGetAnimosityBit(string sFAID) { // GET THE FACTION ANI BIT
   return GetLocalInt(GetModule(), SDB_FAID + "_ANIBIT_" + sFAID);
}


int SDB_FactionGetAura(string sFAID, string sRank) { // GET THE FACTION AURA
   if (sRank==SDB_FACTION_GENERAL) return GetLocalInt(GetModule(), SDB_FACTION_AURA2 + sFAID);
   return GetLocalInt(GetModule(), SDB_FACTION_AURA + sFAID);
}

string SDB_FactionGetAuraSEF(string sFAID, string sRank="Noob") { // GET THE FACTION AURA
   if (sRank==SDB_FACTION_GENERAL) return GetLocalString(GetModule(), SDB_FACTION_AURA2 + sFAID);
   return GetLocalString(GetModule(), SDB_FACTION_AURA + sFAID);
}

string SDB_GetFMID(object oPC)
{ 
	// GET THE FACTION MEMBER ID
   string sFMID = GetLocalString(oPC, SDB_FMID);
   if (sFMID=="") { // NO VARIABLE YET, CREATE IT
      sFMID = "0";
      string sFAID = "0";
      string sSQL;
      string sCKID = SDB_GetCKID(oPC); // GET CDKEY TABLE ID
      sSQL = "select fm_fmid, fm_faid, fm_rank from factionmember where fm_ckid = " + sCKID;
      CSLNWNX_SQLExecDirect(sSQL);
      if (CSLNWNX_SQLFetch()) { // IN A FACTION
         sFMID = CSLNWNX_SQLGetData(1);
         sFAID = CSLNWNX_SQLGetData(2);
         SetLocalString(oPC, SDB_FACTION_RANK, CSLNWNX_SQLGetData(3));
      }
      SetLocalString(oPC, SDB_FMID, sFMID);
      SetLocalString(oPC, SDB_FAID, sFAID);
   }
   return sFMID;
}



string SDB_GetFAID(object oPC)
{
   SDB_GetFMID(oPC); // JUST TO BE SURE FACTION DATA LOADED
   return GetLocalString(oPC, SDB_FAID);
}

// * Sets the Proper Faction Variable on the Player, implement whatever factions you are using here
void CSL_FactionCacheVariables(object oPC)
{
	string sFaction = SDB_GetFAID(oPC);
	SetLocalString( oPC, "CSL_FACTIONID", sFaction );
	sFaction = (sFaction!="0") ? SDB_FactionGetName(sFaction) : "None";
	SetLocalString( oPC, "CSL_FACTIONNAME", sFaction );
}





void SDB_FactionReloadData(object oPC) {
   DeleteLocalString(oPC, SDB_FMID);
   DeleteLocalString(oPC, SDB_FAID);
   SDB_GetFMID(oPC); // RELOAD FACTION DATA
}

string DEXBattle_getFactionString( string sFAID )
{
	if      (  sFAID == "1" ) { return "fallen"; } // Fallen Angels
	else if (  sFAID == "2" ) { return "order"; } // Order
	else if (  sFAID == "3" ) { return "tb"; } // TB
	else if (  sFAID == "4" ) { return "triad"; } // Triad
	else if (  sFAID == "5" ) { return "pkr"; } // PKR
		

	// defaulted
	return "";
}

string DEXBattle_getFactionFAID( string sFAID )
{
	
	sFAID = GetStringLowerCase( CSLTrim( sFAID ) );
	if      (  sFAID == "1" ) { return "1"; } // Fallen Angels
	else if (  sFAID == "2" ) { return "2"; } // Order
	else if (  sFAID == "3" ) { return "3"; } // TB
	else if (  sFAID == "4" ) { return "4"; } // Triad
	else if (  sFAID == "5" ) { return "5"; } // PKR
	else if (  sFAID == "fallen" ) { return "1"; } // Fallen Angels
	else if (  sFAID == "order" ) { return "2"; } // Order
	else if (  sFAID == "tb" ) { return "3"; } // TB
	else if (  sFAID == "triad" ) { return "4"; } // Triad
	else if (  sFAID == "pkr" ) { return "5"; } // PKR
		

	// defaulted
	return "";
}

int DEXBattle_getFactionConstant( string sFAID )
{
	if      (  sFAID == "1" ) { return STANDARD_FACTION_ARMY1; } // Fallen Angels
	else if (  sFAID == "2" ) { return STANDARD_FACTION_ARMY2; } // Order
	else if (  sFAID == "3" ) { return STANDARD_FACTION_ARMY3; } // TB
	else if (  sFAID == "4" ) { return STANDARD_FACTION_ARMY4; } // Triad
	else if (  sFAID == "5" ) { return STANDARD_FACTION_ARMY5; } // PKR

	// defaulted
	return -1;
}









int SDB_FactionIsMember(object oPC, string sFAID = "0") { // TRUE/FALSE IF IN FACTION, OPTIONALLY CHECK FOR SPECIFIC FACTION
   if (sFAID!="0") return (sFAID==SDB_GetFAID(oPC)); // CHECK SPECIFIC
   return (SDB_GetFMID(oPC)!="0"); // CHECK ANY
}



string SDB_FactionGetRank(object oPC)
{
   SDB_GetFMID(oPC); // JUST TO BE SURE FACTION DATA LOADED
   return GetLocalString(oPC, SDB_FACTION_RANK);
}



int SDB_FactionHasRank(object oPC, string sRank = SDB_FACTION_MEMBER) {
   return (SDB_FactionGetRank(oPC)==sRank);
}



string SDB_FactionNewGeneral(object oCommander, object oGeneral) {
   string scFMID = SDB_GetFMID(oCommander);
   string sgFMID = SDB_GetFMID(oGeneral);
   string sSQL;
   if (SDB_FactionGetRank(oCommander)==SDB_FACTION_COMMANDER && SDB_FactionGetRank(oGeneral)==SDB_FACTION_GENERAL) {
      sSQL = "update factionmember set fm_rank=" + CSLInQs(SDB_FACTION_COMMANDER) + " where fm_fmid=" + sgFMID;
      CSLNWNX_SQLExecDirect(sSQL);
      sSQL = "update factionmember set fm_rank=" + CSLInQs(SDB_FACTION_GENERAL) + " where fm_fmid=" + scFMID;
      CSLNWNX_SQLExecDirect(sSQL);
      SDB_FactionReloadData(oCommander); // RELOAD FACTION DATA
      SDB_FactionReloadData(oGeneral); // RELOAD FACTION DATA
      return "Success! The torch has been passed. " + GetName(oCommander) + " is the new General of " + SDB_FactionGetName(SDB_GetFAID(oCommander));
   }
   return "Failure! The Faction General can only appoint an existing Commander to his position.";
}



string SDB_FactionSetRank(object oPC, string sRank = SDB_FACTION_MEMBER) {
   string sFMID = SDB_GetFMID(oPC);
   string sFAID = SDB_GetFAID(oPC);
   string sOldRank = SDB_FactionGetRank(oPC);
   string sSQL;
   string sMsg = "";
   int nCnt = 0;
   if (sRank==SDB_FACTION_MEMBER && sOldRank==SDB_FACTION_COMMANDER) { // DEMOTING COMMANDER TO MEMBER
      SendMessageToPC(oPC, "You have been demoted from Faction Commander to Member.");
      sMsg = GetName(oPC) + " has been demoted from Faction Commander to Member.";
   } else if (sRank==SDB_FACTION_COMMANDER && sOldRank==SDB_FACTION_MEMBER) { // PROMOTING MEMBER TO COMMANDER, COUNT EXISTING FIRST
      sSQL = "select count(*) from factionmember where fm_faid=" + sFAID + " and fm_rank=" + CSLInQs(SDB_FACTION_COMMANDER);
      CSLNWNX_SQLExecDirect(sSQL);
      if (CSLNWNX_SQLFetch()) nCnt = CSLNWNX_SQLGetDataInt(1);
      if (nCnt==SDB_FACTION_COMMANDER_CNT) {
         return "Failure! " + SDB_FactionGetName(sFAID) + " already has the maximum of " + IntToString(SDB_FACTION_COMMANDER_CNT) + " Commanders";
      } else {
         SendMessageToPC(oPC, "Congratulations! You have been promoted to Faction Commander.");
         sMsg =  "Success! " + GetName(oPC) + " has been promoted to Faction Commander.";
      }
   }
   sSQL = "update factionmember set fm_rank=" + CSLInQs(sRank) + " where fm_fmid=" + sFMID;
   CSLNWNX_SQLExecDirect(sSQL);
   SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
   return sMsg;
}






void SDB_FactionApplyAura(object oPC)
{
	CSL_FactionCacheVariables(oPC);
	if (!SDB_FactionIsMember(oPC) || GetIsDM(oPC)) { return; }
	object oCoin = GetItemPossessedBy(oPC, SDB_FACTION_TOMERESREF); // Bonus
	if (GetObjectType(oCoin)==OBJECT_TYPE_ITEM)
	{
		CSLRemoveEffectByCreator(oPC, oCoin);
		string sAura = SDB_FactionGetAuraSEF(SDB_GetFAID(oPC));
		AssignCommand(oCoin, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNWN2SpecialEffectFile(sAura), oPC));
		if (SDB_FactionGetRank(oPC)==SDB_FACTION_GENERAL)
		{
			sAura = "aura_general.sef"; //SDB_FactionGetAuraSEF(SDB_GetFAID(oPC), SDB_FACTION_GENERAL);
		}
		else if (SDB_FactionGetRank(oPC)==SDB_FACTION_COMMANDER)
		{
			sAura = "aura_commander.sef";   
		}
		else
		{
			return; // NOTHING SPECIAL FOR ENLISTED MEN
		}    
		AssignCommand(oCoin, ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectNWN2SpecialEffectFile(sAura), oPC));
	}
}

void SDB_FactionSetArtifact(string sFAID, string sArtiFAID) { // SET THE FACTION ARTIFACT OWNER
   SetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID, sArtiFAID);
   string sSQL = "update faction set fa_artifact=" + sArtiFAID + " where fa_faid=" + sFAID;
   CSLNWNX_SQLExecDirect(sSQL);
}

string SDB_FactionGetArtifact(string sFAID) { // GET THE FACTION ARTIFACT POSSESSING FACTION
   return GetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID);
}




string SDB_FactionGetArtifactName(string sFAID) { // GET THE FACTION ARTIFACT NAME
   return GetLocalString(GetModule(), SDB_FACTION_ARTINAME + sFAID);
}

int SDB_FactionGetArtifactCount(string sFAID) { // GET THE FACTION ARTIFACT COUNT
   return GetLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sFAID);
}

string SDB_FactionGetBossName(string sFAID) { // GET THE FACTION BOSS NAME
   return GetLocalString(GetModule(), SDB_FACTION_BOSSNAME + sFAID);
}

int SDB_FactionGetBossSkin(string sFAID) { // GET THE FACTION BOSS NAME
   return GetLocalInt(GetModule(), SDB_FACTION_BOSSSKIN + sFAID);
}

int SDB_FactionGetTithe(string sFAID) { // GET THE FACTION BOSS NAME
   return GetLocalInt(GetModule(), SDB_FACTION_TITHE + sFAID);
}

void SDB_FactionLoadData() { // LOAD MASTER FACTION DATA ON MODULE
   object oModule = GetModule();
   CSLDataArray_DeleteEntire(oModule,SDB_FAID_LIST );
   string sFAList = "";
   string sSQL;
   int nAnimosityBit = 8; // START IN 4TH BIT (FIRST 3 BITS FACTIONLESS ALIGNMENT TYPES)
   sSQL = "update faction set fa_artifact=fa_faid where fa_artifact=0";  // REBOOTED WITH NO OWNERS
   CSLNWNX_SQLExecDirect(sSQL);
   sSQL = "select fa_faid, fa_name, fa_aura, fa_aura2, fa_castlewp, fa_artifact, fa_bossname, fa_bossskin, fa_artifactname, fa_aurasef, fa_aurasefg, fa_tithepct from faction order by fa_faid";
   CSLNWNX_SQLExecDirect(sSQL);
   while(CSLNWNX_SQLFetch() == CSLSQL_SUCCESS) {
      string sFAID = CSLNWNX_SQLGetData(1);
      SetLocalString(oModule, SDB_FAID + "_" + sFAID, sFAID);
      SetLocalString(oModule, SDB_FACTION_NAME + sFAID, CSLNWNX_SQLGetData(2));
      SetLocalInt(oModule, SDB_FACTION_AURA + sFAID, CSLNWNX_SQLGetDataInt(3));
      SetLocalInt(oModule, SDB_FACTION_AURA2 + sFAID, CSLNWNX_SQLGetDataInt(4));
      SetLocalString(oModule, SDB_FACTION_WP + sFAID, CSLNWNX_SQLGetData(5));
      SetLocalString(oModule, SDB_FACTION_ARTIFACT + sFAID, CSLNWNX_SQLGetData(6));
      SetLocalString(oModule, SDB_FACTION_BOSSNAME + sFAID, CSLNWNX_SQLGetData(7));
      SetLocalInt(oModule, SDB_FACTION_BOSSSKIN + sFAID, CSLNWNX_SQLGetDataInt(8));
      SetLocalString(oModule, SDB_FACTION_ARTINAME + sFAID, CSLNWNX_SQLGetData(9));
      SetLocalString(oModule, SDB_FACTION_AURA + sFAID, CSLNWNX_SQLGetData(10));
      SetLocalString(oModule, SDB_FACTION_AURA2 + sFAID, CSLNWNX_SQLGetData(11));
      SetLocalInt(oModule, SDB_FACTION_TITHE + sFAID, StringToInt(CSLNWNX_SQLGetData(12)));


      SetLocalInt(oModule, SDB_FAID + "_ANIBIT_" + sFAID, nAnimosityBit);
      //int nEle = 
      CSLDataArray_PushString( oModule, SDB_FAID_LIST, sFAID );
      nAnimosityBit *= 2;
   }
}

string SDB_FactionAdd(object oPC, object oTomer) { // oTomer IS AN OFFICER INVITING oPC
   string sFMID = SDB_GetFMID(oPC);
   string sFAID = SDB_GetFAID(oTomer); // NEW FACTION
   string sFactionName = SDB_FactionGetName(sFAID);
   if (sFMID!="0") { // SHOULD NOT HAPPEN, BUT IN CASE
      string sFAIDOld = SDB_GetFAID(oPC);
      string sFactionRankOld = SDB_FactionGetRank(oPC);
      SendMessageToPC(oTomer, "Sorry, " + GetName(oPC) + " is already a " + sFactionRankOld + " in " + SDB_FactionGetName(sFAIDOld));
      return "Sorry, you are already a " + sFactionRankOld + " in " + SDB_FactionGetName(sFAIDOld);
   }
   string sCKID = SDB_GetCKID(oPC);
   string sSQL = "insert into factionmember (fm_faid, fm_ckid) values (" + sFAID + "," + sCKID + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
   SendMessageToPC(oTomer, "Success! " + GetName(oPC) + " is the newest member of " + sFactionName);
   if (!CSLHasItemByTag(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE TOME
   return "Success! You are the newest member of " + sFactionName;
}



string SDB_FactionRemove(object oPC, object oTomer=OBJECT_INVALID) { // oTomer IS AN OFFICER REMOVING oPC, ELSE REMOVING SELF
   string sFMID = SDB_GetFMID(oPC);
   string sFAID = SDB_GetFAID(oPC);
   string sFactionRank = SDB_FactionGetRank(oPC);
   string sFactionName = SDB_FactionGetName(sFAID);
   if (sFactionRank==SDB_FACTION_GENERAL) { // GENERAL REMOVING SELF!
      return "Failure! Please promote a new General before quitting " + sFactionName;
	}
	string sSQL = "delete from factionmember where fm_fmid=" + sFMID;
	CSLNWNX_SQLExecDirect(sSQL);
	DeleteLocalString(oPC, SDB_FMID);
	DeleteLocalString(oPC, SDB_FAID);
	DeleteLocalString(oPC, SDB_FACTION_RANK);
	RemoveEffect(oPC, EffectVisualEffect(SDB_FactionGetAura(sFAID, sFactionRank)));
	if (GetObjectType( GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG) )==OBJECT_TYPE_ITEM)
	{
		DestroyObject(GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG)); // REMOVE TOME
	}
	if ( GetIsObjectValid(oTomer) )
	{ // FORCED REMOVAL BY OFFICER
		SendMessageToPC(oPC, "You have been removed as a member of " + sFactionName + " by " + GetName(oTomer));
		return "Success! " + GetName(oPC) + " is no longer a member of " + sFactionName;
	}
	return "Success! You are no longer a member of " + sFactionName;
}

void SDB_FactionOnPCDeath(object oPC, object oKiller) {
   if (!GetIsPC(oPC) || !GetIsPC(oKiller)) return;
   string sSQL;
   string skFAID = SDB_GetFAID(oKiller);
   string sFAID = SDB_GetFAID(oPC);
   string sFARankSQL;
   string sFARank = SDB_FactionGetRank(oPC); // RANK OF THE DEAD GUY
   if (skFAID!="0") { // A FACTION KILL
      sFARankSQL = (sFARank==SDB_FACTION_GENERAL) ? "fa_killsgen=fa_killsgen+1, " : (sFARank==SDB_FACTION_COMMANDER) ? "fa_killscom=fa_killscom+1, " : "";
      sSQL = "update faction set " + sFARankSQL + "fa_kills=fa_kills+1 where fa_faid=" + skFAID;
      CSLNWNX_SQLExecDirect(sSQL);
   }
   if (sFAID!="0") { // A FACTION DEATH
      sFARankSQL = (sFARank==SDB_FACTION_GENERAL) ? "fa_deathsgen=fa_deathsgen+1, " : (sFARank==SDB_FACTION_COMMANDER) ? "fa_deathscom=fa_deathscom+1, " : "";
      sSQL = "update faction set " + sFARankSQL + "fa_deaths=fa_deaths+1 where fa_faid=" + sFAID;
      CSLNWNX_SQLExecDirect(sSQL);
   }
   if (sFAID!="0" && skFAID!="0") { // A FACTION VS FACTION ACTION
      sFARankSQL = (sFARank==SDB_FACTION_GENERAL) ? "ff_deathsgen=ff_deathsgen+1, " : (sFARank==SDB_FACTION_COMMANDER) ? "ff_deathscom=ff_deathscom+1, " : "";
      sSQL = "update factionvsfaction set ff_dldeath=now(), " + sFARankSQL + "ff_deaths=ff_deaths+1 where ff_faid=" + sFAID + " and ff_faidvs=" + skFAID;
      CSLNWNX_SQLExecDirect(sSQL);
      sFARankSQL = (sFARank==SDB_FACTION_GENERAL) ? "ff_killsgen=ff_killsgen+1, " : (sFARank==SDB_FACTION_COMMANDER) ? "ff_killscom=ff_killscom+1, " : "";
      sSQL = "update factionvsfaction set ff_dlkill=now(), " + sFARankSQL + "ff_kills=ff_kills+1 where ff_faid=" + skFAID + " and ff_faidvs=" + sFAID;
      CSLNWNX_SQLExecDirect(sSQL);
   }
}

// sDiplo = 'Neutral','Friendly','Enemy'
void SDB_FactionSetDiplomacy(string sFAID, string sVsFAID, string sDiplomacy) {
   string sSQL;
   sSQL = "update factionvsfaction set ff_diplomacy=" + CSLInQs(sDiplomacy) + " where ff_faid=" + sFAID + " and ff_faidvs=" + sVsFAID;
   CSLNWNX_SQLExecDirect(sSQL);
}

int SDB_InList(string sList, string sValue, string sDelim = "|") {
   return (FindSubString(sList, sDelim + sValue + sDelim)!=-1);
}


void SDB_FactionLoadDiplomacy(object oPC) {
   string sFAID = SDB_GetFAID(oPC);
   string sFAIDVs;
   string sSQL;
   string sEnemyList = "|";
   string sFriendList = "|";
   string sNeutralList = "|";
   sSQL = "select ff_diplomacy+0, ff_faidvs from factionvsfaction where ff_faid = " + sFAID;
   CSLNWNX_SQLExecDirect(sSQL);
   while(CSLNWNX_SQLFetch()) { // LOOPS OVER FAID'S AND CREATE A LIST
      int nDiplo = CSLNWNX_SQLGetDataInt(1);
      sFAIDVs = CSLNWNX_SQLGetData(2);
      switch (nDiplo) {
         case REPUTATION_TYPE_NEUTRAL:
            sNeutralList = sNeutralList + sFAIDVs + "|";
            break;
         case REPUTATION_TYPE_FRIEND:
            sFriendList = sFriendList + sFAIDVs + "|";
            break;
         case REPUTATION_TYPE_ENEMY:
            sEnemyList = sEnemyList + sFAIDVs + "|";
            break;
      }
   }
   object oMember = GetFirstPC();
   while (GetIsObjectValid(oMember)) { // LOOP OVER ALL PC'S AND CHECK WHICH LIST THEIR FACTION IS IN
      string sFAIDMember = SDB_GetFAID(oMember);
      if (!GetIsDM(oMember) && sFAIDMember!="0") { // SKIP DM'S & UNFACTIONED
         if (SDB_InList(sNeutralList, sFAIDMember)) {
         } else if (SDB_InList(sFriendList, sFAIDMember)) {
         } else if (SDB_InList(sEnemyList, sFAIDMember)) {
            AssignCommand(oPC,SetIsTemporaryEnemy(oMember));
            SetPCDislike(oPC,oMember);
         }
      }
      oMember = GetNextPC();
   }
}

string SDB_JoinFactionParty(object oPC) {
   string sRank;
   string sFAID = SDB_GetFAID(oPC);
   object oObjectSelected = OBJECT_INVALID;
   object oMember = GetFirstPC();
   while (GetIsObjectValid(oMember)) {
      string stFAID = SDB_GetFAID(oMember);
      if (oPC!=oMember && !GetIsDM(oMember) && sFAID==stFAID) {
         sRank = SDB_FactionGetRank(oMember);
         if (oObjectSelected==OBJECT_INVALID) { // TAKE FIRST FACTION MEMBER FOUND
            oObjectSelected = oMember;
         } else if (sRank==SDB_FACTION_GENERAL) { // FOUND THE GENERAL, PICK HIM
            oObjectSelected = oMember; // SAVE & EXIT LOOP
            break;
         } else if (sRank==SDB_FACTION_COMMANDER) { // FOUND A COMMANDER
            if (SDB_FactionGetRank(oObjectSelected)==SDB_FACTION_MEMBER) oObjectSelected = oMember; // TAKE COMMANDER OVER A MEMBER
         }
      }
      oMember = GetNextPC();
   }
   if (oObjectSelected==OBJECT_INVALID) {
      return "Sorry, no " + SDB_FactionGetName(sFAID) + " members are logged in right now.";
   } else {
      AddToParty(oPC, oObjectSelected);
      CSLSaveParty(oPC, OBJECT_INVALID); // CLEAR IT
      sRank = SDB_FactionGetRank(oObjectSelected);
      if (sRank==SDB_FACTION_GENERAL)        return "You have joined your General's party.";
      else if (sRank==SDB_FACTION_COMMANDER) return "You have joined your Commander's party.";
      else                                   return "You have joined your Faction's party.";
   }
}


int SDB_FactionGetAnimosity(string sFAID) {
    string sAnimosity = GetLocalString(GetModule(), SDB_FACTION_ANIMOSITY);
    int nAnimosity = StringToInt(sAnimosity);
    if (sAnimosity=="") {
      string sSQL = "select ff_diplomacy+0, ff_faidvs from factionvsfaction where ff_faid = " + sFAID + " order by ff_faid";
      CSLNWNX_SQLExecDirect(sSQL);
      while(CSLNWNX_SQLFetch()) { // LOOPS OVER FAID'S AND SET THE BITS
         if (CSLNWNX_SQLGetDataInt(1)==REPUTATION_TYPE_ENEMY) nAnimosity = nAnimosity | SDB_FactionGetAnimosityBit(sFAID);
      }
      SetLocalString(GetModule(), SDB_FACTION_ANIMOSITY, IntToString(nAnimosity));
    }
    return nAnimosity;
}



void SDB_ProcessAnimosity(object oPC, object oMember = OBJECT_INVALID) { // PASS A SINGLE PERSON IN oMember TO PROCESS JUST THEM - CALLED RECURSIVELY IN PC LOOP TO HANDLE DISLIKING NEW LOGINS
	if (GetIsDM(oMember))
	{
		return; // GET OUT!
	}
	string sFAID = SDB_GetFAID(oPC);
	string stFAID;
	int nToggleBit;
	object oTarget;
	int nAnimosity = GetLocalInt(oPC, SDB_ANIMOSITY);
	if (sFAID!="0") // FACTION, USE FVF SETTINGS FOR ANIMOSITY
	{ 
		nAnimosity = nAnimosity & 7; // TURN OFF EVERYTHING OVER POSITION 3 (FACTION BITS)
		nAnimosity = nAnimosity | SDB_FactionGetAnimosity(sFAID); // MERGE PERSONAL & FACTION BITS
	}
	if (oMember!=OBJECT_INVALID)
	{
		oTarget = oMember;
	}
	else
	{
		oTarget = GetFirstPC();
	}
	while (GetIsObjectValid(oTarget))  // LOOP OVER ALL PC'S
	{
		if (!GetIsDM(oTarget) && oTarget!=oPC) // DON'T DO DM'S & DON'T DO SELF
		{
			string stFAID = SDB_GetFAID(oTarget);
			if (stFAID!="0")  // FACTIONED
			{
				nToggleBit = SDB_FactionGetAnimosityBit(stFAID); // GET THIS FACTION'S BIT
			}
			else // NON-FACTIONED, CHECK ALIGNMENT
			{ 
				nToggleBit = CSLGetAlignbits(GetAlignmentGoodEvil(oTarget)); // GET THIS ALIGNMENT'S BIT
			}
			if (nAnimosity & nToggleBit)
			{
				SetPCDislike(oPC,oTarget); // IF IT'S ON I HATE THEM, AND WE DONE WITH THIS GUY
			}
			else if (oMember==OBJECT_INVALID)
			{
				SDB_ProcessAnimosity(oTarget, oPC); // I LIKE YOU, NOW YOU DO ME, BUT JUST ME
			}
		}
		if (oMember != OBJECT_INVALID) // JUST DOING ME, NO LOOP HERE, GTF OUTTA DODGE
		{
			return;
		}
		oTarget = GetNextPC();
	}
}


void SDB_FactionOnClientEnter(object oPC)
{
   SDB_GetFMID(oPC); // LOAD FACTION DATA
   if ( SDB_FactionIsMember(oPC) )
   {
      // SDB_FactionLoadDiplomacy(oPC); SKIP THIS HERE, WE DO IT IN PROCESSANIMOSITY NOW
      SendMessageToPC(oPC, SDB_JoinFactionParty(oPC));
      SDB_FactionApplyAura(oPC);
      if (!CSLHasItemByTag(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE IF NOT THERE

   }
   DelayCommand(5.0,SDB_ProcessAnimosity(oPC));
}

void SDB_FactionOnModuleLoad() {
   SDB_FactionLoadData();
}

void SDB_FactionOnPCRest(object oPC) {
   SDB_FactionApplyAura(oPC);
}

void SDB_FactionOnPCRespawn(object oPC) {
   SDB_FactionApplyAura(oPC);
}







string SDB_FactionGetFirst()
{
   return CSLDataArray_FirstString( GetModule(), SDB_FAID_LIST );
}

string SDB_FactionGetNext()
{
   return CSLDataArray_NextString( GetModule(), SDB_FAID_LIST );
}

string SDB_FactionDMAdd(object oPC, string sFAID, string sRank) {
   string sFactionName = SDB_FactionGetName(sFAID);
   string sSQL;
   if (sRank==SDB_FACTION_GENERAL) { // DEMOTE OLD GENERAL
		sSQL = "update factionmember set fm_rank=" + CSLInQs(SDB_FACTION_MEMBER) + " where fm_rank=" + CSLInQs(SDB_FACTION_GENERAL) + " and fm_faid=" + sFAID;
		CSLNWNX_SQLExecDirect(sSQL);
   }
   string sCKID = SDB_GetCKID(oPC);
   sSQL = "insert into factionmember (fm_faid, fm_ckid, fm_rank) values (" + CSLDelimList(sFAID, sCKID, CSLInQs(sRank)) + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
   SendMessageToPC(oPC, "Success! You are the newest " + sRank + " of " + sFactionName );
   if (!CSLHasItemByTag(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE TOME
   return "Success! " + GetName(oPC) + " is a " + sRank + " of " + sFactionName;
}

string SDB_FactionDMRemove(object oPC)
{
	string sFMID = SDB_GetFMID(oPC);
	string sFAID = SDB_GetFAID(oPC);
	string sFactionRank = SDB_FactionGetRank(oPC);
	string sFactionName = SDB_FactionGetName(sFAID);
	string sSQL = "delete from factionmember where fm_fmid=" + sFMID;
	CSLNWNX_SQLExecDirect(sSQL);
	DeleteLocalString(oPC, SDB_FMID);
	DeleteLocalString(oPC, SDB_FAID);
	DeleteLocalString(oPC, SDB_FACTION_RANK);
	RemoveEffect(oPC, EffectVisualEffect(SDB_FactionGetAura(sFAID, sFactionRank)));
	if (GetObjectType( GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG) )==OBJECT_TYPE_ITEM)
	{	
		DestroyObject(GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG)); // REMOVE TOME
	}
	SendMessageToPC(oPC, "You have been removed as a " + sFactionRank + " of " + sFactionName + " by a DM");
	return "Success! " + GetName(oPC) + " is no longer a " + sFactionRank + " of " + sFactionName;
}