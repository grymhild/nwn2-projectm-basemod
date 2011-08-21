/** @file
* @brief Configuration Constants
*
* Handles base configuration and overall global constants being added.
* This is the one file everything else is likely to include
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

// if true is prints out various debug info
// looking at upgrading this 0 does nothing, 1 does it always, -1 does it IF the character is a "tester"
// DEBUG_HARDCODE forces it to use a given level, otherwise it uses the module var
const int DEBUG_HARDCODE = 0;
int DEBUGGING = DEBUG_HARDCODE || GetLocalInt( GetModule(), "DEBUGLEVEL" );

int CSL_SPELLCAST_SERIALID = -1; // this is a variable in global scope, which is used to uniquely identify a spell casting event
// CSL_SPELLCAST_SERIALID = CSLGetRandomSerialNumber( CSL_SPELLCAST_SERIALID );


/////////////////////////////////Message Routing////////////////////////////////

const int SEND_CHANNELS_TO_CHAT_LOG = TRUE;//Set this to false if you want languages, listening, and metachannels
//sent to the combat log instead of the chat log. This will elimimate the [Tell] bracketed text in front of messages
//but can make messages harder for players to read.


////////////////////////////////Listening Options///////////////////////////////
////////////////////////////////////////////////////////////////////////////////DM Listening//////////////////////////////////////////////////////////////////
const int DMS_HEAR_TELLS = TRUE;//Set this to TRUE if you want people listed in the CSLVerifyDMKey function
//who are logged in as DMs to receive all player tell messages.
//
const int DM_PLAYERS_HEAR_TELLS = TRUE;//Set this to TRUE if you want people listed in the CSLVerifyDMKey
//function who are logged in as players to receive all player tell messages in their combat logs. It will
//NOT route tells to people logged in as DMs, so you should use both this and the above command if you
//want both. Neither of the above commands will route tells from DMs.
//
const int DM_PLAYERS_HEAR_DM = TRUE;//Set this to TRUE if you want people listed in the CSLVerifyDMKey
//function who are logged in as players to receive all DM messages in their combat logs. This will route
//DM messages to anyone with a cdkey you list below, if they are logged as a player. It will route DM
//messages from both players and DMs. People listed in the CSLVerifyDMKey function who are logged as players
//will have the option to ignore these messages if this option is enabled, via the dm_ignoredm command.
//
//Admin Listening///////////////////////////////////////////////////////////////
const int ADMIN_DMS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the CSLVerifyAdminKey
//function who are logged in as DMs to receive all player tell messages.
//
const int ADMIN_PLAYERS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the CSLVerifyAdminKey
//function who are logged in as players to receive all tell messages in their combat logs. It will NOT route
//tells to people logged in as DMs, so you should use both this and the above command if you want both.
//Neither of the above commands will route tells from DMs.
//
const int ADMIN_PLAYERS_HEAR_DM = FALSE;//Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the CSLVerifyAdminKey function, if they are logged as a player. It will route DM messages from
//both players and DMs. DMs logged as players will have the option to ignore these messages if this option
//is enabled, via the dm_ignoredm command.
//
//General Listening/////////////////////////////////////////////////////////////
const int ENABLE_DM_TELL_ROUTING = FALSE;//Set this to TRUE if you want tells from the DM tell channel
//routed as well as tells from the player channel. This is dependant on what channel is used, and not on
//player/dm/admin status.
//
const int DM_TELLS_ROUTED_ONLY_TO_ADMINS = FALSE;//Set this to TRUE if you want DM tells routed to
//administrators (people with cd keys listed in the CSLVerifyAdminKey function) but not to DMs (people with
//cd keys listed in the CSLVerifyAdminKey function. You should leave the above function set to FALSE if you
//enable this.


const string MOD_NAME = "dmfi_110";
const string MOD_VERSION = "V110";


// FAKE DM FLAG
const string DMFI_DM_STATE = "I_AM_A_DM";
const string DMFI_ADMIN_STATE = "I_AM_AN_ADMIN";

const string DMFI_TOOL = "DMFITool";

// OBJECT CONSTANTS OR FILE NAMES
const string DMFI_TEMP = "DMFITemp";
const string DMFI_PC_UI_STATE = "dmfi_pc_ui_state";
const string DMFI_CONV_DEF = "dmfi_conv_def";
const string DMFI_CONV_DEF_PC = "dmfi_conv_def_pc";
const string DMFI_ITEM_TARGET = "DMFIItemTarget";
const string DMFI_EXE_CONV = "dmfi_exe_conv";
const string DMFI_EXE_CONV_PC = "dmfi_exe_conv_pc";

// dmif_inc_tool constants
const string DMFI_MUSIC_INITIALIZED = "DMFIMusicInitialized";
const string DMFI_MUSIC_BATTLE = "DMFIMusicBattle";
const string DMFI_MUSIC_DAY = "DMFIMusicDay";
const string DMFI_MUSIC_NIGHT = "DMFIMusicNight";

const string GUI_DEATH = "SCREEN_PARTY_DEATH";
const string GUI_DEATH_HIDDEN = "SCREEN_HIDDEN_DEATH";
const string SCREEN_DMC_CREATOR = "SCREEN_DMC_CREATOR";
const string SCREEN_DMC_CHOOSER = "SCREEN_DMC_CHOOSER";
const string SCREEN_DMC_CASTER = "SCREEN_DMC_CASTER";
const string SCREEN_SPELLS_QUICK = "SCREEN_SPELLS_QUICK";


//const string DMFI_WAYPOINT_RESREF = "nw_waypoint001";
const string DMFI_STORAGE_RESREF = "plc_secretobject";
const string DMFI_TOOL_RESREF = "dmfi_exe_tool";
const string DMFI_PCTOOL_RESREF = "dmfi_exe_pc";

const string DMFI_SOUND_DELAY = "DMFISoundDelay";
const string DMFI_SOUND_VOLUME = "DMFISoundVolume";
const string DMFI_SOUND_LAST = "DMFISoundLast";
const string DMFI_SOUND_LAST_PRM = "DMFISoundParam";

const string DMFI_VFX_DURATION = "DMFIVFXDuration";
const string DMFI_VFX_LAST = "DMFIVFXLast";
const string DMFI_VFX_RECENT = "DMFIRecent";

const string DMFI_AMBIENT_LOCATION = "DMFIAmbientLoc";
const string DMFI_AMBIENT_VOLUME = "DMFIAmbientVolume";

const string DMFI_FILE_LOCKER = "DMFI_FILE_LOCKER";

const string DMFI_ITEM_TAG = "dmfi_exe_tool";
const string DMFI_LAST_COMMAND = "DMFILastCommand";
const string DMFI_PAGE = "DMFIPage";
const string DMFI_PAGES = "DMFIPages";
const string DMFI_PLUGIN_TAG = "DMFI_Plugin_";
const string DMFI_SPEAKER = "DMFISpeaker";
const string DMFI_STORE = "DMFIStore";
const string DMFI_TARGET = "DMFITarget";
const string DMFI_TARGET_LOC = "DMFITargetLoc";


const string PROPDELIM = "_";
const string BUFFER     = "                                                                                                                                                                                                                                                                                          ";

const int SCSAVING_THROW_NONE = 4;

// * used by the IgnoreTargetRules functions
const string SCITR_NUM_ENTRIES = "SCITR_NUM_ENTRIES"; //number of stored targets to ignore the check.
const string SCITR_ENTRY_PREFIX = "ITR_TARGET_ENTRY"; //prefix for stored targets (ITR_TARGET_ENTRY1, ITR_TARGET_ENTRY15, etc)


//const int SC_MAXAOES = 2; // This is adjusted by characters concentration, with one more AOE per 10 points
// const int SC_MAXBUFFS = 8; // This is adjusted by characters concentration, with one more Buff per 5 points

// leave this one in, don't see why it won't be 2
const int SC_DISPELRULES = 2; // 0 = Vanilla, 2 = Pains PNP/PVP Hybrid, 3 = Seeds empowered version



const int SC_DISPEL_RANGECONSTANT = 70;
const int SC_DISPEL_DISPELLER_ABJFEATWEIGHT = 3;
const int SC_DISPEL_DISPELLER_SPELLPOWERINCREMENT = 5;
const int SC_DISPEL_STATSIGNIFIGANCE = 1;


const int SR_FIX = -4000;
const int DMGRES_FIX = -4001;
const int FATIGUE = -4002;
const int EXHAUSTED = -4003;
const int SHAKEN = -4004;
const int PM_IMMUNITY = -4005;
