#include "_CSLCore_Nwnx"
//#include "dmfi_inc_conv"
#include "_SCInclude_Quest"
#include "_SCInclude_DynamConvos"

// PERSIST VARIABLE STRINGS
const string QUEST_LIST        = "QUEST_LIST";

// ACTIONS
const int ACTION_COMPLETE         = 20; // COMPLETE THE QUEST
const int ACTION_DESCRIBE         = 21; // DESCRIBE THE QUEST
const int ACTION_END_CONVO        = 22; // END CONVERSATION

object oLIST_OWNER = CSLGetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void AddMenuSelection(string sSelectionText, int nSelectionValue) 
{
   CSLDataArray_SetInt(oLIST_OWNER, QUEST_LIST, CSLDataArray_PushString(oLIST_OWNER, QUEST_LIST, sSelectionText ), nSelectionValue );
}

int GetPageOptionSelected()
{
   return CSLDataArray_GetInt( oLIST_OWNER, QUEST_LIST, CSLGetDlgSelection() );
}

void HandleSelection()
{
   object oPC = CSLGetPcDlgSpeaker();
   object oNPC = OBJECT_SELF;
   string sName;
   string sDesc;
   DeleteLocalInt(oLIST_OWNER, "QUEST_PAGE");
   switch (GetPageOptionSelected()) {
      case ACTION_DESCRIBE: 
	     SetLocalInt(oLIST_OWNER, "QUEST_PAGE", 1);
//         sName = GetQuestName(oNPC);
//         sDesc = GetQuestDesc(oNPC);
//         FloatingTextStringOnCreature(CSLColorText(sName + " Quest\n", COLOR_GREEN) + sDesc, oPC);
         return;
      
      case ACTION_COMPLETE:
         GiveQuestReward(oPC, oNPC);
         CSLEndDlg();
         return;

      case ACTION_END_CONVO:
         CSLEndDlg();
         return;
   }
}

void BuildPage() {
   object oPC = CSLGetPcDlgSpeaker();
   object oNPC = OBJECT_SELF;
   CSLDataArray_DeleteEntire( oLIST_OWNER, QUEST_LIST );        // CLEAR OLD OPTIONS
   string sName = GetQuestName(oNPC);
   if (GetLocalInt(oLIST_OWNER, "QUEST_PAGE")) {
      CSLSetDlgPrompt(CSLColorText(sName + " Quest\n", COLOR_GREEN) + GetQuestDesc(oNPC));
      AddMenuSelection("Ok, I'll see what I can do!", ACTION_END_CONVO);
      AddMenuSelection("Sorry, I cannot help you.", ACTION_END_CONVO);
      return;
   }
   int bComplete = PCHasQuestItems(oPC, oNPC);
   string sHas = GetQuestItemsPCHas(oNPC); // MUST BE CALLED AFTER THE PCHasQuestItems CALL WHICH POPULATES THE VARIABLE
   if (bComplete==1) {
      CSLSetDlgPrompt("Great Job! You have obtained what was required to complete my " + sName + " quest. Do you wish to collect your reward now?");
      AddMenuSelection("Yes, take " + sHas + " and give me my reward.", ACTION_COMPLETE);
      AddMenuSelection("No, I think I'll keep the stuff and skip the reward.", ACTION_END_CONVO);
   } else if (bComplete==2) {
      CSLSetDlgPrompt("You are doing great! I see you have " + sHas + " but you still haven't completed all the " + sName + " quest requirements.");
      AddMenuSelection("Refresh my memory...what do I have to do?", ACTION_DESCRIBE);
      AddMenuSelection("I know, I working on it.", ACTION_END_CONVO);
   } else {
      CSLSetDlgPrompt("Would you be interested in completing my " + sName + " quest?");
      AddMenuSelection("It sounds intriguing...tell me more.", ACTION_DESCRIBE);
      AddMenuSelection("I don't think so.", ACTION_END_CONVO);
   }
}

void main() {
   int iEvent = CSLGetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         break;
      case DLG_PAGE_INIT:
         BuildPage();
         CSLSetShowEndSelection(FALSE);
         CSLSetDlgResponseList(QUEST_LIST, oLIST_OWNER);
         break;
      case DLG_SELECTION:
         HandleSelection();
         break;
      case DLG_ABORT:
      case DLG_END:
         CSLDataArray_DeleteEntire( oLIST_OWNER, QUEST_LIST );
         break;
   }
}