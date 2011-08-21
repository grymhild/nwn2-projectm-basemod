#include "_CSLCore_Nwnx"
//#include "_CSLCore_Nwnx"
#include "_CSLCore_Strings"
#include "_CSLCore_Messages"
#include "_CSLCore_Player"

//#include "_SCUtility"
//#include "_HkSpell"

const string SDB_FAQ_LIST          = "FAQ_";

const int SDB_PLAYERNAME_UNIQUE = FALSE; // PC NAME MUST BE UNIQUE
const int SDB_PLAYERNAME_LENGTH = 40;    // PC MAX NAME LENGTH. 0 = ANY LENGTH
const int SDB_TRACK_PVM_DETAILS = 0;     // SAVE ALL PLAYERVSMONSTER DETAILS TO DB?

const int SDB_BANTYPE_TEMP = 0;
const int SDB_BANTYPE_CKID = 1;
const int SDB_BANTYPE_ACID = 2;
const int SDB_BANTYPE_CAID = 3;
const int SDB_BANTYPE_PLID = 4;

const int SDB_BANKTRANS_XP = 1;
const int SDB_BANKTRANS_GOLD = 2;

const string SDB_ACID            = "SDB_ACID";
const string SDB_ANIMOSITY       = "SDB_ANIMOSITY";
const string SDB_ARID            = "SDB_ARID";
const string SDB_BANK_GOLD       = "SDB_BANKGOLD";
const string SDB_BANK_XP         = "SDB_BANKXP";
const string SDB_BANNED          = "SDB_BANNED";
const string SDB_BANREASON       = "SDB_BANREASON";
const string SDB_BIND            = "SDB_BIND";
const string SDB_CAID            = "SDB_CAID";
const string SDB_CKID            = "SDB_CKID";
const string SDB_DAMAGE          = "SDB_DAMAGE";
const string SDB_DEATHS          = "SDB_DEATHS";
const string SDB_DM              = "SDB_DM";
const string SDB_KILLS           = "SDB_KILLS";
const string SDB_KILLS_NEW       = "SDB_KILLS_NEW";
const string SDB_LIID            = "SDB_LIID";
const string SDB_MOID            = "SDB_MOID_";
const string SDB_MONSTER_INSERT  = "SDB_MONSTER_INSERT";
const string SDB_NEW_CHAR        = "SDB_NEW";
const string SDB_NO_DEATH_PEN    = "SDB_NO_DEATH_PEN";
const string SDB_PC_DM           = "SDB_PC_DM";
const string SDB_PC_CNT          = "SDB_PC_CNT";
const string SDB_PC_MAX          = "SDB_PC_MAX";
const string SDB_PLID            = "SDB_PLID";
const string SDB_PKER            = "SDB_PKER";
const string SDB_PKED            = "SDB_PKED";
const string SDB_PV_LVL          = "SDB_PV_LVL";
const string SDB_PVID            = "SDB_PVID";
const string SDB_SEID            = "SDB_SEID";
const string SDB_SHOUTBAN        = "SDB_SHOUTBAN";
const string SDB_TIME            = "SDB_TIME";
const string SDB_XP              = "SDB_XP";
const string SDB_PCBANK_GOLD     = "SDB_PCBANKGOLD";
const string SDB_PCBANK_XP       = "SDB_PCBANKXP";
const string SDB_PCBANK_GOLDNEW  = "SDB_PCBANKGOLDNEW";
const string SDB_PCBANK_XPNEW    = "SDB_PCBANKXPNEW";
const string SDB_PCBANK_PCT      = "SDB_PCBANK_PCT";
const string SDB_RMID            = "SDB_RMID";
const string SDB_PC_SUPER        = "SDB_PC_SUPER";


//string SDB_GetServer();
//string SDB_SetField(string sFld, string sVal);
//void SDB_Error(string sError);
//void SDB_BootPC(object oPC, string sMsg, string sDMMsg);
//void SDB_SetNewType(object oPC, string sType);
//int SDB_NetWorth(object oPC);
string SDB_GetSEID(); // GET OR CREATE A SESSION ID
string SDB_GetCKID(object oPC); // GET OR CREATE A CDKEY ID
string SDB_GetACID(object oPC);  // GET OR CREATE AN ACCOUNT ID
string SDB_GetPLID(object oPC); // GET OR CREATE AN PLAYER ID
string SDB_GetCAID(object oPC);  // GET OR CREATE A CDKEY/ACCOUNT ID
string SDB_GetPVID(object oPC); // GET OR CREATE A PLAYER LEVEL RECORD
string SDB_GetLIID(object oPC); // GET OR CREATE A LOGIN ID
string SDB_GetARID(object oArea); // GET OR CREATE AN AREA ID
//int SDB_GetMonsterKillRate(string sMOID);

//string SDB_GetMOID(object oMonster); // GET OR CREATE A MONSTER ID
//int SDB_GetBankXP(object oPC);
//void SDB_SetBankXP(object oPC, int nXP);
//int SDB_GetBankGold(object oPC);
//void SDB_SetBankGold(object oPC, int nGold);
//int SDB_GetPCBankPCT(object oPC);
//void SDB_SetPCBankPCT(object oPC, int nPCT = 5);
//int SDB_GetPCBankXP(object oPC);
//int SDB_GetPCBankGold(object oPC);
//void SDB_IncPCBank(object oPC, int nXP, int nGold); 
//void SDB_MovePCBankToAccount(object oPC);
//int SDB_ValidName(object oPC);
//void SDB_UpdateSessionCnt(int iVal);
//void SDB_UpdatePlayerStatus(object oPC, string sActive="1", int bShowSaved = TRUE); // CALL THIS AS OFTEN AS NEEDED
//void SDB_OnModuleLoad();
//void SDB_OnClientEnter(object oPC); // CALL ON CLIENT ENTER
//void SDB_OnClientExit(object oPC);  // CALL ON CLIENT EXIT
//void SDB_OnAreaEnter(object oArea);
//int SDB_OnPCDeath(object oKilled, object oKiller); // CALL ON PLAYER DEATH
//void SDB_OnPCLevelUp(object oPC);
//void SDB_OnPCRest(object oPC);
//void SDB_OnPCRespawn(object oPC);
//location SDB_GetBind(object oPC);
//void SDB_SetBind(object oPC, location lBind);
//void SDB_OnPCBind(object oPC, object oBind=OBJECT_INVALID);
//void SDB_OnMonsterDeath(object oMonster, object oPC, int nPartyCnt, int nXP = 0); // PUT IN LOOP THAT AWARDS XP TO PC'S
int SDB_CheckTempBan(object oPC);
//void SDB_ApplyBan(object oPC,  int nBanType = SDB_BANTYPE_TEMP, int nBanLength = 1, string sReason = "");
//void SDB_UpdateAnimosity(object oPC, int nAnimosity);
void SDB_LogMsg(string sType, string sMsg, object oPC=OBJECT_INVALID);
//void SDB_SetXP(object oPC, int nXP, string sSource);
void SDB_BankTransaction(object oPC, int nAmount, int nTranType=SDB_BANKTRANS_GOLD);
//string SDB_GetNextToken(object oDM, object oPC, string sMsg);
//void SDB_SetIsShoutBanned(object oPC, int bFlag = 1, int bPerm = 0);
//int SDB_GetIsShoutBanned(object oPC);
//int SDB_GetIsPCDM(object oPC);
//void SDB_UpdateAccountPwd(object oPC, string sPwd);
//string SDB_GetRMID(object oPC, object oMonster); // GET OR CREATE A RANDOM MONSTER RECORD
//int SDB_GetPCDM(object oPC);
//int SDB_GetPCSuper(object oPC);
//string GetServerMsg();


string SDB_GetServer()
{
	string sWhichServer = GetLocalString(GetModule(), "WHICHSERVER");
	
	if ( sWhichServer == "" )
	{
		if ( GetIsSinglePlayer() )
		{
			return "0";
		}
		else
		{
			return "1";
		}
		
	}
	return sWhichServer;
}

string SDB_SetField(string sFld, string sVal )
{
   return sFld + "='" + sVal + "'";
}

string SDB_SetIntField(string sFld, string sVal )
{
   return sFld + "='" + IntToString(StringToInt(sVal)) + "'";
}

// this does it without validation
string SDB_SetRawField(string sFld, string sVal )
{
   return sFld + "=" + sVal;
}

void SDB_Error(string sError)
{
   string sSQL = "insert into dberrors (de_error) values (" + CSLInQs(sError) + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   WriteTimestampedLogEntry("SDB ERROR: " + sError);
}

void SDB_BootPC(object oPC, string sMsg, string sDMMsg)
{
   if (!GetIsObjectValid(oPC)) return;
   CSLMsgBox(oPC, sMsg + " You will be booted in 5 seconds.");
   DelayCommand(5.0f, BootPC(oPC));
   string sBoot = " Booted CDKey/Account/Player: " + CSLDelimList(CSLGetMyPublicCDKey(oPC), CSLGetMyPlayerName(oPC), CSLGetMyName(oPC));
   SendMessageToAllDMs("SDB MESSAGE: " + sDMMsg + sBoot);
   WriteTimestampedLogEntry("SDB MESSAGE: " + sDMMsg + sBoot);
}

void SDB_SetNewType(object oPC, string sType)
{
   if (GetLocalString(oPC, SDB_NEW_CHAR)=="") SetLocalString(oPC, SDB_NEW_CHAR, sType);
}

int SDB_NetWorth(object oPC)
{
   int iSlot=0;
   int iGP = GetGold(oPC);
   object oItem;
   for(iSlot = 0; iSlot < INVENTORY_SLOT_CWEAPON_L; iSlot++) {
      oItem = GetItemInSlot(iSlot, oPC);
      if (GetIsObjectValid(oItem)) iGP = iGP + GetGoldPieceValue(oItem);
   }
   oItem=GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem)) {
      iGP = iGP + GetGoldPieceValue(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   return iGP;
}

string SDB_GetSEID() // GET OR CREATE A SESSION ID
{
   string sSEID = GetLocalString(GetModule(), SDB_SEID);
   if (sSEID=="") // NO VARIABLE YET, CREATE IT
   {
      string sSQL = Get2DAString("whichserver", "Label", 0);
      SetLocalString(GetModule(), "WHICHSERVER", sSQL);
      //sSQL = GetModuleName() + " " + sSQL;
      sSQL = "insert into session (se_added, se_module) values (now(), "+ CSLInQs(sSQL) + ")";
      CSLNWNX_SQLExecDirect(sSQL);
      sSQL = "select last_insert_id() from session limit 1";
      CSLNWNX_SQLExecDirect(sSQL);
      if (CSLNWNX_SQLFetch() != CSLSQL_ERROR)
      {
         sSEID = CSLNWNX_SQLGetData(1);
         SetLocalString(GetModule(), SDB_SEID, sSEID);
      }
      else
      {
         WriteTimestampedLogEntry("No database! Session variable not fetched.");
         return "-1";
      }
      // SET UP SOME SESSION VARIABLES
      SetLocalInt(GetModule(), SDB_PC_CNT, 0);
      SetLocalInt(GetModule(), SDB_PC_MAX, 0);
   }
   return sSEID;
}


string SDB_GetCKID(object oPC) // GET OR CREATE A CDKEY ID
{
   string sCKID = GetLocalString(oPC, SDB_CKID);
   if (sCKID=="") // NO VARIABLE YET, CREATE IT
   {
      sCKID = "0";
	  if (GetIsDM(oPC)) return "0"; // Don't record dm clients
      string sSQL;
      string sCDKey = CSLGetMyPublicCDKey(oPC);
      sSQL = "select ck_ckid, ck_ban, ck_dm, ck_shoutban from cdkey where ck_cdkey = " + CSLInQs(sCDKey);
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR)  // GOT NO RECORD IN DB, CREATE ONE
      {
         SDB_SetNewType(oPC, "CDKEY");
         sSQL = "insert into cdkey (ck_cdkey) values (" + CSLInQs(sCDKey) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id(), 0 from cdkey limit 1"; // 0 = NOT BANNED BY DEFAULT
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
      }
      if ( nRC != CSLSQL_ERROR)
      {
         sCKID = CSLNWNX_SQLGetData(1);
         //SetLocalString(oPC, SDB_CKID, sCKID);
         if (CSLNWNX_SQLGetData(2)!="0") // BANNED BY CDKEY!
         {
            SetLocalString(oPC, SDB_BANNED, "CDKey");
         } else { // RECORD EXISTS AND ID FETCHED FROM THE DB SO UPDATE LOGIN INFO
            sSQL = "update cdkey set ck_dllogin=now(), ck_logins=ck_logins+1 where ck_ckid=" + sCKID;
            CSLNWNX_SQLExecDirect(sSQL);
       }
       SetLocalInt(oPC, SDB_DM, CSLNWNX_SQLGetDataInt(3));
       SetLocalInt(oPC, SDB_SHOUTBAN, CSLNWNX_SQLGetDataInt(4));

      } else { // OH NO - DB PROBLEM?
         // SDB_BootPC(oPC, "A Database Error has occurred.", "SDB_GetCKID: Record Not Found");
      }
      SetLocalString(oPC, SDB_CKID, sCKID);
   }
   return sCKID;
}

string SDB_GetACID(object oPC)  // GET OR CREATE AN ACCOUNT ID
{
   string sACID = GetLocalString(oPC, SDB_ACID);
   int bNew = FALSE;
   if (sACID=="") { // NO VARIABLE YET, CREATE IT
      sACID = "0";
	  if (GetIsDM(oPC)) return "0"; // Don't record dm clients
      string sSQL;
      string sAccount = CSLGetMyPlayerName(oPC);
      sSQL = "select ac_acid, ac_ban, ac_bankxp, ac_bankgold, ac_animosity, ac_dm, ac_super from account where ac_name = " + CSLInQs(sAccount);
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         SDB_SetNewType(oPC, "ACCOUNT"); // <- REDUNDANT! CANT HAVE NEW ACCOUNT W/O NEW CDKEYACCOUNT
         sSQL = "insert into account (ac_name) values (" + CSLInQs(sAccount) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id(), 0, 0, 0, 0, 0, 0 from account limit 1"; // 0 = NOT BANNED BY DEFAULT
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
         bNew = TRUE;
      }
      if (nRC != CSLSQL_ERROR) {
         sACID = CSLNWNX_SQLGetData(1);
         //SetLocalString(oPC, SDB_ACID, sACID);
         if (CSLNWNX_SQLGetData(2)!="0") { // BANNED BY ACCOUNT!
            SetLocalString(oPC, SDB_BANNED, "Account");
         } else { // RECORD EXISTS AND ID FETCHED FROM THE DB SO UPDATE LOGIN INFO
            SetLocalInt(oPC, SDB_BANK_XP, CSLNWNX_SQLGetDataInt(3));
            SetLocalInt(oPC, SDB_BANK_GOLD, CSLNWNX_SQLGetDataInt(4));
            SetLocalInt(oPC, SDB_ANIMOSITY, CSLNWNX_SQLGetDataInt(5));
            SetLocalInt(oPC, SDB_PC_DM, CSLNWNX_SQLGetDataInt(6));
            SetLocalInt(oPC, SDB_PC_SUPER, CSLNWNX_SQLGetDataInt(7));
            sSQL = "update account set ac_dllogin=now(), ac_logins=ac_logins+1 where ac_acid=" + sACID;
            CSLNWNX_SQLExecDirect(sSQL);
         }
      } else { // OH NO - DB PROBLEM?
         //SDB_BootPC(oPC, "A Database Error has occurred.", "SDB_GetACID: Record Not Found");
      }
      SetLocalString(oPC, SDB_ACID, sACID);
   }
   return sACID;
}

string SDB_GetPLID(object oPC) // GET OR CREATE AN PLAYER ID
{
   string sPLID = GetLocalString(oPC, SDB_PLID);
   if (sPLID=="") { // NO VARIABLE YET, CREATE IT
      sPLID = "0";
	  if (GetIsDM(oPC)) return "0"; // Don't record dm clients
      string sSQL;
      string sPlayer = CSLGetMyName(oPC);
      string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
      sSQL = "select pl_plid, pl_damage, pl_kills, pl_bind, pl_deaths, pl_pker, pl_pked, pl_ban, pl_bankxp, pl_bankgold, pl_bankpct from player where pl_acid = " + sACID + " and pl_name = " + CSLInQs(sPlayer);
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         SDB_SetNewType(oPC, "PLAYER");
         sSQL = "insert into player (pl_acid, pl_name, pl_dm) values (" + sACID + "," + CSLInQs(sPlayer) + "," + IntToString(GetIsDM(oPC)) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id(), 0, 0, '', 0, 0, 0, 0, 0, 0, 0 from player limit 1"; // 0 DAMAGE, 0 BAN BY DEFAULT
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
      }
      if (nRC != CSLSQL_ERROR) {
         sPLID = CSLNWNX_SQLGetData(1);
         SetLocalInt(oPC, SDB_DAMAGE, CSLNWNX_SQLGetDataInt(2));
         SetLocalInt(oPC, SDB_KILLS_NEW, 0);
         SetLocalLocation(oPC, SDB_BIND, CSLUnserializeLocation(CSLNWNX_SQLGetData(4)));
         SetLocalInt(oPC, SDB_DEATHS, CSLNWNX_SQLGetDataInt(5));
         SetLocalInt(oPC, SDB_PKER, CSLNWNX_SQLGetDataInt(6));
         SetLocalInt(oPC, SDB_PKED, CSLNWNX_SQLGetDataInt(7));
         if (CSLNWNX_SQLGetData(8)!="0") { // BANNED BY PLAYER!
            SetLocalString(oPC, SDB_BANNED, "Character");
         } else { // RECORD EXISTS AND ID FETCHED FROM THE DB SO UPDATE LOGIN INFO
            sSQL = "update player set pl_dllogin=now(), pl_logins=pl_logins+1 where pl_plid=" + sPLID;
            CSLNWNX_SQLExecDirect(sSQL);
         }
         
         SetLocalInt(oPC, SDB_PCBANK_GOLD, CSLNWNX_SQLGetDataInt(9));
         SetLocalInt(oPC, SDB_PCBANK_GOLDNEW, 0);
         SetLocalInt(oPC, SDB_PCBANK_XP, CSLNWNX_SQLGetDataInt(10));
         SetLocalInt(oPC, SDB_PCBANK_XPNEW, 0);         
         SetLocalInt(oPC, SDB_PCBANK_PCT, CSLNWNX_SQLGetDataInt(11));
         
      } else { // OH NO - DB PROBLEM?
         SetLocalLocation(oPC, SDB_BIND, GetCampaignLocation("SDB_BIND", "BIND", oPC));
         SendMessageToPC(oPC, "Bioware Bound...");
      }
      SetLocalString(oPC, SDB_PLID, sPLID);
   }
   return sPLID;
}

string SDB_GetCAID(object oPC)  // GET OR CREATE A CDKEY/ACCOUNT ID
{
   string sCAID = GetLocalString(oPC, SDB_CAID);
   if (sCAID=="")
   { // NO VARIABLE YET, CREATE IT
      sCAID=="0";
	  if ( GetIsDM(oPC) ) return "0"; // Don't record dm clients
      string sSQL;
      string sCKID = SDB_GetCKID(oPC); // GET CDKEY TABLE ID
      string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
      sSQL = "select ca_caid, ca_ban from cdkeyaccount where ca_ckid = " + sCKID + " and ca_acid = " + sACID;
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR)
      { // GOT NO RECORD IN DB, CREATE ONE
         sSQL = "select ca_caid from cdkeyaccount where ca_acid = " + sACID; // IS ANOTHER CDKEY ALREADY LINKED TO ANOTHER ACCOUNT?
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
         if (nRC!=CSLSQL_ERROR)
         { // GOT A RECORD IN DB, THIS ACCOUNT IS ALREADY LINKED!!
            SDB_BootPC(oPC, "Login Error. This account is locked to another CD Key.", "SDB_GetCAID: Account/CDKey locked.");
            return "0";
         }
         SDB_SetNewType(oPC, "CDKEYACCOUNT");
         sSQL = "insert into cdkeyaccount (ca_ckid, ca_acid) values (" + sCKID + "," + sACID + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id(), 0 from cdkeyaccount limit 1"; // 0 = NOT BANNED BY DEFAULT
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
      }
      if (nRC != CSLSQL_ERROR) {
         sCAID = CSLNWNX_SQLGetData(1);
         WriteTimestampedLogEntry("New sCAID = " + sCAID);
         //SetLocalString(oPC, SDB_CAID, sCAID);
         if (CSLNWNX_SQLGetData(2)!="0") { // BANNED BY CDKEYACCOUNT!
            SetLocalString(oPC, SDB_BANNED, "CDKey/Account");
         } else { // RECORD EXISTS AND ID FETCHED FROM THE DB SO UPDATE LOGIN INFO
            sSQL = "update cdkeyaccount set ca_dllogin=now(), ca_logins=ca_logins+1 where ca_caid=" + sCAID;
            CSLNWNX_SQLExecDirect(sSQL);
         }
      } else { // OH NO - DB PROBLEM?
         //SDB_BootPC(oPC, "A Database Error has occurred.", "SDB_GetCAID: Record Not Found");
      }
      SetLocalString(oPC, SDB_CAID, sCAID);
   }
   return sCAID;
}

string SDB_GetPVID(object oPC) // GET OR CREATE A PLAYER LEVEL RECORD
{
   if (GetIsDM(oPC)) return "0";

   string sPVID = GetLocalString(oPC, SDB_PVID);
   int nPVLVL = GetLocalInt(oPC, SDB_PV_LVL);
   if (sPVID=="" || nPVLVL!=GetHitDice(oPC)) { // NO VARIABLE YET OR PLAYER HAS LEVELED, CREATE NEW
      sPVID = "0";
      string sSQL;
      string sPLID = SDB_GetPLID(oPC); // GET PLAYER TABLE ID
      nPVLVL = GetHitDice(oPC);
      string sLevel = IntToString(GetHitDice(oPC));
      sSQL = "select pv_pvid from playerlevel where pv_plid = " + sPLID + " AND PV_LEVEL = " + sLevel + " ORDER BY PV_ADDED DESC LIMIT 1"; // GET THE LATEST LEVEL RECORD IN CASE OF DELEVELING
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         string sSEID = SDB_GetSEID();    // GET SESSION ID
         string sTag = GetTag(oPC);
         string sName = CSLGetMyName(oPC);
         string sCR = IntToString(FloatToInt(CSLGetChallengeRating(oPC)));
         string sHP = IntToString(GetMaxHitPoints(oPC));
         string sAC = IntToString(GetAC(oPC));
         string sAB = IntToString(GetTRUEBaseAttackBonus(oPC));
         string sC1 = IntToString(GetClassByPosition(1, oPC));
         string sC1L = IntToString(GetLevelByClass(GetClassByPosition(1, oPC),oPC));
         string sC2 = IntToString(GetClassByPosition(2, oPC));
         string sC2L = IntToString(GetLevelByClass(GetClassByPosition(2, oPC),oPC));
         string sC3 = IntToString(GetClassByPosition(3, oPC));
         string sC3L = IntToString(GetLevelByClass(GetClassByPosition(3, oPC),oPC));
         string sC4 = IntToString(GetClassByPosition(4, oPC));
         string sC4L = IntToString(GetLevelByClass(GetClassByPosition(4, oPC),oPC));
         string sGold = IntToString(SDB_NetWorth(oPC));
         sSQL = "insert into playerlevel (pv_seid, pv_plid, pv_level, pv_hp, pv_ac, pv_ab, pv_class1, pv_class1level, pv_class2, pv_class2level, pv_class3, pv_class3level, pv_class4, pv_class4level, pv_gold) " +
                   "values (" + CSLDelimList(sSEID, sPLID, sLevel, sHP, sAC, sAB)  +
                          "," + CSLDelimList(sC1, sC1L, sC2, sC2L, sC3, sC3L, sC4, sC4L, sGold) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id() from playerlevel limit 1";
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
      }
      if (nRC != CSLSQL_ERROR) {
         sPVID = CSLNWNX_SQLGetData(1);
      }

      SetLocalString(oPC, SDB_PVID, sPVID);
      SetLocalInt(oPC, SDB_PV_LVL, nPVLVL);
   }
   return sPVID;
}

string SDB_GetLIID(object oPC) // GET OR CREATE A LOGIN ID
{
   string sLIID = GetLocalString(oPC, SDB_LIID);
   if (sLIID=="") { // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
      sLIID = "0";
	  if (GetIsDM(oPC)) return "0"; // Don't record dm clients
      string sSQL;
      string sSEID = SDB_GetSEID();    // GET SESSION ID
      string sCKID = SDB_GetCKID(oPC); // GET CDKEY TABLE ID
      string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
      string sPLID = SDB_GetPLID(oPC); // GET PLAYER TABLE ID
      string sCAID = SDB_GetCAID(oPC); // GET CDKEY-ACCOUNT LINK TABLE ID
      string sIP   = CSLGetMyIPAddress(oPC); //GetPCIPAddress(oPC);
      string sGold = IntToString(SDB_NetWorth(oPC));
      string sXP   = IntToString(GetXP(oPC));
      string sSts  = (GetCurrentHitPoints(oPC)>0) ? "OK" : "DEAD";
      sSts = GetIsDM(oPC) ? "DM" : (GetLocalString(oPC, SDB_BANNED)!="") ? "BAN" : sSts;
      sSQL = "insert into login (li_seid, li_ckid, li_acid, li_plid, li_caid, li_stsin, li_goldin, li_xpin, li_ip) " +
                "values (" + CSLDelimList(sSEID, sCKID, sACID, sPLID, sCAID, CSLInQs(sSts), sGold, sXP, CSLInQs(sIP))  + ")";
      CSLNWNX_SQLExecDirect(sSQL);
      sSQL = "select last_insert_id() from login limit 1";
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC!=CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         sLIID = CSLNWNX_SQLGetData(1);
         //SetLocalString(oPC, SDB_LIID, sLIID);
      } else { // OH NO - DB PROBLEM?
         //SDB_BootPC(oPC, "A Database Error has occurred.", "SDB_GetLIID: Record Not Found");
      }
      SetLocalString(oPC, SDB_LIID, sLIID);
   }
   return sLIID;
}

string SDB_GetARID(object oArea) // GET OR CREATE AN AREA ID
{
   string sARID = GetLocalString(oArea, SDB_ARID);
   if (sARID=="") { // NO VARIABLE YET, CREATE IT
      sARID = "0";
      string sSQL;
      string sTag = GetTag(oArea);
      string sName = GetName(oArea);
      if (sTag=="") return "0";
      sSQL = "select ar_arid from area where ar_tag = " + CSLInQs(sTag);
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         sSQL = "insert into area (ar_tag, ar_name) values (" + CSLInQs(sTag) + "," + CSLInQs(sName) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id() from area limit 1";
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
      }
      if (nRC != CSLSQL_ERROR) {
         sARID = CSLNWNX_SQLGetData(1);
      }
      SetLocalString(oArea, SDB_ARID, sARID);
   }
   return sARID;
}

int SDB_GetMonsterKillRate(string sMOID)
{
   return GetLocalInt(GetModule(), SDB_MOID + "_RATE" + sMOID);
}

string SDB_GetMOID(object oMonster) // GET OR CREATE A MONSTER ID
{
   string sRes = GetResRef(oMonster);
   string sTag = GetTag(oMonster);
   if (sRes=="" && CSLStringStartsWith(sTag, "PLID")) sRes = sTag;
   if (sRes=="") return "0"; // no resref, bail
   string sMOID = GetLocalString(GetModule(), SDB_MOID + sRes);
   if (sMOID=="") { // NO VARIABLE YET, CREATE IT
      sMOID = "0";
      string sName = GetName(oMonster);
      string sCR = IntToString(CSLGetMin(40, CSLGetMax(0, FloatToInt(CSLGetChallengeRating(oMonster)))));
      string sHP = IntToString(GetMaxHitPoints(oMonster));
      string sAC = IntToString(GetAC(oMonster));
      string sAB = IntToString(GetTRUEBaseAttackBonus(oMonster));
      string sXP = "0";
      string sLevel = IntToString(GetHitDice(oMonster));
      string sC1 = IntToString(GetClassByPosition(1, oMonster));
      string sC1L = IntToString(GetLevelByClass(GetClassByPosition(1, oMonster),oMonster));
      string sC2 = IntToString(GetClassByPosition(2, oMonster));
      string sC2L = IntToString(GetLevelByClass(GetClassByPosition(2, oMonster),oMonster));
      string sC3 = IntToString(GetClassByPosition(3, oMonster));
      string sC3L = IntToString(GetLevelByClass(GetClassByPosition(3, oMonster),oMonster));
      string sC4 = IntToString(GetClassByPosition(4, oMonster));
      string sC4L = IntToString(GetLevelByClass(GetClassByPosition(4, oMonster),oMonster));
      string sSTR = IntToString(GetAbilityScore(oMonster, ABILITY_STRENGTH, TRUE));
      string sCON = IntToString(GetAbilityScore(oMonster, ABILITY_CONSTITUTION, TRUE));
      string sDEX = IntToString(GetAbilityScore(oMonster, ABILITY_DEXTERITY, TRUE));
      string sINT = IntToString(GetAbilityScore(oMonster, ABILITY_INTELLIGENCE, TRUE));
      string sWIS = IntToString(GetAbilityScore(oMonster, ABILITY_WISDOM, TRUE));
      string sCHA = IntToString(GetAbilityScore(oMonster, ABILITY_CHARISMA, TRUE));
      string sRate = "0";
      string sSQL = "select mo_moid, round(mo_kills/mo_killed * 100) from monster where mo_resref = " + CSLInQs(sRes);
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) { // GOT NO RECORD IN DB, CREATE ONE
         sSQL = "insert into monster (mo_resref) values (" + CSLInQs(sRes) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id() from monster limit 1";
         CSLNWNX_SQLExecDirect(sSQL);
         int nRC = CSLNWNX_SQLFetch();
         sMOID = CSLNWNX_SQLGetData(1);
      } else {
         sMOID = CSLNWNX_SQLGetData(1);
         sRate = CSLNWNX_SQLGetData(2);
      }
      SetLocalString(GetModule(), SDB_MOID + sRes, sMOID);
      SetLocalInt(GetModule(), SDB_MOID + "_RATE" + sMOID, StringToInt(sRate));

      sSQL = "update monster set " +
          CSLDelimList(SDB_SetField("mo_tag", sTag),
                    SDB_SetField("mo_name", sName),
                    SDB_SetField("mo_cr", sCR),
                    SDB_SetField("mo_hp", sHP),
                    SDB_SetField("mo_ac", sAC),
                    SDB_SetField("mo_ab", sAB),
                    SDB_SetField("mo_xpatcr", sXP),
                    SDB_SetField("mo_level", sLevel)
                    ) + "," +
          CSLDelimList(SDB_SetField("mo_str", sSTR),
                    SDB_SetField("mo_con", sCON),
                    SDB_SetField("mo_dex", sDEX),
                    SDB_SetField("mo_int", sINT),
                    SDB_SetField("mo_wis", sWIS),
                    SDB_SetField("mo_cha", sCHA)
                    ) + "," +
          CSLDelimList(SDB_SetField("mo_class1", sC1),
                    SDB_SetField("mo_class1level", sC1L),
                    SDB_SetField("mo_class2", sC2),
                    SDB_SetField("mo_class2level", sC2L),
                    SDB_SetField("mo_class3", sC3),
                    SDB_SetField("mo_class3level", sC3L),
                    SDB_SetField("mo_class4", sC3),
                    SDB_SetField("mo_class4level", sC3L)
                    ) +
            " where mo_moid = " + sMOID;
      CSLNWNX_SQLExecDirect(sSQL);

   }
   return sMOID;
}

int SDB_GetBankXP(object oPC)
{
   return GetLocalInt(oPC, SDB_BANK_XP);
}

void SDB_SetBankXP(object oPC, int nXP)
{
   SDB_BankTransaction(oPC, nXP, SDB_BANKTRANS_XP);
   SetLocalInt(oPC, SDB_BANK_XP, nXP);
   string sSQL = "update account set ac_bankxp=" + IntToString(nXP) + " where ac_acid = " + SDB_GetACID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
}

int SDB_GetBankGold(object oPC)
{
   return GetLocalInt(oPC, SDB_BANK_GOLD);
}

void SDB_SetBankGold(object oPC, int nGold)
{
   SDB_BankTransaction(oPC, nGold, SDB_BANKTRANS_GOLD);
   SetLocalInt(oPC, SDB_BANK_GOLD, nGold);
   string sSQL = "update account set ac_bankgold=" + IntToString(nGold) + " where ac_acid = " + SDB_GetACID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
}

// *** PC BANK
int SDB_GetPCBankPCT(object oPC)
{
   return GetLocalInt(oPC, SDB_PCBANK_PCT);
}

void SDB_SetPCBankPCT(object oPC, int nPCT = 5)
{
   if (nPCT<5) {
      SendMessageToPC(oPC, "Your PC Cache Percentage cannot be less than 5%.");
      nPCT = 5;
   }
   if (nPCT>20) {
      SendMessageToPC(oPC, "Your PC Cache Percentage cannot be greater than 20%.");
      nPCT = 20;
   }
   SetLocalInt(oPC, SDB_PCBANK_PCT, nPCT);
   string sSQL = "update player set pl_bankpct = '" + IntToString(nPCT) + "' where pl_plid=" + SDB_GetPLID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
   SendMessageToPC(oPC, "Your PC Cache Percentage has been set to " + IntToString(nPCT) + "%.");
}

int SDB_GetPCBankXP(object oPC)
{
   return GetLocalInt(oPC, SDB_PCBANK_XP);
}

int SDB_GetPCBankGold(object oPC)
{
   return GetLocalInt(oPC, SDB_PCBANK_GOLD);
}

void SDB_IncPCBank(object oPC, int nXP, int nGold) 
{
   CSLIncrementLocalInt(oPC, SDB_PCBANK_XP, nXP);
   CSLIncrementLocalInt(oPC, SDB_PCBANK_GOLD, nGold);
   CSLIncrementLocalInt(oPC, SDB_PCBANK_XPNEW, nXP);
   CSLIncrementLocalInt(oPC, SDB_PCBANK_GOLDNEW, nGold);
}

void SDB_MovePCBankToAccount(object oPC)
{
   int nGold = SDB_GetPCBankGold(oPC);
   int nXP = SDB_GetPCBankXP(oPC);
   if (nGold+nXP > 0)
   {
      SDB_SetBankGold(oPC, nGold + SDB_GetBankGold(oPC));
      SDB_SetBankXP(oPC, nXP + SDB_GetBankXP(oPC));
      SDB_LogMsg("CACHEOUT", "Cached Out: "  + IntToString(nGold) + " Gold / " + IntToString(nXP) + " XP", oPC);
      CSLNWNX_SQLExecDirect("update player set " + CSLDelimList(SDB_SetField("pl_bankgold", "0"), SDB_SetField("pl_bankxp", "0")) + 
                    " where PL_PLID = " + SDB_GetPLID(oPC));
      DeleteLocalInt(oPC, SDB_PCBANK_XP);
      DeleteLocalInt(oPC, SDB_PCBANK_GOLD);
      DeleteLocalInt(oPC, SDB_PCBANK_XPNEW);
      DeleteLocalInt(oPC, SDB_PCBANK_GOLDNEW);
      SendMessageToPC(oPC, "You reached max level! Your PC XP Cache was worth <color=gold>" + IntToString(nGold) + " Gold</color> and <color=silver>" + IntToString(nXP) + " XP</color>. This has been moved to your Account Bank is now yours to use.");
   }
   else
   {
      SendMessageToPC(oPC, "You reached max level but your PC XP Cache was <color=OliveDrab>worthless</color>.");
   }
}

int SDB_ValidName(object oPC)
{
   if (GetXP(oPC)>0) return TRUE; // ONLY VALIDATE NEW CHARS
   string sAccount = CSLGetMyPlayerName(oPC);
   string sPlayer = CSLGetMyName(oPC);
   string sMsg = "";
   string sDMMsg = "";
   string sBanSQL = "update player set pl_ban='1' where pl_plid=" + SDB_GetPLID(oPC);
   int bBanAccount = FALSE;
   int iLen = GetStringLength(sPlayer);
   if (FindSubString(sAccount, "~")!=-1 || FindSubString(sAccount, "")!=-1)
   {
      sMsg = "Sorry, Account and Player Names cannot contain the tilde (~) or separator () character.";
      sBanSQL = "update account set ac_ban=1 where ac_acid=" + SDB_GetACID(oPC);
      sDMMsg = "Account Banned: Invalid Name (~ or )";
   }
   else if (FindSubString(sPlayer, "~")!=-1 || FindSubString(sPlayer, "")!=-1)
   {
      sMsg = "Sorry, Player and Account Names cannot contain the tilde (~) or separator () character.";
      sDMMsg = "Player Banned: Invalid Name (~ or )";
   }
   else if (SDB_PLAYERNAME_LENGTH>0 && iLen > SDB_PLAYERNAME_LENGTH)
   {
      sMsg = "Sorry, Player Names cannot be longer than " + IntToString(SDB_PLAYERNAME_LENGTH) + " characters.";
      sDMMsg = "Player Banned: " + IntToString(SDB_PLAYERNAME_LENGTH) + " char name limit exceeded";
   }
   else if (SDB_PLAYERNAME_UNIQUE)
   {
      CSLNWNX_SQLExecDirect("select pl_plid from player where pl_name=" + CSLInQs(sPlayer) + " and pl_acid!=" + SDB_GetACID(oPC));
      if (CSLNWNX_SQLFetch() != CSLSQL_ERROR)
      { // This name is used by another account
         sMsg = "Sorry, Another account is using that player name. Please pick a new one.";
         sDMMsg = "Player Ban: Non-Unique name";
      }
   }
   if (sMsg!="") {
      CSLNWNX_SQLExecDirect(sBanSQL);
      SDB_BootPC(oPC, sMsg, sDMMsg);
      return FALSE;
   }
   return TRUE;
}

void SDB_UpdateSessionCnt(int iVal)
{
   string sSEID = SDB_GetSEID();
   int nPCCnt = CSLCountPlayers();// CSLIncrementLocalInt(GetModule(), SDB_PC_CNT, iVal);
   int nPCMax = GetLocalInt(GetModule(), SDB_PC_MAX); // LAST KNOWN MAX
   nPCMax = CSLGetMax(nPCCnt, nPCMax);
   SetLocalInt(GetModule(), SDB_PC_MAX, nPCMax);
   string sSQL = "update session set " +
        CSLDelimList(SDB_SetField("se_pccnt", IntToString(nPCCnt)),
                  SDB_SetField("se_pcmax", IntToString(nPCMax))) +
                 " where se_seid = " + sSEID;
   CSLNWNX_SQLExecDirect(sSQL);
}

void SDB_UpdatePlayerStatus(object oPC, string sActive="1", int bShowSaved = TRUE) // CALL THIS AS OFTEN AS NEEDED
{
   if (!CSLNWNX_Installed()) return;
   if (GetIsDM(oPC)) return; // Don't record dm clients
   string sPLID = SDB_GetPLID(oPC); // GET PLAYER TABLE ID
   string sSQL;
   string sDamage = IntToString(!GetIsDead(oPC) ? GetMaxHitPoints(oPC)-GetCurrentHitPoints(oPC) : GetMaxHitPoints(oPC)+420);
   int nPlayTime = CSLTimeStamp() - GetLocalInt(oPC, SDB_TIME);
   if (nPlayTime > 100) nPlayTime = 0; // SCREWY TIME, RESET VARS
   string sTime = "pl_time+" + IntToString(nPlayTime); // GAME HOURS SINCE LAST SAVE
   SetLocalInt(oPC, SDB_TIME, CSLTimeStamp());
   string sPos = CSLSerializeLocation(GetLocation(oPC));
   string sNewKills = "pl_kills+" + IntToString(GetLocalInt(oPC, SDB_KILLS_NEW));
   SetLocalInt(oPC, SDB_KILLS_NEW, 0);
   
   int nBankGold = GetLocalInt(oPC, SDB_PCBANK_GOLDNEW);
   int nBankXP = GetLocalInt(oPC, SDB_PCBANK_XPNEW);
   string sNewGold  = "pl_bankgold+" + IntToString(nBankGold);
   SetLocalInt(oPC, SDB_PCBANK_GOLDNEW, 0);
   string sNewXP    = "pl_bankxp+" + IntToString(nBankXP);
   SetLocalInt(oPC, SDB_PCBANK_XPNEW, 0);
      
   ExportSingleCharacter(oPC);
   if (bShowSaved) {
      FloatingTextStringOnCreature("<color=orange>PC Saved.</color>", oPC, TRUE);
      if (nBankGold || nBankXP) {
         nBankGold = GetLocalInt(oPC, SDB_PCBANK_GOLD);
         nBankXP = GetLocalInt(oPC, SDB_PCBANK_XP);  
         SendMessageToPC(oPC, "Saved PC Cache. New Balance is " + IntToString(nBankGold) + " Gold / " + IntToString(nBankXP) + " XP.");
      }
   }   
   string sDeaths = IntToString(GetLocalInt(oPC, SDB_DEATHS));
   if (sActive!="0")
   {
		sActive = SDB_GetServer();
   }
   sSQL = "update player set " +
             CSLDelimList( SDB_SetField("pl_active", sActive),
                           SDB_SetField("pl_damage", sDamage),
                           SDB_SetRawField("pl_time", sTime),
                           SDB_SetRawField("pl_bankgold", sNewGold),
                           SDB_SetRawField("pl_bankxp", sNewXP),
                           SDB_SetRawField("pl_kills", sNewKills),
                           SDB_SetField("pl_deaths", sDeaths)) +
           " WHERE PL_PLID = " + sPLID;
   CSLNWNX_SQLExecDirect(sSQL);

   string sLIID = SDB_GetLIID(oPC);
   string sKills= IntToString(GetLocalInt(oPC, SDB_KILLS));
   string sXP   = IntToString(GetXP(oPC));
   sSQL  = "update login set li_logout=now(), ";
   if (sActive=="0") { // LOGGING OUT
      string sGold = IntToString(SDB_NetWorth(oPC));
      string sAPLID= "0";
      string sSts  = (GetCurrentHitPoints(oPC)>0) ? "OK" : "DEAD";
      if (GetIsInCombat(oPC)) {
         object oLHA = GetLastHostileActor(oPC);
         if (GetIsPC(oLHA)) {
            sSts = "ATTACK";
            sAPLID = SDB_GetPLID(GetLastHostileActor(oPC));
         }
      }
      sSQL += CSLDelimList(SDB_SetField("li_stsout",  sSts), SDB_SetField("li_goldout", sGold), SDB_SetField("li_attackplid", sAPLID)) + ", ";
   }
   sSQL += CSLDelimList(SDB_SetField("li_kills",   sKills), SDB_SetField("li_xpout",   sXP));
   sSQL += " where li_liid=" + sLIID;
   CSLNWNX_SQLExecDirect(sSQL);
}

void SDB_OnModuleLoad()
{
   WriteTimestampedLogEntry("Started Server");
   // FRESHEN UP FOR OUR DATE
   CSLNWNX_SQLExecDirect("repair table account, area, cdkey, cdkeyaccount, dberrors, faction, factionmember, factionvsfaction, login, monster, monstervsplayer, playerlevel, player, playervsmonster, playervsplayer, session, temporaryban");
   CSLNWNX_SQLExecDirect("optimize table account, area, cdkey, cdkeyaccount, dberrors, faction, factionmember, factionvsfaction, login, monster, monstervsplayer, playerlevel, player, playervsmonster, playervsplayer, session, temporaryban");
   SDB_GetSEID(); // CREATE A NEW SESSION
   CSLNWNX_SQLExecDirect("delete from temporaryban where tb_expires<=now()"); // UNBAN THE TEMPS
   CSLNWNX_SQLExecDirect("delete from pwdata where adddate(last, expire)<now() and expire > 0"); // PURGE PW DATA
   CSLNWNX_SQLExecDirect("delete from chattext where ct_added < date_add(now(), interval -5 day)"); // PURGE CHAT DATA THAT IS 5 DAYS OLD OR MORE
   CSLNWNX_SQLExecDirect("update player set pl_active=0 where pl_active<>0");
}

void SDB_OnClientEnter(object oPC) // CALL ON CLIENT ENTER
{
   if (GetIsSinglePlayer()) return; // LOCAL MODE, SKIP THIS CRAP
   if (GetIsDM(oPC)) return; // Don't record dm clients
   // CLEAR ALL OLD ID'S - THIS WILL RELOAD ACCOUNT DATA THAT MAY BE IN THE DATABASE BUT STORED LOCALLY - IT MAY HAVE BEEN ACCESSED BY ANOTHER CHAR
   DeleteLocalString(oPC, SDB_LIID);
   DeleteLocalString(oPC, SDB_CKID);
   DeleteLocalString(oPC, SDB_ACID);
   DeleteLocalString(oPC, SDB_PLID);
   DeleteLocalString(oPC, SDB_CAID);
   DeleteLocalString(oPC, SDB_PVID);
   DeleteLocalString(oPC, SDB_BANNED);
   // SET UP THE ID'S
   SDB_GetLIID(oPC); // DOES ALL DB WORK FOR CHARACTER, GETS EXISTING ID ELSE CREATES NEW
   SDB_GetPVID(oPC); // GET PLAYER LEVEL RECORD (it's not used now but we'll need it) OTHER GOTTEN IN GETLIID
   // CHECK PERMANENT BAN
   if (!SDB_ValidName(oPC)) return; // VALIDATE ACCOUNT & PC NAME OR BOOT
   string sBan = GetLocalString(oPC, SDB_BANNED);
   if (sBan!="" && SDB_GetSEID()!="-1")
   { // BAD PLAYER! BAD!
      SDB_BootPC(oPC, "Sorry, this " + sBan + " is banned. Your login attempt has been recorded.", "SDB_PCLogIn: Banned " + sBan + " attempted log in.");
      return;
   }
   if (SDB_CheckTempBan(oPC) && SDB_GetSEID()!="-1") {
      sBan = "You are banned until " + GetLocalString(oPC, SDB_BANNED) + ".\n<color=red>DM REASON: " + GetLocalString(oPC, SDB_BANREASON) + "\n";
      SDB_BootPC(oPC, sBan , "SDB_PCLogIn: Temp Ban expiring on" + sBan + " attempted log in.");
      return;
   }
   // UP SESSION COUNT
   SDB_UpdateSessionCnt(1);
   // SET UP SESSION VARS
   SetLocalInt(oPC, SDB_TIME, CSLTimeStamp());    // SAVE TIME FOR RECORDING HOW LONG PLAYER PLAYED CHARACTER
   SetLocalInt(oPC, SDB_XP, GetXP(oPC)); // VAR TO ACCUM XP
   SetLocalInt(oPC, SDB_KILLS, 0);       // VAR TO ACCUM KILLS
   SetLocalInt(oPC, SDB_KILLS_NEW, 0);
   int iDamage = GetLocalInt(oPC, SDB_DAMAGE);
   if (iDamage > 0) // PLAYER LOGGED OUT WITH DAMAGE, REAPPLY NOW, no longer an issue actually
   {
      if (GetMaxHitPoints(oPC)<=iDamage) // KILL EM
      {
         //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE, TRUE), oPC);
         //SetLocalInt(oPC, SDB_NO_DEATH_PEN, TRUE);
      } 
      else if (iDamage>0) // HURT EM
      {
         //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE), oPC);
      }
   }
   DeleteLocalInt(oPC, SDB_DAMAGE);
   SDB_UpdatePlayerStatus(oPC);
}

void SDB_OnClientExit(object oPC)  // CALL ON CLIENT EXIT
{
	if (GetIsDM(oPC)) return; // Don't record dm clients
   if (GetLocalString(oPC, SDB_BANNED)!="") return;   // DON'T DO ANYTHING IF BOOTING A BANNED PLAYER CAUSE WE DIDN'T WHEN THEY ENTERED
   string sLIID = SDB_GetLIID(oPC);
   string sKills= IntToString(GetLocalInt(oPC, SDB_KILLS));
   string sGold = IntToString(SDB_NetWorth(oPC));
   string sXP   = IntToString(GetXP(oPC));
   string sSts  = (GetCurrentHitPoints(oPC)>0) ? "OK" : "DEAD";
   string sAPLID= "0";
   if (GetIsInCombat(oPC)) {
      object oLHA = GetLastHostileActor(oPC);
      if (GetIsPC(oLHA)) {
         sSts = "ATTACK";
         sAPLID = SDB_GetPLID(oLHA);
      }
   }
   string sSQL  = "update login set li_logout=now(), " +
        CSLDelimList(SDB_SetField("li_kills",   sKills),
                      SDB_SetField("li_xpout",   sXP),
                      SDB_SetField("li_stsout",  sSts),
                      SDB_SetField("li_goldout", sGold),
                      SDB_SetField("li_attackplid", sAPLID)) +
                   " where li_liid=" + sLIID;
   CSLNWNX_SQLExecDirect(sSQL);
   SDB_UpdateSessionCnt(-1);
   SDB_UpdatePlayerStatus(oPC, "0");
}

void SDB_OnAreaEnter(object oArea)
{
	
   object oPC = GetEnteringObject();
   if (GetIsDM(oPC)) return; // Don't record dm clients
   if (!GetIsPC(oPC)) return;
   string sARID = SDB_GetARID(oArea);
   if (sARID=="0") return;
   CSLIncrementLocalInt(oArea, "ENTERED" + sARID);
   if (GetLocalInt(oArea, "ENTERED" + sARID)>3) {
      string sSQL = "update area set ar_entered=ar_entered+3 where ar_arid=" + sARID;
      CSLNWNX_SQLExecDirect(sSQL);
      CSLIncrementLocalInt(oArea, "ENTERED" + sARID, -3);
   }
}

int SDB_OnPCDeath(object oKilled, object oKiller) // CALL ON PLAYER DEATH
{
   if (GetIsDM(oKiller)) return 0;
   int iLevel = GetHitDice(oKilled);
   string sSQL;
   string sSEID = SDB_GetSEID();
   string sARID = SDB_GetARID(GetArea(oKilled));
   string sPLID = SDB_GetPLID(oKilled);
   string sPVID = SDB_GetPVID(oKilled);
   string sLevel = IntToString(iLevel);
   int nDeaths = 0;
   if (GetLocalInt(oKilled, SDB_NO_DEATH_PEN)) { // MODULE KILLED THEM FOR SOME REASON, SO DONT INC DEATH COUNT
      DeleteLocalInt(oKilled, SDB_NO_DEATH_PEN);
   } else {
      nDeaths = CSLIncrementLocalInt(oKilled, SDB_DEATHS);
   }
   if (GetIsPC(oKiller)) {
      int nKLevel = GetHitDice(oKiller);
      string skPLID = SDB_GetPLID(oKiller);
      string skPVID = SDB_GetPVID(oKiller);
      string skLevel = IntToString(nKLevel);
      int nXPPerLevel = 5 * CSLGetMax(0, 5 - (nKLevel - iLevel)); // DON'T GO NEGATIVE
      int nKillsThisLevel;
      int nXP = nXPPerLevel * iLevel;
      int nKilledBankXP = SDB_GetPCBankXP(oKilled);
      int nKillerBankXP = SDB_GetPCBankXP(oKiller);
      nXP = CSLGetMin(nKilledBankXP, nXP); // BANK CAN'T GO NEG
      string skXP = IntToString(nXP);
      FloatingTextStringOnCreature("<color=gold>** " + IntToString(nXP) + " PVP XP **", oKiller, TRUE);
      SendMessageToPC(oKiller, "Your XP cache adds " + IntToString(nXP) + "xp from the PvP Kill of " + GetFirstName(oKilled));
      SendMessageToPC(oKilled, "Your XP cache lost " + IntToString(nXP) + "xp from the PvP Kill by " + GetFirstName(oKiller));
      SDB_LogMsg("PVPXP", "lvl " + skLevel + " pvped " + sLevel + " transferred " + skXP + " XP from " + GetFirstName(oKilled), oKiller);
      SDB_IncPCBank(oKiller, nXP, 0);
      SDB_IncPCBank(oKilled, -nXP, 0);
      CSLIncrementLocalInt(oKilled, SDB_PKED);
      CSLIncrementLocalInt(oKilled, SDB_PKER);
      sSQL = "insert into playervsplayer (pp_seid, pp_arid, pp_plid, pp_pvid, pp_plevel, pp_kplid, pp_kpvid, pp_klevel, pp_xp) " +
           "values (" + CSLDelimList(sSEID, sARID, sPLID, sPVID, sLevel, skPLID, skPVID, skLevel, skXP) + ")";
      CSLNWNX_SQLExecDirect(sSQL);
      sSQL = "update player set pl_pked=pl_pked+1, pl_dlpked=now() where pl_plid=" + sPLID;
      CSLNWNX_SQLExecDirect(sSQL);
      sSQL = "update player set pl_pker=pl_pker+1, pl_dlpker=now() where pl_plid=" + skPLID;
      CSLNWNX_SQLExecDirect(sSQL);
   } else {
      string sMOID = SDB_GetMOID(oKiller);
      if (sMOID!="0") {
         sSQL = "insert into monstervsplayer (mp_seid, mp_arid, mp_moid, mp_plid, mp_pvid, mp_plevel)" +
              "values (" + CSLDelimList(sSEID, sARID, sMOID, sPLID, sPVID, sLevel) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "update monster set mo_kills=mo_kills+1 where mo_moid=" + sMOID;
         CSLNWNX_SQLExecDirect(sSQL);
      } else {
         WriteTimestampedLogEntry("No MOID on " + GetResRef(oKiller));
      }
   }
   SDB_UpdatePlayerStatus(oKilled); // SAVE PC STATUS
   return nDeaths;
}

void SDB_OnPCLevelUp(object oPC)
{
   SDB_GetPVID(oPC); // SAVE THE NEW LEVEL, FETCH IT'S ID
   int nECL = CSLGetRaceDataECLCap( GetSubRace(oPC) );//CSLGetECL(GetSubRace(oPC));
   if (GetHitDice(oPC)>=30-nECL) SDB_MovePCBankToAccount(oPC);
   SDB_UpdatePlayerStatus(oPC); // SAVE PC STATUS
}

void SDB_OnPCRest(object oPC)
{
	SDB_UpdatePlayerStatus(oPC); // SAVE PC STATUS
	string sUptime = CSLGetServerRemainingUpTime();
	if ( sUptime != "" )
	{
		SendMessageToPC(oPC, "Server reboots in " +sUptime + ".");
	}
	int nXP = GetXP(oPC) - GetLocalInt(oPC, SDB_XP);
	int nKills = GetLocalInt(oPC, SDB_KILLS);
	if (nKills!=0)
	{
		int nAvg = (nXP/nKills)+1;
		SendMessageToPC(oPC, "Since log in, you gained " + IntToString(nXP) + " xp for " + IntToString(nKills) + " kills.\nPer Kill Average (PKA) = " + IntToString(nAvg));
		nXP = GetHitDice(oPC)+1;
		nXP = ((nXP * (nXP - 1)) / 2) * 1000 - GetXP(oPC);
		nKills = nXP / nAvg;
		if (GetHitDice(oPC)<20)
		{
			if (nKills<420) SendMessageToPC(oPC, "You need " + IntToString(nXP) + " xp to level, or about " + IntToString(nKills) + " kills based on your PKA");
			else SendMessageToPC(oPC, "You need " + IntToString(nXP) + " xp to level. Kill something worth more XP if you ever want to level!");
		}
		if (nXP > 0) 
		{
			FloatingTextStringOnCreature(IntToString(nXP) + " xp TNL", oPC, TRUE);
		}
	}
}

void SDB_OnPCRespawn(object oPC)
{
   SDB_UpdatePlayerStatus(oPC); // SAVE PC STATUS
}

location SDB_GetBind(object oPC)
{
   return GetLocalLocation(oPC, SDB_BIND);
}

void SDB_SetBind(object oPC, location lBind)
{
   string sLoc = CSLSerializeLocation(lBind);
   SetLocalLocation(oPC, SDB_BIND, lBind);
   string sSQL = "update player set pl_bind = " + CSLInQs(sLoc) + " where pl_plid = " + SDB_GetPLID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
   if (!CSLNWNX_SQLFetch()) {
      SetCampaignLocation("SDB_BIND", "BIND", lBind, oPC);
      SendMessageToPC(oPC, "Obsidian Bound...");
   }
}

void SDB_OnPCBind(object oPC, object oBind=OBJECT_INVALID)
{
   if (oBind==OBJECT_INVALID) oBind=oPC;
   SDB_SetBind(oPC, GetLocation(oBind));
}

void SDB_OnMonsterDeath(object oMonster, object oPC, int nPartyCnt, int nXP = 0) // PUT IN LOOP THAT AWARDS XP TO PC'S
{
   string sMOID = SDB_GetMOID(oMonster);
   string sSQL;
   CSLIncrementLocalInt(oPC, SDB_KILLS);
   int nKills = CSLIncrementLocalInt(oPC, SDB_KILLS_NEW);
   if (nKills % 25 == 20) { // SAVE AFTER FIRST 20 KILLS, THEN EVERY 25
      SDB_UpdatePlayerStatus(oPC);
   }
   if (!GetLocalInt(oMonster, SDB_MONSTER_INSERT)) { // HAVE WE RECORDED THIS KILL YET?
      SetLocalInt(oMonster, SDB_MONSTER_INSERT, 1);
      int nMonsterKills = CSLIncrementLocalInt(GetModule(), SDB_KILLS_NEW+sMOID);
      int nModulus = 5;
      if (GetLocalInt(oMonster, "BOSS") || CSLStringStartsWith(GetTag(oMonster), "PLID_")) nModulus = 1;
      if (nMonsterKills>=nModulus) {
         CSLIncrementLocalInt(GetModule(), SDB_KILLS_NEW+sMOID, -nModulus);
         sSQL = "update monster set mo_dlkilled=now(), mo_killed=mo_killed+" + IntToString(nModulus) + " where mo_moid = " + sMOID;
         CSLNWNX_SQLExecDirect(sSQL);
      }
      if (GetLocalInt(oMonster, "BOSS")) { // SAVE BOSS KILLS TO DB
         string sSEID = SDB_GetSEID();
         string sARID = SDB_GetARID(GetArea(oPC));
         string sPLID = SDB_GetPLID(oPC);
         string sPVID = SDB_GetPVID(oPC);
         string sLevel = IntToString(GetHitDice(oPC));
         sSQL = "insert into playervsmonster (pm_seid, pm_arid, pm_moid, pm_plid, pm_pvid, pm_level, pm_xp, pm_partycnt) " +
                   "values (" + CSLDelimList(sSEID, sARID, sMOID, sPLID, sPVID, sLevel, IntToString(nXP), IntToString(nPartyCnt)) + ")";
        CSLNWNX_SQLExecDirect(sSQL);
        if (nPartyCnt==1) { // ONLY SAVE KILLS BY SMALL PARTIES
           int nPCHD = GetHitDice(oPC);
           int nMoHD = GetHitDice(oMonster)-2;
           if (nPCHD<nMoHD) {
              //string sRMID = SDB_GetRMID(oPC, oMonster);
           }
        }   
     }
  }
}

int SDB_CheckTempBan(object oPC)
{
   string sCKIDList = "";
   string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
   string sSQL = "select ca_ckid from cdkeyaccount where ca_acid=" + sACID; // FIND CD KEYS THIS ACCOUNT HAS EVER USED
   CSLNWNX_SQLExecDirect(sSQL);
   while(CSLNWNX_SQLFetch() == CSLSQL_SUCCESS) {
      sCKIDList = CSLDelimList(CSLNWNX_SQLGetData(1), sCKIDList); // BUILD A COMMA DELIM LIST OF CDKEYS FOR THIS CHARACTER
   }
   sSQL = "select tb_expires, tb_reason from temporaryban where tb_ckid in (" + sCKIDList + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch()==CSLSQL_SUCCESS) {
      string sDateTime = CSLNWNX_SQLGetData(1);
      string sReason = CSLNWNX_SQLGetData(2);
      SetLocalString(oPC, SDB_BANNED, sDateTime);
      SetLocalString(oPC, SDB_BANREASON, sReason);
      return TRUE;
   }
   return FALSE;
}

void SDB_ApplyBan(object oPC,  int nBanType = SDB_BANTYPE_TEMP, int nBanLength = 1, string sReason = "")
{
   string sCKID = SDB_GetCKID(oPC); // GET CDKEY TABLE ID
   string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
   string sPLID = SDB_GetPLID(oPC); // GET PLAYER TABLE ID
   string sCAID = SDB_GetCAID(oPC); // GET CDKEY-ACCOUNT LINK TABLE ID
   string sSQL;
   string sTime;
   switch (nBanType) {
      case SDB_BANTYPE_TEMP:
         sTime = CSLHoursInDays(nBanLength);
         sSQL = "insert into temporaryban (tb_acid, tb_ckid, tb_reason, tb_expires) values (" + CSLDelimList(sACID, sCKID, CSLInQs(sReason), "DATE_ADD(NOW(), INTERVAL " + IntToString(nBanLength) + " HOUR))");
         SDB_BootPC(oPC, "You have been temporarily banned for " + sTime + ", during which time you can reflect upon your actions.", "Banned! Temp Ban applied to expire on" + sTime);
         break;
      case SDB_BANTYPE_CKID:
         sSQL = "update cdkey set ck_ban = 1 where ck_ckid=" + sCKID;
         SDB_BootPC(oPC, "Your CDKey has been permanently banned from the module. All future attempts to log in with this CDKey will be denied.", "Perma-Banned! CDkey Ban delivered.");
         break;
      case SDB_BANTYPE_ACID:
         sSQL = "update account set ac_ban = 1 where ac_acid=" + sACID;
         SDB_BootPC(oPC, "This Account has been permanently banned from the module. All future attempts to log in with this Account will be denied.", "Perma-Banned! Account Ban delivered.");
         break;
      case SDB_BANTYPE_PLID:
         sSQL = "update player set pl_ban = 1 where pl_plid=" + sPLID;
         SDB_BootPC(oPC, "This Character has been permanently banned from the module. All future attempts to log in with this Character will be denied.", "Perma-Banned! Character Ban delivered.");
         break;
      case SDB_BANTYPE_CAID:
         sSQL = "update cdkeyaccount set ca_ban = 1 where ca_caid=" + sCAID;
         SDB_BootPC(oPC, "This CDKey/Account combination has been permanently banned from the module. All future attempts to log into this account using this CDKey will be denied.", "Perma-Banned! CDkey/Account Ban delivered.");
         break;
   }
   CSLNWNX_SQLExecDirect(sSQL);
}

void SDB_UpdateAnimosity(object oPC, int nAnimosity)
{
   SetLocalInt(oPC, SDB_ANIMOSITY, nAnimosity); // SAVE TO LOCAL
   string sSQL = "update account set ac_animosity=" + IntToString(nAnimosity) + " where ac_acid=" + SDB_GetACID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
}

void SDB_LogMsg(string sType, string sMsg, object oPC=OBJECT_INVALID)
{
   string sLIID = "0";
   string sACID = "0";
   string sPLID = "0";
   if (oPC!=OBJECT_INVALID)
   {
      sACID = SDB_GetACID(oPC);
      sPLID = SDB_GetPLID(oPC);
      sLIID = SDB_GetLIID(oPC);
      sMsg = "CK(" + SDB_GetCKID(oPC) + ") " + CSLGetMyPlayerName(oPC) + "/" + CSLGetMyName(oPC) + " : " + sMsg;
   }
   string sSQL = "insert into logmsg (lm_acid, lm_plid, lm_type, lm_msg, lm_liid) values (" + CSLDelimList(sACID, sPLID, CSLInQs(sType), CSLInQs(sMsg), sLIID) + ")";
   
   
   /*
   CREATE TABLE `logmsg` (
  `lm_lmid` mediumint(8) unsigned NOT NULL auto_increment,
  `lm_liid` mediumint(8) unsigned default '0',
  `lm_msg` varchar(255) default '',
  `lm_added` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `lm_type` varchar(45) default '',
  `lm_acid` mediumint(8) unsigned default NULL,
  `lm_plid` mediumint(8) unsigned default NULL,
  PRIMARY KEY  (`lm_lmid`),
  KEY `lm_liid` (`lm_liid`)
) ENGINE=MyISAM AUTO_INCREMENT=8691 DEFAULT CHARSET=latin1
   */
   
   
   
   CSLNWNX_SQLExecDirect(sSQL);
   WriteTimestampedLogEntry("SDB LOGMSG: " + sType + ": " + sMsg);
}

void SDB_SetXP(object oPC, int nXP, string sSource)
{
   string sMsg = sSource + ": Changing XP from " + IntToString(GetXP(oPC)) + " to " + IntToString(nXP);
   SDB_LogMsg("XPCHANGE", sMsg, oPC);
   SetXP(oPC, nXP);
}

void SDB_BankTransaction(object oPC, int nAmount, int nTranType=SDB_BANKTRANS_GOLD)
{
   int nGold = -1;
   int nXP = -1;
   if (nTranType==SDB_BANKTRANS_GOLD)
   {
      nGold = nAmount;
      nXP = SDB_GetBankXP(oPC); // NOT PASSED, NO CHANGE, KEEP SAME
   }
   else
   {
      nXP = nAmount;
      nGold = SDB_GetBankGold(oPC); // NOT PASSED, NO CHANGE, KEEP SAME
   }
   string sLIID = SDB_GetLIID(oPC); // GET LOG ID
   string sACID = SDB_GetACID(oPC); // GET ACCOUNT TABLE ID
   string sGold = IntToString(nGold);
   string sXP   = IntToString(nXP);
   string sSQL = "insert into banktransactions(bt_bankxpold, bt_bankgoldold, bt_acid, bt_liid, bt_bankgoldnew, bt_bankxpnew) " +
      "select ac_bankxp, ac_bankgold, " + CSLDelimList(sACID, sLIID, sGold, sXP) + " from account where ac_acid=" + sACID;
   CSLNWNX_SQLExecDirect(sSQL);
}

string SDB_GetNextToken(object oDM, object oPC, string sMsg)
{
   string sToken;
   string sSQL = "insert into tokentracker (tt_dmplid, tt_plid, tt_msg) values ("+ CSLDelimList(CSLInQs(SDB_GetPLID(oDM)), CSLInQs(SDB_GetPLID(oPC)), CSLInQs(sMsg)) + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   sSQL = "select last_insert_id() from tokentracker limit 1";
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch() != CSLSQL_ERROR)
   {
      sToken = CSLNWNX_SQLGetData(1);
      WriteTimestampedLogEntry("Kewpie #" + sToken + " " + sMsg);
   }
   else
   {
      WriteTimestampedLogEntry("No database! Token not fetched.");
      return "Invalid";
   }
   return sToken;
}


void SDB_SetIsShoutBanned(object oPC, int bFlag = 1, int bPerm = 0)
{
   int bMode = bFlag + bPerm;
   string sSQL = "update cdkey set ck_shoutban = " + IntToString(bMode) + " where ck_ckid = " + SDB_GetCKID(oPC);
   CSLNWNX_SQLExecDirect(sSQL);
   SetLocalInt(oPC, SDB_SHOUTBAN, bMode);
}

int SDB_GetIsShoutBanned(object oPC)
{
   return (GetLocalInt(oPC, SDB_SHOUTBAN)!=0);
}

//int SDB_GetIsPCDM(object oPC)
//{
//   return (GetLocalInt(oPC, SDB_DM)==1);
//}

void SDB_UpdateAccountPwd(object oPC, string sPwd)
{
   string sSQL = "update account set ac_pwd = " + CSLInQs(sPwd) + " where ac_acid = " + SDB_GetACID(oPC);
   if (sPwd=="") {
      SendMessageToPC(oPC, "Your account password has been cleared.");
   } else {
      SendMessageToPC(oPC, "Your account password has been set to '" + sPwd + "'. You can now access the online statistics for this account.");
   }
   CSLNWNX_SQLExecDirect(sSQL);
}

string SDB_GetRMID(object oPC, object oMonster)// GET OR CREATE A RANDOM MONSTER RECORD
{
   if (GetIsDM(oPC)) return "0";
   int iLevel = GetHitDice(oPC);
   string sLevel = IntToString(iLevel);
   string sRMID = GetLocalString(oPC, SDB_RMID + sLevel);
   string sSQL;
   if (sRMID=="") { // NO VARIABLE YET OR PLAYER HAS LEVELED, CREATE NEW
      sRMID = "0";
      string sPLID = SDB_GetPLID(oPC); // GET PLAYER TABLE ID
      sSQL = "select rm_rmid from randommonster where rm_plid = " + sPLID + " and rm_level = " + sLevel;
      CSLNWNX_SQLExecDirect(sSQL);
      int nRC = CSLNWNX_SQLFetch();
      if (nRC==CSLSQL_ERROR) // GOT NO RECORD IN DB, CREATE ONE
      {
         string sName = CSLGetMyName(oPC);
         string sRace = IntToString(GetSubRace(oPC));
         string sHP  = IntToString(GetMaxHitPoints(oPC));
         string sAC  = IntToString(GetAC(oPC));
         string sAB  = IntToString(GetTRUEBaseAttackBonus(oPC));
         string sSTR = IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE));
         string sCON = IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE));
         string sDEX = IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE));
         string sINT = IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE));
         string sWIS = IntToString(GetAbilityScore(oPC, ABILITY_WISDOM, TRUE));
         string sCHA = IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE));         
         string sC1  = IntToString(GetClassByPosition(1, oPC));
         string sC1L = IntToString(GetLevelByClass(GetClassByPosition(1, oPC),oPC));
         string sC2  = IntToString(GetClassByPosition(2, oPC));
         string sC2L = IntToString(GetLevelByClass(GetClassByPosition(2, oPC),oPC));
         string sC3  = IntToString(GetClassByPosition(3, oPC));
         string sC3L = IntToString(GetLevelByClass(GetClassByPosition(3, oPC),oPC));
         string sC4  = IntToString(GetClassByPosition(4, oPC));
         string sC4L = IntToString(GetLevelByClass(GetClassByPosition(4, oPC),oPC));
         sSQL = "insert into randommonster (rm_plid, rm_level, rm_name, rm_subrace, rm_hp, rm_ac, rm_ab, rm_str, rm_con, rm_dex, rm_int, rm_wis, rm_cha, rm_class1, rm_class1level, rm_class2, rm_class2level, rm_class3, rm_class3level, rm_class4, rm_class4level) " +
                   "values (" + CSLDelimList(sPLID, sLevel, CSLInQs(sName), sRace, sHP, sAC, sAB)  +
                          "," + CSLDelimList(sSTR, sCON, sDEX, sINT, sWIS, sCHA) + 
                          "," + CSLDelimList(sC1, sC1L, sC2, sC2L, sC3, sC3L, sC4, sC4L) + ")";
         CSLNWNX_SQLExecDirect(sSQL);
         sSQL = "select last_insert_id() from randommonster limit 1";
         CSLNWNX_SQLExecDirect(sSQL);
         nRC = CSLNWNX_SQLFetch();
         string sDB = "PCLVL" + sLevel;
         string sTag = "PLID_" + sPLID;
         StoreCampaignObject(sDB, sTag, oPC);
         string sMsg = " (" + sLevel + ") killed " + GetName(oMonster) + " (" + IntToString(GetHitDice(oMonster)) + ") stored in " + sDB + " as " + sTag;
         SDB_LogMsg("PCLVL", sMsg, oPC);
      }
      if (nRC != CSLSQL_ERROR) {
         sRMID = CSLNWNX_SQLGetData(1);
      }
      SetLocalString(oPC, SDB_RMID, SDB_RMID + sLevel);
   }
   sSQL = "update randommonster set rm_cnt=rm_cnt+1 where rm_rmid = '" + sRMID + "'";
   CSLNWNX_SQLExecDirect(sSQL);
   return sRMID;
}

//int SDB_GetPCDM(object oPC)
//{
//   return GetLocalInt(oPC, SDB_PC_DM);
//}

int SDB_GetPCSuper(object oPC) // used in seed crafter
{
   return GetLocalInt(oPC, SDB_PC_SUPER);
//   return GetIsSinglePlayer() || GetLocalInt(oPC, SDB_PC_SUPER);
}

string GetServerMsg()
{
   string sSQL = "select sm_msg from servermsg";
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch()) {
      return CSLNWNX_SQLGetData(1);
   }
   return "Please be sure to clear all overrides from other PW's when playing DEX.";
}

//void main(){}