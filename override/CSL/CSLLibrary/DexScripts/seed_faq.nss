#include "_CSLCore_Nwnx"
#include "_CSLCore_Messages"
#include "_CSLCore_ObjectArray"
#include "_SCInclude_DynamConvos"

const string SDB_FAQ_LIST          = "FAQ_";

// PERSIST VARIABLE STRINGS
const string FAQ_LIST        = "FAQ_LIST";
const string FAQ_PAGE        = "FAQ_PAGE";

// PAGES
const int PAGE_MENU_MAIN          = 0;  // View the list of options

// ACTIONS
const int ACTION_BACK_PAGE        = 20; // CONFIRM CURRENT ACTION
const int ACTION_END_CONVO        = 21; // END CONVERSATION

int    GetPageOptionSelected(string sList = FAQ_LIST);
int    GetPageOptionSelectedInt(string sList = FAQ_LIST);
object GetPageOptionSelectedObject(string sList = FAQ_LIST);
string GetPageOptionSelectedString(string sList = FAQ_LIST);

string GetBackCat();
void   SetBackCat(string sFAQ);
string GetNextCat();
void   SetNextCat(string sFAQ);

object oLIST_OWNER = CSLGetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST


void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = FAQ_LIST)
{
   int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
   CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetInt(oLIST_OWNER, sList + "_SUB", nCurrent, nSubValue );
   //CSLDataArray_SetInt(oPC, sList, CSLDataArray_PushString( oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) ), nSelectionValue );
   //CSLDataArray_PushInt(oPC, CRAFTER_LIST + "_SUB", nSubValue);
}

void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = FAQ_LIST)
{
	int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
	CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
	CSLDataArray_SetString(oLIST_OWNER, sList + "_SUB", nCurrent, sSubValue );
}

void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = FAQ_LIST)
{
   int nCurrent = CSLDataArray_PushString(oLIST_OWNER, sList, sSelectionText );
   CSLDataArray_SetInt(oLIST_OWNER, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetObject(oLIST_OWNER, sList + "_SUB", nCurrent, oSubValue );
   //CSLDataArray_SetInt( oPC, sList, CSLDataArray_PushString( oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) ), nSelectionValue );
   //CSLDataArray_PushObject( oPC, CRAFTER_LIST+"_SUB", oSubValue);
}

int GetPageOptionSelected(string sList = FAQ_LIST) {
   return CSLDataArray_GetInt( oLIST_OWNER, sList, CSLGetDlgSelection() );
}

int GetPageOptionSelectedInt(string sList = FAQ_LIST)
{
   return CSLDataArray_GetInt( oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

string GetPageOptionSelectedString(string sList = FAQ_LIST) {
   return CSLDataArray_GetString(oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

object GetPageOptionSelectedObject(string sList = FAQ_LIST) {
   return CSLDataArray_GetObject(oLIST_OWNER, sList + "_SUB", CSLGetDlgSelection() );
}

string GetNextCat() {
   return GetLocalString(oLIST_OWNER, FAQ_PAGE);
}

void SetNextCat(string nFAQ) {
   SetLocalString(oLIST_OWNER, FAQ_PAGE, nFAQ);
}

string GetBackCat() {
   return GetLocalString(oLIST_OWNER, FAQ_LIST + "_BACK");
}

void SetBackCat(string nFAQ) {
   SetLocalString(oLIST_OWNER, FAQ_LIST + "_BACK", nFAQ);
}

void HandleSelection() {
   object oPC = CSLGetPcDlgSpeaker();
   object oModule = GetModule();
   int iSelection = CSLGetDlgSelection();
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   int nPos = GetPageOptionSelectedInt(); // THE RECORD NUMBER FROM THE FAQ TABLE TO DISPLAY
   string sCat;
   string sSubCat;
   string sText;
   string sAnswer;
   switch (iOptionSelected) {

      case PAGE_MENU_MAIN:
         sCat    = CSLDataArray_GetString(oModule, SDB_FAQ_LIST+"CAT", nPos ); // RETRIEVE THE DATA FOR THIS RECORD FROM THE MODULE
         sSubCat = CSLDataArray_GetString(oModule, SDB_FAQ_LIST+"SUB", nPos);
         sText   = CSLDataArray_GetString(oModule, SDB_FAQ_LIST+"TXT", nPos);
         sAnswer = CSLDataArray_GetString(oModule, SDB_FAQ_LIST+"ANS", nPos);
         if (sAnswer!="") { // WE HAVE AN ANSWER FOR THIS NODE, SHOW IT
            FloatingTextStringOnCreature(CSLColorText(sText, COLOR_GREEN) + "\n" + sAnswer, oLIST_OWNER);
         } else { // WE DON'T HAVE AN ANSWER SO IT MUST BE A REAL SUB CAT WITH MORE QUESTIONS
            SetNextCat(sSubCat); // SET NEXT CAT TO DISPLAY AS THE CURRENT SUBCAT
            SetBackCat(sCat);
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
   string sShowCat = GetNextCat(); // THIS IS THE CATEGORY TO BUILD

   CSLDataArray_DeleteEntire(oLIST_OWNER, FAQ_LIST );        // CLEAR OLD OPTIONS
   CSLDataArray_DeleteEntire(oLIST_OWNER, FAQ_LIST+"_SUB"); // CLEAR OLD OPTIONS
   int nBack = 0;
   int nPos = 0;
   string sCat = CSLDataArray_FirstString( oModule, SDB_FAQ_LIST+"CAT" );
   while (sCat!="") { // LOOP OVER THE CAT LIST AND ADD IT"S SUBCATS TO MENU
      if (sShowCat==sCat) {
         string sSubCat = CSLDataArray_GetString(oModule, SDB_FAQ_LIST + "SUB", nPos);
         string sText   = CSLDataArray_GetString(oModule, SDB_FAQ_LIST + "TXT", nPos);
         if (sSubCat=="") {
            CSLSetDlgPrompt(sText);
         } else {
            AddMenuSelectionInt(sText, PAGE_MENU_MAIN, nPos); // SAVE THE LIST POSITION OF THIS ENTRY
         }
      }
      nPos++; // LIST POSITION FOR OTHER LISTS
      sCat = CSLDataArray_NextString( oModule, SDB_FAQ_LIST+"CAT");
   }
   if (sShowCat!="_MAIN") AddMenuSelectionInt("[Back]", ACTION_BACK_PAGE, 0);
}

void SDB_LoadFAQData() { // LOAD MASTER FAQ DATA ON MODULE
   object oModule = GetModule();   
   if (CSLDataArray_LengthString( oModule, SDB_FAQ_LIST+"CAT" )) return; // ONLY LOAD ON FIRST USE
   //int nEle;
   CSLNWNX_SQLExecDirect("select fq_cat, fq_subcat, fq_text, fq_answer from faq order by fq_cat, fq_seq");
   while (CSLNWNX_SQLFetch()) {
      string sCat    = CSLNWNX_SQLGetData(1);
      string sSubCat = CSLNWNX_SQLGetData(2);
      string sText   = CSLNWNX_SQLGetData(3);
      string sAnswer = CSLNWNX_SQLGetData(4);
      // MAKE 4 LISTS
      CSLDataArray_PushString( oModule, SDB_FAQ_LIST + "CAT", sCat );
      CSLDataArray_PushString( oModule, SDB_FAQ_LIST + "SUB", sSubCat );
      CSLDataArray_PushString( oModule, SDB_FAQ_LIST + "TXT", sText );
      CSLDataArray_PushString( oModule, SDB_FAQ_LIST + "ANS", sAnswer );
   }
}


void Init() {
   SDB_LoadFAQData(); 
   SetNextCat("_MAIN"); // START AT THE ROOT NODE
}

void CleanUp() {
    DeleteLocalInt(oLIST_OWNER, FAQ_PAGE);
    CSLDataArray_DeleteEntire(oLIST_OWNER, FAQ_LIST );
    CSLDataArray_DeleteEntire(oLIST_OWNER, FAQ_LIST+"_SUB" );
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
         CSLSetDlgResponseList(FAQ_LIST, oLIST_OWNER);
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