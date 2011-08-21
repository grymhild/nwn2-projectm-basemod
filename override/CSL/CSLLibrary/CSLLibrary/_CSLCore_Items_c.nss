/** @file
* @brief Item and Item property constants
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

#include "_CSLCore_Math_c" // for the bit constants


const string DMFI_STORAGE = "nw_it_contain006";
const string DMFI_INVEN_TEMP = "Inventory Target: ";
const string DMFI_INVENTORY_TARGET = "DMFIInventoryTarget";

// WeaponType 1 = piercing; 2 = bludgeoning; 3 = slashing; 4 = piercing-slashing; 5 = bludgeoning-piercing.
// WeaponSize 1 = tiny; 2 = small; 3 = medium; 4 = large.

int ITEM_ATTRIB_NONE			= BIT0;
// basic damage types
int ITEM_ATTRIB_EQUIPPABLE		= BIT1; // can it be equipped
int ITEM_ATTRIB_WEAPON			= BIT2; // its a weapon
int ITEM_ATTRIB_MELEE			= BIT3;
int ITEM_ATTRIB_RANGED			= BIT4; // Audible
int ITEM_ATTRIB_THROWN			= BIT5; 

//better damage types
int ITEM_ATTRIB_AMMO			= BIT6;
int ITEM_ATTRIB_SHIELD			= BIT7; // covers the various shields
int ITEM_ATTRIB_CONTAINER		= BIT8; // may or may not be needed
int ITEM_ATTRIB_PIERCING		= BIT9;
int ITEM_ATTRIB_BLUDGEONING		= BIT10;
int ITEM_ATTRIB_SLASHING		= BIT11;

// these are for slots usable
int ITEM_ATTRIB_RIGHTHAND		= BIT12;
int ITEM_ATTRIB_LEFTHAND		= BIT13; // This is used if the PC does not have monkey grip
int ITEM_ATTRIB_TWOHANDABLE		= BIT14; // this is used if the PC has moneky grip
int ITEM_ATTRIB_LEFTWMONKEY		= BIT15; // is this even needed, feat based really
int ITEM_ATTRIB_TINY			= BIT16;
int ITEM_ATTRIB_SMALL			= BIT17;   
int ITEM_ATTRIB_MEDIUM			= BIT18;
int ITEM_ATTRIB_LARGE			= BIT19;
// these are for kaedrin special features
int ITEM_ATTRIB_LIGHTWEAPON		= BIT20;  // is this same as finessible with rapier included for non halflings
int ITEM_ATTRIB_INTUITIVEATTACK	= BIT21;
int ITEM_ATTRIB_ELEGANTSTRIKE	= BIT22;
// these are the tome of battle martial groupings, each is a martial art that deals with certain weapons
int ITEM_ATTRIB_WHITERAVEN		= BIT23;
int ITEM_ATTRIB_TIGERCLAW		= BIT24;
int ITEM_ATTRIB_STONEDRAGON		= BIT25;
int ITEM_ATTRIB_SHADOWHAND		= BIT26;
int ITEM_ATTRIB_SETTINGSUN		= BIT27;
int ITEM_ATTRIB_IRONHEART		= BIT28;
int ITEM_ATTRIB_DESERTWIND		= BIT29;
int ITEM_ATTRIB_DEVOTEDSPIRIT	= BIT30;
int ITEM_ATTRIB_DIAMONDMIND		= BIT31;



// * These are missing constants
const int INVENTORY_SLOT_INVALID = -1;
const int INVENTORY_SLOT_HANDS = 104;
const int INVENTORY_SLOT_RINGS = 107;
const int INVENTORY_SLOT_CWEAPON = 114;

// * these are constants just there to make things easier
const int ITEMS_SHOWN_INVISIBLE = 0;
const int ITEMS_SHOWN_VISIBLE = 1;
const int ITEMS_SHOWN_DEFAULT = 4;

const int ITEMS_SHOWN_WEAPON = 0;
const int ITEMS_SHOWN_HELM = 1;
const int ITEMS_SHOWN_HELMWEAPON = 2;

// *  Policy constants for CSLSafeAddItemProperty()
const int    SC_IP_ADDPROP_POLICY_REPLACE_EXISTING = 0;
const int    SC_IP_ADDPROP_POLICY_KEEP_EXISTING = 1;
const int    SC_IP_ADDPROP_POLICY_IGNORE_EXISTING =2;

// *  The tag of the ip work container, a placeable which has to be set into each
// *  module that is using any of the crafting functions.
const string  SC_IP_WORK_CONTAINER_TAG = "x2_plc_ipbox";
// *  2da for the AddProperty ItemProperty
const string SC_IP_ADDRPOP_2DA = "des_crft_props" ;
// *  2da for the Poison Weapon Itemproperty
const string SC_IP_POISONWEAPON_2DA = "des_crft_poison" ;
// *  2da for armor appearance
const string SC_IP_ARMORPARTS_2DA = "des_crft_aparts" ;
// *  2da for armor appearance
const string SC_IP_ARMORAPPEARANCE_2DA = "des_crft_appear" ;

// * Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int    SC_IP_ITEMMODCONVERSATION_CTOKENBASE = 12220;
const int    SC_IP_ITEMMODCONVERSATION_MODE_TAILOR = 0;
const int    SC_IP_ITEMMODCONVERSATION_MODE_CRAFT = 1;

// * Number of maximum item properties allowed on most items
const int    SC_IP_MAX_ITEM_PROPERTIES = 8;

// *  Constants used with the armor modification system
const int    SC_IP_ARMORTYPE_NEXT = 0;
const int    SC_IP_ARMORTYPE_PREV = 1;
const int    SC_IP_ARMORTYPE_RANDOM = 2;
const int    SC_IP_WEAPONTYPE_NEXT = 0;
const int    SC_IP_WEAPONTYPE_PREV = 1;
const int    SC_IP_WEAPONTYPE_RANDOM = 2;


const string SC_LAST_SLOT_NUM	=	"LastSlotNum";
const string SC_LAST_SLOT_OBJ	=	"LastSlotObj";

// item categories - weapon, armor/shield, other
const int SC_ITEM_CATEGORY_NONE    		= 0;
const int SC_ITEM_CATEGORY_WEAPON  		= 1;
const int SC_ITEM_CATEGORY_ARMOR_SHIELD   	= 2;
const int SC_ITEM_CATEGORY_OTHER   		= 4; // everything not armor & weapons
const int SC_ITEM_CATEGORY_MISC_EQUIPPABLE = 8; // amulet, ring, cloak, etc.

// derived item categories
const int SC_ITEM_CATEGORY_ALL   			= 7; // SC_ITEM_CATEGORY_WEAPON + SC_ITEM_CATEGORY_ARMOR_SHIELD + SC_ITEM_CATEGORY_OTHER
const int SC_ITEM_CATEGORY_EQUIPPABLE      = 11; // SC_ITEM_CATEGORY_MISC_EQUIPPABLE + SC_ITEM_CATEGORY_ARMOR_SHIELD + SC_ITEM_CATEGORY_WEAPON


const string SC_PARAM_NO_DRR               = "N2_NO_DRR"; // Set to true on irem to prevent item from being recreated from blueprint
const string SC_VAR_PREFIX_RECREATE_LIST   = "N2_RecreateList";

const int FEAT_IMPROVED_CRITICAL_GREATCLUB = 1600;
const int FEAT_WEAPON_FOCUS_GREATCLUB = 1601;
const int FEAT_WEAPON_SPECIALIZATION_GREATCLUB = 1602;
const int FEAT_EPIC_DEVASTATING_CRITICAL_GREATCLUB = 1603;
const int FEAT_EPIC_WEAPON_FOCUS_GREATCLUB = 1604;
const int FEAT_EPIC_WEAPON_SPECIALIZATION_GREATCLUB = 1605;
const int FEAT_EPIC_OVERWHELMING_CRITICAL_GREATCLUB = 1606;
const int FEAT_WEAPON_OF_CHOICE_GREATCLUB	= 1607;
const int FEAT_GREATER_WEAPON_FOCUS_GREATCLUB = 1608;
const int FEAT_GREATER_WEAPON_SPECIALIZATION_GREATCLUB = 1609;
const int FEAT_POWER_CRITICAL_GREATCLUB = 1610;



const int FEAT_IMPROVED_CRITICAL_LANCE = 1611;
const int FEAT_WEAPON_FOCUS_LANCE = 1612;
const int FEAT_WEAPON_SPECIALIZATION_LANCE = 1613;
const int FEAT_EPIC_DEVASTATING_CRITICAL_LANCE = 1614;
const int FEAT_EPIC_WEAPON_FOCUS_LANCE = 1615;
const int FEAT_EPIC_WEAPON_SPECIALIZATION_LANCE = 1616;
const int FEAT_EPIC_OVERWHELMING_CRITICAL_LANCE = 1617;
const int FEAT_WEAPON_OF_CHOICE_LANCE = 1618;
const int FEAT_GREATER_WEAPON_FOCUS_LANCE = 1619;
const int FEAT_GREATER_WEAPON_SPECIALIZATION_LANCE = 1620;
const int FEAT_POWER_CRITICAL_LANCE = 1621;

const int FEAT_IMPROVED_CRITICAL_SAP = 1622;
const int FEAT_WEAPON_FOCUS_SAP = 1623;
const int FEAT_WEAPON_SPECIALIZATION_SAP = 1624;
const int FEAT_EPIC_DEVASTATING_CRITICAL_SAP = 1625;
const int FEAT_EPIC_WEAPON_FOCUS_SAP = 1626;
const int FEAT_EPIC_WEAPON_SPECIALIZATION_SAP = 1627;
const int FEAT_EPIC_OVERWHELMING_CRITICAL_SAP = 1628;
const int FEAT_WEAPON_OF_CHOICE_SAP = 1629;
const int FEAT_GREATER_WEAPON_FOCUS_SAP = 1630;
const int FEAT_GREATER_WEAPON_SPECIALIZATION_SAP = 1631;
const int FEAT_POWER_CRITICAL_SAP = 1632;


//caos stuff- need to review
const int ARMOR_INVALID						= -1;
const int ARMOR_CLOTH						= 0;
const int ARMOR_CLOTH_PADDED				= 1;
const int ARMOR_LEATHER						= 2;
const int ARMOR_LEATHER_STUDDED				= 3;
const int ARMOR_CHAIN_SHIRT					= 4;
const int ARMOR_SCALE						= 5;
const int ARMOR_BANDED						= 6;
const int ARMOR_HALF_PLATE					= 7;
const int ARMOR_FULL_PLATE					= 8;
const int ARMOR_HIDE						= 12;
const int ARMOR_CHAIN_MAIL					= 13;
const int ARMOR_BREASTPLATE					= 14;
const int ARMOR_SPLINT						= 15;
const int ARMOR_CHAIN_SHIRT_MITHRAL			= 16;
const int ARMOR_SCALE_MITHRAL				= 17;
const int ARMOR_BANDED_MITHRAL				= 18;
const int ARMOR_HALF_PLATE_MITHRAL			= 19;
const int ARMOR_FULL_PLATE_MITHRAL			= 20;
const int ARMOR_CHAIN_MAIL_MITHRAL			= 21;
const int ARMOR_BREASTPLATE_MITHRAL			= 22;
const int ARMOR_SPLINT_MITHRAL				= 23;
const int ARMOR_CLOTH_PADDED_MASTERWORK		= 24;
const int ARMOR_LEATHER_MASTERWORK			= 25;
const int ARMOR_LEATHER_STUDDED_MASTERWORK	= 26;
const int ARMOR_CHAIN_SHIRT_MASTERWORK		= 27;
const int ARMOR_HIDE_MASTERWORK				= 28;
const int ARMOR_SCALE_MASTERWORK			= 29;
const int ARMOR_BREASTPLATE_MASTERWORK		= 30;
const int ARMOR_CHAIN_MAIL_MASTERWORK		= 31;
const int ARMOR_SPLINT_MASTERWORK			= 32;
const int ARMOR_BANDED_MASTERWORK			= 33;
const int ARMOR_HALF_PLATE_MASTERWORK		= 34;
const int ARMOR_FULL_PLATE_MASTERWORK		= 35;

const int ARMOR_WEIGHT_INVALID						= -1;
const int ARMOR_WEIGHT_CLOTH						= 70;
const int ARMOR_WEIGHT_CLOTH_PADDED					= 100;
const int ARMOR_WEIGHT_LEATHER						= 145;
const int ARMOR_WEIGHT_LEATHER_STUDDED				= 195;
const int ARMOR_WEIGHT_CHAIN_SHIRT					= 245;
const int ARMOR_WEIGHT_SCALE						= 300;
const int ARMOR_WEIGHT_BANDED						= 350;
const int ARMOR_WEIGHT_HALF_PLATE					= 470;
const int ARMOR_WEIGHT_FULL_PLATE					= 500;
const int ARMOR_WEIGHT_HIDE							= 230;
const int ARMOR_WEIGHT_CHAIN_MAIL					= 400;
const int ARMOR_WEIGHT_BREASTPLATE					= 320;
const int ARMOR_WEIGHT_SPLINT						= 450;
const int ARMOR_WEIGHT_CHAIN_SHIRT_MITHRAL			= 125;
const int ARMOR_WEIGHT_SCALE_MITHRAL				= 150;
const int ARMOR_WEIGHT_BANDED_MITHRAL				= 175;
const int ARMOR_WEIGHT_HALF_PLATE_MITHRAL			= 235;
const int ARMOR_WEIGHT_FULL_PLATE_MITHRAL			= 250;
const int ARMOR_WEIGHT_CHAIN_MAIL_MITHRAL			= 200;
const int ARMOR_WEIGHT_BREASTPLATE_MITHRAL			= 160;
const int ARMOR_WEIGHT_SPLINT_MITHRAL				= 225;
const int ARMOR_WEIGHT_CLOTH_PADDED_MASTERWORK		= 95;
const int ARMOR_WEIGHT_LEATHER_MASTERWORK			= 147;
const int ARMOR_WEIGHT_LEATHER_STUDDED_MASTERWORK	= 197;
const int ARMOR_WEIGHT_CHAIN_SHIRT_MASTERWORK		= 240;
const int ARMOR_WEIGHT_HIDE_MASTERWORK				= 227;
const int ARMOR_WEIGHT_SCALE_MASTERWORK				= 297;
const int ARMOR_WEIGHT_BREASTPLATE_MASTERWORK		= 395;
const int ARMOR_WEIGHT_CHAIN_MAIL_MASTERWORK		= 315;
const int ARMOR_WEIGHT_SPLINT_MASTERWORK			= 445;
const int ARMOR_WEIGHT_BANDED_MASTERWORK			= 345;
const int ARMOR_WEIGHT_HALF_PLATE_MASTERWORK		= 465;
const int ARMOR_WEIGHT_FULL_PLATE_MASTERWORK		= 495;




// These are missing from the nwscript.nss
const int BASE_ITEM_BALORSWORD = 82;
const int BASE_ITEM_BALORFALCHION = 83;
const int BASE_ITEM_CRAFTBASE = 112;
const int BASE_ITEM_SOFTBUNDLE = 125;
const int BASE_ITEM_STEIN		= 127;
const int BASE_ITEM_INK_WELL	= 130;
const int BASE_ITEM_LOOTBAG		= 131;
const int BASE_ITEM_PAN		= 133;
const int BASE_ITEM_POT		= 134;
const int BASE_ITEM_RAKE		= 135;
const int BASE_ITEM_SHOVEL		= 136;
const int BASE_ITEM_SMITHYHAMMER	= 137;
const int BASE_ITEM_SPOON		= 138;
const int BASE_ITEM_BOTTLE		= 139;
const int BASE_ITEM_MISCSTACK = 143;
const int BASE_ITEM_BOUNTYITEM = 144;
const int BASE_ITEM_RECIPE = 145;
const int BASE_ITEM_INCANTATION = 146;





// Tome of Battle
// Weapon Size

const int WEAPON_SIZE_INVALID	=	0;
const int WEAPON_SIZE_TINY		=	1;
const int WEAPON_SIZE_SMALL		=	2;
const int WEAPON_SIZE_MEDIUM	=	3;
const int WEAPON_SIZE_LARGE		=	4;

// Reach Weapons

const int BASE_ITEM_SHORTSWORD_R	=	241;
const int BASE_ITEM_LONGSWORD_R		=	242;
const int BASE_ITEM_BATTLEAXE_R		=	243;
const int BASE_ITEM_BASTARDSWORD_R	=	244;
const int BASE_ITEM_LIGHTFLAIL_R	=	245;
const int BASE_ITEM_WARHAMMER_R		=	246;
const int BASE_ITEM_MACE_R			=	247;
const int BASE_ITEM_HALBERD_R		=	248;
const int BASE_ITEM_GREATSWORD_R	=	249;
const int BASE_ITEM_GREATAXE_R		=	250;
const int BASE_ITEM_DAGGER_R		=	251;
const int BASE_ITEM_CLUB_R			=	252;
const int BASE_ITEM_LIGHTHAMMER_R	=	253;
const int BASE_ITEM_HANDAXE_R		=	254;
const int BASE_ITEM_KAMA_R			=	255;
const int BASE_ITEM_KATANA_R		=	256;
const int BASE_ITEM_KUKRI_R			=	257;
const int BASE_ITEM_MAGICSTAFF_R	=	258;
const int BASE_ITEM_MORNINGSTAR_R	=	259;
const int BASE_ITEM_QUARTERSTAFF_R	=	260;
const int BASE_ITEM_RAPIER_R		=	261;
const int BASE_ITEM_SCIMITAR_R		=	262;
const int BASE_ITEM_SCYTHE_R		=	263;
const int BASE_ITEM_SICKLE_R		=	264;
const int BASE_ITEM_DWARVENWARAXE_R	=	265;
const int BASE_ITEM_WHIP_R			=	266;
const int BASE_ITEM_FALCHION_R		=	267;
const int BASE_ITEM_FLAIL_R			=	268;
const int BASE_ITEM_SPEAR_R			=	269;
const int BASE_ITEM_GREATCLUB_R		=	270;
const int BASE_ITEM_TRAINING_CLUB_R	=	271;
const int BASE_ITEM_WARMACE_R		=	272;



const int BASE_ITEM_LONGBOW_R  = 273;
const int BASE_ITEM_SHORTBOW_R = 274;
const int BASE_ITEM_SHURIKEN_R = 275;
const int BASE_ITEM_HEAVYCROSSBOW_R = 276;
const int BASE_ITEM_LIGHTCROSSBOW_R = 277;
const int BASE_ITEM_THROWINGAXE_R = 278;
const int BASE_ITEM_SLING_R = 279;
const int BASE_ITEM_DART_R = 280;


const int BASE_ITEM_STEED = 281;
// Damage Constants

const int IP_CONST_DAMAGEBONUS_11	=	21;
const int IP_CONST_DAMAGEBONUS_12	=	22;
const int IP_CONST_DAMAGEBONUS_13	=	23;
const int IP_CONST_DAMAGEBONUS_14	=	24;
const int IP_CONST_DAMAGEBONUS_15	=	25;
const int IP_CONST_DAMAGEBONUS_16	=	26;
const int IP_CONST_DAMAGEBONUS_17	=	27;
const int IP_CONST_DAMAGEBONUS_18	=	28;
const int IP_CONST_DAMAGEBONUS_19	=	29;
const int IP_CONST_DAMAGEBONUS_20	=	30;
const int IP_CONST_DAMAGEBONUS_21	=	31;
const int IP_CONST_DAMAGEBONUS_22	=	32;
const int IP_CONST_DAMAGEBONUS_23	=	33;
const int IP_CONST_DAMAGEBONUS_24	=	34;
const int IP_CONST_DAMAGEBONUS_25	=	35;
const int IP_CONST_DAMAGEBONUS_26	=	36;
const int IP_CONST_DAMAGEBONUS_27	=	37;
const int IP_CONST_DAMAGEBONUS_28	=	38;
const int IP_CONST_DAMAGEBONUS_29	=	39;
const int IP_CONST_DAMAGEBONUS_30	=	40;
const int IP_CONST_DAMAGEBONUS_31	=	41;
const int IP_CONST_DAMAGEBONUS_32	=	42;
const int IP_CONST_DAMAGEBONUS_33	=	43;
const int IP_CONST_DAMAGEBONUS_34	=	44;
const int IP_CONST_DAMAGEBONUS_35	=	45;
const int IP_CONST_DAMAGEBONUS_36	=	46;
const int IP_CONST_DAMAGEBONUS_37	=	47;
const int IP_CONST_DAMAGEBONUS_38	=	48;
const int IP_CONST_DAMAGEBONUS_39	=	49;
const int IP_CONST_DAMAGEBONUS_40	=	50;
// double reach ranged weapons



// SHOW constants for item properties
const int SHOW_ABILITY            = BIT1;
const int SHOW_SKILL              = BIT2;
const int SHOW_SAVEVS             = BIT3;
const int SHOW_SPELLSLOT          = BIT4;
const int SHOW_AB                 = BIT5;
const int SHOW_KEEN               = BIT6;
const int SHOW_DAMAGE             = BIT7;
const int SHOW_MASSCRITS          = BIT8;
const int SHOW_VAMP_REGEN         = BIT9;
const int SHOW_ONHIT              = BIT10;
const int SHOW_MIGHTY             = BIT11;
const int SHOW_REGEN              = BIT12;
const int SHOW_SAVESPECIFIC       = BIT13;
const int SHOW_HASTE              = BIT14;
const int SHOW_DARKVISION         = BIT15;
const int SHOW_AC                 = BIT16;
const int SHOW_LIGHT              = BIT17;
const int SHOW_VISUAL             = BIT18;
const int SHOW_EB                 = BIT19;
const int SHOW_DAMAGERESIST       = BIT20;
const int SHOW_DAMAGEIMMUNITY     = BIT21;
const int SHOW_DAMAGEREDUCT       = BIT22;


// Maximum Item Level
const int SMS_ITEM_LEVEL_MAX = 20;
const int MAX_DAMAGE_PER_MOD = 2;

// AC Bonuses
const int SMS_AC_MAX = 4;
const int SMS_AC_MAX_ARMORAMULET = 4;

// Weapon Bonuses
const int SMS_AB_MAX                = 4;
const int SMS_WEAPON_MODS_LARGE     = 6;  // # OF DAMAGE MODS ON LARGE WEAPON
const int SMS_WEAPON_MODS_MEDIUM    = 4;
const int SMS_WEAPON_MODS_SMALL     = 3;
const int SMS_WEAPON_MODS_TINY      = 3;
const int SMS_WEAPON_MODS_THROWING  = 3;
const int SMS_WEAPON_MODS_RANGED    = 2;
const int SMS_WEAPON_MODS_AMMO      = 5; // PRE-CALCULATED NO ADDITIONAL MODIFIERS (EXCEPT BULLETS + 1)
const int SMS_WEAPON_MODS_GLOVES    = 8; // PRE-CALCULATED NO ADDITIONAL MODIFIERS GIVEN, ASSUMES MEDIUM WEAPON, 20 CRIT THREAT AND x2 DAMAGE

const int SMS_WEAPON_MASSCRIT_LARGE     = IP_CONST_DAMAGEBONUS_2d6;
const int SMS_WEAPON_MASSCRIT_MEDIUM    = IP_CONST_DAMAGEBONUS_2d4;
const int SMS_WEAPON_MASSCRIT_SMALL     = IP_CONST_DAMAGEBONUS_1d6;
const int SMS_WEAPON_MASSCRIT_TINY      = IP_CONST_DAMAGEBONUS_1d6;
const int SMS_WEAPON_MASSCRIT_THROWING  = IP_CONST_DAMAGEBONUS_1d6;
const int SMS_WEAPON_MASSCRIT_RANGED    = IP_CONST_DAMAGEBONUS_1d4;
const int SMS_WEAPON_MASSCRIT_AMMO      = IP_CONST_DAMAGEBONUS_1d4;
const int SMS_WEAPON_MASSCRIT_GLOVES    = IP_CONST_DAMAGEBONUS_2d4;

const int SMS_WEAPON_MODS_CRITTHREAT20 = 2;
const int SMS_WEAPON_MODS_CRITTHREAT19 = 1;
const int SMS_WEAPON_MODS_CRITTHREAT18 = 0;

const int SMS_WEAPON_MODS_CRITMULT2   = 2;
const int SMS_WEAPON_MODS_CRITMULT3   = 1;
const int SMS_WEAPON_MODS_CRITMULT4   = 0;

// Ability Bonuses: Armor and Amulets can have up to +4 craftable
const int SMS_ABILITY_MAX   = 4;            // ABILITY MAX

// Skills
const int SMS_SKILL_MAX   = 2;    // MAX POINTS FOR EACH SKILL
const int SMS_SKILL_COUNT = 1;      // # OF SKILL TYPES PER ITEM (=MAX FOR AS MANY AS POINTS)

// Regeneration
const int SMS_REGEN_MAIN_ITEM           = BASE_ITEM_RING;
const int SMS_REGEN_MAIN_ITEM_MAX       = 3;           // PRIMARY ITEM ABILITY MAX
const int SMS_REGEN_OTHER_ITEM_MAX      = 0;             // OTHER ITEM ABILITY MAX
const string SMS_REGEN_MAIN_ITEM_STRING = "Rings";

// Spell Resistance
const int    SMS_SPELL_RESISTANCE_MAIN_ITEM = BASE_ITEM_RING;
const int    SMS_SPELL_RESISTANCE_MAX = IP_CONST_SPELLRESISTANCEBONUS_24;
const string SMS_SPELL_RESISTANCE_MAIN_ITEM_STRING = "Rings";

// Saves -
//    No Universal
//    Specific (Fort, Reflex, Will) on Rings only, Fort comes with -Death to balance
//    Vs Saves can go anywhere
const int    SMS_SAVE_BIG3_COUNT = 2;                                // # OF SAVE ALLOW PER ITEM
const int    SMS_SAVE_BIG3_MAIN_ITEM = BASE_ITEM_RING;               // PRIMARY ITEM FOR SPECIFIC SAVE
const int    SMS_SAVE_BIG3_MAIN_ITEM_MAX = 3;                        // MAX SAVE PER SAVE SPECIFIC
const string SMS_SAVE_BIG3_MAIN_ITEM_STRING = "Rings";

const int    SMS_SAVE_VS_COUNT = 1;                                      // # OF SAVE ALLOW PER ITEM
const int    SMS_SAVE_VS_MAIN_ITEM = BASE_ITEM_RING;                     // PRIMARY ITEM FOR VS SAVE (BASE_ITEM_INVALID = ANY)
const int    SMS_SAVE_VS_MAIN_ITEM_MAX = 3;                              // MAX SAVE VS PER SAVE TYPE (0 TO DISABLE)
const int    SMS_SAVE_VS_OTHER_ITEM_MAX = 0;
const string SMS_SAVE_VS_MAIN_ITEM_STRING = "Rings";

const int    SMS_SPELLSLOTS_MAX   = 1;                                 // TOTAL SUM OF SLOTS
const int    SMS_SPELLSLOTS_COUNT = 1;                                 // TOTAL # OF SLOTS

   // Miscellaneous
const int    SMS_MIGHTY_MAX = 6;
const int    SMS_VAMP_REGEN_MAX = 1;
const int    SMS_ON_HIT_DC_MAX = IP_CONST_ONHIT_SAVEDC_14;

const int IPRP_FEAT_UNCANNYDODGE1 = 800;
const int IPRP_FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING = 801;
const int IPRP_FEAT_TRACKLESSSTEP = 802;
const int IPRP_FEAT_EPIC_SUPERIOR_INITIATIVE = 803;
const int IPRP_FEAT_IMPCRITCREATURE = 804;
const int IPRP_FEAT_WPNSPEC_CREATURE = 805;
const int IPRP_FEAT_EPICWPNFOC_CREATURE = 806;
const int IPRP_FEAT_EPICWPNSPEC_CREATURE = 807;
const int IPRP_FEAT_EPICOVERWHELMCRIT_CREATURE = 808;
const int IPRP_FEAT_GHOST_WARRIOR = 809;
const int IPRP_FEAT_DARKVISION = 810;
const int IPRP_FEAT_PRACTICED_INVOKER = 811;
const int IPRP_FEAT_LOWLIGHTVISION = 812;
const int IPRP_FEAT_RESCUE = 813;

// IPRP_ONHITSPELL CONSTANTS - MAPS INTO IPRP_ONHITSPELL.2DA

const int   IP_CONST_ONHIT_CASTSPELL_FREEZING_CURSE_HIT = 200; // <--- THIS ONE IS BEING USED

const int   IP_CONST_ONHIT_CASTSPELL_CLOAK_CHAOS_HIT    =   201;
const int   IP_CONST_ONHIT_CASTSPELL_HOLY_AURA_HIT  =   202;
const int   IP_CONST_ONHIT_CASTSPELL_SHIELD_LAW_HIT =   203;
//const int   IP_CONST_ONHIT_CASTSPELL_UNHOLY_AURA_HIT    =   204;
const int   IP_CONST_ONHIT_CASTSPELL_RIGHTEOUS_FURY_HIT =   205;