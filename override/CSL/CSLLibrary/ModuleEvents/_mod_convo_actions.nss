// Consolidate any miscellaneous conversation actions in here
// this will keep the number of scripts to a minimum.

#include "_SCInclude_Healer"
#include "_SCInclude_faction"
#include "seed_db_inc"
#include "_SCInclude_Graves"
#include "_SCInclude_DynamConvos"

void main(string sAction) {
   object oPC = GetPCSpeaker();
   object oNPC = OBJECT_SELF;
   object oLocator;

   if (CSLStringStartsWith(sAction, "HEALER_")) {
      DoHealer(sAction);

   } else if (sAction == "FACTIONACCEPT") {
      SDB_FactionAdd(oPC, GetLocalObject(oPC, "FACTION_SPEAKER"));
      DeleteLocalObject(oPC, "FACTION_SPEAKER");

   } else if (sAction == "GIVEBANKGOLD") {
      int nGold = SDB_GetBankGold(oPC);
      GiveGoldToCreature(oPC, nGold);
      SDB_SetBankGold(oPC, 0);

   } else if (sAction == "GIVEBANKXP") { 
      int nXP = GetXP(oPC); // + SDB_GetBankXP(oPC);
      if (nXP > 190000) {
          SendMessageToPC(oPC, "Sorry, you can only claim XP with a character under level 20.");
          return;
      }
      int nNeededXP = CSLGetMax(0, 190000 - nXP);
      int nBank = SDB_GetBankXP(oPC);
      if (nNeededXP>nBank) nNeededXP = nBank;
      SDB_SetXP(oPC, nXP + nNeededXP, "CONVO");
      SDB_SetBankXP(oPC, nBank-nNeededXP);

   } else if (sAction == "QUEST") {
      CSLOpenNextDlg(oPC, oNPC, "seed_quest", TRUE, FALSE);

   } else if (sAction == "INDADU_BOAT") {
      object oBoat = GetItemPossessedBy(oPC, "foldingboat");
      if (oBoat==OBJECT_INVALID) {
         SendMessageToPC(oPC, "Your boat has gone missing.");
         return;
      }
      int iHD;
      int nCnt = 0;
      int nParty = 0;
      int nMax = 0;
      DeleteLocalInt(OBJECT_SELF, "BOAT");
      oNPC = GetFirstFactionMember(oPC);
      while (GetIsObjectValid(oNPC)) {
         if (CSLPCIsClose(oPC, oNPC, 15)) {
          iHD = GetHitDice(oNPC);
          nCnt++;
         nParty += iHD;
         nMax = CSLGetMax(nMax, iHD);
         }
         oNPC = GetNextFactionMember(oPC);
      }
      if (nCnt < 6 && nParty < 56 && nMax < 14) {
         oLocator = GetObjectByTag("WP_INDADU_BOAT");
         DestroyObject(oBoat);
         oNPC = GetFirstFactionMember(oPC);
         while (GetIsObjectValid(oNPC)) {
            if (oPC!=oNPC && CSLPCIsClose(oPC, oNPC, 15)) DoPortOut(oNPC, GetLocation(oLocator));
            oNPC = GetNextFactionMember(oPC);
         }
         AssignCommand(oPC, JumpToObject(oLocator));
      } else {
         SendMessageToPC(oPC, "Your party no longer fits in the boat.");
      }
   }
}