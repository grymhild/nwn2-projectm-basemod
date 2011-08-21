/** @file
* @brief Include File for Epic Spells
*
* 
* 
*
* @ingroup scinclude
* @author PRC, Brian T. Meyer and others
*/

#include "_CSLCore_Magic"
#include "_SCInclude_Summon"


//CONSTANTS FOR MESSAGES.
//reesearch
const string MES_LEARN_SPELL            = "has gained the knowledge and use of this epic spell!";
const string MES_KNOW_SPELL             = "has already researched this spell";
const string MES_NOT_ENOUGH_GOLD        = "does not have the required gold";
const string MES_NOT_ENOUGH_XP          = "does not have the required experience";
const string MES_NOT_ENOUGH_SKILL       = "does not have the required skill";
const string MES_NOT_HAVE_REQ_FEATS     = "does not have the required knowledge";
const string MES_CANNOT_RESEARCH_HERE   = "is not allowed to pursue magical research here.";
const string MES_RESEARCH_SUCCESS       = "has successfully researched an Epic spell! Congratulations! ";
const string MES_RESEARCH_FAILURE       = "has not found success in their research...";
//seeds
const string MES_CLASS_NOT_ALLOWED      = "Your magical teachings do not seem to allow the learning of this epic spell seed.";
const string MES_LEARN_SEED             = "You have gained the knowledge of this epic spell seed!";
const string MES_KNOW_SEED              = "You already have knowledge of this epic spell seed.";
const string MES_BOOK_DESTROYED         = "The handling of this book has caused it to disintegrate!";
//spellcraft
const string MES_SPELLCRAFT_CHECK_PASS  = "Spellcraft check: Success!";
const string MES_SPELLCRAFT_CHECK_FAIL  = "Spellcraft check: Failed!";
//errors
const string MES_CANNOT_CAST_SLOTS      = "Spell failed! You do not have any epic spell slots remaining.";
const string MES_CANNOT_CAST_XP         = "Spell failed! You do not have enough experience to cast this spell.";
//contingencies
const string MES_CONTINGENCIES_YES1     = "You have contingencies active, therefore you do not have your full complement of spell slots.";
const string MES_CONTINGENCIES_YES2     = "The contingencies must expire to allow you to regain the spell slots.";

//Primogenitors SpellID constants


// Play cutscenes for learning Epic Spell Seeds and researching Epic Spells?
const int PLAY_RESEARCH_CUTS = FALSE;
const int PLAY_SPELLSEED_CUT = FALSE;

// What school of magic does each spell belong to? (for research cutscenes)
// A = Abjuration
// C = Conjuration
// D = Divination
// E = Enchantment
// V = Evocation
// I = Illusion
// N = Necromancy
// T = Transmutation
// Between the quotation marks, enter the name of the cutscene script.
const string SCHOOL_A       = "";
const string SCHOOL_C       = "";
const string SCHOOL_D       = "";
const string SCHOOL_E       = "";
const string SCHOOL_V       = "";
const string SCHOOL_I       = "";
const string SCHOOL_N       = "";
const string SCHOOL_T       = "";
const string SPELLSEEDS_CUT = "";

/*
int GetFeatForSeed(int nSeedID);
int GetIPForSeed(int nSeedID);
int GetDCForSeed(int nSeedID);
int GetClassForSeed(int nSeedID);
int GetSeedFromAbrev(string sAbrev);
string GetNameForSeed(int nSeedID);

int GetDCForSpell(int nSpellID);
int GetFeatForSpell(int nSpellID);
int GetResearchFeatForSpell(int nSpellID);
int GetIPForSpell(int nSpellID);
int GetResearchIPForSpell(int nSpellID);
int GetCastXPForSpell(int nSpellID);
string GetSchoolForSpell(int nSpellID);
int GetR1ForSpell(int nSpellID);
int GetR2ForSpell(int nSpellID);
int GetR3ForSpell(int nSpellID);
int GetR4ForSpell(int nSpellID);
string GetNameForSpell(int nSpellID);
int GetSpellFromAbrev(string sAbrev);

// Returns the combined caster level of oPC.
//int HkGetCasterLevel(object oPC);

// returns TRUE if oPC is an Epic level warmage
int GetIsEpicWarmage(object oPC);

// returns TRUE if oPC is an Epic level healer
int GetIsEpicHealer(object oPC);

// returns TRUE if oPC is an Epic level favored soul
int GetIsEpicFavSoul(object oPC);

// Returns TRUE if oPC is an Epic level cleric.
int GetIsEpicCleric(object oPC);

// Returns TRUE if oPC is an Epic level druid.
int GetIsEpicDruid(object oPC);

// Returns TRUE if oPC is an Epic level sorcerer.
int GetIsEpicSorcerer(object oPC);

// Returns TRUE if oPC is an Epic level wizard.
int GetIsEpicWizard(object oPC);

// returns TRUE if oPC is an epic level shaman
int GetIsEpicShaman(object oPC);

// returns TRUE if oPC is an Epic spellcaster
int GetIsEpicSpellcaster(object oPC);

// Performs a check on the book to randomly destroy it or not when used.
void DoBookDecay(object oBook, object oPC);

// Returns oPC's spell slot limit, based on Lore and on optional rules.
int GetEpicSpellSlotLimit(object oPC);

// Returns the number of remaining unused spell slots for oPC.
int GetSpellSlots(object oPC);

// Replenishes oPC's Epic spell slots.
void ReplenishSlots(object oPC);

// Decrements oPC's Epic spell slots by one.
void DecrementSpellSlots(object oPC);

// Lets oPC know how many Epic spell slots remain for use.
void MessageSpellSlots(object oPC);

// Returns a Spellcraft check for oPC, based on optional rules.
int GetSpellcraftCheck(object oPC);

// Returns the Spellcraft skill level of oPC, based on optional rules.
int GetSpellcraftSkill(object oPC);

// Returns TRUE if oPC has enough gold to research the spell.
int GetHasEnoughGoldToResearch(object oPC, int nSpellDC);

// Returns TRUE if oPC has enough excess experience to research the spell.
int GetHasEnoughExperienceToResearch(object oPC, int nSpellDC);

// Returns TRUE if oPC has the passed in required feats (Seeds or other Epic spells)... needs BLAH_IP's
int GetHasRequiredFeatsForResearch(object oPC, int nReq1, int nReq2 = 0, int nReq3 = 0, int nReq4 = 0,
    int nSeed1 = 0, int nSeed2 = 0, int nSeed3 = 0, int nSeed4 = 0, int nSeed5 = 0);

// Returns success (TRUE) or failure (FALSE) in oPC's researching of a spell.
int GetResearchResult(object oPC, int nSpellDC);

// Takes the gold & experience (depending on success) from oPC for researching.
void TakeResourcesFromPC(object oPC, int nSpellDC, int nSuccess);

// Returns TRUE if oPC can cast the spell.
int GetCanCastSpell(object oPC, int nEpicSpell);

// Returns the adjusted DC of a spell that takes into account oPC's Spell Foci.

// Checks to see if oPC has a creature hide. If not, create and equip one.
void EnsurePCHasSkin(object oPC);

// Add nFeatIP to oPC's creature hide.
void GiveFeat(object oPC, int nFeatIP);

// Remove nFeatIP from oPC's creature hide.
void TakeFeat(object oPC, int nFeatIP);

// Checks to see how many castable epic spell feats oPC has ready to use.
// This is used for the control of the radial menu issue.
int GetCastableFeatCount(object oPC);

// When a contingency spell is active, oCaster loses the use of one slot per day
void PenalizeSpellSlotForCaster(object oCaster);

// When a contingecy expires, restore the spell slot for the caster.
void RestoreSpellSlotForCaster(object oCaster);

// Researches an Epic Spell for the caster.
void DoSpellResearch(object oCaster, int nSpellDC, int nSpellIP, string sSchool, object oBook);

// Cycles through equipped items on oTarget, and unequips any having nImmunityType
void UnequipAnyImmunityItems(object oTarget, int nImmType);

// Finds a given spell's DC
//int HkGetSpellSaveDC(object oCaster = OBJECT_SELF, object oTarget = OBJECT_INVALID, int nSpellID = -1);


int GetHasEpicSpellKnown(int nEpicSpell, object oPC);
void SetEpicSpellKnown(int nEpicSpell, object oPC, int nState = TRUE);

int GetHasEpicSeedKnown(int nEpicSeed, object oPC);
void SetEpicSeedKnown(int nEpicSeed, object oPC, int nState = TRUE);

void DoEpicSpellcasterSpawn();
int DoEpicSpells();
int TestConditions(int nSpellID);

void MakeEpicSpellsKnownAIList();
*/
object GetSuitableTaget(int nSpellID);
void ReplenishSlots(object oPC);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "_HkSpell"

#include "_SCInclude_Necromancy"
//#include "prc_inc_spells"
//#include "prc_class_const"
//#include "_SCUtility"
//#include "x2_inc_spellhook"

// SEED FUNCTIONS

int GetFeatForSeed(int nSeedID)
{
    return StringToInt(Get2DAString("epicspellseeds", "FeatID", nSeedID));
}

int GetIPForSeed(int nSeedID)
{
    return StringToInt(Get2DAString("epicspellseeds", "FeatIPID", nSeedID));
}

int GetDCForSeed(int nSeedID)
{
    return StringToInt(Get2DAString("epicspellseeds", "DC", nSeedID));
}

int GetClassForSeed(int nSeedID)
{
    return StringToInt(Get2DAString("epicspellseeds", "Class", nSeedID));
}

int GetSeedFromAbrev(string sAbrev)
{
    sAbrev = GetStringLowerCase(sAbrev);
    if(GetStringLeft(sAbrev, 8) == "epic_sd_")
        sAbrev = GetStringRight(sAbrev, GetStringLength(sAbrev)-8);
    int i = 0;
    string sLabel = GetStringLowerCase(Get2DAString("epicspellseeds", "LABEL", i));
    while(sLabel != "")
    {
        if(sAbrev == sLabel)
            return i;
        i++;
        sLabel = GetStringLowerCase(Get2DAString("epicspellseeds", "LABEL", i));
    }
    return -1;
}

string GetNameForSeed(int nSeedID)
{
    int nFeat = GetFeatForSeed(nSeedID);
    string sName = CSLGetFeatDataName(nFeat);
    return sName;
}

// SPELL FUNCTIONS

int GetDCForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "DC", nSpellID));
}

int GetFeatForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "SpellFeatID", nSpellID));
}

int GetResearchFeatForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "ResFeatID", nSpellID));
}

int GetIPForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "SpellFeatIPID", nSpellID));
}

int GetResearchIPForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "ResFeatIPID", nSpellID));
}

int GetCastXPForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "CastingXP", nSpellID));
}

string GetSchoolForSpell(int nSpellID)
{
    return Get2DAString("epicspells", "School", nSpellID);
}

int GetR1ForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "Prereq1", nSpellID));
}

int GetR2ForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "Prereq2", nSpellID));
}

int GetR3ForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "Prereq3", nSpellID));
}

int GetR4ForSpell(int nSpellID)
{
    return StringToInt(Get2DAString("epicspells", "Prereq4", nSpellID));
}

int GetS1ForSpell(int nSpellID)
{
    string sSeed = Get2DAString("epicspells", "PrereqSeed1", nSpellID);
    if(sSeed == "")
        return -1;
    return StringToInt(sSeed);
}

int GetS2ForSpell(int nSpellID)
{
    string sSeed = Get2DAString("epicspells", "PrereqSeed2", nSpellID);
    if(sSeed == "")
        return -1;
    return StringToInt(sSeed);
}

int GetS3ForSpell(int nSpellID)
{
    string sSeed = Get2DAString("epicspells", "PrereqSeed3", nSpellID);
    if(sSeed == "")
        return -1;
    return StringToInt(sSeed);
}

int GetS4ForSpell(int nSpellID)
{
    string sSeed = Get2DAString("epicspells", "PrereqSeed4", nSpellID);
    if(sSeed == "")
        return -1;
    return StringToInt(sSeed);
}

int GetS5ForSpell(int nSpellID)
{
    string sSeed = Get2DAString("epicspells", "PrereqSeed5", nSpellID);
    if(sSeed == "")
        return -1;
    return StringToInt(sSeed);
}

int GetSpellFromAbrev(string sAbrev)
{
    sAbrev = GetStringLowerCase(sAbrev);
    if(GetStringLeft(sAbrev, 8) == "epic_sp_")
        sAbrev = GetStringRight(sAbrev, GetStringLength(sAbrev)-8);
    //if(DEBUGGING) CSLDebug("sAbrew to check vs: " + sAbrev);
    int i = 0;
    string sLabel = GetStringLowerCase(Get2DAString("epicspells", "LABEL", i));
    while(sLabel != "")
    {
        //if(DEBUGGING) CSLDebug("sLabel to check vs: " + sLabel);
        if(sAbrev == sLabel)
        {
            //if(DEBUGGING) CSLDebug("SpellID: " + IntToString(i));
            return i;
        }
        i++;
        sLabel = GetStringLowerCase(Get2DAString("epicspells", "LABEL", i));
    }
    return -1;
}

string GetNameForSpell(int nSpellID)
{
    int nFeat = GetFeatForSpell(nSpellID);
    string sName = CSLGetFeatDataName(nFeat);
    return sName;
}

/*int GetIsEpicWarmage(object oPC)
{
    if (HkGetCasterLevel(CLASS_TYPE_WARMAGE, oPC) >= 18 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_CHARISMA) >= 19)
            return TRUE;
        return FALSE;
}

int GetIsEpicHealer(object oPC)
{
    if (HkGetCasterLevel(CLASS_TYPE_HEALER, oPC) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}*/

int GetIsEpicFavSoul(object oPC)
{
    if (HkGetCasterLevel( oPC, CLASS_TYPE_FAVORED_SOUL) >= 18 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_CHARISMA) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicCleric(object oPC)
{
    if (HkGetCasterLevel(oPC, CLASS_TYPE_CLERIC) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicDruid(object oPC)
{
    if (HkGetCasterLevel(oPC,CLASS_TYPE_DRUID ) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicSorcerer(object oPC)
{
    if (HkGetCasterLevel(oPC, CLASS_TYPE_SORCERER) >= 18 &&  GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_CHARISMA) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicWizard(object oPC)
{
    if (HkGetCasterLevel(oPC,CLASS_TYPE_WIZARD ) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_INTELLIGENCE) >= 19)
            return TRUE;
    return FALSE;
}

/*int GetIsEpicShaman(object oPC)
{
    if (HkGetCasterLevel(CLASS_TYPE_SHAMAN, oPC) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}*/

int GetIsEpicSpellcaster(object oPC)
{
    object oPC = GetPCSpeaker();
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC) ||
        GetIsEpicFavSoul(oPC))
        return TRUE;
    return FALSE;
}

/*void DoBookDecay(object oBook, object oPC)
{
    if (d100() >= CSLGetPreferenceSwitch(PRC_EPIC_BOOK_DESTRUCTION))
    {
        DestroyObject(oBook, 2.0);
        SendMessageToPC(oPC, MES_BOOK_DESTROYED);
    }
}*/

int GetEpicSpellSlotLimit(object oPC)
{
    int nLimit;
    int nPen = GetLocalInt(oPC, "nSpellSlotPenalty");
    int nBon = GetLocalInt(oPC, "nSpellSlotBonus");
    // What's oPC's Lore skill?.
    nLimit = GetSkillRank(SKILL_LORE, oPC);
    // Variant rule implementation.
    /*if (CSLGetPreferenceSwitch(PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE) == TRUE)
    {
        if (GetIsEpicSorcerer(oPC) || GetIsEpicFavSoul(oPC) || GetIsEpicWarmage(oPC))
        {
            nLimit -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nLimit += GetAbilityModifier(ABILITY_CHARISMA, oPC);
        }
        else if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) || GetIsEpicHealer(oPC) || GetIsEpicShaman(oPC))
        {
            nLimit -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nLimit += GetAbilityModifier(ABILITY_WISDOM, oPC);
        }
    }*/
    // Primary calculation of slots.
    nLimit /= 10;
    // Modified calculation (for contingencies, bonuses, etc)
    nLimit = nLimit + nBon;
    nLimit = nLimit - nPen;
    return nLimit;
}

int GetSpellSlots(object oPC)
{
    int nSlots = GetLocalInt(oPC, "nEpicSpellSlots");
    if(!GetIsPC(oPC) && !GetLocalInt(oPC, "EpicSpellSlotsReplenished"))
    {
        ReplenishSlots(oPC);
        SetLocalInt(oPC, "EpicSpellSlotsReplenished", TRUE);
        nSlots = GetLocalInt(oPC, "nEpicSpellSlots");
    }
    return nSlots;
}

void MessageSpellSlots(object oPC)
{
    SendMessageToPC(oPC, "You now have " +
        IntToString(GetSpellSlots(oPC)) +
        " Epic spell slots available.");
}

void ReplenishSlots(object oPC)
{
    SetLocalInt(oPC, "nEpicSpellSlots", GetEpicSpellSlotLimit(oPC));
    MessageSpellSlots(oPC);
}





void DecrementSpellSlots(object oPC)
{
    SetLocalInt(oPC, "nEpicSpellSlots", GetLocalInt(oPC, "nEpicSpellSlots")-1);
    MessageSpellSlots(oPC);
}



int GetHasEpicSpellKnown(int nEpicSpell, object oPC)
{
    int nReturn = GetLocalInt(oPC, "EpicSpellKnown_"+IntToString(nEpicSpell));
    if(!nReturn)
        nReturn = GetHasFeat(GetResearchFeatForSpell(nEpicSpell), oPC);
    return nReturn;
}

void SetEpicSpellKnown(int nEpicSpell, object oPC, int nState = TRUE)
{
    SetLocalInt(oPC, "EpicSpellKnown_"+IntToString(nEpicSpell), nState);
}

int GetHasEpicSeedKnown(int nEpicSeed, object oPC)
{
    int nReturn = GetLocalInt(oPC, "EpicSeedKnown_"+IntToString(nEpicSeed));
    if(!nReturn)
        nReturn = GetHasFeat(GetFeatForSeed(nEpicSeed), oPC);
    return nReturn;
}

void SetEpicSeedKnown(int nEpicSeed, object oPC, int nState = TRUE)
{
    SetLocalInt(oPC, "EpicSeedKnown_"+IntToString(nEpicSeed), nState);
}

int GetSpellcraftSkill(object oPC)
{
    // Determine initial Spellcraft skill.
    int nSkill = GetSkillRank(SKILL_SPELLCRAFT, oPC);
    // Variant rule implementation.
    /*if (CSLGetPreferenceSwitch(PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE) == TRUE)
    {
        if (GetIsEpicSorcerer(oPC) || GetIsEpicFavSoul(oPC) || GetIsEpicWarmage(oPC))
        {
            nSkill -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nSkill += GetAbilityModifier(ABILITY_CHARISMA, oPC);
        }
        else if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) || GetIsEpicHealer(oPC) || GetIsEpicShaman(oPC))
        {
            nSkill -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nSkill += GetAbilityModifier(ABILITY_WISDOM, oPC);
        }
    }*/
    return nSkill;
}


int GetSpellcraftCheck(object oPC)
{
    // Get oPC's skill rank.
    int nCheck = GetSpellcraftSkill(oPC);
    // Do the check, dependant on "Take 10" variant rule.
    /*if (CSLGetPreferenceSwitch(PRC_EPIC_TAKE_TEN_RULE) == TRUE)
        nCheck += 10;
    else*/
        nCheck += d20();
    return nCheck;
}



int GetHasEnoughGoldToResearch(object oPC, int nSpellDC)
{
    int nCost = nSpellDC /* * CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER)*/;
    //if (CSLGetHasGPToSpend(oPC, nCost))
      //  return TRUE;
    return FALSE;
}

int GetHasEnoughExperienceToResearch(object oPC, int nSpellDC)
{
    int nXPCost = nSpellDC /* * CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER) / CSLGetPreferenceSwitch(PRC_EPIC_XP_FRACTION)*/;
    //if (CSLGetHasXPToSpend(oPC, nXPCost))
      //  return TRUE;
    return FALSE;
}

int GetHasRequiredFeatsForResearch(object oPC, int nReq1, int nReq2 = 0, int nReq3 = 0, int nReq4 = 0,
    int nSeed1 = 0, int nSeed2 = 0, int nSeed3 = 0, int nSeed4 = 0, int nSeed5 = 0)
{
    /*if(DEBUGGING)
    {
        CSLDebug("Requirement #1: " + IntToString(nReq1));
        CSLDebug("Requirement #2: " + IntToString(nReq2));
        CSLDebug("Requirement #3: " + IntToString(nReq3));
        CSLDebug("Requirement #4: " + IntToString(nReq4));
        CSLDebug("Seed #1: " + IntToString(nSeed1));
        CSLDebug("Seed #2: " + IntToString(nSeed2));
        CSLDebug("Seed #3: " + IntToString(nSeed3));
        CSLDebug("Seed #4: " + IntToString(nSeed4));
        CSLDebug("Seed #4: " + IntToString(nSeed5));
    }*/

    if ((GetHasFeat(nReq1, oPC) || nReq1 == 0)
        && (GetHasFeat(nReq2, oPC) || nReq2 == 0)
        && (GetHasFeat(nReq3, oPC) || nReq3 == 0)
        && (GetHasFeat(nReq4, oPC) || nReq4 == 0)
        && (GetHasEpicSeedKnown(nSeed1, oPC) || nSeed1 == -1)
        && (GetHasEpicSeedKnown(nSeed2, oPC) || nSeed2 == -1)
        && (GetHasEpicSeedKnown(nSeed3, oPC) || nSeed3 == -1)
        && (GetHasEpicSeedKnown(nSeed4, oPC) || nSeed4 == -1)
        && (GetHasEpicSeedKnown(nSeed5, oPC) || nSeed5 == -1))
    {
        return TRUE;
    }
    return FALSE;
}
int GetResearchResult(object oPC, int nSpellDC)
{
    int nCheck = GetSpellcraftCheck(oPC);
    SendMessageToPC(oPC, "Your spellcraft check was a " +
        IntToString(nCheck) + ", against a researching DC of " +
        IntToString(nSpellDC));
    if (nCheck >= nSpellDC)
    {
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_PASS);
        return TRUE;
    }
    else
    {
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_FAIL);
        return FALSE;
    }
}

void TakeResourcesFromPC(object oPC, int nSpellDC, int nSuccess)
{
    if (nSuccess != TRUE)
    {
        int nGold = nSpellDC /* *
            CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER) / CSLGetPreferenceSwitch(PRC_EPIC_FAILURE_FRACTION_GOLD)*/;
        //CSLSpendGP(oPC, nGold);
    }
    else
    {
        int nGold = nSpellDC /* *  CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER)*/;
        //CSLSpendGP(oPC, nGold);
        int nXP = nSpellDC /* * CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER) / CSLGetPreferenceSwitch(PRC_EPIC_XP_FRACTION)*/;
        //CSLSpendXP(oPC, nXP);
    }
}

int GetCanCastSpell(object oPC, int nEpicSpell)
{
    int nSpellDC  = GetDCForSpell(nEpicSpell);
    string sChool = GetSchoolForSpell(nEpicSpell);
    int nSpellXP  =GetCastXPForSpell(nEpicSpell);
    // Adjust the DC to account for Spell Foci feats.
    nSpellDC -= CSLGetDCSchoolFocusAdjustment(oPC, CSLGetSchoolByInitial(sChool));
    int nCheck = GetSpellcraftCheck(oPC);
    // Does oPC already know it
    if (!GetHasEpicSpellKnown(nEpicSpell, oPC))
    {
        return FALSE;
    }
    if (!(GetSpellSlots(oPC) >= 1))
    { // No? Cancel spell, then.
        SendMessageToPC(oPC, MES_CANNOT_CAST_SLOTS);
        return FALSE;
    }
    /*if (CSLGetPreferenceSwitch(PRC_EPIC_XP_COSTS) == TRUE)
    {
        // Does oPC have the needed XP available to cast the spell?
        if (!CSLGetHasXPToSpend(oPC, nSpellXP))
        { // No? Cancel spell, then.
            SendMessageToPC(oPC, MES_CANNOT_CAST_XP);
            return FALSE;
        }
    }*/
    // Does oPC pass the Spellcraft check for the spell's casting?
    if (!(nCheck >= nSpellDC))
    { // No?
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_FAIL);
        SendMessageToPC(oPC,
            IntToString(nCheck) + " against a DC of " + IntToString(nSpellDC));
        // Failing a Spellcraft check still costs a spell slot, so decrement...
        DecrementSpellSlots(oPC);
        return FALSE;
    }
    // If the answer is YES to all three, cast the spell!
    SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_PASS);
    SendMessageToPC(oPC,
        IntToString(nCheck) + " against a DC of " + IntToString(nSpellDC));
    //CSLSpendXP(oPC, nSpellXP); // Only spends the XP on a successful casting.
    DecrementSpellSlots(oPC);
    return TRUE;
}

void GiveFeat(object oPC, int nFeatIP)
{
    object oSkin = CSLGetPCSkin(oPC);
    if (oSkin != OBJECT_INVALID)
        CSLSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(nFeatIP), 0.0f, SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void TakeFeat(object oPC, int nFeatIP)
{
    object oSkin = CSLGetPCSkin(oPC);
    itemproperty ipX = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipX))
    {
        if (GetItemPropertyType(ipX) == ITEM_PROPERTY_BONUS_FEAT)
        {
            if(GetItemPropertySubType(ipX) == nFeatIP)
            {
                RemoveItemProperty(oSkin, ipX);
                break;
            }
        }
        ipX = GetNextItemProperty(oSkin);
    }
}


int GetCastableFeatCount(object oPC)
{
    int nX = 0;
    int i = 0;
    int nFeat = GetFeatForSpell(i);
    while(nFeat != 0)
    {
        //test for the castable feat
        if(GetHasFeat(nFeat, oPC))
            nX += 1;
        i++;
        nFeat = GetFeatForSpell(i);
    }
    return nX;
}

void PenalizeSpellSlotForCaster(object oCaster)
{
    int nMod = GetLocalInt(oCaster, "nSpellSlotPenalty");
    SetLocalInt(oCaster, "nSpellSlotPenalty", nMod + 1);
    SendMessageToPC(oCaster, MES_CONTINGENCIES_YES1);
    SendMessageToPC(oCaster, MES_CONTINGENCIES_YES2);
    SendMessageToPC(oCaster, "Your epic spell slot limit is now " +
        IntToString(GetEpicSpellSlotLimit(oCaster)) + ".");
}

void RestoreSpellSlotForCaster(object oCaster)
{
    int nMod = GetLocalInt(oCaster, "nSpellSlotPenalty");
    if (nMod > 0) SetLocalInt(oCaster, "nSpellSlotPenalty", nMod - 1);
    SendMessageToPC(oCaster, "Your epic spell slot limit is now " +
        IntToString(GetEpicSpellSlotLimit(oCaster)) + ".");
}

void DoSpellResearch(object oCaster, int nSpellDC, int nSpellIP, string sSchool, object oBook)
{
    float fDelay = 2.0;
    string sCutScript;
    int nResult = GetResearchResult(oCaster, nSpellDC);
    if (PLAY_RESEARCH_CUTS == TRUE)
    {
        if (sSchool == "A") sCutScript = SCHOOL_A;
        if (sSchool == "C") sCutScript = SCHOOL_C;
        if (sSchool == "D") sCutScript = SCHOOL_D;
        if (sSchool == "E") sCutScript = SCHOOL_E;
        if (sSchool == "I") sCutScript = SCHOOL_I;
        if (sSchool == "N") sCutScript = SCHOOL_N;
        if (sSchool == "T") sCutScript = SCHOOL_T;
        if (sSchool == "V") sCutScript = SCHOOL_V;
        ExecuteScript(sCutScript, oCaster);
        fDelay = 10.0;
    }
    DelayCommand(fDelay, TakeResourcesFromPC(oCaster, nSpellDC, nResult));
    if (nResult == TRUE)
    {
        DelayCommand(fDelay, SendMessageToPC(oCaster, GetName(oCaster) + " " + MES_RESEARCH_SUCCESS));
        //DelayCommand(fDelay, GiveFeat(oCaster, nSpellIP));
        DelayCommand(fDelay, SetEpicSpellKnown(nSpellIP, oCaster, TRUE));
        //DelayCommand(fDelay, DestroyObject(oBook));
        //research time
        //1 day per 50,000GP +1
        //int nDays = (nSpellDC * CSLGetPreferenceSwitch(PRC_EPIC_GOLD_MULTIPLIER))/50000;
        //nDays++;
        //float fSeconds = HoursToSeconds(24*nDays);
        //AdvanceTimeForPlayer(oCaster, fSeconds);
    }
    else
    {
        DelayCommand(fDelay, SendMessageToPC(oCaster, GetName(oCaster) + " " + MES_RESEARCH_FAILURE));
    }
}

void UnequipAnyImmunityItems(object oTarget, int nImmType)
{
    object oItem;
    int nX;
    for (nX = 0; nX <= 13; nX++) // Does not include creature items in search.
    {
        oItem = GetItemInSlot(nX, oTarget);
        // Debug.
        //SendMessageToPC(oTarget, "Checking slot " + IntToString(nX));
        if (oItem != OBJECT_INVALID)
        {
            // Debug.
            //SendMessageToPC(oTarget, "Valid item.");
            itemproperty ipX = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(ipX))
            {
                // Debug.
                //SendMessageToPC(oTarget, "Valid ip");
                if (GetItemPropertySubType(ipX) == nImmType)
                {
                    // Debug.
                    //SendMessageToPC(oTarget, "ip match!!");
                    SendMessageToPC(oTarget, GetName(oItem) +
                        " cannot be equipped at this time.");
                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, ActionUnequipItem(oItem));
                    break;
                }
                else
                    ipX = GetNextItemProperty(oItem);
            }
        }
    }
}

/*int HkGetCasterLevel(object oCaster)
{
    int iBestArcane = GetLevelByTypeArcaneFeats();
    int iBestDivine = GetLevelByTypeDivineFeats();
    int iBest = (iBestDivine > iBestArcane) ? iBestDivine : iBestArcane;

    //SendMessageToPC(oCaster, "Epic casting at level " + IntToString(iBest));

    return iBest;
}*/

/*
int GetDCSchoolFocusAdjustment(object oPC, string sChool)
{
    int nNewDC = 0;
    if (sChool == "A") // Abjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "C") // Conjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "D") // Divination spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 6;
    }
    if (sChool == "E") // Enchantment spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 6;
    }
    if (sChool == "V") // Evocation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 6;
    }
    if (sChool == "I") // Illusion spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 6;
    }
    if (sChool == "N") // Necromancy spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 6;
    }
    if (sChool == "T") // Transmutation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 6;
    }
    return nNewDC;
}
*/

/*
int HkGetSpellSaveDC(object oCaster = OBJECT_SELF, object oTarget = OBJECT_INVALID, int nSpellID = -1)
{
    //int iDiv = HkGetCasterLevel(TYPE_DIVINE,   oCaster); // ie. wisdom determines DC
    int iWiz = HkGetCasterLevel(oCaster, CLASS_TYPE_WIZARD); // int determines DC
    //int iWMa = HkGetCasterLevel(CLASS_TYPE_WARMAGE, oCaster); // cha determines DC
    int iSor = HkGetCasterLevel(oCaster, CLASS_TYPE_SORCERER); // cha determines DC
    int iBest = 0;
    int iAbility;
    if(nSpellID == -1)
        nSpellID = HkGetSpellId();

    //if (iDiv > iBest) { iAbility = ABILITY_WISDOM;       iBest = iDiv; }
    if (iWiz > iBest) { iAbility = ABILITY_INTELLIGENCE; iBest = iWiz; }
    //if (iWMa > iBest) { iAbility = ABILITY_CHARISMA;     iBest = iWMa; }
    if (iSor > iBest) { iAbility = ABILITY_CHARISMA;     iBest = iSor; }

    int nDC;
    if (iBest)   nDC =  20 + GetAbilityModifier(iAbility, oCaster);
    else         nDC =  20; // DC = 20 if the epic spell is cast some other way.

    nDC += CSLGetDCSchoolFocusAdjustment(oCaster, CSLGetSchoolByInitial(Get2DAString("spells", "school", nSpellID)));
    //nDC += GetChangesToSaveDC(oTarget, oCaster);

    return nDC;
}
*/

int TestConditions(int nSpellID)
{
    int i;
    float fDist;
    switch(nSpellID)
    {
        //personal buffs have no extra checks
        //gethasspelleffect is automatically done
        case SPELL_EPIC_ACHHEEL:
        case SPELL_EPIC_EP_WARD:
        case SPELL_EPIC_WHIP_SH:
        case SPELL_EPIC_CON_RES:
            return TRUE;
            break;
        //not sure what or how to test at the moment
        case SPELL_EPIC_ARMY_UN:
        case SPELL_EPIC_PATHS_B:
        case SPELL_EPIC_GEMCAGE:
            return FALSE;
            break;
        //timestop checks if already cast
        case SPELL_EPIC_GR_TIME:
            if(GetHasSpellEffect(
                StringToInt(Get2DAString("feats", "SpellID",
                    StringToInt(Get2DAString("EpicSpells", "SpellFeatID", nSpellID)))
                    ))
                )
                return FALSE;
            else
                return TRUE;
            break;
        //summons check if a summon already exists
        case SPELL_EPIC_UNHOLYD:
        case SPELL_EPIC_SUMABER:
        case SPELL_EPIC_TWINF:
        case SPELL_EPIC_MUMDUST:
        case SPELL_EPIC_DRG_KNI:
            if(GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
                //&& !CSLGetPreferenceInteger("MaxNormalSummons"))
                return FALSE;
            else
                return TRUE;
            break;
        //leechfield checks if enemy undead nearby (25m)
        case SPELL_EPIC_LEECH_F:
            fDist = GetDistanceToObject(GetNearestCreature(CREATURE_TYPE_REPUTATION,
                REPUTATION_TYPE_ENEMY,OBJECT_SELF, 1, CREATURE_TYPE_RACIAL_TYPE,
                RACIAL_TYPE_UNDEAD));
            if(fDist == -1.0 || fDist > 25.0)
                return TRUE;
            else
                return FALSE;
        //Order Restored is alignment sensitive. Only castable by lawful
        case SPELL_EPIC_ORDER_R:
            if(GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL
                && GetAlignmentLawChaos(GetNearestCreature(
                    CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY)) == ALIGNMENT_CHAOTIC)
                return TRUE;
            else
                return FALSE;

        //Anarchy's Call is alignment sensitive. Only castable by Chaotic
        case SPELL_EPIC_ANARCHY:
            if(GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC
                && GetAlignmentLawChaos(GetNearestCreature(
                    CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY)) == ALIGNMENT_LAWFUL)
                return TRUE;
            else
                return FALSE;
        //touchbuffs pass automatically because of target selection checks
        case SPELL_EPIC_HERCALL:
        case SPELL_EPIC_CHAMP_V:
        case SPELL_EPIC_DEADEYE:
        case SPELL_EPIC_DULBLAD:
        case SPELL_EPIC_EP_M_AR:
        case SPELL_EPIC_EP_SP_R:
        case SPELL_EPIC_ET_FREE:
        case SPELL_EPIC_FLEETNS:
        case SPELL_EPIC_GR_SP_RE:
        case SPELL_EPIC_HERCEMP:
        case SPELL_EPIC_IMPENET:
        case SPELL_EPIC_TRANVIT:
        case SPELL_EPIC_UNIMPIN:
        case SPELL_EPIC_AL_MART:
            return TRUE;
            break;
        //single hostile spells
        case SPELL_EPIC_GR_RUIN:
        case SPELL_EPIC_RUINN:
        case SPELL_EPIC_GODSMIT:
        case SPELL_EPIC_NAILSKY:
        case SPELL_EPIC_ENSLAVE:
        case SPELL_EPIC_MORI:
        case SPELL_EPIC_THEWITH:
        case SPELL_EPIC_PSION_S:
        case SPELL_EPIC_DWEO_TH:
        case SPELL_EPIC_SP_WORM:
        case SPELL_EPIC_SINGSUN:
            return TRUE;
            break;

        //aoe hostile spells
        case SPELL_EPIC_ANBLAST:
        case SPELL_EPIC_ANBLIZZ:
        case SPELL_EPIC_A_STONE:
        case SPELL_EPIC_MASSPEN:
        case SPELL_EPIC_HELBALL:
        case SPELL_EPIC_MAGMA_B:
        case SPELL_EPIC_TOLO_KW:
            return TRUE;
            break;

        //fail spells that tha AI cant work with anyway
        case SPELL_EPIC_CELCOUN:
        case SPELL_EPIC_CON_REU:
        case SPELL_EPIC_DREAMSC:
        case SPELL_EPIC_EP_RPLS:
        case SPELL_EPIC_FIEND_W:
        //case SPELL_EPIC_HELSEND:
        //case SPELL_EPIC_LEG_ART:
        case SPELL_EPIC_PIOUS_P:
        case SPELL_EPIC_PLANCEL:
        //case SPELL_EPIC_RISEN_R:
        case SPELL_EPIC_UNSEENW:
            return FALSE;

        //fail spells that dont work at the moment
        //case SPELL_EPIC_BATTLEB:
        //case SPELL_EPIC_DTHMARK:
//        case SPELL_EPIC_HELSEND:
//        case SPELL_EPIC_EP_RPLS:
//        case SPELL_EPIC_LEG_ART:
        //case SPELL_EPIC_LIFE_FT:
        //case SPELL_EPIC_NIGHTSU:
        case SPELL_EPIC_PEERPEN:
//        case SPELL_EPIC_RISEN_R:
        //case SPELL_EPIC_SYMRUST:
            return FALSE;
    }
    return FALSE;
}

//returns True if it casts something
int DoEpicSpells()
{
    //checks for able to cast anything epic
    if(GetHitDice(OBJECT_SELF) <21)
        return FALSE;
    if(GetIsEpicCleric(OBJECT_SELF) ==FALSE
        && GetIsEpicDruid(OBJECT_SELF) ==FALSE
        && GetIsEpicSorcerer(OBJECT_SELF) ==FALSE
        && GetIsEpicFavSoul(OBJECT_SELF) ==FALSE
        && GetIsEpicWizard(OBJECT_SELF) ==FALSE)
        return FALSE;
    if(GetSpellSlots(OBJECT_SELF) < 1)
        return FALSE;

//    CSLDebug("Checking for EpicSpells");
    int nSpellID;
    int bTest;
    int i;
    object oTarget;
    //do specific conditon tests first
    //non implemented at moment
    //test all spells in known spell array setup on spawn
    for(i=0; i < CSLDataArray_LengthInt(OBJECT_SELF,"AI_KnownEpicSpells");i++)
    {
        nSpellID = CSLDataArray_GetInt(OBJECT_SELF,"AI_KnownEpicSpells", i);
        oTarget = GetSuitableTaget(nSpellID);
        if(GetIsObjectValid(oTarget)
            && TestConditions(nSpellID)
            && GetCanCastSpell(OBJECT_SELF, nSpellID))
        {
            ClearAllActions();
            int nRealSpellID = StringToInt(Get2DAString("feats", "SpellID",
                StringToInt(Get2DAString("EpicSpells", "SpellFeatID", nSpellID))));
            ActionCastSpellAtObject(nRealSpellID,oTarget, METAMAGIC_NONE, TRUE);
            return TRUE;
        }
    }
    //if no epic spell can be cast, go through normal tests
    return FALSE;
}


object GetSuitableTaget(int nSpellID)
{
    object oTarget;
    object oTest;
    int i;
    float fDist;
    int nRealSpellID = StringToInt(Get2DAString("feats", "SpellID",
        StringToInt(Get2DAString("EpicSpells", "SpellFeatID", nSpellID))));
    switch(nSpellID)
    {
        //personal spells always target self
        case SPELL_EPIC_ACHHEEL:
        case SPELL_EPIC_ALLHOPE:
        case SPELL_EPIC_ANARCHY:
        case SPELL_EPIC_ARMY_UN:
        //case SPELL_EPIC_BATTLEB:
        case SPELL_EPIC_CELCOUN:
        case SPELL_EPIC_DIREWIN:
        case SPELL_EPIC_DREAMSC:
        case SPELL_EPIC_EP_WARD:
        case SPELL_EPIC_FIEND_W:
        case SPELL_EPIC_GR_TIME:
        //case SPELL_EPIC_HELSEND:
        //case SPELL_EPIC_LEG_ART:
        case SPELL_EPIC_ORDER_R:
        case SPELL_EPIC_PATHS_B:
        case SPELL_EPIC_PEERPEN:
        case SPELL_EPIC_PESTIL:
        case SPELL_EPIC_PIOUS_P:
        case SPELL_EPIC_RAINFIR:
        //case SPELL_EPIC_RISEN_R:
        case SPELL_EPIC_WHIP_SH:
            return OBJECT_SELF;
            break;
        //summons target nearest enemy, or self if enemies over short range
        case SPELL_EPIC_UNHOLYD:
        case SPELL_EPIC_SUMABER:
        case SPELL_EPIC_TWINF:
        case SPELL_EPIC_MUMDUST:
        case SPELL_EPIC_DRG_KNI:
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                REPUTATION_TYPE_ENEMY,OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            if(GetDistanceToObject(oTarget) > RADIUS_SIZE_SMALL)//assuming radius size is the same as range
                return OBJECT_SELF;
            else
                return oTarget;
            break;
        //touchbuffs target self, or nearest ally without the effect
        //maximum 5m distance, dont want to wander too far
        //will separate those best cast on others laters
        case SPELL_EPIC_HERCALL:
        case SPELL_EPIC_CHAMP_V:
        case SPELL_EPIC_DEADEYE:
        case SPELL_EPIC_DULBLAD:
        case SPELL_EPIC_EP_M_AR:
        case SPELL_EPIC_EP_RPLS:
        case SPELL_EPIC_EP_SP_R:
        case SPELL_EPIC_ET_FREE:
        case SPELL_EPIC_FLEETNS:
        case SPELL_EPIC_GR_SP_RE:
        case SPELL_EPIC_HERCEMP:
        case SPELL_EPIC_IMPENET:
        case SPELL_EPIC_TRANVIT:
        case SPELL_EPIC_UNIMPIN:
        case SPELL_EPIC_UNSEENW:
        case SPELL_EPIC_CON_RES:
            fDist = 5.0;
            if(!GetHasSpellEffect(nRealSpellID))
                return OBJECT_SELF;
            else
            {
                oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_FRIEND,OBJECT_SELF, i);
                while(!GetHasSpellEffect(nRealSpellID, oTarget)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_FRIEND,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
            }
            break;

        case SPELL_EPIC_AL_MART:
            fDist = 5.0;
                oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_FRIEND,OBJECT_SELF, i);
                while(!GetHasSpellEffect(nRealSpellID, oTarget)
                    && GetCurrentHitPoints(oTarget) > GetCurrentHitPoints(OBJECT_SELF)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_FRIEND,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                {
                    oTest = GetLocalObject(OBJECT_SELF, "oAILastMart");
                    if(GetIsObjectValid(oTest)
                        && !GetIsDead(oTest)
                        && GetCurrentHitPoints(oTest) > GetMaxHitPoints(oTest)/10)
                        return OBJECT_INVALID;
                    return oTarget;
                }
            break;
        //hostile spells
        //area effect descriminants
        case SPELL_EPIC_ANBLAST:
            fDist = 40.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetCurrentHitPoints(oTarget) > 35
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
                break;
        case SPELL_EPIC_ANBLIZZ:
            fDist = 40.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetCurrentHitPoints(oTarget) > 70
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
                break;
        case SPELL_EPIC_A_STONE:
            fDist = 20.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetFortitudeSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
                break;

        case SPELL_EPIC_MASSPEN:
            fDist = 40.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetFortitudeSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
                break;
        //singe target
        case SPELL_EPIC_ENSLAVE:
            fDist = 80.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetWillSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
                break;
        case SPELL_EPIC_NAILSKY:
            fDist = 20.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetWillSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
                break;
        case SPELL_EPIC_GR_RUIN:
        case SPELL_EPIC_RUINN:
        //case SPELL_EPIC_DTHMARK:
        case SPELL_EPIC_GODSMIT:
        case SPELL_EPIC_SINGSUN:
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                REPUTATION_TYPE_ENEMY,OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            return oTarget;
            break;

        //area effect indescriminants
        case SPELL_EPIC_HELBALL:
        case SPELL_EPIC_MAGMA_B:
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                REPUTATION_TYPE_ENEMY,OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            return oTarget;
            break;

        case SPELL_EPIC_LEECH_F:
            fDist = 40.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetWillSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID)
                    && GetDistanceToObject(oTarget) < fDist
                    && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
                break;
        //check to not target those immune to insta-death
        case SPELL_EPIC_TOLO_KW:
            fDist = 40.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
                break;
        case SPELL_EPIC_MORI:
            fDist = 20.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) >= fDist
                    || i >= 10)
                    return OBJECT_INVALID; //no suitable targets
                else
                    return oTarget;
            break;
        //check to not target those immune to ability lowering
        case SPELL_EPIC_THEWITH:
            fDist = 20.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetIsImmune(oTarget,IMMUNITY_TYPE_ABILITY_DECREASE)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10
                    && GetFortitudeSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID))
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
            break;
            //aslo willcheck
        case SPELL_EPIC_PSION_S:
            fDist = 20.0;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetIsImmune(oTarget,IMMUNITY_TYPE_ABILITY_DECREASE)
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10
                    && GetWillSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID))
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
            break;
        //target spellcasters
        //just gets last spellcaster
        //or those with classes in spellcasting
        case SPELL_EPIC_DWEO_TH:
            fDist = 20.0;

            oTarget = GetLastSpellCaster();
            if(GetDistanceToObject(oTarget) < fDist
                && i < 10
                && GetIsEnemy(oTarget))
                return oTarget;
            else
            {
                oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetLevelByClass(CLASS_TYPE_CLERIC) ==0
                    && GetLevelByClass(CLASS_TYPE_DRUID) ==0
                    && GetLevelByClass(CLASS_TYPE_WIZARD) ==0
                    && GetLevelByClass(CLASS_TYPE_SORCERER) ==0
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10)
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;  //no suitable targets
                else
                    return oTarget;
            }
            break;
        //target spellcasters
        //just gets last spellcaster
        //or those with classes in spellcasting
        //also checks will fail will test
        case SPELL_EPIC_SP_WORM:
            fDist = 8.0;
            oTarget = GetLastSpellCaster();
            if(GetDistanceToObject(oTarget) < fDist
                && i < 10
                && GetIsEnemy(oTarget)
                && GetWillSavingThrow(oTarget)+10 >
                    HkGetSpellSaveDC(OBJECT_SELF) +
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID))
                return oTarget;
            else
            {
                oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                    REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                while(GetLevelByClass(CLASS_TYPE_CLERIC) ==0
                    && GetLevelByClass(CLASS_TYPE_DRUID) ==0
                    && GetLevelByClass(CLASS_TYPE_WIZARD) ==0
                    && GetLevelByClass(CLASS_TYPE_SORCERER) ==0
                    && GetDistanceToObject(oTarget) < fDist
                    && i < 10
                    && GetWillSavingThrow(oTarget)+10 >
                        HkGetSpellSaveDC(OBJECT_SELF, oTarget, nSpellID))
                {
                    i++;
                    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                        REPUTATION_TYPE_ENEMY,OBJECT_SELF, i);
                }
                if(GetDistanceToObject(oTarget) > fDist
                    || i >= 10)
                    return OBJECT_INVALID;
                else
                    return oTarget; //no suitable targets
            }
            break;

    }
    return OBJECT_INVALID;
}

void MakeEpicSpellsKnownAIList()
{
//    CSLDebug("Building EpicSpells Known list");
    int nTemp;
    int nHighestDC;
    int nHighestDCID;
    int j;
    int i;
    //array_create(OBJECT_SELF, "AI_KnownEpicSpells");
    //record what spells in an array
//    CSLDataArray_SetInt(OBJECT_SELF, "AI_KnownEpicSpells");
    string sLabel = Get2DAString("epicspellseeds", "LABEL", i);
    while(sLabel != "")
    {
        if(GetHasFeat(GetFeatForSpell(i)))
        {
            CSLDataArray_SetInt(OBJECT_SELF, "AI_KnownEpicSpells",CSLDataArray_LengthInt(OBJECT_SELF, "AI_KnownEpicSpells") ,i);
        }
        i++;
        sLabel = Get2DAString("epicspellseeds", "LABEL", i);
    }
//    CSLDebug("Finished recording known spells");
    //sort spells into descending DC order
    //move starting point down list
    for (j=0;j<CSLDataArray_LengthInt(OBJECT_SELF, "AI_KnownEpicSpells");j++)
    {
        //for each start get the first spells DC + position
        nHighestDC = GetDCForSpell(CSLDataArray_GetInt(OBJECT_SELF, "AI_KnownEpicSpells",j));
        nHighestDCID = j;
        //check each spell lower on the list for higher DC
        for (i=j;i<CSLDataArray_LengthInt(OBJECT_SELF, "AI_KnownEpicSpells");i++)
        {
            //if so, mark highest to that spell
            if(GetDCForSpell(CSLDataArray_GetInt(OBJECT_SELF, "AI_KnownEpicSpells",i)) > nHighestDC)
            {
                nHighestDC = GetDCForSpell(CSLDataArray_GetInt(OBJECT_SELF, "AI_KnownEpicSpells",i));
                nHighestDCID = i;
            }
        }
        //once you have checked all spells lower, swap the top one with the highest DC
        nTemp = CSLDataArray_GetInt(OBJECT_SELF, "AI_KnownEpicSpells",j);
        CSLDataArray_SetInt(OBJECT_SELF, "AI_KnownEpicSpells",j,CSLDataArray_GetInt(OBJECT_SELF, "AI_KnownEpicSpells",nHighestDCID));
        CSLDataArray_SetInt(OBJECT_SELF, "AI_KnownEpicSpells",nHighestDCID, nTemp);
    }
//    CSLDebug("Finished sorting known spells");
}

void DoEpicSpellcasterSpawn()
{

    //checks for able to cast anything epic
    if(GetHitDice(OBJECT_SELF) <21)
        return;
    if(GetIsEpicCleric(OBJECT_SELF) ==FALSE
        && GetIsEpicDruid(OBJECT_SELF) ==FALSE
        && GetIsEpicSorcerer(OBJECT_SELF) ==FALSE
        && GetIsEpicFavSoul(OBJECT_SELF) ==FALSE
        && GetIsEpicWizard(OBJECT_SELF) ==FALSE)
        return;
    int nLevel = GetHitDice(OBJECT_SELF);
    //give pseudoXP if not already given
    if(!GetXP(OBJECT_SELF))
    {
        int nXP =(nLevel*(nLevel-1))*500;
        nXP = nXP + FloatToInt(IntToFloat(nLevel)*1000.0*((IntToFloat(Random(51))+25.0)/100.0));
        SetXP(OBJECT_SELF, nXP);
    }
    //fill slots
    ReplenishSlots(OBJECT_SELF);
    //TEMP
    //This stuff gives them some Epic Spells for free
    if(!GetCastableFeatCount(OBJECT_SELF))
    {
        int nSlots = GetEpicSpellSlotLimit(OBJECT_SELF)+3;
        int i;
        for(i=0;i<nSlots;i++)
        {
            GiveFeat(OBJECT_SELF, Random(71)+429);
        }
    }
    //setup AI list
    DelayCommand(1.0, ActionDoCommand(MakeEpicSpellsKnownAIList()));
}





/// PRC includes which i need to purge

// This function rolls damage and applies metamagic feats to the damage.
//      nDamageType - The DAMAGE_TYPE_xxx constant for the damage, or -1 for no
//          a non-damaging effect.
//      nDice - number of dice to roll.
//      nDieSize - size of dice, i.e. d4, d6, d8, etc.
//      nBonusPerDie - Amount of bonus damage per die.
//      nBonus - Amount of overall bonus damage.
//      nMetaMagic - metamagic constant, if -1 GetMetaMagic() is called.
//      returns - the damage rolled with metamagic applied.
int SPGetMetaMagicDamage(int nDamageType, int nDice, int nDieSize, int nBonusPerDie = 0, int nBonus = 0, int nMetaMagic = -1)
{
    // If the metamagic argument wasn't given get it.
    if (-1 == nMetaMagic) { nMetaMagic = HkGetMetaMagicFeat(); }

    // Roll the damage, applying metamagic.
    //int nDamage = PRCMaximizeOrEmpower(nDieSize, nDice, nMetaMagic, (nBonusPerDie * nDice) + nBonus);
    
    int nDamage = HkApplyMetamagicVariableMods(CSLDieX(nDieSize,nDice)+(nBonusPerDie * nDice)+nBonus, (nDieSize*nDice)+(nBonusPerDie*nDice)+nBonus, nMetaMagic );
    return nDamage;
}



// Function to save the school of the currently cast spell in a variable.  This should be
// called at the beginning of the script to set the spell school (passing the school) and
// once at the end of the script (with no arguments) to delete the variable.
//  nSchool - SPELL_SCHOOL_xxx constant to set, if general then the variable is
//      deleted.
void SPSetSchool(int nSchool = SPELL_SCHOOL_GENERAL)
{
    // Remove the last value in case it is there and set the new value if it is NOT general.
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    if (SPELL_SCHOOL_GENERAL != nSchool)
        SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", nSchool);
}

// Function to raise the spell cast at event.
//      oTarget - Target of the spell.
//      bHostile - TRUE if the spell is a hostile act.
//      nSpellID - Spell ID or -1 if HkGetSpellId() should be used.
//      oCaster - Object doing the casting.
void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
{
    if (-1 == nSpellID) nSpellID = HkGetSpellId();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHostile));
}
