/*
    Include file to be included in the NPC's OnConversation script. Simply call
    either of the four DoStart...Crafter() functions from within main()

    06/01/15 * Seed       * Change CSLStartDlg to CSLOpenNextDlg
*/
//#include "dmfi_inc_conv"
#include "_SCInclude_Quest"
#include "_SCInclude_DynamConvos"

void main() {
   object oPC = GetLastSpeaker();
   object oNPC = OBJECT_SELF;
   if (NPCHasQuest(oNPC)) {
      string sQUID = GetQuestID(oNPC);
      if (PCAlreadyDidQuest(oPC, sQUID)) {
         SpeakString("Thanks for completing my " + GetQuestName(oNPC) + " quest");
         return;
      }
      CSLOpenNextDlg(oPC, oNPC, "seed_quest", TRUE, FALSE);
      return;
   }
   SpeakString("Don't look at me that way...");
}