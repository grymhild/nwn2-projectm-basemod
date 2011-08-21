#include "_SCInclude_Graves"


int StartingConditional(string sAction) {
   object oPC = GetPCSpeaker();
   object oGrave = GetGrave(oPC);
   if (sAction=="HASGRAVE") {
      return oGrave!=OBJECT_INVALID;
   } else if (sAction=="ISMYGRAVE") {
      if (oGrave==OBJECT_SELF) {
         string sGold = IntToString(GetDeathGold(oGrave));
         string sXP = IntToString(GetDeathXP(oPC));
         SetCustomToken(113, sGold + " gold and " + sXP + " xp");
         return TRUE;
      }
      SetCustomToken(113, GetGraveOwnerName(OBJECT_SELF)); // The grave does not belong to the speaker. Set a token with the owner name
      return FALSE;
   } else if (sAction=="CANPRAY") {
      return !GetHasPrayed(oPC);
   } else if (sAction=="HASRETURNPORTAL") {
      return HasReturnPortal(oPC);
   }
   return TRUE;
}