/** @file
* @brief Constants File for Chat System
*
* 
* 
*
* @ingroup scinclude
* @author FunkySwerve, Brian T. Meyer and others
*/

const string sSpeech_SpeechList = "SpeechList_";
const string sSpeech_PlayerID = "SpeechPlayerID_";

const string CHAT_PLAYERSHOUTBAN = "SDB_SHOUTBAN"; // if this is on player and set to true, they are blocked from shouting


const string CHAT_COLOR_SHOUT = "Yellow";
const string CHAT_COLOR_WHISPER = "SlateGray";
const string CHAT_COLOR_DMWHISPER = "SlateGray";
const string CHAT_COLOR_DMCHANNEL = "Khaki";
const string CHAT_COLOR_TELLTODM = "lightgreen";
const string CHAT_COLOR_DEBUG = "SlateGray";
const string CHAT_COLOR_OOC = "orange";
const string CHAT_COLOR_DMTALK = "LightSkyBlue";
const string CHAT_COLOR_DMSHOUT = "Aquamarine";
const string CHAT_COLOR_EMOTE = "PaleGoldenrod";
//example usage
//sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_DMWHISPER );


const int CHAT_EMOTES_ENABLED = TRUE;				// Are emotes enabled on UI text entry?
const int DMFI_PLAYER_NAME_CHANGING = FALSE;			// Can PCs change their names?





	
// deprecated const int CHAT_PCLANGUAGES_ENABLED = TRUE;			// Are player languages enabled?  DMFILanguagesEnabled
// deprecated const int DMFI_GIVE_COMMON=FALSE;					// Should all PCs be granted 'Common'?
// deprecated const int DMFI_GIVE_DEFAULT_LANGUAGES=FALSE;			// Do we give out racial / class oriented PHB languaes?
// deprecated const int DMFI_CHOOSE_LANGUAGES=FALSE;				// Should we show the Language Selection UI?	
// deprecated const int DMFI_ENABLE_LORELANG=FALSE;                //should the listener do a lore check to understand a language? (Qk)



const string DMFI_RUNSCRIPT_PREFIX="dmfi";			// If != "", limit runscript function to this prefix alone?
const int DMFI_PC_RUNSCRIPT_ALLOWED=FALSE;			// Can PCs have access to ANY runscript functionality?

const int DMFI_UPDATE_INVENTORY = TRUE;				// Should inventory bags auto-update on DM actions?  This 
													// can be expensive for players with a lot of items.  If you
													// run a PW and use these frequently on established players
													// I would strongly evaluate this option.

//const int DMFI_FOLLOWOFF = TRUE;                    //Do you like the follow off button? if FALSE will change to
													//standard follow function without the follow off button

const string DMFI_POPUPMESSAGE =  "<color=Gold>GENERAL MESSAGE:</color>\n\n";
													//The string message for popup windows if you want to customize it (Qk)				
const string DMFI_STORE_DB = "DMFI_DB_MNGRTOOL";    //Name for the Manager Tool Database

// GLOBAL PRE-FIX CONSTANTS - you can change these if you really want although not suggested.
//const string CHAT_COMMAND_SYMBOL = ".";
//const string CHAT_EMOTE_SYMBOL = "*";

//const int CHAT_SHOUTS_ANNOUNCE_PLAYER_AREA = FALSE;

//const int CHAT_SHOUTS_LIMITTOAREA = TRUE;
//const float CHAT_SHOUTS_LIMITTOAREA_RANGE = 40.0f;

const int PROCESS_NPC_SPEECH = FALSE;//Leave this set this to TRUE if you want speech from NPCs to be processed through SIMTools.
//This means that all channels (including silent channels) will be monitored. It is useful for processing the speech
//of DMs possesssing NPCs. It's also necessary if you want to prevent avoidance of the ignore function by PCs possessing
//their familiars. The only downside is the increased number of scriptcalls generated, but the effect on performance should
//not be noticeable.

const int IGNORE_SILENT_CHANNELS = TRUE;//This switch turns off processing of silent channel speech if you have chosen to
//process NPC speech with the PROCESS_NPC_SPEECH speech above. This is important because monsters communicate across
//the entire module using the silent channels, and processing them could result in a greatly increased number of
//scriptcalls. You should only set this switch to FALSE if you plan to add to the functionality of SIMTools in a way
//that requires processing of silent channels. The current SIMTools scripts do not rely on processing silent channels
//at all, and DMs possessing NPCs will still have their speech processed with IGNORE_SILENT_CHANNELS set to TRUE.

const int TEXT_LOGGING_ENABLED = TRUE;//Set to TRUE to send all messages to the text log.

const int SPAMBLOCK_ENABLED = FALSE;//Set this to FALSE to turn off spam blocker. It is intended to
//stop advertising of other servers on yours.

const string CHAT_EMOTE_SYMBOL = "*";//Set this to whatever single character you want players to access the emotes
//with. It is recommended that you select only a normally unused symbol, because any line beginning with this
//symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an 'invalid emote'
//warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. Do not choose the
//forward slash (/), or metachannels and languages will not work. You may simply choose to use the default
//asterisk symbol, if you prefer. If you select a symbol other than the asterisk, the list commands and list
//emotes functions will display the correct symbol automatically, but you will have to change the descriptions
//of the 2 items to reflect the change, if you plan to use them and want them to be accurate.

const string CHAT_OOC_SYMBOL1 = "((";
const string CHAT_OOC_SYMBOL2 = "))";
const string CHAT_OOC_SYMBOL3 = "\\";
const string CHAT_OOC_SYMBOL4 = "//";

const string CHAT_COMMAND_SYMBOL = "!";//Set this to whatever single character you want players to access the
//commands with. It is recommended that you select only a normally unused symbol, because any line beginning
//with this symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an
//'invalid emote' warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. YOU
//MUST PICK A DIFFERENT SYMBOL THAN THE ONE YOU CHOOSE FOR EMOTES, OR THE COMMANDS WILL NOT WORK. Do not
//choose the forward slash (/), or metachannels will not work. You may simply choose to use the default
//exclamation mark symbol, if you prefer. If you select a symbol other than the asterisk, the list commands
//and list emotes functions will display the correct symbol automatically, but you will have to change the
//descriptions of the 2 item to reflect the change, if you plan to use them and want them to be accurate.

const string CHAT_METACHANNEL_SYMBOL = "/";

const string CHAT_DMCOMMAND_SYMBOL = "dm_";

const string CHAT_RUNSCRIPT_SYMBOL = "[";

const int CHAT_DMRUNSCRIPT_ENABLED = TRUE;

const int CHAT_VOICETHROWING_ENABLED = TRUE;

const int ENABLE_WEAPON_VISUALS = TRUE;//Set this to TRUE to allow players to change the vfx on their weapons
//via the !wp commands.

const int ENABLE_PLAYER_SETNAME = FALSE;//Set this to TRUE to allow players to use the !setname command.

const int ENABLE_METALANGUAGE_CONVERSION = TRUE;//Set this to FALSE to stop common metagame chat like 'lol'
//from being converted to emotes like *Laughs out loud* when spoken in the talk channel. Currently only 'lol'
//is converted, more will be added.


//////////////////////////////////Metachannels//////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//Metachannels are added chat channels. They are very similar to the party channel, in that players
//control who is in their metachannel via invites. They may invite whomever they like, however, and
//are not limited to the members of their party. There is no set number of metachannels; rather, a
//metachannel is created whenever a player wants. The first invite sent out determines who the 'leader'
//of the metachannel is. When that invite is accepted, the inviter becomes the leader of a new metachannel.
//From that point on, any messages that any member types that begin with '/m' will be sent to every member
//of the metachannel, via the combat log. Metachannels will be logged with other text if you enable
//text logging. If you are uncertain what use these channels could be put to, the whole reason that I
//implemented them at all was for guild use on my PW, but I'm certain they will find other uses.
////////////////////////////////////////////////////////////////////////////////
//
const int ENABLE_METACHANNELS = TRUE;//Set this to FALSE if you do not want players to have access
//to metachannels.
//
const int DMS_HEAR_META = TRUE;//Set this to TRUE if you want DMs to receive all player metamessages. DMs
//will have the option to ignore these messages with the command dm_ignoremeta. If a DM is also in a
//metachannel, it will not duplicate the messages (like NWN does with party channel when a DM joins a party).
//
const int DM_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want DMs logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the CSLVerifyDMKey function, if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both. DMs
//logged in as players will have the option to ignore these messages with the command dm_ignoremeta.
//If a DM is also in a metachannel, it will not duplicate the messages (like NWN does with party channel
//when a DM joins a party).
//
const int ADMIN_DMS_HEAR_META = FALSE;//Set this to TRUE if you want administrators logged in as DMs to receive
//all player metamessages. Administrators will have the option to ignore these messages with the command
//dm_ignoremeta. If a administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).
//
const int ADMIN_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the CSLVerifyAdminKey function,if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both.
//Administrators logged in as players will have the option to ignore these messages with the command
//dm_ignoremeta. If an administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).

/////////////////////////Conditional Channel Disabling//////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int DISALLOW_SPEECH_WHILE_DEAD = FALSE;//Set to TRUE to disable speech by dead players on one,
//several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players. Emotes
//and Commands are automatically blocked on all channels when the player using them is dead.

const int DISABLE_DEAD_TALK = FALSE;
const int DISABLE_DEAD_SHOUT = TRUE;
const int DISABLE_DEAD_WHISPER = FALSE;
const int DISABLE_DEAD_TELL = FALSE;
const int DISABLE_DEAD_PARTY = FALSE;
const int DISABLE_DEAD_DM = FALSE;

const int DISALLOW_METASPEECH_WHILE_DEAD = FALSE;//Set to TRUE to disable speech by dead players on
//metachannels. This setting is seperate from the above commands, and can be enabled even if
//DISALLOW_SPEECH_WHILE_DEAD is left equal to FALSE.

//////////////////////////Permanent Channel Disabling///////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int ENABLE_PERMANENT_CHANNEL_MUTING = FALSE;//Set this to TRUE if you want to permanently disable
//one, several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players.
//Disabling a channel will ONLY prevent text from displaying on that channel. Emotes and commands can still
//be entered on it.
const int DISABLE_TALK_CHANNEL = FALSE;
const int DISABLE_SHOUT_CHANNEL = FALSE;
const int DISABLE_WHISPER_CHANNEL = FALSE;
const int DISABLE_TELL_CHANNEL = FALSE;
const int DISABLE_PARTY_CHANNEL = FALSE;
const int DISABLE_DM_CHANNEL = FALSE;

//////////////////////////////DM_PORT DESTINATIONS//////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//If you want the DM commands dm_porthell, dm_portjail, and dm_porttown to work, you must specify the tags
//of their waypoints here.
//dm_porthell
const string LOCATION_HELL = "FKY_WAY_HELL"; //Replace FKY_WAY_HELL with the tag of your 'hell' waypoint.
//dm_portjail
const string LOCATION_JAIL = "JAIL"; //Replace FKY_WAY_JAIL with the tag of your 'jail' waypoint.
//dm_porttown
const string LOCATION_TOWN = "dp_return"; //Replace FKY_WAY_TOWN with the tag of your 'town' waypoint.



const string ESCAPE_STRING = "&&";//Adding this escape string to the beginning of a SpeakString call will
//prevent the speaker from translating the string if they are in 'speak another language' mode. The excape
//string is automatically filtered out of what they say, whether or not they are speaking another language
//at the time. It's useful for adding to the begging of strings in scripts that you don't ever want to be
//translated, like loot notification messsages. You can set it to whatever string you want, of whatever
//length, so long as it does not begin with your command symbol (default is !), your emote symbol
//(default is *), or the forward slash channel designator (/). It should only be used for TALKVOLUME_TALK
//SpeakStrings, as they are the only volume subject to translation.
//


const string DMFI_DATABASE = "DMFIDatabase";
const string DMFI_TOOL_VERSION = "DMFIToolVersion";

// DO NOT TOUCH BELOW HERE.  ONLY CHANGE THINGS ^^^^^^^ UP THERE ^^^^^^
//*********************************************************************

//EVENT CONSTANTS
const int DMFI_PRE_EVENT = 1998;
const int DMFI_POST_EVENT = 1999;

//STATE CONSTANTS
const int DMFI_STATE_ERROR =2;
const int DMFI_STATE_NO_ACTION = 0;