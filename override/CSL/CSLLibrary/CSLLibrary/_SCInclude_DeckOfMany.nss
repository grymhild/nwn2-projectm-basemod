/** @file
* @brief Include File for Deck of Many Things Magic Item
*
* 
* 
*
* @ingroup scinclude
* @author Bioware and Obsidian
*/



//:://////////////////////////////////////////////////
//:: _SCInclude_DeckOfMany
/*

Library for the deck of many things.

See the spell script x0_s3_deckmany for an example of
combining these functions to create a deck.

To make your own deck, just add a "Do<whatever>DeckCard" function
for any custom cards you want, then put those cards into the
DoDeckDrawPositive/Negative functions. Then recompile the
spell script x0_s3_deckmany inside your module and a deck inside
your module will use your cards.

*/

//#include "_SCUtility"
//#include "_SCMessages"
#include "_HkSpell"
//#include "x0_i0_treasure"
//#include "x0_i0_henchman"
//#include "x2_inc_switches"
//#include "nw_i0_generic"
#include "_CSLCore_Player"
#include "_CSLCore_Combat"

/*************************************************************************
 * CONSTANTS
 *************************************************************************/
const int SC_DECK_TOKEN_NAME = 9323;
const int SC_DECK_TOKEN_CARD_NAME = 9324;

    int RANGE_1_MIN = 0;
    int RANGE_1_MAX = 5;
    int RANGE_2_MIN = 6;
    int RANGE_2_MAX = 8;

    int RANGE_3_MIN = 9;
    int RANGE_3_MAX = 10;

    int RANGE_4_MIN = 11;
    int RANGE_4_MAX = 13;

    int RANGE_5_MIN = 14;
    int RANGE_5_MAX = 16;

    int RANGE_6_MIN = 17;
    int RANGE_6_MAX = 100;

    // * NUMBER OF ITEMS APPEARING
    int NUMBER_LOW_ONE   = 100; int NUMBER_MED_ONE    = 60; int NUMBER_HIGH_ONE   = 40;  int NUMBER_BOSS_ONE = 100;
    int NUMBER_LOW_TWO   = 0;   int NUMBER_MED_TWO    = 30; int NUMBER_HIGH_TWO   = 40;  int NUMBER_BOSS_TWO = 0;
    int NUMBER_LOW_THREE = 0;   int NUMBER_MED_THREE  = 10; int NUMBER_HIGH_THREE = 20;  int NUMBER_BOSS_THREE = 0;

    int NUMBER_BOOK_ONE = 75;
    int NUMBER_BOOK_TWO = 20;
    int NUMBER_BOOK_THREE = 5;

    // * AMOUNT OF GOLD BY VALUE
    float LOW_MOD_GOLD = 0.5;   float MEDIUM_MOD_GOLD = 1.0; float HIGH_MOD_GOLD = 3.0;
    // * FREQUENCY OF ITEM TYPE APPEARING BY TREASURE TYPE
    int LOW_PROB_BOOK    = 1;  int MEDIUM_PROB_BOOK =   1;  int HIGH_PROB_BOOK =1;
    int LOW_PROB_ANIMAL  = 0;  int MEDIUM_PROB_ANIMAL = 0;  int HIGH_PROB_ANIMAL = 0;
    int LOW_PROB_JUNK    = 2;  int MEDIUM_PROB_JUNK =    1;  int HIGH_PROB_JUNK = 1;
    int LOW_PROB_GOLD = 43;    int MEDIUM_PROB_GOLD =   38; int HIGH_PROB_GOLD = 15;
    int LOW_PROB_GEM  = 9;     int MEDIUM_PROB_GEM =    15; int HIGH_PROB_GEM = 15;
    int LOW_PROB_JEWEL = 4;    int MEDIUM_PROB_JEWEL =  6; int HIGH_PROB_JEWEL = 15;
    int LOW_PROB_ARCANE = 3;   int MEDIUM_PROB_ARCANE = 3; int HIGH_PROB_ARCANE = 3;
    int LOW_PROB_DIVINE = 3;   int MEDIUM_PROB_DIVINE = 3;  int HIGH_PROB_DIVINE = 3;
    int LOW_PROB_AMMO = 10;    int MEDIUM_PROB_AMMO =   5;  int HIGH_PROB_AMMO  =   3;
    int LOW_PROB_KIT = 5;      int MEDIUM_PROB_KIT =    5;  int HIGH_PROB_KIT   =   5;
    int LOW_PROB_POTION =17;   int MEDIUM_PROB_POTION = 20; int HIGH_PROB_POTION=   9;
    int LOW_PROB_TABLE2 = 3;   int MEDIUM_PROB_TABLE2 = 3; int HIGH_PROB_TABLE2=   30;


// * this is the percent chance that no treasure will be spawned by a creature dying
const int BK_CHANCE_OF_N0_MONSTERTREASURE = 80;

int    TREASURE_LOW = 1;
int    TREASURE_MEDIUM = 2;
int    TREASURE_HIGH = 3;
int    TREASURE_BOSS = 4;
int    TREASURE_BOOK = 5;


// * JUMP_LEVEL is used in a Specific item function
// * in the case where a generic item is called for within that function
// * it will create a generic item by adding JUMP_LEVEL to the character's
// * hit die for the purposes of the treasure evaluation.
// * May 2002: Lowered JUMP_LEVEL from 3 to 2

int JUMP_LEVEL = 2;

// Tags for the module-wide containers
string sModContLow  =     "X0_MOD_TREASURE_LOW";
string sModContMed  =     "X0_MOD_TREASURE_MED";
string sModContHigh =     "X0_MOD_TREASURE_HIGH";
string sModContUniq =     "X0_MOD_TREASURE_UNIQ";

// Tags for the area-specific containers
string sContLow  =     "X0_TREASURE_LOW";
string sContMed  =     "X0_TREASURE_MED";
string sContHigh =     "X0_TREASURE_HIGH";
string sContUniq =     "X0_TREASURE_UNIQ";

// Tag for the monster-specific containers
string sContMonster =     "X0_TREASURE_MONSTER";

// Gold item ResRef
string sGoldResRef = "NW_IT_GOLD001";

// Varname holding the number of treasure items
string sNumTreasureItemsVarname = "X0_NUM_TREASURE_ITEMS";

// Varname holding the base type of each treasure item
string sBaseTypeVarname = "X0_BASE_TYPE_TREASURE";

// Varname holding a reference to each treasure item 
string sTreasureItemVarname = "X0_TREASURE_ITEM"; 

// Varname indicating that the treasure container has been filled 
string sTreasureGeneratedVarname = "X0_TREASURE_HAS_BEEN_GENERATED";


int TREASURE_TYPE_LOW    = 1;
int TREASURE_TYPE_MED    = 2;
int TREASURE_TYPE_HIGH   = 3;
int TREASURE_TYPE_UNIQUE = 4;
int TREASURE_TYPE_MONSTER = 5;


// Special generalized base types.
// Giving these large values to make sure they never
// conflict with the actual base type values -- that
// would cause those base types to be non-specifiable.
int TREASURE_BASE_TYPE_WEAPON = 13000;
int TREASURE_BASE_TYPE_WEAPON_NOAMMO = 13001;
int TREASURE_BASE_TYPE_WEAPON_RANGED = 13002;
int TREASURE_BASE_TYPE_WEAPON_MELEE = 13003;
int TREASURE_BASE_TYPE_ARMOR = 13004;
int TREASURE_BASE_TYPE_CLOTHING = 13005;

// Probability of a single item being generated, 
// in percentage
int TREASURE_PROBABILITY_1 = 70;

// Probability of two items being generated, 
// in percentage
int TREASURE_PROBABILITY_2 = 20;

// Probability of an item being converted to gold
int TREASURE_GOLD_PROBABILITY = 35;

// Multiplier to use on the value of an item to convert it to gold
float X0_GOLD_MODIFIER = 0.50;

// This controls how long to delay the actual card effects for
// in order to make the message pop up before it happens
float SC_DECK_DELAY = 8.0;

/*************************************************************************
 * FUNCTION PROTOTYPES
 *************************************************************************/
/*
// Check if the deck has been used before by this creature
int GetHasUsedDeck(object oCaster);

// Mark that the deck has been used by this creature
void SetHasUsedDeck(object oCaster);

// Get the number of draws remaining
int GetNumberDeckDraws(object oCaster);

// Set the number of draws remaining
void SetNumberDeckDraws(object oCaster, int nDraws);

// Do a positive card draw
void DoDeckDrawPositive(object oCaster, int nTurn=0);

// Do a negative card draw
void DoDeckDrawNegative(object oCaster, int nTurn=0);

// Get a special deck-specific area if it exists and is available.
// This will start by checking for an area with just the given area
// tag. If that doesn't exist or is taken, it will start looking
// for areas tagged sAreaTag + number, until it finds one that is available.
// X0_DECK_DONJON1, X0_DECK_DONJON2, etc
// Returns OBJECT_INVALID if no area found.
object GetSpecialAreaForDeckCard(string sAreaTag);

// Get a special area and transport the caster (with
// associates but without party members) to the
// X0_DECK_START waypoint inside it.
//
// Returns TRUE on success, FALSE otherwise.
int DoSpecialAreaDeckCard(object oCaster, string sAreaTag, int nTurn=0);
*/
/*************************************************************************
 * CARD FUNCTIONS
 * If a card draw fails, it will return FALSE, otherwise will return TRUE.
 *************************************************************************/

/*
// ------- NEGATIVE CARDS

// The Fool card (negative)
// Lose 10,000 XP and get 2 extra cards.
int DoFoolDeckCard(object oCaster, int nTurn=0);

// The Donjon card (negative)
// If a donjon area is available, the caster and associates are transported
// there.
// The area should be tagged X0_DECK_DONJON1.
// The starting location should be tagged X0_DECK_START.
// See the Gauntlet area in module 3 of XP1 as an example.
// (This is a good model to use if you want to create a "Keep" or
// "Void" type card for your own module.)
int DoDonjonDeckCard(object oCaster, int nTurn=0);

// The Traitor card (negative)
// Change to diametrically-opposed alignment instantly.
int DoTraitorDeckCard(object oCaster, int nTurn=0);

// The Knave card (negative)
// All non-plot possessions not currently equipped are destroyed.
int DoKnaveDeckCard(object oCaster, int nTurn=0);

// The Plague card (negative)
// Permanent disease effect applied for duration of the module.
int DoPlagueDeckCard(object oCaster, int nTurn=0);

// The Looking Glass card (negative)
// Caster's henchman is replaced with an evil doppelganger.
int DoLookingGlassDeckCard(object oCaster, int nTurn=0);

// The Wyrm card (negative)
// A hostile ancient dragon is lured to the caster.
int DoWyrmDeckCard(object oCaster, int nTurn=0);


// ------- POSITIVE CARDS

// The Joker card (positive)
// Gain 10,000 XP and get 2 extra cards.
int DoJokerDeckCard(object oCaster, int nTurn=0);

// The Hoard card (positive)
// Gain 50-100,000 gold instantly
int DoHoardDeckCard(object oCaster, int nTurn=0);

// The Oracle card (positive)
// Gain permanent premonition effect for duration of the module
int DoOracleDeckCard(object oCaster, int nTurn=0);

// The Avatar card (positive)
// Caster is transformed into an avatar of their alignment.
int DoAvatarDeckCard(object oCaster, int nTurn=0);

// The Fountain card (positive)
// All of caster's items are recharged and all stacked items are
// filled up to the maximum possible number.
int DoFountainDeckCard(object oCaster, int nTurn=0);

// The Hatchling card (positive)
// A wyrmling of alignment-appropriate color appears and follows
// the caster as a summoned creature until damaged, at which point
// it transforms into an adult dragon and fights on the caster's behalf
// until all enemies are slain, then vanishes.
int DoHatchlingDeckCard(object oCaster, int nTurn=0);

// The Bequest card (positive)
// Gain a major unique magical item (this will respect the
// XP1 treasure system if it is used in the module, otherwise
// random boss-level treasure will be generated).
int DoBequestDeckCard(object oCaster, int nTurn=0);
*/
/*************************************************************************
 * FUNCTION DEFINITIONS
 *************************************************************************/


/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 * These functions are deliberately not prototyped and not intended
 * for use outside this library. 
 **********************************************************************/

// This function deliberately not prototyped. Should not be used
// outside this library. 
// Test whether a treasure container has been initialized for 
// specific base treasure type use. 
int SCTreasureGetIsContainerInitialized(object oBaseCont)
{
    return GetLocalInt(oBaseCont, "X0_CONTAINER_INITIALIZED");
}

// This function deliberately not prototyped. Should not be used
// outside this library. 
// Set whether a treasure container has been initialized for 
// specific base treasure type use. 
void SCTreasureSetIsContainerInitialized(object oBaseCont, int bInit=TRUE)
{
    SetLocalInt(oBaseCont, "X0_CONTAINER_INITIALIZED", bInit);
}

// Get the number of items in a base container
int SCGetNumItemsInBaseContainer(object oBaseCont)
{
    int nItems = GetLocalInt(oBaseCont, sNumTreasureItemsVarname);
    if (nItems != 0) {
        return nItems;
    }

    // Haven't initialized the number of items yet
    object oTmp = GetFirstItemInInventory(oBaseCont);
    while (GetIsObjectValid(oTmp)) {
        nItems++;
        oTmp = GetNextItemInInventory(oBaseCont);
    }
    SetLocalInt(oBaseCont, sNumTreasureItemsVarname, nItems);
    return nItems;
}

// This function deliberately not prototyped. Should not be used
// outside this library. 
// Initialize a treasure container to store the items contained
// inside as local variables on the container. 
void SCTreasureInitContainer(object oBaseCont)
{
    // don't do this twice
    if (SCTreasureGetIsContainerInitialized(oBaseCont)) {return;}

    // initialize
    int nItems = SCGetNumItemsInBaseContainer(oBaseCont);

    int i;
    object oTmp = OBJECT_INVALID;
    oTmp = GetFirstItemInInventory(oBaseCont);
    for (i=0; i < nItems && GetIsObjectValid(oTmp); i++) {
        // Store the item and its base type as local vars on 
        // the container object itself.
        string sIndex = IntToString(i);
        string sVar = sBaseTypeVarname + sIndex;
        SetLocalInt(oBaseCont, sVar, GetBaseItemType(oTmp));
        sVar = sTreasureItemVarname + sIndex;
        SetLocalObject(oBaseCont, sVar, oTmp);

        oTmp = GetNextItemInInventory(oBaseCont);
    }

    // mark as initialized
    SCTreasureSetIsContainerInitialized(oBaseCont);
}


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/
//::///////////////////////////////////////////////
//:: GetRange
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if nHD matches the correct
    level range for the indicated nCategory.
    (i.e., First to Fourth level characters
    are considered Range1)
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetRange(int nCategory, int nHD)
{
    int nMin = 0; int nMax = 0;
    switch (nCategory)
    {
        case 6: nMin = RANGE_6_MIN; nMax = RANGE_6_MAX; break;
        case 5: nMin = RANGE_5_MIN; nMax = RANGE_5_MAX; break;
        case 4: nMin = RANGE_4_MIN; nMax = RANGE_4_MAX; break;
        case 3: nMin = RANGE_3_MIN; nMax = RANGE_3_MAX; break;
        case 2: nMin = RANGE_2_MIN; nMax = RANGE_2_MAX; break;
        case 1: nMin = RANGE_1_MIN; nMax = RANGE_1_MAX; break;
    }

   //dbSpeak("nMin = " + IntToString(nMin));
   //dbSpeak("nMax = " + IntToString(nMax));
   //dbSpeak("GetRange.nHD = " + IntToString(nHD));
   if (nHD >= nMin && nHD <= nMax)
   {
    return TRUE;
   }

  return FALSE;

}

// Get the module-wide base container of the appropriate type.
// Possible values for nTreasureType:
//     TREASURE_TYPE_LOW    
//     TREASURE_TYPE_MED    
//     TREASURE_TYPE_HIGH   
//     TREASURE_TYPE_UNIQUE 
object SCTreasureGetModuleBaseContainer(int nTreasureType)
{
    object oCont = OBJECT_INVALID;
    string sContTag = "";

    if (nTreasureType == TREASURE_TYPE_LOW) {
        sContTag = sModContLow;
    } else if (nTreasureType == TREASURE_TYPE_MED) {
        sContTag = sModContMed;
    } else if (nTreasureType == TREASURE_TYPE_HIGH) {
        sContTag = sModContHigh;
    } else if (nTreasureType == TREASURE_TYPE_UNIQUE) {
        sContTag = sModContUniq;
    } else {
        // Invalid treasure type
        return oCont;
    }

    oCont = GetObjectByTag(sContTag);
    return oCont;
}


// Tack on the appropriate racialtype suffix
string SCGetRacialtypeChestTag(string sBaseTag, object oSource)
{
    string sCont = sBaseTag + "_";
    switch (GetRacialType(oSource)) {
    case RACIAL_TYPE_INVALID: return "";
    case RACIAL_TYPE_ABERRATION: sCont = sCont + "ABERRATION"; break;
    case RACIAL_TYPE_ANIMAL: sCont = sCont + "ANIMAL"; break;
    case RACIAL_TYPE_BEAST: sCont = sCont + "BEAST"; break;
    case RACIAL_TYPE_CONSTRUCT: sCont = sCont + "CONSTRUCT"; break;
    case RACIAL_TYPE_DRAGON: sCont = sCont + "DRAGON"; break;
    case RACIAL_TYPE_DWARF: sCont = sCont + "DWARF"; break;
    case RACIAL_TYPE_ELEMENTAL: sCont = sCont + "ELEMENTAL"; break;
    case RACIAL_TYPE_ELF: sCont = sCont + "ELF"; break;
    case RACIAL_TYPE_FEY: sCont = sCont + "FEY"; break;
    case RACIAL_TYPE_GIANT: sCont = sCont + "GIANT"; break;
    case RACIAL_TYPE_GNOME: sCont = sCont + "GNOME"; break;
    case RACIAL_TYPE_HALFELF: sCont = sCont + "HALFELF"; break;
    case RACIAL_TYPE_HALFLING: sCont = sCont + "HALFLING"; break;
    case RACIAL_TYPE_HALFORC: sCont = sCont + "HALFORC"; break;
    case RACIAL_TYPE_HUMAN: sCont = sCont + "HUMAN"; break;
    case RACIAL_TYPE_HUMANOID_GOBLINOID: sCont = sCont + "GOBLINOID"; break;
    case RACIAL_TYPE_HUMANOID_MONSTROUS: sCont = sCont + "MONSTROUS"; break;
    case RACIAL_TYPE_HUMANOID_ORC: sCont = sCont + "ORC"; break;
    case RACIAL_TYPE_HUMANOID_REPTILIAN: sCont = sCont + "REPTILIAN"; break;
    case RACIAL_TYPE_MAGICAL_BEAST: sCont = sCont + "MAGICAL_BEAST"; break;
    case RACIAL_TYPE_OUTSIDER: sCont = sCont + "OUTSIDER"; break;
    case RACIAL_TYPE_SHAPECHANGER: sCont = sCont + "SHAPECHANGER"; break;
    case RACIAL_TYPE_UNDEAD: sCont = sCont + "UNDEAD"; break;
    case RACIAL_TYPE_VERMIN: sCont = sCont + "VERMIN"; break;
    }
    
    return sCont;
}




// Find and return the right monster container, if
// available.
object SCGetMonsterBaseContainer(object oSource=OBJECT_SELF)
{
    object oCont = OBJECT_INVALID;
    string sContTag = "";

    // For monster treasure, we first check for
    // a chest with a tag matching the specific 
    // monster.
    // We strip numbers off the end of the tag first
    string sCreatureTag = GetTag(oSource);
    while ( CSLGetIsNumber(GetStringRight(sCreatureTag, 1)) ) {
        sCreatureTag = GetStringLeft(sCreatureTag, 
                                     GetStringLength(sCreatureTag)-1);
    }

    sContTag = sContMonster + "_" + sCreatureTag;
    oCont = GetObjectByTag(sContTag);
    if (GetIsObjectValid(oCont)) {
        return oCont;
    }

    // Didn't find that -- check for a chest for the
    // appropriate racialtype.
    sContTag = SCGetRacialtypeChestTag(sContMonster, oSource);
    oCont = GetObjectByTag(sContTag);
    if (GetIsObjectValid(oCont)) {
        return oCont;
    }

    // Didn't find that -- check for a module-wide 
    // monster chest
    oCont = GetObjectByTag(sContMonster);
    return oCont;
}


// Locate the nearest base container of the appropriate type.
// Possible values for nTreasureType:
//     TREASURE_TYPE_MONSTER    
//     TREASURE_TYPE_LOW    
//     TREASURE_TYPE_MED    
//     TREASURE_TYPE_HIGH   
//     TREASURE_TYPE_UNIQUE 
object SCTreasureGetNearestBaseContainer(int nTreasureType, 
                                   object oSource=OBJECT_SELF)
{
    object oCont = OBJECT_INVALID;
    int nType = nTreasureType;
    string sContTag = "";

    if (nType == TREASURE_TYPE_MONSTER) {
        oCont = SCGetMonsterBaseContainer(oSource);
        if (GetIsObjectValid(oCont)) 
            return oCont;
        
        // no monster-specific treasure set up
        nType = TREASURE_TYPE_LOW;
    }

    if (nType == TREASURE_TYPE_LOW) {
        sContTag = sContLow;
    } else if (nType == TREASURE_TYPE_MED) {
        sContTag = sContMed;
    } else if (nType == TREASURE_TYPE_HIGH) {
        sContTag = sContHigh;
    } else if (nType == TREASURE_TYPE_UNIQUE) {
        sContTag = sContUniq;
    } else {
        // Invalid treasure type
        return oCont;
    }

    oCont = GetNearestObjectByTag(sContTag);
    if (!GetIsObjectValid(oCont)) {
        // No area chest -- return the module-wide one
        return SCTreasureGetModuleBaseContainer(nType);
    }
    return oCont;
}

// *
// * TREASURE GENERATION FUNCTIONS
// *
    // *
    // * Non-Scaling Treasure
    // *
    void CreateBook(object oTarget)
    {
        int nBook1 = Random(31) + 1;
        string sRes = "NW_IT_BOOK01";

        if (nBook1 < 10)
        {
            sRes = "NW_IT_BOOK00" + IntToString(nBook1);
        }
        else
        {
            sRes = "NW_IT_BOOK0" + IntToString(nBook1);
        }
        //dbSpeak("Create book");
        CreateItemOnObject(sRes, oTarget);
    }

    void CreateAnimalPart(object oTarget)
    {

        string sRes = "";
        int nResult = Random(3) + 1;
        switch (nResult)
        {
            case 1: sRes = "NW_IT_MSMLMISC20"; break;
            case 2: sRes = "NW_IT_MMIDMISC05"; break;
            case 3: sRes = "NW_IT_MMIDMISC06"; break;
        }
        //dbSpeak("animal");
        CreateItemOnObject(sRes, oTarget);
    }

    void CreateJunk(object oTarget)
    {
        string sRes = "NW_IT_TORCH001";
        int NUM_ITEMS = 6;
        int nResult = Random(NUM_ITEMS) + 1;
        int nKit = 0;
        switch (nResult)
        {
            case 1: sRes = "NW_IT_MPOTION021"; break; //ale
            case 2: sRes = "NW_IT_MPOTION021"; break;   // ale
            case 3: sRes = "NW_IT_MPOTION023"; break; // wine
            case 4: sRes = "NW_IT_MPOTION021"; break; // ale
            case 5: sRes = "NW_IT_MPOTION022"; break; // spirits
            case 6: sRes = "NW_IT_TORCH001"; break; //torch
        }
        //dbSpeak("CreateJunk");
        CreateItemOnObject(sRes, oTarget);
    }
    
    void SCCreateGold(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        int nAmount = 0;

        if (GetRange(1, nHD))
        {
            nAmount = d10();
        }
        else if (GetRange(2, nHD))
        {
            nAmount = d20();
        }
        else if (GetRange(3, nHD))
        {
            nAmount = d20(2);
        }
        else if (GetRange(4, nHD))
        {
            nAmount = d20(5);
        }
        else if (GetRange(5, nHD))
        {
            nAmount = d20(8);
        }
        else if (GetRange(6, nHD))
        {
            nAmount = d20(10);
        }
        float nMod = 0.0;
        if (nTreasureType == TREASURE_LOW) nMod = LOW_MOD_GOLD;
        else if (nTreasureType == TREASURE_MEDIUM) nMod = MEDIUM_MOD_GOLD;
        else if (nTreasureType == TREASURE_HIGH) nMod = HIGH_MOD_GOLD;

        // * always at least 1gp is created
        nAmount = FloatToInt(nAmount * nMod);
        if (nAmount <= 0)
        {
            nAmount = 1;
        }
        //dbSpeak("gold");
        CreateItemOnObject("NW_IT_GOLD001", oTarget, nAmount);
    }
    
    void CreateGem(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sGem = "nw_it_gem001";
        if (GetRange(1, nHD))
        {
            int nRandom = Random(9) + 1;
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem001";  break;
                case 2: sGem = "nw_it_gem007";  break;
                case 3: sGem = "nw_it_gem002";  break;
                case 4: case 5: sGem = "nw_it_gem004"; break;
                case 6: case 7: sGem = "nw_it_gem014"; break;
                case 8: sGem = "nw_it_gem003";         break;
                case 9: sGem = "nw_it_gem015";         break;
            }
        }
        else if (GetRange(2, nHD))               // 30 GP Avg; 150 gp Max
        {
            int nRandom = d12();
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem001";         break;
                case 2: sGem = "nw_it_gem007";         break;
                case 3: sGem = "nw_it_gem002";         break;
                case 4: sGem = "nw_it_gem004";         break;
                case 5: case 6: sGem = "nw_it_gem014";  break;
                case 7: case 8: sGem = "nw_it_gem003";  break;
                case 9: case 10: sGem = "nw_it_gem015"; break;
                case 11: sGem = "nw_it_gem011";         break;
                case 12: sGem = "nw_it_gem013";         break;
            }

        }
        else if (GetRange(3, nHD))  // 75GP Avg; 500 gp max
        {
            int nRandom = d2();
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem013";         break;
                case 2: sGem = "nw_it_gem010";         break;
            }

        }
        else if (GetRange(4, nHD))  // 150 gp avg; 1000 gp max
        {
            int nRandom = d3();
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem013";  break;
                case 2: sGem = "nw_it_gem010";    break;
                case 3: sGem = "nw_it_gem008";           break;
            }
        }
        else if (GetRange(5, nHD))  // 300 gp avg; any
        {
            int nRandom = d6();
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem013";  break;
                case 2: sGem = "nw_it_gem010";    break;
                case 3: case 4: sGem = "nw_it_gem008";           break;
                case 5: sGem = "nw_it_gem009";           break;
                case 6: sGem = "nw_it_gem009";           break;
            }
        }
        else if (GetRange(6, nHD))// * Anything higher than level 15    500 gp avg; any
        {
            int nRandom = Random(8) + 1;
            switch (nRandom)
            {
                case 1: sGem = "nw_it_gem013";  break;
                case 2: sGem = "nw_it_gem010";    break;
                case 3: case 4: sGem = "nw_it_gem008";           break;
                case 5: sGem = "nw_it_gem009";           break;
                case 6: sGem = "nw_it_gem009";           break;
                case 7: sGem = "nw_it_gem006";           break;
                case 8: sGem = "nw_it_gem012";           break;
            }
        }
      //dbSpeak("Create Gem");
      CreateItemOnObject(sGem, oTarget, 1);
    }
    void CreateJewel(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sJewel = "";

        if (GetRange(1, nHD))        // 15 gp avg; 75 gp max
        {
          int nRandom = d2();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";   break;
            case 2: sJewel = "nw_it_mneck020";   break;
          }
        }
        else if (GetRange(2, nHD))   // 30 GP Avg; 150 gp Max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";            break;
            case 2: case 3: sJewel = "nw_it_mneck020";    break;
            case 4: sJewel = "nw_it_mring022";            break;
            case 5: case 6: sJewel = "nw_it_mneck023";            break;          }
        }
        else if (GetRange(3, nHD))  // 75GP Avg; 500 gp max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";           break;
            case 2: case 3: sJewel = "nw_it_mneck020";   break;
            case 4: case 5: sJewel = "nw_it_mring022";   break;
            case 6: sJewel = "nw_it_mneck021";           break;
          }
        }
        else if (GetRange(4, nHD))  // 150 gp avg; 1000 gp max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";            break;
            case 2: sJewel = "nw_it_mring022";            break;
            case 3: case 4: case 5: sJewel = "nw_it_mneck021";    break;
            case 6: sJewel = "nw_it_mring023";            break;
          }
        }
        else if (GetRange(5, nHD))  // 300 gp avg; any
        {
          int nRandom = d8();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring022";           break;
            case 2: case 3: sJewel = "nw_it_mneck021";   break;
            case 4: case 5: case 6: sJewel = "nw_it_mring023"; break;
            case 7: case 8: sJewel = "nw_it_mneck022";               break;
          }
        }
        else if (GetRange(6, nHD))
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring022";              break;
            case 2: sJewel = "nw_it_mneck021";              break;
            case 3: case 4: sJewel = "nw_it_mring023";      break;
            case 5: case 6: sJewel = "nw_it_mneck022";      break;
          }
        }
      //dbSpeak("Create Jewel");

      CreateItemOnObject(sJewel, oTarget, 1);

    }
    // * returns the valid upper limit for any arcane spell scroll
    int TrimLevel(int nScroll, int nLevel)
    {   int nMax = 5;
        switch (nLevel)
        {
            case 0: nMax = 4; break;
            case 1: nMax = 13; break;
            case 2: nMax = 21; break;
            case 3: nMax = 15; break;
            case 4: nMax = 17; break;
            case 5: nMax = 13; break;
            case 6: nMax = 14; break;
            case 7: nMax = 8; break;
            case 8: nMax = 9; break;
            case 9: nMax = 12; break;
        }
        if (nScroll > nMax) nScroll = nMax;
        return nScroll;

    }

       void CreateGenericMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wbwsl001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspka001"; break;
                       case 7: sItem = "nw_wbwxh001"; break;
                       case 8: sItem = "nw_waxhn001"; break;
                       case 9: sItem = "nw_wbwxl001"; break;
                       case 10: sItem = "nw_wthmsh002"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wbwsl001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspka001"; break;
                       case 7: sItem = "nw_wbwxh001"; break;
                       case 8: sItem = "nw_waxhn001"; break;
                       case 9: sItem = "nw_wbwxl001"; break;
                       case 10: sItem = "nw_wthmsh002"; break;
                       case 11: sItem = "nw_wbwmsl001"; break;
                       case 12: sItem = "nw_wbwmxh002"; break;
                       case 13: sItem = "nw_wthmsh008"; break;
                       case 14: sItem = "nw_wbwmxl002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl001"; break;
                       case 2: sItem = "nw_wbwmxh002"; break;
                       case 3: sItem = "nw_wthmsh008"; break;
                       case 4: sItem = "nw_wbwmxl002"; break;
                       case 5: sItem = "nw_wthmsh009"; break;
                       case 6: sItem = "nw_wblmcl002"; break;
                       case 7: sItem = "nw_wdbmqs002"; break;
                       case 8: sItem = "nw_wswmdg002"; break;
                       case 9: sItem = "nw_wspmka002"; break;
                       case 10: sItem = "nw_waxmhn002"; break;
                       case 11: sItem = "nw_wbwmsl009"; break;
                       case 12: sItem = "nw_wbwmxh008"; break;
                       case 13: sItem = "nw_wbwmxl008"; break;
                   }


            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh009"; break;
                       case 2: sItem = "nw_wblmcl002"; break;
                       case 3: sItem = "nw_wdbmqs002"; break;
                       case 4: sItem = "nw_wswmdg002"; break;
                       case 5: sItem = "nw_wspmka002"; break;
                       case 6: sItem = "nw_waxmhn002"; break;
                       case 7: sItem = "nw_wbwmsl009"; break;
                       case 8: sItem = "nw_wbwmxh008"; break;
                       case 9: sItem = "nw_wbwmxl008"; break;
                       case 10: sItem = "nw_wbwmsl010"; break;
                       case 11: sItem = "nw_wbwmxh009"; break;
                       case 12: sItem = "nw_wbwmxl009"; break;
                       case 13: sItem = "nw_wblmcl010"; break;
                       case 14: sItem = "nw_wdbmqs008"; break;
                       case 15: sItem = "nw_wswmdg008"; break;
                       case 16: sItem = "nw_wspmka008"; break;
                       case 17: sItem = "nw_waxmhn010"; break;
                   }
            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl010"; break;
                       case 2: sItem = "nw_wbwmxh009"; break;
                       case 3: sItem = "nw_wbwmxl009"; break;
                       case 4: sItem = "nw_wblmcl010"; break;
                       case 5: sItem = "nw_wdbmqs008"; break;
                       case 6: sItem = "nw_wswmdg008"; break;
                       case 7: sItem = "nw_wspmka008"; break;
                       case 8: sItem = "nw_waxmhn010"; break;
                       case 9: sItem = "nw_wblmcl011"; break;
                       case 10: sItem = "nw_wdbmqs009"; break;
                       case 11: sItem = "nw_wswmdg009"; break;
                       case 12: sItem = "nw_wspmka009"; break;
                       case 13: sItem = "nw_waxmhn011"; break;
                   }
            }
          //dbSpeak("Generic Monk Weapon");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh003"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: CreateGenericMonkWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                  }

            }
            else if (GetRange(2, nHD))   // * 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh003"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: sItem = "nw_wthmsh004"; break;
                       case 4: sItem = "nw_wthmsh007"; break;
                       case 5: sItem = "NW_IT_MGLOVE016"; break;
                       case 6: sItem = "NW_IT_MGLOVE021"; break;
                       case 7: sItem = "NW_IT_MGLOVE026"; break;
                       case 8: CreateGenericMonkWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(21) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh006"; break;
                       case 2: sItem = "nw_wthmsh004"; break;
                       case 3: sItem = "nw_wthmsh007"; break;
                       case 4: sItem = "nw_wbwmsl005"; break;
                       case 5: sItem = "nw_wbwmxh005"; break;
                       case 6: sItem = "nw_wspmka004"; break;
                       case 7: sItem = "nw_wbwmxl005"; break;
                       case 8: sItem = "nw_wspmka007"; break;
                       case 9: sItem = "nw_wswmdg006"; break;
                       case 10: sItem = "nw_wspmka005"; break;
                       case 11: sItem = "NW_IT_MGLOVE016"; break;
                       case 12: sItem = "NW_IT_MGLOVE021"; break;
                       case 13: sItem = "NW_IT_MGLOVE026"; break;

                       case 14: sItem = "NW_IT_MGLOVE017"; break;
                       case 15: sItem = "NW_IT_MGLOVE022"; break;
                       case 16: sItem = "NW_IT_MGLOVE027"; break;

                       case 17: sItem = "NW_IT_MGLOVE018"; break;
                       case 18: sItem = "NW_IT_MGLOVE023"; break;
                       case 19: sItem = "NW_IT_MGLOVE028"; break;

                       case 20: sItem = "NW_IT_MGLOVE029"; break;
                       case 21: sItem = "NW_IT_MGLOVE030"; break;


                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(22) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl005"; break;
                       case 2: sItem = "nw_wbwmxh005"; break;
                       case 3: sItem = "nw_wspmka004"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wspmka007"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wspmka005"; break;
                       case 8: sItem = "nw_wblmcl004"; break;
                       case 9: sItem = "nw_wblmcl003"; break;
                       case 10: sItem = "nw_wbwmsl003"; break;
                       case 11: sItem = "nw_wbwmxh003"; break;
                       case 12: sItem = "nw_waxmhn004"; break;
                       case 13: sItem = "nw_wbwmxl003"; break;

                       case 14: sItem = "NW_IT_MGLOVE017"; break;
                       case 15: sItem = "NW_IT_MGLOVE022"; break;

                       case 16: sItem = "NW_IT_MGLOVE018"; break;
                       case 17: sItem = "NW_IT_MGLOVE023"; break;
                       case 18: sItem = "NW_IT_MGLOVE028"; break;

                       case 19: sItem = "NW_IT_MGLOVE029"; break;
                       case 20: sItem = "NW_IT_MGLOVE030"; break;

                       case 21: sItem = "NW_IT_MGLOVE019"; break;
                       case 22: sItem = "NW_IT_MGLOVE024"; break;


                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(24) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wspmka006"; break;
                       case 3: sItem = "nw_wbwmxl004"; break;
                       case 4: sItem = "nw_wspmka003"; break;
                       case 5: sItem = "nw_wbwmxl007"; break;
                       case 6: sItem = "nw_waxmhn003"; break;
                       case 7: sItem = "nw_wblmcl005"; break;
                       case 8: sItem = "nw_wswmdg004"; break;
                       case 9: sItem = "nw_wbwmsl007"; break;
                       case 10: sItem = "nw_wbwmxh004"; break;
                       case 11: sItem = "nw_waxmhn005"; break;
                       case 12: sItem = "nw_wbwmxh007"; break;
                       case 13: sItem = "nw_wswmdg003"; break;
                       case 14: sItem = "nw_wswmdg007"; break;
                       case 15: sItem = "nw_wbwmsl006"; break;
                       case 16: sItem = "nw_wbwmsl008"; break;
                       case 17: sItem = "nw_wblmcl006"; break;
                       case 18: sItem = "nw_wbwmsl004"; break;
                       case 19: sItem = "nw_waxmhn006"; break;
                       case 20: sItem = "nw_wbwmxh006"; break;
                       case 21: sItem = "nw_wswmdg005"; break;
                       case 22: sItem = "nw_wbwmxl006"; break;

                       case 23: sItem = "NW_IT_MGLOVE020"; break;
                       case 24: sItem = "NW_IT_MGLOVE025"; break;

                   }

            }
           //dbSpeak("Specific Monk Weapon");

           CreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthdt001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wplss001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspsc001"; break;
                       case 7: sItem = "nw_wswsc001"; break;
                       case 8: sItem = "nw_wthmdt002"; break;
                   }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthdt001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wplss001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspsc001"; break;
                       case 7: sItem = "nw_wswsc001"; break;
                       case 8: sItem = "nw_wthmdt002"; break;
                       case 9: sItem = "nw_wthmdt005"; break;
                       case 10: sItem = "nw_wbwmsl001"; break;
                       case 11: sItem = "nw_wthmdt008"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt005"; break;
                       case 2: sItem = "nw_wbwmsl001"; break;
                       case 3: sItem = "nw_wthmdt008"; break;
                       case 4: sItem = "nw_wthmdt009"; break;
                       case 5: sItem = "nw_wthmdt006"; break;
                       case 6: sItem = "nw_wblmcl002"; break;
                       case 7: sItem = "nw_wdbmqs002"; break;
                       case 8: sItem = "nw_wplmss002"; break;
                       case 9: sItem = "nw_wswmdg002"; break;
                       case 10: sItem = "nw_wspmsc002"; break;
                       case 11: sItem = "nw_wswmsc002"; break;
                       case 12: sItem = "nw_wthmdt003"; break;
                       case 13: sItem = "nw_wbwmsl009"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(19) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt009"; break;
                       case 2: sItem = "nw_wthmdt006"; break;
                       case 3: sItem = "nw_wblmcl002"; break;
                       case 4: sItem = "nw_wdbmqs002"; break;
                       case 5: sItem = "nw_wplmss002"; break;
                       case 6: sItem = "nw_wswmdg002"; break;
                       case 7: sItem = "nw_wspmsc002"; break;
                       case 8: sItem = "nw_wswmsc002"; break;
                       case 9: sItem = "nw_wthmdt003"; break;
                       case 10: sItem = "nw_wbwmsl009"; break;
                       case 11: sItem = "nw_wthmdt007"; break;
                       case 12: sItem = "nw_wthmdt004"; break;
                       case 13: sItem = "nw_wbwmsl010"; break;
                       case 14: sItem = "nw_wblmcl010"; break;
                       case 15: sItem = "nw_wdbmqs008"; break;
                       case 16: sItem = "nw_wplmss010"; break;
                       case 17: sItem = "nw_wswmdg008"; break;
                       case 18: sItem = "nw_wspmsc010"; break;
                       case 19: sItem = "nw_wswmsc010"; break;
                   }

            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt007"; break;
                       case 2: sItem = "nw_wthmdt004"; break;
                       case 3: sItem = "nw_wbwmsl010"; break;
                       case 4: sItem = "nw_wblmcl010"; break;
                       case 5: sItem = "nw_wdbmqs008"; break;
                       case 6: sItem = "nw_wplmss010"; break;
                       case 7: sItem = "nw_wswmdg008"; break;
                       case 8: sItem = "nw_wspmsc010"; break;
                       case 9: sItem = "nw_wswmsc010"; break;
                       case 10: sItem = "nw_wblmcl011"; break;
                       case 11: sItem = "nw_wdbmqs009"; break;
                       case 12: sItem = "nw_wplmss011"; break;
                       case 13: sItem = "nw_wswmdg009"; break;
                       case 14: sItem = "nw_wspmsc011"; break;
                       case 15: sItem = "nw_wswmsc011"; break;
                   }

            }
          //dbSpeak("Generic Druid weapon");

           CreateItemOnObject(sItem, oTarget, 1);


        }
        void CreateSpecificDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;

            }
            else if (GetRange(2, nHD))   // * 2500
            {
                CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmsl005"; break;
                       case 4: sItem = "nw_wswmdg006"; break;
                       case 5: CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmsl005"; break;
                       case 4: sItem = "nw_wswmdg006"; break;
                       case 5: sItem = "nw_wblmcl004"; break;
                       case 6: sItem = "nw_wdbmqs004"; break;
                       case 7: sItem = "nw_wblmcl003"; break;
                       case 8: sItem = "nw_wbwmsl003"; break;
                       case 9: sItem = "nw_wswmsc004"; break;
                       case 10: sItem = "nw_wplmss005"; break;
                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(18) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs003"; break;
                       case 2: sItem = "nw_wblmcl005"; break;
                       case 3: sItem = "nw_wplmss007"; break;
                       case 4: sItem = "nw_wswmdg004"; break;
                       case 5: sItem = "nw_wbwmsl007"; break;
                       case 6: sItem = "nw_wplmss006"; break;
                       case 7: sItem = "nw_wswmsc006"; break;
                       case 8: sItem = "nw_wswmdg003"; break;
                       case 9: sItem = "nw_wswmdg007"; break;
                       case 10: sItem = "nw_wswmsc007"; break;
                       case 11: sItem = "nw_wbwmsl006"; break;
                       case 12: sItem = "nw_wbwmsl008"; break;
                       case 13: sItem = "nw_wdbmqs007"; break;
                       case 14: sItem = "nw_wblmcl006"; break;
                       case 15: sItem = "nw_wbwmsl004"; break;
                       case 16: sItem = "nw_wswmsc005"; break;
                       case 17: sItem = "nw_wplmss004"; break;
                       case 18: sItem = "nw_wswmdg005"; break;
                   }

            }
          //dbSpeak("specific druid weapon");

           CreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblcl001"; break;
                       case 2: sItem = "nw_wdbqs001"; break;
                       case 3: sItem = "nw_wswdg001"; break;
                       case 4: sItem = "nw_wbwxh001"; break;
                       case 5: sItem = "nw_wbwxl001"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblcl001"; break;
                       case 2: sItem = "nw_wdbqs001"; break;
                       case 3: sItem = "nw_wswdg001"; break;
                       case 4: sItem = "nw_wbwxh001"; break;
                       case 5: sItem = "nw_wbwxl001"; break;
                       case 6: sItem = "nw_wbwmxl002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl002"; break;
                       case 2: sItem = "nw_wblmcl002"; break;
                       case 3: sItem = "nw_wdbmqs002"; break;
                       case 4: sItem = "nw_wswmdg002"; break;
                       case 5: sItem = "nw_wbwmxh008"; break;
                       case 6: sItem = "nw_wbwmxl008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl002"; break;
                       case 2: sItem = "nw_wdbmqs002"; break;
                       case 3: sItem = "nw_wswmdg002"; break;
                       case 4: sItem = "nw_wbwmxh008"; break;
                       case 5: sItem = "nw_wbwmxl008"; break;
                       case 6: sItem = "nw_wbwmxh009"; break;
                       case 7: sItem = "nw_wbwmxl009"; break;
                       case 8: sItem = "nw_wblmcl010"; break;
                       case 9: sItem = "nw_wdbmqs008"; break;
                       case 10: sItem = "nw_wswmdg008"; break;
                   }

            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh009"; break;
                       case 2: sItem = "nw_wbwmxl009"; break;
                       case 3: sItem = "nw_wblmcl010"; break;
                       case 4: sItem = "nw_wdbmqs008"; break;
                       case 5: sItem = "nw_wswmdg008"; break;
                       case 6: sItem = "nw_wblmcl011"; break;
                       case 7: sItem = "nw_wdbmqs009"; break;
                       case 8: sItem = "nw_wswmdg009"; break;
                   }

            }
          //dbSpeak("Generic Wizard or Sorcerer Weapon");

           CreateItemOnObject(sItem, oTarget, 1);

        }
        
        void CreateSpecificWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericWizardWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(2, nHD))   // * 2500
            {
                CreateGenericWizardWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmxh005"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wswmdg006"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmxh005"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wswmdg006"; break;
                       case 6: sItem = "nw_wblmcl004"; break;
                       case 7: sItem = "nw_wdbmqs004"; break;
                       case 8: sItem = "nw_wblmcl003"; break;
                       case 9: sItem = "nw_wbwmxh003"; break;
                       case 10: sItem = "nw_wbwmxl003"; break;
                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wdbmqs003"; break;
                       case 3: sItem = "nw_wbwmxl004"; break;
                       case 4: sItem = "nw_wbwmxl007"; break;
                       case 5: sItem = "nw_wblmcl005"; break;
                       case 6: sItem = "nw_wswmdg004"; break;
                       case 7: sItem = "nw_wbwmxh004"; break;
                       case 8: sItem = "nw_wbwmxh007"; break;
                       case 9: sItem = "nw_wswmdg003"; break;
                       case 10: sItem = "nw_wswmdg007"; break;
                       case 11: sItem = "nw_wdbmqs007"; break;
                       case 12: sItem = "nw_wblmcl006"; break;
                       case 13: sItem = "nw_wbwmxh006"; break;
                       case 14: sItem = "nw_wswmdg005"; break;
                       case 15: sItem = "nw_wbwmxl006"; break;
                   }

            }
          //dbSpeak("Specific Wizard or Sorcerer Weapon");

           CreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericSimple(object oTarget, object oAdventurer, int nModifier = 0)
        {
           string sItem = "";
           int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = d12();
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthdt001"; break;
                    case 2: sItem = "nw_wblcl001"; break;
                    case 3: sItem = "nw_wbwsl001"; break;
                    case 4: sItem = "nw_wplss001"; break;
                    case 5: sItem = "nw_wdbqs001"; break;
                    case 6: sItem = "nw_wswdg001"; break;
                    case 7: sItem = "nw_wblml001"; break;
                    case 8: sItem = "nw_wbwxh001"; break;
                    case 9: sItem = "nw_wspsc001"; break;
                    case 10: sItem = "nw_wblms001"; break;
                    case 11: sItem = "nw_wbwxl001"; break;
                    case 12: sItem = "nw_wthmdt002"; break;
                }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(17) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthdt001"; break;
                    case 2: sItem = "nw_wblcl001"; break;
                    case 3: sItem = "nw_wbwsl001"; break;
                    case 4: sItem = "nw_wplss001"; break;
                    case 5: sItem = "nw_wdbqs001"; break;
                    case 6: sItem = "nw_wswdg001"; break;
                    case 7: sItem = "nw_wblml001"; break;
                    case 8: sItem = "nw_wbwxh001"; break;
                    case 9: sItem = "nw_wspsc001"; break;
                    case 10: sItem = "nw_wblms001"; break;
                    case 11: sItem = "nw_wbwxl001"; break;
                    case 12: sItem = "nw_wthmdt002"; break;
                    case 13: sItem = "nw_wthmdt005"; break;
                    case 14: sItem = "nw_wbwmsl001"; break;
                    case 15: sItem = "nw_wbwmxh002"; break;
                    case 16: sItem = "nw_wthmdt008"; break;
                    case 17: sItem = "nw_wbwmxl002"; break;
                }
            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(19) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt005"; break;
                    case 2: sItem = "nw_wbwmsl001"; break;
                    case 3: sItem = "nw_wbwmxh002"; break;
                    case 4: sItem = "nw_wthmdt008"; break;
                    case 5: sItem = "nw_wbwmxl002"; break;
                    case 6: sItem = "nw_wthmdt009"; break;
                    case 7: sItem = "nw_wthmdt006"; break;
                    case 8: sItem = "nw_wblmcl002"; break;
                    case 9: sItem = "nw_wplmss002"; break;
                    case 10: sItem = "nw_wdbmqs002"; break;
                    case 11: sItem = "nw_wswmdg002"; break;
                    case 12: sItem = "nw_wblmml002"; break;
                    case 13: sItem = "nw_wspmsc002"; break;
                    case 14: sItem = "nw_wblmms002"; break;
                    case 15: sItem = "nw_wthmdt003"; break;
                    case 16: sItem = "nw_wthmdt003"; break;
                    case 17: sItem = "nw_wbwmsl009"; break;
                    case 18: sItem = "nw_wbwmxh008"; break;
                    case 19: sItem = "nw_wbwmxl008"; break;
                }
            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(27) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt009"; break;
                    case 2: sItem = "nw_wthmdt006"; break;
                    case 3: sItem = "nw_wblmcl002"; break;
                    case 4: sItem = "nw_wplmss002"; break;
                    case 5: sItem = "nw_wdbmqs002"; break;
                    case 6: sItem = "nw_wswmdg002"; break;
                    case 7: sItem = "nw_wblmml002"; break;
                    case 8: sItem = "nw_wspmsc002"; break;
                    case 9: sItem = "nw_wblmms002"; break;
                    case 10: sItem = "nw_wthmdt003"; break;
                    case 11: sItem = "nw_wthmdt003"; break;
                    case 12: sItem = "nw_wbwmsl009"; break;
                    case 13: sItem = "nw_wbwmxh008"; break;
                    case 14: sItem = "nw_wbwmxl008"; break;
                    case 15: sItem = "nw_wthmdt007"; break;
                    case 16: sItem = "nw_wthmdt004"; break;
                    case 17: sItem = "nw_wbwmsl010"; break;
                    case 18: sItem = "nw_wbwmxh009"; break;
                    case 19: sItem = "nw_wbwmxl009"; break;
                    case 20: sItem = "nw_wbwmsl005"; break;
                    case 21: sItem = "nw_wblmcl010"; break;
                    case 22: sItem = "nw_wplmss010"; break;
                    case 23: sItem = "nw_wdbmqs008"; break;
                    case 24: sItem = "nw_wswmdg008"; break;
                    case 25: sItem = "nw_wblmml011"; break;
                    case 26: sItem = "nw_wspmsc010"; break;
                    case 27: sItem = "nw_wblmms010"; break;



                }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                int nRandom = Random(23) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt007"; break;
                    case 2: sItem = "nw_wthmdt004"; break;
                    case 3: sItem = "nw_wbwmsl010"; break;
                    case 4: sItem = "nw_wbwmxh009"; break;
                    case 5: sItem = "nw_wbwmxl009"; break;
                    case 6: sItem = "nw_wbwmsl005"; break;
                    case 7: sItem = "nw_wblmcl010"; break;
                    case 8: sItem = "nw_wplmss010"; break;
                    case 9: sItem = "nw_wdbmqs008"; break;
                    case 10: sItem = "nw_wswmdg008"; break;
                    case 11: sItem = "nw_wblmml011"; break;
                    case 12: sItem = "nw_wspmsc010"; break;
                    case 13: sItem = "nw_wblmms010"; break;
                    case 14: sItem = "nw_wblmms010"; break;
                    case 15: sItem = "nw_wblmms010"; break;
                    case 16: sItem = "nw_wblmms010"; break;
                    case 17: sItem = "nw_wblmcl011"; break;
                    case 18: sItem = "nw_wplmss011"; break;
                    case 19: sItem = "nw_wdbmqs009"; break;
                    case 20: sItem = "nw_wswmdg009"; break;
                    case 21: sItem = "nw_wblmml012"; break;
                    case 22: sItem = "nw_wspmsc011"; break;
                    case 23: sItem = "nw_wblmms011"; break;



                }
            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                int nRandom = Random(7) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wblmcl011"; break;
                    case 2: sItem = "nw_wplmss011"; break;
                    case 3: sItem = "nw_wdbmqs009"; break;
                    case 4: sItem = "nw_wswmdg009"; break;
                    case 5: sItem = "nw_wblmml012"; break;
                    case 6: sItem = "nw_wspmsc011"; break;
                    case 7: sItem = "nw_wblmms011"; break;



                }
            }
            //dbSpeak("Create Generic SImple; Specific = " + IntToString(nModifier));

            CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericMartial(object oTarget, object oAdventurer, int nModifier = 0)
        {
           string sItem = "";

            int nHD = GetHitDice(oAdventurer) +nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(17) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthax001"; break;
                    case 2: sItem = "nw_wblhl001"; break;
                    case 3: sItem = "nw_waxhn001"; break;
                    case 4: sItem = "nw_wblfl001"; break;
                    case 5: sItem = "nw_waxbt001"; break;
                    case 6: sItem = "nw_wplhb001"; break;
                    case 7: sItem = "nw_wswss001"; break;
                    case 8: sItem = "nw_wblhw001"; break;
                    case 9: sItem = "nw_wblfh001"; break;
                    case 10: sItem = "nw_wswls001"; break;
                    case 11: sItem = "nw_wswsc001"; break;
                    case 12: sItem = "nw_waxgr001"; break;
                    case 13: sItem = "nw_wswrp001"; break;
                    case 14: sItem = "nw_wbwsh001"; break;
                    case 15: sItem = "nw_wswbs001"; break;
                    case 16: sItem = "nw_wswgs001"; break;
                    case 17: sItem = "nw_wbwln001"; break;
                }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(20) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthax001"; break;
                    case 2: sItem = "nw_wblhl001"; break;
                    case 3: sItem = "nw_waxhn001"; break;
                    case 4: sItem = "nw_wblfl001"; break;
                    case 5: sItem = "nw_waxbt001"; break;
                    case 6: sItem = "nw_wplhb001"; break;
                    case 7: sItem = "nw_wswss001"; break;
                    case 8: sItem = "nw_wblhw001"; break;
                    case 9: sItem = "nw_wblfh001"; break;
                    case 10: sItem = "nw_wswls001"; break;
                    case 11: sItem = "nw_wswsc001"; break;
                    case 12: sItem = "nw_waxgr001"; break;
                    case 13: sItem = "nw_wswrp001"; break;
                    case 14: sItem = "nw_wbwsh001"; break;
                    case 15: sItem = "nw_wswbs001"; break;
                    case 16: sItem = "nw_wswgs001"; break;
                    case 17: sItem = "nw_wbwln001"; break;
                    case 18: sItem = "nw_wthmax002"; break;
                    case 19: sItem = "nw_wbwmsh002"; break;
                    case 20: sItem = "nw_wbwmln002"; break;
                }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(20) + 1;
                switch (nRandom)
                {
                         case 1: sItem = "nw_wthmax002"; break;
                         case 2: sItem = "nw_wbwmsh002"; break;
                         case 3: sItem = "nw_wbwmln002"; break;
                         case 4: sItem = "nw_wblmhl002"; break;
                         case 5: sItem = "nw_waxmhn002"; break;
                         case 6: sItem = "nw_wblmfl002"; break;
                         case 7: sItem = "nw_waxmbt002"; break;
                         case 8: sItem = "nw_wplmhb002"; break;
                         case 9: sItem = "nw_wblmhw002"; break;
                         case 10: sItem = "nw_wblmfh002"; break;
                         case 11: sItem = "nw_wswmls002"; break;
                         case 12: sItem = "nw_wswmsc002"; break;
                         case 13: sItem = "nw_waxmgr002"; break;
                         case 14: sItem = "nw_wswmrp002"; break;
                         case 15: sItem = "nw_wswmbs002"; break;
                         case 16: sItem = "nw_wswmgs002"; break;
                         case 17: sItem = "nw_wthmax008"; break;
                         case 18: sItem = "nw_wbwmsh008"; break;
                         case 19: sItem = "nw_wbwmln008"; break;
                         case 20: sItem = "nw_wswmss002"; break;

                 }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(33) + 1;
                switch (nRandom)
                {
                     case 1: sItem = "nw_wblmhl002"; break;
                     case 2: sItem = "nw_waxmhn002"; break;
                     case 3: sItem = "nw_wblmfl002"; break;
                     case 4: sItem = "nw_waxmbt002"; break;
                     case 5: sItem = "nw_wplmhb002"; break;
                     case 6: sItem = "nw_wblmhw002"; break;
                     case 7: sItem = "nw_wblmfh002"; break;
                     case 8: sItem = "nw_wswmls002"; break;
                     case 9: sItem = "nw_wswmsc002"; break;
                     case 10: sItem = "nw_waxmgr002"; break;
                     case 11: sItem = "nw_wswmrp002"; break;
                     case 12: sItem = "nw_wswmbs002"; break;
                     case 13: sItem = "nw_wswmgs002"; break;
                     case 14: sItem = "nw_wthmax008"; break;
                     case 15: sItem = "nw_wbwmsh008"; break;
                     case 16: sItem = "nw_wbwmln008"; break;
                     case 17: sItem = "nw_wbwmsh009"; break;
                     case 18: sItem = "nw_wbwmln009"; break;
                     case 19: sItem = "nw_wblmhl010"; break;
                     case 20: sItem = "nw_waxmhn010"; break;
                     case 21: sItem = "nw_wblmfl010"; break;
                     case 22: sItem = "nw_waxmbt010"; break;
                     case 23: sItem = "nw_wplmhb010"; break;
                     case 24: sItem = "nw_wblmhw011"; break;
                     case 25: sItem = "nw_wblmfh010"; break;
                     case 26: sItem = "nw_wswmls010"; break;
                     case 27: sItem = "nw_waxmgr009"; break;
                     case 28: sItem = "nw_wswmbs009"; break;
                     case 29: sItem = "nw_wswmgs011"; break;
                     case 30: sItem = "nw_wswmrp010"; break;
                    case 31: sItem = "nw_wswmsc010"; break;
                    case 32: sItem = "nw_wswmss002"; break;
                    case 33: sItem = "nw_wswmss009"; break;
                 }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(20) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh009"; break;
                       case 2: sItem = "nw_wbwmln009"; break;
                       case 3: sItem = "nw_wblmhl010"; break;
                       case 4: sItem = "nw_waxmhn010"; break;
                       case 5: sItem = "nw_wblmfl010"; break;
                       case 6: sItem = "nw_waxmbt010"; break;
                       case 7: sItem = "nw_wplmhb010"; break;
                       case 8: sItem = "nw_wblmhw011"; break;
                       case 9: sItem = "nw_wblmfh010"; break;
                       case 10: sItem = "nw_wswmls010"; break;
                       case 11: sItem = "nw_waxmgr009"; break;
                       case 12: sItem = "nw_wswmbs009"; break;
                       case 13: sItem = "nw_wswmgs011"; break;
                       case 14: sItem = "nw_wthmax009"; break;
                        case 15: sItem = "nw_wswmrp010"; break;
                        case 16: sItem = "nw_wswmrp011"; break;
                        case 17: sItem = "nw_wswmsc010"; break;
                        case 18: sItem = "nw_wswmss009"; break;
                        case 19: sItem = "nw_wswmsc011"; break;
                        case 20: sItem = "nw_wswmss011"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax009"; break;
                       case 2: sItem = "nw_waxmhn011"; break;
                       case 3: sItem = "nw_wblmfl011"; break;
                       case 4: sItem = "nw_waxmbt011"; break;
                       case 5: sItem = "nw_wplmhb011"; break;
                       case 6: sItem = "nw_wblmhw012"; break;
                       case 7: sItem = "nw_wblmfh011"; break;
                       case 8: sItem = "nw_wswmls012"; break;
                       case 9: sItem = "nw_waxmgr011"; break;
                       case 10: sItem = "nw_wswmbs010"; break;
                       case 11: sItem = "nw_wswmgs012"; break;
                        case 12: sItem = "nw_wswmrp011"; break;
                        case 13: sItem = "nw_wswmsc011"; break;
                        case 14: sItem = "nw_wswmss011"; break;
                   }

            }

            //dbSpeak("Create Generic Martial");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericExotic(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";

            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wspka001"; break;
                       case 3: sItem = "nw_wspku001"; break;
                       case 4: sItem = "nw_wplsc001"; break;
                       case 5: sItem = "nw_wdbax001"; break;
                       case 6: sItem = "nw_wdbma001"; break;
                       case 7: sItem = "nw_wswka001"; break;
                       case 8: sItem = "nw_wthmsh002"; break;
                       case 9: sItem = "nw_wdbsw001"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wspka001"; break;
                       case 3: sItem = "nw_wspku001"; break;
                       case 4: sItem = "nw_wplsc001"; break;
                       case 5: sItem = "nw_wdbax001"; break;
                       case 6: sItem = "nw_wdbma001"; break;
                       case 7: sItem = "nw_wswka001"; break;
                       case 8: sItem = "nw_wthmsh002"; break;
                       case 9: sItem = "nw_wdbsw001"; break;
                       case 10: sItem = "nw_wthmsh005"; break;
                       case 11: sItem = "nw_wspmka002"; break;
                       case 12: sItem = "nw_wspmku002"; break;
                       case 13: sItem = "nw_wplmsc002"; break;
                       case 14: sItem = "nw_wdbmax002"; break;
                       case 15: sItem = "nw_wdbmma002"; break;
                       case 16: sItem = "nw_wswmka002"; break;
                       case 17: sItem = "nw_wdbmsw002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbsw001"; break;
                       case 2: sItem = "nw_wthmsh005"; break;
                       case 3: sItem = "nw_wspmka002"; break;
                       case 4: sItem = "nw_wspmku002"; break;
                       case 5: sItem = "nw_wplmsc002"; break;
                       case 6: sItem = "nw_wdbmax002"; break;
                       case 7: sItem = "nw_wdbmma002"; break;
                       case 8: sItem = "nw_wswmka002"; break;
                       case 9: sItem = "nw_wdbmsw002"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh005"; break;
                       case 2: sItem = "nw_wspmka002"; break;
                       case 3: sItem = "nw_wspmku002"; break;
                       case 4: sItem = "nw_wplmsc002"; break;
                       case 5: sItem = "nw_wdbmax002"; break;
                       case 6: sItem = "nw_wdbmma002"; break;
                       case 7: sItem = "nw_wswmka002"; break;
                       case 8: sItem = "nw_wdbmsw002"; break;
                       case 9: sItem = "nw_wthmsh008"; break;
                       case 10: sItem = "nw_wspmka008"; break;
                       case 11: sItem = "nw_wspmku008"; break;
                       case 12: sItem = "nw_wplmsc010"; break;
                       case 13: sItem = "nw_wdbmax010"; break;
                       case 14: sItem = "nw_wdbmma010"; break;
                       case 15: sItem = "nw_wswmka010"; break;
                       case 16: sItem = "nw_wdbmsw010"; break;
                       case 17: sItem = "nw_wthmsh009"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka008"; break;
                       case 2: sItem = "nw_wspmku008"; break;
                       case 3: sItem = "nw_wplmsc010"; break;
                       case 4: sItem = "nw_wdbmax010"; break;
                       case 5: sItem = "nw_wdbmma010"; break;
                       case 6: sItem = "nw_wswmka010"; break;
                       case 7: sItem = "nw_wdbmsw010"; break;
                       case 8: sItem = "nw_wthmsh009"; break;
                       case 9: sItem = "nw_wspmka009"; break;
                       case 10: sItem = "nw_wspmku009"; break;
                       case 11: sItem = "nw_wplmsc011"; break;
                       case 12: sItem = "nw_wdbmax011"; break;
                       case 13: sItem = "nw_wdbmma011"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
            int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw010"; break;
                       case 2: sItem = "nw_wthmsh009"; break;
                       case 3: sItem = "nw_wspmka009"; break;
                       case 4: sItem = "nw_wspmku009"; break;
                       case 5: sItem = "nw_wplmsc011"; break;
                       case 6: sItem = "nw_wdbmax011"; break;
                       case 7: sItem = "nw_wdbmma011"; break;
                       case 8: sItem = "nw_wswmka011"; break;
                       case 9: sItem = "nw_wdbmsw011"; break;
                   }

            }
                  //dbSpeak("Create generic exotic");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericLightArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";

            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_aarcl009"; break;
                       case 2: sItem = "nw_ashsw001"; break;
                       case 3: sItem = "nw_aarcl001"; break;
                       case 4: sItem = "nw_aarcl002"; break;
                       case 5: sItem = "nw_aarcl012"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_aarcl009"; break;
                       case 2: sItem = "nw_ashsw001"; break;
                       case 3: sItem = "nw_aarcl001"; break;
                       case 4: sItem = "nw_aarcl002"; break;
                       case 5: sItem = "nw_aarcl012"; break;
                       case 6: sItem = "nw_maarcl043"; break;
                       case 7: sItem = "nw_ashmsw002"; break;
                       case 8: sItem = "nw_maarcl044"; break;
                       case 9: sItem = "nw_maarcl045"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl043"; break;
                       case 2: sItem = "nw_ashmsw002"; break;
                       case 3: sItem = "nw_maarcl044"; break;
                       case 4: sItem = "nw_maarcl045"; break;
                       case 5: sItem = "nw_maarcl072"; break;
                       case 6: sItem = "nw_ashmsw008"; break;
                       case 7: sItem = "nw_maarcl071"; break;
                       case 8: sItem = "nw_maarcl075"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl072"; break;
                       case 2: sItem = "nw_ashmsw008"; break;
                       case 3: sItem = "nw_maarcl071"; break;
                       case 4: sItem = "nw_maarcl075"; break;
                       case 5: sItem = "nw_maarcl084"; break;
                       case 6: sItem = "nw_ashmsw009"; break;
                       case 7: sItem = "nw_maarcl083"; break;
                       case 8: sItem = "nw_maarcl087"; break;
                       case 9: sItem = "nw_maarcl079"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl084"; break;
                       case 2: sItem = "nw_ashmsw009"; break;
                       case 3: sItem = "nw_maarcl083"; break;
                       case 4: sItem = "nw_maarcl087"; break;
                       case 5: sItem = "nw_maarcl079"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl084"; break;
                       case 2: sItem = "nw_ashmsw009"; break;
                       case 3: sItem = "nw_maarcl083"; break;
                       case 4: sItem = "nw_maarcl087"; break;
                       case 5: sItem = "nw_maarcl079"; break;
                   }

            }
                  //dbSpeak("Create Generic light");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericMediumArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            int nHD = GetHitDice(oAdventurer) + nModifier;
            string sItem = "";
            if (GetRange(1, nHD))    // * 200
            {
                 int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_arhe001"; break;
                       case 2: sItem = "nw_arhe002"; break;
                       case 3: sItem = "nw_arhe003"; break;
                       case 4: sItem = "nw_arhe004"; break;
                       case 5: sItem = "nw_arhe005"; break;
                       case 6: sItem = "nw_aarcl008"; break;
                       case 7: sItem = "nw_ashlw001"; break;
                       case 8: sItem = "nw_aarcl003"; break;
                       case 9: sItem = "nw_aarcl004"; break;
                       case 10: sItem = "nw_aarcl010"; break;
                   }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_arhe001"; break;
                       case 2: sItem = "nw_arhe002"; break;
                       case 3: sItem = "nw_arhe003"; break;
                       case 4: sItem = "nw_arhe004"; break;
                       case 5: sItem = "nw_arhe005"; break;
                       case 6: sItem = "nw_aarcl008"; break;
                       case 7: sItem = "nw_ashlw001"; break;
                       case 8: sItem = "nw_aarcl003"; break;
                       case 9: sItem = "nw_aarcl004"; break;
                       case 10: sItem = "nw_aarcl010"; break;
                       case 11: sItem = "nw_maarcl047"; break;
                       case 12: sItem = "nw_ashmlw002"; break;
                       case 13: sItem = "nw_maarcl046"; break;
                       case 14: sItem = "nw_maarcl048"; break;
                       case 15: sItem = "nw_maarcl035"; break;
                       case 16: sItem = "nw_maarcl049"; break;
                       case 17: sItem = "nw_maarcl050"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl047"; break;
                       case 2: sItem = "nw_ashmlw002"; break;
                       case 3: sItem = "nw_maarcl046"; break;
                       case 4: sItem = "nw_maarcl048"; break;
                       case 5: sItem = "nw_maarcl035"; break;
                       case 6: sItem = "nw_maarcl049"; break;
                       case 7: sItem = "nw_maarcl050"; break;
                       case 8: sItem = "nw_maarcl070"; break;
                       case 9: sItem = "nw_ashmlw008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                   int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl035"; break;
                       case 2: sItem = "nw_maarcl049"; break;
                       case 3: sItem = "nw_maarcl050"; break;
                       case 4: sItem = "nw_maarcl070"; break;
                       case 5: sItem = "nw_ashmlw008"; break;
                       case 6: sItem = "nw_maarcl067"; break;
                       case 7: sItem = "nw_maarcl073"; break;
                       case 8: sItem = "nw_maarcl065"; break;
                       case 9: sItem = "nw_maarcl066"; break;
                       case 10: sItem = "nw_maarcl082"; break;
                       case 11: sItem = "nw_ashmlw009"; break;
                       case 12: sItem = "nw_maarcl085"; break;
                       case 13: sItem = "nw_maarcl077"; break;
                       case 14: sItem = "nw_maarcl078"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl070"; break;
                       case 2: sItem = "nw_ashmlw008"; break;
                       case 3: sItem = "nw_maarcl067"; break;
                       case 4: sItem = "nw_maarcl073"; break;
                       case 5: sItem = "nw_maarcl065"; break;
                       case 6: sItem = "nw_maarcl066"; break;
                       case 7: sItem = "nw_maarcl082"; break;
                       case 8: sItem = "nw_ashmlw009"; break;
                       case 9: sItem = "nw_maarcl085"; break;
                       case 10: sItem = "nw_maarcl077"; break;
                       case 11: sItem = "nw_maarcl078"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl070"; break;
                       case 2: sItem = "nw_ashmlw008"; break;
                       case 3: sItem = "nw_maarcl067"; break;
                       case 4: sItem = "nw_maarcl073"; break;
                       case 5: sItem = "nw_maarcl065"; break;
                       case 6: sItem = "nw_maarcl066"; break;
                       case 7: sItem = "nw_maarcl082"; break;
                       case 8: sItem = "nw_ashmlw009"; break;
                       case 9: sItem = "nw_maarcl085"; break;
                       case 10: sItem = "nw_maarcl077"; break;
                       case 11: sItem = "nw_maarcl078"; break;
                   }

            }
                  //dbSpeak("Create Generic medium");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericHeavyArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashto001"; break;
                       case 2: sItem = "nw_aarcl005"; break;
                       case 3: sItem = "nw_aarcl011"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashto001"; break;
                       case 2: sItem = "nw_aarcl005"; break;
                       case 3: sItem = "nw_aarcl011"; break;
                       case 4: sItem = "nw_aarcl006"; break;
                       case 5: sItem = "nw_ashmto002"; break;
                       case 6: sItem = "nw_maarcl051"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_aarcl005"; break;
                       case 2: sItem = "nw_aarcl011"; break;
                       case 3: sItem = "nw_aarcl006"; break;
                       case 4: sItem = "nw_ashmto002"; break;
                       case 5: sItem = "nw_maarcl051"; break;
                       case 6: sItem = "nw_maarcl052"; break;
                       case 7: sItem = "nw_aarcl007"; break;
                       case 8: sItem = "nw_maarcl053"; break;
                       case 9: sItem = "nw_ashmto008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl051"; break;
                       case 2: sItem = "nw_maarcl052"; break;
                       case 3: sItem = "nw_aarcl007"; break;
                       case 4: sItem = "nw_maarcl053"; break;
                       case 5: sItem = "nw_ashmto008"; break;
                       case 6: sItem = "nw_maarcl064"; break;
                       case 7: sItem = "nw_maarcl074"; break;
                       case 8: sItem = "nw_maarcl069"; break;
                       case 9: sItem = "nw_maarcl068"; break;
                       case 10: sItem = "nw_ashmto003"; break;
                       case 11: sItem = "nw_ashmto009"; break;
                       case 12: sItem = "nw_maarcl076"; break;
                       case 13: sItem = "nw_maarcl086"; break;
                       case 14: sItem = "nw_maarcl081"; break;
                       case 15: sItem = "nw_maarcl080"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmto008"; break;
                       case 2: sItem = "nw_maarcl064"; break;
                       case 3: sItem = "nw_maarcl074"; break;
                       case 4: sItem = "nw_maarcl069"; break;
                       case 5: sItem = "nw_maarcl068"; break;
                       case 6: sItem = "nw_ashmto009"; break;
                       case 7: sItem = "nw_maarcl076"; break;
                       case 8: sItem = "nw_maarcl086"; break;
                       case 9: sItem = "nw_maarcl081"; break;
                       case 10: sItem = "nw_maarcl080"; break;
                   }


            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmto009"; break;
                       case 2: sItem = "nw_maarcl076"; break;
                       case 3: sItem = "nw_maarcl086"; break;
                       case 4: sItem = "nw_maarcl081"; break;
                       case 5: sItem = "nw_maarcl080"; break;
                   }

            }
                  //dbSpeak("Create Generic heavy");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        
        
        	//::///////////////////////////////////////////////
    //:: CreateTable2GenericItem
    //:: Copyright (c) 2002 Bioware Corp.
    //:://////////////////////////////////////////////
    /*
        Creates an item based upon the class of
        oAdventurer
    */
    //:://////////////////////////////////////////////
    //:: Created By:  Brent
    //:: Created On:
    //:://////////////////////////////////////////////
        void CreateGenericMiscItem(object oTarget, object oAdventurer, int nModifier=0)
        {
            int nHD = GetHitDice(oAdventurer) + nModifier;
            string sItem = "";
            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(9) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mglove004"; break;
                 case 2: sItem = "nw_it_mglove004"; break;
                 case 3: sItem = "nw_it_mglove005"; break;
                 case 4: sItem = "nw_it_mglove006"; break;
                 case 5: sItem = "nw_it_mglove007"; break;
                 case 6: sItem = "nw_it_mglove008"; break;
                 case 7: sItem = "nw_it_mglove009"; break;
                 case 8: sItem = "nw_mcloth006"; break;
                 case 9: sItem = "nw_it_mglove012"; break;
                }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(25) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_mcloth006"; break;
                 case 2: sItem = "nw_it_mring009"; break;
                 case 3: sItem = "nw_it_mring009"; break;
                 case 4: sItem = "nw_it_mring010"; break;
                 case 5: sItem = "nw_it_mring011"; break;
                 case 6: sItem = "nw_it_mboots010"; break;
                 case 7: sItem = "nw_it_mneck024"; break;
                 case 8: sItem = "nw_mcloth007"; break;
                 case 9: sItem = "nw_it_mring024"; break;
                 case 10: sItem = "nw_it_mring012"; break;
                 case 11: sItem = "nw_mcloth008"; break;
                 case 12: sItem = "nw_it_mglove010"; break;
                 case 13: sItem = "nw_it_mglove011"; break;
                 case 14: sItem = "nw_it_mglove013"; break;
                 case 15: sItem = "nw_it_mglove014"; break;
                 case 16: sItem = "nw_it_mglove015"; break;
                 case 17: sItem = "nw_maarcl097"; break;
                 case 18: sItem = "nw_maarcl097"; break;
                 case 19: sItem = "nw_maarcl099"; break;
                 case 20: sItem = "nw_it_mneck032"; break;
                 case 21: sItem = "nw_mcloth010"; break;
                 case 22: sItem = "nw_it_mbracer002"; break;
                 case 23: sItem = "nw_it_mneck001"; break;
                 case 24: sItem = "nw_maarcl055"; break;
                 case 25: sItem = "nw_mcloth009"; break;
                }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(44) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring009"; break;
                 case 2: sItem = "nw_it_mring009"; break;
                 case 3: sItem = "nw_it_mring010"; break;
                 case 4: sItem = "nw_it_mring011"; break;
                 case 5: sItem = "nw_it_mboots010"; break;
                 case 6: sItem = "nw_it_mneck024"; break;
                 case 7: sItem = "nw_mcloth007"; break;
                 case 8: sItem = "nw_it_mring024"; break;
                 case 9: sItem = "nw_it_mring012"; break;
                 case 10: sItem = "nw_mcloth008"; break;
                 case 11: sItem = "nw_it_mglove010"; break;
                 case 12: sItem = "nw_it_mglove011"; break;
                 case 13: sItem = "nw_it_mglove013"; break;
                 case 14: sItem = "nw_it_mglove014"; break;
                 case 15: sItem = "nw_it_mglove015"; break;
                 case 16: sItem = "nw_it_contain003"; break;
                 case 17: sItem = "nw_maarcl097"; break;
                 case 18: sItem = "nw_maarcl099"; break;
                 case 19: sItem = "nw_it_mneck032"; break;
                 case 20: sItem = "nw_mcloth010"; break;
                 case 21: sItem = "nw_it_mbracer002"; break;
                 case 22: sItem = "nw_it_mneck001"; break;
                 case 23: sItem = "nw_maarcl055"; break;
                 case 24: sItem = "nw_mcloth009"; break;
                 case 25: sItem = "nw_it_mring001"; break;
                 case 26: sItem = "nw_it_mboots001"; break;
                 case 27: sItem = "nw_it_mbracer001"; break;
                 case 28: sItem = "nw_it_mneck007"; break;
                 case 29: sItem = "nw_maarcl096"; break;
                 case 30: sItem = "nw_it_mglove003"; break;
                 case 31: sItem = "nw_it_contain004"; break;
                 case 32: sItem = "nw_it_mneck031"; break;
                 case 33: sItem = "nw_it_mring006"; break;
                 case 34: sItem = "nw_it_mneck006"; break;
                 case 35: sItem = "nw_it_mneck029"; break;
                 case 36: sItem = "nw_it_mring013"; break;
                 case 37: sItem = "nw_it_mboots011"; break;
                 case 38: sItem = "nw_it_mneck025"; break;
                 case 39: sItem = "nw_it_mbelt009"; break;
                 case 40: sItem = "nw_it_mbelt010"; break;
                 case 41: sItem = "nw_it_mbelt011"; break;
                 case 42: sItem = "nw_it_mring025"; break;
                 case 43: sItem = "nw_it_mring025"; break;
                 case 44: sItem = "nw_maarcl031"; break;

                }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(48) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring001"; break;
                 case 2: sItem = "nw_it_mboots001"; break;
                 case 3: sItem = "nw_it_mbracer001"; break;
                 case 4: sItem = "nw_it_mneck007"; break;
                 case 5: sItem = "nw_maarcl096"; break;
                 case 6: sItem = "nw_it_mglove003"; break;
                 case 7: sItem = "nw_it_mneck031"; break;
                 case 8: sItem = "nw_it_mneck031"; break;
                 case 9: sItem = "nw_it_mring006"; break;
                 case 10: sItem = "nw_it_mneck006"; break;
                 case 11: sItem = "nw_it_mneck029"; break;
                 case 12: sItem = "nw_it_mring013"; break;
                 case 13: sItem = "nw_it_mboots011"; break;
                 case 14: sItem = "nw_it_mneck025"; break;
                 case 15: sItem = "nw_it_mbelt009"; break;
                 case 16: sItem = "nw_it_mbelt010"; break;
                 case 17: sItem = "nw_it_mbelt011"; break;
                 case 18: sItem = "nw_it_mring025"; break;
                 case 19: sItem = "nw_it_mring025"; break;
                 case 20: sItem = "nw_it_mbracer007"; break;
                 case 21: sItem = "nw_it_mbracer007"; break;
                 case 22: sItem = "nw_it_mneck012"; break;
                 case 23: sItem = "nw_maarcl088"; break;
                 case 24: sItem = "nw_it_mboots012"; break;
                 case 25: sItem = "nw_it_mneck026"; break;
                 case 26: sItem = "nw_it_mboots006"; break;
                 case 27: sItem = "nw_it_mbracer003"; break;
                 case 28: sItem = "nw_it_mneck008"; break;
                 case 29: sItem = "nw_it_mring008"; break;
                 case 30: sItem = "nw_maarcl056"; break;
                 case 31: sItem = "nw_maarcl092"; break;
                 case 32: sItem = "nw_it_mring014"; break;
                 case 33: sItem = "nw_it_mneck016"; break;
                 case 34: sItem = "nw_it_mboots013"; break;
                 case 35: sItem = "nw_it_mneck027"; break;
                 case 36: sItem = "nw_it_mbracer008"; break;
                 case 37: sItem = "nw_it_mneck013"; break;
                 case 38: sItem = "nw_maarcl089"; break;
                 case 39: sItem = "nw_it_mbelt012"; break;
                 case 40: sItem = "nw_it_mbelt013"; break;
                 case 41: sItem = "nw_it_mbelt014"; break;
                 case 42: sItem = "nw_it_mring027"; break;
                 case 43: sItem = "nw_it_mboots007"; break;
                 case 44: sItem = "nw_it_mbracer004"; break;
                 case 45: sItem = "nw_it_mneck009"; break;
                 case 46: sItem = "nw_it_mring018"; break;
                 case 47: sItem = "nw_maarcl093"; break;
                 case 48: sItem = "nw_it_mboots002"; break;

                }
            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                int nRandom = Random(42) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mbracer007"; break;
                 case 2: sItem = "nw_it_mbracer007"; break;
                 case 3: sItem = "nw_it_mneck012"; break;
                 case 4: sItem = "nw_maarcl088"; break;
                 case 5: sItem = "nw_it_mboots012"; break;
                 case 6: sItem = "nw_it_mneck026"; break;
                 case 7: sItem = "nw_it_mboots006"; break;
                 case 8: sItem = "nw_it_mbracer003"; break;
                 case 9: sItem = "nw_it_mneck008"; break;
                 case 10: sItem = "nw_it_mring008"; break;
                 case 11: sItem = "nw_maarcl056"; break;
                 case 12: sItem = "nw_maarcl092"; break;
                 case 13: sItem = "nw_it_mring014"; break;
                 case 14: sItem = "nw_it_mneck016"; break;
                 case 15: sItem = "nw_it_mboots013"; break;
                 case 16: sItem = "nw_it_mneck027"; break;
                 case 17: sItem = "nw_it_mbracer008"; break;
                 case 18: sItem = "nw_it_mneck013"; break;
                 case 19: sItem = "nw_maarcl089"; break;
                 case 20: sItem = "nw_it_mbelt012"; break;
                 case 21: sItem = "nw_it_mbelt013"; break;
                 case 22: sItem = "nw_it_mbelt014"; break;
                 case 23: sItem = "nw_it_mring027"; break;
                 case 24: sItem = "nw_it_mboots007"; break;
                 case 25: sItem = "nw_it_mbracer004"; break;
                 case 26: sItem = "nw_it_mneck009"; break;
                 case 27: sItem = "nw_it_mring018"; break;
                 case 28: sItem = "nw_maarcl093"; break;
                 case 29: sItem = "nw_it_mboots002"; break;
                 case 30: sItem = "nw_it_mboots014"; break;
                 case 31: sItem = "nw_it_mneck028"; break;
                 case 32: sItem = "nw_it_mring015"; break;
                 case 33: sItem = "nw_it_mbracer009"; break;
                 case 34: sItem = "nw_it_mneck014"; break;
                 case 35: sItem = "nw_maarcl090"; break;
                 case 36: sItem = "nw_it_mring028"; break;
                 case 37: sItem = "nw_it_mneck017"; break;
                 case 38: sItem = "nw_it_mboots008"; break;
                 case 39: sItem = "nw_it_mbracer005"; break;
                 case 40: sItem = "nw_it_mneck010"; break;
                 case 41: sItem = "nw_it_mmidmisc02"; break;
                 case 42: sItem = "nw_it_mring019"; break;
                }
            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                int nRandom = Random(30) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring027"; break;
                 case 2: sItem = "nw_it_mboots007"; break;
                 case 3: sItem = "nw_it_mbracer004"; break;
                 case 4: sItem = "nw_it_mneck009"; break;
                 case 5: sItem = "nw_it_mring018"; break;
                 case 6: sItem = "nw_maarcl093"; break;
                 case 7: sItem = "nw_it_mboots002"; break;
                 case 8: sItem = "nw_it_mboots014"; break;
                 case 9: sItem = "nw_it_mneck028"; break;
                 case 10: sItem = "nw_it_mring015"; break;
                 case 11: sItem = "nw_it_mbracer009"; break;
                 case 12: sItem = "nw_it_mneck014"; break;
                 case 13: sItem = "nw_maarcl090"; break;
                 case 14: sItem = "nw_it_mring028"; break;
                 case 15: sItem = "nw_it_mneck017"; break;
                 case 16: sItem = "nw_it_mboots008"; break;
                 case 17: sItem = "nw_it_mbracer005"; break;
                 case 18: sItem = "nw_it_mneck010"; break;
                 case 19: sItem = "nw_it_mmidmisc02"; break;
                 case 20: sItem = "nw_maarcl094"; break;
                 case 21: sItem = "nw_it_mring019"; break;
                 case 22: sItem = "nw_it_mring016"; break;
                 case 23: sItem = "nw_it_mbracer010"; break;
                 case 24: sItem = "nw_it_mneck015"; break;
                 case 25: sItem = "nw_maarcl091"; break;
                 case 26: sItem = "nw_it_mboots009"; break;
                 case 27: sItem = "nw_it_mbracer006"; break;
                 case 28: sItem = "nw_it_mneck011"; break;
                 case 29: sItem = "nw_maarcl095"; break;
                 case 30: sItem = "nw_it_mneck018"; break;
                }
             }
             //dbSpeak("Create Misc");

             CreateItemOnObject(sItem, oTarget, 1);
         }



        // *
        // * SPECIC TREASURE ITEMS (re: Named Items)
        // *
        void CreateSpecificMiscItem(object oTarget,object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMiscItem(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericMiscItem(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_maarcl057"; break;
                       case 3: sItem = "nw_it_mbelt005"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl057"; break;
                       case 2: sItem = "nw_it_mbelt005"; break;
                       case 3: sItem = "nw_maarcl101"; break;
                       case 4: sItem = "nw_maarcl102"; break;
                       case 5: sItem = "nw_maarcl103"; break;
                       case 6: sItem = "nw_it_mglove001"; break;
                       case 7: sItem = "nw_maarcl100"; break;
                       case 8: sItem = "nw_it_mbracer011"; break;
                       case 9: sItem = "nw_it_mmidmisc04"; break;
                       case 10: sItem = "nw_it_mring003"; break;
                       case 11: sItem = "nw_it_mbelt006"; break;
                       case 12: sItem = "nw_it_mbelt002"; break;
                       case 13: sItem = "nw_it_mmidmisc03"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(19) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl101"; break;
                       case 2: sItem = "nw_maarcl101"; break;
                       case 3: sItem = "nw_maarcl102"; break;
                       case 4: sItem = "nw_maarcl103"; break;
                       case 5: sItem = "nw_it_mglove001"; break;
                       case 6: sItem = "nw_maarcl100"; break;
                       case 7: sItem = "nw_it_mbracer011"; break;
                       case 8: sItem = "nw_it_mmidmisc04"; break;
                       case 9: sItem = "nw_it_mring003"; break;
                       case 10: sItem = "nw_it_mbelt006"; break;
                       case 11: sItem = "nw_it_mbelt002"; break;
                       case 12: sItem = "nw_it_mmidmisc03"; break;
                       case 13: sItem = "nw_it_mring002"; break;
                       case 14: sItem = "nw_it_mbelt004"; break;
                       case 15: sItem = "nw_it_mring005"; break;
                       case 16: sItem = "nw_it_mboots005"; break;
                       case 17: sItem = "nw_it_mring007"; break;
                       case 18: sItem = "nw_it_mneck003"; break;
                       case 19: sItem = "nw_it_mbelt007"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_mbelt002"; break;
                       case 2: sItem = "nw_it_mbelt002"; break;
                       case 3: sItem = "nw_it_mmidmisc03"; break;
                       case 4: sItem = "nw_it_mring002"; break;
                       case 5: sItem = "nw_it_mbelt004"; break;
                       case 6: sItem = "nw_it_mring005"; break;
                       case 7: sItem = "nw_it_mboots005"; break;
                       case 8: sItem = "nw_it_mring007"; break;
                       case 9: sItem = "nw_it_mneck003"; break;
                       case 10: sItem = "nw_it_mbelt007"; break;
                       case 11: sItem = "nw_it_mboots004"; break;
                       //case 12: sItem = "nw_it_mboots003"; break;
                       case 13: sItem = "nw_it_mneck005"; break;
                       case 14: sItem = "nw_it_mbelt008"; break;
                       case 15: sItem = "nw_it_mring020"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(19) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_mboots004"; break;
                       case 2: sItem = "nw_it_mboots004"; break;
                       //case 3: sItem = "nw_it_mboots003"; break;
                       case 4: sItem = "nw_it_mneck005"; break;
                       case 5: sItem = "nw_it_mbelt008"; break;
                       case 6: sItem = "nw_it_mring020"; break;
                       case 7: sItem = "nw_it_mbelt001"; break;
                       case 8: sItem = "nw_it_mring017"; break;
                       case 9: sItem = "nw_mcloth001"; break;
                       case 10: sItem = "nw_it_mneck019"; break;
                       case 11: sItem = "nw_it_mneck002"; break;
                       case 12: sItem = "nw_it_mneck004"; break;
                       case 13: sItem = "nw_it_mmidmisc01"; break;
                       case 14: sItem = "nw_mcloth002"; break;
                       case 15: sItem = "nw_mcloth003"; break;
                       case 16: sItem = "nw_mcloth004"; break;
                       case 17: sItem = "nw_it_mbelt003"; break;
                       // * new items
                       case 18: sItem = "NW_IT_MBELT020"; break;
                       case 19: sItem = "NW_IT_MBELT021"; break;
                   }

            }
                CreateItemOnObject(sItem, oTarget, 1);
        }
        
        
                void CreateGenericRodStaffWand(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(3) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn013"; break;
                    case 2: sItem = "nw_wmgwn006"; break;
                    case 3: sItem = "nw_it_gem002";  break;  // gem for variety
                }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(3) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn013"; break;
                    case 2: sItem = "nw_wmgwn006"; break;
                    case 3: sItem = "nw_it_gem002";  break;// gem for variety
                }
            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(4) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn006"; break;
                    case 2: sItem = "nw_wmgwn004"; break;
                    case 3: sItem = "nw_wmgrd002"; break;
                    case 4: sItem = "nw_wmgwn012"; break;
                }
            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(11) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn004"; break;
                    case 2: sItem = "nw_wmgwn002"; break;
                    case 3: sItem = "nw_wmgwn007"; break;
                    case 4: sItem = "nw_wmgwn003"; break;
                    case 5: sItem = "nw_wmgwn010"; break;
                    case 6: sItem = "nw_wmgwn011"; break;
                    case 7: sItem = "nw_wmgwn005"; break;
                    case 8: sItem = "nw_wmgwn008"; break;
                    case 9: sItem = "nw_wmgwn009"; break;
                    case 10: sItem = "nw_wmgrd002"; break;
                    case 11: sItem = "nw_wmgwn012"; break;
                }

            }
            else  // * 2500 - 16500
            {
                int nRandom = d8();
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn002"; break;
                    case 2: sItem = "nw_wmgwn007"; break;
                    case 3: sItem = "nw_wmgwn003"; break;
                    case 4: sItem = "nw_wmgwn010"; break;
                    case 5: sItem = "nw_wmgwn011"; break;
                    case 6: sItem = "nw_wmgwn005"; break;
                    case 7: sItem = "nw_wmgwn008"; break;
                    case 8: sItem = "nw_wmgwn009"; break;
                }

            }
          //dbSpeak("Generic Rod staff wand");

           CreateItemOnObject(sItem, oTarget, 1);
        }
        
        
        void CreateSpecificRodStaffWand(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericRodStaffWand(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericRodStaffWand(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgst004"; break;
                       case 2: sItem = "nw_wmgst006"; break;
                       case 3: sItem = "nw_wmgmrd003"; break;
                       case 4: sItem = "nw_wmgst004"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(7) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgmrd003"; break;
                       case 2: sItem = "nw_wmgst006"; break;
                       case 3: sItem = "nw_wmgmrd003"; break;
                       case 4: sItem = "nw_wmgst004"; break;
                       case 5: sItem = "nw_wmgst005"; break;
                       case 6: sItem = "nw_wmgmrd004"; break;
                       case 7: sItem = "nw_wmgrd002"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl012"; break;
                       case 2: sItem = "nw_wmgmrd003"; break;
                       case 3: sItem = "nw_wmgst004"; break;
                       case 4: sItem = "nw_wmgst005"; break;
                       case 5: sItem = "nw_wblmcl012"; break;
                       case 6: sItem = "nw_wmgmrd004"; break;
                       case 7: sItem = "nw_wmgst002"; break;
                       case 8: sItem = "nw_wmgmrd005"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgmrd004"; break;
                       case 2: sItem = "nw_wmgst002"; break;
                       case 3: sItem = "nw_wmgmrd005"; break;
                       case 4: sItem = "nw_wmgmrd002"; break;
                       case 5: sItem = "nw_wmgst003"; break;
                       case 6: sItem = "nw_wblmcl012"; break;
                   }

            }
                CreateItemOnObject(sItem, oTarget, 1);
        }
        
// Get the number of items to generate
// Returns an integer from 1-3, probabilities
// determined by the values of the constants
// TREASURE_PROBABILITY_1 & _2. 
int SCTreasureRandomNumItems()
{
    int nRoll = d100();

    if (nRoll < TREASURE_PROBABILITY_1) {
        return 1;
    } else if (nRoll < (TREASURE_PROBABILITY_1 + TREASURE_PROBABILITY_2)) {
        return 2;
    }
    return 3;
}





// Determine whether an item should actually just be gold.
// Returns TRUE or FALSE. 
// Probability controlled by constant TREASURE_GOLD_PROBABILITY
int SCTreasureIsItemGold()
{
    int nRoll = d100();
    if (nRoll < TREASURE_GOLD_PROBABILITY) 
        return TRUE;
    return FALSE;
}





    // * nModifier is to 'raise' the level of the oAdventurer
    void CreateArcaneScroll(object oTarget, object oAdventurer, int nModifier = 0)
    {
        int nMaxSpells = 21;
        int nHD = GetHitDice(oAdventurer) + nModifier;
        int nScroll = 1;
        int nLevel = 1;

        if (GetRange(1, nHD))           // l 1-2
        {
          nLevel = d2();
          nScroll =  Random(nMaxSpells) + 1;
        }
        else if (GetRange(2, nHD))      // l 1-4
        {
          nLevel = d4();
          nScroll =  Random(nMaxSpells) + 1;
        }
        else if (GetRange(3, nHD))    // l 2-6
        {
          nLevel = d6();
          if (nLevel < 2) nLevel = 2;

          nScroll =  Random(nMaxSpells) + 1;
        }
        else if (GetRange(4, nHD))   // l 3-8
        {
          nLevel = d8();
          if (nLevel < 3) nLevel = 3;

          nScroll =  Random(nMaxSpells) + 1;
        }
        else if (GetRange(5, nHD))   // l 4-9
        {
          nLevel = d8() + 1;
          if (nLevel < 4) nLevel = 4;

          nScroll =  Random(nMaxSpells) + 1;
        }
        else if (GetRange(6, nHD))   // 5 -9
        {
          nLevel = d8() + 1;
          if (nLevel < 5) nLevel = 5;

          nScroll =  Random(nMaxSpells) + 1;
        }

        // * Trims the level of the scroll to match the max # of scrolls in each level range
        nScroll = TrimLevel(nScroll, nLevel);

        string sRes = "nw_it_sparscr216";

        if (nScroll < 10)
        {
            sRes = "NW_IT_SPARSCR" + IntToString(nLevel) + "0" + IntToString(nScroll);
        }
        else
        {
            sRes = "NW_IT_SPARSCR" + IntToString(nLevel) + IntToString(nScroll);
        }
          CreateItemOnObject(sRes, oTarget, 1);
        }

    void CreateDivineScroll(object oTarget, object oAdventurer, int nModifier=0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sScroll = "";
        if (GetRange(1, nHD))
        {
            int nRandom = d4();
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr201"; break;
                case 2: sScroll = "nw_it_spdvscr202"; break;
                case 3: sScroll = "nw_it_spdvscr203"; break;
                case 4: sScroll = "nw_it_spdvscr204"; break;
            }
        }
        else if (GetRange(2, nHD))
        {
            int nRandom = d8();
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr201"; break;
                case 2: sScroll = "nw_it_spdvscr202";break;
                case 3: sScroll = "nw_it_spdvscr203"; break;
                case 4: sScroll = "nw_it_spdvscr204"; break;
                case 5: sScroll = "nw_it_spdvscr301"; break;
                case 6: sScroll = "nw_it_spdvscr302"; break;
                case 7: sScroll = "nw_it_spdvscr401"; break;
                case 8: sScroll = "nw_it_spdvscr402"; break;
            }

        }
        else if (GetRange(3, nHD))
        {
            int nRandom = Random(9) + 1;
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr201"; break;
                case 2: sScroll = "nw_it_spdvscr202"; break;
                case 3: sScroll = "nw_it_spdvscr203"; break;
                case 4: sScroll = "nw_it_spdvscr204"; break;
                case 5: sScroll = "nw_it_spdvscr301"; break;
                case 6: sScroll = "nw_it_spdvscr302"; break;
                case 7: sScroll = "nw_it_spdvscr401"; break;
                case 8: sScroll = "nw_it_spdvscr402"; break;
                case 9: sScroll = "nw_it_spdvscr501"; break;
            }

        }
        else
        {
            int nRandom = Random(7) + 1;
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr301"; break;
                case 2: sScroll = "nw_it_spdvscr302";  break;
                case 3: sScroll = "nw_it_spdvscr401"; break;
                case 4: sScroll = "nw_it_spdvscr402"; break;
                case 5: sScroll = "nw_it_spdvscr501"; break;
                case 6: sScroll = "nw_it_spdvscr701"; break;
                case 7: sScroll = "nw_it_spdvscr702";  break;
            }
        }
        //dbSpeak("Divine Scroll");

        CreateItemOnObject(sScroll, oTarget, 1);

    }
    void CreateAmmo(object oTarget, object oAdventurer, int nModifier=0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sAmmo = "";

        if (GetRange(1, nHD))           // * 200 gp max
        {
            int nRandom = d3();
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wamar001";  break;
                case 2: sAmmo = "nw_wambo001";  break;
                case 3: sAmmo = "nw_wambu001";  break;
            }
          }
        else if (GetRange(2, nHD))       // * 800 gp max
        {
            int nRandom = d6();
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wamar001";  break;
                case 2: sAmmo = "nw_wambo001";  break;
                case 3: sAmmo = "nw_wambu001";  break;
                case 4: sAmmo = "nw_wammar001"; break;
                case 5: sAmmo = "nw_wammbo001"; break;
                case 6: sAmmo = "nw_wammbo002"; break;
            }
        }
        else if (GetRange(3, nHD))    // *  - 2500 gp
        {
            int nRandom = d20();
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wamar001";   break;
                case 2: sAmmo = "nw_wambo001";   break;
                case 3: sAmmo = "nw_wambu001";   break;
                case 4: sAmmo = "nw_wammar001";  break;
                case 5: sAmmo = "nw_wammbo001";  break;
                case 6: sAmmo = "nw_wammbo002";   break;
                case 7: sAmmo = "nw_wammbo003";  break;
                case 8: sAmmo = "nw_wammbu002";  break;
                case 9: sAmmo = "nw_wammar002";  break;
                case 10: sAmmo = "nw_wammar001"; break;
                case 11: sAmmo = "nw_wammar003"; break;
                case 12: sAmmo = "nw_wammar004"; break;
                case 13: sAmmo = "nw_wammar005"; break;
                case 14: sAmmo = "nw_wammar006"; break;
                case 15: sAmmo = "nw_wammbo004";  break;
                case 16: sAmmo = "nw_wammbo005"; break;
                case 17: sAmmo = "nw_wammbu004"; break;
                case 18: sAmmo = "nw_wammbu005"; break;
                case 19: sAmmo = "nw_wammbu006"; break;
                case 20: sAmmo = "nw_wammbu007"; break;
            }
        }
        else
        {
            int nRandom = d20();
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wamar001";      break;
                case 2: sAmmo = "nw_wammbu001";     break;
                case 3: sAmmo = "nw_wammbu003";     break;
                case 4: sAmmo = "nw_wammar001";     break;
                case 5: sAmmo = "nw_wammbo001";      break;
                case 6: sAmmo = "nw_wammbo002";     break;
                case 7: sAmmo = "nw_wammbo003";     break;
                case 8: sAmmo = "nw_wammbu002";     break;
                case 9: sAmmo = "nw_wammar002";     break;
                case 10: sAmmo = "nw_wammar001";    break;
                case 11: sAmmo = "nw_wammar003";    break;
                case 12: sAmmo = "nw_wammar004";     break;
                case 13: sAmmo = "nw_wammar005";    break;
                case 14: sAmmo = "nw_wammar006";    break;
                case 15: sAmmo = "nw_wammbo004";    break;
                case 16: sAmmo = "nw_wammbo005";    break;
                case 17: sAmmo = "nw_wammbu004";    break;
                case 18: sAmmo = "nw_wammbu005";    break;
                case 19: sAmmo = "nw_wammbu006";    break;
                case 20: sAmmo = "nw_wammbu007";    break;
            }
        }
        //dbSpeak("ammo");
        CreateItemOnObject(sAmmo, oTarget, Random(30) + 1); // create up to 30 of the specified ammo type
    }

    void CreateTrapKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
      int nHD = GetHitDice(oAdventurer) + nModifier;
      string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = d3();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap001";    break;
                case 2: sKit = "nw_it_trap029";    break;
                case 3: sKit = "nw_it_trap033";    break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = d12();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap001";    break;
                case 2: sKit = "nw_it_trap029";    break;
                case 3: sKit = "nw_it_trap033";    break;
                case 4: sKit = "nw_it_trap002";    break;
                case 5: sKit = "nw_it_trap030";    break;
                case 6: sKit = "nw_it_trap037";    break;
                case 7: sKit = "nw_it_trap034";   break;
                case 8: sKit = "nw_it_trap005";   break;
                case 9: sKit = "nw_it_trap038";   break;
                case 10: sKit = "nw_it_trap041";   break;
                case 11: sKit = "nw_it_trap003";    break;
                case 12: sKit = "nw_it_trap031";   break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(17) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap002";  break;
                case 2: sKit = "nw_it_trap030";  break;
                case 3: sKit = "nw_it_trap037";  break;
                case 4: sKit = "nw_it_trap034";   break;
                case 5: sKit = "nw_it_trap005";  break;
                case 6: sKit = "nw_it_trap038";   break;
                case 7: sKit = "nw_it_trap041";   break;
                case 8: sKit = "nw_it_trap003";   break;
                case 9: sKit = "nw_it_trap031";   break;
                case 10: sKit = "nw_it_trap035";   break;
                case 11: sKit = "nw_it_trap006";   break;
                case 12: sKit = "nw_it_trap042";   break;
                case 13: sKit = "nw_it_trap004";   break;
                case 14: sKit = "nw_it_trap032";   break;
                case 15: sKit = "nw_it_trap039";    break;
                case 16: sKit = "nw_it_trap009";   break;
                case 17: sKit = "nw_it_trap036";   break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(19) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap035";  break;
                case 2: sKit = "nw_it_trap006";  break;
                case 3: sKit = "nw_it_trap042";  break;
                case 4: sKit = "nw_it_trap004";   break;
                case 5: sKit = "nw_it_trap032";   break;
                case 6: sKit = "nw_it_trap039";   break;
                case 7: sKit = "nw_it_trap009";   break;
                case 8: sKit = "nw_it_trap036";   break;
                case 9: sKit = "nw_it_trap013";   break;
                case 10: sKit = "nw_it_trap040";  break;
                case 11: sKit = "nw_it_trap007";  break;
                case 12: sKit = "nw_it_trap043";  break;
                case 13: sKit = "nw_it_trap010";  break;
                case 14: sKit = "nw_it_trap017";  break;
                case 15: sKit = "nw_it_trap021"; break;
                case 16: sKit = "nw_it_trap014"; break;
                case 17: sKit = "nw_it_trap025"; break;
                case 18: sKit = "nw_it_trap008";  break;
                case 19: sKit = "nw_it_trap044";  break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(18) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap039";   break;
                case 2: sKit = "nw_it_trap009";   break;
                case 3: sKit = "nw_it_trap036";   break;
                case 4: sKit = "nw_it_trap013";   break;
                case 5: sKit = "nw_it_trap040";   break;
                case 6: sKit = "nw_it_trap007";   break;
                case 7: sKit = "nw_it_trap043";   break;
                case 8: sKit = "nw_it_trap010";  break;
                case 9: sKit = "nw_it_trap017";  break;
                case 10: sKit = "nw_it_trap021";  break;
                case 11: sKit = "nw_it_trap014";  break;
                case 12: sKit = "nw_it_trap025";  break;
                case 13: sKit = "nw_it_trap008";  break;
                case 14: sKit = "nw_it_trap044";  break;
                case 15: sKit = "nw_it_trap018";  break;
                case 16: sKit = "nw_it_trap011";  break;
                case 17: sKit = "nw_it_trap022";  break;
                case 18: sKit = "nw_it_trap026";  break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(27) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap039";  break;
                case 2: sKit = "nw_it_trap009";  break;
                case 3: sKit = "nw_it_trap036";  break;
                case 4: sKit = "nw_it_trap013";  break;
                case 5: sKit = "nw_it_trap040";  break;
                case 6: sKit = "nw_it_trap007";  break;
                case 7: sKit = "nw_it_trap043";  break;
                case 8: sKit = "nw_it_trap010"; break;
                case 9: sKit = "nw_it_trap017"; break;
                case 10: sKit = "nw_it_trap021"; break;
                case 11: sKit = "nw_it_trap014"; break;
                case 12: sKit = "nw_it_trap025"; break;
                case 13: sKit = "nw_it_trap008"; break;
                case 14: sKit = "nw_it_trap044"; break;
                case 15: sKit = "nw_it_trap018"; break;
                case 16: sKit = "nw_it_trap011"; break;
                case 17: sKit = "nw_it_trap022"; break;
                case 18: sKit = "nw_it_trap026"; break;
                case 19: sKit = "nw_it_trap015"; break;
                case 20: sKit = "nw_it_trap012"; break;
                case 21: sKit = "nw_it_trap019"; break;
                case 22: sKit = "nw_it_trap023"; break;
                case 23: sKit = "nw_it_trap016"; break;
                case 24: sKit = "nw_it_trap027"; break;
                case 25: sKit = "nw_it_trap020"; break;
                case 26: sKit = "nw_it_trap024"; break;
                case 27: sKit = "nw_it_trap028"; break;
             }

        }
        //dbSpeak("Create Trapkit");
        CreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateHealingKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit001";  break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit001";  break;
                case 2: sKit = "nw_it_medkit002";  break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit002"; break;
                case 2: sKit = "nw_it_medkit003";  break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003";break;
                case 2: sKit = "nw_it_medkit004"; break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003"; break;
                case 2: sKit = "nw_it_medkit004";break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003"; break;
                case 2: sKit = "nw_it_medkit004";break;
             }

        }
        //dbSpeak("Create Healing Kit");

        CreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateLockPick(object oTarget, object oAdventurer, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = d8();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks001";   break;
                case 2: sKit = "nw_it_picks002";   break;
                case 3: sKit = "nw_it_picks001";   break;
                case 4: sKit = "nw_it_picks001";   break;
                case 5: sKit = "nw_it_picks001";   break;
                case 6: sKit = "nw_it_picks001";   break;
                case 7: sKit = "nw_it_picks001";   break;
                case 8: sKit = "nw_it_picks001";   break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = d6();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks001";   break;
                case 2: sKit = "nw_it_picks002";    break;
                case 3: sKit = "nw_it_picks003";   break;
                case 4: sKit = "nw_it_picks002";    break;
                case 5: sKit = "nw_it_picks002";    break;
                case 6: sKit = "nw_it_picks002";    break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks003";  break;
                case 2: sKit = "nw_it_picks004";  break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004";  break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004"; break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004"; break;
             }

        }
       //dbSpeak("Create Lockpick");

        CreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
        // * April 23 2002: Major restructuring of this function
        // * to allow me to

        switch (Random(8) + 1)
        {
            case 1: CreateTrapKit(oTarget, oAdventurer, nModifier); break;
            case 2: case 3: case 4: case 5: CreateHealingKit(oTarget, oAdventurer, nModifier); break;
            case 6: case 7: case 8: CreateLockPick(oTarget, oAdventurer, nModifier); break;
        }
    }

    void CreatePotion(object oTarget, object oAdventurer, int nModifier = 0)
    {
        string sPotion = "";
        int nHD = GetHitDice(oAdventurer) + nModifier;

        if (GetRange(1, nHD))
        {
            int nRandom = d10();
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: sPotion = "nw_it_mpotion001"; break;
                case 5: case 6: case 7: sPotion = "nw_it_mpotion020";  break;
                case 8: sPotion = "nw_it_mpotion002";  break;
                case 9: sPotion = "nw_it_mpotion009";  break;
                case 10: sPotion = "nw_it_mpotion005";  break;
            }

        }
        else if (GetRange(2, nHD))
        {
           int nRandom = Random(29) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: sPotion = "nw_it_mpotion001"; break;
                case 4: case 5: case 6: case 7: case 8: sPotion = "nw_it_mpotion020";  break;
                case 9: case 10: case 11: case 12: sPotion = "nw_it_mpotion002";  break;
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 29: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else if (GetRange(3, nHD))
        {
           int nRandom = Random(29) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: case 10: case 11: case 12:
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 29: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else if (GetRange(4, nHD))
        {
           int nRandom = Random(29) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: case 10: case 11: case 12: sPotion = "nw_it_mpotion003"; break;
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 29: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else  // keep 5 and 6 the same
        {
           int nRandom = Random(29) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: sPotion = "nw_it_mpotion003" ;
                case 10: case 11: case 12: case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 29: sPotion = "nw_it_mpotion006";  break;
            }
        }
        //dbSpeak("Create Potion");
        CreateItemOnObject(sPotion, oTarget, 1);
    }


         // * this function just returns an item that is more appropriate
         // * for this class. Only wizards, sorcerers, clerics, monks, rogues and bards get this
        void CreateGenericClassItem(object oTarget, object oAdventurer, int nSpecific =0)
        {


            if (GetLevelByClass(CLASS_TYPE_DRUID, oAdventurer)>= 1)
            {
                if (nSpecific == 0)
                {
                    CreateGenericDruidWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificDruidWeapon(oTarget, oAdventurer);
                }
            }
            else
            if (GetLevelByClass(CLASS_TYPE_WIZARD, oAdventurer)>= 1 || GetLevelByClass(CLASS_TYPE_SORCERER, oAdventurer) >= 1)
            {
                // * 30% chance of getting a magic scroll else get a weapon suited for a wizard
                if (Random(100) + 1 > 70)
                {
                    // * grab an arcane scroll as if the wizard had +4 levels
                    CreateArcaneScroll(oTarget, oAdventurer, 4);
                }
                else
                if (nSpecific == 0)
                {
                    CreateGenericWizardWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificWizardWeapon(oTarget, oAdventurer);
                }


            }
            else
            if (GetLevelByClass(CLASS_TYPE_CLERIC, oAdventurer)>= 1)
            {
                  int nRandom = Random(4) + 1;
                  string sItem = "nw_it_medkit001";
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_medkit001"; break;
                       case 2: sItem = "nw_it_medkit002"; break;
                       case 3: sItem = "nw_it_medkit003"; break;
                       case 4: sItem = "nw_it_medkit004"; break;
                   }
                  CreateItemOnObject(sItem, oTarget, 1);
            }
            else
            if (GetLevelByClass(CLASS_TYPE_MONK, oAdventurer)>= 1)
            {
                //dbSpeak("in monk function");
                if (nSpecific == 0)
                {
                    CreateGenericMonkWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificMonkWeapon(oTarget, oAdventurer);
                }
            }
            else
            if (GetLevelByClass(CLASS_TYPE_ROGUE, oAdventurer)>= 1)
            {
                // * give a misc item as if a couple levels higher
                CreateGenericMiscItem(oTarget, oAdventurer, 2);
            }
            else
            if (GetLevelByClass(CLASS_TYPE_BARD, oAdventurer)>= 1)
            {
                // * give a misc item as if a couple levels higher
                CreateGenericMiscItem(oTarget, oAdventurer, 2);
            }

        }

        


        void CreateSpecificSimple(object oTarget, object oAdventurer)
        {
           string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericSimple(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericSimple(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs005"; break;
                       case 3: sItem = "nw_wdbmqs006"; break;
                       case 4: sItem = "nw_wbwmxh005"; break;
                       case 5: sItem = "nw_wbwmxl005"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wblmml006"; break;
                       case 8: sItem = "nw_wspmsc004"; break;
                       case 9: sItem = "nw_wblmms007"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(22) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs006"; break;
                       case 2: sItem = "nw_wdbmqs005"; break;
                       case 3: sItem = "nw_wdbmqs006"; break;
                       case 4: sItem = "nw_wbwmxh005"; break;
                       case 5: sItem = "nw_wbwmxl005"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wblmml006"; break;
                       case 8: sItem = "nw_wspmsc004"; break;
                       case 9: sItem = "nw_wblmms007"; break;
                       case 10: sItem = "nw_wblmms003"; break;
                       case 11: sItem = "nw_wblmcl004"; break;
                       case 12: sItem = "nw_wspmsc006"; break;
                       case 13: sItem = "nw_wspmsc006"; break;
                       case 14: sItem = "nw_wdbmqs004"; break;
                       case 15: sItem = "nw_wblmcl003"; break;
                       case 16: sItem = "nw_wbwmsl003"; break;
                       case 17: sItem = "nw_wbwmxh003"; break;
                       case 18: sItem = "nw_wspmsc003"; break;
                       case 19: sItem = "nw_wplmss005"; break;
                       case 20: sItem = "nw_wplmss005"; break;
                       case 21: sItem = "nw_wbwmxl003"; break;
                       case 22: sItem = "nw_wblmml004"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(27) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms003"; break;
                       case 2: sItem = "nw_wblmms003"; break;
                       case 3: sItem = "nw_wblmcl004"; break;
                       case 4: sItem = "nw_wspmsc006"; break;
                       case 5: sItem = "nw_wspmsc006"; break;
                       case 6: sItem = "nw_wdbmqs004"; break;
                       case 7: sItem = "nw_wblmcl003"; break;
                       case 8: sItem = "nw_wbwmsl003"; break;
                       case 9: sItem = "nw_wbwmxh003"; break;
                       case 10: sItem = "nw_wspmsc003"; break;
                       case 11: sItem = "nw_wplmss005"; break;
                       case 12: sItem = "nw_wplmss005"; break;
                       case 13: sItem = "nw_wbwmxl003"; break;
                       case 14: sItem = "nw_wblmml004"; break;
                       case 15: sItem = "nw_wdbmqs003"; break;
                       case 16: sItem = "nw_wbwmxl004"; break;
                       case 17: sItem = "nw_wbwmxl007"; break;
                       case 18: sItem = "nw_wblmml005"; break;
                       case 19: sItem = "nw_wblmcl005"; break;
                       case 20: sItem = "nw_wplmss007"; break;
                       case 21: sItem = "nw_wswmdg004"; break;
                       case 22: sItem = "nw_wbwmsl007"; break;
                       case 23: sItem = "nw_wblmml007"; break;
                       case 24: sItem = "nw_wblmml007"; break;
                       case 25: sItem = "nw_wbwmxh004"; break;
                       case 26: sItem = "nw_wplmss006"; break;
                       case 27: sItem = "nw_wbwmxh007"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(31) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wbwmxl003"; break;
                       case 3: sItem = "nw_wblmml004"; break;
                       case 4: sItem = "nw_wdbmqs003"; break;
                       case 5: sItem = "nw_wbwmxl004"; break;
                       case 6: sItem = "nw_wbwmxl007"; break;
                       case 7: sItem = "nw_wblmml005"; break;
                       case 8: sItem = "nw_wblmcl005"; break;
                       case 9: sItem = "nw_wplmss007"; break;
                       case 10: sItem = "nw_wswmdg004"; break;
                       case 11: sItem = "nw_wbwmsl007"; break;
                       case 12: sItem = "nw_wblmml007"; break;
                       case 13: sItem = "nw_wblmml007"; break;
                       case 14: sItem = "nw_wbwmxh004"; break;
                       case 15: sItem = "nw_wplmss006"; break;
                       case 16: sItem = "nw_wbwmxh007"; break;
                       case 17: sItem = "nw_wblmms006"; break;
                       case 18: sItem = "nw_wswmdg003"; break;
                       case 19: sItem = "nw_wswmdg007"; break;
                       case 20: sItem = "nw_wblmms004"; break;
                       case 21: sItem = "nw_wbwmsl006"; break;
                       case 22: sItem = "nw_wbwmsl008"; break;
                       case 23: sItem = "nw_wblmml008"; break;
                       case 24: sItem = "nw_wdbmqs007"; break;
                       case 25: sItem = "nw_wblmcl006"; break;
                       case 26: sItem = "nw_wbwmsl004"; break;
                       case 27: sItem = "nw_wbwmxh006"; break;
                       case 28: sItem = "nw_wplmss004"; break;
                       case 29: sItem = "nw_wswmdg005"; break;
                       case 30: sItem = "nw_wbwmxl006"; break;
                       case 31: sItem = "nw_wspmsc005"; break;

                   }

            }
                CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMartial(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMartial(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericMartial(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmax005"; break;
                       case 3: sItem = "nw_wthmax007"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax003"; break;
                       case 2: sItem = "nw_wthmax005"; break;
                       case 3: sItem = "nw_wthmax007"; break;
                       case 4: sItem = "nw_wthmax003"; break;
                       case 5: sItem = "nw_wthmax004"; break;
                       case 6: sItem = "nw_wthmax006"; break;
                       case 7: sItem = "nw_wswmrp004"; break;
                       case 8: sItem = "nw_wswmrp004"; break;
                       case 9: sItem = "nw_wblmfl004"; break;
                       case 10: sItem = "nw_wblmhl004"; break;
                       case 11: sItem = "nw_wbwmsh003"; break;
                       case 12: sItem = "nw_wblmhw006"; break;
                       case 13: sItem = "nw_wblmhw006"; break;
                       case 14: sItem = "nw_wbwmln004"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(28) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl005"; break;
                       case 2: sItem = "nw_wthmax007"; break;
                       case 3: sItem = "nw_wthmax003"; break;
                       case 4: sItem = "nw_wthmax004"; break;
                       case 5: sItem = "nw_wthmax006"; break;
                       case 6: sItem = "nw_wswmrp004"; break;
                       case 7: sItem = "nw_wswmrp004"; break;
                       case 8: sItem = "nw_wblmfl004"; break;
                       case 9: sItem = "nw_wblmhl004"; break;
                       case 10: sItem = "nw_wbwmsh003"; break;
                       case 11: sItem = "nw_wblmhw006"; break;
                       case 12: sItem = "nw_wblmhw006"; break;
                       case 13: sItem = "nw_wbwmln004"; break;
                       case 14: sItem = "nw_wblmfl005"; break;
                       case 15: sItem = "nw_wswmgs006"; break;
                       case 16: sItem = "nw_waxmgr003"; break;
                       case 17: sItem = "nw_wplmhb004"; break;
                       case 18: sItem = "nw_wblmhw005"; break;
                       case 19: sItem = "nw_wblmfh004"; break;
                       case 20: sItem = "nw_wblmfh008"; break;
                       case 21: sItem = "nw_wbwmsh006"; break;
                       case 22: sItem = "nw_wswmsc004"; break;
                       case 23: sItem = "nw_waxmgr006"; break;
                       case 24: sItem = "nw_wswmrp005"; break;
                       case 25: sItem = "nw_wswmls007"; break;
                       case 26: sItem = "nw_wswmgs004"; break;
                       case 27: sItem = "nw_waxmhn004"; break;
                       case 28: sItem = "nw_wswmbs005"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(42) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw006"; break;
                       case 2: sItem = "nw_wblmhw006"; break;
                       case 3: sItem = "nw_wblmhw006"; break;
                       case 4: sItem = "nw_wbwmln004"; break;
                       case 5: sItem = "nw_wblmfl005"; break;
                       case 6: sItem = "nw_wswmgs006"; break;
                       case 7: sItem = "nw_waxmgr003"; break;
                       case 8: sItem = "nw_wplmhb004"; break;
                       case 9: sItem = "nw_wblmhw005"; break;
                       case 10: sItem = "nw_wblmfh004"; break;
                       case 11: sItem = "nw_wblmfh008"; break;
                       case 12: sItem = "nw_wbwmsh006"; break;
                       case 13: sItem = "nw_wswmsc004"; break;
                       case 14: sItem = "nw_waxmgr006"; break;
                       case 15: sItem = "nw_wswmrp005"; break;
                       case 16: sItem = "nw_wswmls007"; break;
                       case 17: sItem = "nw_wswmgs004"; break;
                       case 18: sItem = "nw_waxmhn004"; break;
                       case 19: sItem = "nw_wswmbs005"; break;
                       case 20: sItem = "nw_wblmhl005"; break;
                       case 21: sItem = "nw_wblmhl011"; break;
                       case 22: sItem = "nw_wswmss005"; break;
                       case 23: sItem = "nw_wplmhb003"; break;
                       case 24: sItem = "nw_wbwmln007"; break;
                       case 25: sItem = "nw_wbwmln007"; break;
                       case 26: sItem = "nw_wbwmsh007"; break;
                       case 27: sItem = "nw_waxmbt006"; break;
                       case 28: sItem = "nw_wswmbs006"; break;
                       case 29: sItem = "nw_wblmfl007"; break;
                       case 30: sItem = "nw_waxmhn003"; break;
                       case 31: sItem = "nw_wblmhl006"; break;
                       case 32: sItem = "nw_wblmfl006"; break;
                       case 33: sItem = "nw_wswmls005"; break;
                       case 34: sItem = "nw_wswmss004"; break;
                       case 35: sItem = "nw_wbwmln006"; break;
                       case 36: sItem = "nw_wblmhw003"; break;
                       case 37: sItem = "nw_wblmfh006"; break;
                       case 38: sItem = "nw_wswmsc006"; break;
                       case 39: sItem = "nw_waxmhn005"; break;
                       case 40: sItem = "nw_wblmfh003"; break;
                       case 41: sItem = "nw_wswmls006"; break;
                       case 42: sItem = "nw_wswmrp007"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(55) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl005"; break;
                       case 2: sItem = "nw_wblmhl005"; break;
                       case 3: sItem = "nw_wblmhl011"; break;
                       case 4: sItem = "nw_wswmss005"; break;
                       case 5: sItem = "nw_wplmhb003"; break;
                       case 6: sItem = "nw_wbwmln007"; break;
                       case 7: sItem = "nw_wbwmln007"; break;
                       case 8: sItem = "nw_wbwmsh007"; break;
                       case 9: sItem = "nw_waxmbt006"; break;
                       case 10: sItem = "nw_wswmbs006"; break;
                       case 11: sItem = "nw_wblmfl007"; break;
                       case 12: sItem = "nw_waxmhn003"; break;
                       case 13: sItem = "nw_wblmhl006"; break;
                       case 14: sItem = "nw_wblmfl006"; break;
                       case 15: sItem = "nw_wswmls005"; break;
                       case 16: sItem = "nw_wswmss004"; break;
                       case 17: sItem = "nw_wbwmln006"; break;
                       case 18: sItem = "nw_wblmhw003"; break;
                       case 19: sItem = "nw_wblmfh006"; break;
                       case 20: sItem = "nw_wswmsc006"; break;
                       case 21: sItem = "nw_waxmhn005"; break;
                       case 22: sItem = "nw_wblmfh003"; break;
                       case 23: sItem = "nw_wswmls006"; break;
                       case 24: sItem = "nw_wswmrp007"; break;
                       case 25: sItem = "nw_wswmgs005"; break;
                       case 26: sItem = "nw_wswmgs005"; break;
                       case 27: sItem = "nw_waxmgr005"; break;
                       case 28: sItem = "nw_wplmhb007"; break;
                       case 29: sItem = "nw_wswmsc007"; break;
                       case 30: sItem = "nw_wswmrp006"; break;
                       case 31: sItem = "nw_wswmss006"; break;
                       case 32: sItem = "nw_wblmhl009"; break;
                       case 33: sItem = "nw_wswmbs007"; break;
                       case 34: sItem = "nw_wbwmln005"; break;
                       case 35: sItem = "nw_wblmfh005"; break;
                       case 36: sItem = "nw_wswmgs003"; break;
                       case 37: sItem = "nw_waxmbt003"; break;
                       case 38: sItem = "nw_wswmls004"; break;
                       case 39: sItem = "nw_wbwmsh005"; break;
                       case 40: sItem = "nw_wbwmsh005"; break;
                       case 41: sItem = "nw_waxmbt004"; break;
                       case 42: sItem = "nw_waxmbt004"; break;
                       case 43: sItem = "nw_wblmhl003"; break;
                       case 44: sItem = "nw_wblmhl003"; break;
                       case 45: sItem = "nw_wswmbs003"; break;
                       case 46: sItem = "nw_waxmbt005"; break;
                       case 47: sItem = "nw_waxmhn006"; break;
                       case 48: sItem = "nw_wswmss003"; break;
                       case 49: sItem = "nw_wswmsc005"; break;
                       case 50: sItem = "nw_wplmhb006"; break;
                       case 51: sItem = "nw_wbwmsh004"; break;
                       case 52: sItem = "nw_wswmbs004"; break;
                       case 53: sItem = "nw_wbwmln003"; break;
                       case 54: sItem = "nw_wblmhw004"; break;
                       case 55: sItem = "nw_waxmgr004"; break;
                   }

            }
                CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificExotic(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericExotic(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmsh003"; break;
                       case 3: sItem = "nw_wthmsh006"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericExotic(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmsh003"; break;
                       case 3: sItem = "nw_wthmsh006"; break;
                       case 4: sItem = "nw_wthmsh004"; break;
                       case 5: sItem = "nw_wthmsh007"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh006"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: sItem = "nw_wthmsh004"; break;
                       case 4: sItem = "nw_wthmsh007"; break;
                       case 5: sItem = "nw_wspmku006"; break;
                       case 6: sItem = "nw_wdbmma003"; break;
                       case 7: sItem = "nw_wswmka005"; break;
                       case 8: sItem = "nw_wspmka004"; break;
                       case 9: sItem = "nw_wspmka007"; break;
                       case 10: sItem = "nw_wdbmax006"; break;
                       case 11: sItem = "nw_wdbmsw006"; break;
                       case 12: sItem = "nw_wspmku005"; break;
                       case 13: sItem = "nw_wdbmsw007"; break;
                       case 14: sItem = "nw_wspmka005"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(16) + 1;
                  switch (nRandom)
                  {
                       case 1:sItem = "nw_wthmsh007"; break;
                       case 2: sItem = "nw_wthmsh007"; break;
                       case 3: sItem = "nw_wspmku006"; break;
                       case 4: sItem = "nw_wdbmma003"; break;
                       case 5: sItem = "nw_wswmka005"; break;
                       case 6: sItem = "nw_wspmka004"; break;
                       case 7: sItem = "nw_wspmka007"; break;
                       case 8: sItem = "nw_wdbmax006"; break;
                       case 9: sItem = "nw_wdbmsw006"; break;
                       case 10: sItem = "nw_wspmku005"; break;
                       case 11: sItem = "nw_wdbmsw007"; break;
                       case 12: sItem = "nw_wspmka005"; break;
                       case 13: sItem = "nw_wplmsc003"; break;
                       case 14: sItem = "nw_wdbmax005"; break;
                       case 15: sItem = "nw_wspmku004"; break;
                       case 16: sItem = "nw_wdbmma005"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc003"; break;
                       case 2: sItem = "nw_wspmka005"; break;
                       case 3: sItem = "nw_wplmsc003"; break;
                       case 4: sItem = "nw_wdbmax005"; break;
                       case 5: sItem = "nw_wspmku004"; break;
                       case 6: sItem = "nw_wdbmma005"; break;
                       case 7: sItem = "nw_wdbmma005"; break;
                       case 8: sItem = "nw_wdbmax004"; break;
                       case 9: sItem = "nw_wdbmma004"; break;
                       case 10: sItem = "nw_wswmka007"; break;
                       case 11: sItem = "nw_wdbmsw005"; break;
                       case 12: sItem = "nw_wspmka006"; break;
                       case 13: sItem = "nw_wspmka003"; break;
                       case 14: sItem = "nw_wdbmax007"; break;
                       case 15: sItem = "nw_wplmsc006"; break;
                       case 16: sItem = "nw_wspmku007"; break;
                       case 17: sItem = "nw_wdbmma006"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(21) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma005"; break;
                       case 2: sItem = "nw_wdbmma005"; break;
                       case 3: sItem = "nw_wdbmma005"; break;
                       case 4: sItem = "nw_wdbmax004"; break;
                       case 5: sItem = "nw_wdbmma004"; break;
                       case 6: sItem = "nw_wswmka007"; break;
                       case 7: sItem = "nw_wdbmsw005"; break;
                       case 8: sItem = "nw_wspmka006"; break;
                       case 9: sItem = "nw_wspmka003"; break;
                       case 10: sItem = "nw_wdbmax007"; break;
                       case 11: sItem = "nw_wplmsc006"; break;
                       case 12: sItem = "nw_wspmku007"; break;
                       case 13: sItem = "nw_wdbmma006"; break;
                       case 14: sItem = "nw_wspmku003"; break;
                       case 15: sItem = "nw_wswmka006"; break;
                       case 16: sItem = "nw_wplmsc005"; break;
                       case 17: sItem = "nw_wplmsc005"; break;
                       case 18: sItem = "nw_wswmka004"; break;
                       case 19: sItem = "nw_wswmka004"; break;
                       case 20: sItem = "nw_wdbmsw004"; break;
                       case 21: sItem = "nw_wplmsc004"; break;
                   }

            }
                CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificLightArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericLightArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericLightArmor(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_ashmsw011"; break;
                       case 3: sItem = "nw_ashmsw010"; break;
                   }
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmsw011"; break;
                       case 2: sItem = "nw_ashmsw011"; break;
                       case 3: sItem = "nw_ashmsw010"; break;
                       case 4: sItem = "nw_maarcl011"; break;
                       case 5: sItem = "nw_ashmsw006"; break;
                       case 6: sItem = "nw_maarcl017"; break;
                       case 7: sItem = "nw_ashmsw005"; break;
                       case 8: sItem = "nw_maarcl013"; break;
                       case 9: sItem = "nw_maarcl012"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl011"; break;
                       case 2: sItem = "nw_maarcl011"; break;
                       case 3: sItem = "nw_ashmsw006"; break;
                       case 4: sItem = "nw_maarcl017"; break;
                       case 5: sItem = "nw_ashmsw005"; break;
                       case 6: sItem = "nw_maarcl013"; break;
                       case 7: sItem = "nw_maarcl012"; break;
                       case 8: sItem = "nw_ashmsw004"; break;
                       case 9: sItem = "nw_maarcl006"; break;
                       case 10: sItem = "nw_maarcl032"; break;
                       case 11: sItem = "nw_maarcl003"; break;
                       case 12: sItem = "nw_maarcl002"; break;
                       case 13: sItem = "nw_maarcl007"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl012"; break;
                       case 2: sItem = "nw_maarcl012"; break;
                       case 3: sItem = "nw_ashmsw004"; break;
                       case 4: sItem = "nw_maarcl006"; break;
                       case 5: sItem = "nw_maarcl032"; break;
                       case 6: sItem = "nw_maarcl003"; break;
                       case 7: sItem = "nw_maarcl002"; break;
                       case 8: sItem = "nw_maarcl005"; break;
                       case 9: sItem = "nw_ashmsw003"; break;
                       case 10: sItem = "nw_maarcl001"; break;
                       case 11: sItem = "nw_maarcl034"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl005"; break;
                       case 2: sItem = "nw_maarcl005"; break;
                       case 3: sItem = "nw_ashmsw003"; break;
                       case 4: sItem = "nw_maarcl001"; break;
                       case 5: sItem = "nw_maarcl034"; break;
                       case 6: sItem = "nw_maarcl008"; break;
                       case 7: sItem = "nw_ashmsw007"; break;
                       case 8: sItem = "nw_maarcl033"; break;
                       case 9: sItem = "nw_mcloth005"; break;
                       case 10: sItem = "nw_maarcl009"; break;
                       case 11: sItem = "nw_maarcl004"; break;
                   }

            }
              CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMediumArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMediumArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericMediumArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe008"; break;
                       case 2: sItem = "nw_armhe008"; break;
                       //case 3: sItem = "nw_armhe007"; break;
                       case 4: sItem = "nw_armhe009"; break;
                       //case 5: sItem = "nw_armhe010"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe008"; break;
                       case 2: sItem = "nw_armhe008"; break;
                       //case 3: sItem = "nw_armhe007"; break;
                       case 4: sItem = "nw_armhe009"; break;
                       //case 5: sItem = "nw_armhe010"; break;
                       case 6: sItem = "nw_armhe006"; break;
                       case 7: sItem = "nw_ashmlw007"; break;
                       case 8: sItem = "nw_ashmlw005"; break;
                       case 9: sItem = "nw_maarcl016"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(12) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe009"; break;
                       case 2: sItem = "nw_armhe009"; break;
                       //case 3: sItem = "nw_armhe010"; break;
                       case 4: sItem = "nw_armhe006"; break;
                       case 5: sItem = "nw_ashmlw007"; break;
                       case 6: sItem = "nw_ashmlw005"; break;
                       case 7: sItem = "nw_maarcl016"; break;
                       case 8: sItem = "nw_maarcl036"; break;
                       case 9: sItem = "nw_ashmlw004"; break;
                       case 10: sItem = "nw_maarcl037"; break;
                       case 11: sItem = "nw_maarcl040"; break;
                       case 12: sItem = "nw_ashmlw006"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(12) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl016"; break;
                       case 2: sItem = "nw_maarcl016"; break;
                       case 3: sItem = "nw_maarcl036"; break;
                       case 4: sItem = "nw_ashmlw004"; break;
                       case 5: sItem = "nw_maarcl037"; break;
                       case 6: sItem = "nw_maarcl040"; break;
                       case 7: sItem = "nw_ashmlw006"; break;
                       case 8: sItem = "nw_ashmlw003"; break;
                       case 9: sItem = "nw_maarcl014"; break;
                       case 10: sItem = "nw_maarcl039"; break;
                       case 11: sItem = "nw_maarcl010"; break;
                       case 12: sItem = "nw_maarcl015"; break;
                   }

            }
                  CreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificHeavyArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericHeavyArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericHeavyArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl026"; break;
                       case 2: sItem = "nw_maarcl026"; break;
                       case 3: sItem = "nw_maarcl021"; break;
                       case 4: sItem = "nw_ashmto003"; break;
                       case 5: sItem = "nw_maarcl029"; break;
                       case 6: sItem = "nw_maarcl020"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl021"; break;
                       case 2: sItem = "nw_maarcl026"; break;
                       case 3: sItem = "nw_maarcl021"; break;
                       case 4: sItem = "nw_ashmto003"; break;
                       case 5: sItem = "nw_maarcl029"; break;
                       case 6: sItem = "nw_maarcl020"; break;
                       case 7: sItem = "nw_ashmto006"; break;
                       case 8: sItem = "nw_maarcl041"; break;
                       case 9: sItem = "nw_ashmto005"; break;
                       case 10: sItem = "nw_ashmto007"; break;
                       case 11: sItem = "nw_ashmto010"; break;
                       case 12: sItem = "nw_maarcl022"; break;
                       case 13: sItem = "nw_maarcl018"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl020"; break;
                       case 2: sItem = "nw_maarcl020"; break;
                       case 3: sItem = "nw_ashmto006"; break;
                       case 4: sItem = "nw_maarcl041"; break;
                       case 5: sItem = "nw_ashmto005"; break;
                       case 6: sItem = "nw_ashmto007"; break;
                       case 7: sItem = "nw_ashmto010"; break;
                       case 8: sItem = "nw_maarcl022"; break;
                       case 9: sItem = "nw_maarcl018"; break;
                       case 10: sItem = "nw_maarcl024"; break;
                       case 11: sItem = "nw_ashmto011"; break;
                       case 12: sItem = "nw_maarcl042"; break;
                       case 13: sItem = "nw_maarcl054"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl018"; break;
                       case 2: sItem = "nw_maarcl018"; break;
                       case 3: sItem = "nw_maarcl024"; break;
                       case 4: sItem = "nw_ashmto011"; break;
                       case 5: sItem = "nw_maarcl042"; break;
                       case 6: sItem = "nw_maarcl054"; break;
                       case 7: sItem = "nw_ashmto004"; break;
                       case 8: sItem = "nw_maarcl025"; break;
                       case 9: sItem = "nw_maarcl028"; break;
                       case 10: sItem = "nw_maarcl027"; break;
                   }

            }
                  CreateItemOnObject(sItem, oTarget, 1);

        }
        
        
//::///////////////////////////////////////////////
//:: Determine Class to Use
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines which of a NPCs three classes to
    use in the random treasure system
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

int nDetermineClassToUse(object oCharacter)
{
    int nClass;
    int nTotal = GetHitDice(oCharacter);
    //dbSpeak("Hit dice " + IntToString(nTotal));
    if (nTotal < 1)
    {
        nTotal = 1;
    }
    float fTotal = IntToFloat(nTotal);
    if (GetIsObjectValid(oCharacter) == FALSE)
    {
        //dbSpeak("DetermineClassToUse: This character is invalid");
    }
    int nClass1 =  GetClassByPosition(1, oCharacter);
    int nState1 = FloatToInt((IntToFloat(GetLevelByClass(nClass1, oCharacter)) / fTotal) * 100);
    //dbSpeak("Level 1 Class Level = " + IntToString(GetLevelByClass(nClass1,oCharacter)));

    PrintString("GENERIC SCRIPT DEBUG STRING ********** " +  GetTag(oCharacter) + "Class 1 " + IntToString(nState1));
    //dbSpeak("State 1 " + IntToString(nState1));
    int nClass2 = GetClassByPosition(2, oCharacter);
    int nState2 = FloatToInt((IntToFloat(GetLevelByClass(nClass2, oCharacter)) / fTotal) * 100) + nState1;
    PrintString("GENERIC SCRIPT DEBUG STRING ********** " + GetTag(oCharacter) + "Class 2 " + IntToString(nState2));

    int nClass3 = GetClassByPosition(3, oCharacter);
    int nState3 = FloatToInt((IntToFloat(GetLevelByClass(nClass3, oCharacter)) / fTotal) * 100) + nState2;
    PrintString("GENERIC SCRIPT DEBUG STRING ********** " + GetTag(oCharacter) + "Class 3 " + IntToString(nState3));

    int nUseClass = d100();
    PrintString("GENERIC SCRIPT DEBUG STRING ********** " + "D100 Roll " +IntToString(nUseClass));


    //dbSpeak("Before comparison : " + IntToString(nClass1));
    if(nUseClass <= nState1)
    {
        nClass = nClass1;
    }
    else if(nUseClass > nState1 && nUseClass <= nState2)
    {
        nClass = nClass2;
    }
    else
    {
        nClass = nClass3;
    }
    //dbSpeak("Class from determineClass " + IntToString(nClass));
    return nClass;
}
        
   // * if nSpecific is = 1 then spawn in 'named' items at the higher levels
    void CreateTable2Item(object oTarget, object oAdventurer, int nSpecific=0)
    {
        //dbSpeak("In CreateTable2Item");
        string sItem = "";
        int nProbMisc = 0;
        int nProbClass = 0;
        int nProbRodStaffWand = 0;
        int nProbSimple = 0;
        int nProbMartial = 0;
        int nProbExotic = 0;
        int nProbLight = 0;
        int nProbMedium = 0;
        int nProbHeavy = 0;

        int nSpecialRanger = 0; // 2 Means to treat the ranger as a barbarian. A 1 is to treat it as a fighter


        // * May 2002: Changed using Preston's multiclass function
        // * it randomly chooses one of your classes
        int nClass =  nDetermineClassToUse(oAdventurer);


        // * SPECIAL RANGER BEHAVIOR
        // * If the ranger has the Heavy Armor proficiency, will treat the ranger
        if ( nClass == CLASS_TYPE_RANGER && GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY))
        {
            nSpecialRanger = 1;
        }
        else
        if (nClass == CLASS_TYPE_RANGER)
        {
            nSpecialRanger = 2;
        }



        //* SETUP probabilities based on Class
        if ( nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_PALADIN || nSpecialRanger == 1)
        {
            //dbSpeak("I am fighter or paladin or heavy ranger");
            nProbMisc = 20;
            nProbClass = 0;
            nProbRodStaffWand = 5;
            nProbSimple = 5;
            nProbMartial = 20;
            nProbExotic = 10;
            nProbLight = 5;
            nProbMedium = 15;
            nProbHeavy = 20;
        }
        else
        if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER)
        {
            //dbSpeak("I am wizard or sorcerer");
            nProbMisc = 40;
            nProbClass = 30;
            nProbRodStaffWand = 15;
            nProbSimple = 3;
            nProbMartial = 3;
            nProbExotic = 3;
            nProbLight = 2;
            nProbMedium = 2;
            nProbHeavy = 2;
        }
        else
        if (nClass == CLASS_TYPE_BARBARIAN || nSpecialRanger == 2)
        {
            //dbSpeak("I am barbarian or light ranger");

            nProbMisc = 20;
            nProbClass = 0;
            nProbRodStaffWand = 5;
            nProbSimple = 17;
            nProbMartial = 27;
            nProbExotic = 15;
            nProbLight = 8;
            nProbMedium = 5;
            nProbHeavy = 3;
        }
        else
        if (nClass == CLASS_TYPE_CLERIC)
        {
            //dbSpeak("I am cleric");

            nProbMisc = 20;
            nProbClass = 10;
            nProbRodStaffWand = 10;
            nProbSimple = 25;
            nProbMartial = 7;
            nProbExotic = 5;
            nProbLight = 5;
            nProbMedium = 8;
            nProbHeavy = 10;
        }
        else
        if (nClass == CLASS_TYPE_DRUID)
        {
            //dbSpeak("I am druid");

            nProbMisc = 20;
            nProbClass = 25;
            nProbRodStaffWand = 15;
            nProbSimple = 10;
            nProbMartial = 5;
            nProbExotic = 5;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        else
        if (nClass == CLASS_TYPE_MONK)
        {
            //dbSpeak("I am monk");
            nProbMisc = 20;
            nProbClass = 50;
            nProbRodStaffWand = 2;
            nProbSimple = 7;
            nProbMartial = 2;
            nProbExotic = 7;
            nProbLight = 4;
            nProbMedium = 4;
            nProbHeavy = 4;
        }
        else
        if (nClass == CLASS_TYPE_ROGUE)
        {
            //dbSpeak("I am rogue");

            nProbMisc = 25;
            nProbClass = 10;
            nProbRodStaffWand = 10;
            nProbSimple = 25;
            nProbMartial = 5;
            nProbExotic = 5;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        else
        if (nClass == CLASS_TYPE_BARD)
        {
            //dbSpeak("I am bard");

            nProbMisc = 25;
            nProbClass = 5;
            nProbRodStaffWand = 5;
            nProbSimple = 25;
            nProbMartial = 10;
            nProbExotic = 10;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        else
        {
            //dbSpeak("No Valid Class");
        }
        //dbSpeak("Table2Item: After Class Distribution");
        //* Create Items based on Probabilities
        int nRandom = d100();
        if (nRandom <= nProbMisc)
        {
            if (nSpecific == 0) CreateGenericMiscItem(oTarget, oAdventurer);
            else CreateSpecificMiscItem(oTarget, oAdventurer);

        }
        else
        if (nRandom <= nProbMisc + nProbClass)
        {   // * no need for a seperate specific function here
            CreateGenericClassItem(oTarget, oAdventurer, nSpecific);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand)
        {
            if (nSpecific == 0) CreateGenericRodStaffWand(oTarget, oAdventurer);
            else CreateSpecificRodStaffWand(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple)
        {
            if (nSpecific == 0) CreateGenericSimple(oTarget, oAdventurer);
            else CreateSpecificSimple(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial)
        {

             if (nSpecific == 0) CreateGenericMartial(oTarget, oAdventurer);
             else CreateSpecificMartial(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic)
        {
            if (nSpecific == 0) CreateGenericExotic(oTarget, oAdventurer);
            else CreateSpecificExotic(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight)
        {
            if (nSpecific == 0) CreateGenericLightArmor(oTarget, oAdventurer);
            else CreateSpecificLightArmor(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight + nProbMedium)
        {
            if (nSpecific == 0) CreateGenericMediumArmor(oTarget, oAdventurer);
            else CreateSpecificMediumArmor(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight + nProbMedium + nProbHeavy)
        {
            if (nSpecific == 0) CreateGenericHeavyArmor(oTarget, oAdventurer);
            else CreateSpecificHeavyArmor(oTarget, oAdventurer);
        }
        else
        {
            //dbSpeak("Generic Generic or Specific; error: 3524");
        }
    }


//::///////////////////////////////////////////////
//:: GetNumberOfItems
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the number of items to create.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetNumberOfItems(int nTreasureType)
{
    int nItems = 0;
    int nRandom = 0;

    int nProbThreeItems = 0;
    int nProbTwoItems = 0;
    int nProbOneItems = 0;

    if (nTreasureType == TREASURE_LOW)
    {
     nProbThreeItems = NUMBER_LOW_THREE;
     nProbTwoItems = NUMBER_LOW_TWO;
     nProbOneItems = NUMBER_LOW_ONE;
    }
    else
    if (nTreasureType == TREASURE_MEDIUM)
    {
     nProbThreeItems = NUMBER_MED_THREE;
     nProbTwoItems = NUMBER_MED_TWO;
     nProbOneItems = NUMBER_MED_ONE;
    }
    else
    if (nTreasureType == TREASURE_HIGH)
    {
     nProbThreeItems = NUMBER_HIGH_THREE;
     nProbTwoItems = NUMBER_HIGH_TWO;
     nProbOneItems = NUMBER_HIGH_ONE;
    }
    else
    if (nTreasureType == TREASURE_BOSS)
    {
     nProbThreeItems = NUMBER_BOSS_THREE;
     nProbTwoItems = NUMBER_BOSS_TWO;
     nProbOneItems = NUMBER_BOSS_ONE;
    }
    else
    if (nTreasureType == TREASURE_BOOK)
    {
     nProbThreeItems = NUMBER_BOOK_THREE;
     nProbTwoItems = NUMBER_BOOK_TWO;
     nProbOneItems = NUMBER_BOOK_ONE;
    }


    nRandom = d100();
    if (nRandom <= nProbThreeItems)
    {
        nItems = 3;
    }
    else
    if (nRandom <= nProbTwoItems + nProbThreeItems)
    {
        nItems = 2;
    }
    else
    {
        nItems = 1;
    }

    // * May 13 2002: Cap number of items, in case of logic error
    if (nItems > 3)
    {
        nItems = 3;
    }

    return nItems;
}

//:://////////////////////////////////////////////
//:: Created By:  Andrew
//:: Created On:
//:://////////////////////////////////////////////
void GenerateTreasure(int nTreasureType, object oLastOpener, object oCreateOn)
{

    //dbSpeak("*********************NEW TREASURE*************************");

    // * abort treasure if no one opened the container
    if (GetIsObjectValid(oLastOpener) == FALSE)
    {
        //dbSpeak("Aborted.  No valid Last Opener");
        return;
    }

    // * if no valid create on object, then create on oLastOpener
    if (oCreateOn == OBJECT_INVALID)
    {
        oCreateOn = oLastOpener;
    }

    // * if an Animal then generate 100% animal treasure

    // not done yet
    // * VARIABLES
   int nProbBook =   0;
   int nProbAnimal = 0;
   int nProbJunk =   0;
   int nProbGold = 0;
   int nProbGem = 0;
   int nProbJewel = 0;
   int nProbArcane = 0;
   int nProbDivine = 0;
   int nProbAmmo = 0;
   int nProbKit = 0;
   int nProbPotion = 0;
   int nProbTable2 = 0;

   int nSpecific = 0;
   int i = 0;
   int nNumberItems = GetNumberOfItems(nTreasureType);

   // * Set Treasure Type Values
   if (nTreasureType == TREASURE_LOW)
   {
    nProbBook   = LOW_PROB_BOOK;
    nProbAnimal = LOW_PROB_ANIMAL;
    nProbJunk   = LOW_PROB_JUNK;
    nProbGold   = LOW_PROB_GOLD;
    nProbGem    = LOW_PROB_GEM;
    nProbJewel  = LOW_PROB_JEWEL;
    nProbArcane = LOW_PROB_ARCANE;
    nProbDivine  = LOW_PROB_DIVINE;
    nProbAmmo = LOW_PROB_AMMO ;
    nProbKit = LOW_PROB_KIT;
    nProbPotion = LOW_PROB_POTION;
    nProbTable2 = LOW_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_MEDIUM)
   {
    nProbBook   = MEDIUM_PROB_BOOK;
    nProbAnimal = MEDIUM_PROB_ANIMAL;
    nProbJunk   = MEDIUM_PROB_JUNK;
    nProbGold   = MEDIUM_PROB_GOLD;
    nProbGem    = MEDIUM_PROB_GEM;
    nProbJewel  = MEDIUM_PROB_JEWEL;
    nProbArcane = MEDIUM_PROB_ARCANE;
    nProbDivine  = MEDIUM_PROB_DIVINE;
    nProbAmmo = MEDIUM_PROB_AMMO ;
    nProbKit = MEDIUM_PROB_KIT;
    nProbPotion = MEDIUM_PROB_POTION;
    nProbTable2 = MEDIUM_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_HIGH)
   {
    nProbBook   = HIGH_PROB_BOOK;
    nProbAnimal = HIGH_PROB_ANIMAL;
    nProbJunk   = HIGH_PROB_JUNK;
    nProbGold   = HIGH_PROB_GOLD;
    nProbGem    = HIGH_PROB_GEM;
    nProbJewel  = HIGH_PROB_JEWEL;
    nProbArcane = HIGH_PROB_ARCANE;
    nProbDivine  = HIGH_PROB_DIVINE;
    nProbAmmo = HIGH_PROB_AMMO ;
    nProbKit = HIGH_PROB_KIT;
    nProbPotion = HIGH_PROB_POTION;
    nProbTable2 = HIGH_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_BOSS)
   { //dbSpeak("boss");
    nProbTable2 = 100;
    nSpecific = 1;
   }
   else if (nTreasureType == TREASURE_BOOK)
   {
    nProbBook = 90;
    nProbArcane = 6;
    nProbDivine = 4;
   }

   //dbSpeak("Generate Treasure nSpecific = " + IntToString(nSpecific));

   for (i = 1; i <= nNumberItems; i++)
   {
     int nRandom = d100();
     if (nRandom <= nProbBook)
        CreateBook(oCreateOn);                                // * Book
     else if (nRandom <= nProbBook + nProbAnimal)
        CreateAnimalPart(oCreateOn);                          // * Animal
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk)
        CreateJunk(oCreateOn);                                // * Junk
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold)
        SCCreateGold(oCreateOn, oLastOpener, nTreasureType);    // * Gold
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem)
        CreateGem(oCreateOn, oLastOpener, nTreasureType);     // * Gem
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel)
        CreateJewel(oCreateOn, oLastOpener, nTreasureType);   // * Jewel
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane)
        CreateArcaneScroll(oCreateOn, oLastOpener);   // * Arcane Scroll
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine)
        CreateDivineScroll(oCreateOn, oLastOpener);   // * Divine Scroll
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo)
        CreateAmmo(oCreateOn, oLastOpener);   // * Ammo
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit)
        CreateKit(oCreateOn, oLastOpener);   // * Healing, Trap, or Thief kit
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit + nProbPotion)
        CreatePotion(oCreateOn, oLastOpener);   // * Potion
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit + nProbPotion + nProbTable2)
     {
        CreateTable2Item(oCreateOn, oLastOpener, nSpecific);   // * Weapons, Armor, Misc - Class based
     }
     else
     {
      //dbSpeak("other stuff");
		}


   }
}

void GenerateLowTreasure(object oLastOpener, object oCreateOn=OBJECT_INVALID)
{
 GenerateTreasure(TREASURE_LOW, oLastOpener, oCreateOn);
}
void GenerateMediumTreasure(object oLastOpener, object oCreateOn=OBJECT_INVALID)
{
 GenerateTreasure(TREASURE_MEDIUM, oLastOpener, oCreateOn);
}
void GenerateHighTreasure(object oLastOpener, object oCreateOn=OBJECT_INVALID)
{
 GenerateTreasure(TREASURE_HIGH, oLastOpener, oCreateOn);
}
void GenerateBossTreasure(object oLastOpener, object oCreateOn=OBJECT_INVALID)
{
 GenerateTreasure(TREASURE_BOSS, oLastOpener, oCreateOn);
}
void GenerateBookTreasure(object oLastOpener, object oCreateOn=OBJECT_INVALID)
{
 GenerateTreasure(TREASURE_BOOK, oLastOpener, oCreateOn);
}


// Generate treasure using default method.
// Not prototyped -- this function should not be used outside
// this library.
void SCTreasureCreateDefaultTreasure(int nTreasureType, object oAdventurer, object oCont)
{
    // generate treasure using default method from nw_o2_coninclude
    if (nTreasureType == TREASURE_TYPE_LOW) {
        GenerateLowTreasure(oAdventurer, oCont);
    } else if (nTreasureType == TREASURE_TYPE_MED) {
        GenerateMediumTreasure(oAdventurer, oCont);            
    } else if (nTreasureType == TREASURE_TYPE_HIGH) {
        GenerateHighTreasure(oAdventurer, oCont);
    } else if (nTreasureType == TREASURE_TYPE_UNIQUE) {
        GenerateBossTreasure(oAdventurer, oCont);
    }
}

// Get the specified item out of the given base container's inventory
object SCGetTreasureItem(object oBaseCont, int nItemNum)
{
    if (!GetIsObjectValid(oBaseCont)) {return OBJECT_INVALID;}

    // initialize the container -- this will automatically
    // only happen once.
    SCTreasureInitContainer(oBaseCont);

    // Refs to the items are stored on the container itself
    string sVar = sTreasureItemVarname + IntToString(nItemNum);
    return GetLocalObject(oBaseCont, sVar);
}

// Check if the item's base type is of the given base type
int SCGetIsBaseType(int nItemBaseType,
                            int nBaseType1=BASE_ITEM_INVALID,
                            int nBaseType2=BASE_ITEM_INVALID,
                            int nBaseType3=BASE_ITEM_INVALID)
{
    return ( (nItemBaseType != BASE_ITEM_INVALID)
             && (
                 nItemBaseType == nBaseType1 
                 || nItemBaseType == nBaseType2
                 || nItemBaseType == nBaseType3) );
}


// Check if the item's base type is a weapon but not ammunition
int SCGetIsWeaponNoammo(int nItemBaseType)
{
    return ( CSLGetIsAWeapon(nItemBaseType) 
             && (nItemBaseType != BASE_ITEM_ARROW
                 || nItemBaseType != BASE_ITEM_BOLT
                 || nItemBaseType != BASE_ITEM_BULLET)
             );
}

// Check if the item's base type is a ranged weapon
int SCGetIsRangedWeapon(int nItemBaseType)
{
    return (nItemBaseType == BASE_ITEM_DART
            || nItemBaseType == BASE_ITEM_GRENADE
            || nItemBaseType == BASE_ITEM_HEAVYCROSSBOW
            || nItemBaseType == BASE_ITEM_LIGHTCROSSBOW
            || nItemBaseType == BASE_ITEM_LONGBOW
            || nItemBaseType == BASE_ITEM_SHORTBOW
            || nItemBaseType == BASE_ITEM_SHURIKEN 
            || nItemBaseType == BASE_ITEM_SLING 
            || nItemBaseType == BASE_ITEM_THROWINGAXE);
}



// Check if the item's base type is armor
int SCGetIsArmor(int nItemBaseType)
{
    return (nItemBaseType == BASE_ITEM_ARMOR
            || nItemBaseType == BASE_ITEM_LARGESHIELD
            || nItemBaseType == BASE_ITEM_SMALLSHIELD
            || nItemBaseType == BASE_ITEM_TOWERSHIELD);
}

// Check if the item's base type is clothing
int SCGetIsClothing(int nItemBaseType)
{
        return (nItemBaseType == BASE_ITEM_BELT
            || nItemBaseType == BASE_ITEM_BOOTS
            || nItemBaseType == BASE_ITEM_BRACER
            || nItemBaseType == BASE_ITEM_CLOAK
            || nItemBaseType == BASE_ITEM_GLOVES);
}

// Starting from the specified item position, return the first
// item that matches one of the three base types. 
// If nBaseType1 is passed in as invalid, NO TYPE CHECKING WILL BE DONE.
// nBaseType1 may also be passed in as a special custom type:
// TREASURE_BASE_TYPE_WEAPON (for any weapon type)
// TREASURE_BASE_TYPE_WEAPON_NOAMMO (for any weapon but ammunition)
// TREASURE_BASE_TYPE_WEAPON_RANGED (for any ranged weapon)
// TREASURE_BASE_TYPE_WEAPON_MELEE (for any melee weapon)
// TREASURE_BASE_TYPE_ARMOR (for armor, shields)
// TREASURE_BASE_TYPE_CLOTHING (for belts, boots, bracers, 
//                              cloaks, helms, gloves)
object SCTreasureGetSpecificBaseTypeItem(object oBaseCont,  int nItemNum, int nBaseType1=BASE_ITEM_INVALID, int nBaseType2=BASE_ITEM_INVALID, int nBaseType3=BASE_ITEM_INVALID)
{
    if (!GetIsObjectValid(oBaseCont)) {return OBJECT_INVALID;}

    // initialize the container -- this will automatically
    // only happen once.
    SCTreasureInitContainer(oBaseCont);

    int nRollOverNum = SCGetNumItemsInBaseContainer(oBaseCont);
    
    // If there are no items in the container, no chance of finding a matching one!
    if (nRollOverNum == 0) return OBJECT_INVALID;
    
    int i;
    string sVar;
    int nItemBaseType;
    int nLooped = 0;
    for (i=nItemNum; i != nItemNum || !nLooped ; i++) {
        
        // The base type of each item is stored on the container itself
        sVar = sBaseTypeVarname + IntToString(i);
        nItemBaseType = GetLocalInt(oBaseCont, sVar);

        // Check to see if the type matches our desired type.
        if (
            // Check for a weapon
            (nBaseType1 == TREASURE_BASE_TYPE_WEAPON 
             && 
             CSLGetIsAWeapon(nItemBaseType))
            ||
            // non-ammo weapon
            (nBaseType1 == TREASURE_BASE_TYPE_WEAPON_NOAMMO 
             && 
             SCGetIsWeaponNoammo(nItemBaseType))
            ||
            // ranged weapon
            (nBaseType1 == TREASURE_BASE_TYPE_WEAPON_RANGED
             && 
             SCGetIsRangedWeapon(nItemBaseType))
            ||
            // melee weapon
            (nBaseType1 == TREASURE_BASE_TYPE_WEAPON_MELEE
             && 
             CSLGetIsMeleeWeapon(nItemBaseType))
            ||
            // armor
            (nBaseType1 == TREASURE_BASE_TYPE_ARMOR
             && 
             SCGetIsArmor(nItemBaseType))
            ||
            // clothing
            (nBaseType1 == TREASURE_BASE_TYPE_CLOTHING
             && 
             SCGetIsClothing(nItemBaseType))
            ||
            // other specific item type
            ( SCGetIsBaseType(nItemBaseType,
                                nBaseType1,
                                nBaseType2,
                                nBaseType3))
            ) // end of if statement
        {
            // we found a matching item -- return it
            return SCGetTreasureItem(oBaseCont, i);
        }

        // Handle the wrap-around case
        if ( (i+1) == nRollOverNum ) {
            // set i back to 0
            i = -1;
            nLooped = 1;
        }
    }
    
    // No matching item was found -- return null 
    return OBJECT_INVALID;
}

// Test if treasure has been generated in the given object
int SCGetIsTreasureGenerated(object oCont)
{
    return GetLocalInt(oCont, sTreasureGeneratedVarname);
}

// Set whether treasure has been generated
void SCSetIsTreasureGenerated(object oCont, int bGenerated=TRUE)
{
    SetLocalInt(oCont, sTreasureGeneratedVarname, bGenerated);
}


// Create gold treasure in the specified container.
void SCCreateGoldTreasure(int nTreasureType,  object oAdventurer,  object oCont=OBJECT_SELF)
{
    // Just use the default generation scripts
    SCCreateGold(oCont, oAdventurer, nTreasureType);
}



// Create treasure of the appropriate treasure level and matching one  
// of up to three different base types in the specified container. 
//
// Possible values for nTreasureType:
//     TREASURE_TYPE_LOW    
//     TREASURE_TYPE_MED    
//     TREASURE_TYPE_HIGH   
//     TREASURE_TYPE_UNIQUE 
//
// Possible values for nBaseType1/2/3: any BASE_ITEM_* constant.
// Can also use these special values:
//  TREASURE_BASE_TYPE_WEAPON (for any weapon type)
//  TREASURE_BASE_TYPE_WEAPON_NOAMMO (for any weapon but ammunition)
//  TREASURE_BASE_TYPE_WEAPON_RANGED (for any ranged weapon)
//  TREASURE_BASE_TYPE_WEAPON_MELEE (for any melee weapon)
//  TREASURE_BASE_TYPE_ARMOR (for armor, shields)
//  TREASURE_BASE_TYPE_CLOTHING (for belts, boots, bracers, 
//                              cloaks, helms, gloves)
// 
void SCCreateSpecificBaseTypeTreasure(int nTreasureType,  object oAdventurer,   object oCont, int nBaseType1=BASE_ITEM_INVALID,  int nBaseType2=BASE_ITEM_INVALID, int nBaseType3=BASE_ITEM_INVALID)
{
    // Prevent duplicate treasure generation
    if (SCGetIsTreasureGenerated(oCont)) {return;}
    SCSetIsTreasureGenerated(oCont);

    // Locate the base container
    object oBaseCont = SCTreasureGetNearestBaseContainer(nTreasureType, 
                                                   oCont);

    // Make sure we have a valid base container
    if (!GetIsObjectValid(oBaseCont)) {
        // if not, generate treasure using default method 
        if (nBaseType1 == BASE_ITEM_BOOK 
            || nBaseType1 == BASE_ITEM_SPELLSCROLL) 
        {
            // Make book treasure
            GenerateBookTreasure(oAdventurer, oCont);
        } else {
            // Generate default treasure
            SCTreasureCreateDefaultTreasure(nTreasureType, oAdventurer, oCont);
        }
        return;
    }

    // Get the number of available items
    int nItemsInBaseCont = SCGetNumItemsInBaseContainer(oBaseCont);

    // Special case: unique treasure items
    if (nTreasureType == TREASURE_TYPE_UNIQUE) {
        // only give one item and only give it once
        int nRandom = Random(nItemsInBaseCont);

        object oItem;
        if (nBaseType1 == BASE_ITEM_INVALID) {
            // we're not checking base types
            oItem = SCGetTreasureItem(oBaseCont, nRandom);
        } else {
            oItem = SCTreasureGetSpecificBaseTypeItem(oBaseCont, 
                                                        nRandom,
                                                        nBaseType1,
                                                        nBaseType2,
                                                        nBaseType3);
        }

        if (!GetIsObjectValid(oItem)) {
            SCTreasureCreateDefaultTreasure(nTreasureType, oAdventurer, oCont);
        } else {

            // Copy the item
//            CreateItemOnObject(GetResRef(oItem), oCont);
            // * do an actual copy BK Feb 2003. Less chance of resref errors
            CopyObject(oItem, GetLocation(oItem), oCont);
            // Destroy the original
            DestroyObject(oItem);
        }

        return;
    }

    // Otherwise, we generate 1-3 items, possibly convert some 
    // to gold. 
    int nItems = SCTreasureRandomNumItems();
    int nItemsCreated = 0;
    object oItem = OBJECT_INVALID;

    // Keep track of items handed out to avoid dupes
    object oItem1 = OBJECT_INVALID;
    object oItem2 = OBJECT_INVALID;

    // Random number -- position of item to hand out
    int nRandom = 0;

    while (nItemsCreated < nItems) {
        nItemsCreated++;
        if (nBaseType1 == BASE_ITEM_INVALID &&  SCTreasureIsItemGold() )
        {
            SCCreateGoldTreasure(nTreasureType, oAdventurer, oCont);
        }
        else
        {
            nRandom = Random(nItemsInBaseCont);

            if (nBaseType1 == BASE_ITEM_INVALID)
            {
                // we're not checking base types
                oItem = SCGetTreasureItem(oBaseCont, nRandom);
            }
            else
            {
                oItem = SCTreasureGetSpecificBaseTypeItem(oBaseCont, 
                                                            nRandom,
                                                            nBaseType1,
                                                            nBaseType2,
                                                            nBaseType3);
            }

            if (!GetIsObjectValid(oItem))
            {
                // Ugh, no matching item found! 
                // Bad module designer, no cookie.
                SCTreasureCreateDefaultTreasure(nTreasureType, oAdventurer, oCont);
            }
            else if ( nItemsCreated > 1 && 
                        (GetTag(oItem) == GetTag(oItem1) || GetTag(oItem) == GetTag(oItem2)) )
            {
                // Ugh, duplicate item. Make gold instead.
                SCCreateGoldTreasure(nTreasureType, oAdventurer, oCont);
            }
            else
            {
                // Make the item
                CopyItem(oItem, oCont);
                if (nItemsCreated == 1) {
                    oItem1 = oItem;
                } else {
                    // if this is the third item, it doesn't matter
                    // anyway, so we might as well save the conditional.
                    oItem2 = oItem;
                }
            }
        }
    }
}

// Create random treasure items of the appropriate type
// in the specified container. Should be called
// by a script on a treasure container. 
// 
// Possible values for nTreasureType:
//     TREASURE_TYPE_LOW    
//     TREASURE_TYPE_MED    
//     TREASURE_TYPE_HIGH   
//     TREASURE_TYPE_UNIQUE 
void SCCreateTreasure(int nTreasureType, object oAdventurer, object oCont=OBJECT_SELF)
{
    // To avoid code duplication, this actually just uses the specific 
    // version and passes an invalid item type
    SCCreateSpecificBaseTypeTreasure(nTreasureType, oAdventurer, oCont);
}






// Create treasure on an NPC.
// This function will typically be called from within the
// NPC's OnSpawn handler. 
// Note that this defaults to TREASURE_TYPE_MONSTER, which uses
// the monster-specific treasure chests and falls back to low-
// level treasure if none exist. 
void SCGenerateNPCTreasure(int nTreasureType=5, object oNPC=OBJECT_SELF)
{
    // Locate the base container
    object oBaseCont = SCTreasureGetNearestBaseContainer(nTreasureType, 
                                                   oNPC);

    // Make sure we have a valid base container
    if (!GetIsObjectValid(oBaseCont)) {
        // if not, generate treasure using default method from
        // nw_o2_coninclude.
        if (nTreasureType == TREASURE_TYPE_MONSTER) 
            SCGenerateNPCTreasure(TREASURE_TYPE_LOW, oNPC);
        else
            SCGenerateNPCTreasure(nTreasureType, oNPC);
        return;
    }

    // Now we determine whether we put treasure on the NPC
    int nRacialType = GetRacialType(oNPC);
    switch (nRacialType) {
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_VERMIN:
        // No treasure, sorry.
        return;
    }

    if (nTreasureType == TREASURE_TYPE_MONSTER) {

        if (d100() < BK_CHANCE_OF_N0_MONSTERTREASURE) {
            return;
        }
    }

    // Otherwise, generate as usual
    SCCreateTreasure(nTreasureType, oNPC, oNPC);
}



/**********************************************************************
 * Boring type-checking functions. 
 **********************************************************************/









// Check if the deck has been used before by this creature
int GetHasUsedDeck(object oCaster)
{
	return GetLocalInt(oCaster, "X0_DECK_USED");
}

// Mark that the deck has been used by this creature
void SetHasUsedDeck(object oCaster)
{
	SetLocalInt(oCaster, "X0_DECK_USED", TRUE);
}

// Get the number of draws remaining
int GetNumberDeckDraws(object oCaster)
{
	return GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");
}

// Set the number of draws remaining
void SetNumberDeckDraws(object oCaster, int nDraws)
{
	SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nDraws);
}





// Get a special deck-specific area if it exists and is available.
// This will start by checking for an area with just the given area
// tag. If that doesn't exist or is taken, it will start looking
// for areas tagged sAreaTag + number, until it finds one that is available.
// X0_DECK_DONJON1, X0_DECK_DONJON2, etc
// Returns OBJECT_INVALID if no area found.
object GetSpecialAreaForDeck(string sAreaTag)
{
	object oArea = GetObjectByTag(sAreaTag);
	if (GetIsObjectValid(oArea) && !GetLocalInt(oArea, "X0_DECK_USED")) {
			SetLocalInt(oArea, "X0_DECK_USED", TRUE);
			return oArea;
	}

	// We didn't find one with the base tag, so start tacking on
	// numbers.
	int nNth = 1;
	oArea = GetObjectByTag(sAreaTag + IntToString(nNth));
	while (GetIsObjectValid(oArea) && GetLocalInt(oArea, "X0_DECK_USED")) {
			nNth++;
			oArea = GetObjectByTag(sAreaTag + IntToString(nNth));
	}

	if (GetIsObjectValid(oArea))
			SetLocalInt(oArea, "X0_DECK_USED", TRUE);

	// Valid or not, return it
	return oArea;
}


// Get a special area and transport the caster (with
// associates but without party members) to the
// X0_DECK_START waypoint inside it.
//
// Returns TRUE on success, FALSE otherwise.
int DoSpecialAreaDeckCard(object oCaster, string sAreaTag, int nTurn=0)
{
	object oArea = GetSpecialAreaForDeck(sAreaTag);
	if (!GetIsObjectValid(oArea)) return FALSE;

	// We have an area, find the X0_DECK_START waypoint inside it
	object oWay;
	object oTmp = GetFirstObjectInArea(oArea);
	if (GetTag(oTmp) == "X0_DECK_START")
	oWay = oTmp;
	else
	oWay = GetNearestObjectByTag("X0_DECK_START", oTmp);

	if (!GetIsObjectValid(oWay)) return FALSE;
	DelayCommand(SC_DECK_DELAY * nTurn, CSLTransportToWaypoint(oCaster, oWay));
	return TRUE;
}


// The Fool card (negative)
// Lose 10,000 XP and get 2 extra cards.
int DoFoolDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_FOOL_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_FOOL_CARD", TRUE);

	int nXP = GetXP(oCaster);
	DelayCommand(SC_DECK_DELAY * nTurn, SetXP(oCaster, nXP-10000));
	int nCards = GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");
	string sMess = GetStringByStrRef(40562);
	DelayCommand(SC_DECK_DELAY * nTurn, SendMessageToPC(oCaster, sMess));
	SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nCards+2);
	return TRUE;
}

// The Donjon card (negative)
// If a donjon area is available, the caster and associates are transported
// there.
// The area should be tagged X0_DECK_DONJON1.
// The starting location should be tagged X0_DECK_START.
// See the Gauntlet area in module 3 of XP1 as an example.
// (This is a good model to use if you want to create a "Keep" or
// "Void" type card for your own module.)
int DoDonjonDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_DONJON_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_DONJON_CARD", TRUE);

	int nSucc = DoSpecialAreaDeckCard(oCaster, "X0_DECK_DONJON", nTurn);
	if (nSucc) {
			// don't get to draw any more cards!
			SetNumberDeckDraws(oCaster, 0);
			string sMessage = GetStringByStrRef(9247);
			//string sMessage = "The remaining cards vanish from your hands!";
			SendMessageToPC(oCaster, sMessage);
	}


	return nSucc;
}

// The Traitor card (negative)
// Change to diametrically-opposed alignment instantly.
int DoTraitorDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_TRAITOR_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_TRAITOR_CARD", TRUE);

	int nGoodEvil = GetAlignmentGoodEvil(oCaster);
	int nLawChaos = GetAlignmentLawChaos(oCaster);
	if (nGoodEvil == ALIGNMENT_GOOD
			|| (nGoodEvil == ALIGNMENT_NEUTRAL && Random(2)) ) {
			// make evil
			DelayCommand(SC_DECK_DELAY * nTurn,
						AdjustAlignment(oCaster, ALIGNMENT_EVIL, 100));
	} else {
			// make good
			DelayCommand(SC_DECK_DELAY * nTurn,
						AdjustAlignment(oCaster, ALIGNMENT_GOOD, 100));
	}

	if (nLawChaos == ALIGNMENT_LAWFUL
			|| (nLawChaos == ALIGNMENT_NEUTRAL && Random(2)) ) {
			// make chaotic
			DelayCommand(SC_DECK_DELAY * nTurn,
						AdjustAlignment(oCaster, ALIGNMENT_CHAOTIC, 100));
	} else {
			// make lawful
			DelayCommand(SC_DECK_DELAY * nTurn,
						AdjustAlignment(oCaster, ALIGNMENT_LAWFUL, 100));
	}

	return TRUE;
}

// The Knave card (negative)
// All non-plot possessions not currently equipped are destroyed.
int DoKnaveDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_KNAVE_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_KNAVE_CARD", TRUE);

	object oItem = GetFirstItemInInventory(oCaster);
	while (GetIsObjectValid(oItem)) {
			if (!GetPlotFlag(oItem)) {
				DestroyObject(oItem, SC_DECK_DELAY * nTurn);
			}
			oItem = GetNextItemInInventory(oCaster);
	}
	return TRUE;
}

// Private function used to apply the initial plague effect
void DoPlagueDeckCardEffect(object oCaster)
{
	effect eImp = EffectVisualEffect(VFX_IMP_DISEASE_S);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,
								eImp,
								oCaster);

	// Apply damage
	int nDam = d10() + 10;
	if (nDam > GetCurrentHitPoints(oCaster)) {
			nDam = GetCurrentHitPoints(oCaster) - 1;
	}
	effect eDam = EffectDamage(nDam,
						DAMAGE_TYPE_MAGICAL,
						DAMAGE_POWER_PLUS_FIVE);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT,
								eDam,
								oCaster);
}

// The Plague card (negative)
// Permanent disease effect applied for duration of the module.
int DoPlagueDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_PLAGUE_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_PLAGUE_CARD", TRUE);

	// Create the plague object, which will keep applying the
	// nasty plague permanently, even after a restoration spell,
	// muahaha ha ha.... cough, cough.
	object oPlague = CreateObject(OBJECT_TYPE_PLACEABLE,
						"x0_deck_plague",
						GetLocation(oCaster));

	if (!GetIsObjectValid(oPlague)) return FALSE;

	SetLocalObject(oPlague, "X0_DECK_TARGET", oCaster);

	DelayCommand(SC_DECK_DELAY * nTurn,
						AssignCommand(oPlague, DoPlagueDeckCardEffect(oCaster)));

	return TRUE;
}

// Private function to run the actual henchman change after a delay
void DoLookingGlassDeckCardEffect(object oCaster, object oHench)
{
	effect eReplace = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eReplace, oHench);

	CSLFireHenchman(oCaster, oHench);
	ChangeToStandardFaction(oHench, STANDARD_FACTION_HOSTILE);
	DelayCommand(1.0f, CSLDetermineCombatRound( oHench, oCaster ) );
	
	//AssignCommand(oHench, SCAIDetermineCombatRound(oCaster)));
}

// The Looking Glass card (negative)
// Caster's henchman is turned hostile.
int DoLookingGlassDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_LOOKGLASS_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_LOOKGLASS_CARD", TRUE);

	object oHench = GetHenchman(oCaster);
	if (!GetIsObjectValid(oHench) || GetArea(oHench) != GetArea(oCaster))
	return FALSE;

	DelayCommand(SC_DECK_DELAY * nTurn,
						DoLookingGlassDeckCardEffect(oCaster, oHench));
	return TRUE;
}

// Private function to run the actual wyrm summon after a delay
void DoWyrmDeckCardEffect(object oCaster, string sResRef)
{
	object oDrag = CreateObject(OBJECT_TYPE_CREATURE,
					sResRef,
					GetLocation(oCaster),
					TRUE);
	SetIsTemporaryEnemy(oCaster, oDrag);
	//DelayCommand(1.0, AssignCommand(oDrag, SCAIDetermineCombatRound(oCaster)));
	DelayCommand(1.0, CSLDetermineCombatRound( oDrag, oCaster ) );
}

// The Wyrm card (negative)
// A dragon is lured to the caster and attacks
int DoWyrmDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_WYRM_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_WYRM_CARD", TRUE);

	int nGoodEvil = GetAlignmentGoodEvil(oCaster);
	string sResRef;
	if (nGoodEvil == ALIGNMENT_EVIL) {
			sResRef = "nw_drgsilv001";
			if (Random(2))
				sResRef = "nw_drggold001";
	} else {
			sResRef = "nw_drgblue001";
			if (Random(2))
				sResRef = "nw_drgred001";
	}

	DelayCommand(SC_DECK_DELAY * nTurn,
						DoWyrmDeckCardEffect(oCaster, sResRef));

	return TRUE;
}


// ------- POSITIVE CARDS

// The Joker card (positive)
// Gain 10,000 XP and get 2 extra cards.
int DoJokerDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_JOKER_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_JOKER_CARD", TRUE);

	DelayCommand(SC_DECK_DELAY * nTurn, GiveXPToCreature(oCaster, 10000));
	int nCards = GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");

			string sMess = GetStringByStrRef(40562);
	SendMessageToPC(oCaster, sMess);

	SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nCards+2);
	return TRUE;
}

// The Hoard card (positive)
// Gain 50,000 gold instantly
int DoHoardDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_HOARD_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_HOARD_CARD", TRUE);

	DelayCommand(SC_DECK_DELAY * nTurn, GiveGoldToCreature(oCaster, 50000));
	return TRUE;
}

// The Oracle card (positive)
// Gain permanent premonition effect for duration of the module
int DoOracleDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_ORACLE_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_ORACLE_CARD", TRUE);

	// Create the oracle object, which will keep applying the
	// oracle effect permanently, even after resting.
	object oOracle = CreateObject(OBJECT_TYPE_PLACEABLE,
											"x0_deck_oracle",
											GetLocation(oCaster));

	if (!GetIsObjectValid(oOracle))
			return FALSE;

	SetLocalObject(oOracle, "X0_DECK_TARGET", oCaster);

	effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, 0);
	effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

	//Link the visual and the damage reduction effect
	effect eLink = EffectLinkEffects(ePrem, eVis);

	DelayCommand(SC_DECK_DELAY * nTurn,
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster));
	return TRUE;
}

// Private function to create the avatar item on the caster
void DoAvatarDeckCardEffect(object oCaster)
{
	CreateItemOnObject("x0_deck_avatar", oCaster);
}

// Private function to do the avatar transformation effect
void DoAvatarDeckCardTransform(object oCaster)
{
	int nGoodEvil = GetAlignmentGoodEvil(oCaster);
	int nGender = GetGender(oCaster);

	effect ePoly;
	int nVFX;

	// Temporary vars here to avoid magic numbers
	// replace with POLYMORPH_TYPE constants when added to nwscript
	if (nGoodEvil == ALIGNMENT_GOOD) {
			// transform into celestial avenger
			nVFX = VFX_IMP_MAGIC_PROTECTION;
			ePoly = EffectPolymorph(POLYMORPH_TYPE_CELESTIAL_AVENGER);
	} else if (nGoodEvil == ALIGNMENT_EVIL) {
			// transform into vrock or succubus
			nVFX = VFX_IMP_REDUCE_ABILITY_SCORE;
			if (nGender == GENDER_MALE)
				ePoly = EffectPolymorph(POLYMORPH_TYPE_VROCK);
			else
				ePoly = EffectPolymorph(POLYMORPH_TYPE_SUCCUBUS);
	} else {
			// transform into fire or water elemental
			if (nGender == GENDER_MALE) {
				ePoly = EffectPolymorph(POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL);
				nVFX = VFX_IMP_FLAME_M;
			} else {
				ePoly = EffectPolymorph(POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL);
				nVFX = VFX_IMP_MAGIC_PROTECTION;
			}
	}

	effect eVis = EffectVisualEffect(nVFX);

	SetCustomToken(SC_DECK_TOKEN_NAME, GetName(oCaster));
	FloatingTextStrRefOnCreature(9246, oCaster);
	//FloatingTextStringOnCreature(GetName(oCaster)
	//                             + " transforms into an avatar.",
	//                             oCaster);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oCaster);
}

// The Avatar card (positive)
// Caster is transformed into an avatar of their alignment.
int DoAvatarDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_AVATAR_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_AVATAR_CARD", TRUE);

	// Create the avatar object, which will allow the user
	// to become the avatar at will.
	DelayCommand(SC_DECK_DELAY * nTurn, DoAvatarDeckCardEffect(oCaster));
	DelayCommand(SC_DECK_DELAY * nTurn, DoAvatarDeckCardTransform(oCaster));

	return TRUE;
}

// The Fountain card (positive)
// All of caster's items are recharged and all stacked items are
// filled up to the maximum possible number.
int DoFountainDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_FOUNTAIN_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_FOUNTAIN_CARD", TRUE);

	object oItem = GetFirstItemInInventory(oCaster);
	while (GetIsObjectValid(oItem)) {
			if (!GetPlotFlag(oItem)) {
				// Set maximum charges & stack
				DelayCommand(SC_DECK_DELAY * nTurn, SetItemCharges(oItem, 50));
				DelayCommand(SC_DECK_DELAY * nTurn, SetItemStackSize(oItem, 99));
			}
			oItem = GetNextItemInInventory(oCaster);
	}
	return TRUE;
}

// Private function used to create the hatchling-summoning object
void DoHatchlingDeckCardEffect(object oCaster)
{
	object oHatchObject = CreateObject(OBJECT_TYPE_PLACEABLE,
													"x0_deck_hatch",
													GetLocation(oCaster));

	SetLocalObject(oHatchObject, "X0_DECK_TARGET", oCaster);
	SetLocalObject(oCaster, "X0_DECK_HATCH_OBJECT", oHatchObject);
}

// Private function used to record the hatchling object
void DoHatchlingDeckCardRecord(string sTag)
{
	object oHatch = GetNearestObjectByTag(sTag);
	SetLocalObject(OBJECT_SELF, "X0_DECK_HATCH", oHatch);

	//DBG_msg("Hatchling summoned: " + GetTag(oHatch));
}

// Private function -- this is assigned to the caster as an action
// to cause them to summon the hatchling.
void DoHatchlingDeckCardSummon()
{
	// Summon the hatchling
	string sResRef;
	int nGoodEvil = GetAlignmentGoodEvil(OBJECT_SELF);
	if (nGoodEvil == ALIGNMENT_EVIL) {
			sResRef = "X0_HATCH_EVIL";
	} else {
			sResRef = "X0_HATCH_GOOD";
	}

	//DBG_msg("Attempting to summon hatchling: " + sResRef);

	effect eSummon = EffectSummonCreature(sResRef,
														VFX_IMP_DIVINE_STRIKE_HOLY,
														0.5);

	HkApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
									eSummon,
									CSLGetOppositeLocation(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	DelayCommand(3.0, DoHatchlingDeckCardRecord(sResRef));
}


// The Hatchling card (positive)
// A wyrmling of alignment-appropriate color appears and follows
// the caster as a summoned creature until damaged, at which point
// it transforms into an adult dragon and fights on the caster's behalf
// until all enemies are slain, then vanishes.
int DoHatchlingDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_HATCHLING_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_HATCHLING_CARD", TRUE);

	// Summon the hatchling
	DelayCommand(SC_DECK_DELAY * nTurn,
						AssignCommand(oCaster,
										DoHatchlingDeckCardSummon()));

	// Create the hatchling object, which will resummon
	// the hatchling.
	DelayCommand(SC_DECK_DELAY * nTurn, DoHatchlingDeckCardEffect(oCaster));

	return TRUE;
}

// The Bequest card (positive)
// Gain a major unique magical item (this will respect the
// XP1 treasure system if it is used).
int DoBequestDeckCard(object oCaster, int nTurn=0)
{
	if (GetLocalInt(oCaster, "X0_DECK_BEQUEST_CARD")) return FALSE;
	SetLocalInt(oCaster, "X0_DECK_BEQUEST_CARD", TRUE);

	DelayCommand(SC_DECK_DELAY * nTurn,
			SCCreateTreasure(TREASURE_TYPE_UNIQUE, oCaster, oCaster));
	return TRUE;
}


// Do a positive card draw
void DoDeckDrawPositive(object oCaster, int nTurn=0)
{
	int bDone = FALSE;
	int nTriesMax = 10; // Just as a failsafe
	int nTries = 0;
	string sCardName = "";

	// If a card draw succeeds, bDone will be set to TRUE
	// and this loop will exit.
	while (!bDone && nTries < nTriesMax) {
			nTries++;
			int nCard = Random(7);

			//DBG_msg("nCard positive: " + IntToString(nCard));

			// For each card, we set the custom token 1 to
			// be the name we want to assign to the card.
			switch (nCard) {
			case 0: bDone = DoJokerDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9255); // "Mentor";
					break;
			case 1: bDone = DoHoardDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9258); // "Hoard";
					break;
			case 2: bDone = DoOracleDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9261); //"Oracle";
					break;
			case 3: bDone = DoAvatarDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9248); //"Avatar";
					break;
			case 4: bDone = DoFountainDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9257); //"Fountain";
					break;
			case 5: bDone = DoHatchlingDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9254); //"Hatchling";
					break;
			case 6: bDone = DoBequestDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9249); //"Bequest";
					break;
			}
	}

	// Set the caster name and card name as tokens
	SetCustomToken(SC_DECK_TOKEN_NAME, GetName(oCaster));
	DelayCommand(SC_DECK_DELAY*nTurn - 3.0, SetCustomToken(SC_DECK_TOKEN_CARD_NAME, sCardName));

	// Apply the visual effect
	int nDeckEffect = 322;
	effect eDraw = EffectVisualEffect(nDeckEffect);
	DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
						HkApplyEffectToObject(DURATION_TYPE_INSTANT,
												eDraw,
												oCaster));


	if (!bDone)
	{
			// ugh, send error message
			DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
							FloatingTextStrRefOnCreature(9239, oCaster));
			return;
	}

	// Print out the message
	DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
						FloatingTextStrRefOnCreature(9238, oCaster));
}

// Do a negative card draw
void DoDeckDrawNegative(object oCaster, int nTurn=0)
{
	int bDone = FALSE;
	int nTriesMax = 10; // Just as a failsafe
	int nTries = 0;
	string sCardName = "";

	// If a card draw succeeds, bDone will be set to TRUE
	// and this loop will exit.
	while (!bDone && nTries < nTriesMax) {
			nTries++;
			int nCard = Random(7);
			//DBG_msg("nCard negative: " + IntToString(nCard));
			switch (nCard) {
			case 0: bDone = DoFoolDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9256); //"Prince of Lies";
					break;
			case 1: bDone = DoDonjonDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9250); //"Gauntlet";
					break;
			case 2: bDone = DoTraitorDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9263); //"Traitor";
					break;
			case 3: bDone = DoKnaveDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9259); //"Knave";
					break;
			case 4: bDone = DoPlagueDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9262); //"Plague";
					break;
			case 5: bDone = DoLookingGlassDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9260); //"Looking Glass";
					break;
			case 6: bDone = DoWyrmDeckCard(oCaster, nTurn);
					sCardName = GetStringByStrRef(9264); //"Wyrm";
					break;
			}
	}

	// Set the caster name and card name as tokens
	SetCustomToken(SC_DECK_TOKEN_NAME, GetName(oCaster));
	DelayCommand(SC_DECK_DELAY*nTurn - 3.0, SetCustomToken(SC_DECK_TOKEN_CARD_NAME, sCardName));


	// Apply the visual effect
	int nDeckEffect = 322;
	effect eDraw = EffectVisualEffect(nDeckEffect);
	DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
						HkApplyEffectToObject(DURATION_TYPE_INSTANT,
												eDraw,
												oCaster));


	if (!bDone) {
			// ugh, send error message
			DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
							FloatingTextStrRefOnCreature(9239, oCaster));
			return;
	}

	// Print out the message
	DelayCommand(SC_DECK_DELAY * nTurn - 2.0,
						FloatingTextStrRefOnCreature(9238, oCaster));
}

	
/* void main() {} /* */