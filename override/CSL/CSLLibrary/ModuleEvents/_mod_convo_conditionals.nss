// Consolidate any miscellaneous conversation actions in here
// this will keep the number of scripts to a minimum.
#include "_SCInclude_Healer"
#include "_SCInclude_Quest"
#include "seed_db_inc"

int StartingConditional(string sAction)
{
   object oPC = GetPCSpeaker();
   object oNPC = OBJECT_SELF;

   if (CSLStringStartsWith(sAction, "HEALER_")) {
      return DoHealer(sAction, TRUE);

   } else if (sAction=="HASBANK") {
      int nGold = SDB_GetBankGold(oPC);
     int nXP = SDB_GetBankXP(oPC);
     if (nGold+nXP==0) SpeakString("Take a look to the sky just before you die. It is the last time you will.");
     return (nGold+nXP)>0;

   } else if (sAction=="HASBANKGOLD") {
      int nGold = SDB_GetBankGold(oPC);
     SetCustomToken(55001, IntToString(nGold));
     return nGold>0;

   } else if (sAction=="HASBANKXP") {
     int nXP = SDB_GetBankXP(oPC);
     SetCustomToken(55002, IntToString(nXP));
     return nXP>0;

   } else if (sAction=="ISLEVEL1") {
      if (GetXP(oPC) < 190000) return TRUE;
      return GetHitDice(oPC)==1;

   } else if (sAction=="HASQUEST") {
      if (NPCHasQuest(oNPC)) {
         string sQUID = GetQuestID(oNPC);
         string sQuest = GetQuestName(oNPC);
         if (PCAlreadyDidQuest(oPC, sQUID)) {
            SpeakString("Thanks for completing my " + sQuest + " quest");
            return FALSE;
         }
         SetCustomToken(55003, sQuest);
         return TRUE;
      }
      return FALSE;

   } else if (sAction=="INDADU_BOAT") {
      int iHD;
      int nCnt = 0;
      int nParty = 0;
      int nMax = 0;
      object oParty = GetFirstFactionMember(oPC);
      while (GetIsObjectValid(oParty))
	  {
         if ( CSLPCIsClose(oPC, oParty, 15) )
		 {
            iHD = GetHitDice(oParty);
            nCnt++;
            nParty += iHD;
            nMax = CSLGetMax(nMax, iHD);
         }
         oParty = GetNextFactionMember(oPC);
      }
      string sMsg = "The party has " + IntToString(nCnt) + CSLAddS(" member", nCnt) + ".\n";
      sMsg += "The party has " + IntToString(nParty) + " total levels.\n";
      sMsg += "The party max is level " + IntToString(nMax) + ".\n\n";
      if (nCnt < 6 && nParty < 56 && nMax < 14) {
         sMsg += "<color=limegreen>Your party fits in the boat!";
         PlaySound("as_cv_bellship1");
         SetLocalInt(OBJECT_SELF, "BOAT", TRUE);
      } else {
         sMsg += "<color=pink>Your party cannot fit the boat.";
         DeleteLocalInt(OBJECT_SELF, "BOAT");
      }
      SetCustomToken(55004,sMsg);
      return TRUE;

   } else if (sAction=="INDADU_BOAT2") {
      return GetLocalInt(OBJECT_SELF, "BOAT");

   }
   return TRUE;
}