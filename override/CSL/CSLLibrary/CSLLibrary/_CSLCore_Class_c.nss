/** @file
* @brief Class related constants
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

// Class Progressions
const int SC_PROG_XXX = -1; // Don't know progression yet
const int SC_PROG_NONE = 0;
const int SC_PROG_2DA = 1;
const int SC_PROG_FULL = 2;
const int SC_PROG_EVEN = 3;
const int SC_PROG_ODD  = 4;
const int SC_PROG_SKIPFIRST = 5; // Use this for the classes that get every level but first
const int SC_PROG_SACRED = 6; // Sacred Skips fourth and 8th, need to determine if more than that
const int SC_PROG_FORESTMASTER = 7; // forestmaster is same as sacred fist progression
const int SC_PROG_SWIFTBLADE = 8; // swiftblade skips 1, 4, 7, 10
const int SC_PROG_HOSPITALER = 9; // hospitaler skips 1, 5 and 9
const int SC_PROG_SHDSTALKER = 10; // shdstalker 1, 2, 3, 5, 6, 7, 8, 10  

const int SC_CLASS_BASE = 1;
const int SC_CLASS_PRC = 2;
const int SC_CLASS_KAEDRIN = 3;
const int SC_CLASS_DISABLED = -2;
const int SC_CLASS_NPC = -1;

//////////////////////////
//////// CLASSES /////////
//////////////////////////


// special cases for determining clases
const int CLASS_TYPE_NONE = 255;
const int CLASS_TYPE_RACIAL = -256; // use this soas to get the total hit dice involved instead of the actual class
const int CLASS_TYPE_BESTDIVINE = -257;
const int CLASS_TYPE_BESTARCANE = -258;
const int CLASS_TYPE_BESTELDRITCH = -259;
const int CLASS_TYPE_BESTPSIONIC = -260;
const int CLASS_TYPE_BESTCASTER = -261;



/////// Barbarian /////// 
// const int CLASS_TYPE_BARBARIAN = 0


/////// Bard /////// 
// const int CLASS_TYPE_BARD = 1
// Caster
const int SC_CLASS_PROG_BARD = SC_PROG_FULL;

/////// Cleric /////// 
// const int CLASS_TYPE_CLERIC = 2
// Caster
const int SC_CLASS_PROG_CLERIC = SC_PROG_FULL;

/////// Druid /////// 
// const int CLASS_TYPE_DRUID = 3
// Caster
const int SC_CLASS_PROG_DRUID = SC_PROG_FULL;

/////// Fighter /////// 
// const int CLASS_TYPE_FIGHTER = 4


/////// Monk /////// 
// const int CLASS_TYPE_MONK = 5


/////// Paladin /////// 
// const int CLASS_TYPE_PALADIN = 6
// Caster
const int SC_CLASS_PROG_PALADIN = SC_PROG_FULL;

/////// Ranger /////// 
// const int CLASS_TYPE_RANGER = 7
// Caster
const int SC_CLASS_PROG_RANGER = SC_PROG_FULL;

/////// Rogue /////// 
// const int CLASS_TYPE_ROGUE = 8


/////// Sorcerer /////// 
// const int CLASS_TYPE_SORCERER = 9
// Caster
const int SC_CLASS_PROG_SORCERER = SC_PROG_FULL;

/////// Wizard /////// 
// const int CLASS_TYPE_WIZARD = 10
// Caster
const int SC_CLASS_PROG_WIZARD = SC_PROG_FULL;

/////// Shadowdancer /////// 
// const int CLASS_TYPE_SHADOWDANCER = 27


/////// Harper /////// 
// const int CLASS_TYPE_HARPER = 28
const int SC_CLASS_PROG_HARPER = SC_PROG_SKIPFIRST;

const int FEAT_HARPER_SPELLCASTING_CLERIC = 1576;
const int FEAT_HARPER_SPELLCASTING_DRUID = 1577;
const int FEAT_HARPER_SPELLCASTING_SORCERER = 1578;
const int FEAT_HARPER_SPELLCASTING_WIZARD = 1579;
const int FEAT_HARPER_SPELLCASTING_WARLOCK = 1580;
const int FEAT_HARPER_SPELLCASTING_BARD = 1581;
const int FEAT_HARPER_SPELLCASTING_PALADIN = 1582;
const int FEAT_HARPER_SPELLCASTING_RANGER = 1583;
const int FEAT_HARPER_SPELLCASTING_SPIRIT_SHAMAN = 2013;
const int FEAT_HARPER_SPELLCASTING_FAVORED_SOUL = 2078;

/////// Arcane_Archer /////// 
// const int CLASS_TYPE_ARCANE_ARCHER = 29


/////// Assassin /////// 
// const int CLASS_TYPE_ASSASSIN = 30
const int SC_CLASS_PROG_ASSASSIN = SC_PROG_FULL;
// Assassin Spell Book
const int SPELL_ASN_GhostlyVisage = 1698;
const int SPELL_ASN_Sleep = 1699;
const int SPELL_ASN_True_Strike = 1700;
const int SPELL_ASN_Spellbook_2 = 1701;
const int SPELL_ASN_Cats_Grace = 1702;
const int SPELL_ASN_Foxs_Cunning = 1703;
const int SPELL_ASN_Darkness = 1704;
const int SPELL_ASN_Spellbook_3 = 1705;
const int SPELL_ASN_Invisibility = 1706;
const int SPELL_ASN_Deep_Slumber = 1707;
const int SPELL_ASN_False_Life = 1708;
const int SPELL_ASN_Magic_Circle_against_Good = 1709;
const int SPELL_ASN_Spellbook_4 = 1710;
const int SPELL_ASN_ImprovedInvisibility = 1711;
const int SPELL_ASN_Freedom_of_Movement = 1712;
const int SPELL_ASN_Poison = 1713;
const int SPELL_ASN_Clairaudience_and_Clairvoyance = 1714;


/////// Blackguard /////// 
// const int CLASS_TYPE_BLACKGUARD = 31
const int SC_CLASS_PROG_BLACKGUARD = SC_PROG_FULL;
const int FEAT_BG_BULLS_STRENGTH_1 = 3011;
const int FEAT_BG_BULLS_STRENGTH_2 = 3012;
const int FEAT_BG_BULLS_STRENGTH_3 = 3013;
const int FEAT_BG_BULLS_STRENGTH_4 = 3014;
const int FEAT_BG_BULLS_STRENGTH_5 = 3015;
const int FEAT_BG_INFLICT_SERIOUS_WOUNDS_1 = 3016;
const int FEAT_BG_INFLICT_SERIOUS_WOUNDS_2 = 3017;
const int FEAT_BG_INFLICT_SERIOUS_WOUNDS_3 = 3018;
const int FEAT_BG_INFLICT_SERIOUS_WOUNDS_4 = 3019;
const int FEAT_BG_INFLICT_SERIOUS_WOUNDS_5 = 3020;
const int FEAT_BG_CONTAGION_1 = 3021;
const int FEAT_BG_CONTAGION_2 = 3022;
const int FEAT_BG_CONTAGION_3 = 3023;
const int FEAT_BG_CONTAGION_4 = 3024;
const int FEAT_BG_MANIFEST_DEATH_1 = 3025;
const int FEAT_BG_MANIFEST_DEATH_2 = 3026;
const int FEAT_BG_MANIFEST_DEATH_3 = 3027;
// Blackguard Spell book
const int SPELL_BG_Spellbook_1 = 1715;
const int SPELL_BG_BullsStrength = 1716;
const int SPELL_BG_Magic_Weapon = 1717;
const int SPELL_BG_Doom = 1718;
const int SPELL_BG_Cure_Light_Wounds = 1719;
const int SPELL_BG_Spellbook_2 = 1720;
const int SPELL_BG_InflictSerious = 1721;
const int SPELL_BG_Darkness = 1722;
const int SPELL_BG_Cure_Moderate_Wounds = 1723;
const int SPELL_BG_Eagle_Splendor = 1724;
const int SPELL_BG_Death_Knell = 1725;
const int SPELL_BG_Spellbook_3 = 1726;
const int SPELL_BG_Contagion = 1727;
const int SPELL_BG_Cure_Serious_Wounds = 1728;
const int SPELL_BG_Protection_from_Energy = 1729;
const int SPELL_BG_Summon_Creature_III = 1730;
const int SPELL_BG_Spellbook_4 = 1731;
const int SPELL_BG_InflictCritical = 1732;
const int SPELL_BG_MANIFEST_DEATH = 1732; // @bug duplicate constant value for SPELL_BG_InflictCritical and SPELL_BG_MANIFEST_DEATH
const int SPELL_BG_Cure_Critical_Wounds = 1733;
const int SPELL_BG_Freedom_of_Movement = 1734;
const int SPELL_BG_Poison = 1735;


/////// Divine_Champion /////// 
// const int CLASS_TYPE_DIVINE_CHAMPION = 32


/////// WeaponMaster /////// 
// const int CLASS_TYPE_WEAPON_MASTER = 33


/////// Pale_Master /////// 
// const int CLASS_TYPE_PALE_MASTER = 34
const int SC_CLASS_PROG_PALEMASTER = SC_PROG_ODD;
const int FEAT_PALE_MASTER_SPELLCASTING_BARD = 1801;
const int FEAT_PALE_MASTER_SPELLCASTING_SORCERER = 1802;
const int FEAT_PALE_MASTER_SPELLCASTING_WARLOCK = 1803;
const int FEAT_PALE_MASTER_SPELLCASTING_WIZARD = 1804;


/////// Dwarven_Defender /////// 
// const int CLASS_TYPE_DWARVEN_DEFENDER = 36


/////// Dragon_Disciple /////// 
// const int CLASS_TYPE_DRAGON_DISCIPLE = 37
const int FEAT_DRAGON_DIS_BLACK = 3238;
const int FEAT_DRAGON_DIS_BLUE = 3239;
const int FEAT_DRAGON_DIS_BRASS = 3240;
const int FEAT_DRAGON_DIS_BRONZE = 3241;
const int FEAT_DRAGON_DIS_COPPER = 3242;
const int FEAT_DRAGON_DIS_GOLD = 3243;
const int FEAT_DRAGON_DIS_GREEN = 3244;
const int FEAT_DRAGON_DIS_RED = 3245;
const int FEAT_DRAGON_DIS_SILVER = 3246;
const int FEAT_DRAGON_DIS_WHITE = 3247;
const int FEAT_DRAGON_DIS_GENERAL = 3248;
const int FEAT_DRAGON_DIS_IMMUNITY = 3249;


/////// Warlock /////// 
// const int CLASS_TYPE_WARLOCK = 39
const int SC_CLASS_PROG_WARLOCK = SC_PROG_FULL;

/////// Arcane_Trickster /////// 
// const int CLASS_TYPE_ARCANETRICKSTER = 40
const int SC_CLASS_PROG_ARCANETRICKSTER = SC_PROG_FULL;
const int FEAT_ARCTRICKSTER_SPELLCASTING_BARD = 1512;
const int FEAT_ARCTRICKSTER_SPELLCASTING_SORCERER = 1513;
const int FEAT_ARCTRICKSTER_SPELLCASTING_WIZARD = 1514;
const int FEAT_ARCTRICKSTER_SPELLCASTING_WARLOCK = 1677;


/////// Frenzied_Berserker /////// 
// const int CLASS_TYPE_FRENZIEDBERSERKER = 43


/////// Sacred_Fist /////// 
// const int CLASS_TYPE_SACREDFIST = 45
const int SC_CLASS_PROG_SACREDFIST = SC_PROG_SACRED;
const int FEAT_SACREDFIST_SPELLCASTING_CLERIC = 1549;
const int FEAT_SACREDFIST_SPELLCASTING_DRUID = 1550;
const int FEAT_SACREDFIST_SPELLCASTING_PALADIN = 1551;
const int FEAT_SACREDFIST_SPELLCASTING_RANGER = 1552;
const int FEAT_SACREDFIST_SPELLCASTING_SPIRIT_SHAMAN = 2101;
const int FEAT_SACREDFIST_SPELLCASTING_FAVORED_SOUL = 2102;
const int SACREDFIST_CODE_OF_CONDUCT = 1979;
//const int FEAT_SACREDFIST_SPELLCASTING_DRUID = 2102;

/////// Shadow_Thief_of_Amn /////// 
// const int CLASS_TYPE_SHADOWTHIEFOFAMN = 46


/////// NWNine_Warder /////// 
// const int CLASS_TYPE_NW9WARDER = 47
const int SC_CLASS_PROG_NWNINE_WARDER = SC_PROG_XXX;
const int FEAT_NW9_SPELLCASTING_CLERIC = 1567;
const int FEAT_NW9_SPELLCASTING_DRUID = 1568;
const int FEAT_NW9_SPELLCASTING_SORCERER = 1569;
const int FEAT_NW9_SPELLCASTING_WIZARD = 1570;
const int FEAT_NW9_SPELLCASTING_WARLOCK = 1571;

/////// Duelist /////// 
// const int CLASS_TYPE_DUELIST = 50


/////// Warpriest /////// 
// const int CLASS_TYPE_WARPRIEST = 51
const int SC_CLASS_PROG_WARPRIEST = SC_PROG_EVEN;
const int FEAT_WARPRIEST_SPELLCASTING_CLERIC = 1808;
const int FEAT_WARPRIEST_SPELLCASTING_DRUID = 1809;
const int FEAT_WARPRIEST_SPELLCASTING_PALADIN = 1810;
const int FEAT_WARPRIEST_SPELLCASTING_RANGER = 1811;
const int FEAT_WARPRIEST_SPELLCASTING_SPIRIT_SHAMAN = 2014;
const int FEAT_WARPRIEST_SPELLCASTING_FAVORED_SOUL = 2079;

/////// Eldritch_Knight /////// 
// const int CLASS_TYPE_ELDRITCH_KNIGHT = 52
const int SC_CLASS_PROG_ELDRITCH_KNIGHT = SC_PROG_SKIPFIRST;
const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_BARD = 1820;
const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_SORCERER = 1821;
const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_WIZARD = 1822;

/////// Red_Wizard /////// 
// const int CLASS_TYPE_RED_WIZARD = 53
const int SC_CLASS_PROG_RED_WIZARD = SC_PROG_FULL;
const int FEAT_RED_WIZARD_SPELLCASTING_WIZARD = 1886;

/////// Arcane_Scholar /////// 
// const int CLASS_TYPE_ARCANE_SCHOLAR = 54
const int SC_CLASS_PROG_ARCANE_SCHOLAR = SC_PROG_FULL;
const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_BARD = 1887;
const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_SORCERER = 1888;
const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_WIZARD = 1889;

/////// Spirit_Shaman /////// 
// const int CLASS_TYPE_SPIRIT_SHAMAN = 55
// Caster
const int SC_CLASS_PROG_SPIRIT_SHAMAN = SC_PROG_FULL;

/////// Stormlord /////// 
// const int CLASS_TYPE_STORMLORD = 56
const int SC_CLASS_PROG_STORMLORD = SC_PROG_FULL;
const int FEAT_STORMLORD_SPELLCASTING_CLERIC = 2033;
const int FEAT_STORMLORD_SPELLCASTING_DRUID = 2034;
const int FEAT_STORMLORD_SPELLCASTING_PALADIN = 2035;
const int FEAT_STORMLORD_SPELLCASTING_RANGER = 2036;
const int FEAT_STORMLORD_SPELLCASTING_SPIRIT_SHAMAN = 2037;
const int FEAT_STORMLORD_SPELLCASTING_FAVORED_SOUL = 2080;


/////// Invisible_Blade /////// 
// const int CLASS_TYPE_INVISIBLE_BLADE = 57


/////// Favored_Soul /////// 
// const int CLASS_TYPE_FAVORED_SOUL = 58
// Caster
const int SC_CLASS_PROG_FAVORED_SOUL = SC_PROG_FULL;
/////// Swashbuckler /////// 
// const int CLASS_TYPE_SWASHBUCKLER = 59


/////// Doomguide /////// 
// const int CLASS_TYPE_DOOMGUIDE = 60
// Caster
const int SC_CLASS_PROG_DOOMGUIDE = SC_PROG_FULL;
const int FEAT_DOOMGUIDE_CLERIC_SPELLCASTING = 2249;
const int FEAT_DOOMGUIDE_PALADIN_SPELLCASTING = 2250;
const int FEAT_DOOMGUIDE_DRUID_SPELLCASTING = 2251;
const int FEAT_DOOMGUIDE_SPIRITSHAMAN_SPELLCASTING = 2252;
const int FEAT_DOOMGUIDE_FAV_SOUL_SPELLCASTING = 2253;
const int FEAT_DOOMGUIDE_RANGER_SPELLCASTING = 2254;

/////// HellfireWarlock /////// 
// const int CLASS_TYPE_HELLFIRE_WARLOCK = 61
const int SC_CLASS_PROG_HELLFIRE_WARLOCK = SC_PROG_FULL;

/////// Crusader /////// 
const int CLASS_TYPE_CRUSADER	=	70;

/////// Sword Sage ///////
const int CLASS_TYPE_SWORDSAGE	=	71;

/////// War Blade ///////
const int CLASS_TYPE_WARBLADE	=	72;

/////// Saint ///////
const int CLASS_TYPE_SAINT		=	73;

/////// Hospitaler /////// 
// const int CLASS_TYPE_HOSPITALER = 106
const int CLASS_HOSPITALER = 106;
const int SC_CLASS_PROG_HOSPITALER = SC_PROG_HOSPITALER; // -> 2, 3, 4, 6, 7, 8, and 10.
const int FEAT_HOSPITALER_SPELLCASTING_SPIRIT_SHAMAN = 2993;
const int FEAT_HOSPITALER_SPELLCASTING_CLERIC = 2994;
const int FEAT_HOSPITALER_SPELLCASTING_DRUID = 2995;
const int FEAT_HOSPITALER_SPELLCASTING_PALADIN = 2996;
const int FEAT_HOSPITALER_SPELLCASTING_RANGER = 2997;
const int FEAT_HOSPITALER_SPELLCASTING_FAVORED_SOUL = 2998;

/////// Warrior_of_Darkness /////// 
// const int CLASS_TYPE_WARRIOR_DARKNESS = 107
const int CLASS_WARRIOR_DARKNESS = 107;
const int FEAT_WOD_DARKLING_WEAPON = 3109;
const int FEAT_WOD_SCARRED_FLESH = 3110;
const int FEAT_WOD_REPELLANT_FLESH = 3111;

/////// Bladesinger /////// 
// const int CLASS_TYPE_BLADESINGER = 108
const int CLASS_BLADESINGER = 108;
const int SC_CLASS_PROG_BLADESINGER = SC_PROG_ODD; // ODD
const int FEAT_BLADESINGER_SPELLCASTING_BARD = 3112;
const int FEAT_BLADESINGER_SPELLCASTING_SORCERER = 3113;
const int FEAT_BLADESINGER_SPELLCASTING_WIZARD = 3114;
const int FEAT_BLADESINGER_BLADESONG_STYLE = 3115;
const int FEAT_BLADESINGER_SONG_CELERITY_1 = 3116;
const int FEAT_BLADESINGER_SONG_CELERITY_2 = 3117;
const int FEAT_BLADESINGER_SONG_FURY = 3118;
const int FEAT_ARMORED_CASTER_BLADESINGER = 3119;

/////// Stormsinger /////// 
// const int CLASS_TYPE_STORMSINGER = 109
const int CLASS_STORMSINGER = 109;
const int SC_CLASS_PROG_STORMSINGER = SC_PROG_FULL; // FULL
const int FEAT_STORMSINGER_SPELLCASTING_BARD = 3126;
const int FEAT_STORMSINGER_SPELLCASTING_SPIRIT_SHAMAN = 3120;
const int FEAT_STORMSINGER_SPELLCASTING_CLERIC = 3121;
const int FEAT_STORMSINGER_SPELLCASTING_DRUID = 3122;
const int FEAT_STORMSINGER_SPELLCASTING_PALADIN = 3123;
const int FEAT_STORMSINGER_SPELLCASTING_RANGER = 3124;
const int FEAT_STORMSINGER_SPELLCASTING_FAVORED_SOUL = 3125;
const int FEAT_STORMSINGER_SPELLCASTING_SORCERER = 3127;
const int FEAT_STORMSINGER_SPELLCASTING_WIZARD = 3128;
const int FEAT_STORMSINGER_SPELLCASTING_WARLOCK = 3545;
/////// Tempest /////// 
// const int CLASS_TYPE_TEMPEST = 110
const int CLASS_TEMPEST = 110;
const int FEAT_TEMPEST_WHIRLWIND = 3054;
const int FEAT_TEMPEST_DEFENSE = 3055;

/////// Black_Flame_Zealot /////// 
// const int CLASS_TYPE_BFZ = 111
const int CLASS_BLACK_FLAME_ZEALOT = 111;
const int SC_CLASS_PROG_BLACK_FLAME_ZEALOT = SC_PROG_EVEN; // EVEn
const int FEAT_BFZ_SPELLCASTING_SPIRIT_SHAMAN = 3005;
const int FEAT_BFZ_SPELLCASTING_CLERIC = 3006;
const int FEAT_BFZ_SPELLCASTING_DRUID = 3007;
const int FEAT_BFZ_SPELLCASTING_PALADIN = 3008;
const int FEAT_BFZ_SPELLCASTING_RANGER = 3009;
const int FEAT_BFZ_SPELLCASTING_FAVORED_SOUL = 3010;
const int FEAT_BFZ_SACRED_FLAME = 3056;
const int FEAT_BFZ_ZEALOUS_HEART = 3057;

/////// Shining_Blade /////// 
// const int CLASS_TYPE_SB = 112
const int CLASS_SHINING_BLADE = 112;
const int SC_CLASS_PROG_SHINING_BLADE  = SC_PROG_EVEN; // EVEN
const int FEAT_SHINING_BLADE_SPELLCASTING_SPIRIT_SHAMAN = 2999;
const int FEAT_SHINING_BLADE_SPELLCASTING_CLERIC = 3000;
const int FEAT_SHINING_BLADE_SPELLCASTING_DRUID = 3001;
const int FEAT_SHINING_BLADE_SPELLCASTING_PALADIN = 3002;
const int FEAT_SHINING_BLADE_SPELLCASTING_RANGER = 3003;
const int FEAT_SHINING_BLADE_SPELLCASTING_FAVORED_SOUL = 3004;
const int FEAT_BATTLE_CASTER_BLADESINGER = 3189;
const int FEAT_SB_SHOCK_BLADE1 = 3077;
const int FEAT_SB_SHOCK_BLADE2 = 3078;
const int FEAT_SB_SHOCK_BLADE3 = 3171;
const int FEAT_SB_SHOCK_BLADE4 = 3172;
const int FEAT_SB_SHOCK_BLADE5 = 3173;
const int FEAT_SB_HOLY_BLADE1 = 3079;
const int FEAT_SB_HOLY_BLADE2 = 3080;
const int FEAT_SB_HOLY_BLADE3 = 3081;

/////// Swiftblade /////// 
// const int CLASS_TYPE_SWIFTBLADE = 113
const int CLASS_SWIFTBLADE = 113;
const int SC_CLASS_PROG_SWIFTBLADE = SC_PROG_SWIFTBLADE; // 2,3,5,6,8, and 9
const int FEAT_SWIFTBLADE_SPELLCASTING_BARD = 3160;
const int FEAT_SWIFTBLADE_SPELLCASTING_SORCERER = 3161;
const int FEAT_SWIFTBLADE_SPELLCASTING_WIZARD = 3162;

/////// Forest_Master /////// 
// CLASS_FOREST_MASTER = 114
const int CLASS_FOREST_MASTER = 114;
const int SC_CLASS_PROG_FOREST_MASTER = SC_PROG_FORESTMASTER; // 1, 2, 3, 5, 6, 7, 9, and 10
const int FEAT_FOREST_MASTER_SPELLCASTING_CLERIC = 3210;
const int FEAT_FOREST_MASTER_SPELLCASTING_DRUID = 3211;
const int FEAT_FOREST_MASTER_SPELLCASTING_FAVORED_SOUL = 3212;
const int FEAT_FOREST_MASTER_SPELLCASTING_PALADIN = 3213;
const int FEAT_FOREST_MASTER_SPELLCASTING_RANGER = 3214;
const int FEAT_FOREST_MASTER_SPELLCASTING_SPIRIT_SHAMAN = 3215;

/////// Nightsong_Enforcer /////// 
// const int CLASS_TYPE_NSENFORCE = 115
const int CLASS_NIGHTSONG_ENFORCER = 115;
const int FEAT_NE_TEAMWORK = 3089;
const int FEAT_NE_AGILITY_TRAINING = 3090;

/////// Thug /////// 
const int CLASS_THUG = 116;


/////// Eldritch Disciple /////// 
const int CLASS_ELDRITCH_DISCIPLE = 117;

const int SC_CLASS_PROG_ELDRITCH_DISCIPLE = SC_PROG_FULL;

const int FEAT_ELDDISC_SPELLCASTING_CLERIC = 3380;
const int FEAT_ELDDISC_SPELLCASTING_DRUID = 3381;
const int FEAT_ELDDISC_SPELLCASTING_FAVORED_SOUL = 3382;
const int FEAT_ELDDISC_SPELLCASTING_PALADIN = 3383;
const int FEAT_ELDDISC_SPELLCASTING_RANGER = 3384;
const int FEAT_ELDDISC_SPELLCASTING_SPIRIT_SHAMAN = 3385;
const int FEAT_ELDDISC_SPELLCASTING_WARLOCK = 3386;


/////// Elemental_Archer /////// 
// const int CLASS_TYPE_ELEMARCHER = 118
const int CLASS_ELEM_ARCHER = 118;
const int FEAT_ELEM_ARCHER_ELEM_STORM = 3230;
const int FEAT_ELEM_ARCHER_IMP_ELEM_SHIELD = 3231;
const int FEAT_ELEM_ARCHER_IMP_ELEM_STORM = 3232;
const int FEAT_ELEM_ARCHER_PATH_AIR = 3233;
const int FEAT_ELEM_ARCHER_PATH_EARTH = 3234;
const int FEAT_ELEM_ARCHER_PATH_FIRE = 3235;
const int FEAT_ELEM_ARCHER_PATH_WATER = 3236;
const int SPELLABILITY_ELEMARCHER_PIERCE_SHOT = 1776;
const int SPELLABILITY_ELEMARCHER_ELEMSHOT = 1777;
const int SPELLABILITY_ELEMARCHER_ELEMSHOT_F = 1778;
const int SPELLABILITY_ELEMARCHER_ELEMSHOT_C = 1779;
const int SPELLABILITY_ELEMARCHER_ELEMSHOT_A = 1780;
const int SPELLABILITY_ELEMARCHER_ELEMSHOT_E = 1781;
const int SPELLABILITY_ELEMARCHER_ELEMSTORM = 1782;
const int SPELLABILITY_ELEMARCHER_MYSTICFLETCHING = 1783;
const int SPELLABILITY_ELEMARCHER_ELEMBURST = 1784;
const int SPELLABILITY_ELEMARCHER_ELEMBURST_F = 1785;
const int SPELLABILITY_ELEMARCHER_ELEMBURST_C = 1786;
const int SPELLABILITY_ELEMARCHER_ELEMBURST_E = 1787;
const int SPELLABILITY_ELEMARCHER_ELEMBURST_A = 1788;

/////// Divine_Seeker /////// 
// const int CLASS_TYPE_DIVSEEK = 119
const int CLASS_DIVINE_SEEKER = 119;
const int FEAT_DIVSEEK_SACRED_STEALTH = 3082;
const int FEAT_DIVSEEK_SACRED_DEFENSE = 3083;
const int FEAT_DIVSEEK_DIVINE_PERSERVERANCE= 3084;

/////// Anointed_Knight /////// 
// const int CLASS_TYPE_ANOINTED_KNIGHT = 120
const int CLASS_ANOINTED_KNIGHT = 120;

/////// Natures_Warrior /////// 
// CLASS_NATURES_WARRIOR = 121
const int CLASS_NATURES_WARRIOR = 121;
const int SC_CLASS_PROG_NATURES_WARRIOR = SC_PROG_EVEN; // EVEN
const int FEAT_NATWARR_NATARM_CROC = 3255;
const int FEAT_NATWARR_NATARM_BLAZE = 3256;
const int FEAT_NATWARR_NATARM_GRIZZLY = 3257;
const int FEAT_NATWARR_NATARM_EARTH = 3258;
const int FEAT_NATWARR_NATARM_CLOUD = 3259;
const int FEAT_NATWARR_NATARM_GROWTH = 3260;
const int FEAT_NATWAR_SPELLCASTING_DRUID = 3252;
const int FEAT_NATWAR_SPELLCASTING_RANGER = 3253;

/////// Frost_Mage /////// 
// const int CLASS_TYPE_FROSTMAGE = 122
const int CLASS_FROST_MAGE = 122;
const int SC_CLASS_PROG_FROST_MAGE = SC_PROG_FULL; // FULL
const int FEAT_FROSTMAGE_SPELLCASTING_BARD = 3275;
const int FEAT_FROSTMAGE_SPELLCASTING_CLERIC = 3276;
const int FEAT_FROSTMAGE_SPELLCASTING_DRUID = 3277;
const int FEAT_FROSTMAGE_SPELLCASTING_FAVORED_SOUL = 3278;
const int FEAT_FROSTMAGE_SPELLCASTING_PALADIN = 3279;
const int FEAT_FROSTMAGE_SPELLCASTING_RANGER = 3280;
const int FEAT_FROSTMAGE_SPELLCASTING_SORCERER = 3281;
const int FEAT_FROSTMAGE_SPELLCASTING_SPIRIT_SHAMAN = 3282;
const int FEAT_FROSTMAGE_SPELLCASTING_WIZARD = 3283;

/////// Lion_Of_Talisid /////// 
// const int CLASS_TYPE_LION_TALISID = 123
const int CLASS_LION_TALISID = 123;
const int SC_CLASS_PROG_LION_TALISID = SC_PROG_FULL; // FULL
const int FEAT_LION_TALISID_SPELLCASTING_SPIRIT_SHAMAN = 3147;
const int FEAT_LION_TALISID_SPELLCASTING_CLERIC = 3148;
const int FEAT_LION_TALISID_SPELLCASTING_DRUID = 3149;
const int FEAT_LION_TALISID_SPELLCASTING_PALADIN = 3150;
const int FEAT_LION_TALISID_SPELLCASTING_RANGER = 3151;
const int FEAT_LION_TALISID_SPELLCASTING_FAVORED_SOUL = 3152;

/////// Canaith_Lyrist /////// 
// CLASS_CANAITH_LYRIST = 124
const int CLASS_CANAITH_LYRIST = 124;

const int SC_CLASS_PROG_CANAITH_LYRIST  = SC_PROG_FULL;

const int FEAT_CANAITH_SPELLCASTING_BARD = 3320;
const int FEAT_CANAITH_SPELLCASTING_CLERIC = 3321;
const int FEAT_CANAITH_SPELLCASTING_DRUID = 3322;
const int FEAT_CANAITH_SPELLCASTING_FAVORED_SOUL = 3323;
const int FEAT_CANAITH_SPELLCASTING_PALADIN = 3324;
const int FEAT_CANAITH_SPELLCASTING_RANGER = 3325;
const int FEAT_CANAITH_SPELLCASTING_SORCERER = 3326;
const int FEAT_CANAITH_SPELLCASTING_SPIRIT_SHAMAN = 3327;
const int FEAT_CANAITH_SPELLCASTING_WIZARD = 3328;


/////// Lyric_Thaumaturge /////// 
// CLASS_LYRIC_THAUMATURGE = 125
const int CLASS_LYRIC_THAUMATURGE = 125;

const int SC_CLASS_PROG_LYRIC_THAUMATURGE = SC_PROG_FULL;

const int FEAT_LYRIC_THAUM_SPELLCASTING_BARD = 3329;

/////// Champion_Wild /////// 
const int CLASS_CHAMPION_WILD = 126;
// const int CLASS_TYPE_CHAMPION_WILD = 126


/////// Skullclan_Hunter /////// 
const int CLASS_SKULLCLAN_HUNTER = 127;
// const int CLASS_TYPE_SKULLCLAN = 127


/////// Dark_Lantern /////// 
const int CLASS_DARK_LANTERN = 128;
// const int CLASS_TYPE_DARKLANT = 128


/////// Nightsong_Infiltrator /////// 
// const int CLASS_TYPE_NSINFIL = 129
const int CLASS_NIGHTSONG_INFILTRATOR = 129;
const int FEAT_NI_TEAMWORK = 3085;
const int FEAT_NI_ADRENALINE_BOOST1 = 3086;
const int FEAT_NI_ADRENALINE_BOOST2 = 3087;
const int FEAT_NI_ADRENALINE_BOOST3 = 3088;
const int FEAT_NI_TRACKLESS_STEP_ALLIES = 3091;

/////// Master_Radiance /////// 
// const int CLASS_TYPE_MASTER_RADIANCE = 130
const int CLASS_MASTER_RADIANCE = 130;
const int SC_CLASS_PROG_MASTER_RADIANCE = SC_PROG_SKIPFIRST; // fullafterfirst (2, 3, 4, etc)
const int FEAT_MASTER_RADIANCE_SPELLCASTING_SPIRIT_SHAMAN = 3178;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_CLERIC = 3179;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_DRUID = 3180;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_PALADIN = 3181;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_RANGER = 3182;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_FAVORED_SOUL = 3183;
const int FEAT_MASTER_RADIANCE_RADIANT_AURA_1 = 3184;
const int FEAT_MASTER_RADIANCE_RADIANT_AURA_2 = 3185;
const int FEAT_MASTER_RADIANCE_RADIANT_AURA_3 = 3186;
const int FEAT_MASTER_RADIANCE_SEARING_LIGHT = 3187;
const int FEAT_MASTER_RADIANCE_BEAM_SUNLIGHT = 3188;

/////// Heartwarder /////// 
// CLASS_HEARTWARD = 131
const int CLASS_HEARTWARDER = 131;
const int SC_CLASS_PROG_HEARTWARDER = SC_PROG_FULL; // FULL
const int FEAT_HEARTWARDER_SPELLCASTING_WARLOCK = 3271;
const int FEAT_HEARTWARDER_SPELLCASTING_BARD = 3262;
const int FEAT_HEARTWARDER_SPELLCASTING_CLERIC = 3263;
const int FEAT_HEARTWARDER_SPELLCASTING_DRUID = 3264;
const int FEAT_HEARTWARDER_SPELLCASTING_FAVORED_SOUL = 3265;
const int FEAT_HEARTWARDER_SPELLCASTING_PALADIN = 3266;
const int FEAT_HEARTWARDER_SPELLCASTING_RANGER = 3267;
const int FEAT_HEARTWARDER_SPELLCASTING_SORCERER = 3268;
const int FEAT_HEARTWARDER_SPELLCASTING_SPIRIT_SHAMAN = 3269;
const int FEAT_HEARTWARDER_SPELLCASTING_WIZARD = 3270;
//const int FEAT_HEARTWARDER_SPELLCASTING_WARLOCK = 3271;


/////// Knight Tierdial /////// 
const int CLASS_KNIGHT_TIERDRIAL = 132;

const int SC_CLASS_PROG_KNIGHT_TIERDRIAL = SC_PROG_FULL;

const int FEAT_KOT_SPELLCASTING_BARD = 3332;
const int FEAT_KOT_SPELLCASTING_CLERIC = 3333;
const int FEAT_KOT_SPELLCASTING_DRUID = 3334;
const int FEAT_KOT_SPELLCASTING_FAVORED_SOUL = 3335;
const int FEAT_KOT_SPELLCASTING_PALADIN = 3336;
const int FEAT_KOT_SPELLCASTING_RANGER = 3337;
const int FEAT_KOT_SPELLCASTING_SORCERER = 3338;
const int FEAT_KOT_SPELLCASTING_SPIRIT_SHAMAN = 3339;
const int FEAT_KOT_SPELLCASTING_WIZARD = 3340;
const int FEAT_KOT_SPELLCASTING_WARLOCK = 3341;
const int FEAT_KOT_SPELLCASTING_ASSASSIN = 3342;
const int FEAT_KOT_SPELLCASTING_AVENGER = 3343;
const int FEAT_KOT_SPELLCASTING_BLACKGUARD = 3344;


/////// Shadowbane Stalker /////// 
const int CLASS_SHADOWBANE_STALKER = 133;

const int SC_CLASS_PROG_SHADOWBANE_STALKER = SC_PROG_SHDSTALKER;

const int FEAT_SHDWSTLKR_SPELLCASTING_CLERIC = 3345;
const int FEAT_SHDWSTLKR_SPELLCASTING_DRUID = 3346;
const int FEAT_SHDWSTLKR_SPELLCASTING_FAVORED_SOUL = 3347;
const int FEAT_SHDWSTLKR_SPELLCASTING_PALADIN = 3348;
const int FEAT_SHDWSTLKR_SPELLCASTING_RANGER = 3349;
const int FEAT_SHDWSTLKR_SPELLCASTING_SPIRIT_SHAMAN = 3350;


/////// Dragon_Slayer /////// 
const int CLASS_DRAGONSLAYER = 134;

const int SC_CLASS_PROG_DRAGONSLAYER = SC_PROG_FULL;

const int FEAT_DRSLR_SPELLCASTING_BARD = 3363;
const int FEAT_DRSLR_SPELLCASTING_CLERIC = 3364;
const int FEAT_DRSLR_SPELLCASTING_DRUID = 3365;
const int FEAT_DRSLR_SPELLCASTING_FAVORED_SOUL = 3366;
const int FEAT_DRSLR_SPELLCASTING_PALADIN = 3367;
const int FEAT_DRSLR_SPELLCASTING_RANGER = 3368;
const int FEAT_DRSLR_SPELLCASTING_SORCERER = 3369;
const int FEAT_DRSLR_SPELLCASTING_SPIRIT_SHAMAN = 3370;
const int FEAT_DRSLR_SPELLCASTING_WIZARD = 3371;
const int FEAT_DRSLR_SPELLCASTING_WARLOCK = 3372;
const int FEAT_DRSLR_SPELLCASTING_ASSASSIN = 3373;
const int FEAT_DRSLR_SPELLCASTING_AVENGER = 3374;
const int FEAT_DRSLR_SPELLCASTING_BLACKGUARD = 3375;


/////// Dragon_Shaman /////// 
const int CLASS_DRAGON_SHAMAN = 135;

/////// Fist of the Forest /////// 
const int CLASS_FIST_FOREST = 136;

/////// Champion Silver Flame /////// 
const int CLASS_CHAMP_SILVER_FLAME = 137;


/////// Avenger /////// 
// const int CLASS_TYPE_ASSASSIN = 142
const int CLASS_TYPE_AVENGER = 142;
const int SC_CLASS_PROG_AVENGER = SC_PROG_SKIPFIRST; // fullafterfirst (2, 3, 4, etc)

/////// Dread_Commando /////// 
// CLASS_DREAD_COMMANDO = 166
const int CLASS_DREAD_COMMANDO = 166;
const int FEAT_DC_TEAM_INITIATIVE = 3106;
const int FEAT_DC_ARMORED_EASE = 3107;

/////// Elemental_Warrior /////// 
// const int CLASS_TYPE_ELEMWAR = 180
const int CLASS_ELEMENTAL_WARRIOR = 180;
const int FEAT_ELEMWAR_AFFINITY_AIR = 3500;
const int FEAT_ELEMWAR_AFFINITY_EARTH = 3501;
const int FEAT_ELEMWAR_AFFINITY_FIRE = 3502;
const int FEAT_ELEMWAR_AFFINITY_WATER = 3503;
const int SPELLABILITY_ELEMWAR_AFFINITYE = 2001;
const int SPELLABILITY_ELEMWAR_AFFINITYF = 2002;
const int SPELLABILITY_ELEMWAR_AFFINITYW = 2003;

/////// Whirling_Dervish /////// 
// const int CLASS_TYPE_WHDERV = 181
const int CLASS_WHIRLING_DERVISH = 181;
const int SPELLABILITY_MINORTELEPORT = 2009;




const int CLASS_DEATHBLADE = 182;
const int CLASS_OPTIMIST = 183;

const int CLASS_SWORD_DANCER = 138;

const int CLASS_DRAGON_WARRIOR = 139;

const int CLASS_CHILD_NIGHT = 140;




const int CLASS_DERVISH = 143;

const int CLASS_NINJA = 144;

const int CLASS_GHOST_FACED_KILLER = 145;

const int CLASS_DREAD_PIRATE = 146;

/////// Daggerspell Mage /////// 
const int CLASS_DAGGERSPELL_MAGE = 147;
const int SC_CLASS_PROG_DAGGERSPELL_MAGE = SC_PROG_SKIPFIRST;

/////// Daggerspell shaper /////// 
const int CLASS_DAGGERSPELL_SHAPER = 148;
const int SC_CLASS_PROG_DAGGERSPELL_SHAPER = SC_PROG_SKIPFIRST;

const int CLASS_SCOUT = 149;

const int CLASS_WILD_STALKER = 150;

const int CLASS_VERDANT_GUARDIAN = 151;


const int CLASS_CHARNAG_MAELTHRA = 179;


const int CLASS_DISSONANT_CHORD = 184;



/////// Aberration /////// 
// const int CLASS_TYPE_ABERRATION = 11


/////// Animal /////// 
// const int CLASS_TYPE_ANIMAL = 12


/////// Construct /////// 
// const int CLASS_TYPE_CONSTRUCT = 13


/////// Humanoid /////// 
// const int CLASS_TYPE_HUMANOID = 14


/////// Monstrous /////// 
// const int CLASS_TYPE_MONSTEROUS = 15


/////// Elemental /////// 
// const int CLASS_TYPE_ELEMENTAL = 16


/////// Fey /////// 
// const int CLASS_TYPE_FEY = 17


/////// Dragon /////// 
// const int CLASS_TYPE_DRAGON = 18


/////// Undead /////// 
// const int CLASS_TYPE_UNDEAD = 19


/////// Commoner /////// 
// const int CLASS_TYPE_COMMONER = 20


/////// Beast /////// 
// const int CLASS_TYPE_BEAST = 21


/////// Giant /////// 
// const int CLASS_TYPE_GIANT = 22


/////// MagicBeast /////// 
// const int CLASS_TYPE_MAGICAL_BEAST = 23


/////// Outsider /////// 
// const int CLASS_TYPE_OUTSIDER = 24


/////// Shapechanger /////// 
// const int CLASS_TYPE_SHAPECHANGER = 25


/////// Vermin /////// 
// const int CLASS_TYPE_VERMIN = 26


///////  Plant /////// 
// const int CLASS_TYPE_PLANT = 35




///////  Contemplative /////// 
const int SC_CLASS_PROG_CONTEMPLATIVE = SC_PROG_XXX;
const int FEAT_CONTEMPLATIVE_SPELLCASTING_CLERIC = 1515;
const int FEAT_CONTEMPLATIVE_SPELLCASTING_DRUID = 1516;
const int FEAT_CONTEMPLATIVE_SPELLCASTING_PALADIN = 1517;
const int FEAT_CONTEMPLATIVE_SPELLCASTING_RANGER = 1518;

///////  Mystic Theurge /////// 
const int SC_CLASS_PROG_MYSTICTHEURGE = SC_PROG_XXX;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_BARD = 1542;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_SORCERER = 1543;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_WIZARD = 1544;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_CLERIC = 1545;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_DRUID = 1546;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_PALADIN = 1547;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_RANGER = 1548;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_WARLOCK = 1678;


const int SC_CLASS_PROG_OOZE = SC_PROG_XXX;
const int SC_CLASS_PROG_NWNINE_AGENT = SC_PROG_XXX;
const int SC_CLASS_PROG_NWNINE_MAGUS = SC_PROG_XXX;


//*
//Probably will have to add these
//const int FEAT_HOSPITALER_SPELLCASTING_SPIRIT_SHAMAN = 2993;
//const int FEAT_HOSPITALER_SPELLCASTING_CLERIC = 2994;
//const int FEAT_HOSPITALER_SPELLCASTING_DRUID = 2995;
//const int FEAT_HOSPITALER_SPELLCASTING_PALADIN = 2996;
//const int FEAT_HOSPITALER_SPELLCASTING_RANGER = 2997;
//const int FEAT_HOSPITALER_SPELLCASTING_FAVORED_SOUL = 2998;
//const int FEAT_SHINING_BLADE_SPELLCASTING_SPIRIT_SHAMAN = 2999;
//const int FEAT_SHINING_BLADE_SPELLCASTING_CLERIC = 3000;
//const int FEAT_SHINING_BLADE_SPELLCASTING_DRUID = 3001;
//const int FEAT_SHINING_BLADE_SPELLCASTING_PALADIN = 3002;
//const int FEAT_SHINING_BLADE_SPELLCASTING_RANGER = 3003;
//const int FEAT_SHINING_BLADE_SPELLCASTING_FAVORED_SOUL = 3004;
//const int FEAT_BFZ_SPELLCASTING_SPIRIT_SHAMAN = 3005;
//const int FEAT_BFZ_SPELLCASTING_CLERIC = 3006;
//const int FEAT_BFZ_SPELLCASTING_DRUID = 3007;
//const int FEAT_BFZ_SPELLCASTING_PALADIN = 3008;
//const int FEAT_BFZ_SPELLCASTING_RANGER = 3009;
//const int FEAT_BFZ_SPELLCASTING_FAVORED_SOUL = 3010;
//const int FEAT_BLADESINGER_SPELLCASTING_BARD = 3112;
//const int FEAT_BLADESINGER_SPELLCASTING_SORCERER = 3113;
//const int FEAT_BLADESINGER_SPELLCASTING_WIZARD = 3114;

// just added 
const int FEAT_COTSF_SPELLCASTING_PALADIN = 3546;
const int FEAT_SWRDNCR_SPELLCASTING_PALADIN = 3556;
const int FEAT_DISCHORD_IMPROVED_COUNTERSPELL = 3569;
const int FEAT_CHLDNIGHT_SPELLCASTING_PALADIN = 3580;
const int FEAT_CHLDNIGHT_SPELLCASTING_WARLOCK = 3585;
const int FEAT_CHLDNIGHT_SPELLCASTING_ASSASSIN = 3586;
const int FEAT_CHLDNIGHT_SPELLCASTING_AVENGER = 3587;
const int FEAT_CHLDNIGHT_SPELLCASTING_BLACKGUARD = 3588;
const int FEAT_DERVISH_DEFENSIVE_PARRY = 3613;
const int FEAT_NINJA_KI_POWER_1 = 3617;
const int FEAT_DRPIRATE_RALLY_THE_CREW_1 = 3686;
const int FEAT_DRPIRATE_RALLY_THE_CREW_2 = 3687;
const int FEAT_EXPANDED_KI_POOL = 3692;
const int FEAT_ASCETIC_STALKER = 3695;
const int FEAT_MARTIAL_STALKER = 3696;
const int FEAT_DEVOTED_TRACKER = 3697;
const int FEAT_EXTRA_SPIRIT_FORM = 3698;
const int FEAT_EXTRA_SPIRIT_JOURNEY = 3698;

const int FEAT_TELTHOR_COMPANION = 3704;
const int FEAT_IMPROVED_NATURAL_BOND = 3705;
const int FEAT_SCOUT_SKIRMISHAC = 3709;
const int FEAT_SWIFT_AMBUSHER = 3710;
const int FEAT_SWIFT_HUNTER = 3711;
const int FEAT_DMAGE_SPELLCASTING_WARLOCK = 3718;
const int FEAT_DSHAPE_SPELLCASTING_PALADIN = 3723;
const int FEAT_DSHAPE_SPELLCASTING_RANGER = 3724;
const int FEAT_VGUARD_PLANT_SHAPE1 = 3730;
const int FEAT_GUTTURAL_INVOCATIONS = 3748;
const int FEAT_DARK_TRANSIENT = 3751;
const int FEAT_PRACTICED_INVOKER = 3753;
const int FEAT_REAL_EXTRA_WILD_SHAPE = 3755;