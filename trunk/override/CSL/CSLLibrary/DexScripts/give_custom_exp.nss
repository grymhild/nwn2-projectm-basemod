//#include "dmfi_inc_sendtex"

#include "seed_db_inc"
#include "_SCInclude_faction"
#include "_CSLCore_Player"

const int XPBASE      = 150; //75;
const int XPPERCR     = 12; //10;
const int XPCAP       = 300; //250;
const int GOLDDIVISOR = 6; //+Party Size
 
string AddXPText(int nAmount, string sType)
{
	if (!nAmount)
	{
		return "";  // DON'T ADD 0
	}
	
	if ( nAmount >= 0 )
	{
		return CSLColorText(" + " + IntToString(nAmount) + " " + sType + "Bonus", COLOR_GREEN);
	}
	else
	{
		return CSLColorText(" - " + IntToString(-nAmount) + " " + sType + "Penalty", COLOR_RED);
	}
}

void DEXRewardXP(object oKiller, object oDead) {
   if (GetLocalInt(oDead, "AlreadyDyingEXP")) {
      DeleteLocalInt(oDead, "AlreadyDyingEXP");
      return;
   }
   if (oKiller==OBJECT_INVALID) return;
   if (GetFactionEqual(oKiller, oDead)) {
      SendMessageToPC(oKiller, "No XP given - Same faction as " + GetName(oDead));
      return;
   }   
   SetLocalInt(oDead, "AlreadyDyingEXP", TRUE);
   int iLevel = 0;
   int bIsVamp = CSLStringStartsWith(GetTag(oDead), "VAMP_");
   int nCR = CSLGetMin(40, CSLGetMax(FloatToInt(CSLGetChallengeRating(oDead)), 0)); // FORCE TO INT AND USE MIN 0 and MAX 40
   if (CSLStringStartsWith(GetTag(oDead), "PLID_")) nCR = GetHitDice(oDead) + 2;
   if (bIsVamp) nCR = GetHitDice(oDead) - 3;
   int nXPBase;
   int nCRBonus;
   int nPartyBonus;
   int nXPAwarded;
   int nXPGiven;
   int nXPEarned;
   int nGold;
   string sText;
   int nLeech;
   int nECL;
   int nMaxXP;

   if (GetMaster(oKiller) != OBJECT_INVALID) {
      oKiller = GetMaster(oKiller);
   }

   int nMinLevel = CSLGetRealLevel(oKiller); // INIT TO THE KILLER'S LEVEL
   int nMaxLevel = nMinLevel; // KILLER'S LEVEL IS THE MIN AND THE MAX
   int nPartyCount = 1; // COUNT KILLER IN PARTY

   object oPartyMember = GetFirstFactionMember(oKiller, FALSE);
   while (GetIsObjectValid(oPartyMember)) {
      if (GetIsPC(oPartyMember)) { // ONLY PC'S COUNT
         if (oPartyMember!=oKiller) { // DON'T RECOUNT THE KILLER, THEY ARE COUNTED IN INIT CAUSE THEY ALWAYS COUNT REGARDLESS OF DISTANCE
            if (CSLPCIsClose(oPartyMember, oDead, 27 ) )
			{ // MUST BE WITHIN 27 METERS AND ALIVE TO GET COUNTED, adjusted up from 18
               nPartyCount++;
               iLevel = CSLGetRealLevel(oPartyMember);
               nMinLevel = CSLGetMin(nMinLevel, iLevel);
               nMaxLevel = CSLGetMax(nMaxLevel, iLevel);
            }
         }
      }
      oPartyMember = GetNextFactionMember(oKiller, FALSE);
   } 

   // CALC THE DIFFERENCE BETWEEN PARTY LEVEL AND MONSTER CR
   int nCRDiff = CSLGetMax(nMaxLevel - nCR, -5);  // changed to -5, was at 0, which made first line of <<CALC CR BONUS/PENALTY>> not do anything.

   // CALC BASE XP
   int nXPCap = CSLRoundToNearest(XPCAP + nCR);
   nXPBase = CSLGetMin(nXPCap, XPBASE + nCR * XPPERCR);
   if (GetLocalInt(oKiller, "BOSS")) nXPBase *=5;
   
   // CALC CR BONUS/PENALTY
   nCRBonus = 0;
   if      (nCRDiff < 0) nCRBonus = nXPBase * CSLGetMin(25, -nCRDiff * 5) / 100;        // Bonus of 5% per CR Diff, Max 25%
   else if (nCRDiff > 4) nCRBonus = -nXPBase * 99 / 100;                  // loss of 99%
   else if (nCRDiff > 0) nCRBonus = -nXPBase * (10 + (nCRDiff - 1) * 20) / 100;  // loss of 10-70%
   nCRBonus = CSLRoundToNearest(nCRBonus);

   // CALC PARTY BONUS/PENALTY
   nPartyBonus = 0;
   if (nPartyCount > 5) {// CALC OVERSIZED PARTY PENALTY
      int nPenaltyPct = CSLGetMin(100, (nPartyCount - 5) * nPartyCount);
      nPartyBonus = - CSLRoundToNearest(nXPBase * nPenaltyPct / 100);
   } else if (nPartyCount > 1) { // CALC NICE SIZE PARTY BONUS
      int nBonusPct = 5 * (nPartyCount - 1); // PARTIES OF 2-4 GET +5% PER
      if (nPartyCount==5) nBonusPct = 5; // PARTIES OF 5 GET 5% MAX
      nPartyBonus = CSLRoundToNearest(nXPBase * nBonusPct / 100);
   }

   // CALC FINAL XP
   nXPAwarded = CSLGetMax(5, nXPBase + nCRBonus + nPartyBonus); // MIN OF 5 XP IS GIVEN PER KILL

   // CALC GOLD GIVEN
   //int nRate = GetMin(GOLDDIVISOR, GetMax(0, SDB_GetMonsterKillRate(SDB_GetMOID(oDead))-1));
   nGold = CSLGetMax(75, CSLRoundToNearest(CSLGetMax(1, nCR) * nXPAwarded / (GOLDDIVISOR + nPartyCount))); //(GOLDDIVISOR + nPartyCount - nRate));

//SendMessageToPC(oKiller, "nMaxLevel = " + IntToString(nMaxLevel));
//SendMessageToPC(oKiller, "CR = " + IntToString(nCR));
//SendMessageToPC(oKiller, "CRDiff = " + IntToString(nCRDiff));
//SendMessageToPC(oKiller, "nXPBase = " + IntToString(nXPBase));
//SendMessageToPC(oKiller, "nCRBonus = " + IntToString(nCRBonus));
//SendMessageToPC(oKiller, "nPartyBonus = " + IntToString(nPartyBonus));
//SendMessageToPC(oKiller, "nXPAwarded = " + IntToString(nXPAwarded));
//SendMessageToPC(oKiller, "nGold = " + IntToString(nGold));

   oPartyMember = GetFirstFactionMember(oKiller, TRUE);
   while (GetIsObjectValid(oPartyMember)) {

      if (nCRDiff<5 && !bIsVamp) SDB_OnMonsterDeath(oDead, oKiller, nPartyCount); // IF THIS IS A WORTHY KILL RECORD IT

      int bValid = GetIsPC(oPartyMember);
      if (bValid) { // ONLY PC'S COUNT
         bValid = (oPartyMember==oKiller); // KILLER ALWAYS VALID FOR XP
         if (!bValid) { // NOT THE KILLER, CHECK HEALTH AND DISTANCE
            bValid = CSLPCIsClose(oPartyMember, oDead, 25);  // MUST BE ALIVE AND WITHIN 15 METERS TO GET COUNTED
         }
      }
      if (bValid) { // VALID TO GET XP
         iLevel = CSLGetRealLevel(oPartyMember);
         nECL = CSLGetRaceDataECLCap( GetSubRace(oPartyMember) );//CSLGetECL(GetSubRace(oPartyMember));
         nMaxXP = CSLGetXPByLevel(30-nECL);
         nXPGiven = GetXP(oPartyMember); // STORE CURRENT
         nLeech = nMaxLevel - iLevel;
         if (nXPGiven > nMaxXP) {
            CSLMessage_SendText(oPartyMember, "Max XP reached, no experience rewarded.", FALSE, COLOR_RED);
            if (nGold) GiveGoldToCreature(oPartyMember, nGold);
         } else if (nLeech <= 5) { // 5 level leech limit
            if (nECL!=0 && nXPGiven<1000) FloatingTextStringOnCreature("The " + CSLGetSubraceName(GetSubRace(oPartyMember)) + " subrace cannot level past " + IntToString(30-nECL) + " in DEX to help maintain PvP balance.", oPartyMember, TRUE);
            int nPCT = SDB_GetPCBankPCT(oPartyMember);
            int nBankGold = CSLGetMax(5, CSLRoundToNearest(nGold * nPCT / 100, 5));
            int nBankXP = CSLGetMax(5, CSLRoundToNearest(nXPAwarded * nPCT / 100, 5));
            int nTitheGold = 0;
            int nTitheXP = 0;
            string sFAID = SDB_GetFAID(oPartyMember);
            if (sFAID!="0" && sFAID!="") { // IN A FACTION
               int nTithePCT = SDB_FactionGetTithe(sFAID); // GET THE %AGE
               if (nTithePCT > 0) {
                  nTitheXP = CSLGetMax(5, CSLRoundToNearest(nXPAwarded * nTithePCT / 100, 5));  // CALC TITHE XP
                  if (nGold) nTitheGold = CSLGetMax(5, CSLRoundToNearest(nGold * nTithePCT / 100, 5));
                  if (nTitheGold) CSLIncrementLocalInt(GetModule(), "TITHE_GOLD_" + sFAID, nTitheGold);
                  int nTitheTotal = CSLIncrementLocalInt(GetModule(), "TITHE_XP_" + sFAID, nTitheXP); // SAVE INTO ACCUMLATOR
                  if (nTitheTotal > 500) { // IS ACCUM VALUE HIGH ENOUGH? IF SO SAVE TO DB
                     CSLIncrementLocalInt(GetModule(), "TITHE_XP_" + sFAID, -500); // REDUCE ACCUM
                     nTitheGold = GetLocalInt(GetModule(), "TITHE_GOLD_" + sFAID); // GET THE TOTAL ACCUM GOLD
                     CSLIncrementLocalInt(GetModule(), "TITHE_GOLD_" + sFAID, -nTitheGold); // CLEAR THE ACCUM GOLD
                     string sSQL = "update faction set fa_bankxp=fa_bankxp+1000, fa_bankgold=fa_bankgold+" + IntToString(nTitheGold) + " where fa_faid=" + sFAID;
                     CSLNWNX_SQLExecDirect(sSQL);
                  }
               }
            }
            nGold = CSLGetMax(0, nGold - nBankGold - nTitheXP);
            nXPEarned = CSLGetMax(0, nXPAwarded - nBankXP - nTitheXP);
            //*********************************************************
            if (nXPEarned) GiveXPToCreature(oPartyMember, nXPEarned);
            if (nGold)     GiveGoldToCreature(oPartyMember, nGold);
            //*********************************************************
            SDB_IncPCBank(oPartyMember, nBankXP, nBankGold);
            nXPGiven = GetXP(oPartyMember) - nXPGiven; // CHECK FOR DELTA
            if (nXPGiven) {
               FloatingTextStringOnCreature(IntToString(nXPGiven)+" xp", oPartyMember, TRUE);
               int nXPDiff = nXPEarned - nXPGiven; // HOW MUCH WAS TAKEN BY THE NWN ENGINE FOR CLASS COMBO PENALTY
               sText = CSLColorText(IntToString(nXPGiven) + " xp award was: " + IntToString(nXPBase) + " Base", COLOR_YELLOW_DARK);
               sText += AddXPText(nCRBonus, "CR");
               sText += AddXPText(nPartyBonus, "Party");
               sText += AddXPText(-nXPDiff, "Class");
               sText += AddXPText(-nBankXP, "Cache");
               sText += AddXPText(-nTitheXP, "Tithe");
               SendMessageToPC(oPartyMember, sText);
            }
         } else {
            CSLMessage_SendText(oPartyMember, "Party Leech Gap Exceeded (5 lvl max), no experience rewarded.", FALSE, COLOR_RED);
         }
      }
      oPartyMember = GetNextFactionMember(oKiller, TRUE);
   }
}