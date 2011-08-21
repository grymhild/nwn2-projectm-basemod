/** @file
* @brief Magic Related Constants
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/

#include "_CSLCore_Math_c"

/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

/********************************************************************************************************/
/** @name SubSchool Constants
* School and Subschool Constants
********************************************************************************************************* @{ */

// could add more to cover more cases ( hostile, buff, non-hostile or perhaps the other things i always want to know )
// the schools are defined in nwscript, subschools are bit based since a spell can be in multiple groups at the same time
// Addtitional subschools are defined in http://www.giantitp.com/forums/showthread.php?t=99708, this helps scripts and only applies to ones that don't have a school
// note this project http://pcgen.sourceforge.net/autobuilds/pcgen-docs/listfilepages/lstfileclass/lfc_lesson07_spells.html

const int SPELL_SCHOOL_NONE  = -1;
//int SPELL_SCHOOL_GENERAL  = 0;
const int SPELL_SUBSCHOOL_NONE = BIT0;
//int SPELL_SCHOOL_ABJURATION = 1;
//int SPELL_SCHOOL_CONJURATION  = 2;
const int SPELL_SUBSCHOOL_CALLING = BIT1;
const int SPELL_SUBSCHOOL_CREATION  = BIT2;
const int SPELL_SUBSCHOOL_HEALING = BIT3;
const int SPELL_SUBSCHOOL_SUMMONING = BIT4;
const int SPELL_SUBSCHOOL_TELEPORTATION = BIT5;
const int SPELL_SUBSCHOOL_WILD = BIT6;
const int SPELL_SUBSCHOOL_PACT = BIT7;
const int SPELL_SUBSCHOOL_DJINN = BIT8;
//int SPELL_SCHOOL_DIVINATION = 3;
const int SPELL_SUBSCHOOL_SCRYING = BIT9;
const int SPELL_SUBSCHOOL_NAMING = BIT10;
//int SPELL_SCHOOL_ENCHANTMENT  = 4;
const int SPELL_SUBSCHOOL_CHARM = BIT11;
const int SPELL_SUBSCHOOL_COMPULSION  = BIT12;
const int SPELL_SUBSCHOOL_PSIONIC = BIT13;
//int SPELL_SCHOOL_EVOCATION  = 5;
const int SPELL_SUBSCHOOL_ELEMENTAL = BIT25;
//int SPELL_SCHOOL_ILLUSION = 6;
const int SPELL_SUBSCHOOL_FIGMENT  = BIT14;
const int SPELL_SUBSCHOOL_GLAMER  = BIT15;
const int SPELL_SUBSCHOOL_PATTERN = BIT16;
const int SPELL_SUBSCHOOL_PHANTASM  = BIT17;
const int SPELL_SUBSCHOOL_SHADOW  = BIT18;
//int SPELL_SCHOOL_NECROMANCY = 7;
const int SPELL_SUBSCHOOL_CURSE = BIT19;
const int SPELL_SUBSCHOOL_BLOOD = BIT20;
const int SPELL_SUBSCHOOL_INCARNUM = BIT22;
const int SPELL_SUBSCHOOL_ANIMATE = BIT23;
//int SPELL_SCHOOL_TRANSMUTATION  = 8;
const int SPELL_SUBSCHOOL_POLYMORPH = BIT24;
const int SPELL_SUBSCHOOL_FLESH = BIT25;
const int SPELL_SUBSCHOOL_CHRONOS = BIT26; // for haste, slow and the like

const int SPELL_SUBSCHOOL_PLUMA = BIT27;
const int SPELL_SUBSCHOOL_HISHNA = BIT28; // 29 30 31

const int SPELL_SCHOOL_ELDRITCH  = 9;


// could add more to cover more cases ( hostile, buff, non-hostile or perhaps the other things i always want to know )
// the schools are defined in nwscript, subschools are bit based since a spell can be in multiple groups at the same time
// Addtitional subschools are defined in http://www.giantitp.com/forums/showthread.php?t=99708, this helps scripts and only applies to ones that don't have a school
// note this project http://pcgen.sourceforge.net/autobuilds/pcgen-docs/listfilepages/lstfileclass/lfc_lesson07_spells.html

int SCMETA_ATTRIBUTES_NONE					= BIT0;
// Type of magic involved
int SCMETA_ATTRIBUTES_MAGICAL				= BIT1; // Spell is affected by antimagic
int SCMETA_ATTRIBUTES_EXTRAORDINARY			= BIT2; // Spell is not removed on rest or dispel
int SCMETA_ATTRIBUTES_SUPERNATURAL			= BIT3; // Spell is not removed on dispel
int SCMETA_ATTRIBUTES_MISCELLANEOUS			= BIT4; // Spell is not really magic, but rather a natural ability
// These are hints, its really more about the class but that does not always work
int SCMETA_ATTRIBUTES_ARCANE				= BIT5; // Spell is external-arcane in nature-used in class lookups-or used as arcane if class is not known
int SCMETA_ATTRIBUTES_DIVINE				= BIT6; // Spell is external-from a god, divine in nature-used in class lookups-or used as divine if class is not known
int SCMETA_ATTRIBUTES_INTERNAL				= BIT7; // Spell is internal power, psionic, incarnum, emanates from the caster, again for class lookups
// The components required, less expensive to store it all here
int SCMETA_ATTRIBUTES_SOMANTICCOMP			= BIT8;
int SCMETA_ATTRIBUTES_VOCALCOMP				= BIT9;
int SCMETA_ATTRIBUTES_MATERIALCOMP			= BIT10;
int SCMETA_ATTRIBUTES_FOCUSCOMP				= BIT11;
// Other needed attributes, mainly for where things can be cast
int SCMETA_ATTRIBUTES_BUFF					= BIT12; // says if the spell is a buff ( if you buff an opponent to lower their defenses they get a save )
int SCMETA_ATTRIBUTES_RESTORATIVE			= BIT13; // spell is healing and or defensive in nature
int SCMETA_ATTRIBUTES_HOSTILE				= BIT14; // spell is a hostile act - 
int SCMETA_ATTRIBUTES_TURNABLE				= BIT15; // spell is turnable
int SCMETA_ATTRIBUTES_CANTCASTINTOWN		= BIT16; // you can't cast spell in town, for PW's
int SCMETA_ATTRIBUTES_CANTCASTUNDERWATER	= BIT17; // you can't cast spell underwater (grimoire idea)

//@} ****************************************************************************************************

/********************************************************************************************************/
/** @name Negative Effect Constants to support restoration line of spells, freedom of movement and the like
* Description
********************************************************************************************************* @{ */
const int NEGEFFECT_NONE = BIT0;
const int NEGEFFECT_DISEASE = BIT1;
const int NEGEFFECT_POISON = BIT2;
const int NEGEFFECT_CURSE = BIT3;
const int NEGEFFECT_MENTAL = BIT4;
const int NEGEFFECT_TEMPORARYABILITY = BIT5;
const int NEGEFFECT_ABILITY = BIT6;
const int NEGEFFECT_LEVEL = BIT7;
const int NEGEFFECT_MOVEMENT = BIT8;
const int NEGEFFECT_COMBAT = BIT9;
const int NEGEFFECT_PETRIFY = BIT10;
const int NEGEFFECT_PERCEPTION = BIT11;
const int NEGEFFECT_SLOWED = BIT12;
const int NEGEFFECT_SLEEP = BIT13;
const int NEGEFFECT_OTHER = BIT31;
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Utility Constants
* Description
********************************************************************************************************* @{ */
const int SC_REMOVE_FIRSTONLYCREATOR = 1;
const int SC_REMOVE_ONLYCREATOR = 2;
const int SC_REMOVE_FIRSTALLCREATORS = 3;
const int SC_REMOVE_ALLCREATORS = 4;

// * see CSLSpellsIsTarget for a definition of these constants
const int SCSPELL_TARGET_ALLALLIES = 1;
const int SCSPELL_TARGET_STANDARDHOSTILE = 2;
const int SCSPELL_TARGET_SELECTIVEHOSTILE = 3;
const int SCSPELL_TARGET_ALL = 5;

// Placeholders
const int SAVING_THROW_TYPE_XXXX = -1;
const int VFX_XXXX = -1;
const int DAMAGE_TYPE_XXXX = -1;

const int SCSTR_REF_FEEDBACK_SPELL_FAILED	= 3734;
const int SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET    = 83384;

// For AOE Tag Positions
const int SCSPELLTAG_NAME = 1;
const int SCSPELLTAG_SPELLID = 2;
const int SCSPELLTAG_CASTERPOINTER = 3;
const int SCSPELLTAG_CASTERCLASS = 4;
const int SCSPELLTAG_CASTERLEVEL = 5;
const int SCSPELLTAG_SPELLLEVEL = 6;
const int SCSPELLTAG_SPELLPOWER = 7;
const int SCSPELLTAG_METAMAGIC = 8;
const int SCSPELLTAG_DESCRIPTOR = 9;
const int SCSPELLTAG_SPELLSAVEDC = 10;
const int SCSPELLTAG_SPELLRESISTDC = 11;
const int SCSPELLTAG_SPELLDISPELDC = 12;
const int SCSPELLTAG_SPELLSCHOOL = 13;
const int SCSPELLTAG_ENDINGROUND = 14;
const int SCSPELLTAG_RAND = 15;

const int FEAT_TIRELESS = 3846;

const int SC_EVENT_CONCENTRATION_BROKEN = 12400;

//#include "nwscript"
//include 

const float RADIUS_SIZE_INNERVATE_SPEED = 30.48f;

const int SC_DURCATEGORY_SECONDS = 1; // 1 second
const int SC_DURCATEGORY_ROUNDS = 2; // 6 seconds
const int SC_DURCATEGORY_MINUTES = 3; // one minute - 60 seconds - 1 turn
const int SC_DURCATEGORY_TENMINUTES = 4; // ten minutes - 600 seconds - 10 turns
const int SC_DURCATEGORY_HOURS = 5; // hour - 60 minutes - 3600 seconds = 60 turns
const int SC_DURCATEGORY_DAYS = 6; // 24 hours


const int SC_SHAPE_NONE = 0;
const int SC_SHAPE_SPELLCYLINDER = 1; // consider extending these soas to allow varied sizes as well
const int SC_SHAPE_AOE = 2;
const int SC_SHAPE_AOEEXPLODE = 3;
const int SC_SHAPE_BREATHCONE = 4;
const int SC_SHAPE_SPELLCONE = 5;
const int SC_SHAPE_BEAM = 6;
const int SC_SHAPE_MIRV = 7;
const int SC_SHAPE_CUBE = 8;
const int SC_SHAPE_WALL = 9;
const int SC_SHAPE_CLOUD = 10;
const int SC_SHAPE_AURA = 11;
const int SC_SHAPE_CONTDAMAGE = 12;
const int SC_SHAPE_IMPACT = 13;
const int SC_SHAPE_SHIELD = 14;

const int SC_SHAPE_SPELLWEAP_SPEAR = 15;
const int SC_SHAPE_SPELLWEAP_SWORD = 16;
const int SC_SHAPE_SPELLWEAP_HAMMER = 17;
const int SC_SHAPE_SPELLWEAP_DAGGER = 18;
const int SC_SHAPE_SPELLWEAP_MACE = 19;
const int SC_SHAPE_SPELLWEAP_TRIDENT = 20;
const int SC_SHAPE_SPELLWEAP_GLAIVE = 21;
const int SC_SHAPE_SPELLWEAP_PITCHFORK = 22;
const int SC_SHAPE_SPELLWEAP_SCYTHE = 23;
const int SC_SHAPE_SPELLWEAP_BATTLEAXE = 24;
const int SC_SHAPE_SPELLWEAP_BOW = 25;
const int SC_SHAPE_SPELLWEAP_SHIELD = 26;
const int SC_SHAPE_SPELLWEAP_ARMOR = 27;
const int SC_SHAPE_SPELLWEAP_WHIP = 28;

const int SC_SHAPE_SHORTCONE = 29; // renumber these later
const int SC_SHAPE_FAERYAURA = 30;

const int SC_DELIM_NOT_FOUND = -1;

// Magical aura strength constants - based on jailiax
const int SC_AURASTRENGTH_NONE			= 0;
const int SC_AURASTRENGTH_FAINT			= 1;
const int SC_AURASTRENGTH_MODERATE		= 2;
const int SC_AURASTRENGTH_STRONG		= 3;
const int SC_AURASTRENGTH_OVERWHELMING	= 4;

// Spell range type constants
const int JX_SPELLRANGE_INVALID  = 0;
const int JX_SPELLRANGE_SHORT    = 1;
const int JX_SPELLRANGE_MEDIUM   = 2;
const int JX_SPELLRANGE_LONG     = 3;
const int JX_SPELLRANGE_PERSONAL = 4;
const int JX_SPELLRANGE_TOUCH    = 5;



const int SC_TOUCH_UNKNOWN = 0;
const int SC_TOUCH_MELEE = 1; // prc XXTOUCH_ATTACK_MELEE
const int SC_TOUCH_RANGED = 2; //  prc XXTOUCH_ATTACK_RANGED
const int SC_TOUCHSPELL_MELEE = 3; // prc  XXTOUCH_ATTACK_MELEE_SPELL
const int SC_TOUCHSPELL_RANGED = 4; // prc  XXTOUCH_ATTACK_RANGED_SPELL
const int SC_TOUCHSPELL_RAY = 5;


// This configures the progression, just use the above constants to adjust the following





const int INT_CASTER = 1;
const int CHA_CASTER = 2;
const int WIS_CASTER = 3;

const int ELEMENTAL_TYPE_AIR = 0;
const int ELEMENTAL_TYPE_EARTH = 1;
const int ELEMENTAL_TYPE_FIRE = 2;
const int ELEMENTAL_TYPE_WATER = 3;


// Do a Spell Resistance check between oCaster and oTarget, returning TRUE if
// the spell was resisted. These replace the normal constants defined by OEI
const int SC_SR_SPELL_WORKED = 0;
const int SC_SR_SPELL_RESISTED = 1;
const int SC_SR_SPELL_IMMUNITY = 2;
const int SC_SR_SPELL_ABSORBED = 3;
const int SC_SR_SPELL_COUNTERSONGED = 4;
const int SC_SR_SPELL_TURNED = 5;



// Spell type constants ( based on Spell Casting Framework )
// these are going to be bit math, so if something is arcane and divine it is a 3
// Blackguard is divine, assasin, bard are arcane
const int SC_SPELLTYPE_INVALID = -1;
const int SC_SPELLTYPE_NONE = 0;
const int SC_SPELLTYPE_ARCANE = 1;
const int SC_SPELLTYPE_DIVINE = 2;
const int SC_SPELLTYPE_ELDRITCH = 4; // warlocks
const int SC_SPELLTYPE_PSIONIC = 8; // psion, just in case
const int SC_SPELLTYPE_BOTH = 3; // for both arcane and divine


//const int SC_SPELLTYPE_ARCANE = 1;
//const int SC_SPELLTYPE_DIVINE = 2;
//const int SC_SPELLTYPE_ELDRITCH = 4; // warlocks
//const int SC_SPELLTYPE_PSIONIC = 8; // psion, just in case

const int SCRACE_ELEMENTALTYPE_NONE = 0;
const int SCRACE_ELEMENTALTYPE_FIRE = 1;
const int SCRACE_ELEMENTALTYPE_WATER = 2;
const int SCRACE_ELEMENTALTYPE_EARTH = 3;
const int SCRACE_ELEMENTALTYPE_AIR = 4;



 // Size Categories ( integer values from the PRC )
const int CREATURE_SIZE_FINE = 20;
const int CREATURE_SIZE_DIMINUTIVE = 21;
//int CREATURE_SIZE_INVALID = 0;
//int CREATURE_SIZE_TINY =    1;
//int CREATURE_SIZE_SMALL =   2;
//int CREATURE_SIZE_MEDIUM =  3;
//int CREATURE_SIZE_LARGE =   4;
//int CREATURE_SIZE_HUGE =    5;
const int CREATURE_SIZE_GARGANTUAN = 22;
const int CREATURE_SIZE_COLOSSAL =23;


const int SPELL_NONMAGICLIGHT = -100;
const int SPELL_FORCEINVALID = -2;


const string SCVAR_IMMUNE_TO_HEAL = "IMMUNE_TO_HEAL";


const int METAMAGIC_INVOC_UNDBANE_BLAST = BIT25;
const int METAMAGIC_INVOC_REPELL_BLAST = BIT26;
const int METAMAGIC_INVOC_TEMPEST_BLAST = BIT27;

//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Feats
* Description
********************************************************************************************************* @{ */
const int FEAT_COUNTERSPELL = 5951;

const int FEAT_SCPRACTICED_SPELLCASTER_FAVORED_SOUL = 2068;
const int FEAT_SCPRACTICED_SPELLCASTER_SPIRIT_SHAMAN = 2003;

int FEAT_EPIC_AUTOMATIC_QUICKEN_4 = 1918;
int	FEAT_EPIC_AUTOMATIC_QUICKEN_5 = 1919;
int	FEAT_EPIC_AUTOMATIC_QUICKEN_6 = 1920;
int	FEAT_EPIC_AUTOMATIC_QUICKEN_7 = 1921;
int	FEAT_EPIC_AUTOMATIC_QUICKEN_8 = 1922;
int	FEAT_EPIC_AUTOMATIC_QUICKEN_9 = 1923;


const int FEAT_PRACTICAL_METAMAGIC_CHAIN_SPELL = 3536;
const int FEAT_PRACTICAL_METAMAGIC_EXTEND_SPELL = 3537;
const int FEAT_PRACTICAL_METAMAGIC_SILENT_SPELL = 3538;
const int FEAT_PRACTICAL_METAMAGIC_STILL_SPELL = 3539;
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Polymorph
* Description
********************************************************************************************************* @{ */
const int WORD_OF_CHANGING_HORNED_DEVIL = 201;

const int POLYMORPH_WILDSHAPE_TYPE_PANTHER = 162;
const int POLYMORPH_WILDSHAPE_TYPE_DIRE_PANTHER = 163;
const int POLYMORPH_TYPE_EMBER_GUARD = 164;
const int POLYMORPH_TYPE_HELLCAT = 166;

const int DRAGONSHAPE_RED_DRAGON_25 = 167;
const int DRAGONSHAPE_RED_DRAGON_28 = 168;
const int DRAGONSHAPE_RED_DRAGON_30 = 169;
const int DRAGONSHAPE_BLUE_DRAGON_24 = 170;
const int DRAGONSHAPE_BLUE_DRAGON_27 = 171;
const int DRAGONSHAPE_BLUE_DRAGON_30 = 172;
const int DRAGONSHAPE_BLACK_DRAGON_25 = 173;
const int DRAGONSHAPE_BLACK_DRAGON_28 = 174;
const int DRAGONSHAPE_BLACK_DRAGON_30 = 175;

const int WORD_OF_CHANGING_PIT_FIEND = 179;
const int WORD_OF_CHANGING_HEZEBEL = 180;
//@} ****************************************************************************************************

/********************************************************************************************************/
/** @name Area of Effects
* Description
********************************************************************************************************* @{ */
// Needed to add support for more wall types, mainly recolored them
// AOE_PER_WALLFIRE = 5;
const int AOE_PER_WALLELECTRICAL = 100;	//VFX_PER_WALLELECTRICAL
const int AOE_PER_WALLACID = 101;	//VFX_PER_WALLACID
const int AOE_PER_WALLCOLD = 102;	//VFX_PER_WALLCOLD
const int AOE_PER_WALLSONIC = 103;	//VFX_PER_WALLSONIC
const int AOE_PER_WALLPOSITIVE = 104;	//VFX_PER_WALLPOSITIVE
const int AOE_PER_WALLNEGATIVE = 105;	//VFX_PER_WALLNEGATIVE

const int AOE_PER_RADFIRE = 180;
const int AOE_PER_RADELECTRICAL = 181;
const int AOE_PER_RADACID = 182;
const int AOE_PER_RADCOLD = 183;
const int AOE_PER_RADSONIC = 184;
const int AOE_PER_RADPOSITIVE = 185;
const int AOE_PER_RADNEGATIVE = 186;
const int AOE_PER_RADMAGIC = 187;

// AOE EFFECTS - MAPS INTO VFX PERSISTANT
const int VFX_PER_WIDEN_AURA_OF_DESPAIR = 81;
const int VFX_PER_PRC_DARKNESS = 82;
const int VFX_MOB_PRC_CIRCEVIL = 83;
const int VFX_PER_NI_TEAMWORK = 84;
const int VFX_PER_NE_TEAMWORK = 85;
const int VFX_PER_DC_TEAMINIT = 86;
const int VFX_PER_STORMSINGER_STORM = 87;
const int VFX_PER_RADIANT_AURA = 88;
const int VFX_PER_BREAK_CONC = 89;
const int VFX_PER_CAUSTIC_WEB = 90;
const int VFX_MOB_LESSER_AURA_COLD = 91;
const int VFX_PER_BRIAR_WEB = 92;
const int VFX_PER_TRIP_VINE = 93;

const int   AOE_PLANARTEAR_FIRE = 110;
const int   AOE_PLANARTEAR_ELECTRICAL = 111;
const int   AOE_PLANARTEAR_ACID = 112;
const int	AOE_PLANARTEAR_COLD = 113;
const int   AOE_PLANARTEAR_SONIC = 114;
const int   AOE_PLANARTEAR_POSITIVE = 115;
const int   AOE_PLANARTEAR_NEGATIVE = 116;
const int   AOE_PLANARTEAR_MAGIC = 117;
const int   AOE_PLANARTEAR_SAND = 118;
const int   AOE_PLANARTEAR_SNOW = 119;
const int   AOE_PLANARTEAR_FLOOD = 120;
const int   AOE_PLANARTEAR_HEAVEN = 121;
const int   AOE_PLANARTEAR_HELL = 122;

// need to play test sizes
const int   AOE_CHARGE_SMALL = 124; // 1 meter wide, perhaps for a human sized creature
const int   AOE_CHARGE_MEDIUM = 125;// 2 meter wide, perhaps for a Large sized creature ( hill giants and ogres )
const int   AOE_CHARGE_LARGE = 126; // 3 meter wide, perhaps larger for a very large creature ( T rex )

// These are under review, from syrus for importing on some of them
const int   AOE_PER_BLACKLIGHT  =   127 ;
const int   AOE_PER_WALL_OF_ICE =   128 ;
const int   AOE_MOB_FILTER  =   129 ;

const int   AOE_MOB_ARMOR_UNDEATH   =   131 ;
const int   AOE_MOB_BLACKFLAME  =   132 ;
const int   AOE_MOB_CLOAK_RIGHT =   133 ;
const int   AOE_MOB_COMP_STRIFE =   134 ;
const int   AOE_MOB_LOV_TORM    =   135 ;
const int   AOE_PER_ALARM   =   136 ;
const int   AOE_PER_TALOS_WRATH =  137 ;
const int   AOE_MOB_PURIFY_FLAMES   =   138 ;
const int   AOE_MOB_REPEL_VERMIN    =   139 ; 
const int   AOE_MOB_FLENSING    =   140 ;
const int   AOE_PER_BLOODSTORM  =   141 ;
const int   AOE_MOB_GAZE_PETRIFY    =   142 ;
const int   AOE_MOB_ANTILIFE_SHELL  =   143 ;
const int   AOE_MOB_CORPSE_VISAGE   =   144 ;
const int   AOE_PER_FOGSTINKSINGLE  =   145 ;
const int   AOE_PER_IGEDRAZAARS_MIASMA  =   146 ;
const int   AOE_PER_FORCEWARD   =   147 ;
const int   AOE_PER_GLITTERDUST =   148 ;
const int   AOE_PER_ACID_STORM  =   149 ;
const int   AOE_PER_CONSECRATE  =   150 ;
const int   AOE_PER_DESECRATE   =   151 ;
const int   AOE_PER_ETHEREAL_BARRIER    =   152 ;
const int   AOE_MOB_DEEPER_DARKNESS =   153 ;
const int   AOE_PER_WALLSOUND   =   154 ;
const int   AOE_PER_WALLSND_DEAF    =   155 ;
const int   AOE_PER_WALLSND_SNDBLK  =   156 ;
const int   AOE_PER_MIN_MALISON =   157 ;
const int   AOE_MOB_FIRE_AURA   =   158 ;
const int   AOE_MOB_LIGHT =   159 ;
const int   AOE_MOB_SPIRIT_WORM =   160 ;
const int   AOE_MOB_DAYLIGHT    =   161 ;
const int   AOE_CUSTOM_10FT_RAD =   162 ;
const int   AOE_CUSTOM_15FT_RAD =   163 ;
const int   AOE_CUSTOM_20FT_RAD =   164 ;
const int   AOE_CUSTOM_30FT_RAD =   165 ;
const int   AOE_CUSTOM_SMALL    =   166 ;
const int   AOE_CUSTOM_MEDIUM   =   167 ;
const int   AOE_CUSTOM_LARGE    =   168 ;
const int   AOE_CUSTOM_HUGE =   169 ;
const int   AOE_CUSTOM_COLOSSAL =   170 ;
const int   AOE_CUSTOM_GARGANTUAN   =   171 ;
//const int   AOE_MOB_BROT_ARMS   =   135 ;
//const int   AOE_MOB_DETECT_DISEASE  =   138 ;
//const int   AOE_MOB_FREEZE_CURSE    =   139 ;
//const int   AOE_MOB_EMOTION_DESPAIR =   177 ;
//const int   AOE_MOB_EMOTION_FEAR    =   178 ;
//const int   AOE_MOB_EMOTION_HOPE    =   179 ;
//const int   AOE_MOB_EMOTION_RAGE    =   180 ;
//const int   AOE_MOB_FINDTRAPS   =   181 ;
//const int   AOE_PER_SPIKEGROWTH =   182 ;
//const int   AOE_MOB_MELFS_ACID_ARROW    =   183 ;
//const int   AOE_PER_BIGBYS  =   184 ;
//const int   AOE_MOB_INFERNO =   185 ;
//const int   AOE_MOB_INFESTATION_OF_MAGGOTS  =   186 ;
//const int   AOE_MOB_COMBUST =   187 ;
//const int   AOE_MOB_HEMORRHAGE  =   188 ;
//const int   AOE_MOB_LIGHT   =   190 ;
//const int   AOE_MOB_IMPROVED_INVISIBILITY   =   192 ;
//const int   AOE_PER_BREATH_JUNGLE   =   193 ;


// prc related constants, need to prune these down
const int AOE_MOB_PESTILENCE                    = 291;
const int AOE_PER_TELEPORTATIONCIRCLE           = 292;
const int AOE_PER_DEEPER_DARKNESS               = 328;

const int AOE_PER_FOGCLOUD    					= 130; ////// 984
const int AOE_PER_OBSCURING_MIST                = 283; ////// 984
const int AOE_PER_SOLID_FOG                     = 320; //////

const int AOE_PER_ACHAIERAI                     = 327;
const int AOE_PER_UTTERDARK                     = 326;
const int AOE_PER_DAMNDARK                      = 324;
const int VFX_MOB_BRILLIANT_EMANATION           = 325;
const int AOE_PER_BLNDGLORY                     = 323;
const int VFX_AOE_RAIN_OF_BLACK_TULIPS          = 322;
const int VFX_AOE_RAIN_OF_ROSES                 = 321;

const int AOE_PER_REPULSION                     = 319;
const int AOE_PER_CALM_EMOTIONS                 = 318;

// Psionic Area of Effects
const int AOE_PER_PSIGREASE                     = 273;
const int AOE_PER_ESHAMBLER                     = 274;
const int AOE_PER_ENERGYWALL                    = 275;
const int AOE_MOB_CATAPSI                       = 276;
const int AOE_PER_NULL_PSIONICS_FIELD           = 277;
const int AOE_MOB_FORM_DOOM                     = 278;
const int AOE_PER_ENERGYWALL_WIDENED            = 279;
const int AOE_PER_ESHAMBLER_WIDENED             = 280;
const int AOE_PER_NULL_PSIONICS_FIELD_WIDENED   = 281;
const int VFX_PER_NEW_TIMESTOP                  = 282;


// Invisible Area of Effects
const int VFX_PER_5_FT_INVIS                    = 376;
const int VFX_PER_10_FT_INVIS                   = 377;
const int VFX_PER_15_FT_INVIS                   = 378;
const int VFX_PER_20_FT_INVIS                   = 379;
const int VFX_PER_25_FT_INVIS                   = 380;
const int VFX_PER_30_FT_INVIS                   = 381;
const int VFX_PER_5M_INVIS                      = 387;
const int VFX_PER_10M_INVIS                     = 388;
const int VFX_PER_15M_INVIS                     = 389;
const int VFX_PER_20M_INVIS                     = 390;
const int VFX_PER_25M_INVIS                     = 391;
const int VFX_PER_30M_INVIS                     = 392;
const int VFX_PER_35M_INVIS                     = 393;
const int VFX_PER_40M_INVIS                     = 394;
const int VFX_PER_45M_INVIS                     = 395;
const int VFX_PER_50M_INVIS                     = 396;

//@} ****************************************************************************************************

/********************************************************************************************************/
/** @name Visuals
* Description
********************************************************************************************************* @{ */
// This is conflicting, move to SC name space to keep it safe
const int VFX_SCFNF_SCREEN_SHAKE2 = 356;

const int VFXSC_PLACEHOLDER = 1800;
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Spells
* SPELLR_* are spells which exist in nwscript, but which i want to put on new rows
********************************************************************************************************* @{ */
const int SPELL_Tempest_Whirlwind = 1736;
const int SPELL_Tempest_Defense = 1737;
const int SPELL_Angelskin = 1738;
const int SPELL_Awaken_Sin = 1739;
const int SPELL_Blessed_Aim = 1740;
const int SPELL_Blessing_Bahumut = 1741;
const int SPELL_Blessing_Righteous = 1742;
const int SPELL_Castigate = 1743;
const int SPELL_Cloak_Bravery = 1744;
const int SPELL_Deafening_Clang = 1745;
const int SPELL_Draconic_Might = 1746;
const int SPELL_Lesser_Energized_Shield = 1747;
const int SPELL_Lesser_Energizedl_Shield_F = 1748;
const int SPELL_Lesser_Energized_Shield_C = 1749;
const int SPELL_Lesser_Energized_Shield_E = 1750;
const int SPELL_Lesser_Energized_Shield_A = 1751;
const int SPELL_Lesser_Energized_Shield_S = 1752;
const int SPELL_Energized_Shield = 1753;
const int SPELL_Energizedl_Shield_F = 1754;
const int SPELL_Energized_Shield_C = 1755;
const int SPELL_Energized_Shield_E = 1756;
const int SPELL_Energized_Shield_A = 1757;
const int SPELL_Energized_Shield_S = 1758;
const int SPELL_Flame_Faith = 1759;
const int SPELL_Hand_Divinity = 1760;
const int SPELL_Lawful_Sword = 1761;
const int SPELL_Righteous_Fury = 1764;
const int SPELL_Second_Wind = 1765;
const int SPELL_Shield_Warding = 1766;
const int SPELL_Silverbeard = 1767;
const int SPELL_Strategic_Charge = 1768;
const int SPELL_Strength_Stone = 1769;
const int SPELL_Undead_Bane_Weapon = 1770;
const int SPELL_Weapon_of_the_Deity = 1771;
const int SPELL_Zeal = 1772;
const int SPELL_Blood_of_the_Martyr = 1773;
const int SPELL_Righteous_Glory = 1774;

const int SPELL_Blasphemy = 1793;
const int SPELL_Holy_Word = 1794;
const int SPELL_Visage_Deity = 1795;
const int SPELL_Scourge = 1796;
const int SPELL_Domain_Inspire_Hatred = 1797;
const int SPELL_Domain_Mystic_Protection = 1798;
const int SPELL_Domain_Pain_Touch = 1799;
const int SPELL_Domain_Death_Touch = 1800;
const int SPELL_Lay_On_Hands_Hostilev1 = 1802;
const int SPELL_Chasing_Perfection = 1812;
const int SPELL_Sonic_Shield = 1813;
const int SPELL_Weapon_Energy = 1814;
const int SPELL_Weapon_Energy_F = 1815;
const int SPELL_Weapon_Energy_A = 1816;
const int SPELL_Weapon_Energy_C = 1817;
const int SPELL_Weapon_Energy_E = 1818;
const int SPELL_Inspirational_Boost = 1819;
const int SPELL_Lions_Roar = 1820;
const int SPELL_Living_Undeath = 1821;
const int SPELL_Natures_Favor = 1828;
const int SPELL_Resonating_Bolt = 1829;
const int SPELL_Sirines_Grace = 1830;
const int SPELL_Sonic_Weapon = 1831;
const int SPELL_Wild_Instinct = 1832;
const int SPELL_Nixies_Grace = 1833;

const int SPELL_Eldritch_Glaive = 1844;
const int SPELL_Faerie_Fire = 1857;
const int SPELL_Heartfire = 1858;   

const int SPELL_SCRIBESPELL = 3890;
const int SPELL_BREWPOTION = 3891;
const int SPELL_CRAFTWAND = 3892;

const int SPELL_CONTROLWEATHER = 3868;
const int SPELL_CONTROLWEATHER_RAINSTORM = 3869;
const int SPELL_CONTROLWEATHER_THUNDERSTORM = 3870;
const int SPELL_CONTROLWEATHER_SNOWSTORM = 3871;
const int SPELL_CONTROLWEATHER_SANDSTORM = 3872;
const int SPELL_CONTROLWEATHER_CALM = 3873;



const int SPELL_Orb_Acid = 1859;
const int SPELL_Orb_Sound = 1861;
const int SPELL_Orb_Force = 1863;
const int SPELL_Orb_Cold = 1825;
const int SPELL_Orb_Fire = 1826;
const int SPELL_Orb_Electricity = 1827;

const int SPELL_Lesser_Orb_Acid = 1860;
const int SPELL_Lesser_Orb_Sound = 1862;
const int SPELL_Lesser_Orb_Cold = 1822;
const int SPELL_Lesser_Orb_Fire = 1823;
const int SPELL_Lesser_Orb_Electricity = 1824;

const int SPELL_Plant_Body = 1950;
const int SPELL_Thorn_Skin = 1951;

const int SPELL_I_DARK_PREMONITION = 838; // replaces SPELL_I_DARK_FORESIGHT due to kaedrins name change
const int SPELL_I_DARKFORESIGHT = 2069;

const int SPELL_I_IGNOREPYRE = 2071;
const int SPELL_I_INSTILLVULN = 2078;
const int SPELL_I_UNDEADBANEBLST = 2077;
const int SPELL_I_HELLSPAWNGRACE = 2070;
const int SPELL_I_CASTERS_LAMENT = 2091; //

const int Ignore_The_Pyre_A = 2072;
const int Ignore_The_Pyre_C = 2073;
const int Ignore_The_Pyre_E = 2074;
const int Ignore_The_Pyre_F = 2075;
const int Ignore_The_Pyre_S = 2076;

const int Instill_Vulnerability = 2078;
const int Instill_Vuln_A = 2079;
const int Instill_Vuln_C = 2080;
const int Instill_Vuln_E = 2081;
const int Instill_Vuln_F = 2082;
const int Instill_Vuln_S = 2083;

const int SPELL_I_REPELL_BLAST = 2086;
const int SPELL_I_TEMPEST_BLAST = 2087;

const int SPELL_I_FRIGHTFUL_PRESENCE = 2090;
const int SPELL_I_CAUSTIC_MIRE = 2092; //
const int SPELL_BRIAR_WEB = 2097;
const int SPELL_TRIP_VINE = 2102;


const int SPELL_FAERIE_FIRE_PURPLE = 3880;
const int SPELL_FAERIE_FIRE_BLUE = 3881;
const int SPELL_FAERIE_FIRE_GREEN = 3882;

const int SPELL_BALEFUL_BLINK = 2127;
const int SPELL_PRIMAL_SENSES = 2126;
const int SPELL_PRIMAL_SPEED = 2116;
const int SPELL_PRIMAL_INSTINCTS = 2125;
const int SPELL_PRIMAL_HUNTER = 2124;
const int SPELL_SPIRIT_WOLF = 2123;
const int SPELL_SPIRIT_TIGER = 2122;
const int SPELL_SPIRIT_RAT = 2121;
const int SPELL_SPIRIT_BOAR = 2120;
const int SPELL_SPIRIT_BEAR = 2119;
const int SPELL_MANTLE_FAITH = 2118;
const int SPELL_MARK_DOOM = 2117;
const int SPELL_INSIGNIA_WARDING = 2115;
const int SPELL_INSIGNIA_HEALING = 2114;
const int SPELL_INSIGNIA_BLESSING = 2113;
const int SPELL_GLORY_MARTYR = 2112;
const int SPELL_BENEDICTION = 2111;
const int SPELL_FAVOR_MARTYR = 2110;
const int SPELL_SEED_LIFE = 2109;
const int SPELL_SACRED_HAVEN = 2108;
const int SPELL_FLAMEBOUND_WEAPON = 2107;
const int SPELL_MANIFEST_LIFE = 2106;
const int SPELL_MANIFEST_DEATH = 1732;
const int SPELL_DIVINE_PROTECTION = 2105;
const int SPELL_SWIFT_HASTE = 2103;
const int SPELL_HAWKEYE = 2101;
const int SPELL_LINKED_PERCEPTION = 2100;
const int SPELL_EMBRACE_WILD = 2099;
const int SPELL_LESSER_AURA_COLD = 2098;
const int SPELL_SKIN_CACTUS = 2096;
const int SPELL_HALO_SAND = 2095;
const int SPELL_ENRAGE_ANIMAL = 2094;
const int SPELL_SPLINTERBOLT = 2088;





/// added these, these were missing from kaedrins constants
const int SPELL_LEONALS_ROAR = 1914;
const int SPELL_LIVEOAK = 1928;

const int SPELL_PHANTOMBEAR = 1930;
const int SPELL_PHANTOMWOLF = 1931;


const int SPELL_LESSER_DISPEL_FRIEND = 1845;
const int SPELL_LESSER_DISPEL_HOSTILE = 1846;
const int SPELL_LESSER_DISPEL_AOE = 1847;
const int SPELL_DISPEL_MAGIC_FRIEND = 1848;
const int SPELL_DISPEL_MAGIC_HOSTILE = 1849;
const int SPELL_DISPEL_MAGIC_AOE = 1850;
const int SPELL_GREATER_DISPELLING_FRIEND = 1851;
const int SPELL_GREATER_DISPELLING_HOSTILE = 1852;
const int SPELL_GREATER_DISPELLING_AOE = 1853;
const int SPELL_MORDENKAINENS_DISJUNCTION_FRIEND = 1854;
const int SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE = 1855;
const int SPELL_MORDENKAINENS_DISJUNCTION_AOE = 1856;
const int SPELL_SILENCE_FRIEND = 3801;
const int SPELL_SILENCE_HOSTILE = 3802;
const int SPELL_SILENCE_AOE = 3803;



const int SPELL_ARCANE_LOCK = 3804;
const int SPELL_CHAIN_MISSLE = 3810;
const int SPELL_CHAIN_DISPEL = 3811;
const int SPELL_REAVING_DISPEL = 3867;
const int SPELL_SHIELDIMPROVED = 3812; // Improved_Shield
const int SPELL_DISRUPT_UNDEAD = 3813; // Disrupt_Undead
const int SPELL_PLANAR_TEAR = 3814;


const int SPELL_BREAK_ENCHANTMENT = 3816; 

const int SPELL_OPEN = -1; // not added to spells.2da yet

const int SPELLR_NEGATIVE_ENERGY_RAY = 2200; // Negative_Energy_Ray
const int SPELLR_NEGATIVE_ENERGY_BURST = 2201;
 // Negative_Energy_Burst
const int SPELL_NEGATIVE_ENERGY_RAYH = 2202; // Negative_Energy_Ray_Hostile
const int SPELL_NEGATIVE_ENERGY_RAYF = 2203; // Negative_Energy_Ray_Friendly
const int SPELL_MADDENING_SCREAM = 2204; // Maddening_Scream
const int SPELL_FREEZING_SPHERE = 2205; // Freezing_Sphere
const int SPELL_BLAST_OF_FLAME = 2206; // Blast_of_Flame
const int SPELL_ICELANCE = 2207; // Icelance

const int SPELL_CALM_EMOTIONS = 3820; // Calm_Emotions
const int SPELLR_CLARITY = 3821; // Clarity
const int SPELLR_CLOAK_OF_CHAOS = 3822; // Cloak_of_Chaos
const int SPELLR_FLAME_LASH = 3823; // Flame_Lash
const int SPELL_MASS_DOMINATION = 3824; // Mass_Domination
const int SPELLR_NATURES_BALANCE = 3825; // Natures_Balance
const int SPELLR_NEGATIVE_ENERGY_PROTECTION = 3826; // Negative_Energy_Protection
const int SPELLR_SHIELD_OF_LAW = 3827; // Shield_of_Law
const int SPELLR_TIME_STOP = 3829; // Time_Stop
const int SPELLR_ENERGY_BUFFER = 3830; // Energy_Buffer
const int SPELLR_CONTINUAL_FLAME = 3831; // Continual_Flame
const int SPELLR_ONE_WITH_THE_LAND = 3832; // One_With_The_Land
const int SPELLR_BLOOD_FRENZY = 3833; // Blood_Frenzy
const int SPELLR_ELECTRIC_JOLT = 3834; // Electric_Jolt
const int SPELLR_WOUNDING_WHISPERS = 3835; // Wounding_Whispers
const int SPELLR_HEALING_STING = 3836; // Healing_Sting
const int SPELLR_GREAT_THUNDERCLAP = 3837; // Great_Thunderclap
const int SPELLR_BALL_LIGHTNING = 3838; // Ball_Lightning
const int SPELLR_HORIZIKAULS_BOOM = 3839; // Horizikauls_Boom
const int SPELLR_IRONGUTS = 3840; // Ironguts
const int SPELLR_MESTILS_ACID_SHEATH = 3841; // Mestils_Acid_Sheath
const int SPELLR_MONSTROUS_REGENERATION = 3842; // Monstrous_Regeneration
const int SPELLR_STONE_BONES = 3843; // Stone_Bones
const int SPELLR_BLACK_BLADE_OF_DISASTER = 3844; // Black_Blade_of_Disaster
const int SPELLR_SHELGARNS_PERSISTENT_BLADE = 3845; // Shelgarns_Persistent_Blade
const int SPELLR_BLADE_THIRST = 3846; // Blade_Thirst
const int SPELLR_ICE_DAGGER = 3848; // Ice_Dagger
const int SPELLR_DARKFIRE = 3849; // Darkfire
const int SPELLR_DEATHWATCH = 3850; // Deathwatch
const int SPELLR_SPELL_IMMUNITY = 3851; // Spell_Immunity
const int SPELLR_PERMANANCY = 3852; // Permanancy
const int SPELLR_TELEPORT = 3853; // Teleport
const int SPELLR_CONTINGENCY = 3854; // Contingency
const int SPELLR_REPULSION = 3855; // Repulsion
const int SPELLR_LIMITED_WISH = 3856; // Limited_Wish
const int SPELLR_MASS_INVISIBILITY = 3857; // Mass_Invisibility
const int SPELLR_SPELL_TURNING = 3858; // Spell_Turning
//const int SPELLR_TELEPORT = 3859; // Greater_Teleport
const int SPELLR_STALKING_SPELL = 3860; // Stalking_Spell
const int SPELLR_WISH = 3861; // Wish
const int SPELLR_GREATER_SPELL_IMMUNITY = 3862; // Greater_Spell_Immunity
const int SPELLR_MIRACLE = 3863; // Miracle


// from Taleron
const int SPELL_AIMING_AT_THE_TARGET = 6041;
const int SPELL_ALEGRO = 6112;
const int SPELL_APPRAISING_TOUCH = 5973;
const int SPELL_ARROW_OF_BONE = 6314;
const int SPELL_AURA_OF_TERROR = 6275;
const int SPELL_BLAST_OF_FORCE = 6042;
const int SPELL_BLINDING_SPITTLE = 6043;
const int SPELL_BLOODFREEZE_ARROW = 6168;
//const int SPELL_BLOOD_TO_WATER = 6315; duplicate constant, in oei constants i imagine
const int SPELL_BOLT_OF_GLORY = 6276;
const int SPELL_BRAMBLES = 6044;
const int SPELL_BURNING_SWORD = 6045;
const int SPELL_CLEAR_MIND = 5974;
const int SPELL_CORONA_OF_COLD = 6113;
const int SPELL_MASS_CURSE_OF_ILL_FORTUNE = 6241;
const int SPELL_DARKFLAME_ARROW = 6114;
const int SPELL_DAWN = 5912;
const int SPELL_DECOY_IMAGE = 6115;
const int SPELL_DEIFIC_VENGEANCE = 6046;
const int SPELL_DELUSIONS_OF_GRANDEUR = 6047;
const int SPELL_DISCERN_LIES = 6169;
const int SPELL_DISCERN_SHAPESHIFTER = 6048;
const int SPELL_DISRUPT_UNDEAD_GREATER = 6118;
const int SPELL_DIVINE_AGILITY = 6238;
//const int SPELL_DIVINE_PROTECTION = 6049; duplicate constant 3157 is on 2105
const int SPELL_DRACONIC_MIGHT = 6170;
const int SPELL_DRAGON_SIGHT = 6239;
const int SPELL_ECTOPLASMIC_ARMOR = 5975;
const int SPELL_ENLARGE_PERSON_GREATER = 6240;
const int SPELL_ILLUSIONARY_WALL = 6171;
const int SPELL_LOCATE_CREATURE = 6172;
const int SPELL_OPEN_AND_CLOSE = 5913;
const int SPELL_RAY_OF_ACID = 5914;
const int SPELL_RAY_OF_ELECTRICITY = 5915;
const int SPELL_RAY_OF_FIRE = 5916;
const int SPELL_SHADOW_ARROW = 6173;

// from spell grimoire, syrus greycloak
const int SPELL_ACID_SPITTLE = 5576;
const int SPELL_ACID_STORM = 5577;
const int SPELL_AGANAZZARS_SCORCHER = 5578;
const int SPELL_ALARM = 5579;
const int SPELL_ANISHAPE_NORMAL = 5581;
const int SPELL_ANISHAPE_DIRE = 5582;
const int SPELL_ANISHAPE_BEAR = 5583;
const int SPELL_ANISHAPE_PANTHER = 5584;
const int SPELL_ANISHAPE_WOLF = 5585;
const int SPELL_ANISHAPE_BOAR = 5586;
const int SPELL_ANISHAPE_BADGER = 5587;
const int SPELL_ANISHAPE_DBEAR = 5588;
const int SPELL_ANISHAPE_DPANTHER = 5589;
const int SPELL_ANISHAPE_DWOLF = 5590;
const int SPELL_ANISHAPE_DBOAR = 5591;
const int SPELL_ANISHAPE_DBADGER = 5592;
const int SPELL_ARMOR_DARKNESS = 5594;
const int SPELL_ARMOR_UNDEATH = 5595;
const int SPELL_BANISH_SHADOW = 5596;
const int SPELL_BATTLECRY = 5597;
const int SPELL_BLACKFLAME = 5598;
const int SPELL_BLOODSTORM = 5599;
const int SPELL_CALM_ANIMALS = 5601;
const int SPELL_CHAMELEON_SKIN = 5603;
const int SPELL_CHAOS_HAMMER = 5604;
const int SPELL_CHILL_TOUCH = 5605;
const int SPELL_CLOAK_RIGHTEOUSNESS = 5606;
const int SPELL_COMP_STRIFE = 5607;
const int SPELL_CONDEMNED = 5608;
const int SPELL_DARKBOLT = 5609;
const int SPELL_DARTAN_SBOLT = 5610;
const int SPELL_DIMENSION_DOOR = 5612;
const int SPELL_DISAPPEAR = 5613;
const int SPELL_DOLOMAR_WAVE = 5614;
const int SPELL_ELE_SWARM_AIR = 5615;
const int SPELL_ELE_SWARM_EARTH = 5616;
const int SPELL_ELE_SWARM_FIRE = 5617;
const int SPELL_ELE_SWARM_WATER = 5618;
const int SPELL_FLAME_BOLT = 5621;
const int SPELL_FLASH = 5622;
const int SPELL_FLENSING = 5623;
const int SPELL_FOG_CLOUD = 5624;
const int SPELL_FREEZING_CURSE = 5625;
const int SPELL_GANEST_FARSTRIKE = 5626;
const int SPELL_GLITTERDUST = 5627;
const int SPELL_GREATER_HEALING_CIRCLE = 5628;
const int SPELL_INCAPACITATE = 5630;
const int SPELL_LEECH_FIELD = 5631;
const int SPELL_LIFE_TRANSFER = 5632;
const int SPELL_LOV_TORMENTS = 5633;


const int SPELL_MINOR_SHAD_CONJ = 5641;
const int SPELL_MSC_GREASE = 5638;
const int SPELL_MSC_MAGE_ARMOR = 5639;
const int SPELL_MSC_SUMM_SHAD = 5640;

const int SPELL_MINOR_SHAD_EVOC = 5642;
const int SPELL_MSE_DARKNESS = 5634;
const int SPELL_MSE_FLAME_BOLT = 5635;
const int SPELL_MSE_GANSTRIKE = 5636;
const int SPELL_MSE_MAGMISSILE = 5637;


const int SPELL_POWER_WORD_THUNDER = 5643;
const int SPELL_PROTECTION_CANTRIPS = 5644;
const int SPELL_PROTECTION_PARALYSIS = 5645;
const int SPELL_PURIFY_FLAMES = 5646;
const int SPELL_RABBIT_FEET = 5647;
const int SPELL_REPEL_VERMIN = 5648;
const int SPELL_SHADOW_STORM = 5649;
const int SPELL_SNILLOC_SNOWBALL = 5650;
const int SPELL_TALOS_WRATH = 5651;
const int SPELL_DEST_SMITE = 5653;
const int SPELL_ORC_SMITE = 5654;
const int SPELL_HOLY_SMITE = 5666;
const int SPELL_ORDERS_WRATH = 5667;
const int SPELL_UNHOLY_BLIGHT = 5668;
const int SPELL_REP_CRITICAL_DAMAGE = 5669;
const int SPELL_REP_LIGHT_DAMAGE = 5670;
const int SPELL_REP_MINOR_DAMAGE = 5671;
const int SPELL_REP_MODERATE_DAMAGE = 5672;
const int SPELL_REP_SERIOUS_DAMAGE = 5673;
const int SPELL_ICE_BURST = 5674;
//const int SPELL_ENHANCE_FAMILIAR = 5682;
const int SPELL_MASS_RESIST_ELEMENTS = 5683;
const int SPELL_MASS_RESIST_ELEMENTS_ACID = 5684;
const int SPELL_MASS_RESIST_ELEMENTS_COLD = 5685;
const int SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY = 5686;
const int SPELL_MASS_RESIST_ELEMENTS_FIRE = 5687;
const int SPELL_MASS_RESIST_ELEMENTS_SONIC = 5688;
const int SPELL_NEG_ENERGY_WAVE = 5689;
const int SPELL_NEG_ENERGY_WAVE_REBUKE = 5690;
const int SPELL_NEG_ENERGY_WAVE_BOLSTER = 5691;
const int SPELL_MASS_DARKVISION = 5692;
const int SPELL_FORTIFY_FAMILIAR = 5693;
const int SPELL_SONIC_BLAST = 5696;

const int SPELL_AZUTH_SPELL_SHIELD = 5702;
const int SPELL_AZUTH_SPSH1 = 5703;
const int SPELL_AZUTH_SPSH3 = 5704;
const int SPELL_AZUTH_SPSH5 = 5705;
const int SPELL_AZUTH_SPSH10 = 5706;
const int SPELL_AZUTH_SPSH15 = 5707;
const int SPELL_ANIMAL_GROWTH = 5709;
const int SPELL_ANTILIFE_SHELL = 5710;
const int SPELL_SUMMON_CREATURE_IX_CHAOS = 5711;
const int SPELL_SUMMON_CREATURE_IX_GOOD = 5712;
const int SPELL_SUMMON_CREATURE_IX_EVIL = 5713;
const int SPELL_SUMMON_CREATURE_IX_LAW = 5714;
const int SPELL_HEMORRHAGE = 5715;
const int SPELL_COMPREHEND_LANGUAGES = 5717;
const int SPELL_MORD_FORCE_MISSILE = 5718;
const int SPELL_CLOAK_CHAOS_HIT = 5720;
const int SPELL_HORIZIKAULS_COUGH = 5725;
const int SPELL_SPIRIT_WORM = 5727;
const int SPELL_DAYLIGHT = 5728;
const int SPELL_PROT_THIRST_HUNGER = 5729;
const int SPELL_CORPSE_VISAGE = 5730;
const int SPELL_CHROMATIC_ORB_LVLS15 = 5731;
const int SPELL_CHROMATIC_ORB_LVLS69 = 5732;
const int SPELL_CHROMATIC_ORB_WHITE = 5733;
const int SPELL_CHROMATIC_ORB_RED = 5734;
const int SPELL_CHROMATIC_ORB_ORANGE = 5735;
const int SPELL_CHROMATIC_ORB_YELLOW = 5736;
const int SPELL_CHROMATIC_ORB_GREEN = 5737;
const int SPELL_CHROMATIC_ORB_TURQUOISE = 5738;
const int SPELL_CHROMATIC_ORB_BLUE = 5739;
const int SPELL_CHROMATIC_ORB_VIOLET = 5740;
const int SPELL_CHROMATIC_ORB_BLACK = 5741;
const int SPELL_INVISIBILITY_TO_ANIMALS = 5742;
const int SPELL_INVISIBILITY_TO_UNDEAD = 5743;
const int SPELL_FAITH_HEALING = 5744;
const int SPELL_HERALDS_CALL = 5745;
const int SPELL_STRATEGIC_CHARGE = 5747;
const int SPELL_TOWERING_OAK = 5748;
const int SPELL_CURSE_OF_ILL_FORTUNE = 5749;
const int SPELL_HAND_OF_DIVINITY = 5750;
const int SPELL_IGEDRAZAARS_MIASMA = 5751;
const int SPELL_LIFE_BOLT = 5752;
const int SPELL_SPELL_SHIELD = 5753;
const int SPELL_FORCEWARD = 5755;
const int SPELL_HAUNTING_TUNE = 5756;
const int SPELL_HEALING_TOUCH = 5757;
const int SPELL_SPIDER_POISON = 5760;
const int SPELL_FAVOR_OF_ILMATER = 5762;
const int SPELL_FAVOR_OF_ILMATER_DF = 5763;
const int SPELL_FAVOR_OF_ILMATER_PM = 5764;
const int SPELL_IRON_BONES = 5765;
const int SPELL_JAWS_OF_THE_WOLF = 5766;
const int SPELL_SEEK_ETERNAL_REST = 5767;
const int SPELL_CAST_IN_STONE = 5768;
const int SPELL_NYBORS_GENTLE_REMINDER = 5770;
const int SPELL_NYBORS_MILD_ADMONISHMENT = 5771;
const int SPELL_NYBORS_STERN_REPROOF = 5772;
const int SPELL_NYBORS_WRATHFUL_CASTIGATION = 5773;
const int SPELL_SIMBULS_SYNOSTODWEOMER = 5774;
const int SPELL_MAGIC_STONE = 5777;
const int SPELL_MSC_REP_LIGHT_DAMAGE = 5779;
const int SPELL_RANDOM_ACTION = 5780;
const int SPELL_BLACKLIGHT = 5781;
const int SPELL_WALL_OF_ICE = 5782;
const int SPELL_WALL_OF_STONE = 5783;
const int SPELL_WALL_OF_IRON = 5784;
const int SPELL_WARP_WOOD = 5785;
const int SPELL_STRENGTH_OF_STONE = 5786;
const int SPELL_SUNSCORCH = 5787;
const int SPELL_CONSECRATE = 5788;
const int SPELL_DESECRATE = 5789;
const int SPELL_ETHEREAL_BARRIER = 5790;
const int SPELL_FILTER = 5791;
const int SPELL_DEEPER_DARKNESS = 5792;
const int SPELL_DAYLIGHT_CLERIC = 5793;
const int SPELL_WATER_BREATHING = 5794;
const int SPELL_IRON_MIND = 5795;
const int SPELL_PAIN_TOUCH = 5796;
const int SPELL_WALL_OF_SOUND = 5797;
const int SPELL_MINOR_MALISON = 5798;
const int SPELL_DIMENSIONAL_ANCHOR = 5799;
const int SPELL_DIMENSIONAL_ANCHOR_FRIENDLY = 5800;
const int SPELL_DIMENSIONAL_ANCHOR_HOSTILE = 5801;
const int SPELL_EXTERMINATE = 5802;
const int SPELL_REVITALIZE_ANIMAL = 5803;
const int SPELL_REVITALIZE_ANIMAL_1 = 5804;
const int SPELL_REVITALIZE_ANIMAL_2 = 5805;
const int SPELL_BLESSED_WARMTH = 5806;
const int SPELL_FIRE_AURA = 5807;
const int SPELL_GREATER_MALISON = 5808;
const int SPELL_MINOR_SPELL_TURNING = 5809;
const int SPELL_NAT_BALANCE = 5810;
const int SPELL_NAT_BALANCE_STR = 5811;
const int SPELL_NAT_BALANCE_DEX = 5812;
const int SPELL_NAT_BALANCE_INT = 5813;
const int SPELL_NAT_BALANCE_WIS = 5814;
const int SPELL_NAT_BALANCE_CHA = 5815;
const int SPELL_ARCANE_BOLT = 5817;
const int SPELL_DIVINE_INTERDICTION = 5819;
const int SPELL_THUNDER_STAFF = 5825;
const int SPELL_POTION_GLIBNESS = 5826;
const int SPELL_POTION_VISION = 5828;

const int SPELL_BLINDNESS = 5830;
const int SPELL_DEAFNESS = 5831;
const int SPELL_DELAYED_BLAST_FIREBALL1 = 5832;
const int SPELL_DELAYED_BLAST_FIREBALL2 = 5833;
const int SPELL_DELAYED_BLAST_FIREBALL3 = 5834;
const int SPELL_DELAYED_BLAST_FIREBALL4 = 5835;
const int SPELL_DELAYED_BLAST_FIREBALL5 = 5836;
const int SPELL_MASS_BLINDNESS = 5837;
const int SPELL_MASS_DEAFNESS = 5838;

const int SPELL_FREEZING_CURSE_ONHIT = 5880;
const int SPELL_LARLOCHS_MINOR_DRAIN = 5879;
const int SPELL_MORDS_MAG_MANSION = 5899;
const int SPELL_BALEFUL_TRANSPOSITION = 5900;
const int SPELL_BENIGN_TRANSPOSITION = 5901;
const int SPELL_MASS_CONVICTION = 5903;

//@} ****************************************************************************************************



/*
these were dupes or cut, row numbers assigned are no longer valide, but dupe row is noted
//const int SPELL_DISRUPT_UNDEAD ; //  is on 3813
//const int SPELL_LIONHEART ; // 3160 is on 1053
//const int SPELL_MAGIC_STONE ; // is on 5777
//const int SPELL_OBSCURING_MIST ; //  is right above
//const int SPELL_CALM_EMOTIONS ; // is on 3820
//const int SPELL_COMMAND_UNDEAD ; //  is right above
//const int SPELL_CONTINUAL_FLAME ; // is on 419
//const int SPELL_DEATH_KNELL ; //  is on 866
//const int SPELL_DIVINE_PROTECTION ; // 3157 is on 2105
//const int SPELL_FOG_CLOUD ; // is on 5624
//const int SPELL_WARP_WOOD ; // is on 5785 
//const int SPELL_DEEPER_DARKNESS ; // 3207 is on 5792
//const int SPELL_ICE_BURST ; // 3105 is on 5674
//const int SPELL_BLAST_OF_FLAME ; // 3110 is on 2206
//const int SPELL_RECITATION ; // 3140 is on 1054
//const int SPELL_BREAK_ENCHANTMENT ; // is on 3816
//const int SPELL_TELEPORT ; // is on 872
//const int SPELL_MASS_CONTAGION ; // 2122 is on 1017
//const int SPELL_REPULSION ; // is on 877
//const int SPELL_SPELLSTAFF ; //  is on 508
//const int SPELL_LIMITED_WISH ; // is on 880
//const int SPELL_NYBORS_STERN_REPROOF ; // 3176 - is on 5772
//const int SPELL_REPULSION ; // see above 6272 and 877
//const int SPELL_HOLY_AURA ; // 1854 is on 84
//const int SPELL_NATURE_AVATAR ; // 2097 is on 1008
*/



/********************************************************************************************************/
/** @name Level 0 Spells
* Cantrips
********************************************************************************************************* @{ */
const int SPELL_DANCING_LIGHTS = 5905; // need to implement fully
const int SPELL_DETECT_MAGIC = 5906; // need to implement fully
const int SPELL_GHOST_SOUND = 5907; // need to implement fully
const int SPELL_GUIDANCE = 5908; // need to implement fully
const int SPELL_LULLABY = 5909; // need to implement fully
const int SPELL_PURIFY_FOOD_AND_DRINK = 5910; // need to implement fully
const int SPELL_READ_MAGIC = 5911; // need to implement fully
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 1 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ABERRATE = 5926; // 2512
const int SPELL_ANGRY_ACHE = 5927; // 2515
const int SPELL_ANIMAL_MESSENGER = 5928; // need to implement fully
const int SPELL_BESTOW_WOUND = 5929; // 2520
const int SPELL_BIGBYS_TRIPPING_HAND = 5930; // 1743
const int SPELL_BLADE_OF_BLOOD = 5931; // 1744
const int SPELL_BLESS_WATER = 5932; // 1851
const int SPELL_BURNING_BOLT = 5933; // 3109
const int SPELL_CHARM_ANIMAL = 5934; // need to implement fully
const int SPELL_COMMAND = 5935; // need to implement fully
const int SPELL_CREATE_WATER = 5936; // need to implement fully
const int SPELL_CURSE_WATER = 5937; // need to implement fully
const int SPELL_DETECT_CHAOS = 5938; // 3204
const int SPELL_DETECT_EVIL = 5939; // 3201
const int SPELL_DETECT_GOOD = 5940; // 3202
const int SPELL_DETECT_LAW = 5941; // 3203
const int SPELL_DETECT_POISON = 5942; // need to implement fully
const int SPELL_DETECT_SECRET_DOORS = 5943; // need to implement fully
const int SPELL_DISGUISE_SELF = 5944; // 1735
const int SPELL_DIVINE_INSPIRATION = 5945; // 2609
const int SPELL_DIVINE_SACRIFICE = 5946; // 2629
///const int SPELL_DIVINE_SACRIFICE = 5946; // 2629


const int SPELL_DRUG_RESISTANCE = 5947; // 2544
const int SPELL_EXTRACT_DRUG = 5948; // 2554
const int SPELL_EYES_OF_THE_AVORAL = 5949; // 2632
const int SPELL_GOODBERRY = 5950; // need to implement fully
const int SPELL_HAIL_OF_STONE = 5951; // 3183
const int SPELL_HEARTACHE = 5952; // 2565
const int SPELL_HOLD_PORTAL = 5953; // need to implement fully
const int SPELL_HYPNOTISM = 5954; // need to implement fully
const int SPELL_JUMP = 5955; // 2070
const int SPELL_KELGORES_FIRE_ORB = 5956; // 1834
const int SPELL_LANTERN_LIGHT = 5957; // 2634
const int SPELL_LESSER_CONFUSION = 5958; // need to implement fully
const int SPELL_LESSER_DEFLECT = 5959; // 1817
const int SPELL_LESSER_SHIVERING_TOUCH = 5960; // 2605
const int SPELL_LONGSTRIDER = 5961; // need to implement fully
const int SPELL_NECROTIC_AWARENESS = 5962; // 2854
const int SPELL_OBSCURING_MIST = 5963; // 3085
const int SPELL_PRODUCE_FLAME = 5964; // need to implement fully
const int SPELL_RAY_OF_HOPE = 5965; // 2640
const int SPELL_ROUSE = 5966; // 1836
const int SPELL_SEETHING_EYEBANE = 5967; // 2579
const int SPELL_SHILLELAGH = 5968; // need to implement fully
const int SPELL_SORROW = 5969; // 2582
const int SPELL_TONGUE_OF_BAALZEBUL = 5970; // 2588
const int SPELL_TWILIGHT_LUCK = 5971; // 2620
const int SPELL_VISION_OF_HEAVEN = 5972; // 3083
//@} ****************************************************************************************************


const int SPELL_BOOKWARD = 5989; //¥ level 2 Abjuration
const int SPELL_ERASE = 5976; //¥ level 1 Transmutation
const int SPELL_EXPLOSIVERUNES = 6121; //¥ level 3 Abjuration
const int SPELL_PHANTOMTRAP = 5990; //¥ level 2 Illusion
const int SPELL_RUNEOFRETURN = 6242; //¥ level 5 Conj
const int SPELL_SECRETPAGE = 6119; //¥ level 3 Trans
const int SPELL_SEPIA_SNAKE_SIGIL = 6120; //¥ level 3 Conj
const int SPELL_SCRIVENERSCHANT = 5986; //¥ level 0 trans
const int SPELL_UNDETECTABLE_AURA = 5977; //¥ level 1 Illusion
const int SPELL_ALTERTEXT = 5987; //¥ level 2 trans
const int SPELL_FROSTTRAP = 5988; //¥ level 4 wizard










/********************************************************************************************************/
/** @name Level 2 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ADDICTION = 5991; // 2645
const int SPELL_ALIGN_WEAPON = 5992; // need to implement fully
const int SPELL_ALTER_SELF = 5993; // need to implement fully
const int SPELL_ANIMAL_TRANCE = 5994; // need to implement fully
const int SPELL_AUGMENT_FAMILIAR = 5995; // 1796
const int SPELL_AYAILLAS_RADIANT_BURST = 5996; // 2607
const int SPELL_BIGBYS_STRIKING_FIST = 5997; // 1742
const int SPELL_BONEBLAST = 5998; // 2526
const int SPELL_CHILL_METAL = 5999; // need to implement fully
const int SPELL_CLARITY_OF_MIND = 6000; // 3181
const int SPELL_COMMAND_UNDEAD = 6001; // 2499
const int SPELL_CONSECRATED_AURA = 6002; // 2167
const int SPELL_CREATE_MAGIC_TATOO = 6003; // 3166
const int SPELL_DAZE_MONSTER = 6004; // need to implement fully
const int SPELL_DEFLECT = 6005; // 1797
const int SPELL_DELAY_POISON = 6006; // need to implement fully
const int SPELL_DIMENSION_HOP = 6007; // 1818
const int SPELL_DISPELLING_TOUCH = 6009; // 1819
const int SPELL_ENERGIZE_POTION = 6010; // 2631
const int SPELL_ENTHRALL = 6011; // need to implement fully
const int SPELL_FIRE_TRAP = 6012; // need to implement fully
const int SPELL_FLAMING_SPHERE = 6013; // need to implement fully
const int SPELL_GENTLE_REPOSE = 6014; // need to implement fully
const int SPELL_HEAT_METAL = 6015; // need to implement fully
const int SPELL_HYPNOTIC_PATTERN = 6016; // need to implement fully
const int SPELL_LAHMS_FINGER_DARTS = 6017; // 2570
const int SPELL_LUMINOUS_ARMOR = 6018; // 2636
const int SPELL_MAKE_WHOLE = 6019; // need to implement fully
const int SPELL_MASOCHISM = 6020; // 2644
const int SPELL_NECROTIC_CYST = 6021; // 2855
const int SPELL_PHANTOM_TRAP = 6022; // need to implement fully
const int SPELL_PYROTECNICS = 6023; // need to implement fully
const int SPELL_ROPE_TRICK = 6024; // need to implement fully
const int SPELL_SEEKING_RAY = 6025; // 1837
const int SPELL_SHADOW_SPRAY = 6026; // 3170
const int SPELL_SHRIVELING = 6027; // 2580
const int SPELL_SNARE = 6028; // need to implement fully
const int SPELL_SONG_OF_FESTERING_DEATH = 6029; // 2581
const int SPELL_SPIRITUAL_WEAPON = 6030; // need to implement fully
const int SPELL_SPORES_OF_THE_VROCK = 6031; // 2584
const int SPELL_SUMMON_SWARM = 6032; // need to implement fully
const int SPELL_SURE_STRIKE = 6033; // 1840
const int SPELL_TONGUES = 6034;
const int SPELL_TREE_SHAPE = 6035; // need to implement fully
const int SPELL_UNDETECTABLE_ALINGMENT = 6036; // 3205
const int SPELL_UNHEAVENED = 6037; // 2590
const int SPELL_WAVE_OF_GRIEF = 6038; // 2593
const int SPELL_WHISPERING_WIND = 6039; // need to implement fully
const int SPELL_WOOD_SHAPE = 6040; // need to implement fully
const int SPELL_BABBLE = 6056;
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 3 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_BLESSING_OF_BAHAMUT = 6050; // 2099
const int SPELL_BLINK = 6051; // need to implement fully
const int SPELL_BONEBLADE = 6052; // 2522
const int SPELL_BONEBLADE_GREATSWORD = 6053; // 2523
const int SPELL_BONEBLADE_LONGSWORD = 6054; // 2524
const int SPELL_BONEBLADE_SHORTSWORD = 6055; // 2525
const int SPELL_BRILLIANT_EMANATION = 6057; // 2608
const int SPELL_CLOSE_WOUNDS = 6058; // 1849
const int SPELL_CLUTCH_OF_ORCUS = 6059; // 2532
const int SPELL_COMMAND_PLANTS = 6060; // need to implement fully
const int SPELL_CREATE_FOOD_AND_WATER = 6061; // need to implement fully
const int SPELL_CROWN_OF_MIGHT = 6062; // 1815
const int SPELL_CROWN_OF_PROTECTION = 6063; // 1816
const int SPELL_CURSE_OF_PETTY_FAILING = 6064; // 3155
const int SPELL_CURSE_OF_THE_PUTRID_HUSK = 6065; // 2534
const int SPELL_DEVILS_EYE = 6066; // 2541
const int SPELL_DIMINISH_PLANTS = 6067; // need to implement fully
const int SPELL_DREAD_WORD = 6068; // 2543
const int SPELL_ELATION = 6069; // 2630
const int SPELL_ENERGY_AEGIS = 6070; // 1821
const int SPELL_ENERGY_AEGIS_ACID = 6071; // 1822
const int SPELL_ENERGY_AEGIS_COLD = 6072; // 1823
const int SPELL_ENERGY_AEGIS_ELEC = 6073; // 1824
const int SPELL_ENERGY_AEGIS_FIRE = 6074; // 1825
const int SPELL_ENERGY_AEGIS_SONIC = 6075; // 1826
const int SPELL_ENERGY_SURGE = 6076; // 1827
const int SPELL_ENERGY_SURGE_ACID = 6077; // 1828
const int SPELL_ENERGY_SURGE_COLD = 6078; // 1829
const int SPELL_ENERGY_SURGE_ELEC = 6079; // 1830
const int SPELL_ENERGY_SURGE_FIRE = 6080; // 1831
const int SPELL_ENERGY_SURGE_SONIC = 6081; // 1832
const int SPELL_EVIL_EYE = 6082; // 2547
const int SPELL_FLASHBURST = 6083; // 3168
const int SPELL_FLESH_RIPPER = 6084; // 2562
const int SPELL_FORCEBLAST = 6085; // 3141
const int SPELL_GLIBNESS = 6086; // 2081
const int SPELL_GOOD_HOPE = 6087; // need to implement fully
const int SPELL_GREENFIRE = 6088; // 3187
const int SPELL_HALT = 6089; // 1833
const int SPELL_HALT_UNDEAD = 6090; // need to implement fully
const int SPELL_HAMMER_OF_RIGHTEOUSNESS = 6091; // 2613
const int SPELL_LEGIONS_CONVICTION = 6092; // 3152
const int SPELL_NECROTIC_BLOAT = 6093; // 2856
const int SPELL_NONDETECTION = 6094; // 2077
const int SPELL_PLANT_GROWTH = 6095; // need to implement fully
const int SPELL_QUENCH = 6096; // need to implement fully
const int SPELL_RAYOFEXHAUSTION = 6098; // 3057
const int SPELL_REALITY_BLIND = 6099; // 2575
const int SPELL_RED_FESTER = 6100; // 2576
const int SPELL_REGROUP = 6101; // 1835
const int SPELL_ROTTING_CURSE_OF_URFESTRA = 6102; // 2578
const int SPELL_SHIVERING_TOUCH = 6103; // 2606
const int SPELL_SLASHING_DARKNESS = 6104; // 3164
const int SPELL_SLEET_STORM = 6105; // need to implement fully
const int SPELL_STONE_SHAPE = 6106; // need to implement fully
const int SPELL_STUNNING_SCREECH = 6107; // 2585
const int SPELL_TINY_HUT = 6108; // need to implement fully
const int SPELL_TOUCH_OF_JUIBLEX = 6109; // 2589
const int SPELL_UNLIVING_WEAPON = 6110; // 2591


const int SPELL_MERCY = 6111;
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 4 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ABSORB_STRENGTH = 6126; // 2513
const int SPELL_ABYSSAL_MIGHT = 6127; // 2514
const int SPELL_ANTIPLANT_SHELL = 6128; // need to implement fully
const int SPELL_BLIGHT = 6129; // need to implement fully
const int SPELL_BLOOD_OF_THE_MARTYR = 6130; // 3099
const int SPELL_CHANNELED_PYROBURST = 6131; // 1810
const int SPELL_CHANNELED_PYROBURST_1 = 6132; // 1811
const int SPELL_CHANNELED_PYROBURST_2 = 6133; // 1812
const int SPELL_CHANNELED_PYROBURST_3 = 6134; // 1813
const int SPELL_CHANNELED_PYROBURST_4 = 6135; // 1814
const int SPELL_CLAWS_OF_THE_SAVAGE = 6137; // 2530
const int SPELL_DAMNING_DARKNESS = 6138; // 2535
const int SPELL_DANCING_WEB = 6139; // 2628
const int SPELL_DETECT_SCRYING = 6140; // 1809
const int SPELL_DIAMOND_SPRAY = 6141; // 2610
const int SPELL_DOOM_SCARABS = 6142; // 1820
const int SPELL_GIANT_VERMIN = 6143; // need to implement fully
const int SPELL_GREATER_LUMINOUS_ARMOR = 6144; // 2637
const int SPELL_GRIM_REVENGE = 6145; // 2563
const int SPELL_ILLUSORY_WALL = 6146; // need to implement fully
const int SPELL_ILYYKURS_MANTLE = 6147; // 3173
const int SPELL_LEGIONS_SHIELD_OF_FAITH = 6148; // 3163
const int SPELL_LESSER_PLANAR_ALLY = 6149; // need to implement fully
const int SPELL_LIQUID_PAIN = 6150; // 2571
const int SPELL_LOWER_SR = 6151; // 3126
const int SPELL_MASS_ULTRAVISION = 6152; // 3125
const int SPELL_NECROTIC_DOMINATION = 6153; // 2857
const int SPELL_PANACEA = 6154; // 3162
const int SPELL_RAINBOW_PATTERN = 6155; // 2078
const int SPELL_RUSTING_GRASP = 6156; // need to implement fully
const int SPELL_SECURE_SHELTER = 6157; // need to implement fully
const int SPELL_SENDING = 6158; // need to implement fully
const int SPELL_SINSABURS_BALEFUL_BOLT = 6159; // 3177
const int SPELL_SLASHING_DISPEL = 6160; // 1838
const int SPELL_SOLID_FOG = 6161; // 1808
const int SPELL_SPIKE_STONES = 6162; // need to implement fully
const int SPELL_SUNMANTLE = 6163; // 2619
const int SPELL_SWORD_OF_CONSCIENCE = 6164; // 3084
const int SPELL_VISCID_GLOB = 6165; // 3185
const int SPELL_WAVE_OF_PAIN = 6166; // 2594
const int SPELL_WRACK = 6167; // 2595
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 5 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ATONEMENT = 6200; // need to implement fully
const int SPELL_BALEFUL_POLYMORPH = 6201; // 1805
const int SPELL_BELTYNS_BURNING_BLOOD = 6202; // 3172
const int SPELL_CALL_DRETCH_HORDE = 6203; // 2527
const int SPELL_CALL_LEMURE_HORDE = 6204; // 2528
const int SPELL_CHAAVS_LAUGH = 6205; // 2626
const int SPELL_CLAWS_OF_THE_BEBILITH = 6206; // 2529
const int SPELL_CONVERT_WAND = 6207; // 2627
const int SPELL_DISPEL_ALIGNMENT = 6208; // need to implement fully
const int SPELL_DISRUPTING_WEAPON = 6209; // need to implement fully
const int SPELL_FABRICATE = 6210; // need to implement fully
const int SPELL_GREATER_COMMAND = 6211; // need to implement fully
const int SPELL_HALLOW = 6212; // need to implement fully
const int SPELL_HEARTCLUTCH = 6213; // 2566
const int SPELL_INSECT_PLAGUE = 6214; // need to implement fully
const int SPELL_LEGIONS_CURSE_OF_PETTY_FAILING = 6215; // 3156
const int SPELL_MAGES_PRIVATE_SANCTUM = 6216; // need to implement fully
const int SPELL_MAJOR_MAGIC_MISSILE = 6217; // 2247
const int SPELL_MISLEAD = 6218; // need to implement fully
const int SPELL_MORALITY_UNDONE = 6219; // 2572
const int SPELL_NECROTIC_BURST = 6220; // 2858
const int SPELL_NIGHTS_CARESS = 6221; // 2864
const int SPELL_PLANE_SHIFT = 6222; // need to implement fully
const int SPELL_POWER_LEECH = 6223; // 2573
const int SPELL_RESONATING_RESISTANCE = 6224; // 2577
const int SPELL_REVIVIFY = 6225; // 1850
const int SPELL_SEEMING = 6226; // need to implement fully
const int SPELL_SHADOW_EVOCATION = 6227; // need to implement fully
const int SPELL_SICKEN_EVIL = 6228; // 2617
const int SPELL_SOULSCOUR = 6229; // 3179
const int SPELL_STOP_HEART = 6230; // 2586
const int SPELL_TELEPATHIC_BOND = 6231; // need to implement fully
const int SPELL_TRANSMUTE_MUD_AND_ROCK = 6232; // need to implement fully
const int SPELL_UNHALLOW = 6233; // need to implement fully
const int SPELL_WALL_OF_FORCE = 6234; // need to implement fully
const int SPELL_WALL_OF_THORNS = 6235; // need to implement fully
//const int SPELL_WAVES_OF_FATIGUE = 6236; // need to implement fully
const int SPELL_WAVESOFFATIGUE = 6237; // 3058
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 6 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ANIMATE_OBJECT = 6250; // 1790
const int SPELL_ANTIMAGIC_FIELD = 6251; // 2076
const int SPELL_CALL_FAITHFUL_SERVANTS = 6252; // 2624
const int SPELL_CELESTIAL_BLOOD = 6253; // 2625
const int SPELL_CLOUD_OF_THE_ACHAIERAI = 6254; // 2531
const int SPELL_ECTOPLASMIC_ENCHANCEMENT = 6255; // 2545
const int SPELL_EXALTED_RAIMENT = 6256; // 2583
const int SPELL_EYEBITE = 6257; // need to implement fully
const int SPELL_FIRE_SEEDS = 6258; // need to implement fully
const int SPELL_FORBIDDANCE = 6259; // need to implement fully
const int SPELL_GHOUL_GAUNTLET = 6260; // 2862
const int SPELL_GREATER_GLYPH_OF_WARDING = 6261; // need to implement fully
const int SPELL_HEROES_FEAST = 6262; // need to implement fully
const int SPELL_IRONWOOD = 6263; // need to implement fully
const int SPELL_IRRESISTIBLE_DANCE = 6264; // need to implement fully
const int SPELL_MOVE_EARTH = 6265; // need to implement fully
const int SPELL_NECROTIC_ERUPTION = 6266; // 2859
const int SPELL_POX = 6267; // 2886
const int SPELL_PROJECT_IMAGE = 6268; // need to implement fully
const int SPELL_REPEL_WOOD = 6269; // need to implement fully
const int SPELL_STARMANTLE = 6270; // 2642
const int SPELL_STORM_OF_SHARDS = 6271; // 2618
const int SPELL_THOUSAND_NEEDLES = 6272; // 2587
const int SPELL_TRANSPORT_VIA_PLANTS = 6273; // need to implement fully
const int SPELL_WORD_OF_RECALL = 6274; // need to implement fully
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Level 7 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_AMBER_SARCOPHAGUS = 6290; // 2621
const int SPELL_ANIMATE_PLANTS = 6291; // need to implement fully
const int SPELL_CHANGESTAFF = 6292; // need to implement fully
const int SPELL_DEATH_BY_THORNS = 6293; // 2536
const int SPELL_ENERGY_EBB = 6294; // 2863
const int SPELL_EYE_OF_THE_BEHOLDER = 6295; // 2548
const int SPELL_FIENDISH_CLARITY = 6296; // 2560
const int SPELL_FORCECAGE = 6297; // need to implement fully
const int SPELL_GREATER_HARM = 6298; // 3217
const int SPELL_INSANITY = 6299; // 3212
const int SPELL_PHASE_DOOR = 6300; // need to implement fully
const int SPELL_PHOENIX_FIRE = 6301; // 2615
const int SPELL_RAIN_OF_EMBERS = 6303; // 2616
const int SPELL_RAIN_OF_ROSES = 6304; // 2639
const int SPELL_RAPTURE_OF_RUPTURE = 6305; // 2574
const int SPELL_REFUGE = 6306; // need to implement fully
const int SPELL_RIGHTEOUS_SMITE = 6307; // 2641
const int SPELL_STATUE = 6308; // need to implement fully
const int SPELL_TOMB_OF_LIGHT = 6309; // 2643
const int SPELL_TRANSMUTE_METAL_TO_WOOD = 6310; // need to implement fully
const int SPELL_WAVES_OF_EXHAUSTION = 6311; // need to implement fully
const int SPELL_WORD_OF_BALANCE = 6312; // 3186
const int SPELL_WRETCHED_BLIGHT = 6313; // 2596
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Level 8 Spells
* 
********************************************************************************************************* @{ */
const int SPELL_ANIMAL_SHAPES = 6331; // need to implement fully
const int SPELL_ANTIPATHY = 6332; // need to implement fully
const int SPELL_AVASCULAR_MASS = 6333; // 2852
const int SPELL_BODAK_BIRTH = 6334; // 2521
const int SPELL_CLONE = 6335; // need to implement fully
const int SPELL_CONTROL_PLANTS = 6336; // need to implement fully
const int SPELL_DIMENSIONAL_LOCK = 6337; // 2898
const int SPELL_DRAGON_CLOUD = 6338; // 2611
const int SPELL_EVIL_WEATHER = 6339; // 2549
const int SPELL_EVIL_WEATHER_RAIN_OF_BLOOD = 6340; // 2550
const int SPELL_EVIL_WEATHER_VIOLET_RAIN = 6341; // 2551
const int SPELL_EVIL_WEATHER_GREEN_FOG = 6342; // 2552
const int SPELL_EVIL_WEATHER_RAIN_OF_FISH = 6343; // 2553
const int SPELL_GUTWRENCH = 6345; // 2564
const int SPELL_LAST_JUDGEMENT = 6346; // 2635
const int SPELL_MANTLE_OF_EGREG_MIGHT = 6347; // 3112
const int SPELL_MAZE = 6348; // 2888
const int SPELL_NECROTIC_EMPOWERMENT = 6349; // 2860
const int SPELL_PESTILENCE = 6350; // 2887
const int SPELL_PRISMATIC_WALL = 6351; // need to implement fully
const int SPELL_REPEL_METAL_OR_STONE = 6352; // need to implement fully
const int SPELL_SCINTILLATING_PATTERN = 6353; // need to implement fully
const int SPELL_TEMPORAL_STASIS = 6354; // need to implement fully
const int SPELL_TRAP_THE_SOUL = 6355; // need to implement fully
const int SPELL_WHIRLWIND = 6356; // need to implement fully
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Spells
* SPELLR_* are spells which exist in nwscript, but which i want to put on new rows
********************************************************************************************************* @{ */
const int SPELL_APOCALYPSE_FROM_THE_SKY = 6371; // 2516
const int SPELL_APOCALYPSE_FROM_THE_SKY_FIRE = 6372; // 2517
const int SPELL_APOCALYPSE_FROM_THE_SKY_ACID = 6373; // 2518
const int SPELL_APOCALYPSE_FROM_THE_SKY_SONIC = 6374; // 2519
const int SPELL_ASTRAL_PROJECTION = 6376; // need to implement fully
const int SPELL_BLINDING_GLORY = 6377; // 2622
const int SPELL_CRUSHING_FIST_OF_SPITE = 6378; // 2533
const int SPELL_DESPOIL = 6379; // 2539
const int SPELL_EXALTED_FURY = 6380; // 2612
const int SPELL_FORESIGHT = 6381; // 1856
const int SPELL_FREEDOM = 6382; // need to implement fully
const int SPELL_IMPRISONMENT = 6383;// need to implement fully
const int SPELL_NECROTIC_TERMINATION = 6384; // 2861
const int SPELL_PRISMATIC_SPHERE = 6385;// need to implement fully
const int SPELL_RAIN_OF_BLACK_TULIPS = 6386; // 2638
const int SPELL_SHAMBLER = 6387;// need to implement fully
const int SPELL_SOUL_BIND = 6388;// need to implement fully
const int SPELL_SPHERE_OF_ULTIMATE_DESTRUCTION = 6389; // 3180
const int SPELL_SYMPATHY = 6390;// need to implement fully
const int SPELL_TELEPORTATION_CIRCLE = 6391;// need to implement fully
const int SPELL_TRUE_RESURRECTION = 6392; // 1855
const int SPELL_UNYIELDING_ROOTS = 6393; // 2098
const int SPELL_UTTERDARK = 6394; // 2592
//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Spells
* SPELLR_* are spells which exist in nwscript, but which i want to put on new rows
********************************************************************************************************* @{ */
const int SPELL_EPIC_A_STONE = 6400; // Epic_Spell_Audience_of_Stone 4007
const int SPELL_EPIC_ACHHEEL = 6401; // Epic_Spell_Achilles_Heel 4000
const int SPELL_EPIC_AL_MART = 6402; // Epic_Spell_Allied_Martyr 4002
const int SPELL_EPIC_ALLHOPE = 6403; // Epic_Spell_All_Hope_Lost 4001
const int SPELL_EPIC_ANARCHY = 6404; // Epic_Spell_Anarchys_Call 4003
const int SPELL_EPIC_ANBLAST = 6405; // Epic_Spell_Animus_Blast 4004
const int SPELL_EPIC_ANBLIZZ = 6406; // Epic_Spell_Animus_Blizzard 4005
const int SPELL_EPIC_ARMY_UN = 6407; // Epic_Spell_Army_Unfallen 4006
const int SPELL_EPIC_CELCOUN = 6408; // Epic_Spell_Celestial_Council 4009
const int SPELL_EPIC_CHAMP_V = 6409; // Epic_Spell_Champions_Valor 4010
const int SPELL_EPIC_CON_RES = 6410; // Epic_Spell_Contingent_Resurrection 4011
const int SPELL_EPIC_CON_REU = 6411; // Epic_Spell_Contingent_Reunion 4012
const int SPELL_EPIC_DEADEYE = 6412; // Epic_Spell_Deadeye_Sense 4013
const int SPELL_EPIC_DIREWIN = 6413; // Epic_Spell_Dire_Winter 4015
const int SPELL_EPIC_DREAMSC = 6414; // Epic_Spell_Dreamscape 4017
const int SPELL_EPIC_DRG_KNI = 6415; // Epic_Spell_Dragon_Knight 4016
const int SPELL_EPIC_DULBLAD = 6416; // Epic_Spell_Dullblades 4018
const int SPELL_EPIC_DWEO_TH = 6417; // Epic_Spell_Dweomer_Thief 4019
const int SPELL_EPIC_ENSLAVE = 6418; // Epic_Spell_Enslave 4020
const int SPELL_EPIC_EP_M_AR = 6419; // Epic_Spell_Epic_Mage_Armor 4021
const int SPELL_EPIC_EP_RPLS = 6420; // Epic_Spell_Epic_Repulsion 4022
const int SPELL_EPIC_EP_SP_R = 6421; // Epic_Spell_Epic_Spell_Reflection 4023
const int SPELL_EPIC_EP_WARD = 6422; // Epic_Spell_Epic_Warding 4024
const int SPELL_EPIC_ET_FREE = 6423; // Epic_Spell_Eternal_Freedom 4025
const int SPELL_EPIC_FIEND_W = 6424; // Epic_Spell_Fiendish_Words 4026
const int SPELL_EPIC_FLEETNS = 6425; // Epic_Spell_Fleetness_of_Foot 4027
const int SPELL_EPIC_GEMCAGE = 6426; // Epic_Spell_Gem_Cage 4028
const int SPELL_EPIC_GODSMIT = 6427; // Epic_Spell_Godsmite 4029
const int SPELL_EPIC_GR_RUIN = 6428; // Epic_Spell_Greater_Ruin 4030
const int SPELL_EPIC_GR_SP_RE = 6429; // Epic_Spell_Greater_Spell_Resistance 4031
const int SPELL_EPIC_GR_TIME = 6430; // Epic_Spell_Greater_Timestop 4032
const int SPELL_EPIC_HELBALL = 6431; // Epic_Spell_Hellball 4034
const int SPELL_EPIC_HERCALL = 6432; // Epic_Spell_Herculean_Alliance 4035
const int SPELL_EPIC_HERCEMP = 6433; // Epic_Spell_Herculean_Empowerment 4036
const int SPELL_EPIC_IMPENET = 6434; // Epic_Spell_Impenetrability 4037
const int SPELL_EPIC_LEECH_F = 6435; // Epic_Spell_Leech_Field 4038
const int SPELL_EPIC_MAGMA_B = 6436; // Epic_Spell_Magma_Burst 4041
const int SPELL_EPIC_MASSPEN = 6437; // Epic_Spell_Mass_Penguin 4042
const int SPELL_EPIC_MORI = 6438; // Epic_Spell_Momento_Mori 4043
const int SPELL_EPIC_MUMDUST = 6439; // Epic_Spell_Mummy_Dust 4044
const int SPELL_EPIC_NAILSKY = 6440; // Epic_Spell_Nailed_to_the_Sky 4045
const int SPELL_EPIC_ORDER_R = 6441; // Epic_Spell_Order_Restored 4047
const int SPELL_EPIC_PATHS_B = 6442; // Epic_Spell_Paths_Become_Known 4048
const int SPELL_EPIC_PEERPEN = 6443; // Epic_Spell_Peerless_Penitence 4049
const int SPELL_EPIC_PESTIL = 6444; // Epic_Spell_Pestilence 4050
const int SPELL_EPIC_PIOUS_P = 6445; // Epic_Spell_Pious_Parley 4051
const int SPELL_EPIC_PLANCEL = 6446; // Epic_Spell_Planar_Cell 4052
const int SPELL_EPIC_PSION_S = 6447; // Epic_Spell_Psionic_Salvo 4053
const int SPELL_EPIC_RAINFIR = 6448; // Epic_Spell_Rain_of_Fire 4054
const int SPELL_EPIC_RUINN = 6449; // Epic_Spell_Ruin 4056
const int SPELL_EPIC_SINGSUN = 6450; // Epic_Spell_Singular_Sunder 4057
const int SPELL_EPIC_SP_WORM = 6451; // Epic_Spell_Spell_Worm 4058
const int SPELL_EPIC_STORM_M = 6452; // Epic_Spell_Storm_Mantle 4059
const int SPELL_EPIC_SUMABER = 6453; // Epic_Spell_Summon_Aberration 4060
const int SPELL_EPIC_SUP_DIS = 6454; // Epic_Spell_Superb_Dispelling 4061
const int SPELL_EPIC_THEWITH = 6455; // Epic_Spell_The_Withering 4063
const int SPELL_EPIC_TOLO_KW = 6456; // Epic_Spell_Tolodines_Killing_Wind 4064
const int SPELL_EPIC_TRANVIT = 6457; // Epic_Spell_Transcendent_Vitality 4065
const int SPELL_EPIC_TWINF = 6458; // Epic_Spell_Twinfiend 4066
const int SPELL_EPIC_UNHOLYD = 6459; // Epic_Spell_Unholy_Disciple 4067
const int SPELL_EPIC_UNIMPIN = 6460; // Epic_Spell_Unimpinged 4068
const int SPELL_EPIC_UNSEENW = 6461; // Epic_Spell_Unseen_Wanderer 4069
const int SPELL_EPIC_WANDERUNSEEN = 6462; // Epic_Spell_Wander_Unseen 4071
const int SPELL_EPIC_WHIP_SH = 6463; // Epic_Spell_Whip_of_Shar 4070
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Spell Abilities
* Description
********************************************************************************************************* @{ */

const int SPELLABILITY_SG_HALFLING_DOMAIN_POWER = 5778;
const int SPELLABILITY_SG_HATRED_DOMAIN_POWER = 5829;

const int SPELLABILITY_SG_SPLENDOR_OF_EAGLES = 5697;
const int SPELLABILITY_SG_FREEDOM_OF_MOVEMENT = 5698;

const int SPELLABILITY_ENERGY_SUBSTITUTION_ACID = -100;
const int SPELLABILITY_ENERGY_SUBSTITUTION_COLD = -101;
const int SPELLABILITY_ENERGY_SUBSTITUTION_ELEC = -102;
const int SPELLABILITY_ENERGY_SUBSTITUTION_FIRE = -103;
const int SPELLABILITY_ENERGY_SUBSTITUTION_SONIC = -104;

const int SPELLABILITY_ELEMENTAL_SUBSTITUTION_ACID = 5881;
const int SPELLABILITY_ELEMENTAL_SUBSTITUTION_COLD = 5882;
const int SPELLABILITY_ELEMENTAL_SUBSTITUTION_ELECTRICITY = 5883;
const int SPELLABILITY_ELEMENTAL_SUBSTITUTION_FIRE = 5884;
const int SPELLABILITY_ELEMENTAL_SUBSTITUTION_SONIC = 5885;


const int ELEMENTAL_SUBSTITUTION_TYPE_NONE = 0;
const int ELEMENTAL_SUBSTITUTION_TYPE_ACID = 1;
const int ELEMENTAL_SUBSTITUTION_TYPE_COLD = 2;
const int ELEMENTAL_SUBSTITUTION_TYPE_ELECTRICITY = 3;
const int ELEMENTAL_SUBSTITUTION_TYPE_FIRE = 4;
const int ELEMENTAL_SUBSTITUTION_TYPE_SONIC = 5;

const int SPELL_SPELLABILITY_Acidic_Splatter = 1864;
const int SPELL_SPELLABILITY_Clap_Thunder = 1865;
const int SPELL_SPELLABILITY_Fiery_Burst = 1866;
const int SPELL_SPELLABILITY_Hurricane_Breath = 1867;
const int SPELL_SPELLABILITY_Invisible_Needle = 1868;

const int SPELL_SPELLABILITY_Storm_Bolt = 1870;
const int SPELL_SPELLABILITY_Sickening_Graspe = 1871;
const int SPELL_SPELLABILITY_Summon_Elemental = 1872;
const int SPELL_SPELLABILITY_Winters_Blast = 1873;
const int SPELL_SPELLABILITY_Holy_Warrior = 1874;
const int SPELL_SPELLABILITY_Protective_Ward = 1875;
const int SPELL_SPELLABILITY_Healing_Touch = 1876;
const int SPELL_SPELLABILITY_Umbral_Shroud = 1877;
const int SPELLABILITY_AURA_DC_TEAMINIT = 1878;
const int DREADCOM_ARMORED_EASE = 1879;
const int WOD_DARKLING_WEAPON = 1880;
const int WOD_DARKLING_WEAPON_FLAMING = 1881;
const int WOD_DARKLING_WEAPON_FROST = 1882;
const int WOD_DARKLING_WEAPON_VAMP = 1883;
const int WOD_DARKLING_WEAPON_SHOCK = 1884;
const int WOD_DARKLING_WEAPON_CRITS = 1885;
const int WOD_SCARRED_FLESH = 1886;
const int WOD_REPELLANT_FLESH = 1887;
const int BLADESINGER_BLADESONG_STYLE = 1888;
const int BLADESINGER_SONG_CELERITY = 1889;
const int BLADESINGER_SONG_FURY = 1890;
const int SPELLABILITY_Crossbow_Sniper = 1891;
const int SPELLABILITY_Sacred_Vow = 1892;
const int SPELLABILITY_Ranged_Weapon_Mastery = 1893;
const int STORMSINGER_GUST_OF_WIND = 1894;
const int STORMSINGER_THUNDERSTRIKE = 1895;
const int STORMSINGER_CALL_LIGHTNING = 1896;
const int STORMSINGER_WINTER_BALLAD = 1897;
const int STORMSINGER_GTR_THUNDERSTRIKE = 1898;
const int STORMSINGER_STORM_VENGEANCE = 1899;
const int STORMSINGER_RESIST_ELECTRICITY = 1900;
const int AKNIGHT_ANOINT_WEAPON = 1901;
const int AKNIGHT_ANOINT_WEAPON_FLAMING = 1902;
const int AKNIGHT_ANOINT_WEAPON_FROST = 1903;
const int AKNIGHT_ANOINT_WEAPON_VAMP = 1904;
const int AKNIGHT_ANOINT_WEAPON_SHOCK = 1905;
const int AKNIGHT_ANOINT_WEAPON_CRITS = 1906;
const int AKNIGHT_UNBROKEN_FLESH = 1907;
const int AKNIGHT_SACRED_FLESH = 1908;
const int LION_TALISID_LIONS_COURAGE = 1909;
const int LION_TALISID_LIONS_SWIFTNESS = 1910;
const int LION_TALISID_LEONALS_ROAR = 1911;
const int SWIFTBLADE_SWIFTSURGE = 1912;

const int SPELLABILITY_Divine_Armor = 1915;
const int SPELLABILITY_Divine_Fortune = 1916;
const int SPELLABILITY_Divine_Cleansing = 1917;
const int SPELLABILITY_Divine_Vigor = 1918;
const int SPELLABILITY_Minor_Shapeshift = 1919;
const int SPELLABILITY_Minor_Shapeshift_Might = 1920;
const int SPELLABILITY_Minor_Shapeshift_Speed = 1921;
const int SPELLABILITY_Minor_Shapeshift_Vigor = 1922;
const int SPELLABILITY_Armored_Caster = 1923;
const int SPELLABILITY_Battle_Caster = 1924;
const int SPELLABILITY_Fast_Healing_I = 1925;
const int SPELLABILITY_Fast_Healing_II = 1926;
const int SPELLABILITY_Gtr_2Wpn_Defense = 1927;

const int SPELLABILITY_TOXIC_GIFT = 1933;
const int SPELLABILITY_ELEMENTAL_ESSENCE = 1934;
const int SPELLABILITY_ELEMENTAL_ESSENCE_A = 1935;
const int SPELLABILITY_ELEMENTAL_ESSENCE_C = 1936;
const int SPELLABILITY_ELEMENTAL_ESSENCE_E = 1937;
const int SPELLABILITY_ELEMENTAL_ESSENCE_F = 1938;
const int SPELLABILITY_ARMOR_SPECIALIZATION_MEDIUM = 1939;
const int SPELLABILITY_ARMOR_SPECIALIZATION_HEAVY = 1940;
const int SPELLABILITY_RACIAL_FAERIE_FIRE = 1941;
const int SPELLABILITY_OVERSIZE_TWO_WEAPON_FIGHTING = 1942; 
const int SPELLABILITY_MASTER_RADIANCE_SEARING_LIGHT = 1943;
const int SPELLABILITY_MASTER_RADIANCE_BEAM_SUNLIGHT = 1944;
const int SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA = 1945;
const int SPELLABILITY_PENETRATING_SHOT = 1946;
const int SPELLABILITY_BATTLE_DANCER = 1947;
const int SPELLABILITY_FIERY_FIST = 1948;
const int SPELLABILITY_FIERY_KI_DEFENSE = 1949;





const int SPELLABILITY_FAERIE_FIRE_PURPLE = 3883;
const int SPELLABILITY_FAERIE_FIRE_BLUE = 3884;
const int SPELLABILITY_FAERIE_FIRE_GREEN = 3885;

const int SPELLABILITY_COUNTERSPELL = 3885;

const int SPELLABILITY_EMPOWER_ELDBLAST = 2084;
const int SPELLABILITY_MAXIMIZE_ELDBLAST = 2085;
const int SPELLABILITY_PARAGON_VISIONARY = 2089;

const int SPELLABILITY_DRPIRATE_FIGHT2DEATH = 2130;

const int SPELLABILITY_LAY_ON_HANDS_ALLY = 1841;
const int SPELLABILITY_MINORSHAPESHIFT = 1869;
const int SPELLABILITY_SWIFTBLADE_INNERVATED_SPEED = 1913;

const int SPELLABILITY_MARKJUSTICE = 1929;

const int SPELLABILITY_TREEBROTHER = 1956;
const int SPELLABILITY_FORESTDOMINION = 1957;
const int SPELLABILITY_SPRUCEGROWTH = 1962;
const int SPELLABILITY_DEATHTOUCH = 1980;
const int SPELLABILITY_TOUCHWILD = 1981;

const int SPELLABILITY_GRAYENLARGE = 803;
const int SPELLABILITY_LITTORCH = 3815;

const int SPELLABILITY_UNARMED_COMBAT_MASTERY = 1952;
const int ELEM_ARCHER_ELEM_SHOT = 1953;
const int ELEM_ARCHER_ELEM_SHIELD = 1954;
const int ELEM_ARCHER_ELEM_STORM = 1955;

const int FOREST_MASTER_FOREST_HAMMER = 1958;
const int FOREST_MASTER_FOREST_HAMMER_FROST = 1959;
const int FOREST_MASTER_FOREST_HAMMER_SHOCK = 1960;
const int FOREST_MASTER_OAKEN_SKIN = 1961;
const int FOREST_MASTER_OAK_HEART = 1963;
const int FOREST_MASTER_DEEP_ROOTS = 1964;
const int FOREST_MASTER_FOREST_MIGHT = 1965;

const int SPELLABILITY_DARKLANT_CIT_TRAIN = 1967;
const int SPELLABILITY_HEARTWARD_HEART_PASSION = 1968;
const int SPELLABILITY_HEARTWARD_LIPS_RAPTURE = 1969;
const int SPELLABILITY_ARMOR_FROST = 1970;
const int SPELLABILITY_SKULLCLAN_HUNTERS_IMMUNITIES = 1971;
const int SPELLABILITY_CHAMPWILD_ELEGANT_STRIKE = 1972;
const int SPELLABILITY_CHAMPWILD_SUPERIOR_DEFENSE = 1973;
const int SPELLABILITY_CHAMPWILD_WRATH_WILD = 1974;



const int SPELLABILITY_ELEMWAR_AFFINITY = 2000;
const int SPELLABILITY_ELEMWAR_MANIFESTATION = 2004;
const int SPELLABILITY_ELEMWAR_WEAPON = 2005;
const int SPELLABILITY_ELEMWAR_SANCTUARY = 2006;
const int SPELLABILITY_ELEMWAR_STRIKE = 2007;
const int SPELLABILITY_WHDERV_CRITSENSE = 2008;


const int SONG_SNOWFLAKE_WARDANCE = 2029;
const int SPELLABILITY_CHLDNIGHT_CLOAK_SHADOWS = 2030;
const int SPELLABILITY_CHLDNIGHT_DANCE_SHADOWS = 2031;
const int SPELLABILITY_CHLDNIGHT_NIGHT_FORM = 2032;
const int SPELLABILITY_ELDDISC_DR = 2033;
const int SPELLABILITY_ELDDISC_FR = 2034;
const int SPELLABILITY_ELDDISC_HB = 2035;
const int SPELLABILITY_ELDDISC_WF = 2036;
const int SPELLABILITY_DRGWRR_RESIST_ENERGY = 2037;
const int SPELLABILITY_DRGWRR_ELEMENTAL_WEAPON = 2038;
const int SPELLABILITY_DRGWRR_DRG_BREATH = 2039;
const int SPELLABILITY_DISCHORD_BREAK_CONC = 2040;
const int SPELLABILITY_DISCHORD_DISJUNCT = 2041;
const int SPELLABILITY_PALADIN_SPIRIT_COMBAT = 2042;
const int SPELLABILITY_PALADIN_SPIRIT_HEROISM = 2043;
const int SPELLABILITY_PALADIN_SPIRIT_FALLEN = 2044;
const int SPELLABILITY_DERVISH_AC_BONUS = 2045;
const int SPELLABILITY_DERVISH_DANCE = 2046;
const int SPELLABILITY_THOUSAND_CUTS = 2047;
const int SPELLABILITY_NINJA_AC_BONUS = 2048;
const int SPELLABILITY_NINJA_GHOST_STEP = 2049;
const int SPELLABILITY_NINJA_KI_DODGE = 2050;
const int SPELLABILITY_NINJA_GHOST_STRIKE = 2051;
const int SPELLABILITY_NINJA_GHOST_WALK = 2052;
const int SPELLABILITY_GFK_GHOST_STEP = 2053;
const int SPELLABILITY_GFK_FRIGHTFUL_ATK = 2054;

const int SPELLABILITY_DRPIRATE_FEARSOME_REPUTATION = 2061;
const int SPELLABILITY_DRPIRATE_RALLY_THE_CREW = 2062;

const int SPELLABILITY_SCOUT_BATTLEFORT = 2064;
const int SPELLABILITY_SCOUT_SKIRMISHAC = 2065;
const int SPELLABILITY_VGUARD_PLANT_SHAPE = 2066;


const int SPELLABILITY_EXALTED_WILD_SHAPE = -3132;
const int SPELLABILITY_DRAGON_DIS_IMMUNITY = 1966;

const int SPELLABILITY_INTUITIVE_ATTACK = 1975;
const int SPELLABILITY_SHDWSTLKR_SACRED_STEALTH = 1984;
const int SPELLABILITY_SHDWSTLKR_DISCOVER_SUBTERFUGE = 1985;
const int SPELLABILITY_DRSLR_DMG_BONUS = 1986;
//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Spells Missing Constants
* These are the active spells without constants, These should be in nwscript.nss
********************************************************************************************************* @{ */
const int SPELL_ETHEREAL_JAUNT = 724;
const int SPELL_GREATER_SHADOW_CONJURATION = 71;
const int SPELL_SHADES = 158;
const int SPELL_SHADOW_CONJURATION = 159;
const int SPELL_PROTECTION_FROM_ALIGNMENT = 321;
const int SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 322;
const int SPELL_AURA_VERSUS_ALIGNMENT = 323;
const int SPELL_POLYMORPH_SWORD_SPIDER = 387;
const int SPELL_POLYMORPH_TROLL = 388;
const int SPELL_POLYMORPH_UMBER_HULK = 389;
const int SPELL_POLYMORPH_GARGOYLE = 390;
const int SPELL_POLYMORPH_MINDFLAYER = 391;
const int SPELL_SHAPECHANGE_FROST_GIANT = 392;
const int SPELL_SHAPECHANGE_FIRE_GIANT = 393;
const int SPELL_SHAPECHANGE_HORNED_DEVIL = 394;
const int SPELL_SHAPECHANGE_NIGHTWALKER = 395;
const int SPELL_SHAPECHANGE_IRON_GOLEM = 396;
const int SPELLABILITY_ELEMENTAL_SHAPE_FIRE = 397;
const int SPELLABILITY_ELEMENTAL_SHAPE_WATER = 398;
const int SPELLABILITY_ELEMENTAL_SHAPE_EARTH = 399;
const int SPELLABILITY_ELEMENTAL_SHAPE_AIR = 400;
const int SPELLABILITY_SPECIAL_ALCOHOL_BEER = 406;
const int SPELLABILITY_SPECIAL_ALCOHOL_WINE = 407;
const int SPELLABILITY_SPECIAL_ALCOHOL_SPIRITS = 408;
const int SPELLABILITY_SPECIAL_HERB_BELLADONNA = 409;
const int SPELLABILITY_SPECIAL_HERB_GARLIC = 410;
const int SPELLABILITY_BARDS_SONG = 411;
const int SPELLABILITY_ACTIVATE_ITEM_SELF = 413;
const int SPELL_OWLS_INSIGHT = 438;
const int SPELLABILITY_SLEEP = 480;
const int SPELLABILITY_CATS_GRACE = 481;
const int SPELLABILITY_EAGLE_SPLENDOR = 482;
const int SPELLABILITY_INVISIBILITY = 483;
const int SPELLABILITY_CHARGER = 509;
const int SPELLABILITY_GOBLIN_BALLISTA_FIREBALL = 553;
const int SPELLABILITY_AURAOFGLORY_X2 = 562;
const int SPELLABILITY_HASTE_SLOW_X2 = 563;
const int SPELLABILITY_SUMMON_SHADOW_X2 = 564;
const int SPELLABILITY_TIDE_OF_BATTLE = 565;
const int SPELLABILITY_EVIL_BLIGHT = 566;
const int SPELLABILITY_CURE_CRITICAL_WOUNDS_OTHERS = 567;
const int SPELLABILITY_RESTORATION_OTHERS = 568;
const int SPELLABILITY_TWINFISTS = 615;
const int SPELLABILITY_LICHLYRICS = 616;
const int SPELLABILITY_ICEBERRY = 617;
const int SPELLABILITY_FLAMEBERRY = 618;
const int SPELLABILITY_PRAYERBOX = 619;
const int SPELLABILITY_PLANARTURNING = 643;
const int SPELLABILITY_WYRMLINGPCBREATHCOLD = 663;
const int SPELLABILITY_WYRMLINGPCBREATHACID = 664;
const int SPELLABILITY_WYRMLINGPCBREATHFIRE = 665;
const int SPELLABILITY_WYRMLINGPCBREATHGAS = 666;
const int SPELLABILITY_WYRMLINGPCBREATHLIGHTNING = 667;
const int SPELLABILITY_ITEM_TELEPORT = 668;
const int SPELLABILITY_ITEM_CHAOS_SHIELD = 669;
const int SPELLABILITY_HARPYSONG = 686;
const int SPELLABILITY_GWILDSHAPE_STONEGAZE = 687;
const int SPELLABILITY_DRIDERDARKNESS = 688;
const int SPELLABILITY_SLAYRAKSHASA = 689;
const int SPELLABILITY_REDDRAGONDISCIPLEBREATH = 690;
const int SPELLABILITY_GREATER_WILD_SHAPE_SPIKES = 692;
const int SPELLABILITY_GWILDSHAPE_MINDBLAST = 693;
const int SPELLABILITY_ONHITFIREDAMAGE = 696;
const int SPELLABILITY_ACTIVATE_ITEM_L = 697;
//int SPELLABILITY_DRAGON_BREATH_NEGATIVE = 698;
const int SPELLABILITY_POISON_WEAPON_NX1 = 699;
const int SPELLABILITY_ACTIVATE_ITEM_ONHITSPELLCAST = 700;
const int SPELLABILITY_SUMMON_BAATEZU = 701;
const int SPELLABILITY_ONHITPLANARRIFT = 702;
const int SPELLABILITY_ONHITDARKFIRE = 703;
const int SPELLABILITY_GREATER_WILD_SHAPE_RED_DRAGON = 707;
const int SPELLABILITY_GREATER_WILD_SHAPE_BLUE_DRAGON = 708;
const int SPELLABILITY_GREATER_WILD_SHAPE_BLACK_DRAGON = 709;
const int SPELLABILITY_EYEBALLRAY0 = 710;
const int SPELLABILITY_EYEBALLRAY1 = 711;
const int SPELLABILITY_EYEBALLRAY2 = 712;
const int SPELLABILITY_MINDFLAYER_MINDBLAST_10 = 713;
const int SPELLABILITY_MINDFLAYER_PARAGON_MINDBLAST = 714;
const int SPELLABILITY_GOLEM_RANGED_SLAM = 715;
const int SPELLABILITY_SUCKBRAIN = 716;
const int SPELLABILITY_ACTIVATE_ITEM_SEQUENCER_1 = 717;
const int SPELLABILITY_ACTIVATE_ITEM_SEQUENCER_2 = 718;
const int SPELLABILITY_ACTIVATE_ITEM_SEQUENCER_3 = 719;
const int SPELLABILITY_CLEAR_SEQUENCER = 720;
const int SPELLABILITY_ONHITFLAMINGSKIN = 721;
const int SPELLABILITY_MIMIC_EAT = 722;
const int SPELLABILITY_MIMIC_GEM_THROWER = 723;
//const int SPELL_ETHEREAL_JAUNT = 724;
const int SPELLABILITY_DRAGON_SHAPE = 725;
const int SPELLABILITY_MIMIC_EAT_ENEMY = 726;
const int SPELLABILITY_BEHOLDER_ANTI_MAGIC_CONE = 727;
const int SPELLABILITY_MIMIC_STEAL_ARMOR = 729;
const int SPELLABILITY_BEBELITH_WEB = 731;
const int SPELLABILITY_BEHOLDER_SPECIAL_SPELL_AI = 736;
const int SPELLABILITY_PSIONIC_INERTIAL_BARRIER = 741;
const int SPELLABILITY_CRAFT_WEAPON_COMPONENT = 742;
const int SPELLABILITY_CRAFT_ARMOR_COMPONENT = 743;
const int SPELLABILITY_GRENADE_FIREBOMB = 744;
const int SPELLABILITY_GRENADE_ACIDBOMB = 745;
const int SPELLABILITY_HELL_CATAPULT_MALE = 746;
const int SPELLABILITY_HELL_CATAPULT_FEMALE = 747;
const int SPELLABILITY_HELL_BR_CATAPULT_MALE = 748;
const int SPELLABILITY_HELL_BRAZIER_MALE = 749;
const int SPELLABILITY_HELL_FENCE_MALE = 750;
const int SPELLABILITY_HELL_BOULDER_MALE = 751;
const int SPELLABILITY_HELL_TREE_MALE = 752;
const int SPELLABILITY_HELL_KNOWER_EFFECT1 = 753;
const int SPELLABILITY_HELL_KNOWER_EFFECT2 = 754;
const int SPELLABILITY_HELL_KNOWER_EFFECT3 = 755;
const int SPELLABILITY_ONHITBEBILITHATTACK = 756;
const int SPELLABILITY_SHADOWBLEND = 757;
const int SPELLABILITY_ONHITDEMILICHTOUCH = 758;
const int SPELLABILITY_UNDEADSELFHARM = 759;
const int SPELLABILITY_ONHITDRACOLICHTOUCH = 760;
const int SPELLABILITY_AURA_OF_HELLFIRE = 761;
const int SPELLABILITY_HELL_INFERNO = 762;
const int SPELLABILITY_PSIONIC_MASS_CONCUSSION = 763;
const int SPELLABILITY_GLYPHOFWARDINGDEFAULT = 764;
const int SPELLABILITY_HELL_KNOWER_EFFECT4 = 765;
const int SPELLABILITY_HELL_KNOWER_EFFECT5 = 766;
const int SPELLABILITY_INTELLIGENT_WEAPON_TALK = 767;
const int SPELLABILITY_INTELLIGENT_WEAPON_ONHIT = 768;
const int SPELLABILITY_SHADOW_ATTACK = 769;
const int SPELLABILITY_SLAAD_CHAOS_SPITTLE = 770;
const int SPELLABILITY_DRAGON_BREATH_PRISMATIC = 771;
const int SPELLABILITY_ACCELERATING_FIREBALL = 772;
const int SPELLABILITY_BATTLE_BOULDER_TOSS = 773;
const int SPELLABILITY_DEFLECTING_FORCE = 774;
const int SPELLABILITY_GIANT_HURL_ROCK = 775;
const int SPELLABILITY_BEHOLDER_NODE_1 = 776;
const int SPELLABILITY_BEHOLDER_NODE_2 = 777;
const int SPELLABILITY_BEHOLDER_NODE_3 = 778;
const int SPELLABILITY_BEHOLDER_NODE_4 = 779;
const int SPELLABILITY_BEHOLDER_NODE_5 = 780;
const int SPELLABILITY_BRIDGE_VFX = 781;
const int SPELLABILITY_SPHERE_SPELL = 782;
const int SPELLABILITY_BEHOLDER_NODE_6 = 783;
const int SPELLABILITY_BEHOLDER_NODE_7 = 784;
const int SPELLABILITY_BEHOLDER_NODE_8 = 785;
const int SPELLABILITY_BEHOLDER_NODE_9 = 786;
const int SPELLABILITY_BEHOLDER_NODE_10 = 787;
const int SPELLABILITY_ONHITPARALYZE = 788;
const int SPELLABILITY_ILLITHID_MINDBLAST = 789;
const int SPELLABILITY_ONHITDEAFENCLANG = 790;
const int SPELLABILITY_ONHITKNOCKDOWN = 791;
const int SPELLABILITY_ONHITFREEZE = 792;
const int SPELLABILITY_DEMONIC_GRAPPLING_HAND = 793;
const int SPELLABILITY_BALLISTA_BOLT = 794;
const int SPELLABILITY_ACTIVATE_ITEM_T = 795;
//int SPELLABILITY_DRAGON_BREATH_LIGHTNING = 796;
//int SPELLABILITY_DRAGON_BREATH_FIRE = 797;
//int SPELLABILITY_DRAGON_BREATH_GAS = 798;
const int SPELLABILITY_VAMPIRE_INVISIBILITY = 799;
const int SPELLABILITY_VAMPIRE_DOMINATIONGAZE = 800;
const int SPELLABILITY_SHIFTER_SPECTRE_ATTACK = 802;
const int SPELLABILITY_GRAY_ENLARGE = 803;
const int SPELLABILITY_GRAYINVISIBILITY = 804;
const int SPELLABILITY_FAERIEFIRE = 805;
const int SPELLABILITY_BLUR = 806;
const int SPELLABILITY_GUARDING_THE_LORD = 929;
const int SPELLABILITY_DETECT_MAGIC = 930;
const int SPELLABILITY_HIDEOUS_BLOW_IMPACT = 931;
const int SPELLABILITY_SEE_INVISIBILITY = 943;
const int SPELLABILITY_RACIALINVISIBILITY = 944;
const int SPELLABILITY_RACIALBLINDNESS_AND_DEAFNESS = 946;
const int SPELLABILITY_HARPERDOMINATE_ANIMAL = 947;
int SPELLABILITY_ELDRITCH_BLAST2 = 949;
int SPELLABILITY_ELDRITCH_BLAST3 = 950;
int SPELLABILITY_ELDRITCH_BLAST4 = 951;
int SPELLABILITY_ELDRITCH_BLAST5 = 952;
int SPELLABILITY_ELDRITCH_BLAST6 = 953;
int SPELLABILITY_ELDRITCH_BLAST7 = 954;
int SPELLABILITY_ELDRITCH_BLAST8 = 955;
int SPELLABILITY_ELDRITCH_BLAST9 = 956;
const int SPELLABILITY_WARPRIEST_MASS_CURE_LIGHT_WOUNDS = 961;
const int SPELLABILITY_WARPRIEST_BATTLETIDE = 963;
const int SPELLABILITY_WARPRIEST_MASS_HEAL = 965;
const int SPELLABILITY_AIR_ELEMENTAL_APPEARANCE = 991;
const int SPELL_TOUCH_OF_IDIOCY = 1051;
const int SPELL_MASS_AID = 1052;
const int SPELL_LIONHEART = 1053;
const int SPELL_RECITATION = 1054;
const int SPELL_SCORCHING_RAY = 1055;
const int SPELL_SCORCHING_RAY_MANY = 1056;
const int SPELL_SCORCHING_RAY_SINGLE = 1057;
int SPELL_EXTRACT_WATER_ELEMENTAL = 1058;
int SPELLABILITY_OTHERWORLDLY_WHISPERS = 1059;
int SPELLABILITY_DREAD_SEIZURE = 1060;
int SPELLABILITY_ELDRITCH_BLAST10 = 1061;
int SPELLABILITY_ELDRITCH_BLAST11 = 1062;
const int SPELLABILITY_ELDRITCH_BLAST12 = 1063;
const int SPELLABILITY_ELDRITCH_BLAST13 = 1064;
const int SPELLABILITY_ELDRITCH_BLAST14 = 1065;
const int SPELLABILITY_SONG_OF_REQUIEM = 1074;
const int SPELLABILITY_SPELLABILITY_RESCUE = 1075;
const int SPELLABILITY_DAMNATION = 1076;
const int SPELLABILITY_EPIC_GATE = 1078;
const int SPELLABILITY_MASS_FOWL = 1079;
const int SPELLABILITY_VAMPIRIC_FEAST = 1080;
const int SPELLABILITY_IMBUE_ITEM = 1081;
const int SPELLABILITY_CHASTISE_SPIRITS = 1094;
const int SPELLABILITY_DETECT_SPIRITS = 1095;
const int SPELLABILITY_SHAPERS_ALEMBIC = 1097;
const int SPELLABILITY_SHAPERS_ALEMBIC_DIVIDE = 1098;
const int SPELLABILITY_SHAPERS_ALEMBIC_COMBINE = 1099;
const int SPELLABILITY_SHAPERS_ALEMBIC_CONVERT = 1100;
const int SPELLABILITY_SPIRIT_FORM = 1102;
const int SPELLABILITY_SPIRIT_JOURNEY = 1103;
const int SPELLABILITY_FAVORED_OF_THE_SPIRITS = 1104;
const int SPELLABILITY_WEAKEN_SPIRITS = 1105;
const int SPELLABILITY_IMMUNITY_TO_ELECTRICITY = 1106;
const int SPELLABILITY_STORMLORD_STORM_AVATAR = 1107;
const int SPELLABILITY_SACRED_FLAMES = 1123;
const int SPELLABILITY_INNER_ARMOR = 1124;
const int SPELL_SOLIPSISM = 1129;
const int SPELLABILITY_HINDERING_BLAST = 1130;
const int SPELLABILITY_BINDING_BLAST = 1131;
const int SPELL_SHADOW_SIMULACRUM = 1132;
const int SPELL_GLASS_DOPPELGANGER = 1133;
const int SPELLABILITY_SCYTHE_DEVOUR_SPIRIT = 1140;
const int SPELLABILITY_WEAKNESS = 1141;
const int SPELLABILITY_SSWORD_NX1_SWORD_FORMS = 1142;
const int SPELLABILITY_SSWORD_NX1_PENETRATING_EDGE = 1143;
//int SPELLABILITY_SSWORD_NX1_ANTI-MAGIC_EDGE = 1144;
//int SPELLABILITY_SSWORD_NX1_UNITY_OF_WILL = 1145;
//int SPELLABILITY_SSWORD_NX1_SPELL-LIKE_ABILITIES = 1146;
const int SPELLABILITY_SSWORD_ICE_ATTACK = 1147;
const int SPELLABILITY_SSWORD_SONIC_ATTACK = 1148;
const int SPELLABILITY_SSWORD_DEFENSE = 1149;
const int SPELLABILITY_SSWORD_HEAL = 1151;
const int SPELLABILITY_SSWORD_NX1_VORPAL_EDGE = 1153;
const int SPELLABILITY_SSWORD_NX1_DEFENSIVE_EDGE = 1154;
const int SPELLABILITY_DREAD_WRAITH_CON_DRAIN = 1155;
const int SPELLABILITY_DEMILICH_TOUCH = 1156;
const int SPELLABILITY_RECALL_SPIRIT = 1157;
const int SPELLABILITY_SONG_CHORUS_OF_HEROISM = 1158;
const int SPELLABILITY_DISRUPTION_PROPERTY = 1159;
const int SPELLABILITY_AKACHI_POWERUP = 1160;
const int SPELLABILITY_AKACHI_POWERDOWN = 1161;


const int SPELL_ASN_Spellbook_1 = 1762;
const int SPELL_SB_Shocking_Blade = 1789;
const int SPELL_BFZ_Sacred_Flame = 1790;
const int SPELL_BFZ_Zealous_Heart = 1791;
const int SPELL_SB_Holy_Blade = 1792;

const int SPELL_DIVSEEK_SACRED_DEFENSE = 1834;
const int SPELL_DIVSEEK_SACRED_STEALTH = 1835;
const int SPELL_DIVSEEK_DIVINE_PERSERVERANCE = 1836;
const int SPELL_NIGHTSONGI_ADRENALINE_BOOST = 1837;
const int SPELL_SPELLABILITY_AURA_NI_TEAMWORK = 1838;
const int SPELL_SPELLABILITY_AURA_NE_TEAMWORK = 1839;
const int SPELL_NIGHTSONGE_AGILITY_TRAINING = 1840;
const int SPELL_Lay_On_Hands_HOSTILEv2 = 1842;
const int SPELL_NIGHTSONGI_TRACKLESS_STEP_ALLIES = 1843;

//const int SPELLABILITY_WARPRIEST_BATTLETIDE = 963;

//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Diseases
* Mostly from the PRC
********************************************************************************************************* @{ */

const int SPELL_AGONY                               = 2597;
const int SPELL_BACCARAN                            = 2598;
const int SPELL_DEVILWEED                           = 2599;
const int SPELL_LUHIX                               = 2600;
const int SPELL_MUSHROOM_POWDER                     = 2601;
const int SPELL_SANNISH                             = 2602;
//const int SPELL_TERRAN_BRANDY                       = 2603;
const int SPELL_VODARE                              = 2604;

const int DISEASE_CONTAGION_BLINDING_SICKNESS   = 20;
const int DISEASE_CONTAGION_CACKLE_FEVER        = 21;
const int DISEASE_CONTAGION_FILTH_FEVER         = 22;
const int DISEASE_CONTAGION_MINDFIRE            = 23;
const int DISEASE_CONTAGION_RED_ACHE            = 24;
const int DISEASE_CONTAGION_SHAKES              = 25;
const int DISEASE_CONTAGION_SLIMY_DOOM          = 26;
const int DISEASE_PESTILENCE                    = 51;
const int DISEASE_BLUE_GUTS                     = 53;
const int DISEASE_SOUL_ROT                      = 54;
const int DISEASE_AGONY_ADDICTION               = 55;
const int DISEASE_BACCARAN_ADDICTION            = 56;
const int DISEASE_DEVILWEED_ADDICTION           = 57;
const int DISEASE_LUHIX_ADDICTION               = 58;
const int DISEASE_MUSHROOM_POWDER_ADDICTION     = 59;
const int DISEASE_SANNISH_ADDICTION             = 60;
const int DISEASE_TERRAN_BRANDY_ADDICTION       = 61;
const int DISEASE_VODARE_ADDICTION              = 62;

//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Poisons
* Mostly from the PRC
********************************************************************************************************* @{ */

const int POISON_TINY_CENTIPEDE_POISON          = 122;
const int POISON_MEDIUM_CENTIPEDE_POISON        = 123;
const int POISON_LARGE_CENTIPEDE_POISON         = 124;
const int POISON_HUGE_CENTIPEDE_POISON          = 125;
const int POISON_GARGANTUAN_CENTIPEDE_POISON    = 126;
const int POISON_COLOSSAL_CENTIPEDE_POISON      = 127;

const int POISON_TINY_SCORPION_VENOM            = 128;
const int POISON_SMALL_SCORPION_VENOM           = 129;
const int POISON_MEDIUM_SCORPION_VENOM          = 130;
const int POISON_HUGE_SCORPION_VENOM            = 131;
const int POISON_GARGANTUAN_SCORPION_VENOM      = 132;
const int POISON_COLOSSAL_SCOPRION_VENOM        = 133;

const int POISON_EYEBLAST                       = 134;
const int POISON_BALOR_BILE                     = 135;
const int POISON_VILESTAR                       = 136;
const int POISON_SASSON_JUICE                   = 137;

const int POISON_SUFFERFUME                     = 138;
const int POISON_URTHANYK                       = 139;
const int POISON_MIST_OF_NOURN                  = 140;
const int POISON_ISHENTAV                       = 141;
const int POISON_BURNING_ANGEL_WING_FUMES       = 142;

const int POISON_RAVAGE_GOLDEN_ICE              = 100;
const int POISON_RAVAGE_CELESTIAL_LIGHTSBLOOD   = 143;
const int POISON_RAVAGE_JADE_WATER              = 144;
const int POISON_RAVAGE_PURIFIED_COUATL_VENOM   = 145;
const int POISON_RAVAGE_UNICORN_BLOOD           = 146;

//@} ****************************************************************************************************