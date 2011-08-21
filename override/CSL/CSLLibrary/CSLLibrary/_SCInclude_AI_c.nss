int giCSLTotalScriptsRunning; // this is added soas to keep track of how many AI scripts are running in a round, if too many i can use this to do less intensive AI processing, or delay things until it's not so busy.


int giBestDispelCastingLevel;
int giBestSpellResistanceReduction;
int globalBestEnemyCount;

float gfMaximumAllyDamage;
float gfAllyDamageWeight;
float gfMaximumAllyEffect;

int giCurNumMaxAreaTest;
int giCurNumMaxSingleTest;

int gbRangedTouchAttackInit;

string gsRangeSaveStr;

float gfMinHealAmountArea;
float gfLastHealAmountArea;
float gfMinHealWeightArea;
float gfMinHealAmountSingle;
float gfLastHealAmountSingle;
float gfMinHealWeightSingle;
float gfMinHarmAmountArea;
float gfLastHarmAmountArea;
float gfMinHarmWeightArea;
float gfMinHarmAmountSingle;
float gfLastHarmAmountSingle;
float gfMinHarmWeightSingle;

// one of the HENCH_INT_* values
int giIntelligenceLevel;

// global basic target information
object goClosestSeenEnemy;
object goClosestHeardEnemy;
object goClosestNonActiveEnemy;
object goClosestSeenOrHeardEnemy;
object goNotHeardOrSeenEnemy;
object goLastTarget;
object goCharmedAlly;
object goDeadFriend;

// used in SC GetThreatRating
float gfOverrideTargetWeight;
object goOverrideTarget;


object goClosestSeenFriend;

float gfAdjustedThreatRating;

int gbMeleeAttackers;
int gbAnyValidTarget;
int gbLineOfSightHeardEnemy;
int gbIAmStuck;
// these globals are used internally
int giCurSeenCreatureCount;
int giCurHeardCreatureCount;
int giSpecialTargeting;
int gbEnableMoveAway;
int gbFoundInfiniteBuffSpell;


// caster level (spell resistance)
int giMySpellCasterLevel;
int giMySpellCasterSpellPenetration;
// DC for spells
int giMySpellCasterDC;
// touch attacks
int giMyRangedTouchAttack;
int giMyMeleeTouchAttack;

int giMySpellCastingConcentration;
int gbAnySpellcastingClasses;

int giWarlockDamageDice;
int giWarlockMinSaveDC;
int gbWarlockMaster;


int gbDisableNonHealorCure;
int gbDoingBuff;
int gbDisableNonUnlimitedOrHealOrCure;
int gbSpellInfoCastMask;

// adjustments for spellcasting chances
float gfBuffSelfWeight;
float gfBuffOthersWeight;
float gfAttackWeight;

object goSaveMeleeAttackTarget;		// saved melee attack target
float gfSaveAttackChance;   // chance of any hit occurring during round

float gfAttackTargetWeight;   // weight of current best attack option

float gfBuffTargetWeight;   // weight of current best buff option

float bfBuffTargetAccumWeight;	// accumulated weight of pending buffs
int giNumberOfPendingBuffs;			// number of pending buffs

float gfSelfInvisiblityWeight;	// weight of best self invisibility

float gfSelfHideWeight;	// weight of best self hide (early rounds)

int gbCheckInvisbility;
int gbTrueSeeingNear;
int gbSeeInvisNear;

string gsCurrentSpellInfoStr;

float gfHealingThreshold;
int giRegenHealScaleAmount;
int giHealingDivisor;

object goHealingKit;

int gbDisabledAllyFound;

object goBestSpellCaster;

int giHenchUseSpellProtectionsChecked;

int gbHealingListInit;

float gbHealingAttackWeight;
float gbHarmAttackWeight;

int gbDisableHighLevelSpells;






// new "made up" immunity types that don't exist in NWSCRIPT but are used in spells.2da.
const int SCFAKE_IMMUNITY_TYPE_DIVINE			= -1; 
const int SCFAKE_IMMUNITY_TYPE_ACID				= -2; 
const int SCFAKE_IMMUNITY_TYPE_FIRE				= -3; 
const int SCFAKE_IMMUNITY_TYPE_ELECTRICITY		= -4; 
const int SCFAKE_IMMUNITY_TYPE_COLD				= -5; 
const int SCFAKE_IMMUNITY_TYPE_SONIC			= -6; 
const int SCFAKE_IMMUNITY_TYPE_NEGATIVE			= -7; // Spell Immunity that apply solely to "NegativeImmune" Races.
const int SCFAKE_IMMUNITY_TYPE_POSITIVE			= -8; 
const int SCFAKE_IMMUNITY_TYPE_NON_SPIRIT		= -9; 

const float HENCH_MAX_SCOUT_DISTANCE = 35.0;

/**** Names for the local variables that go on the NPCs ****/

// Holds the current one-liner
const string HENCH_ONELINER_VARNAME = "X0_CURRENT_ONE_LINER";

// Holds whether this NPC's one-shot event has occurred
//const string sOneShotVarname = "X0_ONE_SHOT_EVENT";




/**** Number of henchmen ****/
const int X2_NUMBER_HENCHMEN = 2; // This won't be the same as the GetMaxHenchmen() function due to followers


/**** XP1 Henchmen tags ****/

/**** variable names and suffixes ****/
const string HENCH_DEATH_VARNAME = "NW_L_HEN_I_DIED";

const string HENCH_LASTMASTER_VARNAME = "X0_LAST_MASTER_TAG";


// Amount of time to pass between respawn checks
const float HENCH_DELAY_BETWEEN_RESPAWN_CHECKS = 3.0f;

// * duration henchmen play their die animations

// The maximum length of the wait before respawn
const float HENCH_MAX_RESPAWN_WAIT = 60.0f;

/**** Script names ****/
const string HENCH_GOHOME_SCRIPT = "x0_ch_hen_gohome";

// This is the name of the local variable that holds the spawn-in conditions

// The available spawn-in conditions




//const int NW_TALENT_PROTECT = 1;
const int NW_MODE_STEALTH                = 0x00000001;
const int NW_MODE_DETECT                 = 0x00000002;






// melee distance
const float MELEE_DISTANCE = 3.0;


//==============================================================
// Shout constants
//==============================================================

// NOT USED
const int NW_GENERIC_SHOUT_I_WAS_ATTACKED = 1;

//IN OnDeath Script
const int NW_GENERIC_SHOUT_I_AM_DEAD = 12;

//IN SC TalentMeleeAttacked
//const int NW_GENERIC_SHOUT_BACK_UP_NEEDED = 13;

//const int NW_GENERIC_SHOUT_BLOCKER = 2;

//==============================================================
// SC ChooseTactics constants
//==============================================================

const int      CHOOSETACTICS_MEMORY_OFFENSE_MELEE    = 0;
const int      CHOOSETACTICS_MEMORY_DEFENSE_OTHERS   = 1;
const int      CHOOSETACTICS_MEMORY_DEFENSE_SELF     = 2;
const int      CHOOSETACTICS_MEMORY_OFFENSE_SPELL    = 3;

// IF this is true there is no CR consideration for using powers
const int NO_SMART = FALSE;

const float DEFEND_MASTER_MAX_TARGET_DISTANCE = 22.0f;

// Added by Brent, constant for 'always get me it' things like Healing
const int TALENT_ANY = 20;


// Bitwise constants for negative conditions we might want to try to cure
const int COND_CURSE     = 0x00000001;
const int COND_POISON    = 0x00000002;
const int COND_DISEASE   = 0x00000004;
const int COND_ABILITY   = 0x00000008;
const int COND_DRAINED   = 0x00000010;
const int COND_BLINDDEAF = 0x00000020;
const int COND_FEAR      = 0x00000040;
const int COND_PARALYZE  = 0x00000080;
const int COND_PETRIFY   = 0x00000100;
const int COND_SLOW   	 = 0x00000200;

const float WHIRL_DISTANCE = 3.0; // * Shortened distance so its more effective (went from 5.0 to 2.0 and up to 3.0)

// these str refs double as identifiers for SC SetBehavior function, so do not set as -1, or make multiple values equal.

const int STR_REF_BEHAVIOR_FOLLOWDIST_NEAR          = 179925;
const int STR_REF_BEHAVIOR_FOLLOWDIST_MED           = 179926;
const int STR_REF_BEHAVIOR_FOLLOWDIST_FAR           = 179927;
const int STR_REF_BEHAVIOR_DEF_MASTER_ON            = 179928;
const int STR_REF_BEHAVIOR_DEF_MASTER_OFF           = 179929;
const int STR_REF_BEHAVIOR_RETRY_LOCKS_ON           = 179930;
const int STR_REF_BEHAVIOR_RETRY_LOCKS_OFF          = 179931;
const int STR_REF_BEHAVIOR_STEALTH_MODE_NONE        = 179932; 
const int STR_REF_BEHAVIOR_STEALTH_MODE_PERM        = 179933;
const int STR_REF_BEHAVIOR_STEALTH_MODE_TEMP        = 179934;
const int STR_REF_BEHAVIOR_DISARM_TRAPS_ON          = 179936;
const int STR_REF_BEHAVIOR_DISARM_TRAPS_OFF         = 179937;
const int STR_REF_BEHAVIOR_DISPEL_ON                = 179938;
const int STR_REF_BEHAVIOR_DISPEL_OFF               = 179939;
//const int STR_REF_BEHAVIOR_CASTING_ON               = 179940;
const int STR_REF_BEHAVIOR_CASTING_OFF              = 179941;
const int STR_REF_BEHAVIOR_CASTING_OVERKILL         = 182915;
const int STR_REF_BEHAVIOR_CASTING_POWER            = 182914;
const int STR_REF_BEHAVIOR_CASTING_SCALED           = 182913;
const int STR_REF_BEHAVIOR_ITEM_USE_ON            	= 183071;
const int STR_REF_BEHAVIOR_ITEM_USE_OFF          	= 183070;
const int STR_REF_BEHAVIOR_FEAT_USE_ON            	= 183216;
const int STR_REF_BEHAVIOR_FEAT_USE_OFF          	= 183215;
const int STR_REF_BEHAVIOR_PUPPET_ON            	= 183222;
const int STR_REF_BEHAVIOR_PUPPET_OFF          		= 183223;
const int STR_REF_BEHAVIOR_COMBAT_MODE_USE_ON		= 184645;
const int STR_REF_BEHAVIOR_COMBAT_MODE_USE_OFF		= 184646;









const int CSL_CHARMOD_HENCHMODIFIERID = 18050;

const int INFLUENCE_MIN = -100; // Companion Influence cap
const int INFLUENCE_MAX = 100;

// const string GUI_SCRIPT_SCREEN_PARTYSELECT = "SCRIPT_SCREEN_PARTYSELECT";

// Prefix for the companion spawnpoints.  For example, bishop will
// spawn at waypoint w/ tag "spawn_bishop"
///const string COMPANION_SPAWN_WP_PREFIX = "spawn_";


const int FOCUSED_FULL 		= 2;	// fully focused
const int FOCUSED_PARTIAL 	= 1;	// will only become unfocused if attacked
const int FOCUSED_STANDARD 	= 0;	// treated as full focus when in conversations
const int FOCUSED_NONE 		= -1;	// same as original scripts
const string VAR_FOCUSED	= "Focused";


// This constant somewhat matches taking a henchmen hit dice and converting to CR rating
const float HENCH_HITDICE_TO_CR = 0.7;

// hitpoints threshold for death
const float HENCH_MAX_SNEAK_ATTACK_DISTANCE     = 10.0;

// stored healing information state
const int HENCH_HEAL_SELF_UNKNOWN   = 0;
const int HENCH_HEAL_SELF_CANT      = 1;
const int HENCH_HEAL_SELF_WAIT      = 2;
const int HENCH_HEAL_SELF_IN_PROG   = 3;
const string HENCH_HEAL_SELF_STATE  = "HenchHealSelfState";

// new behavior settings used by this AI
const int HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH  =   0x00000001; // only for associates
const int HENCH_ASC_USE_RANGED_WEAPON           =   0x00000002; // this is not actually saved, use CSL_ASC_USE_RANGED_WEAPON
const int HENCH_ASC_BEEN_SET_ONCE               =   0x00000002; // reuse of ranged weapon bit, this is set once to indicate basic flags have been set
const int HENCH_ASC_MELEE_DISTANCE_NEAR         =   0x00000004; // pick only one of the melee distance options
const int HENCH_ASC_MELEE_DISTANCE_MED          =   0x00000008;
const int HENCH_ASC_MELEE_DISTANCE_FAR          =   0x00000010;
const int HENCH_ASC_ENABLE_BACK_AWAY            =   0x00000020; // creature will try to avoid melee combat
const int HENCH_ASC_DISABLE_SUMMONS             =   0x00000040; // creature will not summon allies
const int HENCH_ASC_ENABLE_DUAL_WIELDING        =   0x00000080; // creature will dual wield (setting not needed if creature has two weapon fighting feat)
const int HENCH_ASC_DISABLE_DUAL_WIELDING       =   0x00000100; // creature will not dual wield
const int HENCH_ASC_DISABLE_DUAL_HEAVY          =   0x00000200; // only use light off hand weapons
const int HENCH_ASC_DISABLE_SHIELD_USE          =   0x00000400; // don't use a shield even if you have shield feats
const int HENCH_ASC_RECOVER_TRAPS               =   0x00000800; // only for associates
const int HENCH_ASC_AUTO_OPEN_LOCKS             =   0x00001000; // only for associates
const int HENCH_ASC_AUTO_PICKUP                 =   0x00002000; // only for companions
const int HENCH_ASC_DISABLE_POLYMORPH           =   0x00004000; // don't attempt polymorph or stone/ironskin
const int HENCH_ASC_DISABLE_INFINITE_BUFF       =   0x00008000; // only for associates
const int HENCH_ASC_ENABLE_HEALING_ITEM_USE     =   0x00010000; // only for associates
const int HENCH_ASC_DISABLE_AUTO_HIDE           =   0x00020000; // creature will not use stealth in combat or when master uses stealth
const int HENCH_ASC_GUARD_DISTANCE_NEAR         =   0x00040000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_MED          =   0x00080000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_FAR          =   0x00100000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_DEFAULT      =   0x00140000; // special for use in case statement
const int HENCH_ASC_MELEE_DISTANCE_ANY          =   0x00200000; // creature will go to melee if any members of party are melee with target
const int HENCH_ASC_NO_MELEE_ATTACKS            =   0x00400000; // creature will not use melee attacks
const int HENCH_ASC_NON_SAFE_RECOVER_TRAPS      =   0x00800000; // only for associates
const int HENCH_ASC_PAUSE_EVERY_ROUND		    =   0x01000000; // only for companions, pause every round instead of change target or nothing to do
//const int HENCH_ASC_IGNORE_SHOUTS             =   0x02000000; // not implemented, creature will not respond to shouts, only for associates
//const int HENCH_ASC_WEAPON_ATTACK_BONUS       =   0x04000000; // not implemented, equip weapons based on attack bonus

// in addition these standard associate settings work for monsters also -
// CSL_ASC_HEAL_AT_75, CSL_ASC_HEAL_AT_50, CSL_ASC_HEAL_AT_25   percentage to heal at

// state options for entire party (stored on PC)
const int HENCH_PARTY_UNEQUIP_WEAPONS           =   0x00000001; // party members will unequip weapons outside of combat
const int HENCH_PARTY_SUMMON_FAMILIARS          =   0x00000002; // party members will summon familiars outside of combat
const int HENCH_PARTY_SUMMON_COMPANIONS         =   0x00000004; // party members will summon animal companions outside of combat
const int HENCH_PARTY_LOW_ALLY_DAMAGE         	=   0x00000008; // party members avoid giving damage to allies
const int HENCH_PARTY_MEDIUM_ALLY_DAMAGE       	=   0x00000010; // party members give small amount of damage to allies
const int HENCH_PARTY_HIGH_ALLY_DAMAGE       	=   0x00000020; // party members give moderate amount of damage to allies
const int HENCH_PARTY_DISABLE_PEACEFUL_MODE		=   0x00000040; // don't turn on peaceful mode with follow command
const int HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF	=   0x00000080; // disable group buff and heal from having PC cast
const int HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG	=   0x00000100; // disable showing weapon switching messages
const int HENCH_PARTY_ENABLE_PUPPET_FOLLOW		=   0x00000200; // enable puppet mode out of combat follow and other activities


// missing action modes
const int HENCH_ACTION_MODE_TRACKING            = 14;   // tracking action mode

// missing actions
const int HENCH_ACTION_MOVETOLOCATION           = 43;   // seems to occur when moving to location


// constants for standard NWN2 settings

const int HENCH_AC_INCREASE_OFFSET = 6;


const int HENCH_AI_REGEN_RATE_ROUNDS = 4;

// global spell failure chance
float gfSpellFailureChance;



const int HENCH_SPELL_INFO_VERSION                  = 0x16000000;
const int HENCH_SPELL_INFO_VERSION_MASK             = 0xff000000;

const int HENCH_CLASS_SPELL_PROG_MASK		= 0x00000007;

const int HENCH_FULL_SPELL_PROGRESSION 				= 0x7;
const int HENCH_SKIP_FIRST_SPELL_PROGRESSION		= 0x6;
const int HENCH_SKIP_FOURTH_SPELL_PROGRESSION		= 0x5;
const int HENCH_EVERY_OTHER_ODD_SPELL_PROGRESSION	= 0x4;
const int HENCH_EVERY_OTHER_EVEN_SPELL_PROGRESSION	= 0x3;
const int HENCH_SKIP_FIRST_THIRD_SPELL_PROGRESSION	= 0x2;
//const int HENCH_NO_SPELL_PROGRESSION				= 0x0;
		
const int HENCH_CLASS_FEAT_SPELLS			= 0x00000008;
const int HENCH_CLASS_PRC_FLAG				= 0x00000010;
const int HENCH_CLASS_DIVINE_FLAG			= 0x00000020;
const int HENCH_CLASS_DC_BONUS_FLAG			= 0x00000040;
const int HENCH_CLASS_FOURTH_LEVEL_NEEDED	= 0x00000080;
const int HENCH_CLASS_ABILITY_MODIFIER_MASK	= 0x00000300;
const int HENCH_CLASS_ABILITY_MODIFIER_SHIFT	= 8;
const int HENCH_CLASS_BUFF_OTHERS_MASK		= 0x00000c00;
const int HENCH_CLASS_BUFF_OTHERS_FULL		= 0x00000000;
const int HENCH_CLASS_BUFF_OTHERS_HIGH		= 0x00000400;
const int HENCH_CLASS_BUFF_OTHERS_MEDIUM	= 0x00000800;
//const int HENCH_CLASS_BUFF_OTHERS_LOW		= 0x00000c00;
const int HENCH_CLASS_ATTACK_MASK			= 0x00003000;
const int HENCH_CLASS_ATTACK_FULL			= 0x00000000;
const int HENCH_CLASS_ATTACK_HIGH			= 0x00001000;
const int HENCH_CLASS_ATTACK_MEDIUM			= 0x00002000;
//const int HENCH_CLASS_ATTACK_LOW			= 0x00003000;

const int HENCH_CLASS_SA_MASK					= 0x0001c000;	// sneak attack info
const int HENCH_CLASS_SA_NONE					= 0x00000000;
const int HENCH_CLASS_SA_EVERY_OTHER_ODD		= 0x00004000;
const int HENCH_CLASS_SA_EVERY_OTHER_EVEN		= 0x00008000;
const int HENCH_CLASS_SA_EVERY_THIRD_SKIP_FIRST	= 0x0000c000;
const int HENCH_CLASS_SA_EVERY_THIRD			= 0x00010000;
const int HENCH_CLASS_SA_EVERY_THIRD_FROM_TWO	= 0x00014000;
const int HENCH_CLASS_SA_EVERY_THIRD_FROM_ONE	= 0x00018000;
const int HENCH_CLASS_SA_EVERY_FORTH			= 0x0001c000;

const int HENCH_CLASS_TURN_UNDEAD_STACK		= 0x00020000;
const int HENCH_CLASS_IGNORE_SILENCE		= 0x00040000;

// feat spell info
const int HENCH_FEAT_SPELL_MASK_FEAT		= 0x0000ffff;
const int HENCH_FEAT_SPELL_MASK_SPELL		= 0x3fff0000;
//const int HENCH_FEAT_SPELL_CHEAT_CAST		= 0x40000000;




const int HENCH_RACIAL_FEAT_SPELLS			= 0x00000008;

// how frequently shouts are done by monsters to call in allies to help
// DM clients can get flooded with these messages in which case the
// number can be increased to reduce the frequency.
const int HENCH_MONSTER_SHOUT_FREQUENCY = 10;


// This flag turns off when set to true monsters hearing other monsters and
// attacking them
const int HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER = TRUE;

// general global options
const int HENCH_OPTION_STEALTH = 0x0001;      // monsters use stealth
const int HENCH_OPTION_WANDER  = 0x0002;      // monsters can wander
const int HENCH_OPTION_UNLOCK  = 0x0004;      // monsters can unlock or bash locked doors
const int HENCH_OPTION_OPEN    = 0x0008;      // monsters can open doors
const int HENCH_OPTION_KNOCKDOWN_DISABLED	= 0x0010; // everyone - disable use of knockdown
const int HENCH_OPTION_KNOCKDOWN_SOMETIMES	= 0x0020; // everyone - tone down use of knockdown
const int HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET    = 0x00040;      // disable auto set of companion behaviors
const int HENCH_OPTION_ENABLE_AUTO_BUFF        		= 0x00080;      // non members of PC party automatically use long duration buffs at start of combat
const int HENCH_OPTION_ENABLE_ITEM_CREATION         = 0x00100;      // non members of PC party get healing potions, etc. at start of combat
const int HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE     = 0x00200;      // non members of PC party are able to use equipped items (run at start of combat)
const int HENCH_OPTION_ENABLE_INVENTORY_DISTRURBED  = 0x00400;      // monsters react to disturb events (pickpocket)
const int HENCH_OPTION_HIDEOUS_BLOW_INSTANT			= 0x00800;      // warlock hideous blow is cast instant (one round to attack instead of two)
const int HENCH_OPTION_MONSTER_ALLY_DAMAGE			= 0x01000;      // monsters damage allies based on alignment
const int HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF      = 0x02000;      // non members of PC party automatically use medium duration buffs at start of combat, long duration must already be set up
const int HENCH_OPTION_DISABLE_HB_HEARING     		= 0x04000;      // turn off heartbeat hearing for monsters and associates
const int HENCH_OPTION_DISABLE_HB_DETECTION    		= 0x08000;      // turn off heartbeat detection of enemies for monsters and associates
const int HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH 		= 0x10000;      // in puppet mode, pause and switch to companions
const int HENCH_OPTION_ENABLE_PAUSE_FOR_TRAPS 		= 0x20000;      // pause the game when a trap is found
const int HENCH_OPTION_DISABLE_ATTACK_DYING 		= 0x40000;      // don't attack dying enemies

//const int HENCH_MONAI_DISTRIB = 0x0010;      // monsters distribute themselves when attacking
//const int HENCH_MONAI_COMP    = 0x0080;      // monsters summon familiars and animal companions

const int HENCH_OPTION_SET_ONCE      = 0x40000000;      // global options set once, 0x80000000 can't be used with campaign integers



const string HENCH_CAMPAIGN_DB = "compaisettings"; // mispelled but always has been

const float HENCH_HEARING_DISTANCE = 5.0;
const float HENCH_MASTER_HEARING_DISTANCE = 100.0;
const float HENCH_MAX_ENCHANTMENT_WEIGHT = 0.5;

const int HENCH_SPELL_INFO_DAMAGE_BREACH	= 0x1;
const int HENCH_SPELL_INFO_DAMAGE_DISPEL	= 0x2;
const int HENCH_SPELL_INFO_DAMAGE_RESIST	= 0x4;



const int HENCH_AI_SCRIPT_NOT_RUN       = 0;
const int HENCH_AI_SCRIPT_IN_PROGRESS   = 1;
const int HENCH_AI_SCRIPT_ALREADY_RUN   = 2;

const float HENCH_AI_SCRIPT_DELAY       = 0.03;

const string HENCH_AI_SCRIPT_RUN_STATE      =  "AIIntruder";
const string HENCH_AI_SCRIPT_FORCE          =  "AIIntruderForce";
const string HENCH_AI_SCRIPT_INTRUDER_OBJ   =  "AIIntruderObj";
const string HENCH_AI_SCRIPT_POLL           =  "AIIntruderPoll";

const string HENCH_LAST_HEARD_OR_SEEN          = "LastSeenOrHeard";

const int HENCH_STEP_FORWARD 	= 0;
const int HENCH_STEP_RIGHT 		= 1;
const int HENCH_STEP_LEFT 		= 2;
const int HENCH_STEP_NONE 		= 3;

// Auldar: Configurable distance at which to "hide", if the PC, or PC's Associate is within that distance.
// TK 40 doesn't seem to be far enough
const float HENCH_STEALTH_DIST_THRESHOLD = 80.0;

// globals for spells

const float HENCH_CREATURE_SAVE_UNKNOWN		= -1000.0;
const float HENCH_CREATURE_SAVE_ABORT		= -500.0;


const float HENCH_LOW_ALLY_DAMAGE_THRESHOLD		= 0.05;
const float HENCH_MED_ALLY_DAMAGE_THRESHOLD		= 0.15;
const float HENCH_HIGH_ALLY_DAMAGE_THRESHOLD	= 0.5;
const float HENCH_EXTR_ALLY_DAMAGE_THRESHOLD	= 100.0;

const float HENCH_LOW_ALLY_DAMAGE_WEIGHT		= -3.0;
const float HENCH_MED_ALLY_DAMAGE_WEIGHT		= -2.0;
const float HENCH_HIGH_ALLY_DAMAGE_WEIGHT		= -1.0;



const int HENCH_ATTACK_NO_CHECK										= 0;
const int HENCH_ATTACK_CHECK_HEAL									= 1;
const int HENCH_ATTACK_CHECK_NEG_HEALING							= 2;
const int HENCH_ATTACK_CHECK_HUMANOID								= 3;
const int HENCH_ATTACK_CHECK_NOT_ALREADY_EFFECTED					= 4;
const int HENCH_ATTACK_CHECK_INCORPOREAL							= 5;
const int HENCH_ATTACK_CHECK_DARKNESS								= 6;
const int HENCH_ATTACK_CHECK_PETRIFY								= 7;
const int HENCH_ATTACK_CHECK_ANIMAL									= 8;
const int HENCH_ATTACK_CHECK_NOT_CONSTRUCT_OR_UNDEAD				= 9;
const int HENCH_ATTACK_CHECK_DROWN									= 10;
const int HENCH_ATTACK_CHECK_SLEEP									= 11;
const int HENCH_ATTACK_CHECK_BIGBY									= 12;
const int HENCH_ATTACK_CHECK_UNDEAD									= 13;
const int HENCH_ATTACK_CHECK_NOT_UNDEAD								= 14;
const int HENCH_ATTACK_CHECK_IMMUNITY_PHANTASMS						= 15;
const int HENCH_ATTACK_CHECK_MAGIC_MISSLE							= 16;
const int HENCH_ATTACK_CHECK_INFERNO_OR_COMBUST						= 17;
const int HENCH_ATTACK_CHECK_DISMISSAL_OR_BANISHMENT				= 18;
const int HENCH_ATTACK_CHECK_SPELLCASTER							= 19;
const int HENCH_ATTACK_CHECK_NOT_ELF								= 20;
const int HENCH_ATTACK_CHECK_CONSTRUCT								= 21;
const int HENCH_ATTACK_CHECK_SEARING_LIGHT							= 22;
const int HENCH_ATTACK_CHECK_MINDBLAST								= 23;
const int HENCH_ATTACK_CHECK_EVARDS_TENTACLES						= 24;
const int HENCH_ATTACK_CHECK_IRONHORN								= 25;
const int HENCH_ATTACK_CHECK_PRISM									= 26;
const int HENCH_ATTACK_CHECK_SPIRIT									= 27;
const int HENCH_ATTACK_CHECK_WORDOFFAITH							= 28;
const int HENCH_ATTACK_CHECK_CLOUDKILL								= 29;
const int HENCH_ATTACK_CHECK_HUMANOID_OR_ANIMAL						= 30;
const int HENCH_ATTACK_CHECK_DAZE									= 31;
const int HENCH_ATTACK_CHECK_TASHAS									= 32;
const int HENCH_ATTACK_CHECK_CAUSE_FEAR								= 33;
const int HENCH_ATTACK_CHECK_PERCENTAGE								= 34;
const int HENCH_ATTACK_CHECK_CREEPING_DOOM							= 35;
const int HENCH_ATTACK_CHECK_DEATH_KNELL							= 36;
const int HENCH_ATTACK_CHECK_WARLOCK								= 37;
const int HENCH_ATTACK_CHECK_MOONBOLT								= 38;
const int HENCH_ATTACK_CHECK_SWAMPLUNG								= 39;
const int HENCH_ATTACK_CHECK_SEEN									= 40;
const int HENCH_ATTACK_CHECK_COLOR_SPRAY							= 41;
const int HENCH_ATTACK_CHECK_SUNBEAM                                = 42;
const int HENCH_ATTACK_CHECK_SUNBURST                               = 43;
const int HENCH_ATTACK_CHECK_MEDIUM									= 44;
const int HENCH_ATTACK_CHECK_CASTIGATE								= 45;
const int HENCH_ATTACK_CHECK_FIGHTER								= 46;
const int HENCH_ATTACK_CHECK_NOT_DEAF								= 47;
const int HENCH_ATTACK_CHECK_HOLY_BLAS								= 48;
const int HENCH_ATTACK_CHECK_EVIL									= 49;
        
const int HENCH_ATTACK_TARGET_START									= 0;
const int HENCH_ATTACK_TARGET_ALLIES								= 1;
const int HENCH_ATTACK_TARGET_ENEMIES								= 2;
const int HENCH_ATTACK_TARGET_SELF									= 3;
//const int HENCH_ATTACK_TARGET_DONE									= 4;



const string HENCH_RANGED_TOUCH_SAVEINFO	= "HenchRangedTouchSave";
const int HENCH_RANGED_TOUCH_REGULAR		= 0x1;
//const int HENCH_RANGED_TOUCH_PLUS_TWO		= 0x2;
const int HENCH_MELEE_TOUCH_REGULAR			= 0x4;
const int HENCH_MELEE_TOUCH_PLUS_TWO		= 0x8;

const int HENCH_MAX_SINGLE_TARGET_CHECKS	=  30;
const int HENCH_MAX_AREA_TARGET_CHECKS		=  60;







// constants for healing and buffing
const int HENCH_CNTX_MENU_OFF           = 0;
const int HENCH_CNTX_MENU_HEAL          = 1;
const int HENCH_CNTX_MENU_BUFF_LONG     = 2;
const int HENCH_CNTX_MENU_BUFF_MEDIUM   = 3;
const int HENCH_CNTX_MENU_BUFF_SHORT    = 4;
// constants so player controlled character gets flags set too
const int HENCH_CNTX_MENU_PC_ATTACK_NEAREST     = 100;
const int HENCH_CNTX_MENU_PC_FOLLOW_MASTER      = 101;
const int HENCH_CNTX_MENU_PC_GUARD_MASTER       = 102;
const int HENCH_CNTX_MENU_PC_STAND_GROUND       = 103;
// constants for scouting
const int HENCH_CNTX_MENU_SCOUT                 = 104;
// constants for follow
const int HENCH_CNTX_MENU_FOLLOW_TARGET         = 105;
const int HENCH_CNTX_MENU_FOLLOW_ME             = 106;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE         = 107;
const int HENCH_CNTX_MENU_FOLLOW_RESET          = 108;
const int HENCH_CNTX_MENU_FOLLOW_RESET_ALL      = 109;
const int HENCH_CNTX_MENU_FOLLOW_SINGLE         = 114;
const int HENCH_CNTX_MENU_FOLLOW_DOUBLE         = 115;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE_ALL     = 116;
// constants for guarding
const int HENCH_CNTX_MENU_GUARD_TARGET          = 110;
const int HENCH_CNTX_MENU_GUARD_ME              = 111;
const int HENCH_CNTX_MENU_GUARD_RESET           = 112;
const int HENCH_CNTX_MENU_GUARD_RESET_ALL       = 113;
// constants for weapon equipping
const int HENCH_CNTX_MENU_SET_WEAPON            = 200;
const int HENCH_CNTX_MENU_RESET_WEAPON          = 201;
// constants for global actions
const int HENCH_SAVE_GLOBAL_SETTINGS			= 300;
const int HENCH_LOAD_GLOBAL_SETTINGS			= 301;
const int HENCH_RESET_GLOBAL_SETTINGS			= 302;


const int HENCH_EVENT_ATTACK_NEAREST 		= 14785;
const int HENCH_EVENT_FOLLOW_MASTER 		= 14786;
const int HENCH_EVENT_GUARD_MASTER 			= 14787;
const int HENCH_EVENT_STAND_GROUND 			= 14788;
const int HENCH_EVENT_PARTY_SAW_TRAP 		= 14789;

// basic intelligence ranking, can change how AI reacts
const int HENCH_INT_VERY_LOW = 0;
const int HENCH_INT_LOW = 1;
const int HENCH_INT_AVG = 2;
const int HENCH_INT_HIGH = 3;
const int HENCH_INT_VERY_HIGH = 4;

const int HENCH_SPECIAL_TARGETING_SINGLE       = 0x01;
const int HENCH_SPECIAL_TARGETING_RACE         = 0x02;  // not currently implemented
const int HENCH_SPECIAL_TARGETING_CLASS        = 0x04;  // not currently implemented

const float HENCH_LOG_POINT_FLOAT = 0.4054651;

const float HENCH_MOVE_BACK_DISTANCE = 5.0;
const float HENCH_DISTANCE_BEHIND_FRIEND = 5.0;


//int giSpellVersionToUse;

const float HENCH_ATTRI_BUFF_SCALE_HIGH = 0.05;
const float HENCH_ATTRI_BUFF_SCALE_MED = 0.04;
const float HENCH_ATTRI_BUFF_SCALE_LOW = 0.025;


int gbMeleeTargetInit;
int gbIAmMeleeTarget;

const int HENCH_AC_CHECK_ARMOR						= 1;
//const int HENCH_AC_CHECK_SHIELD						= 2;
const int HENCH_AC_CHECK_EQUIPPED_ITEMS				= 0xf;
const int HENCH_AC_CHECK_MOVEMENT_SPEED_DECREASE	= 0x10000000;


int giMeleeAttackLevel;


const int HENCH_IMMUNITY_WEIGHT_AMOUNT_MASK = 0xff000;
const int HENCH_IMMUNITY_WEIGHT_AMOUNT_SHIFT = 12;
const int HENCH_IMMUNITY_WEIGHT_RESISTANCE = 0x100000;
const int HENCH_IMMUNITY_ONLY_ONE = 0x200000;
const int HENCH_IMMUNITY_GENERAL = 0x400000;




const int HENCH_WEAPON_STAFF_FLAG      = 0x1;
const int HENCH_WEAPON_SLASH_FLAG      = 0x2;
const int HENCH_WEAPON_HOLY_SWORD      = 0x4;
const int HENCH_WEAPON_BLUNT_FLAG      = 0x8;
const int HENCH_WEAPON_UNDEAD_FLAG     = 0x10;
const int HENCH_WEAPON_DRUID_FLAG      = 0x1000;


const int HENCH_POLYMORPH_CHECK_NATURAL_SPELL	= 0x01;
const int HENCH_POLYMORPH_CHECK_NON_POLYMORPH	= 0x02;
const int HENCH_POLYMORPH_CHECK_MAGIC_FANG		= 0x04;

float gfMaxPolymorph;

const int HENCH_DARKNESS_CHECK_NOT_INITIALIZED = 0;          
const int HENCH_DARKNESS_CHECK_ENABLE = 1;
const int HENCH_DARKNESS_CHECK_DISABLE = 2;

int giDarknessCheck;

int gICheckCreatureInfoStaleTime;



const int giCustomContentClassStart = 80;


const string HENCH_AI_SCRIPT_HB             = "AIIntruderHB";
const string HENCH_AI_BLOCKED				= "HenchTargetIsBlocked";


// void main() {    }

// internal weapon state settings
const int HENCH_AI_WEAPON_INIT =          0x00000001;
const int HENCH_AI_HAS_MELEE =            0x00000002;
const int HENCH_AI_HAS_MELEE_WEAPON =     0x00000004;
const int HENCH_AI_HAS_RANGED_WEAPON =    0x00000008;
const string HENCH_AI_WEAPON = "HENCH_AI_WEAPON";

const int HENCH_AI_STORED_MELEE_FLAG	= 0x1;
const int HENCH_AI_STORED_RANGED_FLAG	= 0x2;
const int HENCH_AI_STORED_SHIELD_FLAG	= 0x4;
const int HENCH_AI_STORED_OFF_HAND_FLAG	= 0x8;


const int HENCH_ITEM_TYPE_NONE      = 0;
const int HENCH_ITEM_TYPE_OTHER     = 1;
const int HENCH_ITEM_TYPE_POTION    = 2;

const int HENCH_TALENT_USE_SPELLS_ONLY = 3;
const int HENCH_TALENT_USE_ABILITIES_ONLY = 5;
const int HENCH_TALENT_USE_ITEMS_ONLY = 6;


const int HENCH_DISABLE_EFFECT_SILENCE = 0x1;
const int HENCH_DISABLE_EFFECT_NO_MAGIC = 0x2;

int gbDisablingEffect;      // disabling effect for spells
int giAuraSpellToCast;	// pending aura to cast


int giItemTalentSpellCount;
int giItemTalentSpellStart;
const int HENCH_AI_MAXITEM_TALENTSPELLCOUNT = 10;
int giItemSpellID1, giItemSpellID2, giItemSpellID3, giItemSpellID4, giItemSpellID5,  giItemSpellID6, giItemSpellID7, giItemSpellID8, giItemSpellID9, giItemSpellID10;

int giCheckSpontaneousFlags;
int giCheckSpontaneousLevels;
string gsSpontaneousClassColumn;
string gsSpontaneousClassCache;

int giExcludedItemTalents;   // global flags for excluded talent types, polymorph can change setting
int gbUseSpells;
int gbUseAbilities;
int gbUseItems;


const int HENCH_CHECK_SPONTANEOUS_HEAL		= 1;
const int HENCH_CHECK_SPONTANEOUS_HARM		= 2;
//const int HENCH_CHECK_SPONTANEOUS_SUMMON	= 3;


// includes from Kaedrin's PrC Pack
const int CLASS_KAED_HOSPITALER = 106;
const int CLASS_KAED_STORMSINGER = 109;
const int CLASS_KAED_CANAITH_LYRIST = 124;
const int CLASS_KAED_CHAMPION_WILD = 126;

const int SPELL_KAED_Blood_of_the_Martyr = 1773;
const int SPELL_KAED_SPELLABILITY_Healing_Touch = 1876;
const int SPELL_KAED_SPELLABILITY_TOUCHWILD = 1981;



const float HENCH_HEALSELF_WEIGHT_ADJUSTMENT = 1000.0;
const float HENCH_HEALOTHER_WEIGHT_ADJUSTMENT = 50.0;


const int HENCH_SPELL_INFO_SPELL_TYPE_MASK          = 0x000000ff;

const int HENCH_SPELL_INFO_SPELL_TYPE_ATTACK        = 1;
const int HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF       = 2;
const int HENCH_SPELL_INFO_SPELL_TYPE_BUFF          = 3;
const int HENCH_SPELL_INFO_SPELL_TYPE_PERSISTENTAREA = 4;
const int HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH     = 5;
const int HENCH_SPELL_INFO_SPELL_TYPE_DISPEL        = 6;
const int HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE     = 7;
const int HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION = 8;
const int HENCH_SPELL_INFO_SPELL_TYPE_SUMMON        = 9;
const int HENCH_SPELL_INFO_SPELL_TYPE_HEAL          = 10;
const int HENCH_SPELL_INFO_SPELL_TYPE_HARM          = 11;
const int HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF     = 12;
const int HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT     = 13;
const int HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK  = 14;
const int HENCH_SPELL_INFO_SPELL_TYPE_ARCANE_ARCHER = 15;
const int HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT    = 16;
const int HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH = 17;
const int HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS  = 18;
//const int HENCH_SPELL_INFO_SPELL_TYPE_WARLOCK       = 19;
const int HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE      = 20;
const int HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF   = 21;
const int HENCH_SPELL_INFO_SPELL_TYPE_BUFF_ANIMAL_COMP = 22;
const int HENCH_SPELL_INFO_SPELL_TYPE_PROT_EVIL     = 23;
const int HENCH_SPELL_INFO_SPELL_TYPE_PROT_GOOD     = 24;
const int HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE    = 25;
const int HENCH_SPELL_INFO_SPELL_TYPE_GUST_OF_WIND  = 26;
const int HENCH_SPELL_INFO_SPELL_TYPE_ELEMENTAL_SHIELD = 27;
const int HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD   = 28;
const int HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF       = 29;
const int HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK_BUFF   = 30;
const int HENCH_SPELL_INFO_SPELL_TYPE_RAISE_DEAD          = 31;
const int HENCH_SPELL_INFO_SPELL_TYPE_CONCEALMENT         = 32;
const int HENCH_SPELL_INFO_SPELL_TYPE_ATTACK_SPECIAL		= 33;
const int HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL		= 34;

const int HENCH_SPELL_INFO_MASTER_FLAG              = 0x00000100;
const int HENCH_SPELL_INFO_IGNORE_FLAG              = 0x00000200;
const int HENCH_SPELL_INFO_MASTER_OR_IGNORE_FLAG    = 0x00000300;
const int HENCH_SPELL_INFO_CONCENTRATION_FLAG       = 0x00000400;
const int HENCH_SPELL_INFO_REMOVE_CONCENTRATION_FLAG= 0xfffffbff;
const int HENCH_SPELL_INFO_UNLIMITED_FLAG           = 0x00000800;
// TODO not used const int HENCH_SPELL_INFO_SPELLLIKE_ABILITY		= 0x00001000;
const int HENCH_SPELL_INFO_SPELL_LEVEL_MASK         = 0x0001e000;
const int HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT        = 13;
const int HENCH_SPELL_INFO_HEAL_OR_CURE             = 0x00020000;
const int HENCH_SPELL_INFO_SHORT_DUR_BUFF           = 0x00040000;
const int HENCH_SPELL_INFO_MEDIUM_DUR_BUFF          = 0x00080000;
const int HENCH_SPELL_INFO_LONG_DUR_BUFF            = 0x00100000;

// flags that are added on
// spell is from item
const int HENCH_SPELL_INFO_ITEM_FLAG                = 0x00800000;


const int HENCH_SPELL_TARGET_SHAPE_MASK             = 0x00000007;

const int HENCH_SHAPE_NONE                          = 7;        // indicates no shape
const int HENCH_SHAPE_FACTION                       = 6;        // indicates faction targets

const int HENCH_SPELL_TARGET_RANGE_MASK             = 0x00000038;
const int HENCH_SPELL_TARGET_RANGE_PERSONAL         = 0x00000000;
const int HENCH_SPELL_TARGET_RANGE_TOUCH            = 0x00000008;
const int HENCH_SPELL_TARGET_RANGE_SHORT            = 0x00000010;
const int HENCH_SPELL_TARGET_RANGE_MEDIUM           = 0x00000018;
const int HENCH_SPELL_TARGET_RANGE_LONG             = 0x00000020;
const int HENCH_SPELL_TARGET_RANGE_INFINITE         = 0x00000028;

const int HENCH_SPELL_TARGET_RADIUS_MASK            = 0x0000ffc0;   // 10 bits radius * 10

const int HENCH_SPELL_TARGET_SHAPE_LOOP				= 0x00010000;
const int HENCH_SPELL_TARGET_CHECK_COUNT			= 0x00020000;
const int HENCH_SPELL_TARGET_MISSILE_TARGETS		= 0x00040000;
const int HENCH_SPELL_TARGET_SECONDARY_TARGETS		= 0x00080000;
const int HENCH_SPELL_TARGET_SECONDARY_HALF_DAM		= 0x00100000;
const int HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG      = 0x00200000;
const int HENCH_SPELL_TARGET_RANGED_SEL_AREA_FLAG   = 0x00400000;
const int HENCH_SPELL_TARGET_PERSISTENT_SPELL		= 0x00800000;
const int HENCH_SPELL_TARGET_SCALE_EFFECT			= 0x01000000;
const int HENCH_SPELL_TARGET_NECROMANCY_SPELL		= 0x02000000;
const int HENCH_SPELL_TARGET_REGULAR_SPELL			= 0x04000000;


const int HENCH_SPELL_SAVE_TYPE_CUSTOM_MASK         = 0x0000003f;
const int HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK      = 0x00000fc0;
const int HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK      = 0x0003f000;

const int HENCH_SPELL_SAVE_TYPE_SAVES_MASK          = 0x03fc0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_SAVE_MASK    = 0x000c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_FORT          = 0x00040000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX        = 0x00080000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_WILL          = 0x000c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_KIND_MASK    = 0x00300000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY   = 0x00000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_HALF   = 0x00100000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_DAMAGE = 0x00200000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION= 0x00300000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_MASK    		= 0x003c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE	= 0xffc3ffff;
const int HENCH_SPELL_SAVE_TYPE_SAVES2_SAVE_MASK    = 0x00c00000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_FORT          = 0x00400000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_REFLEX        = 0x00800000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_WILL          = 0x00c00000;
const int HENCH_SPELL_SAVE_TYPE_SAVES2_KIND_MASK    = 0x03000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_ONLY   = 0x00000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_HALF   = 0x01000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_DAMAGE = 0x02000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION= 0x03000000;

const int HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT    	= 0x10;

const int HENCH_SPELL_SAVE_TYPE_SR_FLAG             = 0x80000000;
const int HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG = 0x40000000;
const int HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG        = 0x20000000;
const int HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG    = 0x10000000;
const int HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG    = 0x08000000;
const int HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG     = 0x04000000;

//const int HENCH_NO_SPELLCASTING		= 0;
const int HENCH_DIVINE_SPELLCASTING = 1;
const int HENCH_ARCANE_SPELLCASTING = 2;

const float gfSummonAdjustment = 0.75;

// options for how to cast sSpellInformation
const int HENCH_CASTING_INFO_USE_SPELL_TALENT			= 0;
const int HENCH_CASTING_INFO_USE_SPELL_FEATID			= 1;
const int HENCH_CASTING_INFO_USE_SPELL_WARLOCK			= 2;
const int HENCH_CASTING_INFO_USE_SPELL_REGULAR			= 3;
const int HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT	= 4;
const int HENCH_CASTING_INFO_USE_HEALING_KIT			= 5;

const int HENCH_CASTING_INFO_USE_MASK					= 0x0000000f;

const int HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG		= 0x00000010;
const int HENCH_CASTING_INFO_CHEAT_CAST_FLAG			= 0x00000020; 
const int HENCH_CASTING_INFO_PERSISTENT_SPELL_FLAG		= 0x00000040; 

const int HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_MASK		= 0xff000000; 
const int HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT	= 24;

const int HENCH_HEALING_KIT_ID  = 1000000;

const int HENCH_SAVEDC_SPELL  = -1000;

const int HENCH_SAVEDC_HD_1 = 1000;
const int HENCH_SAVEDC_HD_2 = 1001;
const int HENCH_SAVEDC_HD_4 = 1002;
const int HENCH_SAVEDC_HD_2_CONST = 1003;
const int HENCH_SAVEDC_HD_2_CONST_MINUS_5 = 1004;
const int HENCH_SAVEDC_HD_2_WIS = 1005;
const int HENCH_SAVEDC_HD_2_PLUS_5 = 1006;
const int HENCH_SAVEDC_HD_2_CHA = 1007;

const int HENCH_SAVEDC_DISEASE_BOLT = 1010;
const int HENCH_SAVEDC_DISEASE_CONE = 1011;
const int HENCH_SAVEDC_DISEASE_PULSE = 1012;
const int HENCH_SAVEDC_POISON = 1013;

const int HENCH_SAVEDC_EPIC = 1014;

const int HENCH_SAVEDC_DEATHLESS_MASTER_TOUCH = 1020;
const int HENCH_SAVEDC_UNDEAD_GRAFT = 1021;
const int HENCH_SAVEDC_SPELL_NO_SPELL_LEVEL = 1022;
const int HENCH_SAVEDC_BARD_SLOWING = 1024;
const int HENCH_SAVEDC_BARD_FASCINATE = 1025;

// missing or wrong numbered spell and feat definitions in nwscript
//const int SPELL_HENCH_RedDragonDiscipleBreath = 690;
const int SPELL_HENCH_Owl_Insight = 438;

const int GRAPPLE_CHECK_HIT = 0x1;
const int GRAPPLE_CHECK_HOLD = 0x2;
const int GRAPPLE_CHECK_RUSH = 0x4;
const int GRAPPLE_CHECK_STR = 0x8;

const int DISEASE_CHECK_BOLT = 1;
const int DISEASE_CHECK_CONE = 2;
const int DISEASE_CHECK_PULSE = 3;

const int HENCH_SPELL_INFO_BUFF_MASK                = 0x0f000000;
const int HENCH_SPELL_INFO_BUFF_CASTER_LEVEL        = 0x01000000;
const int HENCH_SPELL_INFO_BUFF_HD_LEVEL            = 0x02000000;
const int HENCH_SPELL_INFO_BUFF_FIXED               = 0x03000000;
const int HENCH_SPELL_INFO_BUFF_CHARISMA            = 0x0b000000;
//const int HENCH_SPELL_INFO_BUFF_BARD_LEVEL          = 0x0c000000;
const int HENCH_SPELL_INFO_BUFF_DRAGON				= 0x0d000000;

const int HENCH_SPELL_INFO_BUFF_LEVEL_ADJ_MASK      = 0x00f00000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_DIV_MASK      = 0x000f0000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_MASK     = 0x0000c000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_DICE     = 0x00000000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_ADJ      = 0x00004000;
//const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_COUNT  = 0x00008000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_CONST    = 0x0000c000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_LIMIT_MASK    = 0x00003f00;
const int HENCH_SPELL_INFO_BUFF_AMOUNT_MASK         = 0x000000ff;

const int HENCH_SPELL_INFO_DAMAGE_MASK              = 0xf0000000;
const int HENCH_SPELL_INFO_DAMAGE_CASTER_LEVEL      = 0x00000000;
const int HENCH_SPELL_INFO_DAMAGE_HD_LEVEL          = 0x10000000;
const int HENCH_SPELL_INFO_DAMAGE_FIXED             = 0x20000000;
const int HENCH_SPELL_INFO_DAMAGE_CURE              = 0x30000000;
const int HENCH_SPELL_INFO_DAMAGE_DRAGON            = 0x40000000;
const int HENCH_SPELL_INFO_DAMAGE_SPECIAL_COUNT     = 0x50000000;
const int HENCH_SPELL_INFO_DAMAGE_CUSTOM	        = 0x60000000;
const int HENCH_SPELL_INFO_DAMAGE_DRAG_DISP         = 0x70000000;
const int HENCH_SPELL_INFO_DAMAGE_AA_LEVEL          = 0x80000000;
//const int HENCH_SPELL_INFO_DAMAGE_WP_LEVEL          = 0x90000000;
const int HENCH_SPELL_INFO_DAMAGE_LAY_ON_HANDS      = 0xa0000000;
const int HENCH_SPELL_INFO_DAMAGE_CHARISMA          = 0xb0000000;
const int HENCH_SPELL_INFO_DAMAGE_BARD_PERFORM      = 0xc0000000;
const int HENCH_SPELL_INFO_DAMAGE_WARLOCK           = 0xd0000000;

const int HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK    = 0x0c000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK   = 0x03000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE   = 0x00000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_ADJ    = 0x01000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_COUNT  = 0x02000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_CONST  = 0x03000000;
const int HENCH_SPELL_INFO_DAMAGE_FIXED_COUNT		= 0x0f000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK  = 0x00f00000;
const int HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK       = 0x000ff000;
const int HENCH_SPELL_INFO_DAMAGE_TYPE_MASK         = 0x00000fff;

//const int HENCH_GLOBAL_FLAG_UNCHECKED   = 0;
const int HENCH_GLOBAL_FLAG_TRUE        = 1;
const int HENCH_GLOBAL_FLAG_FALSE       = 2;

const int HENCH_PERSIST_SPELL_VERSION = 3;

const int HENCH_PERSIST_SPELL_MASK          = 0x0000ffff;
const int HENCH_PERSIST_CHECK_HEARTBEAT     = 0x00010000;
const int HENCH_PERSIST_HARMFUL             = 0x00020000;
const int HENCH_PERSIST_UNFRIENDLY          = 0x00040000;
const int HENCH_PERSIST_MOVE_AWAY           = 0x00080000;
//const int HENCH_PERSIST_DISPEL_EFFECT       = 0x00100000;
//const int HENCH_PERSIST_NOT_SELF            = 0x00200000;
const int HENCH_PERSIST_CAN_DISPEL          = 0x00400000;
const int HENCH_PERSIST_FOG                 = 0x00800000;
const int HENCH_PERSIST_SPELL_LEVEL_MASK    = 0x0f000000;
const int HENCH_PERSIST_SPELL_FLAG          = 0x40000000;


const int HENCH_HEALING_NOTNEEDED = 100000;
const float HENCH_ALLY_MELEE_TOUCH_RANGE = 7.5;

// ~ Behavior Constants
const int HENCH_BK_HEALINMELEE = 10;
const int HENCH_BK_CURRENT_AI_MODE = 20; // Can only be in one AI mode at a time
//const int BK_AI_MODE_FOLLOW = 9; // default mode, moving after the player
const int HENCH_BK_AI_MODE_RUN_AWAY = 19; // something is causing AI to retreat
const int HENCH_BK_NEVERFIGHT = 30;

// ~ Delay Constants
const float HENCH_BK_VOICE_RESPOND_DELAY = 2.0f; // VoiceChat delay for SC RespondToHenchmenShout()
const float HENCH_BK_FOLLOW_BUSY_DELAY = 12.0f; // CSL_ASC_IS_BUSY duration for ASSOCIATE_COMMAND_FOLLOWMASTER (increased from 5.0f)

// ~ Distance Constants
const float HENCH_BK_HEALTHRESHOLD = 5.0f;
const float HENCH_BK_FOLLOW_THRESHOLD= 15.0f;

//const int X2_SPELL_AOEBEHAVIOR_FLEE = 0;
//const int X2_SPELL_AOEBEHAVIOR_IGNORE = 1;
//const int X2_SPELL_AOEBEHAVIOR_GUST = 2;
//const int X2_SPELL_AOEBEHAVIOR_DISPEL_L = SPELL_LESSER_DISPEL;
//const int X2_SPELL_AOEBEHAVIOR_DISPEL_N = SPELL_DISPEL_MAGIC;
//const int X2_SPELL_AOEBEHAVIOR_DISPEL_G = SPELL_GREATER_DISPELLING;
//const int X2_SPELL_AOEBEHAVIOR_DISPEL_M = SPELL_MORDENKAINENS_DISJUNCTION;
//const int X2_SPELL_AOEBEHAVIOR_DISPEL_C = 727;