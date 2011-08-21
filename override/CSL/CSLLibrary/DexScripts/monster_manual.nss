#include "_CSLCore_Nwnx"
#include "_CSLCore_Messages"
#include "_CSLCore_Strings"
#include "_CSLCore_Nwnx"
#include "_CSLCore_Class"
#include "_CSLCore_ObjectArray"
#include "_SCInclude_DynamConvos"
//#include "_SCUtility"

// PERSIST VARIABLE STRINGS
const string MM_CATS = "MM_CATS_";
const string MM_LIST = "MM_LIST";
const string MM_PAGE = "MM_PAGE";
const string CRLF = "\n";
// PAGES
const int PAGE_MENU_MAIN          = 0;  // View the list of options

// ACTIONS
const int ACTION_BACK_PAGE        = 20; // CONFIRM CURRENT ACTION
const int ACTION_END_CONVO        = 21; // END CONVERSATION

void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = MM_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = MM_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = MM_LIST);
int    GetPageOptionSelected(string sList = MM_LIST); 
int    GetPageOptionSelectedInt(string sList = MM_LIST); 
object GetPageOptionSelectedObject(string sList = MM_LIST);
string GetPageOptionSelectedString(string sList = MM_LIST);

string GetBackCat();
void   SetBackCat(string sFAQ);
string GetNextCat();
void   SetNextCat(string sFAQ);

object oLIST_OWNER = CSLGetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = MM_LIST)
{
   int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
   CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetInt(oLIST_OWNER, sList + "_SUB", nCurrent, nSubValue );
   
   //ReplaceIntElement(CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText)-1, nSelectionValue, sList, oLIST_OWNER);
   //AddIntElement(nSubValue, MM_LIST + "_SUB", oLIST_OWNER);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = MM_LIST)
{
   int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
	CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
	CSLDataArray_SetString(oLIST_OWNER, sList + "_SUB", nCurrent, sSubValue );
   
   //ReplaceIntElement(CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText)-1, nSelectionValue, sList, oLIST_OWNER);
   //CSLDataArray_PushString(oLIST_OWNER, MM_LIST + "_SUB", sSubValue);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = MM_LIST)
{
   int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
   CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetObject(oLIST_OWNER, sList + "_SUB", nCurrent, oSubValue );
   
   //ReplaceIntElement(CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText)-1, nSelectionValue, sList, oLIST_OWNER);
   //AddObjectElement( oLIST_OWNER, MM_LIST + "_SUB",oSubValue);
}

int GetPageOptionSelected(string sList = MM_LIST) {
   return CSLDataArray_GetInt( oLIST_OWNER, sList, CSLGetDlgSelection() );
}

int GetPageOptionSelectedInt(string sList = MM_LIST) {
   return CSLDataArray_GetInt( oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

string GetPageOptionSelectedString(string sList = MM_LIST) {
    return CSLDataArray_GetString(oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

object GetPageOptionSelectedObject(string sList = MM_LIST) {
   return CSLDataArray_GetObject(oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

string GetNextCat()
{
   return GetLocalString(oLIST_OWNER, MM_PAGE);
}

void SetNextCat(string nFAQ) {
   SetLocalString(oLIST_OWNER, MM_PAGE, nFAQ);
}

string GetBackCat() {
   return GetLocalString(oLIST_OWNER, MM_LIST + "_BACK");
}

void SetBackCat(string nFAQ) {
   SetLocalString(oLIST_OWNER, MM_LIST + "_BACK", nFAQ);
}

int ExistsInList(string sList, string sValue) {
   object oModule = GetModule();
   int nPos = 1;
   string sEle = CSLDataArray_FirstString(oModule, sList);
   while (sEle!="") { // LOOP OVER CAT LIST AND CHECK THE VALUES
      if (sEle==sValue) return nPos;
      nPos++; // LIST POSITION FOR OTHER LISTS
      sEle = CSLDataArray_NextString(oModule, sList);
   }
   return 0;
}

int AddIfNotInList(string sList, string sValue) {
   object oModule = GetModule();
   if (!ExistsInList(sList, sValue)) {
      int nNew = CSLDataArray_PushString(oModule, sList, sValue);
      return nNew;
   }
   return 0;
}

void LoadCategories() // LOAD MONSTER MANUAL CATEGORY DATA
{
   object oModule = GetModule();
   if (CSLDataArray_LengthString(oModule, MM_CATS + "_MAIN" )) return; // ONLY LOAD ON FIRST USE
   int nEle;
   CSLNWNX_SQLExecDirect("select mo_cat, mo_moid, mo_name, mo_cr from monster where mo_killed>20 and mo_prettyname<>'' order by mo_cat, mo_cr, mo_name");
   while (CSLNWNX_SQLFetch()) {
      string sCat  = CSLNWNX_SQLGetData(1);
      string sMOID = CSLNWNX_SQLGetData(2);
      string sName = CSLNWNX_SQLGetData(3);
      string sCR   = CSLNWNX_SQLGetData(4);
      // CHECK FOR SUB CATS
      string sSubCat;
      string sLast = "_MAIN";
      int nCnt = CSLNth_GetCount(sCat, "|");
      int i;
      for (i=1; i<=nCnt; i++)
      {
         sSubCat = CSLNth_GetNthElement(sCat, i, "|");
         AddIfNotInList(MM_CATS + sLast, sSubCat); // ADD IT TO THE CURRENT LIST IF NOT THERE ALREADY
         sLast = sSubCat; // SET LIST VARIABLE SO NEXT SUB CAT GOES TO THAT SUB LIST
      }
      CSLDataArray_PushString(oModule, MM_CATS + sLast, "CR " + sCR + ": " + sName);
      CSLDataArray_PushString(oModule, MM_CATS + sLast + "_MOID", sMOID);
   }
}

string GetMonsterAreas(string sMOID)
{
   object oModule = GetModule();
   string sArea = GetLocalString(oModule, "MOID_AREA_" + sMOID);
   if (sArea=="") { // NOT RUN YET
      CSLNWNX_SQLExecDirect("select distinct ar_name from area, monstervsplayer where ar_arid=mp_arid and mp_moid=" + sMOID);
      while (CSLNWNX_SQLFetch()) {
         if (sArea!="") sArea += ", ";
         sArea += CSLNWNX_SQLGetData(1);
      }
      if (sArea=="") sArea = "Unknown";
      SetLocalString(oModule, "MOID_AREA_" + sMOID, sArea);
   }
   return sArea;
}



string ShowMonsterData(string sMOID) {
   object oModule = GetModule();
   string sText = "Error - Missing Record";
   string sSQL = "select mo_name, mo_cr, mo_hp, mo_ac, mo_ab, mo_str, mo_con, mo_dex, mo_int, mo_wis, mo_cha, " +
                        "mo_class1, mo_class2, mo_class3, mo_class4, mo_class1level, mo_class2level, mo_class3level, mo_class4level, " +
                        "mo_killed, round(mo_kills/mo_killed * 100), date_format(mo_dlkilled,'%m/%d') from monster where mo_moid=" + sMOID;
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch()) {
      string sName = CSLNWNX_SQLGetData(1);
      string sCR   = CSLNWNX_SQLGetData(2);
      string sHP   = CSLNWNX_SQLGetData(3);
      string sAC   = CSLNWNX_SQLGetData(4);
      string sAB   = CSLNWNX_SQLGetData(5);
      string sSTR  = CSLNWNX_SQLGetData(6);
      string sCON  = CSLNWNX_SQLGetData(7);
      string sDEX  = CSLNWNX_SQLGetData(8);
      string sINT  = CSLNWNX_SQLGetData(9);
      string sWIS  = CSLNWNX_SQLGetData(10);
      string sCHA  = CSLNWNX_SQLGetData(11);
      int nC1      = CSLNWNX_SQLGetDataInt(12);
      int nC2      = CSLNWNX_SQLGetDataInt(13);
      int nC3      = CSLNWNX_SQLGetDataInt(14);
      int nC4      = CSLNWNX_SQLGetDataInt(15);
      string sC1L  = CSLNWNX_SQLGetData(16);
      string sC2L  = CSLNWNX_SQLGetData(17);
      string sC3L  = CSLNWNX_SQLGetData(18);
      string sC4L  = CSLNWNX_SQLGetData(19);
      string sKill = CSLNWNX_SQLGetData(20);
      string sRate = CSLNWNX_SQLGetData(21);
      string sDLK  = CSLNWNX_SQLGetData(22);

      int nCR   = StringToInt(sCR);   
      int nRate = StringToInt(sRate);
     
      sText  = CSLColorText("Name: ", COLOR_GREEN) + CSLColorText(sName, COLOR_YELLOW) + CRLF;
      sText += CSLColorText("Locations: ", COLOR_GREEN) + CSLColorText(GetMonsterAreas(sMOID), COLOR_YELLOW) + CRLF;
      sText += CSLColorText("Stats: ", COLOR_GREEN);
      sText += CSLColorText("CR "  , COLOR_YELLOW) + CSLColorText(sCR, COLOR_ORANGE);
      sText += CSLColorText("  HP ", COLOR_YELLOW) + CSLColorText(sHP, COLOR_ORANGE);
      sText += CSLColorText("  AC ", COLOR_YELLOW) + CSLColorText(sAC, COLOR_ORANGE);
      sText += CSLColorText("  AB ", COLOR_YELLOW) + CSLColorText(sAB, COLOR_ORANGE) + CRLF;

      sText += CSLColorText("Ability: ", COLOR_GREEN);
      sText += CSLColorText("ST "  , COLOR_YELLOW) + CSLColorText(sSTR, COLOR_ORANGE);
      sText += CSLColorText("  CN ", COLOR_YELLOW) + CSLColorText(sCON, COLOR_ORANGE);
      sText += CSLColorText("  DX ", COLOR_YELLOW) + CSLColorText(sDEX, COLOR_ORANGE);
      sText += CSLColorText("  IN ", COLOR_YELLOW) + CSLColorText(sINT, COLOR_ORANGE);
      sText += CSLColorText("  WI ", COLOR_YELLOW) + CSLColorText(sWIS, COLOR_ORANGE);
      sText += CSLColorText("  CH ", COLOR_YELLOW) + CSLColorText(sCHA, COLOR_ORANGE) + CRLF;

      sText += CSLColorText("Classes: ", COLOR_GREEN);
      sText += CSLColorText(CSLGetClassesDataAbbrev(nC1), COLOR_YELLOW) + CSLColorText(sC1L, COLOR_ORANGE);
      if (nC2!=CLASS_TYPE_INVALID) sText += CSLColorText("  " + CSLGetClassesDataAbbrev(nC2), COLOR_YELLOW) + " " + CSLColorText(sC2L, COLOR_ORANGE);
      if (nC3!=CLASS_TYPE_INVALID) sText += CSLColorText("  " + CSLGetClassesDataAbbrev(nC3), COLOR_YELLOW) + " " + CSLColorText(sC3L, COLOR_ORANGE);
      if (nC4!=CLASS_TYPE_INVALID) sText += CSLColorText("  " + CSLGetClassesDataAbbrev(nC4), COLOR_YELLOW) + " " + CSLColorText(sC4L, COLOR_ORANGE);

     sText += CRLF + CSLColorText("Kills: ", COLOR_GREEN);
      sText += CSLColorText("Killed " , COLOR_YELLOW) + CSLColorText(sKill, COLOR_ORANGE);
      sText += CSLColorText("  PC Kill Rate "   , COLOR_YELLOW) + CSLColorText(sRate + "%", COLOR_ORANGE);
      sText += CSLColorText("  DLK " , COLOR_YELLOW) + CSLColorText(sDLK, COLOR_ORANGE) + CRLF;
      int nXPatCR   = CSLGetMin(125, 50 + nCR * 5); // 125 CAP
      int nGoldatCR = CSLRoundToNearest(nCR * nXPatCR / 5);
      int nXPBCR    = CSLRoundToNearest(nXPatCR * CSLGetMin(25, (nCR-1) * 5) / 100);
      int nXPBParty = CSLRoundToNearest(nXPatCR * 15 / 100);
     nRate = CSLGetMin(4, CSLGetMax(0, nRate-1)); // SQUEEZE IT BETWEEN 0 & 4
      int nGoldMax  = CSLRoundToNearest(CSLGetMax(1, nCR) * (nXPatCR+nXPBCR) / (5-nRate));
      int nGoldParty= CSLRoundToNearest(CSLGetMax(1, nCR) * (nXPatCR+nXPBCR+nXPBParty) / (8-nRate));
      int nXPMax    = nXPatCR + nXPBCR + nXPBParty;
      sText += CSLColorText("XP Level=CR: "     , COLOR_GREEN);
      sText += CSLColorText("XP ", COLOR_YELLOW) + CSLColorText(IntToString(nXPatCR), COLOR_ORANGE);  
      sText += CSLColorText("  Gold ", COLOR_YELLOW) + CSLColorText(IntToString(nGoldatCR), COLOR_ORANGE) + CRLF;  
      sText += CSLColorText("XP Max (CR+5,Party4): "     , COLOR_GREEN);
      sText += CSLColorText("XP ", COLOR_YELLOW) + CSLColorText(IntToString(nXPMax) + " (" + IntToString(nXPatCR) + "+CR " + IntToString(nXPBCR) + "+Pty " + IntToString(nXPBParty) + ")", COLOR_ORANGE);
      sText += CSLColorText("  Gold ", COLOR_YELLOW) + CSLColorText(IntToString(nGoldParty), COLOR_ORANGE) + CRLF;
   }
   return sText;

}

void HandleSelection() {
   object oPC = CSLGetPcDlgSpeaker();
   object oModule = GetModule();
   int iSelection = CSLGetDlgSelection();
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   int nPos = GetPageOptionSelectedInt(); // THE RECORD NUMBER FROM TABLE TO DISPLAY
   string sShowCat = GetNextCat(); // THIS IS THE CATEGORY WE ARE VIEWING
   string sNextCat;
   int nCnt;
   switch (iOptionSelected) {
      case PAGE_MENU_MAIN:
         sNextCat = CSLDataArray_GetString(oModule, MM_CATS + sShowCat, nPos ); // RETRIEVE THE DATA FOR THE SELECTION
         nCnt = CSLDataArray_LengthString( oModule, MM_CATS + sNextCat); // DO WE HAVE ELEMENTS FOR THIS OR IS IT AN END POINT
         if (!nCnt) { // NO SUB ELEMENTS, DISPLAY THE RECORD
             string sMOID = CSLDataArray_GetString(oModule, MM_CATS + sShowCat + "_MOID",nPos );       
            FloatingTextStringOnCreature(ShowMonsterData(sMOID), oLIST_OWNER, FALSE);
            // NO NEED TO CHANGE THE CAT, WE'LL REDISPLAY THE SAME ONE
         } else {
            SetNextCat(sNextCat); // SET NEXT CAT TO DISPLAY AS THE NEW CAT
            SetBackCat(sShowCat); // SET BACK CAT AS THE SELECTED CAT
         }
         return;

      case ACTION_BACK_PAGE:
         SetNextCat(GetBackCat()); // GO BACK ONE
         return;

      case ACTION_END_CONVO:
         CSLEndDlg();
         return;
   }
}

void BuildPage() {
   object oModule = GetModule();
   object oPC = CSLGetPcDlgSpeaker();
   CSLDataArray_DeleteEntire(oLIST_OWNER, MM_LIST );        // CLEAR OLD OPTIONS
   CSLDataArray_DeleteEntire(oLIST_OWNER,MM_LIST+"_SUB" ); // CLEAR OLD OPTIONS
   string sShowCat = GetNextCat(); // THIS IS THE CATEGORY TO BUILD
   int nBack = 0;
   int nCnt = 0;
   CSLSetDlgPrompt("Welcome to the DEX Monster Manual. What would you like to know more about?");
   if ( sShowCat != "_MAIN" ) 
   {
	   AddMenuSelectionInt("[Back]", ACTION_BACK_PAGE, 0);
   }
   string sCat = CSLDataArray_FirstString(oModule, MM_CATS + sShowCat );
   while (sCat!="") { // LOOP OVER THE CAT LIST AND ADD IT"S SUBCATS TO MENU
      AddMenuSelectionInt(sCat, PAGE_MENU_MAIN, nCnt++); // ADD THE CATEGORY TO THE PAGE
      sCat = CSLDataArray_NextString(oModule, MM_CATS + sShowCat);
   }
}


void Init() {
   LoadCategories();
   SetNextCat("_MAIN"); // START AT THE ROOT NODE
}

void CleanUp() {
    DeleteLocalInt(oLIST_OWNER, MM_PAGE);
    CSLDataArray_DeleteEntire(oLIST_OWNER, MM_LIST );
    CSLDataArray_DeleteEntire(oLIST_OWNER, MM_LIST+"_SUB" );
}

void main() {
   int iEvent = CSLGetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage();
         CSLSetShowEndSelection(TRUE);
         CSLSetDlgResponseList(MM_LIST, oLIST_OWNER);
         break;
      case DLG_SELECTION:
         HandleSelection();
         break;
      case DLG_ABORT:
      case DLG_END:
         CleanUp();
         break;
   }
}