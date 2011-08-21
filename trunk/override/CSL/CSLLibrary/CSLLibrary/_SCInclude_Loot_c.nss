/////////////////////////////////////////////				FILE DESCRIPTION
//
/////////////////////////////////////////////
// This file is new to version 1.2.  I rearranged several things to try
// to be consistent.  There were a couple of constants that didn't quite 
// fit into any of the other script files.  So they ended up here. At the
// very end of this file are the custom data types and global variables
// that the random loot generator uses.  


// GOLD_AWARDED
// I should explain how I determine how much gold drops. First, you must understand
// a monster won't always drop gold.  The only way he drops gold is if
// the gold category was rolled by the random loot generator.  If gold 
// was the category chosen, then we have to decide how many GP the monster
// will drop. I use a formula to determine this, so that the amount 
// dropped will scale as the monsters get more and more powerful 
// throughout the game.  
//
// The random loot generator will roll a number between a lower and
// upper limit. These limits are defined using the default formula and
// the gold modifier constants below.  
// The default formula for max is: (CR * FW_MAX_GOLD_MODIFIER)
// The default formula for min is: (CR * FW_MIN_GOLD_MODIFIER)
// Once a max and min have been chosen, the random generator rolls a
// number between these two values. 
//
// Finally, the number chosen is checked against the module minimum
// and maximum amounts to make sure we didn't accidentally go too 
// high or low.  
//
// Example 1: A CR level 10 monster dies.  The maximum amount of gold
// 		he could drop is: (CR * Modifier) or (10 * 5.0) = 50 gold. The
//		minimum amount is: (CR * Modifier) or (10 * 2.5) = 25 gold. 
//      The random loot generator then rolls a number between 25 and
//		50 and this is how many GP the monster will drop.  Let's say the
//		random generator rolled 34 gold.
//
//		As long as 34 gold is more than the module minimum per kill and 
//		less than the module maximum per kill, then he'll drop 34 gold.
//	    If 34 gold isn't within the module limits then it is lowered or
//		raised to fit within the module limits.
//
// 34 gold probably isn't an amount that most worlds would consider too
// much for a kill.  But as the monsters get tougher and tougher the 
// amount of gold they could drop goes up with their CR. This creates a
// potential problem if there wasn't a way to cap very high amounts (or
// also to cap very low amounts). Imagine a level 40 CR monster dies.
// Using the min and max MODIFIERs this monster could possibly drop 100-200 gold. 
// This could be an amount that some worlds want to disallow.
// That's why I have included a minimum and maximum module limit constant.
// You could keep the modifier at 5.0 if you want (or change it), but cap the 
// amount of gold at some level you feel is appropriate by setting module
// limits.  
//
// Basically the gold modifiers set the range the random loot generator
// will select from, but then the number chosen is subject to the module
// limits. As far as I know, there is no hard coded upper limit.
// NOTE: These are float values (include a decimal)  
const float FW_MAX_GOLD_MODIFIER = 5.0;
const float FW_MIN_GOLD_MODIFIER = 2.5;

// Module Limits per monster kill as explained above.
// NOTE: These are integer values (no decimal)
const int FW_MIN_MODULE_GOLD = 10;
const int FW_MAX_MODULE_GOLD = 10000000;

// *DAMAGE SHIELDS*  Damage shields already in existence in the game are:
// Elemental Shield (spell) and Death Armor (spell).  As part of the random loot
// generation system, I've made it possible to have damage shields of other types
// of damage besides just fire and sonic appear on an item.  Do not confuse with
// IP CONST Damage Bonus. Not the same thing.
// Setting min and max switches (see below) for damage shield bonuses requires
// a bit of explaining. I have ranked all the damage bonuses a damage shield
// can have in ascending order based off of the average damage dealt by each
// damage_bonus_* constant. In cases where the average was a tie (i.e. 7 dmg
// and 2d6 dmg both average 7 dmg) I gave a higher ranking to the random amount
// because it can potentially roll much higher. By default I have the damage
// bonus constants set to min=0 and max=49.  This allows any amount of damage
// ranging from index 0 (measly +1 dmg.) up to and including index 49 (a whopping
// +40 dmg.) By changing the values of the constants you can specify the range
// of values you want to allow / disallow as possibilities. Here's a couple
// examples to show you what I mean.
//
// Example 1: You set FW_MIN_DAMAGE_SHIELD_BONUS = 5;
//    and you set     FW_MAX_DAMAGE_SHIELD_BONUS = 8;
//    Possibilities are now from index 5 to 8, or: +4, +1d8, +5, or +2d4 damage.
//
// Example 2: You set FW_MIN_DAMAGE_SHIELD_BONUS = 3
//    and you set     FW_MAX_DAMAGE_SHIELD_BONUS = 8.
//    Possibilites are from index 3 to 8, or: +3, +1d6, +4, +1d8, +5, or +2d4
//    damage.
//
// Note: It's okay to set min = max.  There just wouldn't be any randomness
//    if you do that.
//
// TABLE: DAMAGE_BONUS  (Used only for Damage Shields)
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//   0   = 1    damage  ...avg = 1
//   1   = 2    damage  ...avg = 2
//   2   = 1d4  damage  ...avg = 2.5
//   3   = 3    damage  ...avg = 3
//   4   = 1d6  damage  ...avg = 3.5
//   5   = 4    damage  ...avg = 4
//   6   = 1d8  damage  ...avg = 4.5
//   7   = 5    damage  ...avg = 5
//   8   = 2d4  damage  ...avg = 5
//   9   = 1d10 damage  ...avg = 5.5
//   10  = 6    damage  ...avg = 6
//   11  = 1d12 damage  ...avg = 6.5
//   12  = 7    damage  ...avg = 7
//   13  = 2d6  damage  ...avg = 7
//   14  = 8    damage  ...avg = 8
//   15  = 9    damage  ...avg = 9
//   16  = 2d8  damage  ...avg = 9
//   17  = 10   damage  ...avg = 10
//   18  = 11   damage  ...avg = 11
//   19  = 2d10 damage  ...avg = 11
//   20  = 12   damage  ...avg = 12
//   21  = 13   damage  ...avg = 13
//   22  = 2d12 damage  ...avg = 13
//   23  = 14   damage  ...avg = 14
//   24  = 15   damage  ...avg = 15
//   25  = 16   damage  ...avg = 16
//   26  = 17   damage  ...avg = 17
//   27  = 18   damage  ...avg = 18
//   28  = 19   damage  ...avg = 19
//   29  = 20   damage  ...avg = 20
//   30  = 21   damage  ...avg = 21
//   31  = 22   damage  ...avg = 22
//   32  = 23   damage  ...avg = 23
//   33  = 24   damage  ...avg = 24
//   34  = 25   damage  ...avg = 25
//   35  = 26   damage  ...avg = 26
//   36  = 27   damage  ...avg = 27
//   37  = 28   damage  ...avg = 28
//   38  = 29   damage  ...avg = 29
//   39  = 30   damage  ...avg = 30
//   40  = 31   damage  ...avg = 31
//   41  = 32   damage  ...avg = 32
//   42  = 33   damage  ...avg = 33
//   43  = 34   damage  ...avg = 34
//   44  = 35   damage  ...avg = 35
//   45  = 36   damage  ...avg = 36
//   46  = 37   damage  ...avg = 37
//   47  = 38   damage  ...avg = 38
//   48  = 39   damage  ...avg = 39
//   49  = 40   damage  ...avg = 40
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//
// - The above table is used ONLY for Damage Shields.
//
// - There is no need to have minimum and maximum values for every CR
//   because the formula that calculates damage shield power doesn't 
//   use monster CR as a variable.  Instead, it uses the PC level.  And
//   the formula I wrote automatically scales with the PC's level. So
//   that's why you only see 2 constants here instead of seeing 42.
//
// The minimum and maximum damage shield bonus.  See explanation and table above.
// Acceptable values range from 0 to 49.  0,1,2,3,...,49
const int FW_MIN_DAMAGE_SHIELD_BONUS = 0;
const int FW_MAX_DAMAGE_SHIELD_BONUS = 10;

// The minimum and maximum damage shield bonus time length (in seconds). As far
// as I know there is no limit for the maximum amount of time.  I suggest a
// minimum of 60 seconds.  Must be any positive integer.
// This is the amount of time the damage shield will last before it 
// expires.  It is only useable once per day. That info. may help you
// in determining how long you want the damage shield to last.
const int FW_MIN_DAMAGE_SHIELD_LENGTH_TIME = 30;   // 1 minute by default.
const int FW_MAX_DAMAGE_SHIELD_LENGTH_TIME = 120;  // 10 minutes by default.


// *****************************************
//
//              USER-DEFINED DATA TYPES
//
// 		DON'T CHANGE THESE EVER OR YOU COULD
//  	BREAK THE LOOT GENERATION SYSTEM
//
// *****************************************
struct MyStruct
{
   object oItem;
   int nLootType;
   string sName;
};


// *****************************************
//
//              GLOBAL VARIABLES
//
// 		DON'T CHANGE THESE EVER OR YOU COULD
//  	BREAK THE LOOT GENERATION SYSTEM
// *****************************************
const int FW_ARMOR_BOOT = 0;
const int FW_ARMOR_CLOTHING = 1;
const int FW_ARMOR_HEAVY = 2;
const int FW_ARMOR_HELMET = 3;
const int FW_ARMOR_LIGHT = 4;
const int FW_ARMOR_MEDIUM = 5;
const int FW_ARMOR_SHIELDS = 6;
const int FW_WEAPON_AMMUNITION = 7;
const int FW_WEAPON_SIMPLE = 8;
const int FW_WEAPON_MARTIAL = 9;
const int FW_WEAPON_EXOTIC = 10;
const int FW_WEAPON_MAGE_SPECIFIC = 11;
const int FW_WEAPON_RANGED = 12;
const int FW_WEAPON_THROWN = 13;
const int FW_MISC_CLOTHING = 14;
const int FW_MISC_JEWELRY = 15;
const int FW_MISC_GAUNTLET = 16;
const int FW_MISC_POTION = 17;
const int FW_MISC_TRAPS = 18;
const int FW_MISC_BOOKS = 19;
const int FW_MISC_GOLD = 20;
const int FW_MISC_GEMS = 21;
const int FW_MISC_HEAL_KIT = 22;
const int FW_MISC_SCROLL = 23;
const int FW_MISC_CRAFTING_MATERIAL = 24;
const int FW_MISC_OTHER = 25;
const int FW_MISC_DAMAGE_SHIELD = 26;
const int FW_MISC_CUSTOM_ITEM = 27;

const int FW_MATERIAL_NON_SPECIFIC = 1;
const int FW_MATERIAL_ADAMANTINE = 2;
const int FW_MATERIAL_ALCHEMICAL_SILVER = 3; 
const int FW_MATERIAL_COLD_IRON = 4;
const int FW_MATERIAL_DARK_STEEL =5;
const int FW_MATERIAL_DUSKWOOD = 6;
const int FW_MATERIAL_IRON = 7;
const int FW_MATERIAL_MITHRAL = 8;
const int FW_MATERIAL_ZALANTAR = 9;

const int FW_ARMOR_HEAVY_BANDED = 1 ;
const int FW_ARMOR_HEAVY_FULLPLATE = 2;
const int FW_ARMOR_HEAVY_HALFPLATE = 3;
const int FW_ARMOR_LIGHT_CHAINSHIRT = 4;
const int FW_ARMOR_MEDIUM_SCALEMAIL = 5;
const int FW_ARMOR_MEDIUM_CHAINMAIL = 6;
const int FW_ARMOR_MEDIUM_BREASTPLATE = 7;



// *****************************************
//				UPDATES
//				
//
// *****************************************
// VERSION 1.2
// -27 August 2007. I wanted this file to contain all of the switches
//     for the random loot generator.  I moved a couple of the misc
//     switches that were previously in other files to this file to 
//     try to be consistent.  This file now contains ONLY switches
//     that turn things on/off.
//
// -5 Sept 2007.  I added several more switches to this file for more
//    end-user control.


// *****************************************
//
//    ITEM PROPERTY SWITCHES FOR MORE CONTROL
//
//	  YOU CAN CHANGE THESE IF YOU WANT				
//
// *****************************************

// These switches are set up by default to allow every item property that
// is not broken at the time this version of my random loot generator was
// released. 
//
// The item properties that Obsidian has not fixed yet are set to FALSE.
// Changing them to TRUE accidentally (or on purpose) will NOT cause any 
// errors.
//
// TRUE means the item property is allowed (and could POSSIBLY appear on 
// an item).
// FALSE means the item property is disallowed (and will never appear
// on an item).
//
// If you want to allow an item property, but you want to exclude some of
// its sub-types you should set the item property equal to TRUE in this
// file. For example, maybe you want to allow some, but not all types of
// immunities. Set the switch that controls immunities to TRUE. I explain
// each item property and how to limit them in the files: 
// "fw_inc_loot_cr_scaling_formulas" and "fw_inc_loot_cr_scaling_constants"  
//
// If you set something here to FALSE, then you have completely eliminated
// that property from ever showing up on an item, including all of its 
// sub-types.  Setting something to TRUE does not necessarily mean all 
// sub-types will be allowed because you can limit them in the files I just
// named above.   
//
const int FW_ALLOW_ABILITY_BONUS = TRUE;

const int FW_ALLOW_AC_BONUS = TRUE;
const int FW_ALLOW_AC_BONUS_VS_ALIGN = FALSE;
const int FW_ALLOW_AC_BONUS_VS_DMG_TYPE = FALSE;
const int FW_ALLOW_AC_BONUS_VS_RACE = FALSE;
const int FW_ALLOW_AC_BONUS_VS_SALIGN = FALSE;

const int FW_ALLOW_ARCANE_SPELL_FAILURE = TRUE;

const int FW_ALLOW_ATTACK_BONUS = TRUE;
const int FW_ALLOW_ATTACK_BONUS_VS_ALIGN = FALSE;
const int FW_ALLOW_ATTACK_BONUS_VS_RACE = FALSE;
const int FW_ALLOW_ATTACK_BONUS_VS_SALIGN = FALSE;

const int FW_ALLOW_ATTACK_PENALTY = FALSE;

const int FW_ALLOW_BONUS_FEAT = FALSE;

const int FW_ALLOW_BONUS_LEVEL_SPELL = FALSE;

const int FW_ALLOW_BONUS_HIT_POINTS = FALSE;

const int FW_ALLOW_BONUS_SAVING_THROW = FALSE;
const int FW_ALLOW_BONUS_SAVING_THROW_VSX = FALSE;

const int FW_ALLOW_BONUS_SPELL_RESISTANCE = TRUE;

const int FW_ALLOW_CAST_SPELL = FALSE;

const int FW_ALLOW_DAMAGE_BONUS = TRUE;
const int FW_ALLOW_DAMAGE_BONUS_VS_ALIGNMENT = FALSE;
const int FW_ALLOW_DAMAGE_BONUS_VS_RACE = FALSE;
const int FW_ALLOW_DAMAGE_BONUS_VS_SALIGNMENT = FALSE;

const int FW_ALLOW_MASSIVE_CRITICAL_DAMAGE_BONUS = TRUE;

const int FW_ALLOW_DAMAGE_SHIELDS = FALSE;

const int FW_ALLOW_DAMAGE_IMMUNITY = FALSE;

const int FW_ALLOW_DAMAGE_PENALTY = TRUE;

// NWN 2 is bugged when it comes to damage reduction.  By default
// this is set to FALSE. Until they fix it anyway.
const int FW_ALLOW_DAMAGE_REDUCTION = FALSE;

const int FW_ALLOW_DAMAGE_RESISTANCE = FALSE;

const int FW_ALLOW_DAMAGE_VULNERABILITY = TRUE;

const int FW_ALLOW_ABILITY_PENALTY = TRUE;

const int FW_ALLOW_AC_PENALTY = TRUE;

const int FW_ALLOW_SKILL_DECREASE = TRUE;

const int FW_ALLOW_ENHANCEMENT_BONUS = TRUE;
const int FW_ALLOW_ENHANCEMENT_BONUS_VS_ALIGN = FALSE;
const int FW_ALLOW_ENHANCEMENT_BONUS_VS_RACE = FALSE;
const int FW_ALLOW_ENHANCEMENT_BONUS_VS_SALIGN = FALSE;
const int FW_ALLOW_ENHANCEMENT_PENALTY = FALSE;

const int FW_ALLOW_EXTRA_MELEE_DAMAGE_TYPE = TRUE;

const int FW_ALLOW_EXTRA_RANGE_DAMAGE_TYPE = TRUE;

const int FW_ALLOW_HEALER_KIT = FALSE;

const int FW_ALLOW_IMMUNITY_MISC = FALSE;

const int FW_ALLOW_IMMUNITY_TO_SPELL_LEVEL = FALSE;

const int FW_ALLOW_LIGHT = TRUE;

const int FW_ALLOW_LIMIT_USE_BY_ALIGN = TRUE;
const int FW_ALLOW_LIMIT_USE_BY_CLASS = FALSE;
const int FW_ALLOW_LIMIT_USE_BY_RACE = FALSE;
const int FW_ALLOW_LIMIT_USE_BY_SALIGN = FALSE;

const int FW_ALLOW_MIGHTY_BONUS = TRUE;

const int FW_ALLOW_ON_HIT_CAST_SPELL = FALSE;

const int FW_ALLOW_ON_HIT_PROPS = FALSE;

const int FW_ALLOW_SAVING_THROW_PENALTY = FALSE;
const int FW_ALLOW_SAVING_THROW_PENALTY_VSX = FALSE;

const int FW_ALLOW_REGENERATION = FALSE;

const int FW_ALLOW_SKILL_BONUS = TRUE;

const int FW_ALLOW_SPELL_IMMUNITY_SCHOOL = FALSE;

const int FW_ALLOW_SPELL_IMMUNITY_SPECIFIC = FALSE;

// Thieves tools are bugged in NWN 2 and cannot be added to an item 
// dynamically. Default is FALSE.
const int FW_ALLOW_THIEVES_TOOLS = FALSE;

// Turn Resistance can only be added to a skin of a creature.  If a PC finds a 
// creature skin they can't equip it, so I couldn't implement this.  Default is
// set to FALSE.
const int FW_ALLOW_TURN_RESISTANCE = FALSE;

const int FW_ALLOW_UNLIMITED_AMMO = TRUE;

const int FW_ALLOW_VAMPIRIC_REGENERATION = TRUE;

// Weight increase is bugged in NWN 2 and cannot be added to an item
// dynamically. Default is FALSE.
const int FW_ALLOW_WEIGHT_INCREASE = FALSE;

// Weight reduction works fine though.  
const int FW_ALLOW_WEIGHT_REDUCTION = TRUE;

// *****************************************
//
//    MISCELLANEOUS SWITCHES FOR MORE CONTROL
//
//	  YOU CAN CHANGE THESE IF YOU WANT				
//
// *****************************************

// If set to TRUE there is a chance that an item is cursed.  If you change this
// to FALSE then there is NO CHANCE ever of a cursed item.  Cursed Items 
// are not the same thing as items with negative properties.  A cursed 
// item cannot be dropped by a PC.  It might have positive or negative
// item properties, or both.
//  
const int FW_ALLOW_CURSED_ITEMS = TRUE;
 

// *****************************************
// When determining the ranges of the different item properties that can 
// appear on an item there are different ways to set "acceptable" ranges.
// One method is to set ranges at every CR value by setting a lower and upper
// limit using constants.  Another way is using formulas that calculate the
// limits for each item property.  Either way works. Both methods have
// benefits and drawbacks.    
//
// Scaling loot based off constants that control upper and lower limits
// gives not just greater control, but COMPLETE control to the end-user.
// However, this method is VERY time-consuming to edit because there are 
// over 2000 constants to set values on.  For those willing to invest the
// time, CR scaling using constants gives you total control. The constants
// along with explanations on how to use them are found in the file:
// "fw_inc_loot_cr_scaling_constants".   
//
// Formula based CR scaling tends to be MUCH easier to use for an end-user 
// because there are not nearly so many things to edit/change compared to 
// constant based CR Scaling.  The formulas, along with explanations on how
// to use them are found in the file "fw_inc_loot_cr_scaling_formulas".
//
// My random loot generator allows you to choose which way to control CR
// scaling of your loot.  I've chosen what I consider "reasonable" limits
// for the formulas. On the other hand, the constants are set up to allow
// for any item property of any power at any CR level. You need to decide
// which way to handle CR scaling of the power of your loot. 
//
// If set to TRUE (the default) then CR scaling will be done through 
// formulas.  If you set this to FALSE then CR scaling will be handled 
// through constants.  You cannot have both formula and constant scaling
// of your loot at the same time.  You have to pick one or the other. 
// TRUE = formula based scaling of loot.
// FALSE = constant based scaling of loot.
//
const int FW_ALLOW_FORMULA_BASED_CR_SCALING = TRUE;


// *****************************************
// Overall GP restrictions;
// When set to TRUE, the overall value of an item is restricted 
// to certain gold piece limits you set in the file:
// "fw_inc_item_value_restrictions" for each CR level of a monster.
// When set to TRUE the overall GP restrictions are applied in
// addition to the formula or constant based limitations on
// specific item properties.  
//
// If you set this to FALSE, then there is no limit to the 
// overall value of an item that could drop, but there will still
// be limits on individual item properties.  CR scaling always
// applies (either formula or constant based), but GP restrictions
// on items does not always apply.  You choose to enable it or
// disable gp restrictions. 
//
// If you plan to have item level restrictions in your world,
// then you probably want to leave this set to TRUE.  The reason
// is because if you set this to FALSE, then the random loot
// generator will eventually create an item too high of level
// for any PC to ever wear.  While it might be nice to sell
// such an item for the gold you'd get at the store, it would
// also probably be somewhat of a downer for the game player.
//
// I set default values to the overall gp restrictions in the
// file "fw_inc_item_value_restrictions". You can change those
// values to whatever you want. 
//
const int FW_ALLOW_OVERALL_GP_RESTRICTIONS = TRUE;


// *****************************************
// If you set the switch below to TRUE, then the type of loot category
// that will appear on a spawning monster is determined by race specific
// loot probability tables in the file "fw_inc_race_prob_tables".
//  
// If you set the switch below to FALSE, then the type of loot category
// that will appear on a spawning monster is determined by the 'default'
// loot category probability table in the file "fw_inc_race_prob_tables"
// (at the very bottom of that file).
// 
const int FW_RACE_SPECIFIC_LOOT_DROPS = FALSE;


/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////

/*
This file is completely new to Version 1.2  This file handles cr scaling of loot
based off of a formula method.  This is a great time saving device for those
who want a quick and easy way to scale loot based off of the power of the monster
that the PC fights.  Formula based CR scaling does NOT give you as much control
as constant based scaling does, but is much easier to edit.  Feel free to change
the default values of the modifiers.  Changing the modifiers will result in 
different ranges for each item property.
*/

// VERY IMPORTANT NOTE: I indicate next to each item property below telling you 
// what the hard-coded limits are. For example, attack penalties can range from 1 
// to 5. These limits are not things I set, but are hard coded into 
// the game by Obsidian.  I note these limits to remind you of the max and min
// values possible.  I also show you what the default range is for a level 20
// monster using the default formula and the default values I have set for
// the modifiers.  By altering the modifiers you can adjust to whatever range
// you want.  The range will automatically scale according to the CR
// of the monster that the PC faces.
//
// I'm hoping this will help you in picking a modifier for each
// item property.  In ALL of the function implementations I have checks that
// keep the values inside the hard-coded bounds.  So you don't need to worry
// about resulting values greater than or less than the limits.  Continuing
// the example of attack penalties...  If a value > 5 would result, the value is 
// changed to 5 because that's the maximum attack penalty possible.  If a value 
// less than 1 results, the value is changed to 1 because that is the minimum
// attack penalty allowed.  Even though I am using attack penalty as the 
// example, I made sure all of the item properties have checks to keep values
// inside the legal bounds of the game. You don't have to worry about that.

// ABILITY BONUS
// Can range from 1 to 12
// Default Formula: (CR * Modifier) + 1 
// Default range (max .25, min .1) for CR 20 monster: 3-6  
// (This means a level 20 CR monster could drop an item with +3, +4, +5, or +6 
// using the default modifiers) If you change the modifiers it will change
// the range possible, not just at level 20, but at every level.
// Max .14 (<1/7) means a CR 29 or 30 could drop up to a +5
const float FW_MAX_ABILITY_BONUS_MODIFIER = 0.13;
const float FW_MIN_ABILITY_BONUS_MODIFIER = 0.08;

// AC BONUS
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5 
const float FW_MAX_AC_BONUS_MODIFIER = 0.13;
const float FW_MIN_AC_BONUS_MODIFIER = 0.08;

// AC BONUS VS. ALIGN GROUP
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1 
// Default range for CR 20 monster: 3-5
const float FW_MAX_AC_BONUS_VS_ALIGN_MODIFIER = 0.2;
const float FW_MIN_AC_BONUS_VS_ALIGN_MODIFIER = 0.1;

// AC BONUS VS DAMAGE TYPE
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_AC_BONUS_VS_DAMAGE_MODIFIER = 0.2;
const float FW_MIN_AC_BONUS_VS_DAMAGE_MODIFIER = 0.1;

// AC BONUS VS RACE
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_AC_BONUS_VS_RACE_MODIFIER = 0.2;
const float FW_MIN_AC_BONUS_VS_RACE_MODIFIER = 0.1;

// AC BONUS VS SPECIFIC ALIGNMENT
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_AC_BONUS_VS_SALIGN_MODIFIER = 0.2;
const float FW_MIN_AC_BONUS_VS_SALIGN_MODIFIER = 0.1;

// ARCANE SPELL FAILURE
// There is no min/max formula to limit arcane spell failure.  To change what 
// can or can't appear on items for this item property, you need to go into the
// function FW_Choose_IP_Arcane_Spell_Failure and comment out the case 
// statements that you don't want to appear. By default, all types (both 
// positive and negative) arcane spell failure can appear on an item. Only
// an experienced scripter should modify that function. That function is found
// in the file "fw_inc_choose_ip"

// ATTACK BONUS
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ATTACK_BONUS_MODIFIER = 0.13;
const float FW_MIN_ATTACK_BONUS_MODIFIER = 0.08;

// ATTACK BONUS VS ALIGNMENT GROUP
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ATTACK_BONUS_VS_ALIGN_MODIFIER = 0.2;
const float FW_MIN_ATTACK_BONUS_VS_ALIGN_MODIFIER = 0.1;

// ATTACK BONUS VS RACE
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ATTACK_BONUS_VS_RACE_MODIFIER = 0.2;
const float FW_MIN_ATTACK_BONUS_VS_RACE_MODIFIER = 0.1;

// ATTACK BONUS VS. SPECIFIC ALIGNMENT
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ATTACK_BONUS_VS_SALIGN_MODIFIER = 0.2;
const float FW_MIN_ATTACK_BONUS_VS_SALIGN_MODIFIER = 0.1;

// ATTACK PENALTY
// Can range from 1 to 5
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_ATTACK_PENALTY_MODIFIER = 0.1;
const float FW_MIN_ATTACK_PENALTY_MODIFIER = 0.0;

// * ITEM_PROPERTY_BONUS_FEAT
// There is no switch to change what feats can or can't appear on an item.
// If you want to change what feats can or can't appear you need to go into the
// function FW_Choose_IP_Bonus_Feat and comment out the case statements for the
// feats that you don't want to appear.  By default, all feats can appear on an
// item.  That function is found in the file "fw_inc_choose_ip". Only an
// experienced scripter should change it though.

// BONUS HIT POINTS
// Can range from 1 to 50
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 10-30
const float FW_MAX_BONUS_HIT_POINTS_MODIFIER = 0.95; 
const float FW_MIN_BONUS_HIT_POINTS_MODIFIER = 0.45;

// BONUS LEVEL SPELL
// Can range from 0 to 9
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-9
const float FW_MAX_BONUS_LEVEL_SPELL_MODIFIER = 0.1;
const float FW_MIN_BONUS_LEVEL_SPELL_MODIFIER = 0.0;

// BONUS SAVING THROW
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_BONUS_SAVING_THROW_MODIFIER = 0.05;
const float FW_MIN_BONUS_SAVING_THROW_MODIFIER = 0.01;

// BONUS_SAVING_THROW_VSX
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_BONUS_SAVING_THROW_VSX_MODIFIER = 0.05;
const float FW_MIN_BONUS_SAVING_THROW_VSX_MODIFIER = 0.01;

// BONUS_SPELL_RESISTANCE
// Can range from 10 to 32 in increments of 2: 10,12,14,...,32
// Default Formula: (CR * Modifier)
// Note: Different formula than normal. No "+1".
// Default range for CR 20 monster: 20-32
const float FW_MAX_BONUS_SPELL_RESISTANCE_MODIFIER = 0.6;
const float FW_MIN_BONUS_SPELL_RESISTANCE_MODIFIER = 0.0;

// * ITEM_PROPERTY_CAST_SPELL_*
// By default the function that chooses ItemProperty
// CastSpell will choose from every single spell available (there are hundreds)
// If you want to disallow certain spells from being added to an item, then you
// need to go into the function: FW_Choose_IP_Cast_Spell and edit it.  That 
// function is found in the file "fw_inc_choose_ip"  Only an
// experienced scripter should change it though.

// * ITEM_PROPERTY_DAMAGE_BONUS_*
// Setting a formula for damage bonuses requires a bit of explaining.
// I have ranked all the damage bonus item properties in ascending order based
// off of the average damage dealt by each item property. In cases where the
// average was a tie (i.e. 7 dmg and 2d6 dmg both average 7 dmg) I gave a higher
// ranking to the random amount because it can potentially roll much higher. 
// See the table below for the rankings of the damage bonuses. 
//
// When you set the modifier for the formula, the resulting value is equal to the
// index in the table below.  For example, FW_DAMAGE_BONUS_MODIFIER has a formula 
// of: (CR * Modifier) + 1.  The default value for FW_DAMAGE_BONUS_MODIFIER is 1.0
//
// Example 1: (using the default value for modifier)
// A CR level 10 monster will have a maximum **possible** value that corresponds
// to index 11 because (CR * 1.0) + 1 = 11.  Index 11 = 1d12 bonus damage.  The
// random loot generator in this example could roll anything from measly 1 bonus 
// damage up to 1d12 bonus damage or anything inbetween.
//
// Example 2: (using the default value for modifier)
// A CR level 15 monster will have a maximum **possible** value that corresponds
// to index 16 because (CR * 1.0) + 1 = 16.  Index 16 = 2d8 bonus damage.  The
// random loot generator in this example could roll anything from measly 1 bonus 
// damage up to 2d8 bonus damage or anything inbetween.
//
// NOTE: You don't have to worry about going outside (either below index 0 or above
// index 19.  For example, a CR level 25 monster (with the default modifier value
// and default formula of CR * Modifier - 1) would give an index value = 24. 
// But, remember what I said at the top of this file about going out of bounds.
// You don't have to worry about going outside the bounds allowed by the game.  I 
// have checks that stop this from happening. If, as in the example above, a CR
// 25 monster yields a result of 24, the result is changed to 19.  For this item
// property, index 19 is the highest value possible. 
//
// TABLE: IP_CONST_DAMAGE_BONUS
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//   0   = 1    damage  ...avg = 1
//   1   = 2    damage  ...avg = 2
//   2   = 1d4  damage  ...avg = 2.5
//   3   = 3    damage  ...avg = 3
//   4   = 1d6  damage  ...avg = 3.5
//   5   = 4    damage  ...avg = 4
//   6   = 1d8  damage  ...avg = 4.5
//   7   = 5    damage  ...avg = 5
//   8   = 2d4  damage  ...avg = 5
//   9   = 1d10 damage  ...avg = 5.5
//   10  = 6    damage  ...avg = 6
//   11  = 1d12 damage  ...avg = 6.5
//   12  = 7    damage  ...avg = 7
//   13  = 2d6  damage  ...avg = 7
//   14  = 8    damage  ...avg = 8
//   15  = 9    damage  ...avg = 9
//   16  = 2d8  damage  ...avg = 9
//   17  = 10   damage  ...avg = 10
//   18  = 2d10 damage  ...avg = 11
//   19  = 2d12 damage  ...avg = 13
//
// The above table is used for the following item properties:
//   Damage Bonus
//   Damage Bonus Vs. Alignment Group
//   Damage Bonus Vs. Race
//   Damage Bonus vs. Specific Alignment
//   Massive Critical

// DAMAGE_BONUS
// Can range from 0 to 19
// Default Formula: (CR * Modifier) - 1
// Default range for CR 20 monster: +1 to +2d12 dmg.
const float FW_MAX_DAMAGE_BONUS_MODIFIER = 0.17;
const float FW_MIN_DAMAGE_BONUS_MODIFIER = 0.1;

// DAMAGE_BONUS_VS_ALIGN
// Can range from 0 to 19
// Default Formula: (CR * Modifier) - 1
// Default range for CR 20 monster: +1 to +2d12 dmg.
const float FW_MAX_DAMAGE_BONUS_VS_ALIGN_MODIFIER = 0.17;
const float FW_MIN_DAMAGE_BONUS_VS_ALIGN_MODIFIER = 0.1;

// DAMAGE_BONUS_VS_RACE
// Can range from 0 to 19
// Default Formula: (CR * Modifier) - 1
// Default range for CR 20 monster: +1 to +2d12 dmg.
const float FW_MAX_DAMAGE_BONUS_VS_RACE_MODIFIER = 0.17;
const float FW_MIN_DAMAGE_BONUS_VS_RACE_MODIFIER = 0.1;

// DAMAGE_BONUS_VS_SALIGN
// Can range from 0 to 19
// Default Formula: (CR * Modifier) - 1
// Default range for CR 20 monster: +1 to +2d12 dmg.
const float FW_MAX_DAMAGE_BONUS_VS_SALIGN_MODIFIER = 0.17;
const float FW_MIN_DAMAGE_BONUS_VS_SALIGN_MODIFIER = 0.1;

// MASSIVE_CRITICAL_DAMAGE_BONUS
// Can range from 0 to 19
// Default Formula: (CR * Modifier) - 1
// Default range for CR 20 monster: +1 to +2d12 dmg.
const float FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_MODIFIER = 0.17;
const float FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_MODIFIER = 0.1;

// *DAMAGE SHIELDS*  
// Damage Shields scale according to the PC's level, not the spawning monster's 
// level.  Therefore, there is no modifier for Damage 
// Shields.  I already took care of damage shield scaling.  If you want to change
// the formula for damage shields to scale in some manner other than the way I have
// it set up already, you'll need to edit the file: "i_fw_damage_shield_ac".  But
// I recommend only a VERY EXPERIENCED programmer even attempt to change that file.
// And make sure you know all about tag based scripting before you do change it or 
// else you'll mess it up. Whatever you do, DON'T change the name of that file or 
// else it will definitely NOT work. 

// * ITEM_PROPERTY_DAMAGE_IMMUNITY
// There is no switch to control min/max damage immunity amounts.  To disallow certain
// amounts you have to comment out the case statements inside the function
// FW_Choose_IP_Damage_Immunity ();  This function is found in the file:
// "fw_inc_choose_ip" Only an experienced scripter should change it though.

// DAMAGE_PENALTY
// Can range from 1 to 5
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_DAMAGE_PENALTY_MODIFIER = 0.2;
const float FW_MIN_DAMAGE_PENALTY_MODIFIER = 0.0;

// DAMAGE_REDUCTION 
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_DAMAGE_REDUCTION_MODIFIER = 0.2;
const float FW_MIN_DAMAGE_REDUCTION_MODIFIER = 0.1;

// DAMAGESOAK_HP
// Can range from 5 to 50, in increments of 5. i.e. 5,10,15,...,50
// Default Formula: (CR * Modifier) * 5
// NOTE the different formula than normal
// Default range (max 0.5, min 0.05) for CR 20 monster: 5-50
const float FW_MAX_DAMAGESOAK_HP_MODIFIER = 0.05;
const float FW_MIN_DAMAGESOAK_HP_MODIFIER = 0.005;

// DAMAGE_RESISTANCE
// Can range from 5 to 50, in increments of 5. i.e. 5,10,15,...,50
// Default Formula: (CR * Modifier) * 5
// NOTE the different formula than normal
// Default range (max 0.5, min 0.05) for CR 20 monster: 5-50
const float FW_MAX_DAMAGE_RESISTANCE_MODIFIER = 0.05;
const float FW_MIN_DAMAGE_RESISTANCE_MODIFIER = 0.005;

// * ITEM_PROPERTY_DAMAGE_VULNERABILITY
// There is no switch to control damage vulnerability amounts. To disallow
// certain amounts you have to comment out the case statements inside the
// function FW_Choose_IP_Damage_Vulnerability ();  This function is found
// in the file "fw_inc_choose_ip" Only an experienced scripter should change 
// it.

// ABILITY_PENALTY
// Can range from 1 to 10
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-6
const float FW_MAX_ABILITY_PENALTY_MODIFIER = 0.25;
const float FW_MIN_ABILITY_PENALTY_MODIFIER = 0.0;

// AC_PENALTY
// Can range from 1 to 5
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_AC_PENALTY_MODIFIER = 0.2;
const float FW_MIN_AC_PENALTY_MODIFIER = 0.0;

// SKILL_DECREASE
// Can range from 1 to 10
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_SKILL_DECREASE_MODIFIER = 0.2;
const float FW_MIN_SKILL_DECREASE_MODIFIER = 0.0;

// ENHANCEMENT_BONUS
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ENHANCEMENT_BONUS_MODIFIER = 0.13;
const float FW_MIN_ENHANCEMENT_BONUS_MODIFIER = 0.07;

// ENHANCEMENT_BONUS_VS_ALIGN
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_MODIFIER = 0.2;
const float FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_MODIFIER = 0.1;

// ENHANCEMENT_BONUS_VS_RACE
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ENHANCEMENT_BONUS_VS_RACE_MODIFIER = 0.2;
const float FW_MIN_ENHANCEMENT_BONUS_VS_RACE_MODIFIER = 0.1;

// ENHANCEMENT_BONUS_VS_SALIGN
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_MODIFIER = 0.2;
const float FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_MODIFIER = 0.1;

// ENHANCEMENT_PENALTY
// Can range from 1 to 5
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_ENHANCEMENT_PENALTY_MODIFIER = 0.2;
const float FW_MIN_ENHANCEMENT_PENALTY_MODIFIER = 0.0;

// * ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE
// There is no formula. Edit the function: 
// FW_Choose_IP_Extra_Melee_Damage_Type() if you want to change anything.
// Only an experienced scripter should change it though.

// * ITEM_PROPERTY_EXTRA_RANGE_DAMAGE_TYPE
// There is no formula. Edit the function:
// FW_Choose_IP_Extra_Range_Damage_Type() if you want to change anything.
// Only an experienced scripter should change it though.

// HEALER_KIT
// Healer kit item properties don't work dynamically.  I'm waiting for Obsidian to
// fix that.  But even if they do fix it, I don't think anyone would want to 
// make their items into healing kits. The reason is if you use a healing kit, 
// it disappears from your inventory - just like any healing kit does when you 
// use it.  So if someone used their armor, or bracer, or whatever as a healing kit
// their armor/bracer/whatever would disappear.  And that doesn't make sense to me.
// I've included them here, even though they don't work.  Right now it doesn't
// matter what you put for the modifiers for this item property. 
// Can range from 1 to 12.
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 5-12
const float FW_MAX_HEALER_KIT_MODIFIER = 0.55;
const float FW_MIN_HEALER_KIT_MODIFIER = 0.2;


// * ITEM_PROPERTY_IMMUNITY_MISC * 
// There isn't a formula to control miscellaneous immunities. You can
// disallow all miscellaneous immunities in the file "fw_inc_loot_switches"
// If you want to exclude some, but not all immunities you can do so by
// editing the function FW_Choose_IP_Immunity_Misc in the file 
// "fw_inc_choose_ip"  Only an experienced scripter should change it though.

// IMMUNITY_TO_SPELL_LEVEL
// Can range from 1 to 9
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-9
const float FW_MAX_IMMUNITY_TO_SPELL_LEVEL_MODIFIER = 0.0;
const float FW_MIN_IMMUNITY_TO_SPELL_LEVEL_MODIFIER = 0.0;

// * ITEM_PROPERTY_LIGHT
// There is no formula to control the brightness or color of light that
// could be added to an item.  To disallow a light brightness or color,
// comment out the case statements inside function: FW_Choose_IP_Light ();
// This function is found in the file "fw_inc_choose_ip"  Only an experienced
// scripter should change this.

// * ITEM_PROPERTY_LIMIT_USE_BY_ALIGN
// * ITEM_PROPERTY_LIMIT_USE_BY_CLASS
// * ITEM_PROPERTY_LIMIT_USE_BY_RACE
// * ITEM_PROPERTY_LIMIT_USE_BY_SALIGN
// There is no formula to control specifics of the four item properties above. 
// I can't see why someone would want to allow some limitations but not 
// others.  If you want to disallow specifics, then go edit the functions:
// FW_Choose_IP_Limit_Use_By_*  in the file "fw_inc_choose_ip" Only an experienced
// scripter should change this.

// MIGHTY_BONUS
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 3-5
const float FW_MAX_MIGHTY_BONUS_MODIFIER = 0.2;
const float FW_MIN_MIGHTY_BONUS_MODIFIER = 0.1;

// * ITEM_PROPERTY_ON_HIT_CAST_SPELL
// There is no formula for on hit cast spell because this item property
// doesn't scale with CR.  Either an item has this property or it doesn't.
// You can disallow the property in the file "fw_inc_loot_switches" or you can
// disallow some, but not all spells by editing the function "FW_Choose_IP_On_Hit_Cast_Spell"
// in the file "fw_inc_choose_ip"  Only an experienced scripter should change this.

// ON_HIT_SPELL_LEVEL
// This is in conjunction with On Hit Cast Spell.  It must be determined what spell level
// your on hit spell is cast at (for things like breaking down spell mantles, etc). You could 
// allow on hit cast spells, but limit the level here if you wanted. If you disallowed on hit
// cast spell entirely in the file "fw_inc_switches" then it doesn't matter what these values are.
// Can range from 1 to 9
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-9
const float FW_MAX_ON_HIT_SPELL_LEVEL_MODIFIER = 0.0;
const float FW_MIN_ON_HIT_SPELL_LEVEL_MODIFIER = 0.0;

// * ITEM_PROPERTY_ON_HIT_PROPS *
// This item property doesn't scale with CR.  Either an item has an immunity
// or it doesn't.  There's no way to scale it. You can disallow ALL on hit props
// in the file "fw_inc_loot_switches" by setting the switch to FALSE.  If you
// just want to disallow some, but not all on hit props, then edit the function
// FW_Choose_IP_On_Hit_Props in the file "fw_inc_choose_ip" 
// Only an experienced scripter should change it though.

// ON_HIT_SAVE_DC
// This goes in conjunction with On Hit Props. Some of the onhitprops have save
// DC components. If you disallowed on hit props entirley, then these values 
// don't matter. Acceptable values: 14,16,18,20,22,24, or 26.  Anything less than 14
// gets rounded up to 14. Anything higher than 26 gets rounded down to 26. 
// Default Formula: (CR * Modifier)
// NOTE: different formula than normal, no "+1".
// Default range (max 1.5, min .5) for CR 20 monster: 14-26
const float FW_MAX_ON_HIT_SAVE_DC_MODIFIER = 0.5;
const float FW_MIN_ON_HIT_SAVE_DC_MODIFIER = 0.5;

// SAVING_THROW_PENALTY
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_SAVING_THROW_PENALTY_MODIFIER = 0.0;
const float FW_MIN_SAVING_THROW_PENALTY_MODIFIER = 0.0;

// SAVING_THROW_PENALTY_VSX
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 0-5
const float FW_MAX_SAVING_THROW_PENALTY_VSX_MODIFIER = 0.0;
const float FW_MIN_SAVING_THROW_PENALTY_VSX_MODIFIER = 0.0;

// REGENERATION
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range (max .45, min .2) for CR 20 monster: 5-10
const float FW_MAX_REGENERATION_MODIFIER = 0.0;
const float FW_MIN_REGENERATION_MODIFIER = 0.0;

// SKILL_BONUS
// Can range from 1 to 50
// Default Formula: (CR * Modifier) + 1
// Default range (max .45, min .2) for CR 20 monster: 5-10
const float FW_MAX_SKILL_BONUS_MODIFIER = 0.1;
const float FW_MIN_SKILL_BONUS_MODIFIER = 0.05;

// * ITEM_PROPERTY_SPELL_IMMUNITY_SCHOOL *
// * ITEM_PROPERTY_SPELL_IMMUNITY_SPECIFIC *
// There is no formula to control the above two item properties.  
// Either an item is immune to something or it isn't. No way to scale this.
// You can disallow it in the file "fw_inc_loot_switches"
// Only an experienced scripter should change it though.

// THIEVES_TOOLS
// Thieves tools are not working dynamically right now. Hopefully Obsidian
// fixes them soon.  Right now it doesn't matter what you put for these
// modifier values, but I've included them here for when Obsidian finally
// fixes them. They aren't used right now.
// Can range from 1 to 12
// Default Formula: (CR * Modifier) + 1 
// Default range (max .45, min .2) for CR 20 monster: 5-10
const float FW_MAX_THIEVES_TOOLS_MODIFIER = 0.3;
const float FW_MIN_THIEVES_TOOLS_MODIFIER = 0.1;

// TURN_RESISTANCE
// Turn Resistance seems to only be added to creature skins.  But PC's 
// cannot equip creature skins.  I probably don't need to include this
// item property, but in case Obsidian changes it so that turn resistance
// can be added to items other than creature skins, I've included this
// here.  It doesn't matter what you put for this item property modifiers
// at this time.  They aren't used.
// Can range from 1 to 50
// Default Formula: (CR * Modifier) + 1
// Default range for CR 20 monster: 10-20
const float FW_MAX_TURN_RESISTANCE_MODIFIER = 0.95;
const float FW_MIN_TURN_RESISTANCE_MODIFIER = 0.45;

// * ITEM_PROPERTY_UNLIMITED_AMMO
// There is no formula to control the type(s) of unlimited ammo.
// To change the default go into the function FW_Choose_IP_Unlimited_Ammo
// and comment out the case statements you don't want as options.  This
// function is found in the file "fw_inc_choose_ip"
// Only an experienced scripter should change it though.

// VAMPIRIC_REGENERATION
// Can range from 1 to 20
// Default Formula: (CR * Modifier) + 1
// Default range (max .45, min .2) for CR 20 monster: 5-10
const float FW_MAX_VAMPIRIC_REGENERATION_MODIFIER = 0.1;
const float FW_MIN_VAMPIRIC_REGENERATION_MODIFIER = 0.0;

// * ITEM_PROPERTY_WEIGHT_INCREASE
// Weight Increase is bugged in NWN 2.  It cannot be added dynamically
// to items as of this time.  Even if it did work properly, there 
// wouldn't be modifiers for this property because of the nature of the
// different choices for weight increases.

// * ITEM_PROPERTY_WEIGHT_REDUCTION
// There are no modifiers to control weight reduction on an item. By
// default all weight increase/decrease amounts are possible.  To disallow
// any/some of the possibles comment out the undesired amounts inside the
// functions: FW_Choose_IP_Weight_Increase and FW_Choose_IP_Weight_Reduction.
// Only an experienced scripter should change it though.

// TRAP_LEVEL
//   0 = Minor, 1 = Average, 2 = Strong, 3 = Deadly 
// Can range from 0 to 3.
// Default Formula: (CR * Modifier) - 1
// NOTE the different formula. Rounds to the nearest whole integer.
// Default range (max .22, min 0) for CR 20 monster: 0-3
const float FW_MAX_TRAP_LEVEL_MODIFIER = 0.15;
const float FW_MIN_TRAP_LEVEL_MODIFIER = 0.08;



/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////

// *****************************************
//        FILE DESCRIPTION
// *****************************************

/*
This file contains probability tables that are used to determine
what type of loot category will appear on a monster when it spawns.
Each race has its own probability table to control how frequently
the different loot categories will drop.  There is also a default 
loot category probability table at the end of this file.  This is 
one of the most important files because with it you determine the
frequency of what type of loot category will drop.  Once you see
how I've set up the probability tables, I think you'll agree it is
also one of the easiest to edit and understand. 

I have chosen what I consider to be "reasonable" default values for
each race.  For example, I don't find it reasonable that vermin
(rats, beetles, etc) could drop Heavy Armor.  So inside the table
for vermin, I have the value of Heavy Armor set equal to zero.  
Setting the frequency to zero means that particular loot category 
will never drop for that particular race of monster. You can edit
or change any of the values in these tables simply by erasing the
value I had and putting in your own value.  You are not "stuck"
with what I chose.  Feel free to edit to your heart's content.

Race specific loot drops is a switch that you can turn on or off in
the file "fw_inc_loot_switches".  Normally this switch is turned on
(set to TRUE).  

I realize that some people may want any type of loot to drop for any
monster in the game.  You can achieve this the hard, or easy way. 
The hard way would be to leave that switch set to TRUE and then go 
into every single race table below and edit every single constant. 
The easy way is to set the switch to FALSE.  If you turn the switch 
off (by setting it to FALSE) then the race tables are ignored and the
default loot category probability table (found at the very end of 
this file) is used to determine what category of loot drops for 
EVERY monster, no matter what race they are.  I placed what I 
considered "reasonable" frequencies in the default table (for example,
I made exotic weapons rarer than martial weapons) but I made sure
NOT to set any frequency for any category equal to zero.  Every 
type of loot category is possible with the default table.  If you 
use the values I have it will make some types of loot more frequent
than other types.  You can edit the default table just like you can
the race specific tables.
*/

// *****************************************
//
//				UPDATES
//
// *****************************************
// VERSION 1.2
// -28 August 2007. At the very end of this file is the default loot 
//     category constants.  I renamed them to fit the syntax used
//     by the race specific constants.  Previously they were:
//     FW_PROB_TREAS_CAT_*  Now they have the word "DEFAULT" added. 
//     I did this for consistency purposes and because I wanted to 
//     make sure the default values would be recognizable from race
//     specific ones.
//
// -28 August 2007. I used to have the race specific loot probabilities
//     ALL set equal to the default table.  This is not the case anymore
//     Many of the races still have the same distribution as the default
//     table.  This includes all the intelligent, biped, walks-upright
//     monsters. That's because they are smart enough and physically 
//     capable of carrying any type of item.  Where you'll notice the 
//     biggest difference is in the Beast, Animal, Vermin, etc. categories.
//     I couldn't stomach the idea of a beetle dropping plate armor.
//     So most of the loot categories for these races have been significantly
//     changed to represent what I think are more "reasonable" values.
//     As with anything in this file, you can change the values from 
//     the defaults I have to anything you want.  You have complete control
//     over how rare or frequent the different loot categories are.
//
// -28 August 2007.  I added a miscellaneous custom item loot category
//     to every race and to the default table.  Any custom items you have
//     will drop according to the frequency you set here for that loot
//     category.

// *****************************************
//        RACE SPECIFIC PROBABILITY TABLES
// 				FOR MORE CONTROL
//
//			  YOU CAN CHANGE THESE
// *****************************************

// ********* WHAT CATEGORY OF LOOT DROPS ***************
//
// The FW_PROB_*_TREAS_CAT_*2 constants.
//
// *  = Race of monster  
// *2 = the category of loot that will drop.
//
// This section handles the probability of a specific category of loot dropping.  
// These constants are only used when it has been determined that a monster will
// drop loot AND you the switch FW_RACE_SPECIFIC_LOOT_DROPS is set to TRUE;  
// If that switch is set to FALSE then it doesn't matter what you put in
// for the race specific values because they'll never get used and instead the 
// default values (found at the very end of this file) get used.
// 
// You control the probability of loot category that will drop for each race.  
// The higher the number you put, the more likely that category of item(s) 
// drop(s).  You'll note that these constants add up to 1000 (easy to figure 
// percentage for each category that way), but they do NOT have to add
// up to 1000.  By default I have Gold appearing as the most frequent type of loot,
// followed by consumable items, followed by rarer items, etc.  
//
// As you move down the list of constants, the frequency decreases.  This makes since
// from a traditional D&D perspective.  It is only natural that simple weapons be
// more common than martial weapons.  Similarly, martial weapons are more common than
// exotic weapons, and so forth.   
//
// One of the great things about my loot generation system is its robustness.  For 
// example, suppose you want to make heavy armors the most frequent item drop in
// your module, you can certainly do so by increasing the frequency of heavy armor 
// drops compared to the other categories of loot below.  The same holds true for any
// of the categories.  You get to decide what's rare and what isn't!!!!
//  
// The probabilities are relative to the total value of all the categories
// added together (within each race). I made my numbers add up to 1,000 to make it 
// easy to figure out the probability.  You don't have to follow my lead, but it's 
// easier if you do.  The same thing goes for armors: clothes are more common than
// plate mail, etc.  
//
// IMPORTANT: Since you are deciding what category of loot can drop for each
// race, you will most likely want to exclude certain types of loot for certain
// races.  For example, vermin (rats, beetles, etc.) probably shouldn't drop 
// heavy armor (unless your world is a little wacky and you want them to drop
// heavy armor).  If you put a zero in for any of the values that is the same 
// as excluding that type of loot from ever being possible for that particular
// race.  
//
// NOTE: Don't use negative values for the probability. You'll get unpredictable
// results.  
//
// NOTE 2: Zero is an acceptable value.  
//  
//
// ********* ABERRATION ********************
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_ABERRATION_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0  % default = not possible

// ********* ANIMAL ********************
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD				= 650; // 65  % default = most frequent
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 150; // 15  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER 				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION 		= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS 				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS 				= 100; // 10  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT 				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY 			= 100; // 10  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT 				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY 				= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_EXOTIC 			= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_DAMAGE_SHIELD		= 0;   //  0  % default
const int FW_PROB_ANIMAL_TREAS_CAT_MISC_CUSTOM_ITEM			= 0;   //  0  % default = not possible

// ********* BEAST ********************
const int FW_PROB_BEAST_TREAS_CAT_MISC_GOLD					= 650; // 65  % default = most frequent
const int FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 150; // 15  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_POTION				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_OTHER 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION 		= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_GEMS 				= 100; // 10  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY 				= 100; // 10  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY 				= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_EXOTIC 			= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 0;   //  0  % default
const int FW_PROB_BEAST_TREAS_CAT_MISC_DAMAGE_SHIELD		= 0;   //  0  % default 
const int FW_PROB_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0  % default = not possible

// ********* CONSTRUCT ********************
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD					= 175; // 17.5% default = most frequent
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MAGE_SPECIFIC	 	= 16;  //  1.6% default
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CUSTOM_ITEM			= 0;   //  0.0% default = not possible

// ********* DRAGON ********************
const int FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_DRAGON_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_DRAGON_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_DRAGON_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* DWARF ********************
const int FW_PROB_DWARF_TREAS_CAT_MISC_GOLD					= 175; // 17.5% default = most frequent
const int FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_DWARF_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_DWARF_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 16;  //  1.6% default
const int FW_PROB_DWARF_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_DWARF_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0.0% default = not possible

// ********* ELEMENTAL ********************
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD					= 175; // 17.5% default = most frequent
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 16;  //  1.6% default
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0.0% default = not possible

// ********* ELF ********************
const int FW_PROB_ELF_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_ELF_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_ELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_ELF_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_ELF_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* FEY ********************
const int FW_PROB_FEY_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_FEY_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_FEY_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_FEY_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_FEY_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* GIANT ********************
const int FW_PROB_GIANT_TREAS_CAT_MISC_GOLD					= 175; // 17.5% default = most frequent
const int FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_GIANT_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_GIANT_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 16;  //  1.6% default
const int FW_PROB_GIANT_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_GIANT_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0.0% default = not possible

// ********* GNOME ********************
const int FW_PROB_GNOME_TREAS_CAT_MISC_GOLD					= 175; // 17.5% default = most frequent
const int FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_GNOME_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_GNOME_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 16;  //  1.6% default
const int FW_PROB_GNOME_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_GNOME_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0.0% default = not possible

// ********* HALFELF ********************
const int FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HALFELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HALFELF_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HALFELF_TREAS_CAT_MISC_CUSTOM_ITEM		= 0;   //  0.0% default = not possible

// ********* HALFLING ********************
const int FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_POTION			= 70;  //  7  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL			= 70;  //  7  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER 			= 40;  //  4  % default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS 			= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING 		= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT 			= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL 		= 20;  //  2  % default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HALFLING_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HALFLING_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HALFLING_TREAS_CAT_MISC_CUSTOM_ITEM		= 0;   //  0.0% default = not possible

// ********* HALFORC ********************
const int FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HALFORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HALFORC_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HALFORC_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* HUMAN ********************
const int FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD				    = 175; // 17.5% default = most frequent
const int FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT			    = 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY 				= 30;  //  3  % default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT 				= 25;  //  2.5% default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET 				= 25;  //  2.5% default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM 				= 20;  //  2  % default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY 				= 16;  //  1.6% default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HUMAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC 		= 16;  //  1.6% default
const int FW_PROB_HUMAN_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HUMAN_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0.0% default = not possible

// ********* HUMANOID GOBLINOID ********************
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT 		    	= 25;  //  2.5% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY 			    = 16;  //  1.6% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* HUMANOID MONSTROUS ********************
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT 			    = 25;  //  2.5% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY 			    = 16;  //  1.6% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* HUMANOID ORC ********************
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION			= 70;  //  7  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL			= 70;  //  7  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER 			= 40;  //  4  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING 		= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL 		= 20;  //  2  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* HUMANOID REPTILIAN ********************
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT 			    = 25;  //  2.5% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY 			    = 16;  //  1.6% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* INCORPOREAL ********************
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* MAGICAL BEAST ********************
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD				    = 650; // 65  % default = most frequent
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 150; // 15  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER 				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION 		= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS 				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS 				= 100; // 10  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT			    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT 				= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY 			    = 100; // 10  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT 			    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET 			    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM 			    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY 			    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_EXOTIC 			= 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	    = 0;   //  0  % default
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_DAMAGE_SHIELD		= 0;   //  0  % default 
const int FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM 			= 0;   //  0  % default = not possible

// ********* OOZE ********************
const int FW_PROB_OOZE_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_OOZE_TREAS_CAT_MISC_POTION			= 70;  //  7  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL			= 70;  //  7  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_OTHER 			= 40;  //  4  % default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS 			= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING 		= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT 			= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL 		= 20;  //  2  % default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_OOZE_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_OOZE_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_OOZE_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* OUTSIDER ********************
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION			= 70;  //  7  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL			= 70;  //  7  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER 			= 40;  //  4  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS 			= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING 		= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT 			= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL 		= 20;  //  2  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_OUTSIDER_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* SHAPECHANGER ********************
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION			= 70;  //  7  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL			= 70;  //  7  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER 			= 40;  //  4  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS 			= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING 		= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT 			= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT 			= 25;  //  2.5% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL 		= 20;  //  2  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY 			= 16;  //  1.6% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CUSTOM_ITEM		= 0;   //  0.0% default = not possible

// ********* UNDEAD ********************
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD				= 175; // 17.5% default = most frequent
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 95;  //  9.5% default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION				= 70;  //  7  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL				= 70;  //  7  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER 				= 40;  //  4  % default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN 			= 40;  //  4  % default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION 		= 40;  //  4  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS 				= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS 				= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS				= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT			= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT 				= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING 			= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY 			= 30;  //  3  % default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT 			    = 25;  //  2.5% default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET 			= 25;  //  2.5% default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE 			= 25;  //  2.5% default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET 			= 25;  //  2.5% default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM 			= 20;  //  2  % default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS 			= 20;  //  2  % default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL 			= 20;  //  2  % default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED 			= 20;  //  2  % default
const int FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY 		    	= 16;  //  1.6% default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_EXOTIC 			= 16;  //  1.6% default
const int FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 16;  //  1.6% default
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_DAMAGE_SHIELD		= 2;   //  0.2% default = the rarest of treasure
const int FW_PROB_UNDEAD_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0.0% default = not possible

// ********* VERMIN ********************
const int FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD				= 650; // 65  % default = most frequent
const int FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL	= 150; // 15  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_POTION				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER 				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION 		= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS 				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS 				= 100; // 10  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT 				= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY 			= 100; // 10  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT 			    = 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY 			    = 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_EXOTIC 			= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	= 0;   //  0  % default
const int FW_PROB_VERMIN_TREAS_CAT_MISC_DAMAGE_SHIELD		= 0;   //  0  % default 
const int FW_PROB_VERMIN_TREAS_CAT_MISC_CUSTOM_ITEM 		= 0;   //  0  % default = not possible

// ********* WHAT DEFAULT CATEGORY OF LOOT DROPS ***************
//
// The FW_PROB_DEFAULT_TREAS_CAT_* constants.
//
// This is the default probability table for determining the category
// of loot that will drop when a monster spawns. I am guessing that most
// people will want to control what type of loot category can drop for
// each race.  All the other probabilities above in this file handle race
// specific loot category drops.  
//
// If you don't care about race specific loot drops, then the random 
// loot generator still needs some type of default to rely on so that
// it can generate loot.  That's what this table does. These values
// are only used if you set: "FW_RACE_SPECIFIC_LOOT_DROPS = FALSE;"
// in the file "fw_inc_loot_switches".  If you set that switch to 
// FALSE, then all of the other constants in this file up above don't
// get used and you won't have race specific loot drops.  You can ignore
// this table if you have that switch set to TRUE.
//
// NOTE: If you put a zero in for any of the values that is the same
// as excluding it from ever being possible.  
//
// NOTE 2: Do NOT use negative values for the probability. 
// You'll get unpredictable results.  
//
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD				=  0; // 17.5% default = most frequent
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL	        =  0;  //  9.5% default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION				=  0;  //  7  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL				=  0;  //  7  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER 				=  0;  //  4  % default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN 			= 70;  //  4  % default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION 		        =  0;  //  4  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS 				=  0;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS 				=  0;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS				=  0;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT			=  0;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING 			= 70;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT 				= 70;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING 			= 65;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY 			= 70;  //  3  % default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT 			= 60;  //  2.5% default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET 			= 60;  //  2.5% default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE 			= 70;  //  2.5% default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET 			= 70;  //  2.5% default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM 			= 60;  //  2  % default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS 			=  0;  //  2  % default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL 			= 70;  //  2  % default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED 			= 70;  //  2  % default
const int FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY 			= 70;  //  1.6% default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_EXOTIC 			= 65;  //  1.6% default
const int FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MAGE_SPECIFIC 	        = 60;  //  1.6% default
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_DAMAGE_SHIELD		        =  0;   //  0.2% default = the rarest of treasure
const int FW_PROB_DEFAULT_TREAS_CAT_MISC_CUSTOM_ITEM 		        =  0;   //  0.0% default = not possible



// *****************************************
//
//    PROBABILITY CONSTANTS AND TABLES
//
//	  YOU CAN CHANGE THESE IF YOU WANT				
//
// *****************************************

// This constant expresses how many rolls out of 1,000 a piece of loot is
// cursed. Default is 1 piece of loot out of 1,000 is cursed. The value
// of this constant only matters if you turned on (set to TRUE) the
// switch "FW_ALLOW_CURSED_ITEMS" in the file "fw_inc_loot_switches"
//
const int FW_PROB_CURSED_LOOT = 1;
 

// ******** PROBABILITY THAT A MONSTER DROPS LOOT ********************
//
// The FW_PROB_LOOT_CR_* constants.
//
// Probability of a monster dropping loot based off Creature Challenge Rating.
// Expressed as a percentage out of 100.  Default value for every CR rating is
// 50%.  This means exactly half of the monsters will drop some form of loot. 
// Acceptable values range from 0% to 100%.  This gives you total control over
// every CR rating and the probability of that monster CR dropping loot. 
// Here's 1 example of how to change it from the default to something else.
//
// Example 1: Changing the line for level 0 Challenge Rating Monsters
// 		   from: "const int FW_PROB_LOOT_CR_0 = 50;"
// 	         to: "const int FW_PROB_LOOT_CR_0 = 33;"   means CR level 0 monsters
//    would have a 33% chance of dropping loot instead of the default 50%.
//  
// NOTE: Acceptable values: 0,1,2,...,100  
//
// NOTE 2: Don't use negative values for the probability. You'll get unpredictable
// results.
//
const int FW_PROB_LOOT_CR_0 = 25; 

const int FW_PROB_LOOT_CR_1 = 20;  const int FW_PROB_LOOT_CR_11 = 15;  
const int FW_PROB_LOOT_CR_2 = 20;  const int FW_PROB_LOOT_CR_12 = 15;  
const int FW_PROB_LOOT_CR_3 = 20;  const int FW_PROB_LOOT_CR_13 = 15;  
const int FW_PROB_LOOT_CR_4 = 20;  const int FW_PROB_LOOT_CR_14 = 15;  
const int FW_PROB_LOOT_CR_5 = 20;  const int FW_PROB_LOOT_CR_15 = 10;  
const int FW_PROB_LOOT_CR_6 = 20;  const int FW_PROB_LOOT_CR_16 = 10;  
const int FW_PROB_LOOT_CR_7 = 20;  const int FW_PROB_LOOT_CR_17 = 10;  
const int FW_PROB_LOOT_CR_8 = 20;  const int FW_PROB_LOOT_CR_18 = 10;  
const int FW_PROB_LOOT_CR_9 = 20;  const int FW_PROB_LOOT_CR_19 = 10;  
const int FW_PROB_LOOT_CR_10 = 15;  const int FW_PROB_LOOT_CR_20 = 10; 

const int FW_PROB_LOOT_CR_21 = 10;  const int FW_PROB_LOOT_CR_31 = 05;  
const int FW_PROB_LOOT_CR_22 = 10;  const int FW_PROB_LOOT_CR_32 = 05;  
const int FW_PROB_LOOT_CR_23 = 10;  const int FW_PROB_LOOT_CR_33 = 05;  
const int FW_PROB_LOOT_CR_24 = 10;  const int FW_PROB_LOOT_CR_34 = 05;  
const int FW_PROB_LOOT_CR_25 = 10;  const int FW_PROB_LOOT_CR_35 = 05;  
const int FW_PROB_LOOT_CR_26 = 10;  const int FW_PROB_LOOT_CR_36 = 05;  
const int FW_PROB_LOOT_CR_27 = 10;  const int FW_PROB_LOOT_CR_37 = 05;  
const int FW_PROB_LOOT_CR_28 = 10;  const int FW_PROB_LOOT_CR_38 = 05;  
const int FW_PROB_LOOT_CR_29 = 10;  const int FW_PROB_LOOT_CR_39 = 05;  
const int FW_PROB_LOOT_CR_30 = 10;  const int FW_PROB_LOOT_CR_40 = 05; 

const int FW_PROB_LOOT_CR_41_OR_HIGHER = 05;


// ********** HOW MANY ITEMS DROP ************************
//
// The FW_PROB_*_ITEMS_DROPPED constants.
//
// This section handles the probability of how many items drop.  These
// constants are only used when it has already been determined that a monster
// will drop an item (at least 1). Then the question becomes: "How many items 
// will the monster drop?"  That's why there's nothing for zero items.
//
// You control the probability of the number of items that will drop.  
// The higher the number you put, the more likely that quantity of item(s) 
// drop(s).  You'll note that these constants add up to 1000 (easy to figure 
// percentage for each number of items that way), but they do NOT have to add
// up to 1000.  By default I have the lower number of items dropping more 
// frequently than many items. 
//
// These probabilities are relative to the total value of all the categories
// added together.  (I made my numbers add up to 1,000 to make it easy to
// figure out the probability, you don't have to follow my lead, but it's 
// easier if you do). 
//
// If you put a zero in for any of the values that is the same as excluding
// it from ever being possible.  I figure most people aren't going to want a 
// creature dropping 10 items, so in the default values below I have a zero
// in the 10 items dropped constant to remind you that you can have zeros for
// an acceptable value.
//
// NOTE: Although in the default the probabilities get smaller as the number
// of items goes up, that doesn't have to be the case.  
//
// NOTE 2: Don't use negative values for the probability. You'll get unpredictable
// results.
//
const int FW_PROB_1_ITEMS_DROPPED = 0;  // 60%   default (600/1000) = most frequent
const int FW_PROB_2_ITEMS_DROPPED = 800;  // 25%   default (250/1000)  
const int FW_PROB_3_ITEMS_DROPPED = 0;  // 10%   default (100/1000)  
const int FW_PROB_4_ITEMS_DROPPED = 150;   //  2.5% default (25/1000)  
const int FW_PROB_5_ITEMS_DROPPED = 0;   //  1.5% default (15/1000)  
const int FW_PROB_6_ITEMS_DROPPED = 50;    //  0.5% default (5/1000)  
const int FW_PROB_7_ITEMS_DROPPED = 0;    //  0.2% default (2/1000)  
const int FW_PROB_8_ITEMS_DROPPED = 0;    //  0.2% default (2/1000)  
const int FW_PROB_9_ITEMS_DROPPED = 0;    //  0.1% default (1/1000)  
const int FW_PROB_10_ITEMS_DROPPED = 0;   //  0.0% default (0/1000) = not possible


// *************** HOW MANY ITEM PROPERTIES *******************
//
// The FW_PROB_*_ITEM_PROPERTYS constants. 
//
// This is basically the same as above except we have to allow for zero item
// properties or else we would never get generic loot.  Just like 
// FW_PROB_*_ITEMS_DROPPED, these constants don't come into play unless it
// has already been determined that a monster will drop some loot and the
// loot can have item properties added to it (i.e. not gold or crafting material).
//
// NOTE: Same as above. Although the probabilities get smaller as the number
// of item properties goes up, that doesn't have to be the case.  You can use
// zero as a value to exclude something from being possible, like I did with
// the 10 item properties constant.
//
// NOTE 2: Don't use negative values for the probability. You'll get unpredictable
// results.
//
const int FW_PROB_0_ITEM_PROPERTYS = 0; // 35%   default (350/1000) = most frequent 
const int FW_PROB_1_ITEM_PROPERTYS = 0; // 25%   default (250/1000) 
const int FW_PROB_2_ITEM_PROPERTYS = 400; // 15%   default (150/1000) 
const int FW_PROB_3_ITEM_PROPERTYS = 0; // 10%   default (100/1000) 
const int FW_PROB_4_ITEM_PROPERTYS = 400;  //  7.5% default (75/1000) 
const int FW_PROB_5_ITEM_PROPERTYS = 0;  //  4.0% default (40/1000) 
const int FW_PROB_6_ITEM_PROPERTYS = 200;  //  2.0% default (20/1000) 
const int FW_PROB_7_ITEM_PROPERTYS = 0;  //  1.0% default (10/1000) 
const int FW_PROB_8_ITEM_PROPERTYS = 0;   //  0.3% default (3/1000) 
const int FW_PROB_9_ITEM_PROPERTYS = 0;   //  0.2% default (2/1000) 
const int FW_PROB_10_ITEM_PROPERTYS = 0;  //  0.0% default (0/1000) = not possible 


// *************** WHAT TYPE OF ARMOR MATERIAL DROPS *******************
//
// The FW_PROB_ARMOR_MATERIAL_* constants. 
//
// For the purposes of determining damage reduction (armors), we have
// to decide if the armor dropped will be of generic material or some 
// special type.
//
// The types for armors are: 
//
// Non-Specific,
// Metal Adamantine,
// Metal Darksteel,
// Metal Iron,
// Metal Mithral
//
// You set the probability of each metal type dropping with the constants
// below.  The higher the value you put in relation to the other values,
// the more likely that type of material drops. The default values add up
// to 1000, making calculation of probability easy for me. 
//
// NOTE: No negative numbers for probability. That would mess things up. 
//
// NOTE 2: Zero is an acceptable value.  That is how you would exclude 
//    something entirely.   
//
const int FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC  = 700; // 35  % default (350/1000)
const int FW_PROB_ARMOR_MATERIAL_IRON          = 250; // 30  % default (300/1000)
const int FW_PROB_ARMOR_MATERIAL_DARKSTEEL     = 0; // 17.5% default (175/1000)
const int FW_PROB_ARMOR_MATERIAL_ADAMANTINE    = 0; // 12.5% default (125/1000)
const int FW_PROB_ARMOR_MATERIAL_MITHRAL       = 50; //  5  % default (50/1000)


// *********** WHAT TYPE OF METAL WEAPON MATERIAL DROPS *******************
//
// The FW_PROB_METAL_WEAP_MATERIAL_* constants.   
//
// For the purposes of overcoming damage reduction (weapons), we have
// to decide if the weapon dropped will be of generic material or some 
// special type.
//
// The material types for metal weapons are: 
//
// Non-Specific,
// Metal Adamantine,
// Metal Alchemical Silver,
// Metal Cold Iron,
// Metal Darksteel,
// Metal Mithral
//
// You set the probability of each metal type dropping with the constants
// below.  The higher the value you put in relation to the other values,
// the more likely that type of material drops. The default values add up
// to 1000, making calculation of probability easy for me. 
//
// NOTE: No negative numbers for probability. That would mess things up. 
//
// NOTE 2: Zero is an acceptable value.  That is how you would exclude 
//    something entirely.   
//
const int FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC      = 700; // 50   % default (500/1000)
const int FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON         = 100; // 12.5 % default (125/1000)
const int FW_PROB_METAL_WEAP_MATERIAL_DARKSTEEL		= 100; // 12.5 % default (125/1000)
const int FW_PROB_METAL_WEAP_MATERIAL_ALCHEMICAL_SILVER = 100; // 12.5 % default (125/1000)
const int FW_PROB_METAL_WEAP_MATERIAL_ADAMANTINE 	=  0; //  7.5 % default (75/1000)
const int FW_PROB_METAL_WEAP_MATERIAL_MITHRAL		=  0; //  5   % default (50/1000)


// *********** WHAT TYPE OF WOODEN WEAPON MATERIAL DROPS *******************
//
// The FW_PROB_WOOD_WEAP_MATERIAL_* constants.   
//
// For the purposes of overcoming damage reduction (weapons), we have
// to decide if the weapon dropped will be of generic material or some 
// special type.
//
// The material types for wooden weapons are:
//
// Non-Specific,
// Duskwood,
// Zalantar
//
// You set the probability of each type dropping with the constants
// below.  The higher the value you put in relation to the other values,
// the more likely that type of material drops. The default values add up
// to 1000, making calculation of probability easy for me. 
//
// NOTE: No negative numbers for probability. That would mess things up. 
//
// NOTE 2: Zero is an acceptable value.  That is how you would exclude 
//    something entirely.   
//
const int FW_PROB_WOOD_WEAP_MATERIAL_NON_SPECIFIC = 800; // 65   % default (650/1000)
const int FW_PROB_WOOD_WEAP_MATERIAL_ZALANTAR     = 150; // 17.5 % default (175/1000)
const int FW_PROB_WOOD_WEAP_MATERIAL_DUSKWOOD     = 50; // 17.5 % default (175/1000)


// I apologize for the length of this file.  You can leave this file alone
// if you want and I have already set up default values.  However, to give
// you complete control, I had to account for every CR range inside of every
// single item property. This necessarily enlarged this file to be rather 
// long. The good thing is, you should only have to go through this file one
// time.  Warning: Because the default values for these constants allows for
// any item property that is possible, you will get some weird results
// unless you go through and edit this file.  OR you can ignore this file
// if you are using formula based cr scaling of your loot.  The switch
// that turns on formula based cr scaling is in the file: "fw_inc_loot_switches"
// 
// This whole file is where you set the ranges for what item properties can appear
// on an item.  You are able to set the range for every CR value. In this way, you
// can limit lower level monsters from dropping super uber gear.  Similarly, you 
// can limit high level monsters from dropping junk.  
//
// When a monster spawns, loot is created and put in the monster's inventory.  This
// treasure will be dropped by the monster when it dies (or if it is pick pocketed).
//  
// The preset values in these constants allow ALL item property values to appear on
// an item, irregardless of how strong or weak a monster is.  Which means, a level 3 
// CR goblin could drop up to a +20 attack bonus weapon.  For most people you probably
// don't want that to happen in your wrld, so you'll need to go through this file at least
// one time and set these constants to the range of values you want for each CR value.  

// I'm going to give one example to show what a modified table might look like
//
// 		EXAMPLE 1: A modified ATTACK BONUS table.
// 
// The minimum and maximum ATTACK_BONUS values an item could have (for every CR value)
// Acceptable values: 1,2,3,...,20
/*
const int FW_MIN_ATTACK_BONUS_CR_0 = 1; const int FW_MAX_ATTACK_BONUS_CR_0 = 1;

const int FW_MIN_ATTACK_BONUS_CR_1 = 1; const int FW_MAX_ATTACK_BONUS_CR_1 = 1;
const int FW_MIN_ATTACK_BONUS_CR_2 = 1; const int FW_MAX_ATTACK_BONUS_CR_2 = 1;
const int FW_MIN_ATTACK_BONUS_CR_3 = 1; const int FW_MAX_ATTACK_BONUS_CR_3 = 1;
const int FW_MIN_ATTACK_BONUS_CR_4 = 1; const int FW_MAX_ATTACK_BONUS_CR_4 = 1;
const int FW_MIN_ATTACK_BONUS_CR_5 = 1; const int FW_MAX_ATTACK_BONUS_CR_5 = 2;
const int FW_MIN_ATTACK_BONUS_CR_6 = 1; const int FW_MAX_ATTACK_BONUS_CR_6 = 2;
const int FW_MIN_ATTACK_BONUS_CR_7 = 1; const int FW_MAX_ATTACK_BONUS_CR_7 = 2;
const int FW_MIN_ATTACK_BONUS_CR_8 = 1; const int FW_MAX_ATTACK_BONUS_CR_8 = 2;
const int FW_MIN_ATTACK_BONUS_CR_9 = 1; const int FW_MAX_ATTACK_BONUS_CR_9 = 3;
const int FW_MIN_ATTACK_BONUS_CR_10 = 1; const int FW_MAX_ATTACK_BONUS_CR_10 = 3;

const int FW_MIN_ATTACK_BONUS_CR_11 = 1; const int FW_MAX_ATTACK_BONUS_CR_11 = 3;
const int FW_MIN_ATTACK_BONUS_CR_12 = 1; const int FW_MAX_ATTACK_BONUS_CR_12 = 3;
const int FW_MIN_ATTACK_BONUS_CR_13 = 2; const int FW_MAX_ATTACK_BONUS_CR_13 = 4;
const int FW_MIN_ATTACK_BONUS_CR_14 = 2; const int FW_MAX_ATTACK_BONUS_CR_14 = 4;
const int FW_MIN_ATTACK_BONUS_CR_15 = 2; const int FW_MAX_ATTACK_BONUS_CR_15 = 4;
const int FW_MIN_ATTACK_BONUS_CR_16 = 2; const int FW_MAX_ATTACK_BONUS_CR_16 = 4;
const int FW_MIN_ATTACK_BONUS_CR_17 = 3; const int FW_MAX_ATTACK_BONUS_CR_17 = 5;
const int FW_MIN_ATTACK_BONUS_CR_18 = 3; const int FW_MAX_ATTACK_BONUS_CR_18 = 5;
const int FW_MIN_ATTACK_BONUS_CR_19 = 3; const int FW_MAX_ATTACK_BONUS_CR_19 = 5;
const int FW_MIN_ATTACK_BONUS_CR_20 = 3; const int FW_MAX_ATTACK_BONUS_CR_20 = 5;

const int FW_MIN_ATTACK_BONUS_CR_21 = 4; const int FW_MAX_ATTACK_BONUS_CR_21 = 6;
const int FW_MIN_ATTACK_BONUS_CR_22 = 4; const int FW_MAX_ATTACK_BONUS_CR_22 = 6;
const int FW_MIN_ATTACK_BONUS_CR_23 = 4; const int FW_MAX_ATTACK_BONUS_CR_23 = 6;
const int FW_MIN_ATTACK_BONUS_CR_24 = 4; const int FW_MAX_ATTACK_BONUS_CR_24 = 6;
const int FW_MIN_ATTACK_BONUS_CR_25 = 5; const int FW_MAX_ATTACK_BONUS_CR_25 = 7;
const int FW_MIN_ATTACK_BONUS_CR_26 = 5; const int FW_MAX_ATTACK_BONUS_CR_26 = 7;
const int FW_MIN_ATTACK_BONUS_CR_27 = 5; const int FW_MAX_ATTACK_BONUS_CR_27 = 7;
const int FW_MIN_ATTACK_BONUS_CR_28 = 5; const int FW_MAX_ATTACK_BONUS_CR_28 = 7;
const int FW_MIN_ATTACK_BONUS_CR_29 = 6; const int FW_MAX_ATTACK_BONUS_CR_29 = 8;
const int FW_MIN_ATTACK_BONUS_CR_30 = 6; const int FW_MAX_ATTACK_BONUS_CR_30 = 8;

const int FW_MIN_ATTACK_BONUS_CR_31 = 6; const int FW_MAX_ATTACK_BONUS_CR_31 = 8;
const int FW_MIN_ATTACK_BONUS_CR_32 = 6; const int FW_MAX_ATTACK_BONUS_CR_32 = 8;
const int FW_MIN_ATTACK_BONUS_CR_33 = 7; const int FW_MAX_ATTACK_BONUS_CR_33 = 9;
const int FW_MIN_ATTACK_BONUS_CR_34 = 7; const int FW_MAX_ATTACK_BONUS_CR_34 = 9;
const int FW_MIN_ATTACK_BONUS_CR_35 = 7; const int FW_MAX_ATTACK_BONUS_CR_35 = 9;
const int FW_MIN_ATTACK_BONUS_CR_36 = 7; const int FW_MAX_ATTACK_BONUS_CR_36 = 9;
const int FW_MIN_ATTACK_BONUS_CR_37 = 8; const int FW_MAX_ATTACK_BONUS_CR_37 = 1;
const int FW_MIN_ATTACK_BONUS_CR_38 = 8; const int FW_MAX_ATTACK_BONUS_CR_38 = 10;
const int FW_MIN_ATTACK_BONUS_CR_39 = 8; const int FW_MAX_ATTACK_BONUS_CR_39 = 10;
const int FW_MIN_ATTACK_BONUS_CR_40 = 8; const int FW_MAX_ATTACK_BONUS_CR_40 = 10;

const int FW_MIN_ATTACK_BONUS_CR_41_OR_HIGHER = 8; const int FW_MAX_ATTACK_BONUS_CR_41_OR_HIGHER = 10;
*/

// Example 1 explained: 
//
// For CR monsters 0,1,2,3,4  I limited the min and max values to 1.  This means
// that if attack bonus is randomly chosen as the item property to add to a weapon
// then for these CR monsters there is only one option, +1, and that is what would
// get added.
//   
// For CR monsters 5,6,7,8 I limited the min to 1 and max value to 2. This means
// that if attack bonus is randomly chosen as the item property to add to a weapon
// then for these CR monsters it could be a +1 or a +2 attack bonus.  
// 
// For CR monsters 9,10,11,12 I limited the min to 1 and max value to 3. This means
// that if attack bonus is randomly chosen as the item property to add to a weapon
// then for these CR monsters it could be a +1, +2, or +3 attack bonus.
//
// Notice that for CR monsters 13,14,15,16 I raised the minimum to 2.  The max was
// also raised to 4.  If attack bonus is chosen as the random property to
// add to an item, the lowest attack bonus these monsters could have is +2.
// The highest attack bonus they would have on their loot is +4.  (they could also
// have +3).  In this way, you set the range for every CR of monster, up to level 41
//
// The rest of the example is the same as above.  CR monsters 17,18,19,20 can drop
// +3, +4, or +5 attack bonus weapons.  But they can't drop a +1 or +2 weapon because
// in the example I set the minimum at 3 for these CR.  Got it?  I hope so.
//
// You're on your own from here on.  Set ranges to what you want.  By default
// the min value allows the lowest amount possible and by default the max allows
// the highest amount possible. 
//
// Each category of item property in this file only comes into play if the switch
// that allows them was set to TRUE in the file "fw_inc_loot_switches".  If you set 
// something to FALSE in "fw_inc_loot_switches" then it doesn't matter what the 
// corresponding item property constant values are in this file.  

// ABILITY BONUS
// The minimum and maximum Ability Bonus an item could have (for each CR level).
// Acceptable values: 1,2,3,...,12
const int FW_MIN_ABILITY_BONUS_CR_0 = 1; const int FW_MAX_ABILITY_BONUS_CR_0 = 12;

const int FW_MIN_ABILITY_BONUS_CR_1 = 1; const int FW_MAX_ABILITY_BONUS_CR_1 = 12;
const int FW_MIN_ABILITY_BONUS_CR_2 = 1; const int FW_MAX_ABILITY_BONUS_CR_2 = 12;
const int FW_MIN_ABILITY_BONUS_CR_3 = 1; const int FW_MAX_ABILITY_BONUS_CR_3 = 12;
const int FW_MIN_ABILITY_BONUS_CR_4 = 1; const int FW_MAX_ABILITY_BONUS_CR_4 = 12;
const int FW_MIN_ABILITY_BONUS_CR_5 = 1; const int FW_MAX_ABILITY_BONUS_CR_5 = 12;
const int FW_MIN_ABILITY_BONUS_CR_6 = 1; const int FW_MAX_ABILITY_BONUS_CR_6 = 12;
const int FW_MIN_ABILITY_BONUS_CR_7 = 1; const int FW_MAX_ABILITY_BONUS_CR_7 = 12;
const int FW_MIN_ABILITY_BONUS_CR_8 = 1; const int FW_MAX_ABILITY_BONUS_CR_8 = 12;
const int FW_MIN_ABILITY_BONUS_CR_9 = 1; const int FW_MAX_ABILITY_BONUS_CR_9 = 12;
const int FW_MIN_ABILITY_BONUS_CR_10 = 1; const int FW_MAX_ABILITY_BONUS_CR_10 = 12;

const int FW_MIN_ABILITY_BONUS_CR_11 = 1; const int FW_MAX_ABILITY_BONUS_CR_11 = 12;
const int FW_MIN_ABILITY_BONUS_CR_12 = 1; const int FW_MAX_ABILITY_BONUS_CR_12 = 12;
const int FW_MIN_ABILITY_BONUS_CR_13 = 1; const int FW_MAX_ABILITY_BONUS_CR_13 = 12;
const int FW_MIN_ABILITY_BONUS_CR_14 = 1; const int FW_MAX_ABILITY_BONUS_CR_14 = 12;
const int FW_MIN_ABILITY_BONUS_CR_15 = 1; const int FW_MAX_ABILITY_BONUS_CR_15 = 12;
const int FW_MIN_ABILITY_BONUS_CR_16 = 1; const int FW_MAX_ABILITY_BONUS_CR_16 = 12;
const int FW_MIN_ABILITY_BONUS_CR_17 = 1; const int FW_MAX_ABILITY_BONUS_CR_17 = 12;
const int FW_MIN_ABILITY_BONUS_CR_18 = 1; const int FW_MAX_ABILITY_BONUS_CR_18 = 12;
const int FW_MIN_ABILITY_BONUS_CR_19 = 1; const int FW_MAX_ABILITY_BONUS_CR_19 = 12;
const int FW_MIN_ABILITY_BONUS_CR_20 = 1; const int FW_MAX_ABILITY_BONUS_CR_20 = 12;

const int FW_MIN_ABILITY_BONUS_CR_21 = 1; const int FW_MAX_ABILITY_BONUS_CR_21 = 12;
const int FW_MIN_ABILITY_BONUS_CR_22 = 1; const int FW_MAX_ABILITY_BONUS_CR_22 = 12;
const int FW_MIN_ABILITY_BONUS_CR_23 = 1; const int FW_MAX_ABILITY_BONUS_CR_23 = 12;
const int FW_MIN_ABILITY_BONUS_CR_24 = 1; const int FW_MAX_ABILITY_BONUS_CR_24 = 12;
const int FW_MIN_ABILITY_BONUS_CR_25 = 1; const int FW_MAX_ABILITY_BONUS_CR_25 = 12;
const int FW_MIN_ABILITY_BONUS_CR_26 = 1; const int FW_MAX_ABILITY_BONUS_CR_26 = 12;
const int FW_MIN_ABILITY_BONUS_CR_27 = 1; const int FW_MAX_ABILITY_BONUS_CR_27 = 12;
const int FW_MIN_ABILITY_BONUS_CR_28 = 1; const int FW_MAX_ABILITY_BONUS_CR_28 = 12;
const int FW_MIN_ABILITY_BONUS_CR_29 = 1; const int FW_MAX_ABILITY_BONUS_CR_29 = 12;
const int FW_MIN_ABILITY_BONUS_CR_30 = 1; const int FW_MAX_ABILITY_BONUS_CR_30 = 12;

const int FW_MIN_ABILITY_BONUS_CR_31 = 1; const int FW_MAX_ABILITY_BONUS_CR_31 = 12;
const int FW_MIN_ABILITY_BONUS_CR_32 = 1; const int FW_MAX_ABILITY_BONUS_CR_32 = 12;
const int FW_MIN_ABILITY_BONUS_CR_33 = 1; const int FW_MAX_ABILITY_BONUS_CR_33 = 12;
const int FW_MIN_ABILITY_BONUS_CR_34 = 1; const int FW_MAX_ABILITY_BONUS_CR_34 = 12;
const int FW_MIN_ABILITY_BONUS_CR_35 = 1; const int FW_MAX_ABILITY_BONUS_CR_35 = 12;
const int FW_MIN_ABILITY_BONUS_CR_36 = 1; const int FW_MAX_ABILITY_BONUS_CR_36 = 12;
const int FW_MIN_ABILITY_BONUS_CR_37 = 1; const int FW_MAX_ABILITY_BONUS_CR_37 = 12;
const int FW_MIN_ABILITY_BONUS_CR_38 = 1; const int FW_MAX_ABILITY_BONUS_CR_38 = 12;
const int FW_MIN_ABILITY_BONUS_CR_39 = 1; const int FW_MAX_ABILITY_BONUS_CR_39 = 12;
const int FW_MIN_ABILITY_BONUS_CR_40 = 1; const int FW_MAX_ABILITY_BONUS_CR_40 = 12;

const int FW_MIN_ABILITY_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_ABILITY_BONUS_CR_41_OR_HIGHER = 12;

// AC BONUS
// The minimum and maximum AC Bonus values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_AC_BONUS_CR_0 = 1; const int FW_MAX_AC_BONUS_CR_0 = 20;

const int FW_MIN_AC_BONUS_CR_1 = 1; const int FW_MAX_AC_BONUS_CR_1 = 20;
const int FW_MIN_AC_BONUS_CR_2 = 1; const int FW_MAX_AC_BONUS_CR_2 = 20;
const int FW_MIN_AC_BONUS_CR_3 = 1; const int FW_MAX_AC_BONUS_CR_3 = 20;
const int FW_MIN_AC_BONUS_CR_4 = 1; const int FW_MAX_AC_BONUS_CR_4 = 20;
const int FW_MIN_AC_BONUS_CR_5 = 1; const int FW_MAX_AC_BONUS_CR_5 = 20;
const int FW_MIN_AC_BONUS_CR_6 = 1; const int FW_MAX_AC_BONUS_CR_6 = 20;
const int FW_MIN_AC_BONUS_CR_7 = 1; const int FW_MAX_AC_BONUS_CR_7 = 20;
const int FW_MIN_AC_BONUS_CR_8 = 1; const int FW_MAX_AC_BONUS_CR_8 = 20;
const int FW_MIN_AC_BONUS_CR_9 = 1; const int FW_MAX_AC_BONUS_CR_9 = 20;
const int FW_MIN_AC_BONUS_CR_10 = 1; const int FW_MAX_AC_BONUS_CR_10 = 20;

const int FW_MIN_AC_BONUS_CR_11 = 1; const int FW_MAX_AC_BONUS_CR_11 = 20;
const int FW_MIN_AC_BONUS_CR_12 = 1; const int FW_MAX_AC_BONUS_CR_12 = 20;
const int FW_MIN_AC_BONUS_CR_13 = 1; const int FW_MAX_AC_BONUS_CR_13 = 20;
const int FW_MIN_AC_BONUS_CR_14 = 1; const int FW_MAX_AC_BONUS_CR_14 = 20;
const int FW_MIN_AC_BONUS_CR_15 = 1; const int FW_MAX_AC_BONUS_CR_15 = 20;
const int FW_MIN_AC_BONUS_CR_16 = 1; const int FW_MAX_AC_BONUS_CR_16 = 20;
const int FW_MIN_AC_BONUS_CR_17 = 1; const int FW_MAX_AC_BONUS_CR_17 = 20;
const int FW_MIN_AC_BONUS_CR_18 = 1; const int FW_MAX_AC_BONUS_CR_18 = 20;
const int FW_MIN_AC_BONUS_CR_19 = 1; const int FW_MAX_AC_BONUS_CR_19 = 20;
const int FW_MIN_AC_BONUS_CR_20 = 1; const int FW_MAX_AC_BONUS_CR_20 = 20;

const int FW_MIN_AC_BONUS_CR_21 = 1; const int FW_MAX_AC_BONUS_CR_21 = 20;
const int FW_MIN_AC_BONUS_CR_22 = 1; const int FW_MAX_AC_BONUS_CR_22 = 20;
const int FW_MIN_AC_BONUS_CR_23 = 1; const int FW_MAX_AC_BONUS_CR_23 = 20;
const int FW_MIN_AC_BONUS_CR_24 = 1; const int FW_MAX_AC_BONUS_CR_24 = 20;
const int FW_MIN_AC_BONUS_CR_25 = 1; const int FW_MAX_AC_BONUS_CR_25 = 20;
const int FW_MIN_AC_BONUS_CR_26 = 1; const int FW_MAX_AC_BONUS_CR_26 = 20;
const int FW_MIN_AC_BONUS_CR_27 = 1; const int FW_MAX_AC_BONUS_CR_27 = 20;
const int FW_MIN_AC_BONUS_CR_28 = 1; const int FW_MAX_AC_BONUS_CR_28 = 20;
const int FW_MIN_AC_BONUS_CR_29 = 1; const int FW_MAX_AC_BONUS_CR_29 = 20;
const int FW_MIN_AC_BONUS_CR_30 = 1; const int FW_MAX_AC_BONUS_CR_30 = 20;

const int FW_MIN_AC_BONUS_CR_31 = 1; const int FW_MAX_AC_BONUS_CR_31 = 20;
const int FW_MIN_AC_BONUS_CR_32 = 1; const int FW_MAX_AC_BONUS_CR_32 = 20;
const int FW_MIN_AC_BONUS_CR_33 = 1; const int FW_MAX_AC_BONUS_CR_33 = 20;
const int FW_MIN_AC_BONUS_CR_34 = 1; const int FW_MAX_AC_BONUS_CR_34 = 20;
const int FW_MIN_AC_BONUS_CR_35 = 1; const int FW_MAX_AC_BONUS_CR_35 = 20;
const int FW_MIN_AC_BONUS_CR_36 = 1; const int FW_MAX_AC_BONUS_CR_36 = 20;
const int FW_MIN_AC_BONUS_CR_37 = 1; const int FW_MAX_AC_BONUS_CR_37 = 20;
const int FW_MIN_AC_BONUS_CR_38 = 1; const int FW_MAX_AC_BONUS_CR_38 = 20;
const int FW_MIN_AC_BONUS_CR_39 = 1; const int FW_MAX_AC_BONUS_CR_39 = 20;
const int FW_MIN_AC_BONUS_CR_40 = 1; const int FW_MAX_AC_BONUS_CR_40 = 20;

const int FW_MIN_AC_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_BONUS_CR_41_OR_HIGHER = 20;

// AC BONUS VS. ALIGN GROUP
// The minimum and maximum AC Bonus vs. Align GROUP values an item could
// have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_0 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_0 = 20;

const int FW_MIN_AC_BONUS_VS_ALIGN_CR_1 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_1 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_2 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_2 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_3 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_3 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_4 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_4 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_5 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_5 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_6 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_6 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_7 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_7 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_8 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_8 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_9 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_9 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_10 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_10 = 20;

const int FW_MIN_AC_BONUS_VS_ALIGN_CR_11 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_11 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_12 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_12 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_13 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_13 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_14 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_14 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_15 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_15 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_16 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_16 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_17 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_17 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_18 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_18 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_19 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_19 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_20 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_20 = 20;

const int FW_MIN_AC_BONUS_VS_ALIGN_CR_21 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_21 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_22 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_22 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_23 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_23 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_24 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_24 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_25 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_25 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_26 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_26 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_27 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_27 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_28 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_28 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_29 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_29 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_30 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_30 = 20;

const int FW_MIN_AC_BONUS_VS_ALIGN_CR_31 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_31 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_32 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_32 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_33 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_33 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_34 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_34 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_35 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_35 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_36 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_36 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_37 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_37 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_38 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_38 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_39 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_39 = 20;
const int FW_MIN_AC_BONUS_VS_ALIGN_CR_40 = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_40 = 20;

const int FW_MIN_AC_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 20;

// AC BONUS VS DAMAGE TYPE
// The minimum and maximum AC Bonus Vs. Damage Type values an item could
// have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_0 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_0 = 20;

const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_1 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_1 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_2 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_2 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_3 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_3 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_4 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_4 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_5 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_5 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_6 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_6 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_7 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_7 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_8 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_8 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_9 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_9 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_10 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_10 = 20;

const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_11 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_11 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_12 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_12 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_13 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_13 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_14 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_14 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_15 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_15 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_16 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_16 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_17 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_17 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_18 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_18 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_19 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_19 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_20 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_20 = 20;

const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_21 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_21 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_22 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_22 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_23 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_23 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_24 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_24 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_25 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_25 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_26 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_26 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_27 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_27 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_28 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_28 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_29 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_29 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_30 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_30 = 20;

const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_31 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_31 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_32 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_32 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_33 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_33 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_34 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_34 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_35 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_35 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_36 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_36 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_37 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_37 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_38 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_38 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_39 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_39 = 20;
const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_40 = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_40 = 20;

const int FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_41_OR_HIGHER = 20;

// AC BONUS VS RACE
// The minimum and maximum AC Bonus Vs. Race values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_AC_BONUS_VS_RACE_CR_0 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_0 = 20;

const int FW_MIN_AC_BONUS_VS_RACE_CR_1 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_1 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_2 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_2 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_3 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_3 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_4 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_4 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_5 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_5 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_6 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_6 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_7 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_7 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_8 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_8 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_9 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_9 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_10 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_10 = 20;

const int FW_MIN_AC_BONUS_VS_RACE_CR_11 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_11 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_12 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_12 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_13 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_13 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_14 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_14 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_15 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_15 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_16 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_16 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_17 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_17 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_18 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_18 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_19 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_19 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_20 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_20 = 20;

const int FW_MIN_AC_BONUS_VS_RACE_CR_21 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_21 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_22 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_22 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_23 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_23 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_24 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_24 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_25 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_25 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_26 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_26 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_27 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_27 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_28 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_28 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_29 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_29 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_30 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_30 = 20;

const int FW_MIN_AC_BONUS_VS_RACE_CR_31 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_31 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_32 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_32 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_33 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_33 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_34 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_34 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_35 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_35 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_36 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_36 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_37 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_37 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_38 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_38 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_39 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_39 = 20;
const int FW_MIN_AC_BONUS_VS_RACE_CR_40 = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_40 = 20;

const int FW_MIN_AC_BONUS_VS_RACE_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_BONUS_VS_RACE_CR_41_OR_HIGHER = 20;

// AC BONUS VS SPECIFIC ALIGNMENT
// The minimum and maximum AC Bonus Vs Specific Alignment values an item
// could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_0 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_0 = 20;

const int FW_MIN_AC_BONUS_VS_SALIGN_CR_1 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_1 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_2 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_2 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_3 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_3 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_4 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_4 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_5 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_5 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_6 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_6 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_7 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_7 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_8 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_8 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_9 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_9 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_10 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_10 = 20;

const int FW_MIN_AC_BONUS_VS_SALIGN_CR_11 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_11 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_12 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_12 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_13 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_13 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_14 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_14 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_15 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_15 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_16 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_16 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_17 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_17 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_18 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_18 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_19 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_19 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_20 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_20 = 20;

const int FW_MIN_AC_BONUS_VS_SALIGN_CR_21 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_21 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_22 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_22 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_23 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_23 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_24 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_24 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_25 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_25 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_26 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_26 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_27 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_27 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_28 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_28 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_29 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_29 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_30 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_30 = 20;

const int FW_MIN_AC_BONUS_VS_SALIGN_CR_31 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_31 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_32 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_32 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_33 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_33 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_34 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_34 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_35 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_35 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_36 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_36 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_37 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_37 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_38 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_38 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_39 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_39 = 20;
const int FW_MIN_AC_BONUS_VS_SALIGN_CR_40 = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_40 = 20;

const int FW_MIN_AC_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 20;

// ARCANE SPELL FAILURE
// There is no min/max switch to limit arcane spell failure.  To change what 
// can or can't appear on items for this item property, you need to go into the
// function FW_Choose_IP_Arcane_Spell_Failure and comment out the case 
// statements that you don't want to appear. By default, all types (both 
// positive and negative) arcane spell failure can appear on an item. Only
// an experienced scripter should modify the function.

// ATTACK BONUS
// The minimum and maximum Attack Bonus values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ATTACK_BONUS_CR_0 = 1; const int FW_MAX_ATTACK_BONUS_CR_0 = 20;

const int FW_MIN_ATTACK_BONUS_CR_1 = 1; const int FW_MAX_ATTACK_BONUS_CR_1 = 20;
const int FW_MIN_ATTACK_BONUS_CR_2 = 1; const int FW_MAX_ATTACK_BONUS_CR_2 = 20;
const int FW_MIN_ATTACK_BONUS_CR_3 = 1; const int FW_MAX_ATTACK_BONUS_CR_3 = 20;
const int FW_MIN_ATTACK_BONUS_CR_4 = 1; const int FW_MAX_ATTACK_BONUS_CR_4 = 20;
const int FW_MIN_ATTACK_BONUS_CR_5 = 1; const int FW_MAX_ATTACK_BONUS_CR_5 = 20;
const int FW_MIN_ATTACK_BONUS_CR_6 = 1; const int FW_MAX_ATTACK_BONUS_CR_6 = 20;
const int FW_MIN_ATTACK_BONUS_CR_7 = 1; const int FW_MAX_ATTACK_BONUS_CR_7 = 20;
const int FW_MIN_ATTACK_BONUS_CR_8 = 1; const int FW_MAX_ATTACK_BONUS_CR_8 = 20;
const int FW_MIN_ATTACK_BONUS_CR_9 = 1; const int FW_MAX_ATTACK_BONUS_CR_9 = 20;
const int FW_MIN_ATTACK_BONUS_CR_10 = 1; const int FW_MAX_ATTACK_BONUS_CR_10 = 20;

const int FW_MIN_ATTACK_BONUS_CR_11 = 1; const int FW_MAX_ATTACK_BONUS_CR_11 = 20;
const int FW_MIN_ATTACK_BONUS_CR_12 = 1; const int FW_MAX_ATTACK_BONUS_CR_12 = 20;
const int FW_MIN_ATTACK_BONUS_CR_13 = 1; const int FW_MAX_ATTACK_BONUS_CR_13 = 20;
const int FW_MIN_ATTACK_BONUS_CR_14 = 1; const int FW_MAX_ATTACK_BONUS_CR_14 = 20;
const int FW_MIN_ATTACK_BONUS_CR_15 = 1; const int FW_MAX_ATTACK_BONUS_CR_15 = 20;
const int FW_MIN_ATTACK_BONUS_CR_16 = 1; const int FW_MAX_ATTACK_BONUS_CR_16 = 20;
const int FW_MIN_ATTACK_BONUS_CR_17 = 1; const int FW_MAX_ATTACK_BONUS_CR_17 = 20;
const int FW_MIN_ATTACK_BONUS_CR_18 = 1; const int FW_MAX_ATTACK_BONUS_CR_18 = 20;
const int FW_MIN_ATTACK_BONUS_CR_19 = 1; const int FW_MAX_ATTACK_BONUS_CR_19 = 20;
const int FW_MIN_ATTACK_BONUS_CR_20 = 1; const int FW_MAX_ATTACK_BONUS_CR_20 = 20;

const int FW_MIN_ATTACK_BONUS_CR_21 = 1; const int FW_MAX_ATTACK_BONUS_CR_21 = 20;
const int FW_MIN_ATTACK_BONUS_CR_22 = 1; const int FW_MAX_ATTACK_BONUS_CR_22 = 20;
const int FW_MIN_ATTACK_BONUS_CR_23 = 1; const int FW_MAX_ATTACK_BONUS_CR_23 = 20;
const int FW_MIN_ATTACK_BONUS_CR_24 = 1; const int FW_MAX_ATTACK_BONUS_CR_24 = 20;
const int FW_MIN_ATTACK_BONUS_CR_25 = 1; const int FW_MAX_ATTACK_BONUS_CR_25 = 20;
const int FW_MIN_ATTACK_BONUS_CR_26 = 1; const int FW_MAX_ATTACK_BONUS_CR_26 = 20;
const int FW_MIN_ATTACK_BONUS_CR_27 = 1; const int FW_MAX_ATTACK_BONUS_CR_27 = 20;
const int FW_MIN_ATTACK_BONUS_CR_28 = 1; const int FW_MAX_ATTACK_BONUS_CR_28 = 20;
const int FW_MIN_ATTACK_BONUS_CR_29 = 1; const int FW_MAX_ATTACK_BONUS_CR_29 = 20;
const int FW_MIN_ATTACK_BONUS_CR_30 = 1; const int FW_MAX_ATTACK_BONUS_CR_30 = 20;

const int FW_MIN_ATTACK_BONUS_CR_31 = 1; const int FW_MAX_ATTACK_BONUS_CR_31 = 20;
const int FW_MIN_ATTACK_BONUS_CR_32 = 1; const int FW_MAX_ATTACK_BONUS_CR_32 = 20;
const int FW_MIN_ATTACK_BONUS_CR_33 = 1; const int FW_MAX_ATTACK_BONUS_CR_33 = 20;
const int FW_MIN_ATTACK_BONUS_CR_34 = 1; const int FW_MAX_ATTACK_BONUS_CR_34 = 20;
const int FW_MIN_ATTACK_BONUS_CR_35 = 1; const int FW_MAX_ATTACK_BONUS_CR_35 = 20;
const int FW_MIN_ATTACK_BONUS_CR_36 = 1; const int FW_MAX_ATTACK_BONUS_CR_36 = 20;
const int FW_MIN_ATTACK_BONUS_CR_37 = 1; const int FW_MAX_ATTACK_BONUS_CR_37 = 20;
const int FW_MIN_ATTACK_BONUS_CR_38 = 1; const int FW_MAX_ATTACK_BONUS_CR_38 = 20;
const int FW_MIN_ATTACK_BONUS_CR_39 = 1; const int FW_MAX_ATTACK_BONUS_CR_39 = 20;
const int FW_MIN_ATTACK_BONUS_CR_40 = 1; const int FW_MAX_ATTACK_BONUS_CR_40 = 20;

const int FW_MIN_ATTACK_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_ATTACK_BONUS_CR_41_OR_HIGHER = 20;

// ATTACK BONUS VS ALIGNMENT GROUP
// The minimum and maximum Attack Bonus vs. Alignment GROUP values an item
// could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_0 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_0 = 20;

const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_1 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_1 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_2 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_2 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_3 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_3 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_4 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_4 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_5 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_5 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_6 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_6 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_7 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_7 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_8 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_8 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_9 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_9 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_10 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_10 = 20;

const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_11 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_11 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_12 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_12 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_13 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_13 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_14 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_14 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_15 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_15 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_16 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_16 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_17 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_17 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_18 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_18 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_19 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_19 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_20 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_20 = 20;

const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_21 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_21 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_22 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_22 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_23 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_23 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_24 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_24 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_25 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_25 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_26 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_26 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_27 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_27 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_28 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_28 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_29 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_29 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_30 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_30 = 20;

const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_31 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_31 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_32 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_32 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_33 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_33 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_34 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_34 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_35 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_35 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_36 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_36 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_37 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_37 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_38 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_38 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_39 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_39 = 20;
const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_40 = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_40 = 20;

const int FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 20;

// ATTACK BONUS VS RACE
// The minimum and maximum Attack Bonus Vs. Race values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_0 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_0 = 20;

const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_1 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_1 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_2 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_2 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_3 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_3 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_4 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_4 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_5 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_5 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_6 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_6 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_7 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_7 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_8 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_8 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_9 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_9 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_10 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_10 = 20;

const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_11 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_11 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_12 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_12 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_13 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_13 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_14 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_14 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_15 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_15 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_16 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_16 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_17 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_17 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_18 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_18 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_19 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_19 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_20 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_20 = 20;

const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_21 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_21 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_22 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_22 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_23 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_23 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_24 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_24 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_25 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_25 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_26 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_26 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_27 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_27 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_28 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_28 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_29 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_29 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_30 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_30 = 20;

const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_31 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_31 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_32 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_32 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_33 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_33 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_34 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_34 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_35 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_35 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_36 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_36 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_37 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_37 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_38 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_38 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_39 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_39 = 20;
const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_40 = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_40 = 20;

const int FW_MIN_ATTACK_BONUS_VS_RACE_CR_41_OR_HIGHER = 1; const int FW_MAX_ATTACK_BONUS_VS_RACE_CR_41_OR_HIGHER = 20;

// ATTACK BONUS VS. SPECIFIC ALIGNMENT
// The minimum and maximum Attack Bonus vs. SPECIFIC Alignment values an
// item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_0 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_0 = 20;

const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_1 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_1 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_2 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_2 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_3 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_3 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_4 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_4 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_5 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_5 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_6 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_6 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_7 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_7 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_8 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_8 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_9 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_9 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_10 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_10 = 20;

const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_11 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_11 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_12 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_12 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_13 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_13 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_14 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_14 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_15 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_15 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_16 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_16 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_17 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_17 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_18 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_18 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_19 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_19 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_20 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_20 = 20;

const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_21 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_21 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_22 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_22 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_23 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_23 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_24 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_24 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_25 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_25 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_26 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_26 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_27 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_27 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_28 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_28 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_29 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_29 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_30 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_30 = 20;

const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_31 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_31 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_32 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_32 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_33 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_33 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_34 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_34 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_35 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_35 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_36 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_36 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_37 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_37 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_38 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_38 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_39 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_39 = 20;
const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_40 = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_40 = 20;

const int FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 20;

// ATTACK PENALTY
// The minimum and maximum Attack Penalty an item could have (for each CR level).
// Acceptable values: 1 to 5. 1 = -1.  2 = -2 and so forth.  Max is 5!
const int FW_MIN_ATTACK_PENALTY_CR_0 = 1; const int FW_MAX_ATTACK_PENALTY_CR_0 = 5;

const int FW_MIN_ATTACK_PENALTY_CR_1 = 1; const int FW_MAX_ATTACK_PENALTY_CR_1 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_2 = 1; const int FW_MAX_ATTACK_PENALTY_CR_2 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_3 = 1; const int FW_MAX_ATTACK_PENALTY_CR_3 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_4 = 1; const int FW_MAX_ATTACK_PENALTY_CR_4 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_5 = 1; const int FW_MAX_ATTACK_PENALTY_CR_5 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_6 = 1; const int FW_MAX_ATTACK_PENALTY_CR_6 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_7 = 1; const int FW_MAX_ATTACK_PENALTY_CR_7 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_8 = 1; const int FW_MAX_ATTACK_PENALTY_CR_8 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_9 = 1; const int FW_MAX_ATTACK_PENALTY_CR_9 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_10 = 1; const int FW_MAX_ATTACK_PENALTY_CR_10 = 5;

const int FW_MIN_ATTACK_PENALTY_CR_11 = 1; const int FW_MAX_ATTACK_PENALTY_CR_11 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_12 = 1; const int FW_MAX_ATTACK_PENALTY_CR_12 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_13 = 1; const int FW_MAX_ATTACK_PENALTY_CR_13 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_14 = 1; const int FW_MAX_ATTACK_PENALTY_CR_14 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_15 = 1; const int FW_MAX_ATTACK_PENALTY_CR_15 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_16 = 1; const int FW_MAX_ATTACK_PENALTY_CR_16 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_17 = 1; const int FW_MAX_ATTACK_PENALTY_CR_17 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_18 = 1; const int FW_MAX_ATTACK_PENALTY_CR_18 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_19 = 1; const int FW_MAX_ATTACK_PENALTY_CR_19 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_20 = 1; const int FW_MAX_ATTACK_PENALTY_CR_20 = 5;

const int FW_MIN_ATTACK_PENALTY_CR_21 = 1; const int FW_MAX_ATTACK_PENALTY_CR_21 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_22 = 1; const int FW_MAX_ATTACK_PENALTY_CR_22 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_23 = 1; const int FW_MAX_ATTACK_PENALTY_CR_23 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_24 = 1; const int FW_MAX_ATTACK_PENALTY_CR_24 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_25 = 1; const int FW_MAX_ATTACK_PENALTY_CR_25 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_26 = 1; const int FW_MAX_ATTACK_PENALTY_CR_26 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_27 = 1; const int FW_MAX_ATTACK_PENALTY_CR_27 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_28 = 1; const int FW_MAX_ATTACK_PENALTY_CR_28 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_29 = 1; const int FW_MAX_ATTACK_PENALTY_CR_29 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_30 = 1; const int FW_MAX_ATTACK_PENALTY_CR_30 = 5;

const int FW_MIN_ATTACK_PENALTY_CR_31 = 1; const int FW_MAX_ATTACK_PENALTY_CR_31 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_32 = 1; const int FW_MAX_ATTACK_PENALTY_CR_32 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_33 = 1; const int FW_MAX_ATTACK_PENALTY_CR_33 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_34 = 1; const int FW_MAX_ATTACK_PENALTY_CR_34 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_35 = 1; const int FW_MAX_ATTACK_PENALTY_CR_35 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_36 = 1; const int FW_MAX_ATTACK_PENALTY_CR_36 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_37 = 1; const int FW_MAX_ATTACK_PENALTY_CR_37 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_38 = 1; const int FW_MAX_ATTACK_PENALTY_CR_38 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_39 = 1; const int FW_MAX_ATTACK_PENALTY_CR_39 = 5;
const int FW_MIN_ATTACK_PENALTY_CR_40 = 1; const int FW_MAX_ATTACK_PENALTY_CR_40 = 5;

const int FW_MIN_ATTACK_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_ATTACK_PENALTY_CR_41_OR_HIGHER = 5;

// * ITEM_PROPERTY_BONUS_FEAT
// There is no switch to change what feats can or can't appear on an item.
// If you want to change what feats can or can't appear you need to go into the
// function FW_Choose_IP_Bonus_Feat and comment out the case statements for the
// feats that you don't want to appear.  By default, all feats can appear on an
// item.

// BONUS LEVEL SPELL
// The minimum and maximum bonus spell level values an item could have
// (for each CR level).
// Acceptable values: 0,1,2,...9
const int FW_MIN_BONUS_LEVEL_SPELL_CR_0 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_0 = 9;

const int FW_MIN_BONUS_LEVEL_SPELL_CR_1 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_1 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_2 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_2 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_3 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_3 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_4 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_4 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_5 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_5 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_6 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_6 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_7 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_7 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_8 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_8 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_9 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_9 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_10 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_10 = 9;

const int FW_MIN_BONUS_LEVEL_SPELL_CR_11 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_11 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_12 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_12 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_13 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_13 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_14 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_14 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_15 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_15 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_16 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_16 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_17 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_17 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_18 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_18 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_19 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_19 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_20 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_20 = 9;

const int FW_MIN_BONUS_LEVEL_SPELL_CR_21 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_21 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_22 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_22 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_23 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_23 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_24 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_24 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_25 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_25 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_26 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_26 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_27 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_27 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_28 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_28 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_29 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_29 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_30 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_30 = 9;

const int FW_MIN_BONUS_LEVEL_SPELL_CR_31 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_31 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_32 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_32 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_33 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_33 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_34 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_34 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_35 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_35 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_36 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_36 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_37 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_37 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_38 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_38 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_39 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_39 = 9;
const int FW_MIN_BONUS_LEVEL_SPELL_CR_40 = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_40 = 9;

const int FW_MIN_BONUS_LEVEL_SPELL_CR_41_OR_HIGHER = 0; const int FW_MAX_BONUS_LEVEL_SPELL_CR_41_OR_HIGHER = 9;

// BONUS HIT POINTS
// The minimum and maximum Bonus Hit Point values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,50
const int FW_MIN_BONUS_HIT_POINTS_CR_0 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_0 = 50;

const int FW_MIN_BONUS_HIT_POINTS_CR_1 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_1 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_2 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_2 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_3 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_3 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_4 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_4 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_5 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_5 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_6 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_6 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_7 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_7 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_8 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_8 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_9 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_9 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_10 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_10 = 50;

const int FW_MIN_BONUS_HIT_POINTS_CR_11 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_11 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_12 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_12 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_13 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_13 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_14 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_14 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_15 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_15 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_16 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_16 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_17 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_17 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_18 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_18 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_19 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_19 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_20 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_20 = 50;

const int FW_MIN_BONUS_HIT_POINTS_CR_21 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_21 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_22 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_22 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_23 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_23 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_24 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_24 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_25 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_25 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_26 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_26 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_27 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_27 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_28 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_28 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_29 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_29 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_30 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_30 = 50;

const int FW_MIN_BONUS_HIT_POINTS_CR_31 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_31 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_32 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_32 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_33 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_33 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_34 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_34 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_35 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_35 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_36 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_36 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_37 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_37 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_38 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_38 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_39 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_39 = 50;
const int FW_MIN_BONUS_HIT_POINTS_CR_40 = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_40 = 50;

const int FW_MIN_BONUS_HIT_POINTS_CR_41_OR_HIGHER = 1; const int FW_MAX_BONUS_HIT_POINTS_CR_41_OR_HIGHER = 50;

// BONUS SAVING THROW
// The minimum and maximum Bonus Saving Throw values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_BONUS_SAVING_THROW_CR_0 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_0 = 20;

const int FW_MIN_BONUS_SAVING_THROW_CR_1 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_1 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_2 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_2 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_3 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_3 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_4 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_4 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_5 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_5 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_6 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_6 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_7 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_7 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_8 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_8 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_9 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_9 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_10 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_10 = 20;

const int FW_MIN_BONUS_SAVING_THROW_CR_11 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_11 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_12 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_12 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_13 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_13 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_14 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_14 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_15 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_15 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_16 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_16 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_17 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_17 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_18 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_18 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_19 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_19 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_20 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_20 = 20;

const int FW_MIN_BONUS_SAVING_THROW_CR_21 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_21 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_22 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_22 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_23 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_23 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_24 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_24 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_25 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_25 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_26 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_26 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_27 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_27 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_28 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_28 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_29 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_29 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_30 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_30 = 20;

const int FW_MIN_BONUS_SAVING_THROW_CR_31 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_31 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_32 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_32 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_33 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_33 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_34 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_34 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_35 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_35 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_36 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_36 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_37 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_37 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_38 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_38 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_39 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_39 = 20;
const int FW_MIN_BONUS_SAVING_THROW_CR_40 = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_40 = 20;

const int FW_MIN_BONUS_SAVING_THROW_CR_41_OR_HIGHER = 1; const int FW_MAX_BONUS_SAVING_THROW_CR_41_OR_HIGHER = 20;

// BONUS_SAVING_THROW_VSX
// The minimum and maximum Bonus Saving Throw Vs X values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_0 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_0 = 20;

const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_1 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_1 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_2 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_2 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_3 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_3 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_4 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_4 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_5 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_5 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_6 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_6 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_7 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_7 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_8 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_8 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_9 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_9 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_10 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_10 = 20;

const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_11 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_11 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_12 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_12 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_13 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_13 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_14 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_14 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_15 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_15 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_16 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_16 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_17 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_17 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_18 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_18 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_19 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_19 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_20 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_20 = 20;

const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_21 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_21 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_22 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_22 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_23 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_23 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_24 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_24 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_25 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_25 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_26 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_26 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_27 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_27 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_28 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_28 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_29 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_29 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_30 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_30 = 20;

const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_31 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_31 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_32 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_32 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_33 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_33 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_34 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_34 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_35 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_35 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_36 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_36 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_37 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_37 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_38 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_38 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_39 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_39 = 20;
const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_40 = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_40 = 20;

const int FW_MIN_BONUS_SAVING_THROW_VSX_CR_41_OR_HIGHER = 1; const int FW_MAX_BONUS_SAVING_THROW_VSX_CR_41_OR_HIGHER = 20;

// BONUS_SPELL_RESISTANCE
// The minimum and maximum Bonus Spell Resistance an item could have. Min=10, Max=32
// (for each CR level).  Acceptable values for min and max are 
// increments of 2 starting at 10 and ending at 32:  10,12,14,...,32
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_0 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_0 = 32;

const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_1 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_1 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_2 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_2 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_3 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_3 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_4 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_4 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_5 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_5 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_6 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_6 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_7 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_7 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_8 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_8 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_9 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_9 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_10 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_10 = 32;

const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_11 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_11 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_12 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_12 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_13 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_13 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_14 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_14 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_15 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_15 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_16 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_16 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_17 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_17 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_18 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_18 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_19 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_19 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_20 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_20 = 32;

const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_21 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_21 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_22 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_22 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_23 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_23 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_24 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_24 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_25 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_25 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_26 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_26 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_27 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_27 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_28 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_28 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_29 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_29 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_30 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_30 = 32;

const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_31 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_31 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_32 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_32 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_33 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_33 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_34 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_34 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_35 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_35 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_36 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_36 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_37 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_37 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_38 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_38 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_39 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_39 = 32;
const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_40 = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_40 = 32;

const int FW_MIN_BONUS_SPELL_RESISTANCE_CR_41_OR_HIGHER = 10; const int FW_MAX_BONUS_SPELL_RESISTANCE_CR_41_OR_HIGHER = 32;

// * ITEM_PROPERTY_CAST_SPELL_*
// By default the function that chooses ItemProperty
// CastSpell will choose from every single spell available (there are hundreds)
// If you want to disallow certain spells from being added to an item, then you
// need to go into the function: FW_Choose_IP_Cast_Spell and edit it.

// * ITEM_PROPERTY_DAMAGE_BONUS_*
// Setting min and max switches for damage bonuses requires a bit of explaining.
// I have ranked all the damage bonus item properties in ascending order based
// off of the average damage dealt by each item property. In cases where the
// average was a tie (i.e. 7 dmg and 2d6 dmg both average 7 dmg) I gave a higher
// ranking to the random amount because it can potentially roll much higher.
// By default I have the damage bonus constants set to min=0 and max=19.  This
// allows any amount of damage ranging from index 0 (measly +1 dmg.) up to and
// including index 19 (the powerful +2d12 dmg.) By changing the values of the
// constants you can specify the range of values you want to allow / disallow
// as possibilities. Here's a couple examples to show you what I mean.
// Example 1: You set FW_MIN_DAMAGE_BONUS = 5 and FW_MAX_DAMAGE_BONUS = 8.
//    Possibilities are now from index 5 to 8, or: +4, +1d8, +5, or +2d4 damage.
// Example 2: You set FW_MIN_DAMAGE_BONUS = 3 and FW_MAX_DAMAGE_BONUS = 8.
//    Possibilites are from index 3 to 8, or: +3, +1d6, +4, +1d8, +5, or +2d4
//    damage.
// Note: It's okay to set min = max.  There just wouldn't be any randomness
//    if you do that.
//
// TABLE: IP_CONST_DAMAGE_BONUS
//
// INDEX = ITEM_PROPERTY...AVERAGE DAMAGE
//   0   = 1    damage  ...avg = 1
//   1   = 2    damage  ...avg = 2
//   2   = 1d4  damage  ...avg = 2.5
//   3   = 3    damage  ...avg = 3
//   4   = 1d6  damage  ...avg = 3.5
//   5   = 4    damage  ...avg = 4
//   6   = 1d8  damage  ...avg = 4.5
//   7   = 5    damage  ...avg = 5
//   8   = 2d4  damage  ...avg = 5
//   9   = 1d10 damage  ...avg = 5.5
//   10  = 6    damage  ...avg = 6
//   11  = 1d12 damage  ...avg = 6.5
//   12  = 7    damage  ...avg = 7
//   13  = 2d6  damage  ...avg = 7
//   14  = 8    damage  ...avg = 8
//   15  = 9    damage  ...avg = 9
//   16  = 2d8  damage  ...avg = 9
//   17  = 10   damage  ...avg = 10
//   18  = 2d10 damage  ...avg = 11
//   19  = 2d12 damage  ...avg = 13
//
// The above table is used for the following item properties:
//   Damage Bonus
//   Damage Bonus Vs. Alignment Group
//   Damage Bonus Vs. Race
//   Damage Bonus vs. Specific Alignment
//   Massive Critical

// DAMAGE_BONUS
// The minimum and maximum Damage Bonus values an item could have
// (for each CR level).    See explanation and table above.
// Acceptable values: 0,1,2,3,...,19
const int FW_MIN_DAMAGE_BONUS_CR_0 = 0; const int FW_MAX_DAMAGE_BONUS_CR_0 = 19;

const int FW_MIN_DAMAGE_BONUS_CR_1 = 0; const int FW_MAX_DAMAGE_BONUS_CR_1 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_2 = 0; const int FW_MAX_DAMAGE_BONUS_CR_2 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_3 = 0; const int FW_MAX_DAMAGE_BONUS_CR_3 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_4 = 0; const int FW_MAX_DAMAGE_BONUS_CR_4 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_5 = 0; const int FW_MAX_DAMAGE_BONUS_CR_5 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_6 = 0; const int FW_MAX_DAMAGE_BONUS_CR_6 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_7 = 0; const int FW_MAX_DAMAGE_BONUS_CR_7 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_8 = 0; const int FW_MAX_DAMAGE_BONUS_CR_8 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_9 = 0; const int FW_MAX_DAMAGE_BONUS_CR_9 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_10 = 0; const int FW_MAX_DAMAGE_BONUS_CR_10 = 19;

const int FW_MIN_DAMAGE_BONUS_CR_11 = 0; const int FW_MAX_DAMAGE_BONUS_CR_11 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_12 = 0; const int FW_MAX_DAMAGE_BONUS_CR_12 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_13 = 0; const int FW_MAX_DAMAGE_BONUS_CR_13 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_14 = 0; const int FW_MAX_DAMAGE_BONUS_CR_14 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_15 = 0; const int FW_MAX_DAMAGE_BONUS_CR_15 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_16 = 0; const int FW_MAX_DAMAGE_BONUS_CR_16 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_17 = 0; const int FW_MAX_DAMAGE_BONUS_CR_17 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_18 = 0; const int FW_MAX_DAMAGE_BONUS_CR_18 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_19 = 0; const int FW_MAX_DAMAGE_BONUS_CR_19 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_20 = 0; const int FW_MAX_DAMAGE_BONUS_CR_20 = 19;

const int FW_MIN_DAMAGE_BONUS_CR_21 = 0; const int FW_MAX_DAMAGE_BONUS_CR_21 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_22 = 0; const int FW_MAX_DAMAGE_BONUS_CR_22 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_23 = 0; const int FW_MAX_DAMAGE_BONUS_CR_23 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_24 = 0; const int FW_MAX_DAMAGE_BONUS_CR_24 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_25 = 0; const int FW_MAX_DAMAGE_BONUS_CR_25 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_26 = 0; const int FW_MAX_DAMAGE_BONUS_CR_26 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_27 = 0; const int FW_MAX_DAMAGE_BONUS_CR_27 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_28 = 0; const int FW_MAX_DAMAGE_BONUS_CR_28 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_29 = 0; const int FW_MAX_DAMAGE_BONUS_CR_29 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_30 = 0; const int FW_MAX_DAMAGE_BONUS_CR_30 = 19;

const int FW_MIN_DAMAGE_BONUS_CR_31 = 0; const int FW_MAX_DAMAGE_BONUS_CR_31 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_32 = 0; const int FW_MAX_DAMAGE_BONUS_CR_32 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_33 = 0; const int FW_MAX_DAMAGE_BONUS_CR_33 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_34 = 0; const int FW_MAX_DAMAGE_BONUS_CR_34 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_35 = 0; const int FW_MAX_DAMAGE_BONUS_CR_35 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_36 = 0; const int FW_MAX_DAMAGE_BONUS_CR_36 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_37 = 0; const int FW_MAX_DAMAGE_BONUS_CR_37 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_38 = 0; const int FW_MAX_DAMAGE_BONUS_CR_38 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_39 = 0; const int FW_MAX_DAMAGE_BONUS_CR_39 = 19;
const int FW_MIN_DAMAGE_BONUS_CR_40 = 0; const int FW_MAX_DAMAGE_BONUS_CR_40 = 19;

const int FW_MIN_DAMAGE_BONUS_CR_41_OR_HIGHER = 0; const int FW_MAX_DAMAGE_BONUS_CR_41_OR_HIGHER = 19;

// DAMAGE_BONUS_VS_ALIGNMENT
// The minimum and maximum DAMAGE_BONUS_VS_ALIGNMENT values an item could have
// (for each CR level).   See explanation and table above.
// Acceptable values: 0,1,2,3,...,19
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_0 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_0 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_1 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_1 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_2 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_2 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_3 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_3 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_4 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_4 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_5 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_5 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_6 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_6 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_7 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_7 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_8 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_8 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_9 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_9 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_10 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_10 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_11 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_11 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_12 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_12 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_13 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_13 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_14 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_14 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_15 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_15 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_16 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_16 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_17 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_17 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_18 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_18 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_19 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_19 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_20 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_20 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_21 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_21 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_22 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_22 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_23 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_23 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_24 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_24 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_25 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_25 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_26 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_26 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_27 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_27 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_28 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_28 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_29 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_29 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_30 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_30 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_31 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_31 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_32 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_32 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_33 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_33 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_34 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_34 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_35 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_35 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_36 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_36 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_37 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_37 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_38 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_38 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_39 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_39 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_40 = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_40 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_41_OR_HIGHER = 0; const int FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_41_OR_HIGHER = 19;

// DAMAGE_BONUS_VS_RACE
// The minimum and maximum DAMAGE_BONUS_VS_RACE values an item could have
// (for each CR level).     See explanation and table above.
// Acceptable values: 0,1,2,3,...,19
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_0 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_0 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_1 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_1 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_2 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_2 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_3 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_3 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_4 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_4 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_5 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_5 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_6 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_6 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_7 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_7 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_8 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_8 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_9 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_9 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_10 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_10 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_11 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_11 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_12 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_12 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_13 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_13 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_14 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_14 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_15 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_15 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_16 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_16 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_17 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_17 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_18 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_18 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_19 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_19 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_20 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_20 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_21 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_21 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_22 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_22 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_23 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_23 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_24 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_24 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_25 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_25 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_26 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_26 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_27 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_27 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_28 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_28 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_29 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_29 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_30 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_30 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_31 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_31 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_32 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_32 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_33 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_33 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_34 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_34 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_35 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_35 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_36 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_36 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_37 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_37 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_38 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_38 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_39 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_39 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_40 = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_40 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_RACE_CR_41_OR_HIGHER = 0; const int FW_MAX_DAMAGE_BONUS_VS_RACE_CR_41_OR_HIGHER = 19;

// DAMAGE_BONUS_VS_SALIGNMENT
// The minimum and maximum Damage Bonus vs. SPECIFIC Alignment values an item could have
// (for each CR level). See explanation and table above.
// Acceptable values: 0,1,2,3,...,19
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_0 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_0 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_1 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_1 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_2 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_2 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_3 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_3 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_4 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_4 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_5 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_5 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_6 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_6 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_7 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_7 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_8 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_8 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_9 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_9 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_10 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_10 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_11 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_11 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_12 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_12 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_13 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_13 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_14 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_14 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_15 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_15 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_16 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_16 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_17 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_17 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_18 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_18 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_19 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_19 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_20 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_20 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_21 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_21 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_22 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_22 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_23 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_23 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_24 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_24 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_25 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_25 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_26 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_26 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_27 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_27 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_28 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_28 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_29 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_29 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_30 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_30 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_31 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_31 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_32 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_32 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_33 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_33 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_34 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_34 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_35 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_35 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_36 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_36 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_37 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_37 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_38 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_38 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_39 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_39 = 19;
const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_40 = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_40 = 19;

const int FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_41_OR_HIGHER = 0; const int FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_41_OR_HIGHER = 19;

// MASSIVE_CRITICAL_DAMAGE_BONUS
// The minimum and maximum MASSIVE_CRITICAL_DAMAGE_BONUS values an item could have
// (for each CR level).   See table and explanation above.
// Acceptable values: 0,1,2,3,...,20
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_0 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_0 = 19;

const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_1 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_1 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_2 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_2 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_3 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_3 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_4 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_4 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_5 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_5 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_6 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_6 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_7 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_7 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_8 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_8 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_9 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_9 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_10 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_10 = 19;

const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_11 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_11 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_12 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_12 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_13 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_13 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_14 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_14 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_15 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_15 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_16 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_16 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_17 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_17 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_18 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_18 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_19 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_19 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_20 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_20 = 19;

const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_21 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_21 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_22 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_22 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_23 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_23 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_24 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_24 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_25 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_25 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_26 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_26 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_27 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_27 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_28 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_28 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_29 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_29 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_30 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_30 = 19;

const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_31 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_31 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_32 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_32 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_33 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_33 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_34 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_34 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_35 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_35 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_36 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_36 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_37 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_37 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_38 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_38 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_39 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_39 = 19;
const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_40 = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_40 = 19;

const int FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_41_OR_HIGHER = 0; const int FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_41_OR_HIGHER = 19;

// * ITEM_PROPERTY_DAMAGE_IMMUNITY
// There is no switch to control min/max damage immunity amounts.  To disallow certain
// amounts you have to comment out the case statements inside the function
// FW_Choose_IP_Damage_Immunity ();  

// DAMAGE_PENALTY
// The minimum and maximum DAMAGE_PENALTY values an item could have
// (for each CR level).
// Acceptable values: 1 to 5.  I.E. 1 = -1, 2 = -2, etc.
const int FW_MIN_DAMAGE_PENALTY_CR_0 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_0 = 5;

const int FW_MIN_DAMAGE_PENALTY_CR_1 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_1 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_2 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_2 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_3 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_3 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_4 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_4 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_5 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_5 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_6 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_6 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_7 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_7 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_8 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_8 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_9 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_9 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_10 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_10 = 5;

const int FW_MIN_DAMAGE_PENALTY_CR_11 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_11 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_12 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_12 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_13 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_13 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_14 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_14 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_15 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_15 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_16 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_16 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_17 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_17 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_18 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_18 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_19 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_19 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_20 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_20 = 5;

const int FW_MIN_DAMAGE_PENALTY_CR_21 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_21 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_22 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_22 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_23 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_23 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_24 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_24 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_25 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_25 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_26 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_26 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_27 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_27 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_28 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_28 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_29 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_29 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_30 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_30 = 5;

const int FW_MIN_DAMAGE_PENALTY_CR_31 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_31 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_32 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_32 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_33 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_33 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_34 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_34 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_35 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_35 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_36 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_36 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_37 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_37 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_38 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_38 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_39 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_39 = 5;
const int FW_MIN_DAMAGE_PENALTY_CR_40 = 1; const int FW_MAX_DAMAGE_PENALTY_CR_40 = 5;

const int FW_MIN_DAMAGE_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_DAMAGE_PENALTY_CR_41_OR_HIGHER = 5;

// DAMAGE_REDUCTION 
// The minimum and maximum DAMAGE_REDUCTION values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_DAMAGE_REDUCTION_CR_0 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_0 = 20;

const int FW_MIN_DAMAGE_REDUCTION_CR_1 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_1 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_2 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_2 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_3 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_3 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_4 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_4 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_5 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_5 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_6 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_6 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_7 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_7 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_8 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_8 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_9 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_9 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_10 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_10 = 20;

const int FW_MIN_DAMAGE_REDUCTION_CR_11 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_11 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_12 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_12 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_13 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_13 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_14 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_14 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_15 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_15 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_16 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_16 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_17 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_17 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_18 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_18 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_19 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_19 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_20 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_20 = 20;

const int FW_MIN_DAMAGE_REDUCTION_CR_21 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_21 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_22 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_22 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_23 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_23 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_24 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_24 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_25 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_25 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_26 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_26 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_27 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_27 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_28 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_28 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_29 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_29 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_30 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_30 = 20;

const int FW_MIN_DAMAGE_REDUCTION_CR_31 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_31 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_32 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_32 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_33 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_33 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_34 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_34 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_35 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_35 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_36 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_36 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_37 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_37 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_38 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_38 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_39 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_39 = 20;
const int FW_MIN_DAMAGE_REDUCTION_CR_40 = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_40 = 20;

const int FW_MIN_DAMAGE_REDUCTION_CR_41_OR_HIGHER = 1; const int FW_MAX_DAMAGE_REDUCTION_CR_41_OR_HIGHER = 20;

// *DAMAGE SHIELDS*  
// Damage Shields scale according to the PC's level, not the spawning monster's 
// level.  Therefore, there is no constant to control scaling for Damage 
// Shields.  I already took care of damage shield scaling.  If you want to change
// the formula for damage shields to scale in some manner other than the way I have
// it set up already, you'll need to edit the file: "i_fw_damage_shield_ac".  But
// I recommend only a VERY EXPERIENCED programmer even attempt to change that file.
// And make sure you know all about tag based scripting before you do change it or 
// else you'll mess it up. Whatever you do, DON'T change the name of that file or 
// else it will definitely NOT work. 

// DAMAGESOAK_HP
// The minimum and maximum number of hit points that will be soaked up if your
// weapon is not of high enough enhancement. Acceptable values: 5,10,15,...,50
// Note: 0 is NOT an acceptable value.
const int FW_MIN_DAMAGESOAK_HP_CR_0 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_0 = 50;

const int FW_MIN_DAMAGESOAK_HP_CR_1 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_1 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_2 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_2 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_3 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_3 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_4 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_4 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_5 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_5 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_6 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_6 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_7 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_7 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_8 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_8 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_9 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_9 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_10 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_10 = 50;

const int FW_MIN_DAMAGESOAK_HP_CR_11 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_11 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_12 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_12 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_13 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_13 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_14 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_14 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_15 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_15 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_16 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_16 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_17 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_17 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_18 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_18 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_19 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_19 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_20 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_20 = 50;

const int FW_MIN_DAMAGESOAK_HP_CR_21 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_21 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_22 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_22 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_23 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_23 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_24 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_24 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_25 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_25 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_26 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_26 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_27 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_27 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_28 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_28 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_29 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_29 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_30 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_30 = 50;

const int FW_MIN_DAMAGESOAK_HP_CR_31 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_31 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_32 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_32 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_33 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_33 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_34 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_34 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_35 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_35 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_36 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_36 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_37 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_37 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_38 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_38 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_39 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_39 = 50;
const int FW_MIN_DAMAGESOAK_HP_CR_40 = 5; const int FW_MAX_DAMAGESOAK_HP_CR_40 = 50;

const int FW_MIN_DAMAGESOAK_HP_CR_41_OR_HIGHER = 5; const int FW_MAX_DAMAGESOAK_HP_CR_41_OR_HIGHER = 50;

// DAMAGE RESISTANCE
// The minimum and maximum number of HP that can be resisted each round as part
// of damage resistance. Acceptable values for min and max: 5,10,15,...,50
// Note: 0 is NOT an acceptable value.
const int FW_MIN_DAMAGERESIST_HP_CR_0 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_0 = 50;

const int FW_MIN_DAMAGERESIST_HP_CR_1 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_1 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_2 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_2 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_3 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_3 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_4 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_4 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_5 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_5 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_6 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_6 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_7 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_7 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_8 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_8 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_9 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_9 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_10 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_10 = 50;

const int FW_MIN_DAMAGERESIST_HP_CR_11 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_11 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_12 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_12 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_13 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_13 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_14 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_14 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_15 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_15 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_16 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_16 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_17 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_17 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_18 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_18 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_19 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_19 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_20 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_20 = 50;

const int FW_MIN_DAMAGERESIST_HP_CR_21 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_21 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_22 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_22 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_23 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_23 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_24 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_24 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_25 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_25 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_26 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_26 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_27 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_27 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_28 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_28 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_29 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_29 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_30 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_30 = 50;

const int FW_MIN_DAMAGERESIST_HP_CR_31 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_31 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_32 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_32 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_33 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_33 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_34 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_34 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_35 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_35 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_36 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_36 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_37 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_37 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_38 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_38 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_39 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_39 = 50;
const int FW_MIN_DAMAGERESIST_HP_CR_40 = 5; const int FW_MAX_DAMAGERESIST_HP_CR_40 = 50;

const int FW_MIN_DAMAGERESIST_HP_CR_41_OR_HIGHER = 5; const int FW_MAX_DAMAGERESIST_HP_CR_41_OR_HIGHER = 50;

// * ITEM_PROPERTY_DAMAGE_VULNERABILITY
// There is no switch to control damage vulnerability amounts. To disallow
// certain amounts you have to comment out the case statements inside the
// function FW_Choose_IP_Damage_Vulnerability ();

// ABILITY_PENALTY
// The minimum and maximum ABILITY_PENALTY values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,10
const int FW_MIN_ABILITY_PENALTY_CR_0 = 1; const int FW_MAX_ABILITY_PENALTY_CR_0 = 10;

const int FW_MIN_ABILITY_PENALTY_CR_1 = 1; const int FW_MAX_ABILITY_PENALTY_CR_1 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_2 = 1; const int FW_MAX_ABILITY_PENALTY_CR_2 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_3 = 1; const int FW_MAX_ABILITY_PENALTY_CR_3 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_4 = 1; const int FW_MAX_ABILITY_PENALTY_CR_4 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_5 = 1; const int FW_MAX_ABILITY_PENALTY_CR_5 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_6 = 1; const int FW_MAX_ABILITY_PENALTY_CR_6 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_7 = 1; const int FW_MAX_ABILITY_PENALTY_CR_7 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_8 = 1; const int FW_MAX_ABILITY_PENALTY_CR_8 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_9 = 1; const int FW_MAX_ABILITY_PENALTY_CR_9 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_10 = 1; const int FW_MAX_ABILITY_PENALTY_CR_10 = 10;

const int FW_MIN_ABILITY_PENALTY_CR_11 = 1; const int FW_MAX_ABILITY_PENALTY_CR_11 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_12 = 1; const int FW_MAX_ABILITY_PENALTY_CR_12 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_13 = 1; const int FW_MAX_ABILITY_PENALTY_CR_13 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_14 = 1; const int FW_MAX_ABILITY_PENALTY_CR_14 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_15 = 1; const int FW_MAX_ABILITY_PENALTY_CR_15 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_16 = 1; const int FW_MAX_ABILITY_PENALTY_CR_16 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_17 = 1; const int FW_MAX_ABILITY_PENALTY_CR_17 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_18 = 1; const int FW_MAX_ABILITY_PENALTY_CR_18 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_19 = 1; const int FW_MAX_ABILITY_PENALTY_CR_19 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_20 = 1; const int FW_MAX_ABILITY_PENALTY_CR_20 = 10;

const int FW_MIN_ABILITY_PENALTY_CR_21 = 1; const int FW_MAX_ABILITY_PENALTY_CR_21 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_22 = 1; const int FW_MAX_ABILITY_PENALTY_CR_22 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_23 = 1; const int FW_MAX_ABILITY_PENALTY_CR_23 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_24 = 1; const int FW_MAX_ABILITY_PENALTY_CR_24 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_25 = 1; const int FW_MAX_ABILITY_PENALTY_CR_25 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_26 = 1; const int FW_MAX_ABILITY_PENALTY_CR_26 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_27 = 1; const int FW_MAX_ABILITY_PENALTY_CR_27 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_28 = 1; const int FW_MAX_ABILITY_PENALTY_CR_28 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_29 = 1; const int FW_MAX_ABILITY_PENALTY_CR_29 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_30 = 1; const int FW_MAX_ABILITY_PENALTY_CR_30 = 10;

const int FW_MIN_ABILITY_PENALTY_CR_31 = 1; const int FW_MAX_ABILITY_PENALTY_CR_31 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_32 = 1; const int FW_MAX_ABILITY_PENALTY_CR_32 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_33 = 1; const int FW_MAX_ABILITY_PENALTY_CR_33 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_34 = 1; const int FW_MAX_ABILITY_PENALTY_CR_34 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_35 = 1; const int FW_MAX_ABILITY_PENALTY_CR_35 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_36 = 1; const int FW_MAX_ABILITY_PENALTY_CR_36 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_37 = 1; const int FW_MAX_ABILITY_PENALTY_CR_37 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_38 = 1; const int FW_MAX_ABILITY_PENALTY_CR_38 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_39 = 1; const int FW_MAX_ABILITY_PENALTY_CR_39 = 10;
const int FW_MIN_ABILITY_PENALTY_CR_40 = 1; const int FW_MAX_ABILITY_PENALTY_CR_40 = 10;

const int FW_MIN_ABILITY_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_ABILITY_PENALTY_CR_41_OR_HIGHER = 10;

// AC_PENALTY
// The minimum and maximum AC_PENALTY values an item could have (for each CR level).
// Acceptable values: 1 to 5.  Yes 5.
const int FW_MIN_AC_PENALTY_CR_0 = 1; const int FW_MAX_AC_PENALTY_CR_0 = 5;

const int FW_MIN_AC_PENALTY_CR_1 = 1; const int FW_MAX_AC_PENALTY_CR_1 = 5;
const int FW_MIN_AC_PENALTY_CR_2 = 1; const int FW_MAX_AC_PENALTY_CR_2 = 5;
const int FW_MIN_AC_PENALTY_CR_3 = 1; const int FW_MAX_AC_PENALTY_CR_3 = 5;
const int FW_MIN_AC_PENALTY_CR_4 = 1; const int FW_MAX_AC_PENALTY_CR_4 = 5;
const int FW_MIN_AC_PENALTY_CR_5 = 1; const int FW_MAX_AC_PENALTY_CR_5 = 5;
const int FW_MIN_AC_PENALTY_CR_6 = 1; const int FW_MAX_AC_PENALTY_CR_6 = 5;
const int FW_MIN_AC_PENALTY_CR_7 = 1; const int FW_MAX_AC_PENALTY_CR_7 = 5;
const int FW_MIN_AC_PENALTY_CR_8 = 1; const int FW_MAX_AC_PENALTY_CR_8 = 5;
const int FW_MIN_AC_PENALTY_CR_9 = 1; const int FW_MAX_AC_PENALTY_CR_9 = 5;
const int FW_MIN_AC_PENALTY_CR_10 = 1; const int FW_MAX_AC_PENALTY_CR_10 = 5;

const int FW_MIN_AC_PENALTY_CR_11 = 1; const int FW_MAX_AC_PENALTY_CR_11 = 5;
const int FW_MIN_AC_PENALTY_CR_12 = 1; const int FW_MAX_AC_PENALTY_CR_12 = 5;
const int FW_MIN_AC_PENALTY_CR_13 = 1; const int FW_MAX_AC_PENALTY_CR_13 = 5;
const int FW_MIN_AC_PENALTY_CR_14 = 1; const int FW_MAX_AC_PENALTY_CR_14 = 5;
const int FW_MIN_AC_PENALTY_CR_15 = 1; const int FW_MAX_AC_PENALTY_CR_15 = 5;
const int FW_MIN_AC_PENALTY_CR_16 = 1; const int FW_MAX_AC_PENALTY_CR_16 = 5;
const int FW_MIN_AC_PENALTY_CR_17 = 1; const int FW_MAX_AC_PENALTY_CR_17 = 5;
const int FW_MIN_AC_PENALTY_CR_18 = 1; const int FW_MAX_AC_PENALTY_CR_18 = 5;
const int FW_MIN_AC_PENALTY_CR_19 = 1; const int FW_MAX_AC_PENALTY_CR_19 = 5;
const int FW_MIN_AC_PENALTY_CR_20 = 1; const int FW_MAX_AC_PENALTY_CR_20 = 5;

const int FW_MIN_AC_PENALTY_CR_21 = 1; const int FW_MAX_AC_PENALTY_CR_21 = 5;
const int FW_MIN_AC_PENALTY_CR_22 = 1; const int FW_MAX_AC_PENALTY_CR_22 = 5;
const int FW_MIN_AC_PENALTY_CR_23 = 1; const int FW_MAX_AC_PENALTY_CR_23 = 5;
const int FW_MIN_AC_PENALTY_CR_24 = 1; const int FW_MAX_AC_PENALTY_CR_24 = 5;
const int FW_MIN_AC_PENALTY_CR_25 = 1; const int FW_MAX_AC_PENALTY_CR_25 = 5;
const int FW_MIN_AC_PENALTY_CR_26 = 1; const int FW_MAX_AC_PENALTY_CR_26 = 5;
const int FW_MIN_AC_PENALTY_CR_27 = 1; const int FW_MAX_AC_PENALTY_CR_27 = 5;
const int FW_MIN_AC_PENALTY_CR_28 = 1; const int FW_MAX_AC_PENALTY_CR_28 = 5;
const int FW_MIN_AC_PENALTY_CR_29 = 1; const int FW_MAX_AC_PENALTY_CR_29 = 5;
const int FW_MIN_AC_PENALTY_CR_30 = 1; const int FW_MAX_AC_PENALTY_CR_30 = 5;

const int FW_MIN_AC_PENALTY_CR_31 = 1; const int FW_MAX_AC_PENALTY_CR_31 = 5;
const int FW_MIN_AC_PENALTY_CR_32 = 1; const int FW_MAX_AC_PENALTY_CR_32 = 5;
const int FW_MIN_AC_PENALTY_CR_33 = 1; const int FW_MAX_AC_PENALTY_CR_33 = 5;
const int FW_MIN_AC_PENALTY_CR_34 = 1; const int FW_MAX_AC_PENALTY_CR_34 = 5;
const int FW_MIN_AC_PENALTY_CR_35 = 1; const int FW_MAX_AC_PENALTY_CR_35 = 5;
const int FW_MIN_AC_PENALTY_CR_36 = 1; const int FW_MAX_AC_PENALTY_CR_36 = 5;
const int FW_MIN_AC_PENALTY_CR_37 = 1; const int FW_MAX_AC_PENALTY_CR_37 = 5;
const int FW_MIN_AC_PENALTY_CR_38 = 1; const int FW_MAX_AC_PENALTY_CR_38 = 5;
const int FW_MIN_AC_PENALTY_CR_39 = 1; const int FW_MAX_AC_PENALTY_CR_39 = 5;
const int FW_MIN_AC_PENALTY_CR_40 = 1; const int FW_MAX_AC_PENALTY_CR_40 = 5;

const int FW_MIN_AC_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_AC_PENALTY_CR_41_OR_HIGHER = 5;

// SKILL_DECREASE
// The minimum and maximum SKILL_DECREASE values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,10
const int FW_MIN_SKILL_DECREASE_CR_0 = 1; const int FW_MAX_SKILL_DECREASE_CR_0 = 10;

const int FW_MIN_SKILL_DECREASE_CR_1 = 1; const int FW_MAX_SKILL_DECREASE_CR_1 = 10;
const int FW_MIN_SKILL_DECREASE_CR_2 = 1; const int FW_MAX_SKILL_DECREASE_CR_2 = 10;
const int FW_MIN_SKILL_DECREASE_CR_3 = 1; const int FW_MAX_SKILL_DECREASE_CR_3 = 10;
const int FW_MIN_SKILL_DECREASE_CR_4 = 1; const int FW_MAX_SKILL_DECREASE_CR_4 = 10;
const int FW_MIN_SKILL_DECREASE_CR_5 = 1; const int FW_MAX_SKILL_DECREASE_CR_5 = 10;
const int FW_MIN_SKILL_DECREASE_CR_6 = 1; const int FW_MAX_SKILL_DECREASE_CR_6 = 10;
const int FW_MIN_SKILL_DECREASE_CR_7 = 1; const int FW_MAX_SKILL_DECREASE_CR_7 = 10;
const int FW_MIN_SKILL_DECREASE_CR_8 = 1; const int FW_MAX_SKILL_DECREASE_CR_8 = 10;
const int FW_MIN_SKILL_DECREASE_CR_9 = 1; const int FW_MAX_SKILL_DECREASE_CR_9 = 10;
const int FW_MIN_SKILL_DECREASE_CR_10 = 1; const int FW_MAX_SKILL_DECREASE_CR_10 = 10;

const int FW_MIN_SKILL_DECREASE_CR_11 = 1; const int FW_MAX_SKILL_DECREASE_CR_11 = 10;
const int FW_MIN_SKILL_DECREASE_CR_12 = 1; const int FW_MAX_SKILL_DECREASE_CR_12 = 10;
const int FW_MIN_SKILL_DECREASE_CR_13 = 1; const int FW_MAX_SKILL_DECREASE_CR_13 = 10;
const int FW_MIN_SKILL_DECREASE_CR_14 = 1; const int FW_MAX_SKILL_DECREASE_CR_14 = 10;
const int FW_MIN_SKILL_DECREASE_CR_15 = 1; const int FW_MAX_SKILL_DECREASE_CR_15 = 10;
const int FW_MIN_SKILL_DECREASE_CR_16 = 1; const int FW_MAX_SKILL_DECREASE_CR_16 = 10;
const int FW_MIN_SKILL_DECREASE_CR_17 = 1; const int FW_MAX_SKILL_DECREASE_CR_17 = 10;
const int FW_MIN_SKILL_DECREASE_CR_18 = 1; const int FW_MAX_SKILL_DECREASE_CR_18 = 10;
const int FW_MIN_SKILL_DECREASE_CR_19 = 1; const int FW_MAX_SKILL_DECREASE_CR_19 = 10;
const int FW_MIN_SKILL_DECREASE_CR_20 = 1; const int FW_MAX_SKILL_DECREASE_CR_20 = 10;

const int FW_MIN_SKILL_DECREASE_CR_21 = 1; const int FW_MAX_SKILL_DECREASE_CR_21 = 10;
const int FW_MIN_SKILL_DECREASE_CR_22 = 1; const int FW_MAX_SKILL_DECREASE_CR_22 = 10;
const int FW_MIN_SKILL_DECREASE_CR_23 = 1; const int FW_MAX_SKILL_DECREASE_CR_23 = 10;
const int FW_MIN_SKILL_DECREASE_CR_24 = 1; const int FW_MAX_SKILL_DECREASE_CR_24 = 10;
const int FW_MIN_SKILL_DECREASE_CR_25 = 1; const int FW_MAX_SKILL_DECREASE_CR_25 = 10;
const int FW_MIN_SKILL_DECREASE_CR_26 = 1; const int FW_MAX_SKILL_DECREASE_CR_26 = 10;
const int FW_MIN_SKILL_DECREASE_CR_27 = 1; const int FW_MAX_SKILL_DECREASE_CR_27 = 10;
const int FW_MIN_SKILL_DECREASE_CR_28 = 1; const int FW_MAX_SKILL_DECREASE_CR_28 = 10;
const int FW_MIN_SKILL_DECREASE_CR_29 = 1; const int FW_MAX_SKILL_DECREASE_CR_29 = 10;
const int FW_MIN_SKILL_DECREASE_CR_30 = 1; const int FW_MAX_SKILL_DECREASE_CR_30 = 10;

const int FW_MIN_SKILL_DECREASE_CR_31 = 1; const int FW_MAX_SKILL_DECREASE_CR_31 = 10;
const int FW_MIN_SKILL_DECREASE_CR_32 = 1; const int FW_MAX_SKILL_DECREASE_CR_32 = 10;
const int FW_MIN_SKILL_DECREASE_CR_33 = 1; const int FW_MAX_SKILL_DECREASE_CR_33 = 10;
const int FW_MIN_SKILL_DECREASE_CR_34 = 1; const int FW_MAX_SKILL_DECREASE_CR_34 = 10;
const int FW_MIN_SKILL_DECREASE_CR_35 = 1; const int FW_MAX_SKILL_DECREASE_CR_35 = 10;
const int FW_MIN_SKILL_DECREASE_CR_36 = 1; const int FW_MAX_SKILL_DECREASE_CR_36 = 10;
const int FW_MIN_SKILL_DECREASE_CR_37 = 1; const int FW_MAX_SKILL_DECREASE_CR_37 = 10;
const int FW_MIN_SKILL_DECREASE_CR_38 = 1; const int FW_MAX_SKILL_DECREASE_CR_38 = 10;
const int FW_MIN_SKILL_DECREASE_CR_39 = 1; const int FW_MAX_SKILL_DECREASE_CR_39 = 10;
const int FW_MIN_SKILL_DECREASE_CR_40 = 1; const int FW_MAX_SKILL_DECREASE_CR_40 = 10;

const int FW_MIN_SKILL_DECREASE_CR_41_OR_HIGHER = 1; const int FW_MAX_SKILL_DECREASE_CR_41_OR_HIGHER = 10;

// ENHANCEMENT_BONUS
// The minimum and maximum ENHANCEMENT_BONUS values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ENHANCEMENT_BONUS_CR_0 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_0 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_CR_1 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_1 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_2 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_2 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_3 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_3 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_4 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_4 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_5 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_5 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_6 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_6 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_7 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_7 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_8 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_8 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_9 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_9 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_10 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_10 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_CR_11 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_11 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_12 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_12 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_13 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_13 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_14 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_14 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_15 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_15 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_16 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_16 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_17 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_17 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_18 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_18 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_19 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_19 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_20 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_20 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_CR_21 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_21 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_22 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_22 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_23 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_23 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_24 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_24 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_25 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_25 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_26 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_26 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_27 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_27 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_28 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_28 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_29 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_29 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_30 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_30 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_CR_31 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_31 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_32 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_32 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_33 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_33 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_34 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_34 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_35 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_35 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_36 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_36 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_37 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_37 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_38 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_38 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_39 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_39 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_CR_40 = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_40 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_ENHANCEMENT_BONUS_CR_41_OR_HIGHER = 20;

// ENHANCEMENT_BONUS_VS_ALIGN
// The minimum and maximum ENHANCEMENT_BONUS_VS_ALIGN GROUP values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_0 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_0 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_1 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_1 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_2 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_2 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_3 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_3 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_4 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_4 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_5 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_5 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_6 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_6 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_7 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_7 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_8 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_8 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_9 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_9 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_10 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_10 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_11 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_11 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_12 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_12 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_13 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_13 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_14 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_14 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_15 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_15 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_16 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_16 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_17 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_17 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_18 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_18 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_19 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_19 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_20 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_20 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_21 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_21 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_22 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_22 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_23 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_23 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_24 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_24 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_25 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_25 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_26 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_26 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_27 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_27 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_28 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_28 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_29 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_29 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_30 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_30 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_31 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_31 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_32 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_32 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_33 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_33 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_34 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_34 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_35 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_35 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_36 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_36 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_37 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_37 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_38 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_38 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_39 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_39 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_40 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_40 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_41_OR_HIGHER = 20;

// ENHANCEMENT_BONUS_VS_RACE
// The minimum and maximum ENHANCEMENT_BONUS_VS_RACE values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_0 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_0 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_1 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_1 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_2 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_2 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_3 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_3 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_4 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_4 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_5 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_5 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_6 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_6 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_7 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_7 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_8 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_8 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_9 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_9 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_10 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_10 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_11 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_11 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_12 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_12 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_13 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_13 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_14 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_14 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_15 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_15 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_16 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_16 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_17 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_17 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_18 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_18 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_19 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_19 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_20 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_20 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_21 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_21 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_22 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_22 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_23 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_23 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_24 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_24 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_25 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_25 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_26 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_26 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_27 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_27 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_28 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_28 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_29 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_29 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_30 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_30 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_31 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_31 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_32 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_32 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_33 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_33 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_34 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_34 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_35 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_35 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_36 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_36 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_37 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_37 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_38 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_38 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_39 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_39 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_40 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_40 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_41_OR_HIGHER = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_41_OR_HIGHER = 20;

// ENHANCEMENT_BONUS_VS_SALIGN
// The minimum and maximum ENHANCEMENT_BONUS_VS_SALIGN values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_0 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_0 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_1 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_1 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_2 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_2 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_3 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_3 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_4 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_4 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_5 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_5 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_6 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_6 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_7 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_7 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_8 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_8 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_9 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_9 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_10 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_10 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_11 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_11 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_12 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_12 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_13 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_13 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_14 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_14 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_15 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_15 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_16 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_16 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_17 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_17 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_18 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_18 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_19 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_19 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_20 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_20 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_21 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_21 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_22 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_22 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_23 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_23 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_24 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_24 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_25 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_25 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_26 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_26 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_27 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_27 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_28 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_28 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_29 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_29 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_30 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_30 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_31 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_31 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_32 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_32 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_33 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_33 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_34 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_34 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_35 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_35 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_36 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_36 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_37 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_37 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_38 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_38 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_39 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_39 = 20;
const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_40 = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_40 = 20;

const int FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 1; const int FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_41_OR_HIGHER = 20;

// ENHANCEMENT_PENALTY
// The minimum and maximum ENHANCEMENT_PENALTY values an item could have
// (for each CR level).
// Acceptable values: 1 TO 5.
const int FW_MIN_ENHANCEMENT_PENALTY_CR_0 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_0 = 5;

const int FW_MIN_ENHANCEMENT_PENALTY_CR_1 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_1 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_2 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_2 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_3 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_3 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_4 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_4 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_5 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_5 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_6 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_6 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_7 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_7 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_8 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_8 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_9 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_9 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_10 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_10 = 5;

const int FW_MIN_ENHANCEMENT_PENALTY_CR_11 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_11 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_12 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_12 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_13 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_13 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_14 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_14 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_15 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_15 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_16 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_16 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_17 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_17 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_18 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_18 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_19 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_19 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_20 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_20 = 5;

const int FW_MIN_ENHANCEMENT_PENALTY_CR_21 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_21 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_22 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_22 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_23 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_23 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_24 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_24 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_25 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_25 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_26 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_26 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_27 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_27 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_28 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_28 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_29 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_29 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_30 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_30 = 5;

const int FW_MIN_ENHANCEMENT_PENALTY_CR_31 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_31 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_32 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_32 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_33 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_33 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_34 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_34 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_35 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_35 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_36 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_36 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_37 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_37 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_38 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_38 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_39 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_39 = 5;
const int FW_MIN_ENHANCEMENT_PENALTY_CR_40 = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_40 = 5;

const int FW_MIN_ENHANCEMENT_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_ENHANCEMENT_PENALTY_CR_41_OR_HIGHER = 5;

// * ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE
// There is no min/max switch. Edit the function: FW_Choose_IP_Extra_Melee_Damage_Type()
// if you want to change anything.

// * ITEM_PROPERTY_EXTRA_RANGE_DAMAGE_TYPE
// There is no switch. Edit the function: FW_Choose_IP_Extra_Range_Damage_Type
// if you want to change anything.

// HEALER_KIT
// The minimum and maximum HEALER_KIT values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,12
const int FW_MIN_HEALER_KIT_CR_0 = 1; const int FW_MAX_HEALER_KIT_CR_0 = 12;

const int FW_MIN_HEALER_KIT_CR_1 = 1; const int FW_MAX_HEALER_KIT_CR_1 = 12;
const int FW_MIN_HEALER_KIT_CR_2 = 1; const int FW_MAX_HEALER_KIT_CR_2 = 12;
const int FW_MIN_HEALER_KIT_CR_3 = 1; const int FW_MAX_HEALER_KIT_CR_3 = 12;
const int FW_MIN_HEALER_KIT_CR_4 = 1; const int FW_MAX_HEALER_KIT_CR_4 = 12;
const int FW_MIN_HEALER_KIT_CR_5 = 1; const int FW_MAX_HEALER_KIT_CR_5 = 12;
const int FW_MIN_HEALER_KIT_CR_6 = 1; const int FW_MAX_HEALER_KIT_CR_6 = 12;
const int FW_MIN_HEALER_KIT_CR_7 = 1; const int FW_MAX_HEALER_KIT_CR_7 = 12;
const int FW_MIN_HEALER_KIT_CR_8 = 1; const int FW_MAX_HEALER_KIT_CR_8 = 12;
const int FW_MIN_HEALER_KIT_CR_9 = 1; const int FW_MAX_HEALER_KIT_CR_9 = 12;
const int FW_MIN_HEALER_KIT_CR_10 = 1; const int FW_MAX_HEALER_KIT_CR_10 = 12;

const int FW_MIN_HEALER_KIT_CR_11 = 1; const int FW_MAX_HEALER_KIT_CR_11 = 12;
const int FW_MIN_HEALER_KIT_CR_12 = 1; const int FW_MAX_HEALER_KIT_CR_12 = 12;
const int FW_MIN_HEALER_KIT_CR_13 = 1; const int FW_MAX_HEALER_KIT_CR_13 = 12;
const int FW_MIN_HEALER_KIT_CR_14 = 1; const int FW_MAX_HEALER_KIT_CR_14 = 12;
const int FW_MIN_HEALER_KIT_CR_15 = 1; const int FW_MAX_HEALER_KIT_CR_15 = 12;
const int FW_MIN_HEALER_KIT_CR_16 = 1; const int FW_MAX_HEALER_KIT_CR_16 = 12;
const int FW_MIN_HEALER_KIT_CR_17 = 1; const int FW_MAX_HEALER_KIT_CR_17 = 12;
const int FW_MIN_HEALER_KIT_CR_18 = 1; const int FW_MAX_HEALER_KIT_CR_18 = 12;
const int FW_MIN_HEALER_KIT_CR_19 = 1; const int FW_MAX_HEALER_KIT_CR_19 = 12;
const int FW_MIN_HEALER_KIT_CR_20 = 1; const int FW_MAX_HEALER_KIT_CR_20 = 12;

const int FW_MIN_HEALER_KIT_CR_21 = 1; const int FW_MAX_HEALER_KIT_CR_21 = 12;
const int FW_MIN_HEALER_KIT_CR_22 = 1; const int FW_MAX_HEALER_KIT_CR_22 = 12;
const int FW_MIN_HEALER_KIT_CR_23 = 1; const int FW_MAX_HEALER_KIT_CR_23 = 12;
const int FW_MIN_HEALER_KIT_CR_24 = 1; const int FW_MAX_HEALER_KIT_CR_24 = 12;
const int FW_MIN_HEALER_KIT_CR_25 = 1; const int FW_MAX_HEALER_KIT_CR_25 = 12;
const int FW_MIN_HEALER_KIT_CR_26 = 1; const int FW_MAX_HEALER_KIT_CR_26 = 12;
const int FW_MIN_HEALER_KIT_CR_27 = 1; const int FW_MAX_HEALER_KIT_CR_27 = 12;
const int FW_MIN_HEALER_KIT_CR_28 = 1; const int FW_MAX_HEALER_KIT_CR_28 = 12;
const int FW_MIN_HEALER_KIT_CR_29 = 1; const int FW_MAX_HEALER_KIT_CR_29 = 12;
const int FW_MIN_HEALER_KIT_CR_30 = 1; const int FW_MAX_HEALER_KIT_CR_30 = 12;

const int FW_MIN_HEALER_KIT_CR_31 = 1; const int FW_MAX_HEALER_KIT_CR_31 = 12;
const int FW_MIN_HEALER_KIT_CR_32 = 1; const int FW_MAX_HEALER_KIT_CR_32 = 12;
const int FW_MIN_HEALER_KIT_CR_33 = 1; const int FW_MAX_HEALER_KIT_CR_33 = 12;
const int FW_MIN_HEALER_KIT_CR_34 = 1; const int FW_MAX_HEALER_KIT_CR_34 = 12;
const int FW_MIN_HEALER_KIT_CR_35 = 1; const int FW_MAX_HEALER_KIT_CR_35 = 12;
const int FW_MIN_HEALER_KIT_CR_36 = 1; const int FW_MAX_HEALER_KIT_CR_36 = 12;
const int FW_MIN_HEALER_KIT_CR_37 = 1; const int FW_MAX_HEALER_KIT_CR_37 = 12;
const int FW_MIN_HEALER_KIT_CR_38 = 1; const int FW_MAX_HEALER_KIT_CR_38 = 12;
const int FW_MIN_HEALER_KIT_CR_39 = 1; const int FW_MAX_HEALER_KIT_CR_39 = 12;
const int FW_MIN_HEALER_KIT_CR_40 = 1; const int FW_MAX_HEALER_KIT_CR_40 = 12;

const int FW_MIN_HEALER_KIT_CR_41_OR_HIGHER = 1; const int FW_MAX_HEALER_KIT_CR_41_OR_HIGHER = 12;

// * ITEM_PROPERTY_IMMUNITY_MISC
// If you want to disallow ALL immunities from appearing on an item change the 
// above statement to FALSE. 
// If you want to exclude SOME, but not all then comment out the unwanted 
// immunity(s) inside the function: FW_Choose_IP_Immunity_Misc and leave the above 
// set to TRUE.

// IMMUNITY_TO_SPELL_LEVEL
// The minimum and maximum IMMUNITY_TO_SPELL_LEVEL values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,9
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_0 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_0 = 9;

const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_1 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_1 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_2 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_2 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_3 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_3 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_4 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_4 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_5 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_5 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_6 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_6 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_7 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_7 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_8 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_8 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_9 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_9 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_10 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_10 = 9;

const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_11 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_11 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_12 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_12 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_13 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_13 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_14 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_14 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_15 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_15 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_16 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_16 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_17 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_17 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_18 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_18 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_19 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_19 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_20 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_20 = 9;

const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_21 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_21 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_22 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_22 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_23 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_23 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_24 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_24 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_25 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_25 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_26 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_26 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_27 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_27 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_28 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_28 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_29 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_29 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_30 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_30 = 9;

const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_31 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_31 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_32 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_32 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_33 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_33 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_34 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_34 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_35 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_35 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_36 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_36 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_37 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_37 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_38 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_38 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_39 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_39 = 9;
const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_40 = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_40 = 9;

const int FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_41_OR_HIGHER = 1; const int FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_41_OR_HIGHER = 9;

// * ITEM_PROPERTY_LIGHT
// There is no switch to control the brightness or color of light that could be
// added to an item.  To disallow a light brightness or color, comment out the
// case statements inside function: FW_Choose_IP_Light ();

// * ITEM_PROPERTY_LIMIT_USE_BY_ALIGN
// * ITEM_PROPERTY_LIMIT_USE_BY_CLASS
// * ITEM_PROPERTY_LIMIT_USE_BY_RACE
// * ITEM_PROPERTY_LIMIT_USE_BY_SALIGN
// There is no switch to control specifics of the four item properties above.  I can't see
// why someone would want to allow some limitations but not others.  If you want
// to disallow specifics, then go edit the functions: FW_Choose_IP_Limit_Use_By_*

// MIGHTY_BONUS
// The minimum and maximum MIGHTY_BONUS values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_MIGHTY_BONUS_CR_0 = 1; const int FW_MAX_MIGHTY_BONUS_CR_0 = 20;

const int FW_MIN_MIGHTY_BONUS_CR_1 = 1; const int FW_MAX_MIGHTY_BONUS_CR_1 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_2 = 1; const int FW_MAX_MIGHTY_BONUS_CR_2 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_3 = 1; const int FW_MAX_MIGHTY_BONUS_CR_3 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_4 = 1; const int FW_MAX_MIGHTY_BONUS_CR_4 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_5 = 1; const int FW_MAX_MIGHTY_BONUS_CR_5 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_6 = 1; const int FW_MAX_MIGHTY_BONUS_CR_6 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_7 = 1; const int FW_MAX_MIGHTY_BONUS_CR_7 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_8 = 1; const int FW_MAX_MIGHTY_BONUS_CR_8 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_9 = 1; const int FW_MAX_MIGHTY_BONUS_CR_9 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_10 = 1; const int FW_MAX_MIGHTY_BONUS_CR_10 = 20;

const int FW_MIN_MIGHTY_BONUS_CR_11 = 1; const int FW_MAX_MIGHTY_BONUS_CR_11 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_12 = 1; const int FW_MAX_MIGHTY_BONUS_CR_12 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_13 = 1; const int FW_MAX_MIGHTY_BONUS_CR_13 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_14 = 1; const int FW_MAX_MIGHTY_BONUS_CR_14 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_15 = 1; const int FW_MAX_MIGHTY_BONUS_CR_15 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_16 = 1; const int FW_MAX_MIGHTY_BONUS_CR_16 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_17 = 1; const int FW_MAX_MIGHTY_BONUS_CR_17 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_18 = 1; const int FW_MAX_MIGHTY_BONUS_CR_18 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_19 = 1; const int FW_MAX_MIGHTY_BONUS_CR_19 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_20 = 1; const int FW_MAX_MIGHTY_BONUS_CR_20 = 20;

const int FW_MIN_MIGHTY_BONUS_CR_21 = 1; const int FW_MAX_MIGHTY_BONUS_CR_21 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_22 = 1; const int FW_MAX_MIGHTY_BONUS_CR_22 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_23 = 1; const int FW_MAX_MIGHTY_BONUS_CR_23 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_24 = 1; const int FW_MAX_MIGHTY_BONUS_CR_24 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_25 = 1; const int FW_MAX_MIGHTY_BONUS_CR_25 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_26 = 1; const int FW_MAX_MIGHTY_BONUS_CR_26 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_27 = 1; const int FW_MAX_MIGHTY_BONUS_CR_27 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_28 = 1; const int FW_MAX_MIGHTY_BONUS_CR_28 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_29 = 1; const int FW_MAX_MIGHTY_BONUS_CR_29 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_30 = 1; const int FW_MAX_MIGHTY_BONUS_CR_30 = 20;

const int FW_MIN_MIGHTY_BONUS_CR_31 = 1; const int FW_MAX_MIGHTY_BONUS_CR_31 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_32 = 1; const int FW_MAX_MIGHTY_BONUS_CR_32 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_33 = 1; const int FW_MAX_MIGHTY_BONUS_CR_33 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_34 = 1; const int FW_MAX_MIGHTY_BONUS_CR_34 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_35 = 1; const int FW_MAX_MIGHTY_BONUS_CR_35 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_36 = 1; const int FW_MAX_MIGHTY_BONUS_CR_36 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_37 = 1; const int FW_MAX_MIGHTY_BONUS_CR_37 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_38 = 1; const int FW_MAX_MIGHTY_BONUS_CR_38 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_39 = 1; const int FW_MAX_MIGHTY_BONUS_CR_39 = 20;
const int FW_MIN_MIGHTY_BONUS_CR_40 = 1; const int FW_MAX_MIGHTY_BONUS_CR_40 = 20;

const int FW_MIN_MIGHTY_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_MIGHTY_BONUS_CR_41_OR_HIGHER = 20;

// * ITEM_PROPERTY_ON_HIT_CAST_SPELL
// I saw no easy way to have a switch to allow/disallow certain spells from the
// item property OnHitCastSpell.  By default the function that chooses the prop.
// OnHitCastSpell will choose from every single spell available (there are lots)
// If you want to disallow certain spells from being added to an item, then you
// need to go into the function: FW_Choose_IP_On_Hit_Cast_Spell and comment out
// the case statements for the spells you don't want to be included. 

// ON_HIT_SPELL_LEVEL
// This is in conjunction with On Hit Cast Spell.  It must be determined what spell level
// your on hit spell is cast at (for things like breaking down spell mantles, etc). You could 
// allow on hit cast spells, but limit the level here if you wanted. If you disallowed on hit
// cast spell entirely in the file "fw_inc_switches" then it doesn't matter what these values are.
// The minimum and maximum ON_HIT_SPELL_LEVEL values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,9
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_0 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_0 = 9;

const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_1 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_1 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_2 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_2 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_3 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_3 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_4 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_4 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_5 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_5 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_6 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_6 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_7 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_7 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_8 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_8 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_9 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_9 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_10 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_10 = 9;

const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_11 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_11 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_12 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_12 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_13 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_13 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_14 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_14 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_15 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_15 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_16 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_16 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_17 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_17 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_18 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_18 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_19 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_19 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_20 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_20 = 9;

const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_21 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_21 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_22 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_22 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_23 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_23 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_24 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_24 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_25 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_25 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_26 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_26 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_27 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_27 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_28 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_28 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_29 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_29 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_30 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_30 = 9;

const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_31 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_31 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_32 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_32 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_33 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_33 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_34 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_34 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_35 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_35 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_36 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_36 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_37 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_37 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_38 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_38 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_39 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_39 = 9;
const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_40 = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_40 = 9;

const int FW_MIN_ON_HIT_SPELL_LEVEL_CR_41_OR_HIGHER = 1; const int FW_MAX_ON_HIT_SPELL_LEVEL_CR_41_OR_HIGHER = 9; 

// * ITEM_PROPERTY_ON_HIT_PROPS
// Same description basically as on hit cast spell.  Either comment out specifics
// inside the function: FW_Choose_IP_On_Hit_Props or change to FALSE to exclude 
// everything.

// ON_HIT_SAVE_DC
// This goes in conjunction with On Hit Props. Some of the onhitprops have save DC components.
// If you disallowed on hit props entirley, then these values don't matter.
// The minimum and maximum ON_HIT_SAVE_DC values an item could have
// (for each CR level).
// Acceptable values: 14,16,18,20,22,24, or 26.  Nothing else.
const int FW_MIN_ON_HIT_SAVE_DC_CR_0 = 1; const int FW_MAX_ON_HIT_SAVE_DC_CR_0 = 26;

const int FW_MIN_ON_HIT_SAVE_DC_CR_1 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_1 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_2 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_2 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_3 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_3 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_4 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_4 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_5 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_5 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_6 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_6 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_7 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_7 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_8 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_8 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_9 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_9 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_10 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_10 = 26;

const int FW_MIN_ON_HIT_SAVE_DC_CR_11 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_11 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_12 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_12 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_13 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_13 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_14 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_14 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_15 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_15 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_16 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_16 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_17 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_17 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_18 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_18 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_19 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_19 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_20 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_20 = 26;

const int FW_MIN_ON_HIT_SAVE_DC_CR_21 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_21 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_22 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_22 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_23 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_23 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_24 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_24 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_25 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_25 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_26 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_26 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_27 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_27 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_28 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_28 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_29 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_29 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_30 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_30 = 26;

const int FW_MIN_ON_HIT_SAVE_DC_CR_31 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_31 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_32 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_32 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_33 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_33 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_34 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_34 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_35 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_35 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_36 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_36 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_37 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_37 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_38 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_38 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_39 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_39 = 26;
const int FW_MIN_ON_HIT_SAVE_DC_CR_40 = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_40 = 26;

const int FW_MIN_ON_HIT_SAVE_DC_CR_41_OR_HIGHER = 14; const int FW_MAX_ON_HIT_SAVE_DC_CR_41_OR_HIGHER = 26;

// SAVING_THROW_PENALTY
// The minimum and maximum SAVING_THROW_PENALTY values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_SAVING_THROW_PENALTY_CR_0 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_0 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_CR_1 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_1 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_2 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_2 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_3 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_3 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_4 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_4 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_5 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_5 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_6 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_6 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_7 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_7 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_8 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_8 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_9 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_9 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_10 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_10 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_CR_11 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_11 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_12 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_12 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_13 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_13 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_14 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_14 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_15 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_15 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_16 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_16 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_17 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_17 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_18 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_18 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_19 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_19 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_20 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_20 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_CR_21 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_21 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_22 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_22 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_23 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_23 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_24 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_24 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_25 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_25 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_26 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_26 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_27 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_27 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_28 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_28 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_29 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_29 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_30 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_30 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_CR_31 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_31 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_32 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_32 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_33 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_33 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_34 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_34 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_35 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_35 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_36 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_36 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_37 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_37 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_38 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_38 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_39 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_39 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_CR_40 = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_40 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_CR_41_OR_HIGHER = 1; const int FW_MAX_SAVING_THROW_PENALTY_CR_41_OR_HIGHER = 20;

// SAVING_THROW_PENALTY_VSX
// The minimum and maximum SAVING_THROW_PENALTY_VSX values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_0 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_0 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_1 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_1 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_2 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_2 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_3 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_3 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_4 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_4 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_5 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_5 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_6 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_6 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_7 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_7 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_8 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_8 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_9 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_9 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_10 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_10 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_11 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_11 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_12 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_12 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_13 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_13 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_14 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_14 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_15 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_15 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_16 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_16 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_17 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_17 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_18 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_18 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_19 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_19 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_20 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_20 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_21 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_21 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_22 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_22 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_23 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_23 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_24 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_24 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_25 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_25 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_26 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_26 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_27 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_27 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_28 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_28 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_29 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_29 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_30 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_30 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_31 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_31 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_32 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_32 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_33 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_33 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_34 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_34 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_35 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_35 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_36 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_36 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_37 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_37 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_38 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_38 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_39 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_39 = 20;
const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_40 = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_40 = 20;

const int FW_MIN_SAVING_THROW_PENALTY_VSX_CR_41_OR_HIGHER = 1; const int FW_MAX_SAVING_THROW_PENALTY_VSX_CR_41_OR_HIGHER = 20;

// REGENERATION
// The minimum and maximum REGENERATION values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_REGENERATION_CR_0 = 1; const int FW_MAX_REGENERATION_CR_0 = 20;

const int FW_MIN_REGENERATION_CR_1 = 1; const int FW_MAX_REGENERATION_CR_1 = 20;
const int FW_MIN_REGENERATION_CR_2 = 1; const int FW_MAX_REGENERATION_CR_2 = 20;
const int FW_MIN_REGENERATION_CR_3 = 1; const int FW_MAX_REGENERATION_CR_3 = 20;
const int FW_MIN_REGENERATION_CR_4 = 1; const int FW_MAX_REGENERATION_CR_4 = 20;
const int FW_MIN_REGENERATION_CR_5 = 1; const int FW_MAX_REGENERATION_CR_5 = 20;
const int FW_MIN_REGENERATION_CR_6 = 1; const int FW_MAX_REGENERATION_CR_6 = 20;
const int FW_MIN_REGENERATION_CR_7 = 1; const int FW_MAX_REGENERATION_CR_7 = 20;
const int FW_MIN_REGENERATION_CR_8 = 1; const int FW_MAX_REGENERATION_CR_8 = 20;
const int FW_MIN_REGENERATION_CR_9 = 1; const int FW_MAX_REGENERATION_CR_9 = 20;
const int FW_MIN_REGENERATION_CR_10 = 1; const int FW_MAX_REGENERATION_CR_10 = 20;

const int FW_MIN_REGENERATION_CR_11 = 1; const int FW_MAX_REGENERATION_CR_11 = 20;
const int FW_MIN_REGENERATION_CR_12 = 1; const int FW_MAX_REGENERATION_CR_12 = 20;
const int FW_MIN_REGENERATION_CR_13 = 1; const int FW_MAX_REGENERATION_CR_13 = 20;
const int FW_MIN_REGENERATION_CR_14 = 1; const int FW_MAX_REGENERATION_CR_14 = 20;
const int FW_MIN_REGENERATION_CR_15 = 1; const int FW_MAX_REGENERATION_CR_15 = 20;
const int FW_MIN_REGENERATION_CR_16 = 1; const int FW_MAX_REGENERATION_CR_16 = 20;
const int FW_MIN_REGENERATION_CR_17 = 1; const int FW_MAX_REGENERATION_CR_17 = 20;
const int FW_MIN_REGENERATION_CR_18 = 1; const int FW_MAX_REGENERATION_CR_18 = 20;
const int FW_MIN_REGENERATION_CR_19 = 1; const int FW_MAX_REGENERATION_CR_19 = 20;
const int FW_MIN_REGENERATION_CR_20 = 1; const int FW_MAX_REGENERATION_CR_20 = 20;

const int FW_MIN_REGENERATION_CR_21 = 1; const int FW_MAX_REGENERATION_CR_21 = 20;
const int FW_MIN_REGENERATION_CR_22 = 1; const int FW_MAX_REGENERATION_CR_22 = 20;
const int FW_MIN_REGENERATION_CR_23 = 1; const int FW_MAX_REGENERATION_CR_23 = 20;
const int FW_MIN_REGENERATION_CR_24 = 1; const int FW_MAX_REGENERATION_CR_24 = 20;
const int FW_MIN_REGENERATION_CR_25 = 1; const int FW_MAX_REGENERATION_CR_25 = 20;
const int FW_MIN_REGENERATION_CR_26 = 1; const int FW_MAX_REGENERATION_CR_26 = 20;
const int FW_MIN_REGENERATION_CR_27 = 1; const int FW_MAX_REGENERATION_CR_27 = 20;
const int FW_MIN_REGENERATION_CR_28 = 1; const int FW_MAX_REGENERATION_CR_28 = 20;
const int FW_MIN_REGENERATION_CR_29 = 1; const int FW_MAX_REGENERATION_CR_29 = 20;
const int FW_MIN_REGENERATION_CR_30 = 1; const int FW_MAX_REGENERATION_CR_30 = 20;

const int FW_MIN_REGENERATION_CR_31 = 1; const int FW_MAX_REGENERATION_CR_31 = 20;
const int FW_MIN_REGENERATION_CR_32 = 1; const int FW_MAX_REGENERATION_CR_32 = 20;
const int FW_MIN_REGENERATION_CR_33 = 1; const int FW_MAX_REGENERATION_CR_33 = 20;
const int FW_MIN_REGENERATION_CR_34 = 1; const int FW_MAX_REGENERATION_CR_34 = 20;
const int FW_MIN_REGENERATION_CR_35 = 1; const int FW_MAX_REGENERATION_CR_35 = 20;
const int FW_MIN_REGENERATION_CR_36 = 1; const int FW_MAX_REGENERATION_CR_36 = 20;
const int FW_MIN_REGENERATION_CR_37 = 1; const int FW_MAX_REGENERATION_CR_37 = 20;
const int FW_MIN_REGENERATION_CR_38 = 1; const int FW_MAX_REGENERATION_CR_38 = 20;
const int FW_MIN_REGENERATION_CR_39 = 1; const int FW_MAX_REGENERATION_CR_39 = 20;
const int FW_MIN_REGENERATION_CR_40 = 1; const int FW_MAX_REGENERATION_CR_40 = 20;

const int FW_MIN_REGENERATION_CR_41_OR_HIGHER = 1; const int FW_MAX_REGENERATION_CR_41_OR_HIGHER = 20;

// SKILL_BONUS
// The minimum and maximum SKILL_BONUS values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,50
const int FW_MIN_SKILL_BONUS_CR_0 = 1; const int FW_MAX_SKILL_BONUS_CR_0 = 50;

const int FW_MIN_SKILL_BONUS_CR_1 = 1; const int FW_MAX_SKILL_BONUS_CR_1 = 50;
const int FW_MIN_SKILL_BONUS_CR_2 = 1; const int FW_MAX_SKILL_BONUS_CR_2 = 50;
const int FW_MIN_SKILL_BONUS_CR_3 = 1; const int FW_MAX_SKILL_BONUS_CR_3 = 50;
const int FW_MIN_SKILL_BONUS_CR_4 = 1; const int FW_MAX_SKILL_BONUS_CR_4 = 50;
const int FW_MIN_SKILL_BONUS_CR_5 = 1; const int FW_MAX_SKILL_BONUS_CR_5 = 50;
const int FW_MIN_SKILL_BONUS_CR_6 = 1; const int FW_MAX_SKILL_BONUS_CR_6 = 50;
const int FW_MIN_SKILL_BONUS_CR_7 = 1; const int FW_MAX_SKILL_BONUS_CR_7 = 50;
const int FW_MIN_SKILL_BONUS_CR_8 = 1; const int FW_MAX_SKILL_BONUS_CR_8 = 50;
const int FW_MIN_SKILL_BONUS_CR_9 = 1; const int FW_MAX_SKILL_BONUS_CR_9 = 50;
const int FW_MIN_SKILL_BONUS_CR_10 = 1; const int FW_MAX_SKILL_BONUS_CR_10 = 50;

const int FW_MIN_SKILL_BONUS_CR_11 = 1; const int FW_MAX_SKILL_BONUS_CR_11 = 50;
const int FW_MIN_SKILL_BONUS_CR_12 = 1; const int FW_MAX_SKILL_BONUS_CR_12 = 50;
const int FW_MIN_SKILL_BONUS_CR_13 = 1; const int FW_MAX_SKILL_BONUS_CR_13 = 50;
const int FW_MIN_SKILL_BONUS_CR_14 = 1; const int FW_MAX_SKILL_BONUS_CR_14 = 50;
const int FW_MIN_SKILL_BONUS_CR_15 = 1; const int FW_MAX_SKILL_BONUS_CR_15 = 50;
const int FW_MIN_SKILL_BONUS_CR_16 = 1; const int FW_MAX_SKILL_BONUS_CR_16 = 50;
const int FW_MIN_SKILL_BONUS_CR_17 = 1; const int FW_MAX_SKILL_BONUS_CR_17 = 50;
const int FW_MIN_SKILL_BONUS_CR_18 = 1; const int FW_MAX_SKILL_BONUS_CR_18 = 50;
const int FW_MIN_SKILL_BONUS_CR_19 = 1; const int FW_MAX_SKILL_BONUS_CR_19 = 50;
const int FW_MIN_SKILL_BONUS_CR_20 = 1; const int FW_MAX_SKILL_BONUS_CR_20 = 50;

const int FW_MIN_SKILL_BONUS_CR_21 = 1; const int FW_MAX_SKILL_BONUS_CR_21 = 50;
const int FW_MIN_SKILL_BONUS_CR_22 = 1; const int FW_MAX_SKILL_BONUS_CR_22 = 50;
const int FW_MIN_SKILL_BONUS_CR_23 = 1; const int FW_MAX_SKILL_BONUS_CR_23 = 50;
const int FW_MIN_SKILL_BONUS_CR_24 = 1; const int FW_MAX_SKILL_BONUS_CR_24 = 50;
const int FW_MIN_SKILL_BONUS_CR_25 = 1; const int FW_MAX_SKILL_BONUS_CR_25 = 50;
const int FW_MIN_SKILL_BONUS_CR_26 = 1; const int FW_MAX_SKILL_BONUS_CR_26 = 50;
const int FW_MIN_SKILL_BONUS_CR_27 = 1; const int FW_MAX_SKILL_BONUS_CR_27 = 50;
const int FW_MIN_SKILL_BONUS_CR_28 = 1; const int FW_MAX_SKILL_BONUS_CR_28 = 50;
const int FW_MIN_SKILL_BONUS_CR_29 = 1; const int FW_MAX_SKILL_BONUS_CR_29 = 50;
const int FW_MIN_SKILL_BONUS_CR_30 = 1; const int FW_MAX_SKILL_BONUS_CR_30 = 50;

const int FW_MIN_SKILL_BONUS_CR_31 = 1; const int FW_MAX_SKILL_BONUS_CR_31 = 50;
const int FW_MIN_SKILL_BONUS_CR_32 = 1; const int FW_MAX_SKILL_BONUS_CR_32 = 50;
const int FW_MIN_SKILL_BONUS_CR_33 = 1; const int FW_MAX_SKILL_BONUS_CR_33 = 50;
const int FW_MIN_SKILL_BONUS_CR_34 = 1; const int FW_MAX_SKILL_BONUS_CR_34 = 50;
const int FW_MIN_SKILL_BONUS_CR_35 = 1; const int FW_MAX_SKILL_BONUS_CR_35 = 50;
const int FW_MIN_SKILL_BONUS_CR_36 = 1; const int FW_MAX_SKILL_BONUS_CR_36 = 50;
const int FW_MIN_SKILL_BONUS_CR_37 = 1; const int FW_MAX_SKILL_BONUS_CR_37 = 50;
const int FW_MIN_SKILL_BONUS_CR_38 = 1; const int FW_MAX_SKILL_BONUS_CR_38 = 50;
const int FW_MIN_SKILL_BONUS_CR_39 = 1; const int FW_MAX_SKILL_BONUS_CR_39 = 50;
const int FW_MIN_SKILL_BONUS_CR_40 = 1; const int FW_MAX_SKILL_BONUS_CR_40 = 50;

const int FW_MIN_SKILL_BONUS_CR_41_OR_HIGHER = 1; const int FW_MAX_SKILL_BONUS_CR_41_OR_HIGHER = 50;

// * ITEM_PROPERTY_SPELL_IMMUNITY_SCHOOL
// * ITEM_PROPERTY_SPELL_IMMUNITY_SPECIFIC
// There is no switch to control min/max for the above two item properties.  
// You can disallow individual items by editing the functions:
// FW_Choose_IP_Spell_Immunity_School  and  FW_Choose_Spell_Immunity_Specific.

// THIEVES_TOOLS
// The minimum and maximum THIEVES_TOOLS values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,12
const int FW_MIN_THIEVES_TOOLS_CR_0 = 1; const int FW_MAX_THIEVES_TOOLS_CR_0 = 12;

const int FW_MIN_THIEVES_TOOLS_CR_1 = 1; const int FW_MAX_THIEVES_TOOLS_CR_1 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_2 = 1; const int FW_MAX_THIEVES_TOOLS_CR_2 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_3 = 1; const int FW_MAX_THIEVES_TOOLS_CR_3 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_4 = 1; const int FW_MAX_THIEVES_TOOLS_CR_4 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_5 = 1; const int FW_MAX_THIEVES_TOOLS_CR_5 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_6 = 1; const int FW_MAX_THIEVES_TOOLS_CR_6 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_7 = 1; const int FW_MAX_THIEVES_TOOLS_CR_7 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_8 = 1; const int FW_MAX_THIEVES_TOOLS_CR_8 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_9 = 1; const int FW_MAX_THIEVES_TOOLS_CR_9 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_10 = 1; const int FW_MAX_THIEVES_TOOLS_CR_10 = 12;

const int FW_MIN_THIEVES_TOOLS_CR_11 = 1; const int FW_MAX_THIEVES_TOOLS_CR_11 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_12 = 1; const int FW_MAX_THIEVES_TOOLS_CR_12 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_13 = 1; const int FW_MAX_THIEVES_TOOLS_CR_13 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_14 = 1; const int FW_MAX_THIEVES_TOOLS_CR_14 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_15 = 1; const int FW_MAX_THIEVES_TOOLS_CR_15 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_16 = 1; const int FW_MAX_THIEVES_TOOLS_CR_16 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_17 = 1; const int FW_MAX_THIEVES_TOOLS_CR_17 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_18 = 1; const int FW_MAX_THIEVES_TOOLS_CR_18 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_19 = 1; const int FW_MAX_THIEVES_TOOLS_CR_19 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_20 = 1; const int FW_MAX_THIEVES_TOOLS_CR_20 = 12;

const int FW_MIN_THIEVES_TOOLS_CR_21 = 1; const int FW_MAX_THIEVES_TOOLS_CR_21 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_22 = 1; const int FW_MAX_THIEVES_TOOLS_CR_22 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_23 = 1; const int FW_MAX_THIEVES_TOOLS_CR_23 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_24 = 1; const int FW_MAX_THIEVES_TOOLS_CR_24 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_25 = 1; const int FW_MAX_THIEVES_TOOLS_CR_25 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_26 = 1; const int FW_MAX_THIEVES_TOOLS_CR_26 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_27 = 1; const int FW_MAX_THIEVES_TOOLS_CR_27 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_28 = 1; const int FW_MAX_THIEVES_TOOLS_CR_28 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_29 = 1; const int FW_MAX_THIEVES_TOOLS_CR_29 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_30 = 1; const int FW_MAX_THIEVES_TOOLS_CR_30 = 12;

const int FW_MIN_THIEVES_TOOLS_CR_31 = 1; const int FW_MAX_THIEVES_TOOLS_CR_31 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_32 = 1; const int FW_MAX_THIEVES_TOOLS_CR_32 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_33 = 1; const int FW_MAX_THIEVES_TOOLS_CR_33 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_34 = 1; const int FW_MAX_THIEVES_TOOLS_CR_34 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_35 = 1; const int FW_MAX_THIEVES_TOOLS_CR_35 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_36 = 1; const int FW_MAX_THIEVES_TOOLS_CR_36 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_37 = 1; const int FW_MAX_THIEVES_TOOLS_CR_37 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_38 = 1; const int FW_MAX_THIEVES_TOOLS_CR_38 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_39 = 1; const int FW_MAX_THIEVES_TOOLS_CR_39 = 12;
const int FW_MIN_THIEVES_TOOLS_CR_40 = 1; const int FW_MAX_THIEVES_TOOLS_CR_40 = 12;

const int FW_MIN_THIEVES_TOOLS_CR_41_OR_HIGHER = 1; const int FW_MAX_THIEVES_TOOLS_CR_41_OR_HIGHER = 12;

// TURN_RESISTANCE
// The minimum and maximum TURN_RESISTANCE values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,50
const int FW_MIN_TURN_RESISTANCE_CR_0 = 1; const int FW_MAX_TURN_RESISTANCE_CR_0 = 50;

const int FW_MIN_TURN_RESISTANCE_CR_1 = 1; const int FW_MAX_TURN_RESISTANCE_CR_1 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_2 = 1; const int FW_MAX_TURN_RESISTANCE_CR_2 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_3 = 1; const int FW_MAX_TURN_RESISTANCE_CR_3 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_4 = 1; const int FW_MAX_TURN_RESISTANCE_CR_4 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_5 = 1; const int FW_MAX_TURN_RESISTANCE_CR_5 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_6 = 1; const int FW_MAX_TURN_RESISTANCE_CR_6 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_7 = 1; const int FW_MAX_TURN_RESISTANCE_CR_7 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_8 = 1; const int FW_MAX_TURN_RESISTANCE_CR_8 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_9 = 1; const int FW_MAX_TURN_RESISTANCE_CR_9 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_10 = 1; const int FW_MAX_TURN_RESISTANCE_CR_10 = 50;

const int FW_MIN_TURN_RESISTANCE_CR_11 = 1; const int FW_MAX_TURN_RESISTANCE_CR_11 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_12 = 1; const int FW_MAX_TURN_RESISTANCE_CR_12 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_13 = 1; const int FW_MAX_TURN_RESISTANCE_CR_13 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_14 = 1; const int FW_MAX_TURN_RESISTANCE_CR_14 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_15 = 1; const int FW_MAX_TURN_RESISTANCE_CR_15 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_16 = 1; const int FW_MAX_TURN_RESISTANCE_CR_16 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_17 = 1; const int FW_MAX_TURN_RESISTANCE_CR_17 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_18 = 1; const int FW_MAX_TURN_RESISTANCE_CR_18 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_19 = 1; const int FW_MAX_TURN_RESISTANCE_CR_19 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_20 = 1; const int FW_MAX_TURN_RESISTANCE_CR_20 = 50;

const int FW_MIN_TURN_RESISTANCE_CR_21 = 1; const int FW_MAX_TURN_RESISTANCE_CR_21 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_22 = 1; const int FW_MAX_TURN_RESISTANCE_CR_22 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_23 = 1; const int FW_MAX_TURN_RESISTANCE_CR_23 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_24 = 1; const int FW_MAX_TURN_RESISTANCE_CR_24 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_25 = 1; const int FW_MAX_TURN_RESISTANCE_CR_25 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_26 = 1; const int FW_MAX_TURN_RESISTANCE_CR_26 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_27 = 1; const int FW_MAX_TURN_RESISTANCE_CR_27 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_28 = 1; const int FW_MAX_TURN_RESISTANCE_CR_28 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_29 = 1; const int FW_MAX_TURN_RESISTANCE_CR_29 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_30 = 1; const int FW_MAX_TURN_RESISTANCE_CR_30 = 50;

const int FW_MIN_TURN_RESISTANCE_CR_31 = 1; const int FW_MAX_TURN_RESISTANCE_CR_31 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_32 = 1; const int FW_MAX_TURN_RESISTANCE_CR_32 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_33 = 1; const int FW_MAX_TURN_RESISTANCE_CR_33 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_34 = 1; const int FW_MAX_TURN_RESISTANCE_CR_34 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_35 = 1; const int FW_MAX_TURN_RESISTANCE_CR_35 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_36 = 1; const int FW_MAX_TURN_RESISTANCE_CR_36 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_37 = 1; const int FW_MAX_TURN_RESISTANCE_CR_37 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_38 = 1; const int FW_MAX_TURN_RESISTANCE_CR_38 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_39 = 1; const int FW_MAX_TURN_RESISTANCE_CR_39 = 50;
const int FW_MIN_TURN_RESISTANCE_CR_40 = 1; const int FW_MAX_TURN_RESISTANCE_CR_40 = 50;

const int FW_MIN_TURN_RESISTANCE_CR_41_OR_HIGHER = 1; const int FW_MAX_TURN_RESISTANCE_CR_41_OR_HIGHER = 50;

// * ITEM_PROPERTY_UNLIMITED_AMMO
// There is no switch to control the type(s) of unlimited ammo.  To change the
// default go into the function FW_Choose_IP_Unlimited_Ammo and comment out the
// case statements you don't want as options.

// VAMPIRIC_REGENERATION
// The minimum and maximum VAMPIRIC_REGENERATION values an item could have
// (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_VAMPIRIC_REGENERATION_CR_0 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_0 = 20;

const int FW_MIN_VAMPIRIC_REGENERATION_CR_1 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_1 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_2 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_2 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_3 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_3 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_4 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_4 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_5 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_5 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_6 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_6 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_7 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_7 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_8 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_8 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_9 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_9 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_10 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_10 = 20;

const int FW_MIN_VAMPIRIC_REGENERATION_CR_11 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_11 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_12 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_12 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_13 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_13 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_14 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_14 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_15 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_15 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_16 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_16 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_17 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_17 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_18 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_18 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_19 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_19 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_20 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_20 = 20;

const int FW_MIN_VAMPIRIC_REGENERATION_CR_21 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_21 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_22 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_22 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_23 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_23 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_24 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_24 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_25 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_25 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_26 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_26 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_27 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_27 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_28 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_28 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_29 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_29 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_30 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_30 = 20;

const int FW_MIN_VAMPIRIC_REGENERATION_CR_31 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_31 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_32 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_32 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_33 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_33 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_34 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_34 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_35 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_35 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_36 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_36 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_37 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_37 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_38 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_38 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_39 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_39 = 20;
const int FW_MIN_VAMPIRIC_REGENERATION_CR_40 = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_40 = 20;

const int FW_MIN_VAMPIRIC_REGENERATION_CR_41_OR_HIGHER = 1; const int FW_MAX_VAMPIRIC_REGENERATION_CR_41_OR_HIGHER = 20;

// * ITEM_PROPERTY_WEIGHT_INCREASE
// Weight Increase is bugged in NWN 2.  Even if it worked properly there wouldn't be a set of
// min / max values to control the amounts because they are sporadic all over the place values

// * ITEM_PROPERTY_WEIGHT_REDUCTION
// There is no switch to control the Weight Increase or Decrease on an item. By
// default all weight increase/decrease amounts are possible.  To disallow
// any/some of the possibles comment out the undesired amounts inside the
// functions: FW_Choose_IP_Weight_Increase and FW_Choose_IP_Weight_Reduction.

// TRAP_LEVEL
// The minimum and maximum trap types that could drop from a monster spawn.
//   0 = Minor, 1 = Average, 2 = Strong, 3 = Deadly  This does not account
// for epic traps yet as they come out with Mask of the Betrayer.
// This will need to be updated for the expansion.
const int FW_MIN_TRAP_LEVEL_CR_0 = 0; const int FW_MAX_TRAP_LEVEL_CR_0 = 3;

const int FW_MIN_TRAP_LEVEL_CR_1 = 0; const int FW_MAX_TRAP_LEVEL_CR_1 = 3;
const int FW_MIN_TRAP_LEVEL_CR_2 = 0; const int FW_MAX_TRAP_LEVEL_CR_2 = 3;
const int FW_MIN_TRAP_LEVEL_CR_3 = 0; const int FW_MAX_TRAP_LEVEL_CR_3 = 3;
const int FW_MIN_TRAP_LEVEL_CR_4 = 0; const int FW_MAX_TRAP_LEVEL_CR_4 = 3;
const int FW_MIN_TRAP_LEVEL_CR_5 = 0; const int FW_MAX_TRAP_LEVEL_CR_5 = 3;
const int FW_MIN_TRAP_LEVEL_CR_6 = 0; const int FW_MAX_TRAP_LEVEL_CR_6 = 3;
const int FW_MIN_TRAP_LEVEL_CR_7 = 0; const int FW_MAX_TRAP_LEVEL_CR_7 = 3;
const int FW_MIN_TRAP_LEVEL_CR_8 = 0; const int FW_MAX_TRAP_LEVEL_CR_8 = 3;
const int FW_MIN_TRAP_LEVEL_CR_9 = 0; const int FW_MAX_TRAP_LEVEL_CR_9 = 3;
const int FW_MIN_TRAP_LEVEL_CR_10 = 0; const int FW_MAX_TRAP_LEVEL_CR_10 = 3;

const int FW_MIN_TRAP_LEVEL_CR_11 = 0; const int FW_MAX_TRAP_LEVEL_CR_11 = 3;
const int FW_MIN_TRAP_LEVEL_CR_12 = 0; const int FW_MAX_TRAP_LEVEL_CR_12 = 3;
const int FW_MIN_TRAP_LEVEL_CR_13 = 0; const int FW_MAX_TRAP_LEVEL_CR_13 = 3;
const int FW_MIN_TRAP_LEVEL_CR_14 = 0; const int FW_MAX_TRAP_LEVEL_CR_14 = 3;
const int FW_MIN_TRAP_LEVEL_CR_15 = 0; const int FW_MAX_TRAP_LEVEL_CR_15 = 3;
const int FW_MIN_TRAP_LEVEL_CR_16 = 0; const int FW_MAX_TRAP_LEVEL_CR_16 = 3;
const int FW_MIN_TRAP_LEVEL_CR_17 = 0; const int FW_MAX_TRAP_LEVEL_CR_17 = 3;
const int FW_MIN_TRAP_LEVEL_CR_18 = 0; const int FW_MAX_TRAP_LEVEL_CR_18 = 3;
const int FW_MIN_TRAP_LEVEL_CR_19 = 0; const int FW_MAX_TRAP_LEVEL_CR_19 = 3;
const int FW_MIN_TRAP_LEVEL_CR_20 = 0; const int FW_MAX_TRAP_LEVEL_CR_20 = 3;

const int FW_MIN_TRAP_LEVEL_CR_21 = 0; const int FW_MAX_TRAP_LEVEL_CR_21 = 3;
const int FW_MIN_TRAP_LEVEL_CR_22 = 0; const int FW_MAX_TRAP_LEVEL_CR_22 = 3;
const int FW_MIN_TRAP_LEVEL_CR_23 = 0; const int FW_MAX_TRAP_LEVEL_CR_23 = 3;
const int FW_MIN_TRAP_LEVEL_CR_24 = 0; const int FW_MAX_TRAP_LEVEL_CR_24 = 3;
const int FW_MIN_TRAP_LEVEL_CR_25 = 0; const int FW_MAX_TRAP_LEVEL_CR_25 = 3;
const int FW_MIN_TRAP_LEVEL_CR_26 = 0; const int FW_MAX_TRAP_LEVEL_CR_26 = 3;
const int FW_MIN_TRAP_LEVEL_CR_27 = 0; const int FW_MAX_TRAP_LEVEL_CR_27 = 3;
const int FW_MIN_TRAP_LEVEL_CR_28 = 0; const int FW_MAX_TRAP_LEVEL_CR_28 = 3;
const int FW_MIN_TRAP_LEVEL_CR_29 = 0; const int FW_MAX_TRAP_LEVEL_CR_29 = 3;
const int FW_MIN_TRAP_LEVEL_CR_30 = 0; const int FW_MAX_TRAP_LEVEL_CR_30 = 3;

const int FW_MIN_TRAP_LEVEL_CR_31 = 0; const int FW_MAX_TRAP_LEVEL_CR_31 = 3;
const int FW_MIN_TRAP_LEVEL_CR_32 = 0; const int FW_MAX_TRAP_LEVEL_CR_32 = 3;
const int FW_MIN_TRAP_LEVEL_CR_33 = 0; const int FW_MAX_TRAP_LEVEL_CR_33 = 3;
const int FW_MIN_TRAP_LEVEL_CR_34 = 0; const int FW_MAX_TRAP_LEVEL_CR_34 = 3;
const int FW_MIN_TRAP_LEVEL_CR_35 = 0; const int FW_MAX_TRAP_LEVEL_CR_35 = 3;
const int FW_MIN_TRAP_LEVEL_CR_36 = 0; const int FW_MAX_TRAP_LEVEL_CR_36 = 3;
const int FW_MIN_TRAP_LEVEL_CR_37 = 0; const int FW_MAX_TRAP_LEVEL_CR_37 = 3;
const int FW_MIN_TRAP_LEVEL_CR_38 = 0; const int FW_MAX_TRAP_LEVEL_CR_38 = 3;
const int FW_MIN_TRAP_LEVEL_CR_39 = 0; const int FW_MAX_TRAP_LEVEL_CR_39 = 3;
const int FW_MIN_TRAP_LEVEL_CR_40 = 0; const int FW_MAX_TRAP_LEVEL_CR_40 = 3;

const int FW_MIN_TRAP_LEVEL_CR_41_OR_HIGHER = 0; const int FW_MAX_TRAP_LEVEL_CR_41_OR_HIGHER = 3;

/*  NOTES TO SELF (cdaulepp)

Here's the template I used to cut and paste all those hundreds of min / max
constants above. Then use the replace function tab to quickly replace 'Z'
with the item property you want.

// The minimum and maximum **** values an item could have (for each CR level).
// Acceptable values: 1,2,3,...,20
const int FW_MIN_Z_CR_0 = 1; const int FW_MAX_Z_CR_0 = 20;

const int FW_MIN_Z_CR_1 = 1; const int FW_MAX_Z_CR_1 = 20;
const int FW_MIN_Z_CR_2 = 1; const int FW_MAX_Z_CR_2 = 20;
const int FW_MIN_Z_CR_3 = 1; const int FW_MAX_Z_CR_3 = 20;
const int FW_MIN_Z_CR_4 = 1; const int FW_MAX_Z_CR_4 = 20;
const int FW_MIN_Z_CR_5 = 1; const int FW_MAX_Z_CR_5 = 20;
const int FW_MIN_Z_CR_6 = 1; const int FW_MAX_Z_CR_6 = 20;
const int FW_MIN_Z_CR_7 = 1; const int FW_MAX_Z_CR_7 = 20;
const int FW_MIN_Z_CR_8 = 1; const int FW_MAX_Z_CR_8 = 20;
const int FW_MIN_Z_CR_9 = 1; const int FW_MAX_Z_CR_9 = 20;
const int FW_MIN_Z_CR_10 = 1; const int FW_MAX_Z_CR_10 = 20;

const int FW_MIN_Z_CR_11 = 1; const int FW_MAX_Z_CR_11 = 20;
const int FW_MIN_Z_CR_12 = 1; const int FW_MAX_Z_CR_12 = 20;
const int FW_MIN_Z_CR_13 = 1; const int FW_MAX_Z_CR_13 = 20;
const int FW_MIN_Z_CR_14 = 1; const int FW_MAX_Z_CR_14 = 20;
const int FW_MIN_Z_CR_15 = 1; const int FW_MAX_Z_CR_15 = 20;
const int FW_MIN_Z_CR_16 = 1; const int FW_MAX_Z_CR_16 = 20;
const int FW_MIN_Z_CR_17 = 1; const int FW_MAX_Z_CR_17 = 20;
const int FW_MIN_Z_CR_18 = 1; const int FW_MAX_Z_CR_18 = 20;
const int FW_MIN_Z_CR_19 = 1; const int FW_MAX_Z_CR_19 = 20;
const int FW_MIN_Z_CR_20 = 1; const int FW_MAX_Z_CR_20 = 20;

const int FW_MIN_Z_CR_21 = 1; const int FW_MAX_Z_CR_21 = 20;
const int FW_MIN_Z_CR_22 = 1; const int FW_MAX_Z_CR_22 = 20;
const int FW_MIN_Z_CR_23 = 1; const int FW_MAX_Z_CR_23 = 20;
const int FW_MIN_Z_CR_24 = 1; const int FW_MAX_Z_CR_24 = 20;
const int FW_MIN_Z_CR_25 = 1; const int FW_MAX_Z_CR_25 = 20;
const int FW_MIN_Z_CR_26 = 1; const int FW_MAX_Z_CR_26 = 20;
const int FW_MIN_Z_CR_27 = 1; const int FW_MAX_Z_CR_27 = 20;
const int FW_MIN_Z_CR_28 = 1; const int FW_MAX_Z_CR_28 = 20;
const int FW_MIN_Z_CR_29 = 1; const int FW_MAX_Z_CR_29 = 20;
const int FW_MIN_Z_CR_30 = 1; const int FW_MAX_Z_CR_30 = 20;

const int FW_MIN_Z_CR_31 = 1; const int FW_MAX_Z_CR_31 = 20;
const int FW_MIN_Z_CR_32 = 1; const int FW_MAX_Z_CR_32 = 20;
const int FW_MIN_Z_CR_33 = 1; const int FW_MAX_Z_CR_33 = 20;
const int FW_MIN_Z_CR_34 = 1; const int FW_MAX_Z_CR_34 = 20;
const int FW_MIN_Z_CR_35 = 1; const int FW_MAX_Z_CR_35 = 20;
const int FW_MIN_Z_CR_36 = 1; const int FW_MAX_Z_CR_36 = 20;
const int FW_MIN_Z_CR_37 = 1; const int FW_MAX_Z_CR_37 = 20;
const int FW_MIN_Z_CR_38 = 1; const int FW_MAX_Z_CR_38 = 20;
const int FW_MIN_Z_CR_39 = 1; const int FW_MAX_Z_CR_39 = 20;
const int FW_MIN_Z_CR_40 = 1; const int FW_MAX_Z_CR_40 = 20;

const int FW_MIN_Z_CR_41_OR_HIGHER = 1; const int FW_MAX_Z_CR_41_OR_HIGHER = 20;

*/

/*
NOTE TO SELF (cdaulepp): Here's the code I cut and pasted to quickly populate the 
item property functions in the file "fw_inc_choose_ip".  Replace "__CR"
with the constants you want. Example "_ATTACK_BONUS_CR".  This will quickly
populate everything!  That way I don't have to type 1000 lines over and 
over!!! 

  
   int min;
   int max;
   
   switch (nCR)
   {
		case 0: min = FW_MIN__CR_0 ; max = FW_MAX__CR_0 ;    break;
		
		case 1: min = FW_MIN__CR_1 ; max = FW_MAX__CR_1 ;    break;
		case 2: min = FW_MIN__CR_2 ; max = FW_MAX__CR_2 ;    break;
		case 3: min = FW_MIN__CR_3 ; max = FW_MAX__CR_3 ;    break;
   		case 4: min = FW_MIN__CR_4 ; max = FW_MAX__CR_4 ;    break;
		case 5: min = FW_MIN__CR_5 ; max = FW_MAX__CR_5 ;    break;
		case 6: min = FW_MIN__CR_6 ; max = FW_MAX__CR_6 ;    break;
   		case 7: min = FW_MIN__CR_7 ; max = FW_MAX__CR_7 ;    break;
		case 8: min = FW_MIN__CR_8 ; max = FW_MAX__CR_8 ;    break;
		case 9: min = FW_MIN__CR_9 ; max = FW_MAX__CR_9 ;    break;
   		case 10: min = FW_MIN__CR_10 ; max = FW_MAX__CR_10 ; break;
		
		case 11: min = FW_MIN__CR_11 ; max = FW_MAX__CR_11 ;  break;
		case 12: min = FW_MIN__CR_12 ; max = FW_MAX__CR_12 ;  break;
		case 13: min = FW_MIN__CR_13 ; max = FW_MAX__CR_13 ;  break;
   		case 14: min = FW_MIN__CR_14 ; max = FW_MAX__CR_14 ;  break;
		case 15: min = FW_MIN__CR_15 ; max = FW_MAX__CR_15 ;  break;
		case 16: min = FW_MIN__CR_16 ; max = FW_MAX__CR_16 ;  break;
   		case 17: min = FW_MIN__CR_17 ; max = FW_MAX__CR_17 ;  break;
		case 18: min = FW_MIN__CR_18 ; max = FW_MAX__CR_18 ;  break;
		case 19: min = FW_MIN__CR_19 ; max = FW_MAX__CR_19 ;  break;
   		case 20: min = FW_MIN__CR_20 ; max = FW_MAX__CR_20 ;  break;
   
   		case 21: min = FW_MIN__CR_21 ; max = FW_MAX__CR_21 ;  break;
		case 22: min = FW_MIN__CR_22 ; max = FW_MAX__CR_22 ;  break;
		case 23: min = FW_MIN__CR_23 ; max = FW_MAX__CR_23 ;  break;
   		case 24: min = FW_MIN__CR_24 ; max = FW_MAX__CR_24 ;  break;
		case 25: min = FW_MIN__CR_25 ; max = FW_MAX__CR_25 ;  break;
		case 26: min = FW_MIN__CR_26 ; max = FW_MAX__CR_26 ;  break;
   		case 27: min = FW_MIN__CR_27 ; max = FW_MAX__CR_27 ;  break;
		case 28: min = FW_MIN__CR_28 ; max = FW_MAX__CR_28 ;  break;
		case 29: min = FW_MIN__CR_29 ; max = FW_MAX__CR_29 ;  break;
   		case 30: min = FW_MIN__CR_30 ; max = FW_MAX__CR_30 ;  break;		
		
		case 31: min = FW_MIN__CR_31 ; max = FW_MAX__CR_31 ;  break;
		case 32: min = FW_MIN__CR_32 ; max = FW_MAX__CR_32 ;  break;
		case 33: min = FW_MIN__CR_33 ; max = FW_MAX__CR_33 ;  break;
   		case 34: min = FW_MIN__CR_34 ; max = FW_MAX__CR_34 ;  break;
		case 35: min = FW_MIN__CR_35 ; max = FW_MAX__CR_35 ;  break;
		case 36: min = FW_MIN__CR_36 ; max = FW_MAX__CR_36 ;  break;
   		case 37: min = FW_MIN__CR_37 ; max = FW_MAX__CR_37 ;  break;
		case 38: min = FW_MIN__CR_38 ; max = FW_MAX__CR_38 ;  break;
		case 39: min = FW_MIN__CR_39 ; max = FW_MAX__CR_39 ;  break;
   		case 40: min = FW_MIN__CR_40 ; max = FW_MAX__CR_40 ;  break;
		
		case 41: min = FW_MIN__CR_41_OR_HIGHER; max = FW_MAX__CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   
*/	  

/////////////////////////////////////////
/*			FILE DESCRIPTION
This file contains constants that control scaling of loot
based off the idea of item level restrictions.  Some
properties are inherently better than others.  Generally,
for example, immunity to critical hits is better than a +1
enhancement.  Because immunity to critical hits is generally
a better feat, it is valued higher than a +1 enhancement.
However, in combination immunity to critical hits with a 
+1 enhancement is worth MORE than either of the seperate
parts.  That's important to know for my explanation below.  

When an item is being created dynamically (like the random
loot generator does) we don't know ahead of time what 
property(s) will be chosen, or what type of item will drop, or
how many item properties an item will have, or if it will be
an item that can have item properties added to it (like a weapon)
or if the item chosen will be something like a gem or trap
(can't have item properties added to it).

While you can scale the range of power of most of the item 
properties by editing the constants and formulas in the files: 
"fw_inc_cr_scaling_constants" and "fw_inc_cr_scaling_formulas" 
respectively, those files do not address the 'overall' value of
an item drop and those files do not address value of an item
when it has a combination of multiple properties. 

A problem arises that we need to somehow limit the overall value
of an item so that the power of the treasure that drops still fits
the difficulty of the monster killed. The cr scaling through 
constants and formulas (in the above mentioned files) limits any
SINGLE item property very effectively based off the CR of the 
monster.  Editing those files lets you put each item property
into ranges that you feel are appropriate. 

But sometimes items will drop that have MULTIPLE item 
properties.  Alone, a single item property will fit into the 
ranges you set, but in combination with other item properties,
an item will sometimes be too powerful for the CR of the monster
unless we limit the overall gold value somehow. That is what
this file does.

This file contains constants where you set the maximum gold
value that an item drop could have for the corresponding 
monster's creature rating (CR).  Don't confuse this file with 
the constants in the file "fw_inc_misc".  They are not the same
thing.  This file sets limits on the value of an item (if an
item category other than gold was chosen), while 
the file "fw_inc_misc" sets limits on the number of Gold Pieces
dropped (if the gold category was chosen).

The default values in the constants below I took from the
standard item level restriction table in the 2da file 
"itemvalue.2da". 
*/

// The max value in gold pieces (GP) an item could have 
// for each creature rating.
const int FW_MAX_ITEM_VALUE_CR_0  = 1000;

const int FW_MAX_ITEM_VALUE_CR_1  = 1000;
const int FW_MAX_ITEM_VALUE_CR_2  = 1500;
const int FW_MAX_ITEM_VALUE_CR_3  = 2500;
const int FW_MAX_ITEM_VALUE_CR_4  = 3500;
const int FW_MAX_ITEM_VALUE_CR_5  = 5000;

const int FW_MAX_ITEM_VALUE_CR_6  = 6500;
const int FW_MAX_ITEM_VALUE_CR_7  = 9000;
const int FW_MAX_ITEM_VALUE_CR_8  = 12000;
const int FW_MAX_ITEM_VALUE_CR_9  = 15000;
const int FW_MAX_ITEM_VALUE_CR_10 = 19500;

const int FW_MAX_ITEM_VALUE_CR_11 = 25000;
const int FW_MAX_ITEM_VALUE_CR_12 = 30000;
const int FW_MAX_ITEM_VALUE_CR_13 = 35000;
const int FW_MAX_ITEM_VALUE_CR_14 = 40000;
const int FW_MAX_ITEM_VALUE_CR_15 = 50000;

const int FW_MAX_ITEM_VALUE_CR_16 = 65000;
const int FW_MAX_ITEM_VALUE_CR_17 = 75000;
const int FW_MAX_ITEM_VALUE_CR_18 = 90000;
const int FW_MAX_ITEM_VALUE_CR_19 = 110000;
const int FW_MAX_ITEM_VALUE_CR_20 = 130000;

const int FW_MAX_ITEM_VALUE_CR_21 = 250000;
const int FW_MAX_ITEM_VALUE_CR_22 = 500000;
const int FW_MAX_ITEM_VALUE_CR_23 = 750000;
const int FW_MAX_ITEM_VALUE_CR_24 = 1000000;  // 1 MILLION
const int FW_MAX_ITEM_VALUE_CR_25 = 1200000;

const int FW_MAX_ITEM_VALUE_CR_26 = 1400000;
const int FW_MAX_ITEM_VALUE_CR_27 = 1600000;
const int FW_MAX_ITEM_VALUE_CR_28 = 1800000;
const int FW_MAX_ITEM_VALUE_CR_29 = 2000000;  // 2 MILLION
const int FW_MAX_ITEM_VALUE_CR_30 = 2200000;

const int FW_MAX_ITEM_VALUE_CR_31 = 2400000;
const int FW_MAX_ITEM_VALUE_CR_32 = 2600000;
const int FW_MAX_ITEM_VALUE_CR_33 = 2800000;
const int FW_MAX_ITEM_VALUE_CR_34 = 3000000;  // 3 MILLION
const int FW_MAX_ITEM_VALUE_CR_35 = 3200000;

const int FW_MAX_ITEM_VALUE_CR_36 = 3400000;
const int FW_MAX_ITEM_VALUE_CR_37 = 3600000;
const int FW_MAX_ITEM_VALUE_CR_38 = 3800000;
const int FW_MAX_ITEM_VALUE_CR_39 = 4000000;  // 4 MILLION
const int FW_MAX_ITEM_VALUE_CR_40 = 4200000;

// I deviated from the 2da file for CR 41 or higher.  I put a limit
// of 10 million gold pieces for this one.  I did this because I 
// am grouping CR 41,42,43,...,60 together.  I didn't want 
// the default value to have a low limit for the super awesomely tough
// monster category of CR 41 or higher.
const int FW_MAX_ITEM_VALUE_CR_41_OR_HIGHER = 10000000; // 10 MILLION