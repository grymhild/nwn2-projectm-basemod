/** @file
* @brief Include File for DMFI
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

// ************************* CONVERSATION CONSTANTS ****************************
const string CV_PC_FOLLOW_ON = "Follow current target.";
const string CV_PC_FOLLOW_OFF = "Cancel Any Follow orders.";
const string CV_PC_ROLL_ABILITY = "Roll an Ability / Save Check.";
const string CV_PC_ROLL_SKILL = "Roll a Skill Check.";
const string CV_PC_ROLL_DICE = "Roll dem Bones.";
const string CV_PC_LANGUAGE = "Turn on a Language Toggle.";
const string CV_PC_LANGUAGE_OFF = "Deactivate the Language Toggle.";

const string CV_LD_D2 = "d2";
const string CV_LD_D3 = "d3";
const string CV_LD_D4 = "d4";
const string CV_LD_D6 = "d6";
const string CV_LD_D8 = "d8";
const string CV_LD_D10 = "d10";
const string CV_LD_D12 = "d12";
const string CV_LD_D20 = "d20";
const string CV_LD_D100 = "d100";

const string CV_SV_INVEN_IDENTIFY = "Identify ALL items for target.";
const string CV_SV_INVEN_STRIP = "Strip ALL items from target.";
const string CV_SV_INVEN_UBER = "Remove Uber Items from target.";
const string CV_SV_FREEZE = "Freeze player (behavoir)";
const string CV_SV_BOOT = "Boot Player from server.";

// Added 11/20/06
const string CV_SV_SCALE = "Scale target to percent.";

const string CV_IT_IDENTIFY = "Identify Item.";
const string CV_IT_DESTROY = "Destroy Item.";
const string CV_IT_TAKE = "Take Item.";
const string CV_IT_CURSED = "Toggle Cursed State.";
const string CV_IT_PLOT = "Toggle Plot State";
const string CV_IT_STOLEN = "Toggle Stolen State";
const string CV_RS_ITEM = "DMFI Item Manipulation";

const string CV_MC_NWN2 = "NWN2";
const string CV_MC_NWN1 = "NWN1";
const string CV_MC_XP = "Expansion";
const string CV_MC_BATTLE = "Battle";
const string CV_MC_MOTB = "MotB";
const string CV_MUSIC = "Music";

const string CV_AM_CAVE = "Cave";
const string CV_AM_MAGIC = "Magic";
const string CV_AM_PEOPLE = "People";
const string CV_AM_MISC = "Misc";
const string CV_AMBIENT = "Ambient";	

const string CV_SD_CITY = "City";
const string CV_SD_MAGIC = "Magic";
const string CV_SD_NATURE = "Nature";
const string CV_SD_PEOPLE = "People";
const string CV_SOUND = "Sound";	

const string CV_DI_ABIL = "Ability/SVs";
const string CV_DI_SKILL = "Skills";
const string CV_DI_DICE = "Dice";
const string CV_DICE = "Dice";

const string CV_VF_SPELLS = "Spells";
const string CV_VF_INVOCATION = "Invocation";
const string CV_VF_DURATION = "Duration";
const string CV_VF_MISC = "Misc";
const string CV_VF_RECENT = "Recent";
const string CV_VFX = "VFX";

const string CV_TOOL = "Tool";

const string CV_PROMPT_TIME = "Please choose the new hour:";
const string CV_PROMPT_EFFECTS = "Please choose the effect to remove:";
const string CV_PROMPT_SCALE = "Select PERCENT to scale:\nObsidian bug 200% then 50% != 100%";

const string CV_PROMPT_DC = "Please choose the new DC to roll against:";
const string CV_PROMPT_DELAY = "Select the new localized sound delay:";
const string CV_PROMPT_DURATION = "Please choose the new duration in seconds: (only applies to duration based effects)";

const string CV_PROMPT_VOLUME = "Please set the ambient sound volume.  Note: This is applied to FUTURE changes or play commands.";
const string CV_PROMPT_MS_TRACK = ":  Please select a music track:";
const string CV_PROMPT_ABILITY = "Please select an ability or save:";
const string CV_PROMPT_SV = "Please select a skill:";
const string CV_PROMPT_DICE = "Please select a number of dice to roll:";
const string CV_PROMPT_VFX = "Choose a VFX to play:";	
const string CV_PROMPT_SOUND = "Please select a sound to play at target location:";

const string CV_PROMPT_GRANT = "Choose a language to grant:";
const string CV_PROMPT_REMOVE = "Choose a language to remove:";
const string CV_PROMPT_CHOOSE = "Remaining Language Selections: ";

const string CV_PROMPT_APPEARANCE = "Please select a new appearance:";