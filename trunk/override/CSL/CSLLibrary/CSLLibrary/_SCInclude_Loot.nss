// I need the item property functions.
#include "_CSLCore_Items"
#include "_CSLCore_Player"
#include "_SCInclude_Loot_c"

/** @file
* @brief Include File for cdaulepp treasure generator
* This is not really working and just here to support some features which are barely used
* 
* 
*
* @ingroup scinclude
* @author Christopher Aulepp
*/

// *******************************
//
// Created by: Christopher Aulepp
// Date: 28 August 2007
// VERSION 1.2
// contact info: cdaulepp@juno.com
//
// *******************************


/*

//////////////////////////////////////////
// * Function that decides if an item is cursed.
// - nChance is how often out of a 1,000 rolls will an item be cursed.
//   By default 1 out of 1,000 items will be cursed. You can change this to
//   any frequency you want up to 1,000 out of 1,000 (all items) cursed.
//   Return TRUE if item is cursed.  Returns FALSE if item is not cursed.
//
int FW_IsItemCursed (int nChance = FW_PROB_CURSED_LOOT);

//////////////////////////////////////////
// * Function that decides if a monster spawn will drop loot or not.
// - nCR is the Challenge Rating of the spawning monster.
//
int FW_DoesMonsterDropLoot (int nCR = 0);

//////////////////////////////////////////
// * Function that decides how many items drop from a spawning monster.
//
int FW_HowManyItemsDrop ();

//////////////////////////////////////////
// * Function that decides how many item PROPERTIES appear on loot
//
int FW_HowManyIP ();

//////////////////////////////////////////
// * Function that decides what metal armor material type drops.
//
int FW_WhatMetalArmorMaterial ();

//////////////////////////////////////////
// * Function that decides what metal weapon material type drops.
//
int FW_WhatMetalWeaponMaterial ();

//////////////////////////////////////////
// * Function that decides what wooden weapon material type drops.
//
int FW_WhatWoodWeaponMaterial ();





/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////

//////////////////////////////////////////////
//			UPDATES
//
//////////////////////////////////////////////
// VERSION 1.2
// -renamed this file to be consistent with naming conventions
//







/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////


// *****************************************
//           	WARNING: ONLY AN
//				EXPERIENCED SCRIPTER SHOULD
//				CHANGE ANYTHING IN THIS FILE
// *****************************************


// *****************************************
//           	UPDATES
// *****************************************
// VERSION 1.2
// - 27 August 2007 - Added a miscellaneous custom item category to each 
//   function implementation to account for end-user custom items they 
//   want to add to the random loot generator


// *****************************************
//           		INCLUDE 
//
//			   DON'T CHANGE THIS
// *****************************************
// I need the racial loot probability tables.
//#include "fw_inc_probability_tables_races"
// I need some constants from the prob_tables
//#include "fw_inc_probability_tables_misc"

// I need the loot category constants.
//#include "fw_inc_misc"

// *****************************************
//           FUNCTION DECLARATIONS
//
//			   DON'T CHANGE THIS
// *****************************************

////////////////////////////////////////////
// * Function that returns the loot category of item to be dropped.
// * returns a FW_MISC_*  or FW_ARMOR_* or FW_WEAPON_* constant.
//
int FW_Get_Racial_Loot_Category();

//////////////////////////////////////////
// * Function that weights the type of loot that drops to make exotic/rarer
// * types of loot drop less often. This is the default that is used only 
// * when the switch that allows racial specific loot drops is set to FALSE.   
//
int FW_Get_Default_Loot_Category ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Aberration ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Animal ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Beast ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Construct ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Dragon ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Dwarf ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Elemental ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Elf ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Fey ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Giant ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Gnome ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halfelf ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halfling ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halforc ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Human ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Goblinoid ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Monstrous ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Orc ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Reptilian ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Incorporeal ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Magical_Beast ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Ooze ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Outsider ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Shapechanger ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Undead ();

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Vermin ();






		

// *******************************
//
// Created by: Christopher Aulepp
// Date: 4 Sept 2007
// VERSION 1.2
// contact info: cdaulepp@juno.com
//
// *******************************





///////////////////////////////////////////////
//			FUNCTION DECLARATIONS
//			 DON'T CHANGE THESE
///////////////////////////////////////////////

//////////////////////////////////////////////
// * This function looks up the maximum overall Gold Piece value
// * an item could have, as defined in the constants:
// * FW_MAX_ITEM_VALUE_CR_* where * = the CR of the spawning
// * monster.
//
int FW_GetMaxItemValue (int nCR = 0);

//////////////////////////////////////////////
// * This function checks to see if the item chosen by the random
// * loot generator is less than the allowable GP limit for the
// * spawning monster.  If the Item is too expensive for the CR of
// * the monster, then this returns TRUE (and the loot generator
// * will reroll a new item).  If the item is within appropriate
// * GP limits then this returns FALSE.
//
int FW_IsItemRolledTooExpensive (object oItem, int nCR = 0);








/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
// *
//////////////////////////////////////////////

/////////////////////////////////////////////
// *
// *  WARNING: ONLY AN EXPERIENCED SCRIPTER
// *  	       SHOULD CHANGE ANYTHING IN THIS 
// *		   FILE
// *
//////////////////////////////////////////////

// *****************************************
//
//              FILE DESCRIPTION
//
// *****************************************
// This file contains all the functions that create item properties. 
// Based off of the range for min and max chosen by the end-user, each
// item property function chooses a random value and returns the 
// chosen item property. 

// *****************************************
//
//              MAIN
//
// *****************************************
// I shouldn't need a main because this will be a starting conditional. 

// *****************************************
//
//       UPDATES TO ORIGINAL VERSION
//
// *****************************************
//
// VERSION 1.2 UPDATES
// -28 August 2007.  Added formula based scaling for the item property
//	   functions.  End-users indirectly set min and max values through
//     modifiers in the file "fw_inc_cr_scaling_formulas".  This sets
//     the range allowed and then the functions in this file choose an 
//     acceptable value within that range.
//
// VERSION 1.1 UPDATES
//
// -27 July 2007.  Added CR based scaling for the item property functions.
// 	   End-users set min and max values in the file "fw_inc_cr_scaling_constants"
//     for each CR and for each item property.  This sets the range allowed.
//     I had to change the function declarations to get rid of the old constants
// 	   and in their place I pass in the monster's CR.  


// *****************************************
//
//              INCLUDED FILES
//
// *****************************************
// I need the switches to see if something was allowed / disallowed
//#include "fw_inc_loot_switches"

// I need the min / max constants for each IP
//#include "fw_inc_cr_scaling_constants"
// I need the formula based cr scaling constants
//#include "fw_inc_cr_scaling_formulas"

// *****************************************
//              FUNCTION DECLARATIONS
// *****************************************
////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGEBONUS_* from min to max.
// * NOT to be confused with DAMAGE_BONUS_* (used for damage shields)
//
// TABLE: IP_CONST_DAMAGEBONUS
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
int FW_Choose_IP_CONST_DAMAGEBONUS (int min, int max);

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGETYPE_*
//
int FW_Choose_IP_CONST_DAMAGETYPE ();

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_ALIGNMENTGROUP_*
//
int FW_Choose_IP_CONST_ALIGNMENTGROUP ();

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_RACIALTYPE_*
//
int FW_Choose_IP_CONST_RACIALTYPE ();

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_ALIGNMENT_*
//
int FW_Choose_IP_CONST_SALIGN ();

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_CLASS_*
//
int FW_Choose_IP_CONST_CLASS ();

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGEREDUCTION_* subject to
// * min and max values. Acceptable values for min and max are: 1,2,3,...,20
//
int FW_Choose_IP_CONST_DAMAGEREDUCTION (int min, int max);

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGESOAK_* subject to min and
// * max values.  Acceptable values for min and max are: 5,10,15,...,50
//
int FW_Choose_IP_CONST_DAMAGESOAK (int min, int max);

////////////////////////////////////////////
// * Function that randomly chooses an ability bonus type and amount.  You can
// * specify the min or max if you want, but any value less than 1 is changed to
// * 1 and any value greater than 12 is changed to 12.
//
itemproperty FW_Choose_IP_Ability_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus.  Values for min and
// * max should be an integer between 1 and 20.  The type of bonus depends on
// * the item it is being applied to.
//
itemproperty FW_Choose_IP_AC_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Align (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. damage type.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Damage_Type (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Race (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_SAlign (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Arcane Spell Failure.
//
itemproperty FW_Choose_IP_Arcane_Spell_Failure ();

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus.  Values for min and
// * max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_Align (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an attack bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_Race (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_SAlign (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Attack penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Attack_Penalty (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a feat to add to an item.
// * By default ALL bonus feats are allowed.
//
itemproperty FW_Choose_IP_Bonus_Feat ();

////////////////////////////////////////////
// * Function that chooses a random amount of bonus hit points to add to an item
// * min and max should be positive integers between 1 and 50.  Because of how
// * the item property bonus hit points is implemented in NWN 2, it goes like
// * this:  1,2,3,...,20, 25, 30, 35, 40, 45, 50.
//
itemproperty FW_Choose_IP_Bonus_Hit_Points (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a bonus spell of level 0...9 to be added to
// * an item.  Values for min and max should be an integer between 0 and 9.
//
itemproperty FW_Choose_IP_Bonus_Level_Spell(int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw to add to an item.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Bonus_Saving_Throw (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw VS 'XYZ' to add to an
// * Item. Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Bonus_Saving_Throw_VsX (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a bonus spell resistance to add to an item.
// * Values for min and max should be an integer between 10 and 32 in even
// * increments of 2. I.E. 10,12,14,16,18,20,22,24,26,28,30,32
//
itemproperty FW_Choose_IP_Bonus_Spell_Resistance (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a spell to be added to an item as a cast
// * spell item property.
//
itemproperty FW_Choose_IP_Cast_Spell ();

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage bonus to be added
// * to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an alignment group, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_Align (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a race, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_Race (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a specific alignment, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_SAlign (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage immunity amount to
// * be added to an item.
//
itemproperty FW_Choose_IP_Damage_Immunity ();

////////////////////////////////////////////
// * Function that randomly chooses a damage penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Damage_Penalty (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an enhancement level that is required to get
// * past the damage reduction as well as choosing the amount of hit points that
// * will be absorbed if the weapon is not of high enough enhancement.
//
itemproperty FW_Choose_IP_Damage_Reduction (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an amount of hit points that will be
// * resisted each round, subject to min and max values. Acceptable values for
// * min and max are: 5,10,15,...,50
//
itemproperty FW_Choose_IP_Damage_Resistance (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage vulnerability
// * amount to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Vulnerability ();

////////////////////////////////////////////
// * Function that randomly chooses an ability penalty type and amount.  You can
// * specify the min or max if you want, but any value less than 1 is changed to
// * 1 and any value greater than 10 is changed to 10.  Use ONLY positive
// * integers.  I.E. 1 = -1 penalty, 2 = -2 penalty, etc.
//
itemproperty FW_Choose_IP_Decrease_Ability (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class type and penalty (subject to
// * min and max values.  Use only POSITIVE integers for min and max. 1...5
//
itemproperty FW_Choose_IP_Decrease_AC (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly decreases a skill between 1 and 10 points.
// * Acceptable values for min and max must be POSITIVE integers: 1,2,3,...,10
//
itemproperty FW_Choose_IP_Decrease_Skill (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus.  Values for min and
// * max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_Align (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an attack bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_Race (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Enhancement_Penalty (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a base damage type to be added to a melee weapon.
// * Only adds Bludgeoning, Slashing, or Piercing damage to a weapon.
//
itemproperty FW_Choose_IP_Extra_Melee_Damage_Type ();

////////////////////////////////////////////
// * Function that chooses a base damage type to be added to a ranged weapon.
// * Only adds Bludgeoning, Slashing, or Piercing damage to a weapon.
//
itemproperty FW_Choose_IP_Extra_Range_Damage_Type ();

////////////////////////////////////////////
// * Function that chooses the level of a healer's kit subject to min and max.
// * Min and Max must be positive integers between 1 and 12:  1,2,3,...,12
//
itemproperty FW_Choose_IP_Healer_Kit (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a miscellaneous immunity property for an item.
//
itemproperty FW_Choose_IP_Immunity_Misc ();

////////////////////////////////////////////
// * Function that chooses an immunity to spell level for an item.  The user
// * becomes immune to all spells of the number chosen and below. Acceptable
// * values for min and max are integers from 1 to 9.  0 is NOT acceptable.
//
itemproperty FW_Choose_IP_Immunity_To_Spell_Level (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a color and brightness of light to be added to an
// * item.
//
itemproperty FW_Choose_IP_Light();

////////////////////////////////////////////
// * Function that limits an item's use to a certain Alignment GROUP.
//
itemproperty FW_Choose_IP_Limit_Use_By_Align ();

////////////////////////////////////////////
// * Function that limits an item's use to a certain Class.
//
itemproperty FW_Choose_IP_Limit_Use_By_Class ();

////////////////////////////////////////////
// * Function that limits an item's use to a certain Race.
//
itemproperty FW_Choose_IP_Limit_Use_By_Race ();

////////////////////////////////////////////
// * Function that limits an item's use to a certain SPECIFIC alignment.
//
itemproperty FW_Choose_IP_Limit_Use_By_SAlign ();

////////////////////////////////////////////
// * Function that chooses an amount of massive critical dmg. bonus to be added
// * to an item.  Min and Max must be POSITIVE integers between 0 and 19. See
// * the table: DAMAGE_BONUS for how to set these values to something different
// * than the default.
//
itemproperty FW_Choose_IP_Massive_Critical (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses the Mighty Bonus on a ranged weapon (the maximum
// * strength bonus allowed.  min and max must be positive integers. 1...20
//
itemproperty FW_Choose_IP_Mighty (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses an OnHitCastSpell to be added to an item. Obviously
// * this only works on weapons and armors.
//
itemproperty FW_Choose_IP_On_Hit_Cast_Spell (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses an OnHitProps to be added to an item. Obviously
// * this only works on weapons and armors.
//
itemproperty FW_Choose_IP_On_Hit_Props (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a saving throw penalty to add to an item.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Reduced_Saving_Throw (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw VS 'XYZ' to add to an
// * Item. Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Reduced_Saving_Throw_VsX (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a regeneration bonus that an item can have.  Subject
// * to min and max values as defined.  Limits for min and max are positive
// * integers between 1 and 20:  1,2,3,...,20
//
itemproperty FW_Choose_IP_Regeneration (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a skill bonus type and amount to be added to an item.
// * Limits for min and max are 1 and 50:  1,2,3,...,50
//
itemproperty FW_Choose_IP_Skill_Bonus (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a random spell school immunity to give to an item.
//
itemproperty FW_Choose_IP_Spell_Immunity_School ();

////////////////////////////////////////////
// * Function that chooses a random specific spell immunity to give to an item.
//
itemproperty FW_Choose_IP_Spell_Immunity_Specific ();

////////////////////////////////////////////
// * Function that chooses the thieves tools modifier to be added to an item.
// * You can specify the min or max if you want, but any value less than 1 is
// * changed to 1 and any value greater than 12 is changed to 12.
//
itemproperty FW_Choose_IP_Thieves_Tools (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a random amount of turn resistance to be added to an
// * item. Limits for min and max are 1 and 50:  1,2,3,...,50
//
itemproperty FW_Choose_IP_Turn_Resistance (int nCR = 0);

////////////////////////////////////////////
// * Function that chooses the unlimited ammo item property and also the amount
// * (if any) of extra damage that will be done.
//
itemproperty FW_Choose_IP_Unlimited_Ammo ();

////////////////////////////////////////////
// * Function that chooses a vampiric regeneration bonus that an item can have.
// * Limits for min and max are positive integers: 1,2,3,...,20
//
itemproperty FW_Choose_IP_Vampiric_Regeneration (int nCR = 0);

////////////////////////////////////////////
// * Function that randomly chooses a weight increase to be added to an item
// * from the IP_CONST_WEIGHTINCREASE_* values.  Possible return values are: 5,
// * 10, 15, 30, 50, and 100 pounds.
//
itemproperty FW_Choose_IP_Weight_Increase ();

////////////////////////////////////////////
// * Function that randomly chooses a weight reduction % to be added to an item.
// * Possible return values are: 10%, 20%, 40%, 60%, and 80%.
//
itemproperty FW_Choose_IP_Weight_Reduction ();





/////////////////////////////////////////////
// *
// * Created by Christopher Aulepp
// * Date: 28 August 2007
// * contact information: cdaulepp@juno.com
// * VERSION 1.2
//
//////////////////////////////////////////////

/////////////////////////////////////////////
// *
// *  WARNING: ONLY AN EXPERIENCED SCRIPTER
// *  	       SHOULD CHANGE ANYTHING IN THIS 
// *		   FILE
// *
//////////////////////////////////////////////

// *****************************************
//
//              FILE DESCRIPTION
//
// *****************************************
// This file works in conjunction with the random loot generation system.
// I couldn't find .2da files for all of the items in the standard toolset
// palette.  So, I had to hard-code many of the basic items to allow them
// to be generated as random loot.  The functions in this file get random
// objects from the various loot category types. (i.e. potions, scrolls, etc)

// *****************************************
//
//              MAIN
//
// *****************************************
// I shouldn't need a main because this will be a starting conditional. 

// *****************************************
//
//              UPDATES
//
// *****************************************
// VERSION 1.2
//
// - 28 August 2007.  I added a new function: FW_Get_Random_Misc_Custom_Item.
//      This function is where people will need to edit the code to add
//      their own items into the random loot generator.
//
// - 28 August 2007.  I had accidentally left a line setting CR = 10; in 
//      the get gold function.  Oops.  I had that there when I was testing.
//      I removed that and now the monster's drop gold according to CR 
//      as I intended them to initially.  I also altered the formula that
//      determines how much gold a monster will drop.  I use a formula and
//      modifier method to calculate gold.  I also added module limit checks
//      on the amount of gold that will drop so that monsters will always
//      drop enough, but not too much gold (depending on what the end-user
//      sets for the module limits.  The module limits for gold are set in
//      the file "fw_inc_misc" as are the gold modifiers.
//
// VERSION 1.1
// 
// - 27 July 2007.  I updated the function FW_Get_Random_Trap to account
//      for CR sliding scale.  I also updated the function declarations
//      to account for the CR being passed in as a variable.
//
// - 29 July 2007.  I added functions to get metal types and wood types.
//      I updated the functions FW_Get_Random_Weapon_Simple and 
//      FW_Get_Random_Weapon_Martial to account for other metal and wood 
//      types instead of just generic items.  I also added two functions
//      that handle exotic and ranged weapons and the different types of
//      materials for those.

// *****************************************
//
//              INCLUDED FILES
//
// *****************************************
// I need all the constants and switches.
//#include "fw_inc_loot_switches"

// I need the probability tables.
//#include "fw_inc_probability_tables_misc"
// I need race probability tables too.
//#include "fw_inc_probability_tables_races"

// I need the CR scaling constants
//#include "fw_inc_cr_scaling_constants"
// I need the CR scaling formulas
//#include "fw_inc_cr_scaling_formulas"



// *****************************************
//
//              FUNCTION DECLARATIONS
//
// *****************************************

////////////////////////////////////////////
// * Function that chooses a random metal armor and returns it.
// -nArmorType is a constant of type: FW_ARMOR_*_*2, where * = HEAVY,
//  MEDIUM, or LIGHT and where *2 = one of the metal types of armor 
//  (i.e. Breastplate and FullPlate, but not hide or leather, etc.)
//
object FW_Get_Random_Metal_Armor (int nArmorType);

////////////////////////////////////////////
// * Function that chooses a random book and returns it.
//
object FW_Get_Random_Book (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random crafting material and returns it.
//
object FW_Get_Random_Crafting_Material (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random crafting ALCHEMY material and returns it.
//
object FW_Get_Random_Crafting_Alchemy ();

////////////////////////////////////////////
// * Function that chooses a random crafting BASIC material and returns it.
//
object FW_Get_Random_Crafting_Basic ();

////////////////////////////////////////////
// * Function that chooses a random crafting DISTILLABLE material and returns it.
//
object FW_Get_Random_Crafting_Distillable ();

////////////////////////////////////////////
// * Function that chooses a random crafting ESSENCES material and returns it.
//
object FW_Get_Random_Crafting_Essence ();

////////////////////////////////////////////
// * Function that chooses a random crafting MOLD material and returns it.
//
object FW_Get_Random_Crafting_Mold ();

////////////////////////////////////////////
// * Function that chooses a random crafting TRADESKILL material and returns it.
//
object FW_Get_Random_Crafting_Tradeskill ();

////////////////////////////////////////////
// * Function that chooses a random gem and returns it.
//
object FW_Get_Random_Gem (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random amount of gold based off 
// * creature rating.  This scales with CR.
//
object FW_Get_Random_Gold (int min = FW_MIN_MODULE_GOLD, int max = FW_MAX_MODULE_GOLD);

////////////////////////////////////////////
// * Function that chooses a random heal kit and returns it.
//
object FW_Get_Random_Heal_Kit (struct MyStruct strStruct);


////////////////////////////////////////////
// * Function that chooses a random end-user custom item
// * and returns it.
//
object FW_Get_Random_Misc_Custom_Item (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random piece of equippable item that a damage
// * shield will be added to.
// - This function also adds the "Unique Power Self Only: One Use Per Day"
//   item property to the returning item.
//
object FW_Get_Random_Misc_Damage_Shield_Item (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random item from the misc | other
// * category and returns it.
//
object FW_Get_Random_Misc_Other (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random potion and returns it.
//
object FW_Get_Random_Potion (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random scroll and returns it.
//
object FW_Get_Random_Scroll (struct MyStruct strStruct);

////////////////////////////////////////////
// * Function that chooses a random trap and returns it.
// - min and max are determined by end-user constants. Translates as follows:
//   0 = Minor, 1 = Average, 2 = Strong, 3 = Deadly, 4 = Epic
// - nCR is the creature rating of the spawning monster and is used to
//   determine the level of trap that a monster spawns.
//
object FW_Get_Random_Trap (struct MyStruct strStruct, int nCR = 0);

////////////////////////////////////////////
// * Function that chooses a random wand and returns it.
//
object FW_Get_Random_Wand (struct MyStruct strStruct);


////////////////////////////////////////////
// * Function that iterates through all the types of exotic weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Exotic();

////////////////////////////////////////////
// * Function that iterates through all the types of simple weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Simple();

////////////////////////////////////////////
// * Function that iterates through all the types of martial weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Martial();

*/





/////////////////////////////////////////////
// *
// * 
// *			IMPLEMENTATION 
// *			 DON'T CHANGE
// *
// * 
//////////////////////////////////////////////

//////////////////////////////////////////
// * Function that decides if an item is cursed.
// - nChance is how often out of a 1,000 rolls will an item be cursed.
//   By default 1 out of 1,000 items will be cursed. You can change this to
//   any frequency you want up to 1,000 out of 1,000 (all items) cursed.
//   Return TRUE if item is cursed.  Returns FALSE if item is not cursed.
//
int FW_IsItemCursed (int nChance = FW_PROB_CURSED_LOOT)
{
   int iRoll = Random (1000);
   if (nChance >= iRoll)
         {  return TRUE;  }
   else  {  return FALSE; }
}

//////////////////////////////////////////
// * Function that decides if a monster spawn will drop loot or not.
// - nCR is the Challenge Rating of the spawning monster.
//
int FW_DoesMonsterDropLoot (int nCR = 0)
{		
	// Keep nCR within the bounds set.	
	if (nCR <= 0)
		nCR = 0;
	if (nCR >= 41)
		nCR = 41;
		
	int iRoll = Random (100) + 1;
		
	switch (nCR)
	{
		case 0: if (iRoll <= FW_PROB_LOOT_CR_0  ) return TRUE; else return FALSE; break;
		
	    case 1: if (iRoll <= FW_PROB_LOOT_CR_1  ) return TRUE; else return FALSE; break;
	    case 2: if (iRoll <= FW_PROB_LOOT_CR_2  ) return TRUE; else return FALSE; break;
	    case 3: if (iRoll <= FW_PROB_LOOT_CR_3  ) return TRUE; else return FALSE; break;
	    case 4: if (iRoll <= FW_PROB_LOOT_CR_4  ) return TRUE; else return FALSE; break;
	    case 5: if (iRoll <= FW_PROB_LOOT_CR_5  ) return TRUE; else return FALSE; break;
	    case 6: if (iRoll <= FW_PROB_LOOT_CR_6  ) return TRUE; else return FALSE; break;
	    case 7: if (iRoll <= FW_PROB_LOOT_CR_7  ) return TRUE; else return FALSE; break;
	    case 8: if (iRoll <= FW_PROB_LOOT_CR_8  ) return TRUE; else return FALSE; break;
	    case 9: if (iRoll <= FW_PROB_LOOT_CR_9  ) return TRUE; else return FALSE; break;
	    case 10: if (iRoll <= FW_PROB_LOOT_CR_10  ) return TRUE; else return FALSE; break;
	    		
		case 11: if (iRoll <= FW_PROB_LOOT_CR_11  ) return TRUE; else return FALSE; break;
	    case 12: if (iRoll <= FW_PROB_LOOT_CR_12  ) return TRUE; else return FALSE; break;
	    case 13: if (iRoll <= FW_PROB_LOOT_CR_13  ) return TRUE; else return FALSE; break;
	    case 14: if (iRoll <= FW_PROB_LOOT_CR_14  ) return TRUE; else return FALSE; break;
	    case 15: if (iRoll <= FW_PROB_LOOT_CR_15  ) return TRUE; else return FALSE; break;
	    case 16: if (iRoll <= FW_PROB_LOOT_CR_16  ) return TRUE; else return FALSE; break;
	    case 17: if (iRoll <= FW_PROB_LOOT_CR_17  ) return TRUE; else return FALSE; break;
	    case 18: if (iRoll <= FW_PROB_LOOT_CR_18  ) return TRUE; else return FALSE; break;
	    case 19: if (iRoll <= FW_PROB_LOOT_CR_19  ) return TRUE; else return FALSE; break;
	    case 20: if (iRoll <= FW_PROB_LOOT_CR_20  ) return TRUE; else return FALSE; break;
	    
		case 21: if (iRoll <= FW_PROB_LOOT_CR_21  ) return TRUE; else return FALSE; break;
	    case 22: if (iRoll <= FW_PROB_LOOT_CR_22  ) return TRUE; else return FALSE; break;
	    case 23: if (iRoll <= FW_PROB_LOOT_CR_23  ) return TRUE; else return FALSE; break;
	    case 24: if (iRoll <= FW_PROB_LOOT_CR_24  ) return TRUE; else return FALSE; break;
	    case 25: if (iRoll <= FW_PROB_LOOT_CR_25  ) return TRUE; else return FALSE; break;
	    case 26: if (iRoll <= FW_PROB_LOOT_CR_26  ) return TRUE; else return FALSE; break;
	    case 27: if (iRoll <= FW_PROB_LOOT_CR_27  ) return TRUE; else return FALSE; break;
	    case 28: if (iRoll <= FW_PROB_LOOT_CR_28  ) return TRUE; else return FALSE; break;
	    case 29: if (iRoll <= FW_PROB_LOOT_CR_29  ) return TRUE; else return FALSE; break;
	    case 30: if (iRoll <= FW_PROB_LOOT_CR_30  ) return TRUE; else return FALSE; break;
	    
		case 31: if (iRoll <= FW_PROB_LOOT_CR_31  ) return TRUE; else return FALSE; break;
	    case 32: if (iRoll <= FW_PROB_LOOT_CR_32  ) return TRUE; else return FALSE; break;
	    case 33: if (iRoll <= FW_PROB_LOOT_CR_33  ) return TRUE; else return FALSE; break;
	    case 34: if (iRoll <= FW_PROB_LOOT_CR_34  ) return TRUE; else return FALSE; break;
	    case 35: if (iRoll <= FW_PROB_LOOT_CR_35  ) return TRUE; else return FALSE; break;
	    case 36: if (iRoll <= FW_PROB_LOOT_CR_36  ) return TRUE; else return FALSE; break;
	    case 37: if (iRoll <= FW_PROB_LOOT_CR_37  ) return TRUE; else return FALSE; break;
	    case 38: if (iRoll <= FW_PROB_LOOT_CR_38  ) return TRUE; else return FALSE; break;
	    case 39: if (iRoll <= FW_PROB_LOOT_CR_39  ) return TRUE; else return FALSE; break;
	    case 40: if (iRoll <= FW_PROB_LOOT_CR_40  ) return TRUE; else return FALSE; break;
	    
		case 41: if (iRoll <= FW_PROB_LOOT_CR_41_OR_HIGHER  ) return TRUE; else return FALSE; break;
	    
		default: return FALSE; break;
	} // end of switch
	// I don't see how we would ever get out of this switch without 
	// returning TRUE or FALSE. But just in case...
	return FALSE;
} // end of function

//////////////////////////////////////////
// * Function that decides how many items drop from a spawning monster.
//
int FW_HowManyItemsDrop ()
{	
	int nTotalProbability;
	nTotalProbability = FW_PROB_1_ITEMS_DROPPED + FW_PROB_2_ITEMS_DROPPED +
						FW_PROB_3_ITEMS_DROPPED + FW_PROB_4_ITEMS_DROPPED +
						FW_PROB_5_ITEMS_DROPPED + FW_PROB_6_ITEMS_DROPPED +
						FW_PROB_7_ITEMS_DROPPED + FW_PROB_8_ITEMS_DROPPED +
						FW_PROB_9_ITEMS_DROPPED + FW_PROB_10_ITEMS_DROPPED;
						
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <= FW_PROB_1_ITEMS_DROPPED) 
		return 1;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED)) 
		return 2;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED + 
					  FW_PROB_3_ITEMS_DROPPED)) 
		return 3;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED)) 
		return 4;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED + 
					  FW_PROB_5_ITEMS_DROPPED)) 
		return 5;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED + 
					  FW_PROB_5_ITEMS_DROPPED + 
					  FW_PROB_6_ITEMS_DROPPED)) 
		return 6;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED + 
					  FW_PROB_5_ITEMS_DROPPED + 
					  FW_PROB_6_ITEMS_DROPPED + 
					  FW_PROB_7_ITEMS_DROPPED)) 
		return 7;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED + 
					  FW_PROB_5_ITEMS_DROPPED + 
					  FW_PROB_6_ITEMS_DROPPED + 
					  FW_PROB_7_ITEMS_DROPPED + 
					  FW_PROB_8_ITEMS_DROPPED)) 
		return 8;  
	else if (iRoll <= (FW_PROB_1_ITEMS_DROPPED + 
					  FW_PROB_2_ITEMS_DROPPED +
					  FW_PROB_3_ITEMS_DROPPED + 
					  FW_PROB_4_ITEMS_DROPPED + 
					  FW_PROB_5_ITEMS_DROPPED + 
					  FW_PROB_6_ITEMS_DROPPED + 
					  FW_PROB_7_ITEMS_DROPPED + 
					  FW_PROB_8_ITEMS_DROPPED + 
					  FW_PROB_9_ITEMS_DROPPED)) 
		return 9;  
	else // A monster dropped 10 items!!! Holy Cow.
		return 10; 
} // end of function

//////////////////////////////////////////
// * Function that decides how many item PROPERTIES appear on loot
//
int FW_HowManyIP ()
{	
	int nTotalProbability;
	nTotalProbability = FW_PROB_0_ITEM_PROPERTYS + FW_PROB_1_ITEM_PROPERTYS +
						FW_PROB_2_ITEM_PROPERTYS + FW_PROB_3_ITEM_PROPERTYS + 
						FW_PROB_4_ITEM_PROPERTYS + FW_PROB_5_ITEM_PROPERTYS + 
						FW_PROB_6_ITEM_PROPERTYS + FW_PROB_7_ITEM_PROPERTYS + 
						FW_PROB_8_ITEM_PROPERTYS + FW_PROB_9_ITEM_PROPERTYS + 
						FW_PROB_10_ITEM_PROPERTYS;
				
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=  FW_PROB_0_ITEM_PROPERTYS) 
		return 0;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS ))
		return 1;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS ))
		return 2;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS ))
		return 3;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS ))
		return 4;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS +
					   FW_PROB_5_ITEM_PROPERTYS ))
		return 5;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS +
					   FW_PROB_5_ITEM_PROPERTYS +
					   FW_PROB_6_ITEM_PROPERTYS ))
		return 6;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS +
					   FW_PROB_5_ITEM_PROPERTYS +
					   FW_PROB_6_ITEM_PROPERTYS +
					   FW_PROB_7_ITEM_PROPERTYS ))
		return 7;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS +
					   FW_PROB_5_ITEM_PROPERTYS +
					   FW_PROB_6_ITEM_PROPERTYS +
					   FW_PROB_7_ITEM_PROPERTYS +
					   FW_PROB_8_ITEM_PROPERTYS ))
		return 8;
	else if (iRoll <= (FW_PROB_0_ITEM_PROPERTYS +
					   FW_PROB_1_ITEM_PROPERTYS +
					   FW_PROB_2_ITEM_PROPERTYS +
					   FW_PROB_3_ITEM_PROPERTYS +
					   FW_PROB_4_ITEM_PROPERTYS +
					   FW_PROB_5_ITEM_PROPERTYS +
					   FW_PROB_6_ITEM_PROPERTYS +
					   FW_PROB_7_ITEM_PROPERTYS +
					   FW_PROB_8_ITEM_PROPERTYS +
					   FW_PROB_9_ITEM_PROPERTYS ))
		return 9;
	else // Wow 10 Item properties on a single item! You can technically have
	     // 25 item properties on an item, but I didn't code that many possibilities
		 // because that is beyond ridiculous.  Most people will probably say even
		 // coding for 10 item properties is ridiculous, but hey, I had to stop
		 // at something.  I chose to stop at 10 IP.
		return 10;
} // end of function


//////////////////////////////////////////
// * Function that decides what metal armor material type drops.
//
int FW_WhatMetalArmorMaterial ()
{
	int nTotalProbability = FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC +
							FW_PROB_ARMOR_MATERIAL_ADAMANTINE +
							FW_PROB_ARMOR_MATERIAL_DARKSTEEL +
							FW_PROB_ARMOR_MATERIAL_IRON +
							FW_PROB_ARMOR_MATERIAL_MITHRAL;
	
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=  FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC)
	
		return FW_MATERIAL_NON_SPECIFIC;
		
	else if (iRoll <= (FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC +
					   FW_PROB_ARMOR_MATERIAL_ADAMANTINE))
					  
		return FW_MATERIAL_ADAMANTINE;
		
	else if (iRoll <= (FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC +
					   FW_PROB_ARMOR_MATERIAL_ADAMANTINE +
					   FW_PROB_ARMOR_MATERIAL_DARKSTEEL))
					  
		return FW_MATERIAL_DARK_STEEL;
		
	else if (iRoll <= (FW_PROB_ARMOR_MATERIAL_NON_SPECIFIC +
					   FW_PROB_ARMOR_MATERIAL_ADAMANTINE +
					   FW_PROB_ARMOR_MATERIAL_DARKSTEEL +
					   FW_PROB_ARMOR_MATERIAL_IRON))
					  
		return FW_MATERIAL_IRON;
		
	else    
		return FW_MATERIAL_MITHRAL;
}

//////////////////////////////////////////
// * Function that decides what metal weapon material type drops.
//
int FW_WhatMetalWeaponMaterial ()
{
	int nTotalProbability = FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC +
							FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON +
							FW_PROB_METAL_WEAP_MATERIAL_DARKSTEEL +
							FW_PROB_METAL_WEAP_MATERIAL_ALCHEMICAL_SILVER +
							FW_PROB_METAL_WEAP_MATERIAL_ADAMANTINE +
							FW_PROB_METAL_WEAP_MATERIAL_MITHRAL ;
							
	int iRoll = Random (nTotalProbability) + 1;
	
	
	if      (iRoll <= (FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC))
	
		return FW_MATERIAL_NON_SPECIFIC;
	
	else if (iRoll <= (FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC +
					   FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON))
	
		return FW_MATERIAL_COLD_IRON;
	
	else if (iRoll <= (FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC +
					   FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON +
					   FW_PROB_METAL_WEAP_MATERIAL_DARKSTEEL ))
	
		return FW_MATERIAL_DARK_STEEL;

	else if (iRoll <= (FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC +
					   FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON +
					   FW_PROB_METAL_WEAP_MATERIAL_DARKSTEEL +
					   FW_PROB_METAL_WEAP_MATERIAL_ALCHEMICAL_SILVER ))
	
		return FW_MATERIAL_ALCHEMICAL_SILVER;

	else if (iRoll <= (FW_PROB_METAL_WEAP_MATERIAL_NON_SPECIFIC +
					   FW_PROB_METAL_WEAP_MATERIAL_COLD_IRON +
					   FW_PROB_METAL_WEAP_MATERIAL_DARKSTEEL +
					   FW_PROB_METAL_WEAP_MATERIAL_ALCHEMICAL_SILVER +
					   FW_PROB_METAL_WEAP_MATERIAL_ADAMANTINE ))
	
		return FW_MATERIAL_ADAMANTINE;

	else 
	
		return FW_MATERIAL_MITHRAL;
}

//////////////////////////////////////////
// * Function that decides what wooden weapon material type drops.
//
int FW_WhatWoodWeaponMaterial ()
{
	int nTotalProbability = FW_PROB_WOOD_WEAP_MATERIAL_NON_SPECIFIC +
							FW_PROB_WOOD_WEAP_MATERIAL_DUSKWOOD +
							FW_PROB_WOOD_WEAP_MATERIAL_ZALANTAR;
							
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <= (FW_PROB_WOOD_WEAP_MATERIAL_NON_SPECIFIC))
	
		return FW_MATERIAL_NON_SPECIFIC;

	else if (iRoll <= (FW_PROB_WOOD_WEAP_MATERIAL_NON_SPECIFIC +
					   FW_PROB_WOOD_WEAP_MATERIAL_DUSKWOOD))
					   
		return FW_MATERIAL_DUSKWOOD;
	
	else  
	
		return FW_MATERIAL_ZALANTAR;		
}

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Aberration ()
{	
	int nTotalProbability = 
		FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT    + FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING + FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS     + FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER    + FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION + 
		FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL   + FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_ABERRATION_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED + FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN + FW_PROB_ABERRATION_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
		
	else if (iRoll <=  (FW_PROB_ABERRATION_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_POTION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_OTHER +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GEMS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ABERRATION_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ABERRATION_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_ABERRATION_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
		
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Animal ()
{	
	int nTotalProbability = 
		FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT    + FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING + FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS     + FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER    + FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION + 
		FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL   + FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_ANIMAL_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED + FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN + FW_PROB_ANIMAL_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
		
	else if (iRoll <=  (FW_PROB_ANIMAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ANIMAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ANIMAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_ANIMAL_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
		
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Beast ()
{	
	int nTotalProbability = 
		FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT    + FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING + FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_BEAST_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_BEAST_TREAS_CAT_MISC_GEMS     + FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
		FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_BEAST_TREAS_CAT_MISC_OTHER    + FW_PROB_BEAST_TREAS_CAT_MISC_POTION + 
		FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL   + FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_BEAST_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED + FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN + FW_PROB_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_BEAST_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
    			
	else if (iRoll <=  (FW_PROB_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
		
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Construct ()
{	
	int nTotalProbability = 
		FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT    + FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS     + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER    + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION + 
		FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL   + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED + FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN + FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_POTION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_OTHER +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GEMS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_CONSTRUCT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_CONSTRUCT_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_CONSTRUCT_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
				
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Dragon ()
{	
	int nTotalProbability = 
		FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT    + FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING + FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS     + FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER    + FW_PROB_DRAGON_TREAS_CAT_MISC_POTION + 
		FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL   + FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_DRAGON_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_DRAGON_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED + FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN + FW_PROB_DRAGON_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_DRAGON_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DRAGON_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_POTION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DRAGON_TREAS_CAT_MISC_OTHER +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DRAGON_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GEMS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DRAGON_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DRAGON_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DRAGON_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DRAGON_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DRAGON_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_DRAGON_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
				
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Dwarf ()
{	
	int nTotalProbability = 
		FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT    + FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING + FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_DWARF_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_DWARF_TREAS_CAT_MISC_GEMS     + FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
		FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_DWARF_TREAS_CAT_MISC_OTHER    + FW_PROB_DWARF_TREAS_CAT_MISC_POTION + 
		FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL   + FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_DWARF_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_DWARF_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED + FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN + FW_PROB_DWARF_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_DWARF_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_DWARF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DWARF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DWARF_TREAS_CAT_MISC_POTION +
						FW_PROB_DWARF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DWARF_TREAS_CAT_MISC_OTHER +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DWARF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DWARF_TREAS_CAT_MISC_GEMS +
						FW_PROB_DWARF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DWARF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DWARF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DWARF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DWARF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DWARF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DWARF_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_DWARF_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
				
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Elemental ()
{	
	int nTotalProbability = 
		FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT    + FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS     + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER    + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION + 
		FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL   + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED + FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN + FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_POTION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELEMENTAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ELEMENTAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_ELEMENTAL_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
				
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Elf ()
{	
	int nTotalProbability = 
		FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT    + FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_ELF_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING + FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_ELF_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_ELF_TREAS_CAT_MISC_GEMS     + FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
		FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_ELF_TREAS_CAT_MISC_OTHER    + FW_PROB_ELF_TREAS_CAT_MISC_POTION + 
		FW_PROB_ELF_TREAS_CAT_MISC_SCROLL   + FW_PROB_ELF_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_ELF_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_ELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED + FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN + FW_PROB_ELF_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_ELF_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELF_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_ELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_ELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_ELF_TREAS_CAT_MISC_POTION +
						FW_PROB_ELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_ELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_ELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_ELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_ELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_ELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_ELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_ELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_ELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_ELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_ELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_ELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_ELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_ELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_ELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_ELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_ELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_ELF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_ELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_ELF_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
		
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Fey ()
{	
	int nTotalProbability = 
		FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT    + FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_FEY_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING + FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_FEY_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_FEY_TREAS_CAT_MISC_GEMS     + FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
		FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_FEY_TREAS_CAT_MISC_OTHER    + FW_PROB_FEY_TREAS_CAT_MISC_POTION + 
		FW_PROB_FEY_TREAS_CAT_MISC_SCROLL   + FW_PROB_FEY_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_FEY_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_FEY_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED + FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN + FW_PROB_FEY_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_FEY_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_FEY_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_FEY_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_FEY_TREAS_CAT_MISC_GOLD + 
						FW_PROB_FEY_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_FEY_TREAS_CAT_MISC_POTION +
						FW_PROB_FEY_TREAS_CAT_MISC_SCROLL +
						FW_PROB_FEY_TREAS_CAT_MISC_OTHER +
						FW_PROB_FEY_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_FEY_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_FEY_TREAS_CAT_MISC_BOOKS +
						FW_PROB_FEY_TREAS_CAT_MISC_GEMS +
						FW_PROB_FEY_TREAS_CAT_MISC_TRAPS +
						FW_PROB_FEY_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_FEY_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_FEY_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_FEY_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_FEY_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_FEY_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_FEY_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_FEY_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_FEY_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_FEY_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_FEY_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_FEY_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_FEY_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
				
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Giant ()
{	
	int nTotalProbability = 
		FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT    + FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING + FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_GIANT_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_GIANT_TREAS_CAT_MISC_GEMS     + FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
		FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_GIANT_TREAS_CAT_MISC_OTHER    + FW_PROB_GIANT_TREAS_CAT_MISC_POTION + 
		FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL   + FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_GIANT_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_GIANT_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED + FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN + FW_PROB_GIANT_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_GIANT_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_GIANT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GIANT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GIANT_TREAS_CAT_MISC_POTION +
						FW_PROB_GIANT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GIANT_TREAS_CAT_MISC_OTHER +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GIANT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GIANT_TREAS_CAT_MISC_GEMS +
						FW_PROB_GIANT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GIANT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GIANT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GIANT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GIANT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GIANT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_GIANT_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_GIANT_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Gnome ()
{	
	int nTotalProbability = 
		FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT    + FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING + FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_GNOME_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_GNOME_TREAS_CAT_MISC_GEMS     + FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
		FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_GNOME_TREAS_CAT_MISC_OTHER    + FW_PROB_GNOME_TREAS_CAT_MISC_POTION + 
		FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL   + FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_GNOME_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_GNOME_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED + FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN + FW_PROB_GNOME_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_GNOME_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_GNOME_TREAS_CAT_MISC_GOLD + 
						FW_PROB_GNOME_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_GNOME_TREAS_CAT_MISC_POTION +
						FW_PROB_GNOME_TREAS_CAT_MISC_SCROLL +
						FW_PROB_GNOME_TREAS_CAT_MISC_OTHER +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_GNOME_TREAS_CAT_MISC_BOOKS +
						FW_PROB_GNOME_TREAS_CAT_MISC_GEMS +
						FW_PROB_GNOME_TREAS_CAT_MISC_TRAPS +
						FW_PROB_GNOME_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_GNOME_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_GNOME_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_GNOME_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_GNOME_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_GNOME_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_GNOME_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halfelf ()
{	
	int nTotalProbability = 
		FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING + FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS     + FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER    + FW_PROB_HALFELF_TREAS_CAT_MISC_POTION + 
		FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL   + FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HALFELF_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HALFELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED + FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN + FW_PROB_HALFELF_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HALFELF_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFELF_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFELF_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFELF_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFELF_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFELF_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFELF_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFELF_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFELF_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HALFELF_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halfling ()
{	
	int nTotalProbability = 
		FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING + FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS     + FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER    + FW_PROB_HALFLING_TREAS_CAT_MISC_POTION + 
		FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL   + FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HALFLING_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HALFLING_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED + FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN + FW_PROB_HALFLING_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HALFLING_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFLING_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFLING_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFLING_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFLING_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFLING_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFLING_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFLING_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFLING_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HALFLING_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Halforc ()
{	
	int nTotalProbability = 
		FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING + FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS     + FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER    + FW_PROB_HALFORC_TREAS_CAT_MISC_POTION + 
		FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL   + FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HALFORC_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HALFORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED + FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN + FW_PROB_HALFORC_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HALFORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HALFORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HALFORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HALFORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HALFORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HALFORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HALFORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HALFORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HALFORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HALFORC_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Human ()
{	
	int nTotalProbability = 
		FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING + FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS     + FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER    + FW_PROB_HUMAN_TREAS_CAT_MISC_POTION + 
		FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL   + FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HUMAN_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HUMAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED + FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN + FW_PROB_HUMAN_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HUMAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HUMAN_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Goblinoid ()
{	
	int nTotalProbability = 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS     + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER    + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL   + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN + FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HUMANOID_GOBLINOID_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Monstrous ()
{	
	int nTotalProbability = 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS     + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER    + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL   + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN + FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HUMANOID_MONSTROUS_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Orc ()
{	
	int nTotalProbability = 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS     + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER    + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL   + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED + FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN + FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HUMANOID_ORC_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Humanoid_Reptilian ()
{	
	int nTotalProbability = 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT    + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS     + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER    + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL   + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN + FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_POTION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_OTHER +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GEMS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_HUMANOID_REPTILIAN_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Incorporeal ()
{	
	int nTotalProbability = 
		FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT    + FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS     + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER    + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION + 
		FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL   + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED + FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN + FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GOLD + 
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_POTION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_SCROLL +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_OTHER +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_BOOKS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GEMS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_TRAPS +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_INCORPOREAL_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_INCORPOREAL_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_INCORPOREAL_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Magical_Beast ()
{	
	int nTotalProbability = 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT    + FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS     + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER    + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL   + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED + FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN + FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GOLD + 
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_POTION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_SCROLL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_OTHER +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_BOOKS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GEMS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_TRAPS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_MAGICAL_BEAST_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Ooze ()
{	
	int nTotalProbability = 
		FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT    + FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING + FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_OOZE_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_OOZE_TREAS_CAT_MISC_GEMS     + FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
		FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_OOZE_TREAS_CAT_MISC_OTHER    + FW_PROB_OOZE_TREAS_CAT_MISC_POTION + 
		FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL   + FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_OOZE_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_OOZE_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED + FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN + FW_PROB_OOZE_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_OOZE_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_OOZE_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OOZE_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OOZE_TREAS_CAT_MISC_POTION +
						FW_PROB_OOZE_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OOZE_TREAS_CAT_MISC_OTHER +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OOZE_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OOZE_TREAS_CAT_MISC_GEMS +
						FW_PROB_OOZE_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OOZE_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OOZE_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OOZE_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OOZE_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OOZE_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_OOZE_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_OOZE_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Outsider ()
{	
	int nTotalProbability = 
		FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT    + FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING + FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS     + FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER    + FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION + 
		FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL   + FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED + FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN + FW_PROB_OUTSIDER_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_OUTSIDER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_POTION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_OTHER +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GEMS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_OUTSIDER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_OUTSIDER_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_OUTSIDER_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Shapechanger ()
{	
	int nTotalProbability = 
		FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT    + FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS     + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER    + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL   + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED + FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN + FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GOLD + 
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_POTION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_SCROLL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_OTHER +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_BOOKS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GEMS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_TRAPS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_SHAPECHANGER_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_SHAPECHANGER_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_SHAPECHANGER_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Undead ()
{	
	int nTotalProbability = 
		FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT    + FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING + FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS     + FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER    + FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION + 
		FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL   + FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_UNDEAD_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED + FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN + FW_PROB_UNDEAD_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_UNDEAD_TREAS_CAT_MISC_GOLD + 
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_POTION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_SCROLL +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_OTHER +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_BOOKS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GEMS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_TRAPS +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_UNDEAD_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_UNDEAD_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_UNDEAD_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function

//////////////////////////////////////////
// * Function that chooses race appropriate loot to drop.   
//
int FW_Race_Loot_Vermin ()
{	
	int nTotalProbability = 
		FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT    + FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING + FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS     + FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER    + FW_PROB_VERMIN_TREAS_CAT_MISC_POTION + 
		FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL   + FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_VERMIN_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_VERMIN_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED + FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN + FW_PROB_VERMIN_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
			
	else if (iRoll <=  (FW_PROB_VERMIN_TREAS_CAT_MISC_GOLD + 
						FW_PROB_VERMIN_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_POTION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_SCROLL +
						FW_PROB_VERMIN_TREAS_CAT_MISC_OTHER +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_VERMIN_TREAS_CAT_MISC_BOOKS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GEMS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_TRAPS +
						FW_PROB_VERMIN_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_VERMIN_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_VERMIN_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_VERMIN_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_VERMIN_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_VERMIN_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;
			
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function



// *****************************************
//              IMPLEMENTATION
//
//			   DON'T CHANGE THIS
// *****************************************

////////////////////////////////////////////
// * Function that returns the loot category of item to be dropped.
// * returns a FW_MISC_*  or FW_ARMOR_* or FW_WEAPON_* constant.
//
int FW_Get_Racial_Loot_Category()
{
   int nRacialType = GetRacialType(OBJECT_SELF);   
   int nLootType;
   
   switch (nRacialType)
   {
		case RACIAL_TYPE_ABERRATION: nLootType = FW_Race_Loot_Aberration();
			break;
		case RACIAL_TYPE_ANIMAL: nLootType =  FW_Race_Loot_Animal();
			break;
		case RACIAL_TYPE_BEAST: nLootType =  FW_Race_Loot_Beast();
			break;
		case RACIAL_TYPE_CONSTRUCT: nLootType = FW_Race_Loot_Construct();
			break;
		case RACIAL_TYPE_DRAGON: nLootType = FW_Race_Loot_Dragon();
			break;
		case RACIAL_TYPE_DWARF: nLootType = FW_Race_Loot_Dwarf();
			break;
		case RACIAL_TYPE_ELEMENTAL: nLootType = FW_Race_Loot_Elemental();
			break;
		case RACIAL_TYPE_ELF: nLootType = FW_Race_Loot_Elf();
			break;
		case RACIAL_TYPE_FEY: nLootType = FW_Race_Loot_Fey();
			break;
		case RACIAL_TYPE_GIANT: nLootType = FW_Race_Loot_Giant();
			break;
		case RACIAL_TYPE_GNOME: nLootType = FW_Race_Loot_Gnome();
			break;
		case RACIAL_TYPE_HALFELF: nLootType = FW_Race_Loot_Halfelf();
			break;
		case RACIAL_TYPE_HALFLING: nLootType = FW_Race_Loot_Halfling();
			break;
		case RACIAL_TYPE_HALFORC: nLootType = FW_Race_Loot_Halforc();
			break;
		case RACIAL_TYPE_HUMAN: nLootType = FW_Race_Loot_Human();
			break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID: nLootType = FW_Race_Loot_Humanoid_Goblinoid();
			break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS: nLootType = FW_Race_Loot_Humanoid_Monstrous();
			break;
		case RACIAL_TYPE_HUMANOID_ORC: nLootType = FW_Race_Loot_Humanoid_Orc();
			break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN: nLootType = FW_Race_Loot_Humanoid_Reptilian();
			break;
		case RACIAL_TYPE_INCORPOREAL: nLootType = FW_Race_Loot_Incorporeal();
			break;
		case RACIAL_TYPE_MAGICAL_BEAST: nLootType =  FW_Race_Loot_Magical_Beast();
			break;
		case RACIAL_TYPE_OOZE: nLootType = FW_Race_Loot_Ooze();
			break;
		case RACIAL_TYPE_OUTSIDER: nLootType = FW_Race_Loot_Outsider();
			break;
		case RACIAL_TYPE_SHAPECHANGER: nLootType = FW_Race_Loot_Shapechanger();
			break;
		case RACIAL_TYPE_UNDEAD: nLootType = FW_Race_Loot_Undead();
			break;
		case RACIAL_TYPE_VERMIN: nLootType = FW_Race_Loot_Vermin();
			break;
		// Gold is always safe to give.
		default: nLootType = FW_MISC_GOLD;
			break;
   }
   return nLootType;
} // end of function.

//////////////////////////////////////////
// * Function that weights the type of loot that drops to make exotic/rarer
// * types of loot drop less often. This is the default that is used only 
// * when the switch that allows racial specific loot drops is set to FALSE.   
//
int FW_Get_Default_Loot_Category ()
{	
	int nTotalProbability = 
		FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT    + FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING + 
		FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY   + FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
		FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT   + FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM + 
		FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS + FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING + FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_DAMAGE_SHIELD + FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS     + FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT + FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER    + FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION + 
		FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL   + FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS + 
		FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION + FW_PROB_DEFAULT_TREAS_CAT_WEAPON_EXOTIC + 
		FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MAGE_SPECIFIC + FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL + 
		FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED + FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE + 
		FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN + FW_PROB_DEFAULT_TREAS_CAT_MISC_CUSTOM_ITEM;  
		
	int iRoll = Random (nTotalProbability) + 1;
	
	if      (iRoll <=   FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD)
	
		return FW_MISC_GOLD;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL))
	
		return FW_MISC_CRAFTING_MATERIAL;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION))
	
		return FW_MISC_POTION;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL))
	
		return FW_MISC_SCROLL;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER))
	
		return FW_MISC_OTHER;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN))
	
		return FW_WEAPON_THROWN;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION))
	
		return FW_WEAPON_AMMUNITION;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS))
	
		return FW_MISC_BOOKS;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS))
	
		return FW_MISC_GEMS;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS))
	
		return FW_MISC_TRAPS;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT))
	
		return FW_MISC_HEAL_KIT;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING))
	
		return FW_ARMOR_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT))
	
		return FW_ARMOR_BOOT;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING ))
	
		return FW_MISC_CLOTHING;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY))
	
		return FW_MISC_JEWELRY;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT))
	
		return FW_ARMOR_LIGHT;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET))
	
		return FW_ARMOR_HELMET;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE))
	
		return FW_WEAPON_SIMPLE;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET))
	
		return FW_MISC_GAUNTLET;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM))
	
		return FW_ARMOR_MEDIUM;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS))
	
		return FW_ARMOR_SHIELDS;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL))
	
		return FW_WEAPON_MARTIAL;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED))
	
		return FW_WEAPON_RANGED;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY))
	
		return FW_ARMOR_HEAVY;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_EXOTIC))
	
		return FW_WEAPON_EXOTIC;
		
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MAGE_SPECIFIC))
						
		return FW_WEAPON_MAGE_SPECIFIC;
	
	else if (iRoll <=  (FW_PROB_DEFAULT_TREAS_CAT_MISC_GOLD + 
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CRAFTING_MATERIAL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_POTION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_SCROLL +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_OTHER +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_THROWN +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_AMMUNITION +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_BOOKS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GEMS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_TRAPS +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_HEAL_KIT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_BOOT +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CLOTHING +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_JEWELRY +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_LIGHT +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HELMET +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_SIMPLE +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_GAUNTLET +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_MEDIUM +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_SHIELDS +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MARTIAL +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_RANGED +
						FW_PROB_DEFAULT_TREAS_CAT_ARMOR_HEAVY +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_EXOTIC +
						FW_PROB_DEFAULT_TREAS_CAT_WEAPON_MAGE_SPECIFIC +
						FW_PROB_DEFAULT_TREAS_CAT_MISC_CUSTOM_ITEM))
						
		return FW_MISC_CUSTOM_ITEM;	
		
	else // We rolled a damage shield, the rarest of all items.
	
		return FW_MISC_DAMAGE_SHIELD;
} // end of function




///////////////////////////////////////////////
//			FUNCTION IMPLEMENTATION
//			  DON'T CHANGE THESE
///////////////////////////////////////////////

//////////////////////////////////////////////
// * This function looks up the maximum overall Gold Piece value
// * an item could have, as defined in the constants:
// * FW_MAX_ITEM_VALUE_CR_* where * = the CR of the spawning
// * monster.
//
int FW_GetMaxItemValue (int nCR = 0)
{
	int nReturnValue;
	
	if (nCR < 0)
		nCR = 0;
	if (nCR > 41)
		nCR = 41;
	
	switch (nCR)
	{
		case 0: nReturnValue = FW_MAX_ITEM_VALUE_CR_0;
			break;
			
		case 1: nReturnValue = FW_MAX_ITEM_VALUE_CR_1;
			break;
		case 2: nReturnValue = FW_MAX_ITEM_VALUE_CR_2;
			break;
		case 3: nReturnValue = FW_MAX_ITEM_VALUE_CR_3;
			break;
		case 4: nReturnValue = FW_MAX_ITEM_VALUE_CR_4;
			break;
		case 5: nReturnValue = FW_MAX_ITEM_VALUE_CR_5;
			break;
		case 6: nReturnValue = FW_MAX_ITEM_VALUE_CR_6;
			break;
		case 7: nReturnValue = FW_MAX_ITEM_VALUE_CR_7;
			break;
		case 8: nReturnValue = FW_MAX_ITEM_VALUE_CR_8;
			break;
		case 9: nReturnValue = FW_MAX_ITEM_VALUE_CR_9;
			break;
		case 10: nReturnValue = FW_MAX_ITEM_VALUE_CR_10;
			break;
		
		case 11: nReturnValue = FW_MAX_ITEM_VALUE_CR_11;
			break;
		case 12: nReturnValue = FW_MAX_ITEM_VALUE_CR_12;
			break;
		case 13: nReturnValue = FW_MAX_ITEM_VALUE_CR_13;
			break;
		case 14: nReturnValue = FW_MAX_ITEM_VALUE_CR_14;
			break;
		case 15: nReturnValue = FW_MAX_ITEM_VALUE_CR_15;
			break;
		case 16: nReturnValue = FW_MAX_ITEM_VALUE_CR_16;
			break;
		case 17: nReturnValue = FW_MAX_ITEM_VALUE_CR_17;
			break;
		case 18: nReturnValue = FW_MAX_ITEM_VALUE_CR_18;
			break;
		case 19: nReturnValue = FW_MAX_ITEM_VALUE_CR_19;
			break;
		case 20: nReturnValue = FW_MAX_ITEM_VALUE_CR_20;
			break;
		
		case 21: nReturnValue = FW_MAX_ITEM_VALUE_CR_21;
			break;
		case 22: nReturnValue = FW_MAX_ITEM_VALUE_CR_22;
			break;
		case 23: nReturnValue = FW_MAX_ITEM_VALUE_CR_23;
			break;
		case 24: nReturnValue = FW_MAX_ITEM_VALUE_CR_24;
			break;
		case 25: nReturnValue = FW_MAX_ITEM_VALUE_CR_25;
			break;
		case 26: nReturnValue = FW_MAX_ITEM_VALUE_CR_26;
			break;
		case 27: nReturnValue = FW_MAX_ITEM_VALUE_CR_27;
			break;
		case 28: nReturnValue = FW_MAX_ITEM_VALUE_CR_28;
			break;
		case 29: nReturnValue = FW_MAX_ITEM_VALUE_CR_29;
			break;
		case 30: nReturnValue = FW_MAX_ITEM_VALUE_CR_30;
			break;
		
		case 31: nReturnValue = FW_MAX_ITEM_VALUE_CR_31;
			break;
		case 32: nReturnValue = FW_MAX_ITEM_VALUE_CR_32;
			break;
		case 33: nReturnValue = FW_MAX_ITEM_VALUE_CR_33;
			break;
		case 34: nReturnValue = FW_MAX_ITEM_VALUE_CR_34;
			break;
		case 35: nReturnValue = FW_MAX_ITEM_VALUE_CR_35;
			break;
		case 36: nReturnValue = FW_MAX_ITEM_VALUE_CR_36;
			break;
		case 37: nReturnValue = FW_MAX_ITEM_VALUE_CR_37;
			break;
		case 38: nReturnValue = FW_MAX_ITEM_VALUE_CR_38;
			break;
		case 39: nReturnValue = FW_MAX_ITEM_VALUE_CR_39;
			break;
		case 40: nReturnValue = FW_MAX_ITEM_VALUE_CR_40;
			break;
		
		case 41: nReturnValue = FW_MAX_ITEM_VALUE_CR_41_OR_HIGHER;
	}
	return nReturnValue;
}

//////////////////////////////////////////////
// * This function checks to see if the item chosen by the random
// * loot generator is less than the allowable GP limit for the
// * spawning monster.  If the Item is too expensive for the CR of
// * the monster, then this returns TRUE (and the loot generator
// * will reroll a new item).  If the item is within appropriate
// * GP limits then this returns FALSE.
//
int FW_IsItemRolledTooExpensive (object oItem, int nCR = 0)
{
	int nMaxItemValue = FW_GetMaxItemValue(nCR);
	int nItemGPValue = GetGoldPieceValue (oItem);
	
	if (nItemGPValue > nMaxItemValue)
	{
		return TRUE;
	}
	return FALSE;
}



// *****************************************
//              IMPLEMENTATION
// *****************************************

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGEBONUS_* from min to max.
// * NOT to be confused with DAMAGE_BONUS_* (used for damage shields)
//
// TABLE: IP_CONST_DAMAGEBONUS
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
int FW_Choose_IP_CONST_DAMAGEBONUS (int min, int max)
{   
   int iRoll;
   int iDamage;
   if (min < 0)
      min = 0;
   if (min > 19)
      min = 19;
   if (max < 0)
      max = 0;
   if (max > 19)
      max = 19;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
   {
      iDamage = IP_CONST_DAMAGEBONUS_1;
   }
   else
   {
      int iValue = max - min + 1;
      iRoll = Random(iValue)+ min;
   }

   switch (iRoll)
   {
      case 0: iDamage = IP_CONST_DAMAGEBONUS_1;
         break;
      case 1: iDamage = IP_CONST_DAMAGEBONUS_2;
         break;
      case 2: iDamage = IP_CONST_DAMAGEBONUS_1d4;
         break;
      case 3: iDamage = IP_CONST_DAMAGEBONUS_3;
         break;
      case 4: iDamage = IP_CONST_DAMAGEBONUS_1d6;
         break;
      case 5: iDamage = IP_CONST_DAMAGEBONUS_4;
         break;
      case 6: iDamage = IP_CONST_DAMAGEBONUS_1d8;
         break;
      case 7: iDamage = IP_CONST_DAMAGEBONUS_5;
         break;
      case 8: iDamage = IP_CONST_DAMAGEBONUS_2d4;
         break;
      case 9: iDamage = IP_CONST_DAMAGEBONUS_1d10;
         break;
      case 10: iDamage = IP_CONST_DAMAGEBONUS_6;
         break;
      case 11: iDamage = IP_CONST_DAMAGEBONUS_1d12;
         break;
      case 12: iDamage = IP_CONST_DAMAGEBONUS_7;
         break;
      case 13: iDamage = IP_CONST_DAMAGEBONUS_2d6;
         break;
      case 14: iDamage = IP_CONST_DAMAGEBONUS_8;
         break;
      case 15: iDamage = IP_CONST_DAMAGEBONUS_9;
         break;
      case 16: iDamage = IP_CONST_DAMAGEBONUS_2d8;
         break;
      case 17: iDamage = IP_CONST_DAMAGEBONUS_10;
         break;
      case 18: iDamage = IP_CONST_DAMAGEBONUS_2d10;
         break;
      case 19: iDamage = IP_CONST_DAMAGEBONUS_2d12;
         break;
      default: break;
   }
   return iDamage;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGETYPE_*
//
int FW_Choose_IP_CONST_DAMAGETYPE ()
{
   int iDamageType;
   int iRoll = Random (12);
   switch (iRoll)
   {
      case 0: iDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
         break;
      case 1: iDamageType = IP_CONST_DAMAGETYPE_PIERCING;
         break;
      case 2: iDamageType = IP_CONST_DAMAGETYPE_SLASHING;
         break;
      case 3: iDamageType = IP_CONST_DAMAGETYPE_ACID;
         break;
      case 4: iDamageType = IP_CONST_DAMAGETYPE_COLD;
         break;
      case 5: iDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
         break;
      case 6: iDamageType = IP_CONST_DAMAGETYPE_FIRE;
         break;
      case 7: iDamageType = IP_CONST_DAMAGETYPE_SONIC;
         break;
      case 8: iDamageType = IP_CONST_DAMAGETYPE_NEGATIVE;
         break;
      case 9: iDamageType = IP_CONST_DAMAGETYPE_POSITIVE;
         break;
      case 10: iDamageType = IP_CONST_DAMAGETYPE_DIVINE;
         break;
      case 11: iDamageType = IP_CONST_DAMAGETYPE_MAGICAL;
         break;
      default: break;
   }
   return iDamageType;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_ALIGNMENTGROUP_*
//
int FW_Choose_IP_CONST_ALIGNMENTGROUP ()
{
   int nAlignGroup;
   int iRoll = Random (6);
   switch (iRoll)
   {
      case 0: nAlignGroup = IP_CONST_ALIGNMENTGROUP_ALL;
         break;
      case 1: nAlignGroup = IP_CONST_ALIGNMENTGROUP_CHAOTIC;
         break;
      case 2: nAlignGroup = IP_CONST_ALIGNMENTGROUP_EVIL;
         break;
      case 3: nAlignGroup = IP_CONST_ALIGNMENTGROUP_GOOD;
         break;
      case 4: nAlignGroup = IP_CONST_ALIGNMENTGROUP_LAWFUL;
         break;
      case 5: nAlignGroup = IP_CONST_ALIGNMENTGROUP_NEUTRAL;
         break;
      default: break;
   } // end of switch
   return nAlignGroup;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_RACIALTYPE_*
//
int FW_Choose_IP_CONST_RACIALTYPE ()
{
   int nRace;
   int iRoll = Random (24);
   switch (iRoll)
   {
      case 0: nRace = IP_CONST_RACIALTYPE_ABERRATION;
         break;
      case 1: nRace = IP_CONST_RACIALTYPE_ANIMAL;
         break;
      case 2: nRace = IP_CONST_RACIALTYPE_BEAST;
         break;
      case 3: nRace = IP_CONST_RACIALTYPE_CONSTRUCT;
         break;
      case 4: nRace = IP_CONST_RACIALTYPE_DRAGON;
         break;
      case 5: nRace = IP_CONST_RACIALTYPE_DWARF;
         break;
      case 6: nRace = IP_CONST_RACIALTYPE_ELEMENTAL;
         break;
      case 7: nRace = IP_CONST_RACIALTYPE_ELF;
         break;
      case 8: nRace = IP_CONST_RACIALTYPE_FEY;
         break;
      case 9: nRace = IP_CONST_RACIALTYPE_GIANT;
         break;
      case 10: nRace = IP_CONST_RACIALTYPE_GNOME;
         break;
      case 11: nRace = IP_CONST_RACIALTYPE_HALFELF;
         break;
      case 12: nRace = IP_CONST_RACIALTYPE_HALFLING;
         break;
      case 13: nRace = IP_CONST_RACIALTYPE_HALFORC;
         break;
      case 14: nRace = IP_CONST_RACIALTYPE_HUMAN;
         break;
      case 15: nRace = IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID;
         break;
      case 16: nRace = IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS;
         break;
      case 17: nRace = IP_CONST_RACIALTYPE_HUMANOID_ORC;
         break;
      case 18: nRace = IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN;
         break;
      case 19: nRace = IP_CONST_RACIALTYPE_MAGICAL_BEAST;
         break;
      case 20: nRace = IP_CONST_RACIALTYPE_OUTSIDER;
         break;
      case 21: nRace = IP_CONST_RACIALTYPE_SHAPECHANGER;
         break;
      case 22: nRace = IP_CONST_RACIALTYPE_UNDEAD;
         break;
      case 23: nRace = IP_CONST_RACIALTYPE_VERMIN;
         break;
      default: break;
   } // end of switch
   return nRace;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_ALIGNMENT_*
//
int FW_Choose_IP_CONST_SALIGN ()
{
   int nAlign;
   int iRoll = Random (9);
   switch (iRoll)
   {
      case 0: nAlign = IP_CONST_ALIGNMENT_CE;
         break;
      case 1: nAlign = IP_CONST_ALIGNMENT_CG;
         break;
      case 2: nAlign = IP_CONST_ALIGNMENT_CN;
         break;
      case 3: nAlign = IP_CONST_ALIGNMENT_LE;
         break;
      case 4: nAlign = IP_CONST_ALIGNMENT_LG;
         break;
      case 5: nAlign = IP_CONST_ALIGNMENT_LN;
         break;
      case 6: nAlign = IP_CONST_ALIGNMENT_NE;
         break;
      case 7: nAlign = IP_CONST_ALIGNMENT_NG;
         break;
      case 8: nAlign = IP_CONST_ALIGNMENT_TN;
         break;
      default: break;
   } // end of switch
   return nAlign;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_CLASS_*
//
int FW_Choose_IP_CONST_CLASS ()
{
   int iClass;
   int iRoll = Random (11);
   switch (iRoll)
   {
      case 0: iClass = IP_CONST_CLASS_BARBARIAN;
         break;
      case 1: iClass = IP_CONST_CLASS_BARD;
         break;
      case 2: iClass = IP_CONST_CLASS_CLERIC;
         break;
      case 3: iClass = IP_CONST_CLASS_DRUID;
         break;
      case 4: iClass = IP_CONST_CLASS_FIGHTER;
         break;
      case 5: iClass = IP_CONST_CLASS_MONK;
         break;
      case 6: iClass = IP_CONST_CLASS_PALADIN;
         break;
      case 7: iClass = IP_CONST_CLASS_RANGER;
         break;
      case 8: iClass = IP_CONST_CLASS_ROGUE;
         break;
      case 9: iClass = IP_CONST_CLASS_SORCERER;
         break;
      case 10: iClass = IP_CONST_CLASS_WIZARD;
         break;
      default: break;
   } // end of switch
   return iClass;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGEREDUCTION_* subject to
// * min and max values. Acceptable values for min and max are: 1,2,3,...,20
//
int FW_Choose_IP_CONST_DAMAGEREDUCTION (int min, int max)
{
   itemproperty ipAdd;
   
   int iRoll;
   int nReturnValue;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nReturnValue = IP_CONST_DAMAGEREDUCTION_1;  }
   else
   {
      int iValue = max - min + 1;
      iRoll = Random(iValue) + min;
   }
   switch (iRoll)
   {
      case 1: nReturnValue = IP_CONST_DAMAGEREDUCTION_1;
         break;
      case 2: nReturnValue = IP_CONST_DAMAGEREDUCTION_2;
         break;
      case 3: nReturnValue = IP_CONST_DAMAGEREDUCTION_3;
         break;
      case 4: nReturnValue = IP_CONST_DAMAGEREDUCTION_4;
         break;
      case 5: nReturnValue = IP_CONST_DAMAGEREDUCTION_5;
         break;
      case 6: nReturnValue = IP_CONST_DAMAGEREDUCTION_6;
         break;
      case 7: nReturnValue = IP_CONST_DAMAGEREDUCTION_7;
         break;
      case 8: nReturnValue = IP_CONST_DAMAGEREDUCTION_8;
         break;
      case 9: nReturnValue = IP_CONST_DAMAGEREDUCTION_9;
         break;
      case 10: nReturnValue = IP_CONST_DAMAGEREDUCTION_10;
         break;
      case 11: nReturnValue = IP_CONST_DAMAGEREDUCTION_11;
         break;
      case 12: nReturnValue = IP_CONST_DAMAGEREDUCTION_12;
         break;
      case 13: nReturnValue = IP_CONST_DAMAGEREDUCTION_13;
         break;
      case 14: nReturnValue = IP_CONST_DAMAGEREDUCTION_14;
         break;
      case 15: nReturnValue = IP_CONST_DAMAGEREDUCTION_15;
         break;
      case 16: nReturnValue = IP_CONST_DAMAGEREDUCTION_16;
         break;
      case 17: nReturnValue = IP_CONST_DAMAGEREDUCTION_17;
         break;
      case 18: nReturnValue = IP_CONST_DAMAGEREDUCTION_18;
         break;
      case 19: nReturnValue = IP_CONST_DAMAGEREDUCTION_19;
         break;
      case 20: nReturnValue = IP_CONST_DAMAGEREDUCTION_20;
         break;

      default: nReturnValue = IP_CONST_DAMAGEREDUCTION_1;
         break;
   }// end of switch
   return nReturnValue;
}

////////////////////////////////////////////
// * Function that randomly chooses an IP_CONST_DAMAGESOAK_* subject to min and
// * max values.  Acceptable values for min and max are: 5,10,15,...,50
//
int FW_Choose_IP_CONST_DAMAGESOAK (int min, int max)
{
   itemproperty ipAdd;
   
   int iRoll;
   int nReturnValue;
   if (min < 5)
      min = 5;
   if (min > 50)
      min = 50;
   if (max < 5)
      max = 5;
   if (max > 50)
      max = 50;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nReturnValue = IP_CONST_DAMAGESOAK_5_HP;  }
   else
   {
      int iValue = (max/5) - (min/5) + 1;
      iRoll = Random(iValue) + (min/5) - 1;
   }
   switch (iRoll)
   {
      case 0: nReturnValue = IP_CONST_DAMAGESOAK_5_HP;
         break;
      case 1: nReturnValue = IP_CONST_DAMAGESOAK_10_HP;
         break;
      case 2: nReturnValue = IP_CONST_DAMAGESOAK_15_HP;
         break;
      case 3: nReturnValue = IP_CONST_DAMAGESOAK_20_HP;
         break;
      case 4: nReturnValue = IP_CONST_DAMAGESOAK_25_HP;
         break;
      case 5: nReturnValue = IP_CONST_DAMAGESOAK_30_HP;
         break;
      case 6: nReturnValue = IP_CONST_DAMAGESOAK_35_HP;
         break;
      case 7: nReturnValue = IP_CONST_DAMAGESOAK_40_HP;
         break;
      case 8: nReturnValue = IP_CONST_DAMAGESOAK_45_HP;
         break;
      case 9: nReturnValue = IP_CONST_DAMAGESOAK_50_HP;
         break;
      default: nReturnValue = IP_CONST_DAMAGESOAK_5_HP;
         break;
   }
   return nReturnValue;
}


////////////////////////////////////////////
// * Function that randomly chooses an ability bonus type and amount.  You can
// * specify the min or max if you want, but any value less than 1 is changed to
// * 1 and any value greater than 12 is changed to 12.
//
itemproperty FW_Choose_IP_Ability_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ABILITY_BONUS == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ABILITY_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ABILITY_BONUS_MODIFIER) + 1;
   }
   else
   {   
   switch (nCR)
   {
		case 0: min = FW_MIN_ABILITY_BONUS_CR_0 ; max = FW_MAX_ABILITY_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_ABILITY_BONUS_CR_1 ; max = FW_MAX_ABILITY_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_ABILITY_BONUS_CR_2 ; max = FW_MAX_ABILITY_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_ABILITY_BONUS_CR_3 ; max = FW_MAX_ABILITY_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_ABILITY_BONUS_CR_4 ; max = FW_MAX_ABILITY_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_ABILITY_BONUS_CR_5 ; max = FW_MAX_ABILITY_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_ABILITY_BONUS_CR_6 ; max = FW_MAX_ABILITY_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_ABILITY_BONUS_CR_7 ; max = FW_MAX_ABILITY_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_ABILITY_BONUS_CR_8 ; max = FW_MAX_ABILITY_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_ABILITY_BONUS_CR_9 ; max = FW_MAX_ABILITY_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_ABILITY_BONUS_CR_10 ; max = FW_MAX_ABILITY_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_ABILITY_BONUS_CR_11 ; max = FW_MAX_ABILITY_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_ABILITY_BONUS_CR_12 ; max = FW_MAX_ABILITY_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_ABILITY_BONUS_CR_13 ; max = FW_MAX_ABILITY_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_ABILITY_BONUS_CR_14 ; max = FW_MAX_ABILITY_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_ABILITY_BONUS_CR_15 ; max = FW_MAX_ABILITY_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_ABILITY_BONUS_CR_16 ; max = FW_MAX_ABILITY_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_ABILITY_BONUS_CR_17 ; max = FW_MAX_ABILITY_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_ABILITY_BONUS_CR_18 ; max = FW_MAX_ABILITY_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_ABILITY_BONUS_CR_19 ; max = FW_MAX_ABILITY_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_ABILITY_BONUS_CR_20 ; max = FW_MAX_ABILITY_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ABILITY_BONUS_CR_21 ; max = FW_MAX_ABILITY_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_ABILITY_BONUS_CR_22 ; max = FW_MAX_ABILITY_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_ABILITY_BONUS_CR_23 ; max = FW_MAX_ABILITY_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_ABILITY_BONUS_CR_24 ; max = FW_MAX_ABILITY_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_ABILITY_BONUS_CR_25 ; max = FW_MAX_ABILITY_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_ABILITY_BONUS_CR_26 ; max = FW_MAX_ABILITY_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_ABILITY_BONUS_CR_27 ; max = FW_MAX_ABILITY_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_ABILITY_BONUS_CR_28 ; max = FW_MAX_ABILITY_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_ABILITY_BONUS_CR_29 ; max = FW_MAX_ABILITY_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_ABILITY_BONUS_CR_30 ; max = FW_MAX_ABILITY_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ABILITY_BONUS_CR_31 ; max = FW_MAX_ABILITY_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_ABILITY_BONUS_CR_32 ; max = FW_MAX_ABILITY_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_ABILITY_BONUS_CR_33 ; max = FW_MAX_ABILITY_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_ABILITY_BONUS_CR_34 ; max = FW_MAX_ABILITY_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_ABILITY_BONUS_CR_35 ; max = FW_MAX_ABILITY_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_ABILITY_BONUS_CR_36 ; max = FW_MAX_ABILITY_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_ABILITY_BONUS_CR_37 ; max = FW_MAX_ABILITY_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_ABILITY_BONUS_CR_38 ; max = FW_MAX_ABILITY_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_ABILITY_BONUS_CR_39 ; max = FW_MAX_ABILITY_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_ABILITY_BONUS_CR_40 ; max = FW_MAX_ABILITY_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_ABILITY_BONUS_CR_41_OR_HIGHER; max = FW_MAX_ABILITY_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAbility;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 6)
      min = 6;
   if (max < 1)
      max = 1;
   if (max > 6)
      max = 6;
   int iRoll = Random (6);
   switch (iRoll)
   {
      case 0: nAbility = IP_CONST_ABILITY_CHA;
         break;
      case 1: nAbility = IP_CONST_ABILITY_CON;
         break;
      case 2: nAbility = IP_CONST_ABILITY_DEX;
         break;
      case 3: nAbility = IP_CONST_ABILITY_INT;
         break;
      case 4: nAbility = IP_CONST_ABILITY_STR;
         break;
      case 5: nAbility = IP_CONST_ABILITY_WIS;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAbilityBonus(nAbility, iBonus);
   return ipAdd;
} // end of function

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus.  Values for min and
// * max should be an integer between 1 and 20.  The type of bonus depends on
// * the item it is being applied to.
//
itemproperty FW_Choose_IP_AC_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_BONUS == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_BONUS_MODIFIER) + 1;
   }
   else
   {  
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_BONUS_CR_0 ; max = FW_MAX_AC_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_BONUS_CR_1 ; max = FW_MAX_AC_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_AC_BONUS_CR_2 ; max = FW_MAX_AC_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_AC_BONUS_CR_3 ; max = FW_MAX_AC_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_BONUS_CR_4 ; max = FW_MAX_AC_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_AC_BONUS_CR_5 ; max = FW_MAX_AC_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_AC_BONUS_CR_6 ; max = FW_MAX_AC_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_BONUS_CR_7 ; max = FW_MAX_AC_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_AC_BONUS_CR_8 ; max = FW_MAX_AC_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_AC_BONUS_CR_9 ; max = FW_MAX_AC_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_BONUS_CR_10 ; max = FW_MAX_AC_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_BONUS_CR_11 ; max = FW_MAX_AC_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_AC_BONUS_CR_12 ; max = FW_MAX_AC_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_AC_BONUS_CR_13 ; max = FW_MAX_AC_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_BONUS_CR_14 ; max = FW_MAX_AC_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_AC_BONUS_CR_15 ; max = FW_MAX_AC_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_AC_BONUS_CR_16 ; max = FW_MAX_AC_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_BONUS_CR_17 ; max = FW_MAX_AC_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_AC_BONUS_CR_18 ; max = FW_MAX_AC_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_AC_BONUS_CR_19 ; max = FW_MAX_AC_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_BONUS_CR_20 ; max = FW_MAX_AC_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_BONUS_CR_21 ; max = FW_MAX_AC_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_AC_BONUS_CR_22 ; max = FW_MAX_AC_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_AC_BONUS_CR_23 ; max = FW_MAX_AC_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_BONUS_CR_24 ; max = FW_MAX_AC_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_AC_BONUS_CR_25 ; max = FW_MAX_AC_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_AC_BONUS_CR_26 ; max = FW_MAX_AC_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_BONUS_CR_27 ; max = FW_MAX_AC_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_AC_BONUS_CR_28 ; max = FW_MAX_AC_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_AC_BONUS_CR_29 ; max = FW_MAX_AC_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_BONUS_CR_30 ; max = FW_MAX_AC_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_BONUS_CR_31 ; max = FW_MAX_AC_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_AC_BONUS_CR_32 ; max = FW_MAX_AC_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_AC_BONUS_CR_33 ; max = FW_MAX_AC_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_BONUS_CR_34 ; max = FW_MAX_AC_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_AC_BONUS_CR_35 ; max = FW_MAX_AC_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_AC_BONUS_CR_36 ; max = FW_MAX_AC_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_BONUS_CR_37 ; max = FW_MAX_AC_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_AC_BONUS_CR_38 ; max = FW_MAX_AC_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_AC_BONUS_CR_39 ; max = FW_MAX_AC_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_BONUS_CR_40 ; max = FW_MAX_AC_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_BONUS_CR_41_OR_HIGHER; max = FW_MAX_AC_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyACBonus(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Align (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_BONUS_VS_ALIGN == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_BONUS_VS_ALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_BONUS_VS_ALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_0 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_1 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_2 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_3 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_4 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_5 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_6 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_7 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_8 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_9 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_10 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_11 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_12 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_13 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_14 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_15 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_16 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_17 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_18 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_19 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_20 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_21 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_22 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_23 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_24 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_25 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_26 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_27 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_28 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_29 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_30 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_31 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_32 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_33 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_34 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_35 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_36 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_37 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_38 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_39 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_40 ; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_BONUS_VS_ALIGN_CR_41_OR_HIGHER; max = FW_MAX_AC_BONUS_VS_ALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAlignGroup = FW_Choose_IP_CONST_ALIGNMENTGROUP();
   int nACBonus;
   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nACBonus = 1;  }
   else if (min == max)
      {  nACBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      nACBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyACBonusVsAlign(nAlignGroup, nACBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. damage type.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Damage_Type (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_BONUS_VS_DMG_TYPE == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_BONUS_VS_DAMAGE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_BONUS_VS_DAMAGE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_0 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_1 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_1 ;    break;
		case 2: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_2 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_2 ;    break;
		case 3: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_3 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_4 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_4 ;    break;
		case 5: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_5 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_5 ;    break;
		case 6: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_6 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_7 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_7 ;    break;
		case 8: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_8 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_8 ;    break;
		case 9: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_9 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_10 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_11 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_11 ;  break;
		case 12: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_12 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_12 ;  break;
		case 13: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_13 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_14 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_14 ;  break;
		case 15: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_15 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_15 ;  break;
		case 16: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_16 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_17 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_17 ;  break;
		case 18: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_18 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_18 ;  break;
		case 19: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_19 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_20 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_21 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_21 ;  break;
		case 22: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_22 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_22 ;  break;
		case 23: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_23 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_24 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_24 ;  break;
		case 25: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_25 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_25 ;  break;
		case 26: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_26 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_27 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_27 ;  break;
		case 28: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_28 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_28 ;  break;
		case 29: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_29 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_30 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_31 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_31 ;  break;
		case 32: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_32 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_32 ;  break;
		case 33: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_33 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_34 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_34 ;  break;
		case 35: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_35 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_35 ;  break;
		case 36: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_36 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_37 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_37 ;  break;
		case 38: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_38 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_38 ;  break;
		case 39: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_39 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_40 ; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_BONUS_VS_DMG_TYPE_CR_41_OR_HIGHER; max = FW_MAX_AC_BONUS_VS_DMG_TYPE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iDamageType;
   int nACBonus;

   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   int iRoll = Random (3);
   switch (iRoll)
   {
      case 0: iDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
         break;
      case 1: iDamageType = IP_CONST_DAMAGETYPE_PIERCING;
         break;
      case 2: iDamageType = IP_CONST_DAMAGETYPE_SLASHING;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nACBonus = 1;  }
   else if (min == max)
      {  nACBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      nACBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyACBonusVsDmgType(iDamageType, nACBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_Race (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_BONUS_VS_RACE == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_BONUS_VS_RACE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_BONUS_VS_RACE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_BONUS_VS_RACE_CR_0 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_BONUS_VS_RACE_CR_1 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_1 ;    break;
		case 2: min = FW_MIN_AC_BONUS_VS_RACE_CR_2 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_2 ;    break;
		case 3: min = FW_MIN_AC_BONUS_VS_RACE_CR_3 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_BONUS_VS_RACE_CR_4 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_4 ;    break;
		case 5: min = FW_MIN_AC_BONUS_VS_RACE_CR_5 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_5 ;    break;
		case 6: min = FW_MIN_AC_BONUS_VS_RACE_CR_6 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_BONUS_VS_RACE_CR_7 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_7 ;    break;
		case 8: min = FW_MIN_AC_BONUS_VS_RACE_CR_8 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_8 ;    break;
		case 9: min = FW_MIN_AC_BONUS_VS_RACE_CR_9 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_BONUS_VS_RACE_CR_10 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_BONUS_VS_RACE_CR_11 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_11 ;  break;
		case 12: min = FW_MIN_AC_BONUS_VS_RACE_CR_12 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_12 ;  break;
		case 13: min = FW_MIN_AC_BONUS_VS_RACE_CR_13 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_BONUS_VS_RACE_CR_14 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_14 ;  break;
		case 15: min = FW_MIN_AC_BONUS_VS_RACE_CR_15 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_15 ;  break;
		case 16: min = FW_MIN_AC_BONUS_VS_RACE_CR_16 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_BONUS_VS_RACE_CR_17 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_17 ;  break;
		case 18: min = FW_MIN_AC_BONUS_VS_RACE_CR_18 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_18 ;  break;
		case 19: min = FW_MIN_AC_BONUS_VS_RACE_CR_19 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_BONUS_VS_RACE_CR_20 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_BONUS_VS_RACE_CR_21 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_21 ;  break;
		case 22: min = FW_MIN_AC_BONUS_VS_RACE_CR_22 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_22 ;  break;
		case 23: min = FW_MIN_AC_BONUS_VS_RACE_CR_23 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_BONUS_VS_RACE_CR_24 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_24 ;  break;
		case 25: min = FW_MIN_AC_BONUS_VS_RACE_CR_25 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_25 ;  break;
		case 26: min = FW_MIN_AC_BONUS_VS_RACE_CR_26 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_BONUS_VS_RACE_CR_27 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_27 ;  break;
		case 28: min = FW_MIN_AC_BONUS_VS_RACE_CR_28 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_28 ;  break;
		case 29: min = FW_MIN_AC_BONUS_VS_RACE_CR_29 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_BONUS_VS_RACE_CR_30 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_BONUS_VS_RACE_CR_31 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_31 ;  break;
		case 32: min = FW_MIN_AC_BONUS_VS_RACE_CR_32 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_32 ;  break;
		case 33: min = FW_MIN_AC_BONUS_VS_RACE_CR_33 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_BONUS_VS_RACE_CR_34 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_34 ;  break;
		case 35: min = FW_MIN_AC_BONUS_VS_RACE_CR_35 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_35 ;  break;
		case 36: min = FW_MIN_AC_BONUS_VS_RACE_CR_36 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_BONUS_VS_RACE_CR_37 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_37 ;  break;
		case 38: min = FW_MIN_AC_BONUS_VS_RACE_CR_38 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_38 ;  break;
		case 39: min = FW_MIN_AC_BONUS_VS_RACE_CR_39 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_BONUS_VS_RACE_CR_40 ; max = FW_MAX_AC_BONUS_VS_RACE_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_BONUS_VS_RACE_CR_41_OR_HIGHER; max = FW_MAX_AC_BONUS_VS_RACE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nRace = FW_Choose_IP_CONST_RACIALTYPE();
   int nACBonus;

   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nACBonus = 1;  }
   else if (min == max)
      {  nACBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      nACBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyACBonusVsRace(nRace, nACBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_AC_Bonus_Vs_SAlign (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_BONUS_VS_SALIGN == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_BONUS_VS_SALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_BONUS_VS_SALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_0 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_1 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_2 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_3 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_4 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_5 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_6 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_7 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_8 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_9 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_10 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_11 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_12 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_13 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_14 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_15 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_16 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_17 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_18 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_19 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_20 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_21 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_22 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_23 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_24 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_25 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_26 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_27 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_28 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_29 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_30 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_31 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_32 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_33 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_34 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_35 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_36 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_37 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_38 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_39 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_40 ; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_BONUS_VS_SALIGN_CR_41_OR_HIGHER; max = FW_MAX_AC_BONUS_VS_SALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAlign = FW_Choose_IP_CONST_SALIGN ();
   int nACBonus;

   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;

   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nACBonus = 1;  }
   else if (min == max)
      {  nACBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      nACBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyACBonusVsSAlign(nAlign, nACBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Arcane Spell Failure.
//
itemproperty FW_Choose_IP_Arcane_Spell_Failure ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_ARCANE_SPELL_FAILURE == FALSE)
      return ipAdd;
   int nModLevel;
   int iRoll = Random (20);
   switch (iRoll)
   {
      case 0: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
         break;
      case 1: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
         break;
      case 2: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
         break;
      case 3: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;
         break;
      case 4: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT;
         break;
      case 5: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;
         break;
      case 6: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT;
         break;
      case 7: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT;
         break;
      case 8: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
         break;
      case 9: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
         break;
      case 10: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_10_PERCENT;
         break;
      case 11: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_15_PERCENT;
         break;
      case 12: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_20_PERCENT;
         break;
      case 13: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT;
         break;
      case 14: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_30_PERCENT;
         break;
      case 15: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_35_PERCENT;
         break;
      case 16: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_40_PERCENT;
         break;
      case 17: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_45_PERCENT;
         break;
      case 18: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_5_PERCENT;
         break;
      case 19: nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT;
         break;
      default: break;
   } // end of switch
   ipAdd = ItemPropertyArcaneSpellFailure(nModLevel);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus.  Values for min and
// * max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ATTACK_BONUS == FALSE)
      return ipAdd;
   int min;
   int max;
   
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ATTACK_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ATTACK_BONUS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ATTACK_BONUS_CR_0 ; max = FW_MAX_ATTACK_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_ATTACK_BONUS_CR_1 ; max = FW_MAX_ATTACK_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_ATTACK_BONUS_CR_2 ; max = FW_MAX_ATTACK_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_ATTACK_BONUS_CR_3 ; max = FW_MAX_ATTACK_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_ATTACK_BONUS_CR_4 ; max = FW_MAX_ATTACK_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_ATTACK_BONUS_CR_5 ; max = FW_MAX_ATTACK_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_ATTACK_BONUS_CR_6 ; max = FW_MAX_ATTACK_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_ATTACK_BONUS_CR_7 ; max = FW_MAX_ATTACK_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_ATTACK_BONUS_CR_8 ; max = FW_MAX_ATTACK_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_ATTACK_BONUS_CR_9 ; max = FW_MAX_ATTACK_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_ATTACK_BONUS_CR_10 ; max = FW_MAX_ATTACK_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_ATTACK_BONUS_CR_11 ; max = FW_MAX_ATTACK_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_ATTACK_BONUS_CR_12 ; max = FW_MAX_ATTACK_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_ATTACK_BONUS_CR_13 ; max = FW_MAX_ATTACK_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_ATTACK_BONUS_CR_14 ; max = FW_MAX_ATTACK_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_ATTACK_BONUS_CR_15 ; max = FW_MAX_ATTACK_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_ATTACK_BONUS_CR_16 ; max = FW_MAX_ATTACK_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_ATTACK_BONUS_CR_17 ; max = FW_MAX_ATTACK_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_ATTACK_BONUS_CR_18 ; max = FW_MAX_ATTACK_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_ATTACK_BONUS_CR_19 ; max = FW_MAX_ATTACK_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_ATTACK_BONUS_CR_20 ; max = FW_MAX_ATTACK_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ATTACK_BONUS_CR_21 ; max = FW_MAX_ATTACK_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_ATTACK_BONUS_CR_22 ; max = FW_MAX_ATTACK_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_ATTACK_BONUS_CR_23 ; max = FW_MAX_ATTACK_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_ATTACK_BONUS_CR_24 ; max = FW_MAX_ATTACK_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_ATTACK_BONUS_CR_25 ; max = FW_MAX_ATTACK_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_ATTACK_BONUS_CR_26 ; max = FW_MAX_ATTACK_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_ATTACK_BONUS_CR_27 ; max = FW_MAX_ATTACK_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_ATTACK_BONUS_CR_28 ; max = FW_MAX_ATTACK_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_ATTACK_BONUS_CR_29 ; max = FW_MAX_ATTACK_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_ATTACK_BONUS_CR_30 ; max = FW_MAX_ATTACK_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ATTACK_BONUS_CR_31 ; max = FW_MAX_ATTACK_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_ATTACK_BONUS_CR_32 ; max = FW_MAX_ATTACK_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_ATTACK_BONUS_CR_33 ; max = FW_MAX_ATTACK_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_ATTACK_BONUS_CR_34 ; max = FW_MAX_ATTACK_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_ATTACK_BONUS_CR_35 ; max = FW_MAX_ATTACK_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_ATTACK_BONUS_CR_36 ; max = FW_MAX_ATTACK_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_ATTACK_BONUS_CR_37 ; max = FW_MAX_ATTACK_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_ATTACK_BONUS_CR_38 ; max = FW_MAX_ATTACK_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_ATTACK_BONUS_CR_39 ; max = FW_MAX_ATTACK_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_ATTACK_BONUS_CR_40 ; max = FW_MAX_ATTACK_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_ATTACK_BONUS_CR_41_OR_HIGHER; max = FW_MAX_ATTACK_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAttackBonus(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_Align (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ATTACK_BONUS_VS_ALIGN == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ATTACK_BONUS_VS_ALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ATTACK_BONUS_VS_ALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_0 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_1 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_2 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_3 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_4 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_5 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_6 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_7 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_8 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_9 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_10 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_11 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_12 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_13 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_14 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_15 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_16 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_17 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_18 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_19 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_20 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_21 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_22 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_23 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_24 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_25 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_26 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_27 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_28 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_29 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_30 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_31 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_32 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_33 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_34 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_35 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_36 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_37 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_38 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_39 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_40 ; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_ATTACK_BONUS_VS_ALIGN_CR_41_OR_HIGHER; max = FW_MAX_ATTACK_BONUS_VS_ALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAlignGroup = FW_Choose_IP_CONST_ALIGNMENTGROUP ();
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAttackBonusVsAlign(nAlignGroup, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an attack bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_Race (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ATTACK_BONUS_VS_RACE == FALSE)
      return ipAdd;
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ATTACK_BONUS_VS_RACE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ATTACK_BONUS_VS_RACE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_0 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_0 ;    break;
		
		case 1: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_1 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_1 ;    break;
		case 2: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_2 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_2 ;    break;
		case 3: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_3 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_3 ;    break;
   		case 4: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_4 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_4 ;    break;
		case 5: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_5 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_5 ;    break;
		case 6: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_6 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_6 ;    break;
   		case 7: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_7 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_7 ;    break;
		case 8: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_8 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_8 ;    break;
		case 9: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_9 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_9 ;    break;
   		case 10: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_10 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_10 ; break;
		
		case 11: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_11 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_11 ;  break;
		case 12: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_12 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_12 ;  break;
		case 13: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_13 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_13 ;  break;
   		case 14: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_14 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_14 ;  break;
		case 15: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_15 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_15 ;  break;
		case 16: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_16 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_16 ;  break;
   		case 17: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_17 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_17 ;  break;
		case 18: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_18 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_18 ;  break;
		case 19: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_19 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_19 ;  break;
   		case 20: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_20 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_21 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_21 ;  break;
		case 22: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_22 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_22 ;  break;
		case 23: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_23 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_23 ;  break;
   		case 24: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_24 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_24 ;  break;
		case 25: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_25 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_25 ;  break;
		case 26: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_26 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_26 ;  break;
   		case 27: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_27 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_27 ;  break;
		case 28: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_28 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_28 ;  break;
		case 29: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_29 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_29 ;  break;
   		case 30: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_30 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_31 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_31 ;  break;
		case 32: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_32 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_32 ;  break;
		case 33: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_33 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_33 ;  break;
   		case 34: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_34 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_34 ;  break;
		case 35: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_35 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_35 ;  break;
		case 36: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_36 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_36 ;  break;
   		case 37: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_37 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_37 ;  break;
		case 38: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_38 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_38 ;  break;
		case 39: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_39 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_39 ;  break;
   		case 40: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_40 ; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_40 ;  break;
		
		case 41: min = FW_MIN_ATTACK_BONUS_VS_RACE_CR_41_OR_HIGHER; max = FW_MAX_ATTACK_BONUS_VS_RACE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nRace = FW_Choose_IP_CONST_RACIALTYPE ();
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAttackBonusVsRace(nRace, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Attack bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Attack_Bonus_Vs_SAlign (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ATTACK_BONUS_VS_SALIGN == FALSE)
      return ipAdd;
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ATTACK_BONUS_VS_SALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ATTACK_BONUS_VS_SALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_0 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_1 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_2 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_3 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_4 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_5 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_6 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_7 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_8 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_9 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_10 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_11 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_12 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_13 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_14 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_15 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_16 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_17 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_18 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_19 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_20 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_21 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_22 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_23 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_24 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_25 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_26 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_27 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_28 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_29 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_30 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_31 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_32 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_33 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_34 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_35 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_36 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_37 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_38 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_39 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_40 ; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_ATTACK_BONUS_VS_SALIGN_CR_41_OR_HIGHER; max = FW_MAX_ATTACK_BONUS_VS_SALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAlign = FW_Choose_IP_CONST_SALIGN ();
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 4)
      min = 4;
   if (max < 1)
      max = 1;
   if (max > 4)
      max = 4;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAttackBonusVsSAlign(nAlign, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Attack penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Attack_Penalty (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ATTACK_PENALTY == FALSE)
      return ipAdd;
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ATTACK_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ATTACK_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ATTACK_PENALTY_CR_0 ; max = FW_MAX_ATTACK_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_ATTACK_PENALTY_CR_1 ; max = FW_MAX_ATTACK_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_ATTACK_PENALTY_CR_2 ; max = FW_MAX_ATTACK_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_ATTACK_PENALTY_CR_3 ; max = FW_MAX_ATTACK_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_ATTACK_PENALTY_CR_4 ; max = FW_MAX_ATTACK_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_ATTACK_PENALTY_CR_5 ; max = FW_MAX_ATTACK_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_ATTACK_PENALTY_CR_6 ; max = FW_MAX_ATTACK_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_ATTACK_PENALTY_CR_7 ; max = FW_MAX_ATTACK_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_ATTACK_PENALTY_CR_8 ; max = FW_MAX_ATTACK_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_ATTACK_PENALTY_CR_9 ; max = FW_MAX_ATTACK_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_ATTACK_PENALTY_CR_10 ; max = FW_MAX_ATTACK_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_ATTACK_PENALTY_CR_11 ; max = FW_MAX_ATTACK_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_ATTACK_PENALTY_CR_12 ; max = FW_MAX_ATTACK_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_ATTACK_PENALTY_CR_13 ; max = FW_MAX_ATTACK_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_ATTACK_PENALTY_CR_14 ; max = FW_MAX_ATTACK_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_ATTACK_PENALTY_CR_15 ; max = FW_MAX_ATTACK_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_ATTACK_PENALTY_CR_16 ; max = FW_MAX_ATTACK_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_ATTACK_PENALTY_CR_17 ; max = FW_MAX_ATTACK_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_ATTACK_PENALTY_CR_18 ; max = FW_MAX_ATTACK_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_ATTACK_PENALTY_CR_19 ; max = FW_MAX_ATTACK_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_ATTACK_PENALTY_CR_20 ; max = FW_MAX_ATTACK_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ATTACK_PENALTY_CR_21 ; max = FW_MAX_ATTACK_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_ATTACK_PENALTY_CR_22 ; max = FW_MAX_ATTACK_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_ATTACK_PENALTY_CR_23 ; max = FW_MAX_ATTACK_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_ATTACK_PENALTY_CR_24 ; max = FW_MAX_ATTACK_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_ATTACK_PENALTY_CR_25 ; max = FW_MAX_ATTACK_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_ATTACK_PENALTY_CR_26 ; max = FW_MAX_ATTACK_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_ATTACK_PENALTY_CR_27 ; max = FW_MAX_ATTACK_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_ATTACK_PENALTY_CR_28 ; max = FW_MAX_ATTACK_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_ATTACK_PENALTY_CR_29 ; max = FW_MAX_ATTACK_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_ATTACK_PENALTY_CR_30 ; max = FW_MAX_ATTACK_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ATTACK_PENALTY_CR_31 ; max = FW_MAX_ATTACK_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_ATTACK_PENALTY_CR_32 ; max = FW_MAX_ATTACK_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_ATTACK_PENALTY_CR_33 ; max = FW_MAX_ATTACK_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_ATTACK_PENALTY_CR_34 ; max = FW_MAX_ATTACK_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_ATTACK_PENALTY_CR_35 ; max = FW_MAX_ATTACK_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_ATTACK_PENALTY_CR_36 ; max = FW_MAX_ATTACK_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_ATTACK_PENALTY_CR_37 ; max = FW_MAX_ATTACK_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_ATTACK_PENALTY_CR_38 ; max = FW_MAX_ATTACK_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_ATTACK_PENALTY_CR_39 ; max = FW_MAX_ATTACK_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_ATTACK_PENALTY_CR_40 ; max = FW_MAX_ATTACK_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_ATTACK_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_ATTACK_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 5)
      min = 5;
   if (max < 1)
      max = 1;
   if (max > 5)
      max = 5;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyAttackPenalty(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a feat to add to an item.
// * By default ALL bonus feats are allowed.
//
itemproperty FW_Choose_IP_Bonus_Feat ()
{
  itemproperty ipAdd;
  if (FW_ALLOW_BONUS_FEAT == FALSE)
      return ipAdd;
  int nReRoll = TRUE;
  int iRoll;

  while (nReRoll)
  {
     // As of 10 July 2007, there are 387 feats in NWN 2.
     iRoll = Random (387);
     switch (iRoll)
     {
        //**************************************
        //
        //  EXCLUDE FEATS IN THIS SECTION
        //
        // I gave 3 examples below of how to exclude a bonus feat from being
        // added to an item.  In the examples, if Alertness, Dodge, or
        // Weapon Finesse is rolled as a random bonus feat, then the generator
        // re-rolls until a feat that isn't below is found.  If you uncomment
        // this section of code, ALWAYS leave the default alone.  The default
        // guarantees that this function doesn't get stuck in a loop forever
        // by setting nContinue to FALSE.  Don't change it.  Substitute the
        // IP_CONST_FEAT_* that you do not want to appear for one of my
        // examples. If you desire to disallow more than 3, then you'll need
        // to make additional case statements like in the examples shown.
        //
        //
        // WARNING: There is a possibility of creating significant lag if you
        //    have a whole lot of disallowed feats with only a couple of
        //    acceptable ones. The reason is the while statement keeps
        //    re-rolling a number between 0 and 386.  It might take it a LONG
        //    time to pick an acceptable feat if you disallow almost everything.
        //    It would be better to rewrite this function a different way if you
        //    are going to disallow more than half of the bonus feats.
        // VITALLY IMPORTANT NOTE: Don't disallow everything or else this will
        //    crash the game because it will get stuck in a loop forever. If you
        //    want to disallow ALL bonus feats from appearing on an item, do so
        //    by setting FW_ALLOW_BONUS_FEAT = FALSE;
        /*
        case IP_CONST_FEAT_ALERTNESS: nReRoll = TRUE;
           break;
        case IP_CONST_FEAT_DODGE: nReRoll = TRUE;
           break;
        case IP_CONST_FEAT_WEAPFINESSE: nReRoll = TRUE;
           break;
        */
        //**************************************
        // We found an acceptable feat!!
        default: nReRoll = FALSE;
           break;
     }
  }
  ipAdd = ItemPropertyBonusFeat (iRoll);
  return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a random amount of bonus hit points to add to an item
// * min and max should be positive integers between 1 and 50.  Because of how
// * the item property bonus hit points is implemented in NWN 2, it goes like
// * this:  1,2,3,...,20, 25, 30, 35, 40, 45, 50.
//
itemproperty FW_Choose_IP_Bonus_Hit_Points (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_BONUS_HIT_POINTS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_BONUS_HIT_POINTS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_BONUS_HIT_POINTS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_BONUS_HIT_POINTS_CR_0 ; max = FW_MAX_BONUS_HIT_POINTS_CR_0 ;    break;
		
		case 1: min = FW_MIN_BONUS_HIT_POINTS_CR_1 ; max = FW_MAX_BONUS_HIT_POINTS_CR_1 ;    break;
		case 2: min = FW_MIN_BONUS_HIT_POINTS_CR_2 ; max = FW_MAX_BONUS_HIT_POINTS_CR_2 ;    break;
		case 3: min = FW_MIN_BONUS_HIT_POINTS_CR_3 ; max = FW_MAX_BONUS_HIT_POINTS_CR_3 ;    break;
   		case 4: min = FW_MIN_BONUS_HIT_POINTS_CR_4 ; max = FW_MAX_BONUS_HIT_POINTS_CR_4 ;    break;
		case 5: min = FW_MIN_BONUS_HIT_POINTS_CR_5 ; max = FW_MAX_BONUS_HIT_POINTS_CR_5 ;    break;
		case 6: min = FW_MIN_BONUS_HIT_POINTS_CR_6 ; max = FW_MAX_BONUS_HIT_POINTS_CR_6 ;    break;
   		case 7: min = FW_MIN_BONUS_HIT_POINTS_CR_7 ; max = FW_MAX_BONUS_HIT_POINTS_CR_7 ;    break;
		case 8: min = FW_MIN_BONUS_HIT_POINTS_CR_8 ; max = FW_MAX_BONUS_HIT_POINTS_CR_8 ;    break;
		case 9: min = FW_MIN_BONUS_HIT_POINTS_CR_9 ; max = FW_MAX_BONUS_HIT_POINTS_CR_9 ;    break;
   		case 10: min = FW_MIN_BONUS_HIT_POINTS_CR_10 ; max = FW_MAX_BONUS_HIT_POINTS_CR_10 ; break;
		
		case 11: min = FW_MIN_BONUS_HIT_POINTS_CR_11 ; max = FW_MAX_BONUS_HIT_POINTS_CR_11 ;  break;
		case 12: min = FW_MIN_BONUS_HIT_POINTS_CR_12 ; max = FW_MAX_BONUS_HIT_POINTS_CR_12 ;  break;
		case 13: min = FW_MIN_BONUS_HIT_POINTS_CR_13 ; max = FW_MAX_BONUS_HIT_POINTS_CR_13 ;  break;
   		case 14: min = FW_MIN_BONUS_HIT_POINTS_CR_14 ; max = FW_MAX_BONUS_HIT_POINTS_CR_14 ;  break;
		case 15: min = FW_MIN_BONUS_HIT_POINTS_CR_15 ; max = FW_MAX_BONUS_HIT_POINTS_CR_15 ;  break;
		case 16: min = FW_MIN_BONUS_HIT_POINTS_CR_16 ; max = FW_MAX_BONUS_HIT_POINTS_CR_16 ;  break;
   		case 17: min = FW_MIN_BONUS_HIT_POINTS_CR_17 ; max = FW_MAX_BONUS_HIT_POINTS_CR_17 ;  break;
		case 18: min = FW_MIN_BONUS_HIT_POINTS_CR_18 ; max = FW_MAX_BONUS_HIT_POINTS_CR_18 ;  break;
		case 19: min = FW_MIN_BONUS_HIT_POINTS_CR_19 ; max = FW_MAX_BONUS_HIT_POINTS_CR_19 ;  break;
   		case 20: min = FW_MIN_BONUS_HIT_POINTS_CR_20 ; max = FW_MAX_BONUS_HIT_POINTS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_BONUS_HIT_POINTS_CR_21 ; max = FW_MAX_BONUS_HIT_POINTS_CR_21 ;  break;
		case 22: min = FW_MIN_BONUS_HIT_POINTS_CR_22 ; max = FW_MAX_BONUS_HIT_POINTS_CR_22 ;  break;
		case 23: min = FW_MIN_BONUS_HIT_POINTS_CR_23 ; max = FW_MAX_BONUS_HIT_POINTS_CR_23 ;  break;
   		case 24: min = FW_MIN_BONUS_HIT_POINTS_CR_24 ; max = FW_MAX_BONUS_HIT_POINTS_CR_24 ;  break;
		case 25: min = FW_MIN_BONUS_HIT_POINTS_CR_25 ; max = FW_MAX_BONUS_HIT_POINTS_CR_25 ;  break;
		case 26: min = FW_MIN_BONUS_HIT_POINTS_CR_26 ; max = FW_MAX_BONUS_HIT_POINTS_CR_26 ;  break;
   		case 27: min = FW_MIN_BONUS_HIT_POINTS_CR_27 ; max = FW_MAX_BONUS_HIT_POINTS_CR_27 ;  break;
		case 28: min = FW_MIN_BONUS_HIT_POINTS_CR_28 ; max = FW_MAX_BONUS_HIT_POINTS_CR_28 ;  break;
		case 29: min = FW_MIN_BONUS_HIT_POINTS_CR_29 ; max = FW_MAX_BONUS_HIT_POINTS_CR_29 ;  break;
   		case 30: min = FW_MIN_BONUS_HIT_POINTS_CR_30 ; max = FW_MAX_BONUS_HIT_POINTS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_BONUS_HIT_POINTS_CR_31 ; max = FW_MAX_BONUS_HIT_POINTS_CR_31 ;  break;
		case 32: min = FW_MIN_BONUS_HIT_POINTS_CR_32 ; max = FW_MAX_BONUS_HIT_POINTS_CR_32 ;  break;
		case 33: min = FW_MIN_BONUS_HIT_POINTS_CR_33 ; max = FW_MAX_BONUS_HIT_POINTS_CR_33 ;  break;
   		case 34: min = FW_MIN_BONUS_HIT_POINTS_CR_34 ; max = FW_MAX_BONUS_HIT_POINTS_CR_34 ;  break;
		case 35: min = FW_MIN_BONUS_HIT_POINTS_CR_35 ; max = FW_MAX_BONUS_HIT_POINTS_CR_35 ;  break;
		case 36: min = FW_MIN_BONUS_HIT_POINTS_CR_36 ; max = FW_MAX_BONUS_HIT_POINTS_CR_36 ;  break;
   		case 37: min = FW_MIN_BONUS_HIT_POINTS_CR_37 ; max = FW_MAX_BONUS_HIT_POINTS_CR_37 ;  break;
		case 38: min = FW_MIN_BONUS_HIT_POINTS_CR_38 ; max = FW_MAX_BONUS_HIT_POINTS_CR_38 ;  break;
		case 39: min = FW_MIN_BONUS_HIT_POINTS_CR_39 ; max = FW_MAX_BONUS_HIT_POINTS_CR_39 ;  break;
   		case 40: min = FW_MIN_BONUS_HIT_POINTS_CR_40 ; max = FW_MAX_BONUS_HIT_POINTS_CR_40 ;  break;
		
		case 41: min = FW_MIN_BONUS_HIT_POINTS_CR_41_OR_HIGHER; max = FW_MAX_BONUS_HIT_POINTS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iBonus;
   // Because at 20 the numbers jump by intervals of five in the iprp_bonushp
   // .2da file I am mapping the min and max to the row value inside the .2da
   // rounding down.
   if (min < 1)
      min = 1;
   if (max < 1)
      max = 1;
   if (min >= 21 && min <= 24)
      min = 20;
   if (max >= 21 && max <= 24)
      max = 20;
   if (min >= 25 && min <= 29)
      min = 21;
   if (max >= 25 && max <= 29)
      max = 21;
   if (min >= 30 && min <= 34)
      min = 22;
   if (max >= 30 && max <= 34)
      max = 22;
   if (min >= 35 && min <= 39)
      min = 23;
   if (max >= 35 && max<= 39)
      max = 23;
   if (min >= 40 && min <= 44)
      min = 24;
   if (max >= 40 && max <= 44)
      max = 24;
   if (min >= 45 && min <= 49)
      min = 25;
   if (max >= 45 && max <= 49)
      max = 25;
   if (min >= 50)
      min = 26;
   if (max >= 50)
      max = 26;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyBonusHitpoints(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a bonus spell of level 0...9 to be added to
// * an item.  Values for min and max should be an integer between 0 and 9.
//
itemproperty FW_Choose_IP_Bonus_Level_Spell (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_BONUS_LEVEL_SPELL == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_BONUS_LEVEL_SPELL_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_BONUS_LEVEL_SPELL_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_BONUS_LEVEL_SPELL_CR_0 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_0 ;    break;
		
		case 1: min = FW_MIN_BONUS_LEVEL_SPELL_CR_1 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_1 ;    break;
		case 2: min = FW_MIN_BONUS_LEVEL_SPELL_CR_2 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_2 ;    break;
		case 3: min = FW_MIN_BONUS_LEVEL_SPELL_CR_3 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_3 ;    break;
   		case 4: min = FW_MIN_BONUS_LEVEL_SPELL_CR_4 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_4 ;    break;
		case 5: min = FW_MIN_BONUS_LEVEL_SPELL_CR_5 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_5 ;    break;
		case 6: min = FW_MIN_BONUS_LEVEL_SPELL_CR_6 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_6 ;    break;
   		case 7: min = FW_MIN_BONUS_LEVEL_SPELL_CR_7 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_7 ;    break;
		case 8: min = FW_MIN_BONUS_LEVEL_SPELL_CR_8 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_8 ;    break;
		case 9: min = FW_MIN_BONUS_LEVEL_SPELL_CR_9 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_9 ;    break;
   		case 10: min = FW_MIN_BONUS_LEVEL_SPELL_CR_10 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_10 ; break;
		
		case 11: min = FW_MIN_BONUS_LEVEL_SPELL_CR_11 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_11 ;  break;
		case 12: min = FW_MIN_BONUS_LEVEL_SPELL_CR_12 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_12 ;  break;
		case 13: min = FW_MIN_BONUS_LEVEL_SPELL_CR_13 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_13 ;  break;
   		case 14: min = FW_MIN_BONUS_LEVEL_SPELL_CR_14 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_14 ;  break;
		case 15: min = FW_MIN_BONUS_LEVEL_SPELL_CR_15 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_15 ;  break;
		case 16: min = FW_MIN_BONUS_LEVEL_SPELL_CR_16 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_16 ;  break;
   		case 17: min = FW_MIN_BONUS_LEVEL_SPELL_CR_17 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_17 ;  break;
		case 18: min = FW_MIN_BONUS_LEVEL_SPELL_CR_18 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_18 ;  break;
		case 19: min = FW_MIN_BONUS_LEVEL_SPELL_CR_19 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_19 ;  break;
   		case 20: min = FW_MIN_BONUS_LEVEL_SPELL_CR_20 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_20 ;  break;
   
   		case 21: min = FW_MIN_BONUS_LEVEL_SPELL_CR_21 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_21 ;  break;
		case 22: min = FW_MIN_BONUS_LEVEL_SPELL_CR_22 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_22 ;  break;
		case 23: min = FW_MIN_BONUS_LEVEL_SPELL_CR_23 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_23 ;  break;
   		case 24: min = FW_MIN_BONUS_LEVEL_SPELL_CR_24 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_24 ;  break;
		case 25: min = FW_MIN_BONUS_LEVEL_SPELL_CR_25 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_25 ;  break;
		case 26: min = FW_MIN_BONUS_LEVEL_SPELL_CR_26 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_26 ;  break;
   		case 27: min = FW_MIN_BONUS_LEVEL_SPELL_CR_27 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_27 ;  break;
		case 28: min = FW_MIN_BONUS_LEVEL_SPELL_CR_28 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_28 ;  break;
		case 29: min = FW_MIN_BONUS_LEVEL_SPELL_CR_29 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_29 ;  break;
   		case 30: min = FW_MIN_BONUS_LEVEL_SPELL_CR_30 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_30 ;  break;		
		
		case 31: min = FW_MIN_BONUS_LEVEL_SPELL_CR_31 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_31 ;  break;
		case 32: min = FW_MIN_BONUS_LEVEL_SPELL_CR_32 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_32 ;  break;
		case 33: min = FW_MIN_BONUS_LEVEL_SPELL_CR_33 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_33 ;  break;
   		case 34: min = FW_MIN_BONUS_LEVEL_SPELL_CR_34 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_34 ;  break;
		case 35: min = FW_MIN_BONUS_LEVEL_SPELL_CR_35 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_35 ;  break;
		case 36: min = FW_MIN_BONUS_LEVEL_SPELL_CR_36 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_36 ;  break;
   		case 37: min = FW_MIN_BONUS_LEVEL_SPELL_CR_37 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_37 ;  break;
		case 38: min = FW_MIN_BONUS_LEVEL_SPELL_CR_38 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_38 ;  break;
		case 39: min = FW_MIN_BONUS_LEVEL_SPELL_CR_39 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_39 ;  break;
   		case 40: min = FW_MIN_BONUS_LEVEL_SPELL_CR_40 ; max = FW_MAX_BONUS_LEVEL_SPELL_CR_40 ;  break;
		
		case 41: min = FW_MIN_BONUS_LEVEL_SPELL_CR_41_OR_HIGHER; max = FW_MAX_BONUS_LEVEL_SPELL_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int iClass;
   int nSpellLevel;

   if (min < 0)
      min = 0;
   if (min > 9)
      min = 9;
   if (max < 0)
      max = 0;
   if (max > 9)
      max = 9;
   int iRoll = Random (7);
   switch (iRoll)
   {
      case 0: iClass = IP_CONST_CLASS_BARD;
              if (max > 6) { min = 0; max = 6; }
         break;
      case 1: iClass = IP_CONST_CLASS_CLERIC;
         break;
      case 2: iClass = IP_CONST_CLASS_DRUID;
         break;
      case 3: iClass = IP_CONST_CLASS_PALADIN;
              if (max > 4) { min = 0; max = 4; }
         break;
      case 4: iClass = IP_CONST_CLASS_RANGER;
              if (max > 4) { min = 0; max = 4; }
         break;
      case 5: iClass = IP_CONST_CLASS_SORCERER;
         break;
      case 6: iClass = IP_CONST_CLASS_WIZARD;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nSpellLevel = 1;  }
   else if (min == max)
      {  nSpellLevel = min;  }
   else
   {
      int iValue = max - min + 1;
      nSpellLevel = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyBonusLevelSpell(iClass, nSpellLevel);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw to add to an item.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Bonus_Saving_Throw (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_BONUS_SAVING_THROW == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_BONUS_SAVING_THROW_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_BONUS_SAVING_THROW_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_BONUS_SAVING_THROW_CR_0 ; max = FW_MAX_BONUS_SAVING_THROW_CR_0 ;    break;
		
		case 1: min = FW_MIN_BONUS_SAVING_THROW_CR_1 ; max = FW_MAX_BONUS_SAVING_THROW_CR_1 ;    break;
		case 2: min = FW_MIN_BONUS_SAVING_THROW_CR_2 ; max = FW_MAX_BONUS_SAVING_THROW_CR_2 ;    break;
		case 3: min = FW_MIN_BONUS_SAVING_THROW_CR_3 ; max = FW_MAX_BONUS_SAVING_THROW_CR_3 ;    break;
   		case 4: min = FW_MIN_BONUS_SAVING_THROW_CR_4 ; max = FW_MAX_BONUS_SAVING_THROW_CR_4 ;    break;
		case 5: min = FW_MIN_BONUS_SAVING_THROW_CR_5 ; max = FW_MAX_BONUS_SAVING_THROW_CR_5 ;    break;
		case 6: min = FW_MIN_BONUS_SAVING_THROW_CR_6 ; max = FW_MAX_BONUS_SAVING_THROW_CR_6 ;    break;
   		case 7: min = FW_MIN_BONUS_SAVING_THROW_CR_7 ; max = FW_MAX_BONUS_SAVING_THROW_CR_7 ;    break;
		case 8: min = FW_MIN_BONUS_SAVING_THROW_CR_8 ; max = FW_MAX_BONUS_SAVING_THROW_CR_8 ;    break;
		case 9: min = FW_MIN_BONUS_SAVING_THROW_CR_9 ; max = FW_MAX_BONUS_SAVING_THROW_CR_9 ;    break;
   		case 10: min = FW_MIN_BONUS_SAVING_THROW_CR_10 ; max = FW_MAX_BONUS_SAVING_THROW_CR_10 ; break;
		
		case 11: min = FW_MIN_BONUS_SAVING_THROW_CR_11 ; max = FW_MAX_BONUS_SAVING_THROW_CR_11 ;  break;
		case 12: min = FW_MIN_BONUS_SAVING_THROW_CR_12 ; max = FW_MAX_BONUS_SAVING_THROW_CR_12 ;  break;
		case 13: min = FW_MIN_BONUS_SAVING_THROW_CR_13 ; max = FW_MAX_BONUS_SAVING_THROW_CR_13 ;  break;
   		case 14: min = FW_MIN_BONUS_SAVING_THROW_CR_14 ; max = FW_MAX_BONUS_SAVING_THROW_CR_14 ;  break;
		case 15: min = FW_MIN_BONUS_SAVING_THROW_CR_15 ; max = FW_MAX_BONUS_SAVING_THROW_CR_15 ;  break;
		case 16: min = FW_MIN_BONUS_SAVING_THROW_CR_16 ; max = FW_MAX_BONUS_SAVING_THROW_CR_16 ;  break;
   		case 17: min = FW_MIN_BONUS_SAVING_THROW_CR_17 ; max = FW_MAX_BONUS_SAVING_THROW_CR_17 ;  break;
		case 18: min = FW_MIN_BONUS_SAVING_THROW_CR_18 ; max = FW_MAX_BONUS_SAVING_THROW_CR_18 ;  break;
		case 19: min = FW_MIN_BONUS_SAVING_THROW_CR_19 ; max = FW_MAX_BONUS_SAVING_THROW_CR_19 ;  break;
   		case 20: min = FW_MIN_BONUS_SAVING_THROW_CR_20 ; max = FW_MAX_BONUS_SAVING_THROW_CR_20 ;  break;
   
   		case 21: min = FW_MIN_BONUS_SAVING_THROW_CR_21 ; max = FW_MAX_BONUS_SAVING_THROW_CR_21 ;  break;
		case 22: min = FW_MIN_BONUS_SAVING_THROW_CR_22 ; max = FW_MAX_BONUS_SAVING_THROW_CR_22 ;  break;
		case 23: min = FW_MIN_BONUS_SAVING_THROW_CR_23 ; max = FW_MAX_BONUS_SAVING_THROW_CR_23 ;  break;
   		case 24: min = FW_MIN_BONUS_SAVING_THROW_CR_24 ; max = FW_MAX_BONUS_SAVING_THROW_CR_24 ;  break;
		case 25: min = FW_MIN_BONUS_SAVING_THROW_CR_25 ; max = FW_MAX_BONUS_SAVING_THROW_CR_25 ;  break;
		case 26: min = FW_MIN_BONUS_SAVING_THROW_CR_26 ; max = FW_MAX_BONUS_SAVING_THROW_CR_26 ;  break;
   		case 27: min = FW_MIN_BONUS_SAVING_THROW_CR_27 ; max = FW_MAX_BONUS_SAVING_THROW_CR_27 ;  break;
		case 28: min = FW_MIN_BONUS_SAVING_THROW_CR_28 ; max = FW_MAX_BONUS_SAVING_THROW_CR_28 ;  break;
		case 29: min = FW_MIN_BONUS_SAVING_THROW_CR_29 ; max = FW_MAX_BONUS_SAVING_THROW_CR_29 ;  break;
   		case 30: min = FW_MIN_BONUS_SAVING_THROW_CR_30 ; max = FW_MAX_BONUS_SAVING_THROW_CR_30 ;  break;		
		
		case 31: min = FW_MIN_BONUS_SAVING_THROW_CR_31 ; max = FW_MAX_BONUS_SAVING_THROW_CR_31 ;  break;
		case 32: min = FW_MIN_BONUS_SAVING_THROW_CR_32 ; max = FW_MAX_BONUS_SAVING_THROW_CR_32 ;  break;
		case 33: min = FW_MIN_BONUS_SAVING_THROW_CR_33 ; max = FW_MAX_BONUS_SAVING_THROW_CR_33 ;  break;
   		case 34: min = FW_MIN_BONUS_SAVING_THROW_CR_34 ; max = FW_MAX_BONUS_SAVING_THROW_CR_34 ;  break;
		case 35: min = FW_MIN_BONUS_SAVING_THROW_CR_35 ; max = FW_MAX_BONUS_SAVING_THROW_CR_35 ;  break;
		case 36: min = FW_MIN_BONUS_SAVING_THROW_CR_36 ; max = FW_MAX_BONUS_SAVING_THROW_CR_36 ;  break;
   		case 37: min = FW_MIN_BONUS_SAVING_THROW_CR_37 ; max = FW_MAX_BONUS_SAVING_THROW_CR_37 ;  break;
		case 38: min = FW_MIN_BONUS_SAVING_THROW_CR_38 ; max = FW_MAX_BONUS_SAVING_THROW_CR_38 ;  break;
		case 39: min = FW_MIN_BONUS_SAVING_THROW_CR_39 ; max = FW_MAX_BONUS_SAVING_THROW_CR_39 ;  break;
   		case 40: min = FW_MIN_BONUS_SAVING_THROW_CR_40 ; max = FW_MAX_BONUS_SAVING_THROW_CR_40 ;  break;
		
		case 41: min = FW_MIN_BONUS_SAVING_THROW_CR_41_OR_HIGHER; max = FW_MAX_BONUS_SAVING_THROW_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int nBaseSaveType;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   int iRoll = Random (3);
   switch (iRoll)
   {
      case 0: nBaseSaveType = IP_CONST_SAVEBASETYPE_FORTITUDE;
         break;
      case 1: nBaseSaveType = IP_CONST_SAVEBASETYPE_REFLEX;
         break;
      case 2: nBaseSaveType = IP_CONST_SAVEBASETYPE_WILL;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyBonusSavingThrow(nBaseSaveType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw VS 'XYZ' to add to an
// * Item. Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Bonus_Saving_Throw_VsX (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_BONUS_SAVING_THROW_VSX == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_BONUS_SAVING_THROW_VSX_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_BONUS_SAVING_THROW_VSX_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_0 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_0 ;    break;
		
		case 1: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_1 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_1 ;    break;
		case 2: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_2 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_2 ;    break;
		case 3: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_3 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_3 ;    break;
   		case 4: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_4 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_4 ;    break;
		case 5: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_5 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_5 ;    break;
		case 6: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_6 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_6 ;    break;
   		case 7: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_7 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_7 ;    break;
		case 8: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_8 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_8 ;    break;
		case 9: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_9 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_9 ;    break;
   		case 10: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_10 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_10 ; break;
		
		case 11: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_11 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_11 ;  break;
		case 12: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_12 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_12 ;  break;
		case 13: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_13 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_13 ;  break;
   		case 14: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_14 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_14 ;  break;
		case 15: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_15 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_15 ;  break;
		case 16: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_16 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_16 ;  break;
   		case 17: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_17 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_17 ;  break;
		case 18: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_18 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_18 ;  break;
		case 19: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_19 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_19 ;  break;
   		case 20: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_20 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_20 ;  break;
   
   		case 21: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_21 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_21 ;  break;
		case 22: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_22 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_22 ;  break;
		case 23: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_23 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_23 ;  break;
   		case 24: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_24 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_24 ;  break;
		case 25: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_25 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_25 ;  break;
		case 26: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_26 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_26 ;  break;
   		case 27: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_27 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_27 ;  break;
		case 28: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_28 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_28 ;  break;
		case 29: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_29 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_29 ;  break;
   		case 30: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_30 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_30 ;  break;		
		
		case 31: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_31 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_31 ;  break;
		case 32: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_32 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_32 ;  break;
		case 33: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_33 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_33 ;  break;
   		case 34: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_34 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_34 ;  break;
		case 35: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_35 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_35 ;  break;
		case 36: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_36 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_36 ;  break;
   		case 37: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_37 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_37 ;  break;
		case 38: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_38 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_38 ;  break;
		case 39: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_39 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_39 ;  break;
   		case 40: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_40 ; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_40 ;  break;
		
		case 41: min = FW_MIN_BONUS_SAVING_THROW_VSX_CR_41_OR_HIGHER; max = FW_MAX_BONUS_SAVING_THROW_VSX_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nBonusType;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   int iRoll = Random (14);
   switch (iRoll)
   {
      case 0: nBonusType = IP_CONST_SAVEVS_ACID;
         break;
      case 1: nBonusType = IP_CONST_SAVEVS_COLD;
         break;
      case 2: nBonusType = IP_CONST_SAVEVS_DEATH;
         break;
      case 3: nBonusType = IP_CONST_SAVEVS_DISEASE;
         break;
      case 4: nBonusType = IP_CONST_SAVEVS_DIVINE;
         break;
      case 5: nBonusType = IP_CONST_SAVEVS_ELECTRICAL;
         break;
      case 6: nBonusType = IP_CONST_SAVEVS_FEAR;
         break;
      case 7: nBonusType = IP_CONST_SAVEVS_FIRE;
         break;
      case 8: nBonusType = IP_CONST_SAVEVS_MINDAFFECTING;
         break;
      case 9: nBonusType = IP_CONST_SAVEVS_NEGATIVE;
         break;
      case 10: nBonusType = IP_CONST_SAVEVS_POISON;
         break;
      case 11: nBonusType = IP_CONST_SAVEVS_POSITIVE;
         break;
      case 12: nBonusType = IP_CONST_SAVEVS_SONIC;
         break;
      case 13: nBonusType = IP_CONST_SAVEVS_UNIVERSAL;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyBonusSavingThrowVsX(nBonusType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a bonus spell resistance to add to an item.
// * Values for min and max should be an integer between 10 and 32 in even
// * increments of 2. I.E. 10,12,14,16,18,20,22,24,26,28,30,32
//
itemproperty FW_Choose_IP_Bonus_Spell_Resistance (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_BONUS_SPELL_RESISTANCE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// Note: Different formula than normal.
		max = FloatToInt(nCR * FW_MAX_BONUS_SPELL_RESISTANCE_MODIFIER) ;
		min = FloatToInt(nCR * FW_MIN_BONUS_SPELL_RESISTANCE_MODIFIER) ;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_0 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_0 ;    break;
		
		case 1: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_1 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_1 ;    break;
		case 2: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_2 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_2 ;    break;
		case 3: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_3 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_3 ;    break;
   		case 4: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_4 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_4 ;    break;
		case 5: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_5 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_5 ;    break;
		case 6: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_6 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_6 ;    break;
   		case 7: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_7 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_7 ;    break;
		case 8: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_8 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_8 ;    break;
		case 9: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_9 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_9 ;    break;
   		case 10: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_10 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_10 ; break;
		
		case 11: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_11 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_11 ;  break;
		case 12: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_12 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_12 ;  break;
		case 13: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_13 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_13 ;  break;
   		case 14: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_14 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_14 ;  break;
		case 15: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_15 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_15 ;  break;
		case 16: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_16 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_16 ;  break;
   		case 17: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_17 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_17 ;  break;
		case 18: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_18 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_18 ;  break;
		case 19: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_19 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_19 ;  break;
   		case 20: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_20 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_21 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_21 ;  break;
		case 22: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_22 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_22 ;  break;
		case 23: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_23 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_23 ;  break;
   		case 24: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_24 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_24 ;  break;
		case 25: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_25 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_25 ;  break;
		case 26: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_26 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_26 ;  break;
   		case 27: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_27 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_27 ;  break;
		case 28: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_28 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_28 ;  break;
		case 29: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_29 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_29 ;  break;
   		case 30: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_30 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_31 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_31 ;  break;
		case 32: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_32 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_32 ;  break;
		case 33: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_33 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_33 ;  break;
   		case 34: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_34 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_34 ;  break;
		case 35: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_35 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_35 ;  break;
		case 36: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_36 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_36 ;  break;
   		case 37: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_37 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_37 ;  break;
		case 38: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_38 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_38 ;  break;
		case 39: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_39 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_39 ;  break;
   		case 40: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_40 ; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_40 ;  break;
		
		case 41: min = FW_MIN_BONUS_SPELL_RESISTANCE_CR_41_OR_HIGHER; max = FW_MAX_BONUS_SPELL_RESISTANCE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of switch
   int iBonus;

   // This is to stop people placing values outside the limits of 10 and 32.
   if (min < 10)
      min = 10;
   if (min > 32)
      min = 32;
   if (max < 10)
      max = 10;
   if (max > 32)
      max = 32;

   int iValue1 = (min - 10) / 2;
   int iValue2 = (max - 10) / 2;
   int nMappedValue = iValue2 - iValue1 + 1;
   int iRoll = Random(nMappedValue)+ iValue1;
   switch (iRoll)
   {
      case 0: iBonus = IP_CONST_SPELLRESISTANCEBONUS_10;
         break;
      case 1: iBonus = IP_CONST_SPELLRESISTANCEBONUS_12;
         break;
      case 2: iBonus = IP_CONST_SPELLRESISTANCEBONUS_14;
         break;
      case 3: iBonus = IP_CONST_SPELLRESISTANCEBONUS_16;
         break;
      case 4: iBonus = IP_CONST_SPELLRESISTANCEBONUS_18;
         break;
      case 5: iBonus = IP_CONST_SPELLRESISTANCEBONUS_20;
         break;
      case 6: iBonus = IP_CONST_SPELLRESISTANCEBONUS_22;
         break;
      case 7: iBonus = IP_CONST_SPELLRESISTANCEBONUS_24;
         break;
      case 8: iBonus = IP_CONST_SPELLRESISTANCEBONUS_26;
         break;
      case 9: iBonus = IP_CONST_SPELLRESISTANCEBONUS_28;
         break;
      case 10: iBonus = IP_CONST_SPELLRESISTANCEBONUS_30;
         break;
      case 11: iBonus = IP_CONST_SPELLRESISTANCEBONUS_32;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = IP_CONST_SPELLRESISTANCEBONUS_10;  }
   ipAdd = ItemPropertyBonusSpellResistance(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a spell to be added to an item as a cast
// * spell item property.
//
itemproperty FW_Choose_IP_Cast_Spell ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_CAST_SPELL == FALSE)
      return ipAdd;
   int iSpellId;
   int nNumUses;
   int nReRoll = TRUE;

   while (nReRoll)
   {
      // As of 10 July 2007 there are 646 spells in NWN 2. See "iprp_spells.2da"
      iSpellId = Random (646);
      switch (iSpellId)
      {
	  		// Excluding spells here that were deleted, but still have entries
			// in iprp_spells.2da and they didn't set Label to "****". 
			// LEAVE THESE ALONE.  YOU EXCLUDE SPELLS IN THE SECTION BELOW THIS ONE
			case 200: case 314: case 315: case 316: case 317: case 318: case 319:
			case 320: case 329: case 335: case 344: case 351: case 353: case 359: 
			case 370: case 372: case 452: case 453: case 454: case 459: case 460:
			case 462: case 463: case 465: case 468: case 469: case 470: case 471: 
			case 478: case 496: case 497: case 498: case 499: case 500: case 513:
			case 536: case 537: case 540: case 553: case 607: case 608: case 609: 
			nReRoll = TRUE;
			break; 
        //**************************************
        //
        //  EXCLUDE SPELLS IN THIS SECTION
        //
        // I gave 3 examples below of how to exclude a bonus spell from being
        // added to an item.  In the examples, if Aid(3), Awaken(9), or Bane(5)
        // is rolled as a random cast spell, then the generator re-rolls until a
        // spell that isn't disallowed below is found.  If you uncomment
        // this section of code, ALWAYS leave the default alone.  The default
        // guarantees that this function doesn't get stuck in a loop forever
        // by setting nReRoll to FALSE.  Don't change it.  Substitute the
        // IP_CONST_CASTSPELL_* that you do not want to appear in for one of my
        // examples. If you desire to disallow more than 3, then you'll need
        // to make additional case statements like in the examples shown.
        //
        //
        // WARNING: There is a possibility of creating significant lag if you
        //    have a whole lot of disallowed spells with only a couple of
        //    acceptable ones. The reason is the while statement keeps
        //    re-rolling a number between 0 and 646.  It might take it a LONG
        //    time to pick an acceptable spell if you disallow almost everything.
        //    It would be better to rewrite this function a different way if you
        //    are going to disallow more than half of the spells.
        // VITALLY IMPORTANT NOTE: Don't disallow everything or else this will
        //    crash the game because it will get stuck in a loop forever. If you
        //    want to disallow ALL spells from appearing on an item, do so
        //    by setting FW_ALLOW_CAST_SPELL = FALSE;
        /*
        case IP_CONST_CASTSPELL_AID_3: nReRoll = TRUE;
           break;
        case IP_CONST_CASTSPELL_AWAKEN_9: nReRoll = TRUE;
           break;
        case IP_CONST_CASTSPELL_BANE_5: nReRoll = TRUE;
           break;
        */
        //**************************************
        // We found an acceptable spell!! NEVER CHANGE THE DEFAULT FROM FALSE.
        default: nReRoll = FALSE;
           break;
      } // end of switch

      // Here I am going to see if the random generator rolled a spell that was
      // removed.  In the .2da file iprp_spells if a spell has been removed its
      // label value is equal to "****"  The Get2DAString function Returns ""
      // (empty string) for "****".  If we rolled a spell that was removed, then
      // we need to reroll, so I set nReRoll = TRUE to force a reroll.
      string sCheck = "";
      string sLabel;
      sLabel = Get2DAString ("iprp_spells", "Label", iSpellId);
      if (sLabel == sCheck)
         nReRoll = TRUE;
   } // end of while

   // Now we have to choose a random number of uses.
   int iRoll = Random (7);
   switch (iRoll)
   {
      case 0: nNumUses = IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE;
         break;
      case 1: nNumUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
         break;
      case 2: nNumUses = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
         break;
      case 3: nNumUses = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
         break;
      case 4: nNumUses = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
         break;
      case 5: nNumUses = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;
         break;
      case 6: nNumUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
         break;
   }
   // Now that we have a spell chosen and the number of uses we can finally
   // make the itemproperty work.
   ipAdd = ItemPropertyCastSpell (iSpellId, nNumUses);
   return ipAdd;
} // end of function

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage bonus to be added
// * to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_BONUS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// NOTE: DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGE_BONUS_MODIFIER) - 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_BONUS_MODIFIER) - 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_BONUS_CR_0 ; max = FW_MAX_DAMAGE_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_BONUS_CR_1 ; max = FW_MAX_DAMAGE_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_BONUS_CR_2 ; max = FW_MAX_DAMAGE_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_BONUS_CR_3 ; max = FW_MAX_DAMAGE_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_BONUS_CR_4 ; max = FW_MAX_DAMAGE_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_BONUS_CR_5 ; max = FW_MAX_DAMAGE_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_BONUS_CR_6 ; max = FW_MAX_DAMAGE_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_BONUS_CR_7 ; max = FW_MAX_DAMAGE_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_BONUS_CR_8 ; max = FW_MAX_DAMAGE_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_BONUS_CR_9 ; max = FW_MAX_DAMAGE_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_BONUS_CR_10 ; max = FW_MAX_DAMAGE_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_BONUS_CR_11 ; max = FW_MAX_DAMAGE_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_BONUS_CR_12 ; max = FW_MAX_DAMAGE_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_BONUS_CR_13 ; max = FW_MAX_DAMAGE_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_BONUS_CR_14 ; max = FW_MAX_DAMAGE_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_BONUS_CR_15 ; max = FW_MAX_DAMAGE_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_BONUS_CR_16 ; max = FW_MAX_DAMAGE_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_BONUS_CR_17 ; max = FW_MAX_DAMAGE_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_BONUS_CR_18 ; max = FW_MAX_DAMAGE_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_BONUS_CR_19 ; max = FW_MAX_DAMAGE_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_BONUS_CR_20 ; max = FW_MAX_DAMAGE_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_BONUS_CR_21 ; max = FW_MAX_DAMAGE_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_BONUS_CR_22 ; max = FW_MAX_DAMAGE_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_BONUS_CR_23 ; max = FW_MAX_DAMAGE_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_BONUS_CR_24 ; max = FW_MAX_DAMAGE_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_BONUS_CR_25 ; max = FW_MAX_DAMAGE_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_BONUS_CR_26 ; max = FW_MAX_DAMAGE_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_BONUS_CR_27 ; max = FW_MAX_DAMAGE_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_BONUS_CR_28 ; max = FW_MAX_DAMAGE_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_BONUS_CR_29 ; max = FW_MAX_DAMAGE_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_BONUS_CR_30 ; max = FW_MAX_DAMAGE_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_BONUS_CR_31 ; max = FW_MAX_DAMAGE_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_BONUS_CR_32 ; max = FW_MAX_DAMAGE_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_BONUS_CR_33 ; max = FW_MAX_DAMAGE_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_BONUS_CR_34 ; max = FW_MAX_DAMAGE_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_BONUS_CR_35 ; max = FW_MAX_DAMAGE_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_BONUS_CR_36 ; max = FW_MAX_DAMAGE_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_BONUS_CR_37 ; max = FW_MAX_DAMAGE_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_BONUS_CR_38 ; max = FW_MAX_DAMAGE_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_BONUS_CR_39 ; max = FW_MAX_DAMAGE_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_BONUS_CR_40 ; max = FW_MAX_DAMAGE_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_BONUS_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iDamage = FW_Choose_IP_CONST_DAMAGEBONUS (min, max);
   ipAdd = ItemPropertyDamageBonus(iDamageType, iDamage);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an alignment group, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_Align (int nCR = 0)
{
   itemproperty ipAdd;
   if ( FW_ALLOW_DAMAGE_BONUS_VS_ALIGNMENT == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// NOTE DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGE_BONUS_VS_ALIGN_MODIFIER) - 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_BONUS_VS_ALIGN_MODIFIER) - 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_0 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_1 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_2 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_3 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_4 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_5 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_6 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_7 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_8 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_9 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_10 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_11 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_12 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_13 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_14 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_15 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_16 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_17 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_18 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_19 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_20 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_21 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_22 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_23 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_24 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_25 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_26 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_27 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_28 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_29 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_30 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_31 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_32 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_33 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_34 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_35 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_36 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_37 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_38 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_39 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_40 ; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_BONUS_VS_ALIGNMENT_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_BONUS_VS_ALIGNMENT_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nAlignGroup = FW_Choose_IP_CONST_ALIGNMENTGROUP ();
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iDamage = FW_Choose_IP_CONST_DAMAGEBONUS (min, max);
   ipAdd = ItemPropertyDamageBonusVsAlign(nAlignGroup, iDamageType, iDamage);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a race, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_Race (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_BONUS_VS_RACE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// 	NOTE DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGE_BONUS_VS_RACE_MODIFIER) - 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_BONUS_VS_RACE_MODIFIER) - 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_0 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_1 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_2 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_3 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_4 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_5 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_6 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_7 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_8 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_9 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_10 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_11 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_12 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_13 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_14 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_15 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_16 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_17 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_18 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_19 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_20 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_21 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_22 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_23 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_24 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_25 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_26 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_27 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_28 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_29 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_30 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_31 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_32 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_33 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_34 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_35 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_36 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_37 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_38 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_39 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_40 ; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_BONUS_VS_RACE_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_BONUS_VS_RACE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else  
   int nRace = FW_Choose_IP_CONST_RACIALTYPE ();
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iDamage = FW_Choose_IP_CONST_DAMAGEBONUS (min, max);
   ipAdd = ItemPropertyDamageBonusVsRace(nRace, iDamageType, iDamage);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a specific alignment, damage type, and damage
// * bonus to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Bonus_Vs_SAlign (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_BONUS_VS_SALIGNMENT == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// NOTE DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGE_BONUS_VS_SALIGN_MODIFIER) - 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_BONUS_VS_SALIGN_MODIFIER) - 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_0 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_1 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_2 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_3 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_4 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_5 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_6 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_7 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_8 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_9 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_10 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_11 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_12 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_13 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_14 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_15 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_16 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_17 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_18 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_19 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_20 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_21 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_22 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_23 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_24 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_25 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_26 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_27 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_28 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_29 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_30 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_31 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_32 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_33 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_34 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_35 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_36 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_37 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_38 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_39 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_40 ; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_BONUS_VS_SALIGNMENT_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_BONUS_VS_SALIGNMENT_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int nSAlign = FW_Choose_IP_CONST_SALIGN ();
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iDamage = FW_Choose_IP_CONST_DAMAGEBONUS (min, max);
   ipAdd = ItemPropertyDamageBonusVsSAlign(nSAlign, iDamageType, iDamage);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage immunity amount to
// * be added to an item.
//
itemproperty FW_Choose_IP_Damage_Immunity ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_IMMUNITY == FALSE)
      return ipAdd;
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iBonus;
   int iRoll = Random (7);
   switch (iRoll)
   {
      case 0: iBonus = IP_CONST_DAMAGEIMMUNITY_5_PERCENT;
         break;
      case 1: iBonus = IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
         break;
      case 2: iBonus = IP_CONST_DAMAGEIMMUNITY_25_PERCENT;
         break;
      case 3: iBonus = IP_CONST_DAMAGEIMMUNITY_50_PERCENT;
         break;
      case 4: iBonus = IP_CONST_DAMAGEIMMUNITY_75_PERCENT;
         break;
      case 5: iBonus = IP_CONST_DAMAGEIMMUNITY_90_PERCENT;
         break;
      case 6: iBonus = IP_CONST_DAMAGEIMMUNITY_100_PERCENT;
         break;
   }
   ipAdd = ItemPropertyDamageImmunity(iDamageType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a damage penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Damage_Penalty (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_PENALTY == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_DAMAGE_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_PENALTY_CR_0 ; max = FW_MAX_DAMAGE_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_PENALTY_CR_1 ; max = FW_MAX_DAMAGE_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_PENALTY_CR_2 ; max = FW_MAX_DAMAGE_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_PENALTY_CR_3 ; max = FW_MAX_DAMAGE_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_PENALTY_CR_4 ; max = FW_MAX_DAMAGE_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_PENALTY_CR_5 ; max = FW_MAX_DAMAGE_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_PENALTY_CR_6 ; max = FW_MAX_DAMAGE_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_PENALTY_CR_7 ; max = FW_MAX_DAMAGE_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_PENALTY_CR_8 ; max = FW_MAX_DAMAGE_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_PENALTY_CR_9 ; max = FW_MAX_DAMAGE_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_PENALTY_CR_10 ; max = FW_MAX_DAMAGE_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_PENALTY_CR_11 ; max = FW_MAX_DAMAGE_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_PENALTY_CR_12 ; max = FW_MAX_DAMAGE_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_PENALTY_CR_13 ; max = FW_MAX_DAMAGE_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_PENALTY_CR_14 ; max = FW_MAX_DAMAGE_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_PENALTY_CR_15 ; max = FW_MAX_DAMAGE_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_PENALTY_CR_16 ; max = FW_MAX_DAMAGE_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_PENALTY_CR_17 ; max = FW_MAX_DAMAGE_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_PENALTY_CR_18 ; max = FW_MAX_DAMAGE_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_PENALTY_CR_19 ; max = FW_MAX_DAMAGE_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_PENALTY_CR_20 ; max = FW_MAX_DAMAGE_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_PENALTY_CR_21 ; max = FW_MAX_DAMAGE_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_PENALTY_CR_22 ; max = FW_MAX_DAMAGE_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_PENALTY_CR_23 ; max = FW_MAX_DAMAGE_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_PENALTY_CR_24 ; max = FW_MAX_DAMAGE_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_PENALTY_CR_25 ; max = FW_MAX_DAMAGE_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_PENALTY_CR_26 ; max = FW_MAX_DAMAGE_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_PENALTY_CR_27 ; max = FW_MAX_DAMAGE_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_PENALTY_CR_28 ; max = FW_MAX_DAMAGE_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_PENALTY_CR_29 ; max = FW_MAX_DAMAGE_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_PENALTY_CR_30 ; max = FW_MAX_DAMAGE_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_PENALTY_CR_31 ; max = FW_MAX_DAMAGE_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_PENALTY_CR_32 ; max = FW_MAX_DAMAGE_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_PENALTY_CR_33 ; max = FW_MAX_DAMAGE_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_PENALTY_CR_34 ; max = FW_MAX_DAMAGE_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_PENALTY_CR_35 ; max = FW_MAX_DAMAGE_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_PENALTY_CR_36 ; max = FW_MAX_DAMAGE_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_PENALTY_CR_37 ; max = FW_MAX_DAMAGE_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_PENALTY_CR_38 ; max = FW_MAX_DAMAGE_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_PENALTY_CR_39 ; max = FW_MAX_DAMAGE_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_PENALTY_CR_40 ; max = FW_MAX_DAMAGE_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 5)
      min = 5;
   if (max < 1)
      max = 1;
   if (max > 5)
      max = 5;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyDamagePenalty(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an enhancement level that is required to get
// * past the damage reduction as well as choosing the amount of hit points that
// * will be absorbed if the weapon is not of high enough enhancement.
//
itemproperty FW_Choose_IP_Damage_Reduction (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_REDUCTION == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_DAMAGE_REDUCTION_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_REDUCTION_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGE_REDUCTION_CR_0 ; max = FW_MAX_DAMAGE_REDUCTION_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGE_REDUCTION_CR_1 ; max = FW_MAX_DAMAGE_REDUCTION_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGE_REDUCTION_CR_2 ; max = FW_MAX_DAMAGE_REDUCTION_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGE_REDUCTION_CR_3 ; max = FW_MAX_DAMAGE_REDUCTION_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGE_REDUCTION_CR_4 ; max = FW_MAX_DAMAGE_REDUCTION_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGE_REDUCTION_CR_5 ; max = FW_MAX_DAMAGE_REDUCTION_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGE_REDUCTION_CR_6 ; max = FW_MAX_DAMAGE_REDUCTION_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGE_REDUCTION_CR_7 ; max = FW_MAX_DAMAGE_REDUCTION_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGE_REDUCTION_CR_8 ; max = FW_MAX_DAMAGE_REDUCTION_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGE_REDUCTION_CR_9 ; max = FW_MAX_DAMAGE_REDUCTION_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGE_REDUCTION_CR_10 ; max = FW_MAX_DAMAGE_REDUCTION_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGE_REDUCTION_CR_11 ; max = FW_MAX_DAMAGE_REDUCTION_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGE_REDUCTION_CR_12 ; max = FW_MAX_DAMAGE_REDUCTION_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGE_REDUCTION_CR_13 ; max = FW_MAX_DAMAGE_REDUCTION_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGE_REDUCTION_CR_14 ; max = FW_MAX_DAMAGE_REDUCTION_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGE_REDUCTION_CR_15 ; max = FW_MAX_DAMAGE_REDUCTION_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGE_REDUCTION_CR_16 ; max = FW_MAX_DAMAGE_REDUCTION_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGE_REDUCTION_CR_17 ; max = FW_MAX_DAMAGE_REDUCTION_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGE_REDUCTION_CR_18 ; max = FW_MAX_DAMAGE_REDUCTION_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGE_REDUCTION_CR_19 ; max = FW_MAX_DAMAGE_REDUCTION_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGE_REDUCTION_CR_20 ; max = FW_MAX_DAMAGE_REDUCTION_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGE_REDUCTION_CR_21 ; max = FW_MAX_DAMAGE_REDUCTION_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGE_REDUCTION_CR_22 ; max = FW_MAX_DAMAGE_REDUCTION_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGE_REDUCTION_CR_23 ; max = FW_MAX_DAMAGE_REDUCTION_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGE_REDUCTION_CR_24 ; max = FW_MAX_DAMAGE_REDUCTION_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGE_REDUCTION_CR_25 ; max = FW_MAX_DAMAGE_REDUCTION_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGE_REDUCTION_CR_26 ; max = FW_MAX_DAMAGE_REDUCTION_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGE_REDUCTION_CR_27 ; max = FW_MAX_DAMAGE_REDUCTION_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGE_REDUCTION_CR_28 ; max = FW_MAX_DAMAGE_REDUCTION_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGE_REDUCTION_CR_29 ; max = FW_MAX_DAMAGE_REDUCTION_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGE_REDUCTION_CR_30 ; max = FW_MAX_DAMAGE_REDUCTION_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGE_REDUCTION_CR_31 ; max = FW_MAX_DAMAGE_REDUCTION_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGE_REDUCTION_CR_32 ; max = FW_MAX_DAMAGE_REDUCTION_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGE_REDUCTION_CR_33 ; max = FW_MAX_DAMAGE_REDUCTION_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGE_REDUCTION_CR_34 ; max = FW_MAX_DAMAGE_REDUCTION_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGE_REDUCTION_CR_35 ; max = FW_MAX_DAMAGE_REDUCTION_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGE_REDUCTION_CR_36 ; max = FW_MAX_DAMAGE_REDUCTION_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGE_REDUCTION_CR_37 ; max = FW_MAX_DAMAGE_REDUCTION_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGE_REDUCTION_CR_38 ; max = FW_MAX_DAMAGE_REDUCTION_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGE_REDUCTION_CR_39 ; max = FW_MAX_DAMAGE_REDUCTION_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGE_REDUCTION_CR_40 ; max = FW_MAX_DAMAGE_REDUCTION_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGE_REDUCTION_CR_41_OR_HIGHER; max = FW_MAX_DAMAGE_REDUCTION_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int nEnhancement = FW_Choose_IP_CONST_DAMAGEREDUCTION (min, max);

   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// NOTE DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGESOAK_HP_MODIFIER) * 5;
		min = FloatToInt(nCR * FW_MIN_DAMAGESOAK_HP_MODIFIER) * 5;
   }
   else
   { 
   // NOW DETERMINE THE AMOUNT OF HP TO SOAK   
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGESOAK_HP_CR_0 ; max = FW_MAX_DAMAGESOAK_HP_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGESOAK_HP_CR_1 ; max = FW_MAX_DAMAGESOAK_HP_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGESOAK_HP_CR_2 ; max = FW_MAX_DAMAGESOAK_HP_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGESOAK_HP_CR_3 ; max = FW_MAX_DAMAGESOAK_HP_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGESOAK_HP_CR_4 ; max = FW_MAX_DAMAGESOAK_HP_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGESOAK_HP_CR_5 ; max = FW_MAX_DAMAGESOAK_HP_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGESOAK_HP_CR_6 ; max = FW_MAX_DAMAGESOAK_HP_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGESOAK_HP_CR_7 ; max = FW_MAX_DAMAGESOAK_HP_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGESOAK_HP_CR_8 ; max = FW_MAX_DAMAGESOAK_HP_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGESOAK_HP_CR_9 ; max = FW_MAX_DAMAGESOAK_HP_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGESOAK_HP_CR_10 ; max = FW_MAX_DAMAGESOAK_HP_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGESOAK_HP_CR_11 ; max = FW_MAX_DAMAGESOAK_HP_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGESOAK_HP_CR_12 ; max = FW_MAX_DAMAGESOAK_HP_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGESOAK_HP_CR_13 ; max = FW_MAX_DAMAGESOAK_HP_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGESOAK_HP_CR_14 ; max = FW_MAX_DAMAGESOAK_HP_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGESOAK_HP_CR_15 ; max = FW_MAX_DAMAGESOAK_HP_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGESOAK_HP_CR_16 ; max = FW_MAX_DAMAGESOAK_HP_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGESOAK_HP_CR_17 ; max = FW_MAX_DAMAGESOAK_HP_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGESOAK_HP_CR_18 ; max = FW_MAX_DAMAGESOAK_HP_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGESOAK_HP_CR_19 ; max = FW_MAX_DAMAGESOAK_HP_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGESOAK_HP_CR_20 ; max = FW_MAX_DAMAGESOAK_HP_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGESOAK_HP_CR_21 ; max = FW_MAX_DAMAGESOAK_HP_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGESOAK_HP_CR_22 ; max = FW_MAX_DAMAGESOAK_HP_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGESOAK_HP_CR_23 ; max = FW_MAX_DAMAGESOAK_HP_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGESOAK_HP_CR_24 ; max = FW_MAX_DAMAGESOAK_HP_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGESOAK_HP_CR_25 ; max = FW_MAX_DAMAGESOAK_HP_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGESOAK_HP_CR_26 ; max = FW_MAX_DAMAGESOAK_HP_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGESOAK_HP_CR_27 ; max = FW_MAX_DAMAGESOAK_HP_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGESOAK_HP_CR_28 ; max = FW_MAX_DAMAGESOAK_HP_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGESOAK_HP_CR_29 ; max = FW_MAX_DAMAGESOAK_HP_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGESOAK_HP_CR_30 ; max = FW_MAX_DAMAGESOAK_HP_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGESOAK_HP_CR_31 ; max = FW_MAX_DAMAGESOAK_HP_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGESOAK_HP_CR_32 ; max = FW_MAX_DAMAGESOAK_HP_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGESOAK_HP_CR_33 ; max = FW_MAX_DAMAGESOAK_HP_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGESOAK_HP_CR_34 ; max = FW_MAX_DAMAGESOAK_HP_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGESOAK_HP_CR_35 ; max = FW_MAX_DAMAGESOAK_HP_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGESOAK_HP_CR_36 ; max = FW_MAX_DAMAGESOAK_HP_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGESOAK_HP_CR_37 ; max = FW_MAX_DAMAGESOAK_HP_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGESOAK_HP_CR_38 ; max = FW_MAX_DAMAGESOAK_HP_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGESOAK_HP_CR_39 ; max = FW_MAX_DAMAGESOAK_HP_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGESOAK_HP_CR_40 ; max = FW_MAX_DAMAGESOAK_HP_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGESOAK_HP_CR_41_OR_HIGHER; max = FW_MAX_DAMAGESOAK_HP_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else
   int nHPSoak = FW_Choose_IP_CONST_DAMAGESOAK (min, max);
   ipAdd = ItemPropertyDamageReduction (nEnhancement, nHPSoak);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an amount of hit points that will be
// * resisted each round, subject to min and max values. Acceptable values for
// * min and max are: 5,10,15,...,50
//
itemproperty FW_Choose_IP_Damage_Resistance (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_RESISTANCE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// NOTE DIFFERENT FORMULA
		max = FloatToInt(nCR * FW_MAX_DAMAGE_RESISTANCE_MODIFIER) * 5;
		min = FloatToInt(nCR * FW_MIN_DAMAGE_RESISTANCE_MODIFIER) * 5;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_DAMAGERESIST_HP_CR_0 ; max = FW_MAX_DAMAGERESIST_HP_CR_0 ;    break;
		
		case 1: min = FW_MIN_DAMAGERESIST_HP_CR_1 ; max = FW_MAX_DAMAGERESIST_HP_CR_1 ;    break;
		case 2: min = FW_MIN_DAMAGERESIST_HP_CR_2 ; max = FW_MAX_DAMAGERESIST_HP_CR_2 ;    break;
		case 3: min = FW_MIN_DAMAGERESIST_HP_CR_3 ; max = FW_MAX_DAMAGERESIST_HP_CR_3 ;    break;
   		case 4: min = FW_MIN_DAMAGERESIST_HP_CR_4 ; max = FW_MAX_DAMAGERESIST_HP_CR_4 ;    break;
		case 5: min = FW_MIN_DAMAGERESIST_HP_CR_5 ; max = FW_MAX_DAMAGERESIST_HP_CR_5 ;    break;
		case 6: min = FW_MIN_DAMAGERESIST_HP_CR_6 ; max = FW_MAX_DAMAGERESIST_HP_CR_6 ;    break;
   		case 7: min = FW_MIN_DAMAGERESIST_HP_CR_7 ; max = FW_MAX_DAMAGERESIST_HP_CR_7 ;    break;
		case 8: min = FW_MIN_DAMAGERESIST_HP_CR_8 ; max = FW_MAX_DAMAGERESIST_HP_CR_8 ;    break;
		case 9: min = FW_MIN_DAMAGERESIST_HP_CR_9 ; max = FW_MAX_DAMAGERESIST_HP_CR_9 ;    break;
   		case 10: min = FW_MIN_DAMAGERESIST_HP_CR_10 ; max = FW_MAX_DAMAGERESIST_HP_CR_10 ; break;
		
		case 11: min = FW_MIN_DAMAGERESIST_HP_CR_11 ; max = FW_MAX_DAMAGERESIST_HP_CR_11 ;  break;
		case 12: min = FW_MIN_DAMAGERESIST_HP_CR_12 ; max = FW_MAX_DAMAGERESIST_HP_CR_12 ;  break;
		case 13: min = FW_MIN_DAMAGERESIST_HP_CR_13 ; max = FW_MAX_DAMAGERESIST_HP_CR_13 ;  break;
   		case 14: min = FW_MIN_DAMAGERESIST_HP_CR_14 ; max = FW_MAX_DAMAGERESIST_HP_CR_14 ;  break;
		case 15: min = FW_MIN_DAMAGERESIST_HP_CR_15 ; max = FW_MAX_DAMAGERESIST_HP_CR_15 ;  break;
		case 16: min = FW_MIN_DAMAGERESIST_HP_CR_16 ; max = FW_MAX_DAMAGERESIST_HP_CR_16 ;  break;
   		case 17: min = FW_MIN_DAMAGERESIST_HP_CR_17 ; max = FW_MAX_DAMAGERESIST_HP_CR_17 ;  break;
		case 18: min = FW_MIN_DAMAGERESIST_HP_CR_18 ; max = FW_MAX_DAMAGERESIST_HP_CR_18 ;  break;
		case 19: min = FW_MIN_DAMAGERESIST_HP_CR_19 ; max = FW_MAX_DAMAGERESIST_HP_CR_19 ;  break;
   		case 20: min = FW_MIN_DAMAGERESIST_HP_CR_20 ; max = FW_MAX_DAMAGERESIST_HP_CR_20 ;  break;
   
   		case 21: min = FW_MIN_DAMAGERESIST_HP_CR_21 ; max = FW_MAX_DAMAGERESIST_HP_CR_21 ;  break;
		case 22: min = FW_MIN_DAMAGERESIST_HP_CR_22 ; max = FW_MAX_DAMAGERESIST_HP_CR_22 ;  break;
		case 23: min = FW_MIN_DAMAGERESIST_HP_CR_23 ; max = FW_MAX_DAMAGERESIST_HP_CR_23 ;  break;
   		case 24: min = FW_MIN_DAMAGERESIST_HP_CR_24 ; max = FW_MAX_DAMAGERESIST_HP_CR_24 ;  break;
		case 25: min = FW_MIN_DAMAGERESIST_HP_CR_25 ; max = FW_MAX_DAMAGERESIST_HP_CR_25 ;  break;
		case 26: min = FW_MIN_DAMAGERESIST_HP_CR_26 ; max = FW_MAX_DAMAGERESIST_HP_CR_26 ;  break;
   		case 27: min = FW_MIN_DAMAGERESIST_HP_CR_27 ; max = FW_MAX_DAMAGERESIST_HP_CR_27 ;  break;
		case 28: min = FW_MIN_DAMAGERESIST_HP_CR_28 ; max = FW_MAX_DAMAGERESIST_HP_CR_28 ;  break;
		case 29: min = FW_MIN_DAMAGERESIST_HP_CR_29 ; max = FW_MAX_DAMAGERESIST_HP_CR_29 ;  break;
   		case 30: min = FW_MIN_DAMAGERESIST_HP_CR_30 ; max = FW_MAX_DAMAGERESIST_HP_CR_30 ;  break;		
		
		case 31: min = FW_MIN_DAMAGERESIST_HP_CR_31 ; max = FW_MAX_DAMAGERESIST_HP_CR_31 ;  break;
		case 32: min = FW_MIN_DAMAGERESIST_HP_CR_32 ; max = FW_MAX_DAMAGERESIST_HP_CR_32 ;  break;
		case 33: min = FW_MIN_DAMAGERESIST_HP_CR_33 ; max = FW_MAX_DAMAGERESIST_HP_CR_33 ;  break;
   		case 34: min = FW_MIN_DAMAGERESIST_HP_CR_34 ; max = FW_MAX_DAMAGERESIST_HP_CR_34 ;  break;
		case 35: min = FW_MIN_DAMAGERESIST_HP_CR_35 ; max = FW_MAX_DAMAGERESIST_HP_CR_35 ;  break;
		case 36: min = FW_MIN_DAMAGERESIST_HP_CR_36 ; max = FW_MAX_DAMAGERESIST_HP_CR_36 ;  break;
   		case 37: min = FW_MIN_DAMAGERESIST_HP_CR_37 ; max = FW_MAX_DAMAGERESIST_HP_CR_37 ;  break;
		case 38: min = FW_MIN_DAMAGERESIST_HP_CR_38 ; max = FW_MAX_DAMAGERESIST_HP_CR_38 ;  break;
		case 39: min = FW_MIN_DAMAGERESIST_HP_CR_39 ; max = FW_MAX_DAMAGERESIST_HP_CR_39 ;  break;
   		case 40: min = FW_MIN_DAMAGERESIST_HP_CR_40 ; max = FW_MAX_DAMAGERESIST_HP_CR_40 ;  break;
		
		case 41: min = FW_MIN_DAMAGERESIST_HP_CR_41_OR_HIGHER; max = FW_MAX_DAMAGERESIST_HP_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iRoll;
   int nHPResist;
   if (min < 5)
      min = 5;
   if (min > 50)
      min = 50;
   if (max < 5)
      max = 5;
   if (max > 50)
      max = 50;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nHPResist = IP_CONST_DAMAGERESIST_5;  }
   else
   {
      int iValue = (max/5) - (min/5) + 1;
      iRoll = Random(iValue) + (min/5) - 1;
   }
   switch (iRoll)
   {
      case 0: nHPResist = IP_CONST_DAMAGERESIST_5;
         break;
      case 1: nHPResist = IP_CONST_DAMAGERESIST_10;
         break;
      case 2: nHPResist = IP_CONST_DAMAGERESIST_15;
         break;
      case 3: nHPResist = IP_CONST_DAMAGERESIST_20;
         break;
      case 4: nHPResist = IP_CONST_DAMAGERESIST_25;
         break;
      case 5: nHPResist = IP_CONST_DAMAGERESIST_30;
         break;
      case 6: nHPResist = IP_CONST_DAMAGERESIST_35;
         break;
      case 7: nHPResist = IP_CONST_DAMAGERESIST_40;
         break;
      case 8: nHPResist = IP_CONST_DAMAGERESIST_45;
         break;
      case 9: nHPResist = IP_CONST_DAMAGERESIST_50;
         break;
      default: nHPResist = IP_CONST_DAMAGERESIST_5;
         break;
   }
   ipAdd = ItemPropertyDamageResistance (iDamageType, nHPResist);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a damage type and damage vulnerability
// * amount to be added to an item.
//
itemproperty FW_Choose_IP_Damage_Vulnerability ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_DAMAGE_VULNERABILITY == FALSE)
      return ipAdd;
   int iDamageType = FW_Choose_IP_CONST_DAMAGETYPE ();
   int iBonus;
   int iRoll = Random (7);
   switch (iRoll)
   {
      case 0: iBonus = IP_CONST_DAMAGEVULNERABILITY_5_PERCENT;
         break;
      case 1: iBonus = IP_CONST_DAMAGEVULNERABILITY_10_PERCENT;
         break;
      case 2: iBonus = IP_CONST_DAMAGEVULNERABILITY_25_PERCENT;
         break;
      case 3: iBonus = IP_CONST_DAMAGEVULNERABILITY_50_PERCENT;
         break;
      case 4: iBonus = IP_CONST_DAMAGEVULNERABILITY_75_PERCENT;
         break;
      case 5: iBonus = IP_CONST_DAMAGEVULNERABILITY_90_PERCENT;
         break;
      case 6: iBonus = IP_CONST_DAMAGEVULNERABILITY_100_PERCENT;
         break;
   }
   ipAdd = ItemPropertyDamageVulnerability(iDamageType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an ability penalty type and amount.  You can
// * specify the min or max if you want, but any value less than 1 is changed to
// * 1 and any value greater than 10 is changed to 10.  Use ONLY positive
// * integers.  I.E. 1 = -1 penalty, 2 = -2 penalty, etc.
//
itemproperty FW_Choose_IP_Decrease_Ability (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ABILITY_PENALTY == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ABILITY_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ABILITY_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ABILITY_PENALTY_CR_0 ; max = FW_MAX_ABILITY_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_ABILITY_PENALTY_CR_1 ; max = FW_MAX_ABILITY_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_ABILITY_PENALTY_CR_2 ; max = FW_MAX_ABILITY_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_ABILITY_PENALTY_CR_3 ; max = FW_MAX_ABILITY_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_ABILITY_PENALTY_CR_4 ; max = FW_MAX_ABILITY_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_ABILITY_PENALTY_CR_5 ; max = FW_MAX_ABILITY_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_ABILITY_PENALTY_CR_6 ; max = FW_MAX_ABILITY_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_ABILITY_PENALTY_CR_7 ; max = FW_MAX_ABILITY_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_ABILITY_PENALTY_CR_8 ; max = FW_MAX_ABILITY_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_ABILITY_PENALTY_CR_9 ; max = FW_MAX_ABILITY_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_ABILITY_PENALTY_CR_10 ; max = FW_MAX_ABILITY_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_ABILITY_PENALTY_CR_11 ; max = FW_MAX_ABILITY_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_ABILITY_PENALTY_CR_12 ; max = FW_MAX_ABILITY_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_ABILITY_PENALTY_CR_13 ; max = FW_MAX_ABILITY_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_ABILITY_PENALTY_CR_14 ; max = FW_MAX_ABILITY_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_ABILITY_PENALTY_CR_15 ; max = FW_MAX_ABILITY_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_ABILITY_PENALTY_CR_16 ; max = FW_MAX_ABILITY_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_ABILITY_PENALTY_CR_17 ; max = FW_MAX_ABILITY_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_ABILITY_PENALTY_CR_18 ; max = FW_MAX_ABILITY_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_ABILITY_PENALTY_CR_19 ; max = FW_MAX_ABILITY_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_ABILITY_PENALTY_CR_20 ; max = FW_MAX_ABILITY_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ABILITY_PENALTY_CR_21 ; max = FW_MAX_ABILITY_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_ABILITY_PENALTY_CR_22 ; max = FW_MAX_ABILITY_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_ABILITY_PENALTY_CR_23 ; max = FW_MAX_ABILITY_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_ABILITY_PENALTY_CR_24 ; max = FW_MAX_ABILITY_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_ABILITY_PENALTY_CR_25 ; max = FW_MAX_ABILITY_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_ABILITY_PENALTY_CR_26 ; max = FW_MAX_ABILITY_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_ABILITY_PENALTY_CR_27 ; max = FW_MAX_ABILITY_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_ABILITY_PENALTY_CR_28 ; max = FW_MAX_ABILITY_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_ABILITY_PENALTY_CR_29 ; max = FW_MAX_ABILITY_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_ABILITY_PENALTY_CR_30 ; max = FW_MAX_ABILITY_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ABILITY_PENALTY_CR_31 ; max = FW_MAX_ABILITY_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_ABILITY_PENALTY_CR_32 ; max = FW_MAX_ABILITY_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_ABILITY_PENALTY_CR_33 ; max = FW_MAX_ABILITY_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_ABILITY_PENALTY_CR_34 ; max = FW_MAX_ABILITY_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_ABILITY_PENALTY_CR_35 ; max = FW_MAX_ABILITY_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_ABILITY_PENALTY_CR_36 ; max = FW_MAX_ABILITY_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_ABILITY_PENALTY_CR_37 ; max = FW_MAX_ABILITY_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_ABILITY_PENALTY_CR_38 ; max = FW_MAX_ABILITY_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_ABILITY_PENALTY_CR_39 ; max = FW_MAX_ABILITY_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_ABILITY_PENALTY_CR_40 ; max = FW_MAX_ABILITY_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_ABILITY_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_ABILITY_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else
   int nAbility;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 10)
      min = 10;
   if (max < 1)
      max = 1;
   if (max > 10)
      max = 10;
   int iRoll = Random (6);
   switch (iRoll)
   {
      case 0: nAbility = IP_CONST_ABILITY_CHA;
         break;
      case 1: nAbility = IP_CONST_ABILITY_CON;
         break;
      case 2: nAbility = IP_CONST_ABILITY_DEX;
         break;
      case 3: nAbility = IP_CONST_ABILITY_INT;
         break;
      case 4: nAbility = IP_CONST_ABILITY_STR;
         break;
      case 5: nAbility = IP_CONST_ABILITY_WIS;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyDecreaseAbility(nAbility, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Armor Class type and penalty (subject to
// * min and max values.  Use only POSITIVE integers for min and max. 1...5
//
itemproperty FW_Choose_IP_Decrease_AC (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_AC_PENALTY == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_AC_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_AC_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_AC_PENALTY_CR_0 ; max = FW_MAX_AC_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_AC_PENALTY_CR_1 ; max = FW_MAX_AC_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_AC_PENALTY_CR_2 ; max = FW_MAX_AC_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_AC_PENALTY_CR_3 ; max = FW_MAX_AC_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_AC_PENALTY_CR_4 ; max = FW_MAX_AC_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_AC_PENALTY_CR_5 ; max = FW_MAX_AC_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_AC_PENALTY_CR_6 ; max = FW_MAX_AC_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_AC_PENALTY_CR_7 ; max = FW_MAX_AC_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_AC_PENALTY_CR_8 ; max = FW_MAX_AC_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_AC_PENALTY_CR_9 ; max = FW_MAX_AC_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_AC_PENALTY_CR_10 ; max = FW_MAX_AC_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_AC_PENALTY_CR_11 ; max = FW_MAX_AC_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_AC_PENALTY_CR_12 ; max = FW_MAX_AC_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_AC_PENALTY_CR_13 ; max = FW_MAX_AC_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_AC_PENALTY_CR_14 ; max = FW_MAX_AC_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_AC_PENALTY_CR_15 ; max = FW_MAX_AC_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_AC_PENALTY_CR_16 ; max = FW_MAX_AC_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_AC_PENALTY_CR_17 ; max = FW_MAX_AC_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_AC_PENALTY_CR_18 ; max = FW_MAX_AC_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_AC_PENALTY_CR_19 ; max = FW_MAX_AC_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_AC_PENALTY_CR_20 ; max = FW_MAX_AC_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_AC_PENALTY_CR_21 ; max = FW_MAX_AC_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_AC_PENALTY_CR_22 ; max = FW_MAX_AC_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_AC_PENALTY_CR_23 ; max = FW_MAX_AC_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_AC_PENALTY_CR_24 ; max = FW_MAX_AC_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_AC_PENALTY_CR_25 ; max = FW_MAX_AC_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_AC_PENALTY_CR_26 ; max = FW_MAX_AC_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_AC_PENALTY_CR_27 ; max = FW_MAX_AC_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_AC_PENALTY_CR_28 ; max = FW_MAX_AC_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_AC_PENALTY_CR_29 ; max = FW_MAX_AC_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_AC_PENALTY_CR_30 ; max = FW_MAX_AC_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_AC_PENALTY_CR_31 ; max = FW_MAX_AC_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_AC_PENALTY_CR_32 ; max = FW_MAX_AC_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_AC_PENALTY_CR_33 ; max = FW_MAX_AC_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_AC_PENALTY_CR_34 ; max = FW_MAX_AC_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_AC_PENALTY_CR_35 ; max = FW_MAX_AC_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_AC_PENALTY_CR_36 ; max = FW_MAX_AC_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_AC_PENALTY_CR_37 ; max = FW_MAX_AC_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_AC_PENALTY_CR_38 ; max = FW_MAX_AC_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_AC_PENALTY_CR_39 ; max = FW_MAX_AC_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_AC_PENALTY_CR_40 ; max = FW_MAX_AC_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_AC_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_AC_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int nACType;
   int nPenalty;
   if (min < 1)
      min = 1;
   if (min > 5)
      min = 5;
   if (max < 1)
      max = 1;
   if (max > 5)
      max = 5;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nPenalty = 1;  }
   else if (min == max)
      {  nPenalty = min;  }
   else
   {
      int iValue = max - min + 1;
      nPenalty = Random(iValue)+ min;
   }
   int iRoll = Random (5);
   switch (iRoll)
   {
      case 0: nACType = IP_CONST_ACMODIFIERTYPE_ARMOR;
         break;
      case 1: nACType = IP_CONST_ACMODIFIERTYPE_DEFLECTION;
         break;
      case 2: nACType = IP_CONST_ACMODIFIERTYPE_DODGE;
         break;
      case 3: nACType = IP_CONST_ACMODIFIERTYPE_NATURAL;
         break;
      case 4: nACType = IP_CONST_ACMODIFIERTYPE_SHIELD;
         break;
   }
   ipAdd = ItemPropertyDecreaseAC (nACType, nPenalty);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly decreases a skill between 1 and 10 points.
// * Acceptable values for min and max must be POSITIVE integers: 1,2,3,...,10
//
itemproperty FW_Choose_IP_Decrease_Skill (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_SKILL_DECREASE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_SKILL_DECREASE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_SKILL_DECREASE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_SKILL_DECREASE_CR_0 ; max = FW_MAX_SKILL_DECREASE_CR_0 ;    break;
		
		case 1: min = FW_MIN_SKILL_DECREASE_CR_1 ; max = FW_MAX_SKILL_DECREASE_CR_1 ;    break;
		case 2: min = FW_MIN_SKILL_DECREASE_CR_2 ; max = FW_MAX_SKILL_DECREASE_CR_2 ;    break;
		case 3: min = FW_MIN_SKILL_DECREASE_CR_3 ; max = FW_MAX_SKILL_DECREASE_CR_3 ;    break;
   		case 4: min = FW_MIN_SKILL_DECREASE_CR_4 ; max = FW_MAX_SKILL_DECREASE_CR_4 ;    break;
		case 5: min = FW_MIN_SKILL_DECREASE_CR_5 ; max = FW_MAX_SKILL_DECREASE_CR_5 ;    break;
		case 6: min = FW_MIN_SKILL_DECREASE_CR_6 ; max = FW_MAX_SKILL_DECREASE_CR_6 ;    break;
   		case 7: min = FW_MIN_SKILL_DECREASE_CR_7 ; max = FW_MAX_SKILL_DECREASE_CR_7 ;    break;
		case 8: min = FW_MIN_SKILL_DECREASE_CR_8 ; max = FW_MAX_SKILL_DECREASE_CR_8 ;    break;
		case 9: min = FW_MIN_SKILL_DECREASE_CR_9 ; max = FW_MAX_SKILL_DECREASE_CR_9 ;    break;
   		case 10: min = FW_MIN_SKILL_DECREASE_CR_10 ; max = FW_MAX_SKILL_DECREASE_CR_10 ; break;
		
		case 11: min = FW_MIN_SKILL_DECREASE_CR_11 ; max = FW_MAX_SKILL_DECREASE_CR_11 ;  break;
		case 12: min = FW_MIN_SKILL_DECREASE_CR_12 ; max = FW_MAX_SKILL_DECREASE_CR_12 ;  break;
		case 13: min = FW_MIN_SKILL_DECREASE_CR_13 ; max = FW_MAX_SKILL_DECREASE_CR_13 ;  break;
   		case 14: min = FW_MIN_SKILL_DECREASE_CR_14 ; max = FW_MAX_SKILL_DECREASE_CR_14 ;  break;
		case 15: min = FW_MIN_SKILL_DECREASE_CR_15 ; max = FW_MAX_SKILL_DECREASE_CR_15 ;  break;
		case 16: min = FW_MIN_SKILL_DECREASE_CR_16 ; max = FW_MAX_SKILL_DECREASE_CR_16 ;  break;
   		case 17: min = FW_MIN_SKILL_DECREASE_CR_17 ; max = FW_MAX_SKILL_DECREASE_CR_17 ;  break;
		case 18: min = FW_MIN_SKILL_DECREASE_CR_18 ; max = FW_MAX_SKILL_DECREASE_CR_18 ;  break;
		case 19: min = FW_MIN_SKILL_DECREASE_CR_19 ; max = FW_MAX_SKILL_DECREASE_CR_19 ;  break;
   		case 20: min = FW_MIN_SKILL_DECREASE_CR_20 ; max = FW_MAX_SKILL_DECREASE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_SKILL_DECREASE_CR_21 ; max = FW_MAX_SKILL_DECREASE_CR_21 ;  break;
		case 22: min = FW_MIN_SKILL_DECREASE_CR_22 ; max = FW_MAX_SKILL_DECREASE_CR_22 ;  break;
		case 23: min = FW_MIN_SKILL_DECREASE_CR_23 ; max = FW_MAX_SKILL_DECREASE_CR_23 ;  break;
   		case 24: min = FW_MIN_SKILL_DECREASE_CR_24 ; max = FW_MAX_SKILL_DECREASE_CR_24 ;  break;
		case 25: min = FW_MIN_SKILL_DECREASE_CR_25 ; max = FW_MAX_SKILL_DECREASE_CR_25 ;  break;
		case 26: min = FW_MIN_SKILL_DECREASE_CR_26 ; max = FW_MAX_SKILL_DECREASE_CR_26 ;  break;
   		case 27: min = FW_MIN_SKILL_DECREASE_CR_27 ; max = FW_MAX_SKILL_DECREASE_CR_27 ;  break;
		case 28: min = FW_MIN_SKILL_DECREASE_CR_28 ; max = FW_MAX_SKILL_DECREASE_CR_28 ;  break;
		case 29: min = FW_MIN_SKILL_DECREASE_CR_29 ; max = FW_MAX_SKILL_DECREASE_CR_29 ;  break;
   		case 30: min = FW_MIN_SKILL_DECREASE_CR_30 ; max = FW_MAX_SKILL_DECREASE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_SKILL_DECREASE_CR_31 ; max = FW_MAX_SKILL_DECREASE_CR_31 ;  break;
		case 32: min = FW_MIN_SKILL_DECREASE_CR_32 ; max = FW_MAX_SKILL_DECREASE_CR_32 ;  break;
		case 33: min = FW_MIN_SKILL_DECREASE_CR_33 ; max = FW_MAX_SKILL_DECREASE_CR_33 ;  break;
   		case 34: min = FW_MIN_SKILL_DECREASE_CR_34 ; max = FW_MAX_SKILL_DECREASE_CR_34 ;  break;
		case 35: min = FW_MIN_SKILL_DECREASE_CR_35 ; max = FW_MAX_SKILL_DECREASE_CR_35 ;  break;
		case 36: min = FW_MIN_SKILL_DECREASE_CR_36 ; max = FW_MAX_SKILL_DECREASE_CR_36 ;  break;
   		case 37: min = FW_MIN_SKILL_DECREASE_CR_37 ; max = FW_MAX_SKILL_DECREASE_CR_37 ;  break;
		case 38: min = FW_MIN_SKILL_DECREASE_CR_38 ; max = FW_MAX_SKILL_DECREASE_CR_38 ;  break;
		case 39: min = FW_MIN_SKILL_DECREASE_CR_39 ; max = FW_MAX_SKILL_DECREASE_CR_39 ;  break;
   		case 40: min = FW_MIN_SKILL_DECREASE_CR_40 ; max = FW_MAX_SKILL_DECREASE_CR_40 ;  break;
		
		case 41: min = FW_MIN_SKILL_DECREASE_CR_41_OR_HIGHER; max = FW_MAX_SKILL_DECREASE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else 
   int nPenalty;
   int nSkill;
   if (min < 1)
      min = 1;
   if (min > 10)
      min = 10;
   if (max < 1)
      max = 1;
   if (max > 10)
      max = 10;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  nPenalty = 1;  }
   else if (min == max)
      {  nPenalty = min;  }
   else
   {
      int iValue = max - min + 1;
      nPenalty = Random(iValue)+ min;
   }

   int nReRoll = TRUE;
   while (nReRoll)
   {
      // As of 10 July 2007 there are 30 skills in NWN 2. See "skills.2da"
      nSkill = Random (30);
      switch (nSkill)
      {
         // NWN 2 removed the skills: Animal Empathy and Ride. That's what
         // these two checks are for.  Don't change these values.
         // 0 = animal empathy.
         case 0: nReRoll = TRUE;
            break;
         // 28 = ride.
         case 28: nReRoll = TRUE;
            break;

         // If you want to disallow skills, do it here.  I've shown 3 examples
         // of how this is done. change what I've chosen for what you want
         // disallowed.
         /*
         case SKILL_APPRAISE: nReRoll = TRUE;
            break;
         case SKILL_USE_MAGIC_DEVICE: nReRoll = TRUE;
            break;
         case SKILL_TUMBLE: nReRoll = TRUE;
            break;
         */
         //**************************************
         // We found an acceptable spell!!
         // NEVER CHANGE THIS.
         default: nReRoll = FALSE;
            break;
      } // end of switch
   } // end of while
   ipAdd = ItemPropertyDecreaseSkill (nSkill, nPenalty);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus.  Values for min and
// * max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ENHANCEMENT_BONUS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ENHANCEMENT_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ENHANCEMENT_BONUS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ENHANCEMENT_BONUS_CR_0 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_ENHANCEMENT_BONUS_CR_1 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_ENHANCEMENT_BONUS_CR_2 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_ENHANCEMENT_BONUS_CR_3 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_ENHANCEMENT_BONUS_CR_4 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_ENHANCEMENT_BONUS_CR_5 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_ENHANCEMENT_BONUS_CR_6 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_ENHANCEMENT_BONUS_CR_7 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_ENHANCEMENT_BONUS_CR_8 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_ENHANCEMENT_BONUS_CR_9 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_ENHANCEMENT_BONUS_CR_10 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_ENHANCEMENT_BONUS_CR_11 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_ENHANCEMENT_BONUS_CR_12 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_ENHANCEMENT_BONUS_CR_13 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_ENHANCEMENT_BONUS_CR_14 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_ENHANCEMENT_BONUS_CR_15 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_ENHANCEMENT_BONUS_CR_16 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_ENHANCEMENT_BONUS_CR_17 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_ENHANCEMENT_BONUS_CR_18 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_ENHANCEMENT_BONUS_CR_19 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_ENHANCEMENT_BONUS_CR_20 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ENHANCEMENT_BONUS_CR_21 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_ENHANCEMENT_BONUS_CR_22 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_ENHANCEMENT_BONUS_CR_23 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_ENHANCEMENT_BONUS_CR_24 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_ENHANCEMENT_BONUS_CR_25 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_ENHANCEMENT_BONUS_CR_26 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_ENHANCEMENT_BONUS_CR_27 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_ENHANCEMENT_BONUS_CR_28 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_ENHANCEMENT_BONUS_CR_29 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_ENHANCEMENT_BONUS_CR_30 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ENHANCEMENT_BONUS_CR_31 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_ENHANCEMENT_BONUS_CR_32 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_ENHANCEMENT_BONUS_CR_33 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_ENHANCEMENT_BONUS_CR_34 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_ENHANCEMENT_BONUS_CR_35 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_ENHANCEMENT_BONUS_CR_36 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_ENHANCEMENT_BONUS_CR_37 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_ENHANCEMENT_BONUS_CR_38 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_ENHANCEMENT_BONUS_CR_39 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_ENHANCEMENT_BONUS_CR_40 ; max = FW_MAX_ENHANCEMENT_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_ENHANCEMENT_BONUS_CR_41_OR_HIGHER; max = FW_MAX_ENHANCEMENT_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyEnhancementBonus(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus vs. an alignment group.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_Align (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ENHANCEMENT_BONUS_VS_ALIGN == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_0 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_1 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_2 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_3 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_4 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_5 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_6 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_7 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_8 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_9 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_10 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_11 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_12 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_13 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_14 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_15 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_16 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_17 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_18 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_19 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_20 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_21 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_22 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_23 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_24 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_25 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_26 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_27 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_28 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_29 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_30 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_31 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_32 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_33 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_34 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_35 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_36 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_37 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_38 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_39 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_40 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_ENHANCEMENT_BONUS_VS_ALIGN_CR_41_OR_HIGHER; max = FW_MAX_ENHANCEMENT_BONUS_VS_ALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else
   int nAlignGroup = FW_Choose_IP_CONST_ALIGNMENTGROUP ();
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyEnhancementBonusVsAlign(nAlignGroup, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an attack bonus vs. race.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_Race (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ENHANCEMENT_BONUS_VS_RACE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ENHANCEMENT_BONUS_VS_RACE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ENHANCEMENT_BONUS_VS_RACE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_0 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_0 ;    break;
		
		case 1: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_1 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_1 ;    break;
		case 2: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_2 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_2 ;    break;
		case 3: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_3 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_3 ;    break;
   		case 4: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_4 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_4 ;    break;
		case 5: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_5 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_5 ;    break;
		case 6: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_6 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_6 ;    break;
   		case 7: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_7 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_7 ;    break;
		case 8: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_8 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_8 ;    break;
		case 9: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_9 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_9 ;    break;
   		case 10: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_10 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_10 ; break;
		
		case 11: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_11 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_11 ;  break;
		case 12: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_12 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_12 ;  break;
		case 13: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_13 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_13 ;  break;
   		case 14: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_14 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_14 ;  break;
		case 15: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_15 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_15 ;  break;
		case 16: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_16 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_16 ;  break;
   		case 17: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_17 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_17 ;  break;
		case 18: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_18 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_18 ;  break;
		case 19: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_19 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_19 ;  break;
   		case 20: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_20 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_21 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_21 ;  break;
		case 22: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_22 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_22 ;  break;
		case 23: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_23 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_23 ;  break;
   		case 24: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_24 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_24 ;  break;
		case 25: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_25 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_25 ;  break;
		case 26: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_26 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_26 ;  break;
   		case 27: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_27 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_27 ;  break;
		case 28: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_28 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_28 ;  break;
		case 29: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_29 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_29 ;  break;
   		case 30: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_30 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_31 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_31 ;  break;
		case 32: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_32 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_32 ;  break;
		case 33: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_33 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_33 ;  break;
   		case 34: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_34 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_34 ;  break;
		case 35: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_35 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_35 ;  break;
		case 36: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_36 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_36 ;  break;
   		case 37: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_37 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_37 ;  break;
		case 38: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_38 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_38 ;  break;
		case 39: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_39 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_39 ;  break;
   		case 40: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_40 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_40 ;  break;
		
		case 41: min = FW_MIN_ENHANCEMENT_BONUS_VS_RACE_CR_41_OR_HIGHER; max = FW_MAX_ENHANCEMENT_BONUS_VS_RACE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int nRace = FW_Choose_IP_CONST_RACIALTYPE ();
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyEnhancementBonusVsRace(nRace, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement bonus vs. SPECIFIC alignment.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ENHANCEMENT_BONUS_VS_SALIGN == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_0 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_0 ;    break;
		
		case 1: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_1 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_1 ;    break;
		case 2: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_2 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_2 ;    break;
		case 3: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_3 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_3 ;    break;
   		case 4: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_4 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_4 ;    break;
		case 5: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_5 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_5 ;    break;
		case 6: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_6 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_6 ;    break;
   		case 7: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_7 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_7 ;    break;
		case 8: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_8 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_8 ;    break;
		case 9: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_9 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_9 ;    break;
   		case 10: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_10 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_10 ; break;
		
		case 11: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_11 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_11 ;  break;
		case 12: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_12 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_12 ;  break;
		case 13: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_13 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_13 ;  break;
   		case 14: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_14 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_14 ;  break;
		case 15: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_15 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_15 ;  break;
		case 16: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_16 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_16 ;  break;
   		case 17: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_17 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_17 ;  break;
		case 18: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_18 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_18 ;  break;
		case 19: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_19 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_19 ;  break;
   		case 20: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_20 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_21 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_21 ;  break;
		case 22: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_22 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_22 ;  break;
		case 23: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_23 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_23 ;  break;
   		case 24: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_24 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_24 ;  break;
		case 25: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_25 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_25 ;  break;
		case 26: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_26 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_26 ;  break;
   		case 27: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_27 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_27 ;  break;
		case 28: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_28 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_28 ;  break;
		case 29: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_29 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_29 ;  break;
   		case 30: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_30 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_31 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_31 ;  break;
		case 32: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_32 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_32 ;  break;
		case 33: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_33 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_33 ;  break;
   		case 34: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_34 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_34 ;  break;
		case 35: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_35 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_35 ;  break;
		case 36: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_36 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_36 ;  break;
   		case 37: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_37 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_37 ;  break;
		case 38: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_38 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_38 ;  break;
		case 39: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_39 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_39 ;  break;
   		case 40: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_40 ; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_40 ;  break;
		
		case 41: min = FW_MIN_ENHANCEMENT_BONUS_VS_SALIGN_CR_41_OR_HIGHER; max = FW_MAX_ENHANCEMENT_BONUS_VS_SALIGN_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else 
   int nAlign = FW_Choose_IP_CONST_SALIGN ();
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyEnhancementBonusVsSAlign(nAlign, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses an Enhancement penalty.  Values for min and
// * max should be an integer between 1 and 5. Yes that is right. 5 is the max.
//
itemproperty FW_Choose_IP_Enhancement_Penalty (int nCR = 0)
{
   itemproperty ipAdd;
   if ( FW_ALLOW_ENHANCEMENT_PENALTY == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ENHANCEMENT_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ENHANCEMENT_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ENHANCEMENT_PENALTY_CR_0 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_ENHANCEMENT_PENALTY_CR_1 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_ENHANCEMENT_PENALTY_CR_2 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_ENHANCEMENT_PENALTY_CR_3 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_ENHANCEMENT_PENALTY_CR_4 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_ENHANCEMENT_PENALTY_CR_5 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_ENHANCEMENT_PENALTY_CR_6 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_ENHANCEMENT_PENALTY_CR_7 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_ENHANCEMENT_PENALTY_CR_8 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_ENHANCEMENT_PENALTY_CR_9 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_ENHANCEMENT_PENALTY_CR_10 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_ENHANCEMENT_PENALTY_CR_11 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_ENHANCEMENT_PENALTY_CR_12 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_ENHANCEMENT_PENALTY_CR_13 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_ENHANCEMENT_PENALTY_CR_14 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_ENHANCEMENT_PENALTY_CR_15 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_ENHANCEMENT_PENALTY_CR_16 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_ENHANCEMENT_PENALTY_CR_17 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_ENHANCEMENT_PENALTY_CR_18 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_ENHANCEMENT_PENALTY_CR_19 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_ENHANCEMENT_PENALTY_CR_20 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ENHANCEMENT_PENALTY_CR_21 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_ENHANCEMENT_PENALTY_CR_22 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_ENHANCEMENT_PENALTY_CR_23 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_ENHANCEMENT_PENALTY_CR_24 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_ENHANCEMENT_PENALTY_CR_25 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_ENHANCEMENT_PENALTY_CR_26 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_ENHANCEMENT_PENALTY_CR_27 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_ENHANCEMENT_PENALTY_CR_28 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_ENHANCEMENT_PENALTY_CR_29 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_ENHANCEMENT_PENALTY_CR_30 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ENHANCEMENT_PENALTY_CR_31 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_ENHANCEMENT_PENALTY_CR_32 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_ENHANCEMENT_PENALTY_CR_33 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_ENHANCEMENT_PENALTY_CR_34 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_ENHANCEMENT_PENALTY_CR_35 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_ENHANCEMENT_PENALTY_CR_36 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_ENHANCEMENT_PENALTY_CR_37 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_ENHANCEMENT_PENALTY_CR_38 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_ENHANCEMENT_PENALTY_CR_39 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_ENHANCEMENT_PENALTY_CR_40 ; max = FW_MAX_ENHANCEMENT_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_ENHANCEMENT_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_ENHANCEMENT_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 5)
      min = 5;
   if (max < 1)
      max = 1;
   if (max > 5)
      max = 5;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyEnhancementPenalty(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a base damage type to be added to a melee weapon.
// * Only adds Bludgeoning, Slashing, or Piercing damage to a weapon.
//
itemproperty FW_Choose_IP_Extra_Melee_Damage_Type ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_EXTRA_MELEE_DAMAGE_TYPE == FALSE)
      return ipAdd;
   int iDamageType;
   int iRoll = Random(3);
   switch(iRoll)
   {
      case 0: iDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
         break;
      case 1: iDamageType = IP_CONST_DAMAGETYPE_PIERCING;
         break;
      case 2: iDamageType = IP_CONST_DAMAGETYPE_SLASHING;
         break;
      default: break;
   }
   ipAdd = ItemPropertyExtraMeleeDamageType(iDamageType);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a base damage type to be added to a ranged weapon.
// * Only adds Bludgeoning, Slashing, or Piercing damage to a weapon.
//
itemproperty FW_Choose_IP_Extra_Range_Damage_Type ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_EXTRA_RANGE_DAMAGE_TYPE == FALSE)
      return ipAdd;
   int iDamageType;
   int iRoll = Random(3);
   switch(iRoll)
   {
      case 0: iDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
         break;
      case 1: iDamageType = IP_CONST_DAMAGETYPE_PIERCING;
         break;
      case 2: iDamageType = IP_CONST_DAMAGETYPE_SLASHING;
         break;
      default: break;
   }
   ipAdd = ItemPropertyExtraRangeDamageType(iDamageType);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses the level of a healer's kit subject to min and max.
// * Min and Max must be positive integers between 1 and 12:  1,2,3,...,12
//
itemproperty FW_Choose_IP_Healer_Kit (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_HEALER_KIT == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_HEALER_KIT_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_HEALER_KIT_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_HEALER_KIT_CR_0 ; max = FW_MAX_HEALER_KIT_CR_0 ;    break;
		
		case 1: min = FW_MIN_HEALER_KIT_CR_1 ; max = FW_MAX_HEALER_KIT_CR_1 ;    break;
		case 2: min = FW_MIN_HEALER_KIT_CR_2 ; max = FW_MAX_HEALER_KIT_CR_2 ;    break;
		case 3: min = FW_MIN_HEALER_KIT_CR_3 ; max = FW_MAX_HEALER_KIT_CR_3 ;    break;
   		case 4: min = FW_MIN_HEALER_KIT_CR_4 ; max = FW_MAX_HEALER_KIT_CR_4 ;    break;
		case 5: min = FW_MIN_HEALER_KIT_CR_5 ; max = FW_MAX_HEALER_KIT_CR_5 ;    break;
		case 6: min = FW_MIN_HEALER_KIT_CR_6 ; max = FW_MAX_HEALER_KIT_CR_6 ;    break;
   		case 7: min = FW_MIN_HEALER_KIT_CR_7 ; max = FW_MAX_HEALER_KIT_CR_7 ;    break;
		case 8: min = FW_MIN_HEALER_KIT_CR_8 ; max = FW_MAX_HEALER_KIT_CR_8 ;    break;
		case 9: min = FW_MIN_HEALER_KIT_CR_9 ; max = FW_MAX_HEALER_KIT_CR_9 ;    break;
   		case 10: min = FW_MIN_HEALER_KIT_CR_10 ; max = FW_MAX_HEALER_KIT_CR_10 ; break;
		
		case 11: min = FW_MIN_HEALER_KIT_CR_11 ; max = FW_MAX_HEALER_KIT_CR_11 ;  break;
		case 12: min = FW_MIN_HEALER_KIT_CR_12 ; max = FW_MAX_HEALER_KIT_CR_12 ;  break;
		case 13: min = FW_MIN_HEALER_KIT_CR_13 ; max = FW_MAX_HEALER_KIT_CR_13 ;  break;
   		case 14: min = FW_MIN_HEALER_KIT_CR_14 ; max = FW_MAX_HEALER_KIT_CR_14 ;  break;
		case 15: min = FW_MIN_HEALER_KIT_CR_15 ; max = FW_MAX_HEALER_KIT_CR_15 ;  break;
		case 16: min = FW_MIN_HEALER_KIT_CR_16 ; max = FW_MAX_HEALER_KIT_CR_16 ;  break;
   		case 17: min = FW_MIN_HEALER_KIT_CR_17 ; max = FW_MAX_HEALER_KIT_CR_17 ;  break;
		case 18: min = FW_MIN_HEALER_KIT_CR_18 ; max = FW_MAX_HEALER_KIT_CR_18 ;  break;
		case 19: min = FW_MIN_HEALER_KIT_CR_19 ; max = FW_MAX_HEALER_KIT_CR_19 ;  break;
   		case 20: min = FW_MIN_HEALER_KIT_CR_20 ; max = FW_MAX_HEALER_KIT_CR_20 ;  break;
   
   		case 21: min = FW_MIN_HEALER_KIT_CR_21 ; max = FW_MAX_HEALER_KIT_CR_21 ;  break;
		case 22: min = FW_MIN_HEALER_KIT_CR_22 ; max = FW_MAX_HEALER_KIT_CR_22 ;  break;
		case 23: min = FW_MIN_HEALER_KIT_CR_23 ; max = FW_MAX_HEALER_KIT_CR_23 ;  break;
   		case 24: min = FW_MIN_HEALER_KIT_CR_24 ; max = FW_MAX_HEALER_KIT_CR_24 ;  break;
		case 25: min = FW_MIN_HEALER_KIT_CR_25 ; max = FW_MAX_HEALER_KIT_CR_25 ;  break;
		case 26: min = FW_MIN_HEALER_KIT_CR_26 ; max = FW_MAX_HEALER_KIT_CR_26 ;  break;
   		case 27: min = FW_MIN_HEALER_KIT_CR_27 ; max = FW_MAX_HEALER_KIT_CR_27 ;  break;
		case 28: min = FW_MIN_HEALER_KIT_CR_28 ; max = FW_MAX_HEALER_KIT_CR_28 ;  break;
		case 29: min = FW_MIN_HEALER_KIT_CR_29 ; max = FW_MAX_HEALER_KIT_CR_29 ;  break;
   		case 30: min = FW_MIN_HEALER_KIT_CR_30 ; max = FW_MAX_HEALER_KIT_CR_30 ;  break;		
		
		case 31: min = FW_MIN_HEALER_KIT_CR_31 ; max = FW_MAX_HEALER_KIT_CR_31 ;  break;
		case 32: min = FW_MIN_HEALER_KIT_CR_32 ; max = FW_MAX_HEALER_KIT_CR_32 ;  break;
		case 33: min = FW_MIN_HEALER_KIT_CR_33 ; max = FW_MAX_HEALER_KIT_CR_33 ;  break;
   		case 34: min = FW_MIN_HEALER_KIT_CR_34 ; max = FW_MAX_HEALER_KIT_CR_34 ;  break;
		case 35: min = FW_MIN_HEALER_KIT_CR_35 ; max = FW_MAX_HEALER_KIT_CR_35 ;  break;
		case 36: min = FW_MIN_HEALER_KIT_CR_36 ; max = FW_MAX_HEALER_KIT_CR_36 ;  break;
   		case 37: min = FW_MIN_HEALER_KIT_CR_37 ; max = FW_MAX_HEALER_KIT_CR_37 ;  break;
		case 38: min = FW_MIN_HEALER_KIT_CR_38 ; max = FW_MAX_HEALER_KIT_CR_38 ;  break;
		case 39: min = FW_MIN_HEALER_KIT_CR_39 ; max = FW_MAX_HEALER_KIT_CR_39 ;  break;
   		case 40: min = FW_MIN_HEALER_KIT_CR_40 ; max = FW_MAX_HEALER_KIT_CR_40 ;  break;
		
		case 41: min = FW_MIN_HEALER_KIT_CR_41_OR_HIGHER; max = FW_MAX_HEALER_KIT_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 12)
      min = 12;
   if (max < 1)
      max = 1;
   if (max > 12)
      max = 12;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyHealersKit (iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a miscellaneous immunity property for an item.
//
itemproperty FW_Choose_IP_Immunity_Misc ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_IMMUNITY_MISC == FALSE)
      return ipAdd;
   int nImmunityType;
   int iRoll = Random (10);
   switch (iRoll)
   {
      case 0: nImmunityType = IP_CONST_IMMUNITYMISC_BACKSTAB;
         break;
      case 1: nImmunityType = IP_CONST_IMMUNITYMISC_CRITICAL_HITS;
         break;
      case 2: nImmunityType = IP_CONST_IMMUNITYMISC_DEATH_MAGIC;
         break;
      case 3: nImmunityType = IP_CONST_IMMUNITYMISC_DISEASE;
         break;
      case 4: nImmunityType = IP_CONST_IMMUNITYMISC_FEAR;
         break;
      case 5: nImmunityType = IP_CONST_IMMUNITYMISC_KNOCKDOWN;
         break;
      case 6: nImmunityType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
         break;
      case 7: nImmunityType = IP_CONST_IMMUNITYMISC_MINDSPELLS;
         break;
      case 8: nImmunityType = IP_CONST_IMMUNITYMISC_PARALYSIS;
         break;
      case 9: nImmunityType = IP_CONST_IMMUNITYMISC_POISON;
         break;
      default: break;
   }
   ipAdd = ItemPropertyImmunityMisc (nImmunityType);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses an immunity to spell level for an item.  The user
// * becomes immune to all spells of the number chosen and below. Acceptable
// * values for min and max are integers from 1 to 9.  0 is NOT acceptable.
//
itemproperty FW_Choose_IP_Immunity_To_Spell_Level (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_IMMUNITY_TO_SPELL_LEVEL == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_IMMUNITY_TO_SPELL_LEVEL_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_IMMUNITY_TO_SPELL_LEVEL_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_0 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_0 ;    break;
		
		case 1: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_1 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_1 ;    break;
		case 2: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_2 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_2 ;    break;
		case 3: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_3 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_3 ;    break;
   		case 4: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_4 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_4 ;    break;
		case 5: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_5 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_5 ;    break;
		case 6: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_6 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_6 ;    break;
   		case 7: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_7 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_7 ;    break;
		case 8: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_8 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_8 ;    break;
		case 9: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_9 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_9 ;    break;
   		case 10: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_10 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_10 ; break;
		
		case 11: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_11 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_11 ;  break;
		case 12: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_12 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_12 ;  break;
		case 13: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_13 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_13 ;  break;
   		case 14: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_14 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_14 ;  break;
		case 15: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_15 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_15 ;  break;
		case 16: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_16 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_16 ;  break;
   		case 17: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_17 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_17 ;  break;
		case 18: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_18 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_18 ;  break;
		case 19: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_19 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_19 ;  break;
   		case 20: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_20 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_20 ;  break;
   
   		case 21: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_21 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_21 ;  break;
		case 22: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_22 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_22 ;  break;
		case 23: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_23 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_23 ;  break;
   		case 24: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_24 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_24 ;  break;
		case 25: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_25 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_25 ;  break;
		case 26: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_26 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_26 ;  break;
   		case 27: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_27 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_27 ;  break;
		case 28: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_28 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_28 ;  break;
		case 29: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_29 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_29 ;  break;
   		case 30: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_30 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_30 ;  break;		
		
		case 31: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_31 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_31 ;  break;
		case 32: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_32 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_32 ;  break;
		case 33: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_33 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_33 ;  break;
   		case 34: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_34 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_34 ;  break;
		case 35: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_35 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_35 ;  break;
		case 36: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_36 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_36 ;  break;
   		case 37: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_37 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_37 ;  break;
		case 38: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_38 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_38 ;  break;
		case 39: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_39 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_39 ;  break;
   		case 40: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_40 ; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_40 ;  break;
		
		case 41: min = FW_MIN_IMMUNITY_TO_SPELL_LEVEL_CR_41_OR_HIGHER; max = FW_MAX_IMMUNITY_TO_SPELL_LEVEL_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 9)
      min = 9;
   if (max < 1)
      max = 1;
   if (max > 9)
      max = 9;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyImmunityToSpellLevel(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a color and brightness of light to be added to an
// * item.
//
itemproperty FW_Choose_IP_Light()
{
   itemproperty ipAdd;
   if (FW_ALLOW_LIGHT == FALSE)
      return ipAdd;
   int nBrightness;
   int nColor;

   int iRoll = Random (4);
   switch (iRoll)
   {
      case 0: nBrightness = IP_CONST_LIGHTBRIGHTNESS_DIM;
         break;
      case 1: nBrightness = IP_CONST_LIGHTBRIGHTNESS_LOW;
         break;
      case 2: nBrightness = IP_CONST_LIGHTBRIGHTNESS_NORMAL;
         break;
      case 3: nBrightness = IP_CONST_LIGHTBRIGHTNESS_BRIGHT;
         break;
      default: break;
   }
   iRoll = Random (7);
   switch (iRoll)
   {
      case 0: nColor = IP_CONST_LIGHTCOLOR_BLUE;
         break;
      case 1: nColor = IP_CONST_LIGHTCOLOR_GREEN;
         break;
      case 2: nColor = IP_CONST_LIGHTCOLOR_ORANGE;
         break;
      case 3: nColor = IP_CONST_LIGHTCOLOR_PURPLE;
         break;
      case 4: nColor = IP_CONST_LIGHTCOLOR_RED;
         break;
      case 5: nColor = IP_CONST_LIGHTCOLOR_WHITE;
         break;
      case 6: nColor = IP_CONST_LIGHTCOLOR_YELLOW;
         break;
      default: break;
   }
   ipAdd = ItemPropertyLight (nBrightness, nColor);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that limits an item's use to a certain Alignment GROUP.
//
itemproperty FW_Choose_IP_Limit_Use_By_Align ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_LIMIT_USE_BY_ALIGN == FALSE)
      return ipAdd;
   int nAlignGroup = FW_Choose_IP_CONST_ALIGNMENTGROUP ();
   ipAdd = ItemPropertyLimitUseByAlign (nAlignGroup);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that limits an item's use to a certain Class.
//
itemproperty FW_Choose_IP_Limit_Use_By_Class ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_LIMIT_USE_BY_CLASS == FALSE)
      return ipAdd;
   int iClass = FW_Choose_IP_CONST_CLASS ();
   ipAdd = ItemPropertyLimitUseByClass (iClass);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that limits an item's use to a certain Race.
//
itemproperty FW_Choose_IP_Limit_Use_By_Race ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_LIMIT_USE_BY_RACE == FALSE)
      return ipAdd;
   int nRace;

   // Since these are items that PC's will be using, it makes no sense to limit
   // something to a race that a PC cannot play, such as vermin or dragon.
   // As new expansions are released this function will need to be updated with
   // any new racial types that a PC can play. For example, Mask of the Betrayer
   // will add Genasi, which are elementals.  That's why I have elemental here.
   int iRoll = Random (9);
   switch (iRoll)
   {
      case 0: nRace = IP_CONST_RACIALTYPE_DWARF;
         break;
      case 1: nRace = IP_CONST_RACIALTYPE_ELEMENTAL;
         break;
      case 2: nRace = IP_CONST_RACIALTYPE_ELF;
         break;
      case 3: nRace = IP_CONST_RACIALTYPE_GNOME;
         break;
      case 4: nRace = IP_CONST_RACIALTYPE_HALFELF;
         break;
      case 5: nRace = IP_CONST_RACIALTYPE_HALFLING;
         break;
      case 6: nRace = IP_CONST_RACIALTYPE_HALFORC;
         break;
      case 7: nRace = IP_CONST_RACIALTYPE_HUMAN;
         break;
      case 8: nRace = IP_CONST_RACIALTYPE_OUTSIDER;
         break;
      default: break;
   } // end of switch
   ipAdd = ItemPropertyLimitUseByRace (nRace);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that limits an item's use to a certain SPECIFIC alignment.
//
itemproperty FW_Choose_IP_Limit_Use_By_SAlign ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_LIMIT_USE_BY_SALIGN == FALSE)
      return ipAdd;
   int nAlignment = FW_Choose_IP_CONST_SALIGN  ();
   ipAdd = ItemPropertyLimitUseBySAlign (nAlignment);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses an amount of massive critical dmg. bonus to be added
// * to an item.  Min and Max must be POSITIVE integers between 0 and 19. See
// * the table: DAMAGE_BONUS for how to set these values to something different
// * than the default.
//
itemproperty FW_Choose_IP_Massive_Critical (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_MASSIVE_CRITICAL_DAMAGE_BONUS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// note different formula
		max = FloatToInt(nCR * FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_MODIFIER) - 1;
		min = FloatToInt(nCR * FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_MODIFIER) - 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_0 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_1 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_2 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_3 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_4 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_5 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_6 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_7 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_8 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_9 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_10 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_11 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_12 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_13 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_14 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_15 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_16 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_17 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_18 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_19 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_20 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_21 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_22 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_23 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_24 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_25 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_26 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_27 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_28 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_29 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_30 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_31 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_32 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_33 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_34 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_35 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_36 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_37 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_38 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_39 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_40 ; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_41_OR_HIGHER; max = FW_MAX_MASSIVE_CRITICAL_DAMAGE_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus = FW_Choose_IP_CONST_DAMAGEBONUS (min, max);
   ipAdd = ItemPropertyMassiveCritical(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses the Mighty Bonus on a ranged weapon (the maximum
// * strength bonus allowed.  min and max must be positive integers. 1...20
//
itemproperty FW_Choose_IP_Mighty (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_MIGHTY_BONUS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_MIGHTY_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_MIGHTY_BONUS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_MIGHTY_BONUS_CR_0 ; max = FW_MAX_MIGHTY_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_MIGHTY_BONUS_CR_1 ; max = FW_MAX_MIGHTY_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_MIGHTY_BONUS_CR_2 ; max = FW_MAX_MIGHTY_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_MIGHTY_BONUS_CR_3 ; max = FW_MAX_MIGHTY_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_MIGHTY_BONUS_CR_4 ; max = FW_MAX_MIGHTY_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_MIGHTY_BONUS_CR_5 ; max = FW_MAX_MIGHTY_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_MIGHTY_BONUS_CR_6 ; max = FW_MAX_MIGHTY_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_MIGHTY_BONUS_CR_7 ; max = FW_MAX_MIGHTY_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_MIGHTY_BONUS_CR_8 ; max = FW_MAX_MIGHTY_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_MIGHTY_BONUS_CR_9 ; max = FW_MAX_MIGHTY_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_MIGHTY_BONUS_CR_10 ; max = FW_MAX_MIGHTY_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_MIGHTY_BONUS_CR_11 ; max = FW_MAX_MIGHTY_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_MIGHTY_BONUS_CR_12 ; max = FW_MAX_MIGHTY_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_MIGHTY_BONUS_CR_13 ; max = FW_MAX_MIGHTY_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_MIGHTY_BONUS_CR_14 ; max = FW_MAX_MIGHTY_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_MIGHTY_BONUS_CR_15 ; max = FW_MAX_MIGHTY_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_MIGHTY_BONUS_CR_16 ; max = FW_MAX_MIGHTY_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_MIGHTY_BONUS_CR_17 ; max = FW_MAX_MIGHTY_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_MIGHTY_BONUS_CR_18 ; max = FW_MAX_MIGHTY_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_MIGHTY_BONUS_CR_19 ; max = FW_MAX_MIGHTY_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_MIGHTY_BONUS_CR_20 ; max = FW_MAX_MIGHTY_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_MIGHTY_BONUS_CR_21 ; max = FW_MAX_MIGHTY_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_MIGHTY_BONUS_CR_22 ; max = FW_MAX_MIGHTY_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_MIGHTY_BONUS_CR_23 ; max = FW_MAX_MIGHTY_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_MIGHTY_BONUS_CR_24 ; max = FW_MAX_MIGHTY_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_MIGHTY_BONUS_CR_25 ; max = FW_MAX_MIGHTY_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_MIGHTY_BONUS_CR_26 ; max = FW_MAX_MIGHTY_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_MIGHTY_BONUS_CR_27 ; max = FW_MAX_MIGHTY_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_MIGHTY_BONUS_CR_28 ; max = FW_MAX_MIGHTY_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_MIGHTY_BONUS_CR_29 ; max = FW_MAX_MIGHTY_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_MIGHTY_BONUS_CR_30 ; max = FW_MAX_MIGHTY_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_MIGHTY_BONUS_CR_31 ; max = FW_MAX_MIGHTY_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_MIGHTY_BONUS_CR_32 ; max = FW_MAX_MIGHTY_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_MIGHTY_BONUS_CR_33 ; max = FW_MAX_MIGHTY_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_MIGHTY_BONUS_CR_34 ; max = FW_MAX_MIGHTY_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_MIGHTY_BONUS_CR_35 ; max = FW_MAX_MIGHTY_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_MIGHTY_BONUS_CR_36 ; max = FW_MAX_MIGHTY_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_MIGHTY_BONUS_CR_37 ; max = FW_MAX_MIGHTY_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_MIGHTY_BONUS_CR_38 ; max = FW_MAX_MIGHTY_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_MIGHTY_BONUS_CR_39 ; max = FW_MAX_MIGHTY_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_MIGHTY_BONUS_CR_40 ; max = FW_MAX_MIGHTY_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_MIGHTY_BONUS_CR_41_OR_HIGHER; max = FW_MAX_MIGHTY_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   // Mighty
   ipAdd = ItemPropertyMaxRangeStrengthMod (iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses an OnHitCastSpell to be added to an item. Obviously
// * this only works on weapons.
//
itemproperty FW_Choose_IP_On_Hit_Cast_Spell (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ON_HIT_CAST_SPELL == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_ON_HIT_SPELL_LEVEL_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_ON_HIT_SPELL_LEVEL_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_0 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_0 ;    break;
		
		case 1: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_1 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_1 ;    break;
		case 2: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_2 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_2 ;    break;
		case 3: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_3 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_3 ;    break;
   		case 4: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_4 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_4 ;    break;
		case 5: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_5 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_5 ;    break;
		case 6: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_6 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_6 ;    break;
   		case 7: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_7 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_7 ;    break;
		case 8: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_8 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_8 ;    break;
		case 9: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_9 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_9 ;    break;
   		case 10: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_10 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_10 ; break;
		
		case 11: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_11 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_11 ;  break;
		case 12: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_12 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_12 ;  break;
		case 13: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_13 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_13 ;  break;
   		case 14: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_14 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_14 ;  break;
		case 15: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_15 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_15 ;  break;
		case 16: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_16 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_16 ;  break;
   		case 17: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_17 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_17 ;  break;
		case 18: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_18 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_18 ;  break;
		case 19: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_19 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_19 ;  break;
   		case 20: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_20 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_21 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_21 ;  break;
		case 22: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_22 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_22 ;  break;
		case 23: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_23 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_23 ;  break;
   		case 24: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_24 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_24 ;  break;
		case 25: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_25 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_25 ;  break;
		case 26: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_26 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_26 ;  break;
   		case 27: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_27 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_27 ;  break;
		case 28: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_28 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_28 ;  break;
		case 29: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_29 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_29 ;  break;
   		case 30: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_30 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_31 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_31 ;  break;
		case 32: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_32 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_32 ;  break;
		case 33: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_33 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_33 ;  break;
   		case 34: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_34 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_34 ;  break;
		case 35: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_35 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_35 ;  break;
		case 36: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_36 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_36 ;  break;
   		case 37: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_37 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_37 ;  break;
		case 38: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_38 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_38 ;  break;
		case 39: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_39 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_39 ;  break;
   		case 40: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_40 ; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_40 ;  break;
		
		case 41: min = FW_MIN_ON_HIT_SPELL_LEVEL_CR_41_OR_HIGHER; max = FW_MAX_ON_HIT_SPELL_LEVEL_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iSpellId;
   int iLevel;
   int nReRoll = TRUE;

   while (nReRoll)
   {
      // As of 10 July 2007 there are 143 OnHit spells in NWN 2.
      // See "iprp_onhitspell.2da"
      iSpellId = Random (143);
      switch (iSpellId)
      {
        //**************************************
        //
        //  EXCLUDE SPELLS IN THIS SECTION
        //
        // I gave 3 examples below of how to exclude an onhit spell from being
        // added to an item.  In the examples, if Acid Fog, Bane, or Daze is
        // rolled as a random OnHitCastSpell then the generator re-rolls until a
        // spell that isn't disallowed below is found.  If you uncomment
        // this section of code, ALWAYS leave the default alone.  The default
        // guarantees that this function doesn't get stuck in a loop forever
        // by setting nReRoll to FALSE.  Don't change it.  Substitute the
        // IP_CONST_ONHIT_CASTSPELL_* that you do not want to appear in for one
        // of my examples. If you desire to disallow more than 3, then you'll
        // need to make additional case statements like in the examples shown.
        //
        //
        // WARNING: There is a possibility of creating significant lag if you
        //    have a whole lot of disallowed spells with only a couple of
        //    acceptable ones. The reason is the while statement keeps
        //    re-rolling a number between 0 and 142.  It might take it a LONG
        //    time to pick an acceptable spell if you disallow almost everything.
        //    It would be better to rewrite this function a different way if you
        //    are going to disallow more than half of the spells.
        // VITALLY IMPORTANT NOTE: Don't disallow everything or else this will
        //    crash the game because it will get stuck in a loop forever. If you
        //    want to disallow ALL OnHitspells from appearing on an item, do so
        //    by changing the constant FW_ALLOW_ON_HIT_CAST_SPELL = FALSE;
        /*
        case IP_CONST_ONHIT_CASTSPELL_ACID_FOG: nReRoll = TRUE;
           break;
        case IP_CONST_ONHIT_CASTSPELL_BANE: nReRoll = TRUE;
           break;
        case IP_CONST_ONHIT_CASTSPELL_DAZE: nReRoll = TRUE;
           break;
        */
        //**************************************
        // We found an acceptable spell!!
        default: nReRoll = FALSE;
           break;
      } // end of switch

      // Here I am going to see if the random generator rolled a spell that was
      // removed.  In the .2da file iprp_onhitspell if a spell has been removed
      // its label value is equal to "****"  The Get2DAString function Returns
      // "" (empty string) for "****".  If we rolled a spell that was removed,
      // then we need to reroll, so I set nReRoll = TRUE to force a reroll.
      string sCheck = "";
      string sLabel;
      sLabel = Get2DAString ("iprp_onhitspell", "Label", iSpellId);
      if (sLabel == sCheck)
         nReRoll = TRUE;
   } // end of while

   if (min < 1)
      min = 1;
   if (min > 9)
      min = 9;
   if (max < 1)
      max = 1;
   if (max > 9)
      max = 9;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iLevel = 1;  }
   else if (min == max)
      {  iLevel = min;  }
   else
   {
      int iValue = max - min + 1;
      iLevel = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyOnHitCastSpell (iSpellId, iLevel);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses an OnHitProps to be added to an item. Obviously
// * this only works on weapons and armors.
//
itemproperty FW_Choose_IP_On_Hit_Props (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_ON_HIT_PROPS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
   		// note different formula
		max = FloatToInt(nCR * FW_MAX_ON_HIT_SAVE_DC_MODIFIER) ;
		min = FloatToInt(nCR * FW_MIN_ON_HIT_SAVE_DC_MODIFIER) ;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_ON_HIT_SAVE_DC_CR_0 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_0 ;    break;
		
		case 1: min = FW_MIN_ON_HIT_SAVE_DC_CR_1 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_1 ;    break;
		case 2: min = FW_MIN_ON_HIT_SAVE_DC_CR_2 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_2 ;    break;
		case 3: min = FW_MIN_ON_HIT_SAVE_DC_CR_3 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_3 ;    break;
   		case 4: min = FW_MIN_ON_HIT_SAVE_DC_CR_4 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_4 ;    break;
		case 5: min = FW_MIN_ON_HIT_SAVE_DC_CR_5 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_5 ;    break;
		case 6: min = FW_MIN_ON_HIT_SAVE_DC_CR_6 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_6 ;    break;
   		case 7: min = FW_MIN_ON_HIT_SAVE_DC_CR_7 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_7 ;    break;
		case 8: min = FW_MIN_ON_HIT_SAVE_DC_CR_8 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_8 ;    break;
		case 9: min = FW_MIN_ON_HIT_SAVE_DC_CR_9 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_9 ;    break;
   		case 10: min = FW_MIN_ON_HIT_SAVE_DC_CR_10 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_10 ; break;
		
		case 11: min = FW_MIN_ON_HIT_SAVE_DC_CR_11 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_11 ;  break;
		case 12: min = FW_MIN_ON_HIT_SAVE_DC_CR_12 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_12 ;  break;
		case 13: min = FW_MIN_ON_HIT_SAVE_DC_CR_13 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_13 ;  break;
   		case 14: min = FW_MIN_ON_HIT_SAVE_DC_CR_14 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_14 ;  break;
		case 15: min = FW_MIN_ON_HIT_SAVE_DC_CR_15 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_15 ;  break;
		case 16: min = FW_MIN_ON_HIT_SAVE_DC_CR_16 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_16 ;  break;
   		case 17: min = FW_MIN_ON_HIT_SAVE_DC_CR_17 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_17 ;  break;
		case 18: min = FW_MIN_ON_HIT_SAVE_DC_CR_18 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_18 ;  break;
		case 19: min = FW_MIN_ON_HIT_SAVE_DC_CR_19 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_19 ;  break;
   		case 20: min = FW_MIN_ON_HIT_SAVE_DC_CR_20 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_20 ;  break;
   
   		case 21: min = FW_MIN_ON_HIT_SAVE_DC_CR_21 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_21 ;  break;
		case 22: min = FW_MIN_ON_HIT_SAVE_DC_CR_22 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_22 ;  break;
		case 23: min = FW_MIN_ON_HIT_SAVE_DC_CR_23 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_23 ;  break;
   		case 24: min = FW_MIN_ON_HIT_SAVE_DC_CR_24 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_24 ;  break;
		case 25: min = FW_MIN_ON_HIT_SAVE_DC_CR_25 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_25 ;  break;
		case 26: min = FW_MIN_ON_HIT_SAVE_DC_CR_26 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_26 ;  break;
   		case 27: min = FW_MIN_ON_HIT_SAVE_DC_CR_27 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_27 ;  break;
		case 28: min = FW_MIN_ON_HIT_SAVE_DC_CR_28 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_28 ;  break;
		case 29: min = FW_MIN_ON_HIT_SAVE_DC_CR_29 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_29 ;  break;
   		case 30: min = FW_MIN_ON_HIT_SAVE_DC_CR_30 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_30 ;  break;		
		
		case 31: min = FW_MIN_ON_HIT_SAVE_DC_CR_31 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_31 ;  break;
		case 32: min = FW_MIN_ON_HIT_SAVE_DC_CR_32 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_32 ;  break;
		case 33: min = FW_MIN_ON_HIT_SAVE_DC_CR_33 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_33 ;  break;
   		case 34: min = FW_MIN_ON_HIT_SAVE_DC_CR_34 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_34 ;  break;
		case 35: min = FW_MIN_ON_HIT_SAVE_DC_CR_35 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_35 ;  break;
		case 36: min = FW_MIN_ON_HIT_SAVE_DC_CR_36 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_36 ;  break;
   		case 37: min = FW_MIN_ON_HIT_SAVE_DC_CR_37 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_37 ;  break;
		case 38: min = FW_MIN_ON_HIT_SAVE_DC_CR_38 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_38 ;  break;
		case 39: min = FW_MIN_ON_HIT_SAVE_DC_CR_39 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_39 ;  break;
   		case 40: min = FW_MIN_ON_HIT_SAVE_DC_CR_40 ; max = FW_MAX_ON_HIT_SAVE_DC_CR_40 ;  break;
		
		case 41: min = FW_MIN_ON_HIT_SAVE_DC_CR_41_OR_HIGHER; max = FW_MAX_ON_HIT_SAVE_DC_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iSaveDC;
   int nSpecial;
   int iRoll;
   // There are 26 on hit props in "iprp_onhit.2da" As of 10 July 2007
   int nProperty = Random (26);
   // #4 in the .2da was removed. So if we rolled #4, reroll a new one.
   while (nProperty == 4)
   {
      nProperty = Random (26);
   }
   // Keep min and max inside bounds.
   if (min < 14)
      min = 14;
   if (max < 14)
      max = 14;
   if (min > 26)
      min = 26;
   if (max > 26)
      max = 26;
   // In case someone accidentally swapped min and max.	
   if (min > max)
      min = max;
   // Map user inputs to .2da values.	  
   int iValue1 = (min - 14) / 2;
   int iValue2 = (max - 14) / 2;
   int nMappedValue = iValue2 - iValue1 + 1;
   iSaveDC = Random(nMappedValue)+ iValue1;
   switch (iSaveDC)
   {
      case 0: iSaveDC = IP_CONST_ONHIT_SAVEDC_14;
         break;
      case 1: iSaveDC = IP_CONST_ONHIT_SAVEDC_16;
         break;
      case 2: iSaveDC = IP_CONST_ONHIT_SAVEDC_18;
         break;
      case 3: iSaveDC = IP_CONST_ONHIT_SAVEDC_20;
         break;
      case 4: iSaveDC = IP_CONST_ONHIT_SAVEDC_22;
         break;
      case 5: iSaveDC = IP_CONST_ONHIT_SAVEDC_24;
         break;
      case 6: iSaveDC = IP_CONST_ONHIT_SAVEDC_26;
         break;      
      default: break;
   } // end of switch
   
   switch (nProperty)
   {
      case IP_CONST_ONHIT_ABILITYDRAIN:	nSpecial = Random (6);         	
	        break;
	  // All of these look for a duration constant. 
	  case IP_CONST_ONHIT_BLINDNESS: case IP_CONST_ONHIT_CONFUSION:
	  case IP_CONST_ONHIT_DAZE:      case IP_CONST_ONHIT_DEAFNESS:
	  case IP_CONST_ONHIT_DOOM:      case IP_CONST_ONHIT_FEAR:
	  case IP_CONST_ONHIT_HOLD:      case IP_CONST_ONHIT_SILENCE:
	  case IP_CONST_ONHIT_SLEEP:     case IP_CONST_ONHIT_SLOW:
	  case IP_CONST_ONHIT_STUN: 
	  	    // There are 40 in iprp_onhitdur.2da		
	 	    nSpecial = Random (40);	  
	     break;
	  // There are 17 diseases in disease.2da
      case IP_CONST_ONHIT_DISEASE: nSpecial = Random (17); 
	     break;
      // There are 6 types of poisons in iprp_poison.2da
	  case IP_CONST_ONHIT_ITEMPOISON: nSpecial = Random (6);
	     break;
	  // Make use of previous work. 
	  case IP_CONST_ONHIT_SLAYALIGNMENT: nSpecial = FW_Choose_IP_CONST_SALIGN ();
	     break;
	  // Make use of previous work.
	  case IP_CONST_ONHIT_SLAYALIGNMENTGROUP: nSpecial = FW_Choose_IP_CONST_ALIGNMENTGROUP();
	     break;
	  // Make use of previous work.
	  case IP_CONST_ONHIT_SLAYRACE: nSpecial = FW_Choose_IP_CONST_RACIALTYPE();
	     break;
	  // According to the Lexicon, I have to pick a number between 1 to 5
	  case IP_CONST_ONHIT_WOUNDING: nSpecial = Random (5) + 1;
	     break;
	  // According to the Lexicon, I have to pick a number between 1 to 5
      case IP_CONST_ONHIT_LEVELDRAIN: nSpecial = Random (5) + 1;
	     break;	 
		 
	  default: nSpecial = 0;
	     break;   
   }// end of switch.	  
   ipAdd = ItemPropertyOnHitProps(nProperty, iSaveDC, nSpecial);   
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a saving throw penalty to add to an item.
// * Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Reduced_Saving_Throw (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_SAVING_THROW_PENALTY == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_SAVING_THROW_PENALTY_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_SAVING_THROW_PENALTY_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_SAVING_THROW_PENALTY_CR_0 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_0 ;    break;
		
		case 1: min = FW_MIN_SAVING_THROW_PENALTY_CR_1 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_1 ;    break;
		case 2: min = FW_MIN_SAVING_THROW_PENALTY_CR_2 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_2 ;    break;
		case 3: min = FW_MIN_SAVING_THROW_PENALTY_CR_3 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_3 ;    break;
   		case 4: min = FW_MIN_SAVING_THROW_PENALTY_CR_4 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_4 ;    break;
		case 5: min = FW_MIN_SAVING_THROW_PENALTY_CR_5 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_5 ;    break;
		case 6: min = FW_MIN_SAVING_THROW_PENALTY_CR_6 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_6 ;    break;
   		case 7: min = FW_MIN_SAVING_THROW_PENALTY_CR_7 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_7 ;    break;
		case 8: min = FW_MIN_SAVING_THROW_PENALTY_CR_8 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_8 ;    break;
		case 9: min = FW_MIN_SAVING_THROW_PENALTY_CR_9 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_9 ;    break;
   		case 10: min = FW_MIN_SAVING_THROW_PENALTY_CR_10 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_10 ; break;
		
		case 11: min = FW_MIN_SAVING_THROW_PENALTY_CR_11 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_11 ;  break;
		case 12: min = FW_MIN_SAVING_THROW_PENALTY_CR_12 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_12 ;  break;
		case 13: min = FW_MIN_SAVING_THROW_PENALTY_CR_13 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_13 ;  break;
   		case 14: min = FW_MIN_SAVING_THROW_PENALTY_CR_14 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_14 ;  break;
		case 15: min = FW_MIN_SAVING_THROW_PENALTY_CR_15 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_15 ;  break;
		case 16: min = FW_MIN_SAVING_THROW_PENALTY_CR_16 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_16 ;  break;
   		case 17: min = FW_MIN_SAVING_THROW_PENALTY_CR_17 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_17 ;  break;
		case 18: min = FW_MIN_SAVING_THROW_PENALTY_CR_18 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_18 ;  break;
		case 19: min = FW_MIN_SAVING_THROW_PENALTY_CR_19 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_19 ;  break;
   		case 20: min = FW_MIN_SAVING_THROW_PENALTY_CR_20 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_20 ;  break;
   
   		case 21: min = FW_MIN_SAVING_THROW_PENALTY_CR_21 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_21 ;  break;
		case 22: min = FW_MIN_SAVING_THROW_PENALTY_CR_22 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_22 ;  break;
		case 23: min = FW_MIN_SAVING_THROW_PENALTY_CR_23 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_23 ;  break;
   		case 24: min = FW_MIN_SAVING_THROW_PENALTY_CR_24 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_24 ;  break;
		case 25: min = FW_MIN_SAVING_THROW_PENALTY_CR_25 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_25 ;  break;
		case 26: min = FW_MIN_SAVING_THROW_PENALTY_CR_26 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_26 ;  break;
   		case 27: min = FW_MIN_SAVING_THROW_PENALTY_CR_27 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_27 ;  break;
		case 28: min = FW_MIN_SAVING_THROW_PENALTY_CR_28 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_28 ;  break;
		case 29: min = FW_MIN_SAVING_THROW_PENALTY_CR_29 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_29 ;  break;
   		case 30: min = FW_MIN_SAVING_THROW_PENALTY_CR_30 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_30 ;  break;		
		
		case 31: min = FW_MIN_SAVING_THROW_PENALTY_CR_31 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_31 ;  break;
		case 32: min = FW_MIN_SAVING_THROW_PENALTY_CR_32 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_32 ;  break;
		case 33: min = FW_MIN_SAVING_THROW_PENALTY_CR_33 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_33 ;  break;
   		case 34: min = FW_MIN_SAVING_THROW_PENALTY_CR_34 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_34 ;  break;
		case 35: min = FW_MIN_SAVING_THROW_PENALTY_CR_35 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_35 ;  break;
		case 36: min = FW_MIN_SAVING_THROW_PENALTY_CR_36 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_36 ;  break;
   		case 37: min = FW_MIN_SAVING_THROW_PENALTY_CR_37 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_37 ;  break;
		case 38: min = FW_MIN_SAVING_THROW_PENALTY_CR_38 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_38 ;  break;
		case 39: min = FW_MIN_SAVING_THROW_PENALTY_CR_39 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_39 ;  break;
   		case 40: min = FW_MIN_SAVING_THROW_PENALTY_CR_40 ; max = FW_MAX_SAVING_THROW_PENALTY_CR_40 ;  break;
		
		case 41: min = FW_MIN_SAVING_THROW_PENALTY_CR_41_OR_HIGHER; max = FW_MAX_SAVING_THROW_PENALTY_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int nBaseSaveType;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   int iRoll = Random (3);
   switch (iRoll)
   {
      case 0: nBaseSaveType = IP_CONST_SAVEBASETYPE_FORTITUDE;
         break;
      case 1: nBaseSaveType = IP_CONST_SAVEBASETYPE_REFLEX;
         break;
      case 2: nBaseSaveType = IP_CONST_SAVEBASETYPE_WILL;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyReducedSavingThrow(nBaseSaveType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a bonus saving throw VS 'XYZ' to add to an
// * Item. Values for min and max should be an integer between 1 and 20.
//
itemproperty FW_Choose_IP_Reduced_Saving_Throw_VsX (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_SAVING_THROW_PENALTY_VSX == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_SAVING_THROW_PENALTY_VSX_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_SAVING_THROW_PENALTY_VSX_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_0 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_0 ;    break;
		
		case 1: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_1 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_1 ;    break;
		case 2: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_2 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_2 ;    break;
		case 3: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_3 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_3 ;    break;
   		case 4: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_4 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_4 ;    break;
		case 5: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_5 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_5 ;    break;
		case 6: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_6 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_6 ;    break;
   		case 7: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_7 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_7 ;    break;
		case 8: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_8 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_8 ;    break;
		case 9: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_9 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_9 ;    break;
   		case 10: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_10 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_10 ; break;
		
		case 11: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_11 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_11 ;  break;
		case 12: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_12 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_12 ;  break;
		case 13: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_13 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_13 ;  break;
   		case 14: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_14 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_14 ;  break;
		case 15: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_15 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_15 ;  break;
		case 16: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_16 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_16 ;  break;
   		case 17: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_17 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_17 ;  break;
		case 18: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_18 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_18 ;  break;
		case 19: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_19 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_19 ;  break;
   		case 20: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_20 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_20 ;  break;
   
   		case 21: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_21 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_21 ;  break;
		case 22: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_22 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_22 ;  break;
		case 23: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_23 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_23 ;  break;
   		case 24: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_24 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_24 ;  break;
		case 25: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_25 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_25 ;  break;
		case 26: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_26 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_26 ;  break;
   		case 27: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_27 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_27 ;  break;
		case 28: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_28 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_28 ;  break;
		case 29: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_29 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_29 ;  break;
   		case 30: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_30 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_30 ;  break;		
		
		case 31: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_31 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_31 ;  break;
		case 32: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_32 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_32 ;  break;
		case 33: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_33 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_33 ;  break;
   		case 34: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_34 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_34 ;  break;
		case 35: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_35 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_35 ;  break;
		case 36: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_36 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_36 ;  break;
   		case 37: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_37 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_37 ;  break;
		case 38: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_38 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_38 ;  break;
		case 39: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_39 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_39 ;  break;
   		case 40: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_40 ; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_40 ;  break;
		
		case 41: min = FW_MIN_SAVING_THROW_PENALTY_VSX_CR_41_OR_HIGHER; max = FW_MAX_SAVING_THROW_PENALTY_VSX_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int nBonusType;
   int iBonus;

   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   int iRoll = Random (14);
   switch (iRoll)
   {
      case 0: nBonusType = IP_CONST_SAVEVS_ACID;
         break;
      case 1: nBonusType = IP_CONST_SAVEVS_COLD;
         break;
      case 2: nBonusType = IP_CONST_SAVEVS_DEATH;
         break;
      case 3: nBonusType = IP_CONST_SAVEVS_DISEASE;
         break;
      case 4: nBonusType = IP_CONST_SAVEVS_DIVINE;
         break;
      case 5: nBonusType = IP_CONST_SAVEVS_ELECTRICAL;
         break;
      case 6: nBonusType = IP_CONST_SAVEVS_FEAR;
         break;
      case 7: nBonusType = IP_CONST_SAVEVS_FIRE;
         break;
      case 8: nBonusType = IP_CONST_SAVEVS_MINDAFFECTING;
         break;
      case 9: nBonusType = IP_CONST_SAVEVS_NEGATIVE;
         break;
      case 10: nBonusType = IP_CONST_SAVEVS_POISON;
         break;
      case 11: nBonusType = IP_CONST_SAVEVS_POSITIVE;
         break;
      case 12: nBonusType = IP_CONST_SAVEVS_SONIC;
         break;
      case 13: nBonusType = IP_CONST_SAVEVS_UNIVERSAL;
         break;
      default: break;
   } // end of switch
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyReducedSavingThrowVsX(nBonusType, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a regeneration bonus that an item can have.  Subject
// * to min and max values as defined.  Limits for min and max are positive
// * integers between 1 and 20:  1,2,3,...,20
//
itemproperty FW_Choose_IP_Regeneration (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_REGENERATION == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_REGENERATION_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_REGENERATION_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_REGENERATION_CR_0 ; max = FW_MAX_REGENERATION_CR_0 ;    break;
		
		case 1: min = FW_MIN_REGENERATION_CR_1 ; max = FW_MAX_REGENERATION_CR_1 ;    break;
		case 2: min = FW_MIN_REGENERATION_CR_2 ; max = FW_MAX_REGENERATION_CR_2 ;    break;
		case 3: min = FW_MIN_REGENERATION_CR_3 ; max = FW_MAX_REGENERATION_CR_3 ;    break;
   		case 4: min = FW_MIN_REGENERATION_CR_4 ; max = FW_MAX_REGENERATION_CR_4 ;    break;
		case 5: min = FW_MIN_REGENERATION_CR_5 ; max = FW_MAX_REGENERATION_CR_5 ;    break;
		case 6: min = FW_MIN_REGENERATION_CR_6 ; max = FW_MAX_REGENERATION_CR_6 ;    break;
   		case 7: min = FW_MIN_REGENERATION_CR_7 ; max = FW_MAX_REGENERATION_CR_7 ;    break;
		case 8: min = FW_MIN_REGENERATION_CR_8 ; max = FW_MAX_REGENERATION_CR_8 ;    break;
		case 9: min = FW_MIN_REGENERATION_CR_9 ; max = FW_MAX_REGENERATION_CR_9 ;    break;
   		case 10: min = FW_MIN_REGENERATION_CR_10 ; max = FW_MAX_REGENERATION_CR_10 ; break;
		
		case 11: min = FW_MIN_REGENERATION_CR_11 ; max = FW_MAX_REGENERATION_CR_11 ;  break;
		case 12: min = FW_MIN_REGENERATION_CR_12 ; max = FW_MAX_REGENERATION_CR_12 ;  break;
		case 13: min = FW_MIN_REGENERATION_CR_13 ; max = FW_MAX_REGENERATION_CR_13 ;  break;
   		case 14: min = FW_MIN_REGENERATION_CR_14 ; max = FW_MAX_REGENERATION_CR_14 ;  break;
		case 15: min = FW_MIN_REGENERATION_CR_15 ; max = FW_MAX_REGENERATION_CR_15 ;  break;
		case 16: min = FW_MIN_REGENERATION_CR_16 ; max = FW_MAX_REGENERATION_CR_16 ;  break;
   		case 17: min = FW_MIN_REGENERATION_CR_17 ; max = FW_MAX_REGENERATION_CR_17 ;  break;
		case 18: min = FW_MIN_REGENERATION_CR_18 ; max = FW_MAX_REGENERATION_CR_18 ;  break;
		case 19: min = FW_MIN_REGENERATION_CR_19 ; max = FW_MAX_REGENERATION_CR_19 ;  break;
   		case 20: min = FW_MIN_REGENERATION_CR_20 ; max = FW_MAX_REGENERATION_CR_20 ;  break;
   
   		case 21: min = FW_MIN_REGENERATION_CR_21 ; max = FW_MAX_REGENERATION_CR_21 ;  break;
		case 22: min = FW_MIN_REGENERATION_CR_22 ; max = FW_MAX_REGENERATION_CR_22 ;  break;
		case 23: min = FW_MIN_REGENERATION_CR_23 ; max = FW_MAX_REGENERATION_CR_23 ;  break;
   		case 24: min = FW_MIN_REGENERATION_CR_24 ; max = FW_MAX_REGENERATION_CR_24 ;  break;
		case 25: min = FW_MIN_REGENERATION_CR_25 ; max = FW_MAX_REGENERATION_CR_25 ;  break;
		case 26: min = FW_MIN_REGENERATION_CR_26 ; max = FW_MAX_REGENERATION_CR_26 ;  break;
   		case 27: min = FW_MIN_REGENERATION_CR_27 ; max = FW_MAX_REGENERATION_CR_27 ;  break;
		case 28: min = FW_MIN_REGENERATION_CR_28 ; max = FW_MAX_REGENERATION_CR_28 ;  break;
		case 29: min = FW_MIN_REGENERATION_CR_29 ; max = FW_MAX_REGENERATION_CR_29 ;  break;
   		case 30: min = FW_MIN_REGENERATION_CR_30 ; max = FW_MAX_REGENERATION_CR_30 ;  break;		
		
		case 31: min = FW_MIN_REGENERATION_CR_31 ; max = FW_MAX_REGENERATION_CR_31 ;  break;
		case 32: min = FW_MIN_REGENERATION_CR_32 ; max = FW_MAX_REGENERATION_CR_32 ;  break;
		case 33: min = FW_MIN_REGENERATION_CR_33 ; max = FW_MAX_REGENERATION_CR_33 ;  break;
   		case 34: min = FW_MIN_REGENERATION_CR_34 ; max = FW_MAX_REGENERATION_CR_34 ;  break;
		case 35: min = FW_MIN_REGENERATION_CR_35 ; max = FW_MAX_REGENERATION_CR_35 ;  break;
		case 36: min = FW_MIN_REGENERATION_CR_36 ; max = FW_MAX_REGENERATION_CR_36 ;  break;
   		case 37: min = FW_MIN_REGENERATION_CR_37 ; max = FW_MAX_REGENERATION_CR_37 ;  break;
		case 38: min = FW_MIN_REGENERATION_CR_38 ; max = FW_MAX_REGENERATION_CR_38 ;  break;
		case 39: min = FW_MIN_REGENERATION_CR_39 ; max = FW_MAX_REGENERATION_CR_39 ;  break;
   		case 40: min = FW_MIN_REGENERATION_CR_40 ; max = FW_MAX_REGENERATION_CR_40 ;  break;
		
		case 41: min = FW_MIN_REGENERATION_CR_41_OR_HIGHER; max = FW_MAX_REGENERATION_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyRegeneration (iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a skill bonus type and amount to be added to an item.
// * Limits for min and max are 1 and 50:  1,2,3,...,50
//
itemproperty FW_Choose_IP_Skill_Bonus (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_SKILL_BONUS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_SKILL_BONUS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_SKILL_BONUS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_SKILL_BONUS_CR_0 ; max = FW_MAX_SKILL_BONUS_CR_0 ;    break;
		
		case 1: min = FW_MIN_SKILL_BONUS_CR_1 ; max = FW_MAX_SKILL_BONUS_CR_1 ;    break;
		case 2: min = FW_MIN_SKILL_BONUS_CR_2 ; max = FW_MAX_SKILL_BONUS_CR_2 ;    break;
		case 3: min = FW_MIN_SKILL_BONUS_CR_3 ; max = FW_MAX_SKILL_BONUS_CR_3 ;    break;
   		case 4: min = FW_MIN_SKILL_BONUS_CR_4 ; max = FW_MAX_SKILL_BONUS_CR_4 ;    break;
		case 5: min = FW_MIN_SKILL_BONUS_CR_5 ; max = FW_MAX_SKILL_BONUS_CR_5 ;    break;
		case 6: min = FW_MIN_SKILL_BONUS_CR_6 ; max = FW_MAX_SKILL_BONUS_CR_6 ;    break;
   		case 7: min = FW_MIN_SKILL_BONUS_CR_7 ; max = FW_MAX_SKILL_BONUS_CR_7 ;    break;
		case 8: min = FW_MIN_SKILL_BONUS_CR_8 ; max = FW_MAX_SKILL_BONUS_CR_8 ;    break;
		case 9: min = FW_MIN_SKILL_BONUS_CR_9 ; max = FW_MAX_SKILL_BONUS_CR_9 ;    break;
   		case 10: min = FW_MIN_SKILL_BONUS_CR_10 ; max = FW_MAX_SKILL_BONUS_CR_10 ; break;
		
		case 11: min = FW_MIN_SKILL_BONUS_CR_11 ; max = FW_MAX_SKILL_BONUS_CR_11 ;  break;
		case 12: min = FW_MIN_SKILL_BONUS_CR_12 ; max = FW_MAX_SKILL_BONUS_CR_12 ;  break;
		case 13: min = FW_MIN_SKILL_BONUS_CR_13 ; max = FW_MAX_SKILL_BONUS_CR_13 ;  break;
   		case 14: min = FW_MIN_SKILL_BONUS_CR_14 ; max = FW_MAX_SKILL_BONUS_CR_14 ;  break;
		case 15: min = FW_MIN_SKILL_BONUS_CR_15 ; max = FW_MAX_SKILL_BONUS_CR_15 ;  break;
		case 16: min = FW_MIN_SKILL_BONUS_CR_16 ; max = FW_MAX_SKILL_BONUS_CR_16 ;  break;
   		case 17: min = FW_MIN_SKILL_BONUS_CR_17 ; max = FW_MAX_SKILL_BONUS_CR_17 ;  break;
		case 18: min = FW_MIN_SKILL_BONUS_CR_18 ; max = FW_MAX_SKILL_BONUS_CR_18 ;  break;
		case 19: min = FW_MIN_SKILL_BONUS_CR_19 ; max = FW_MAX_SKILL_BONUS_CR_19 ;  break;
   		case 20: min = FW_MIN_SKILL_BONUS_CR_20 ; max = FW_MAX_SKILL_BONUS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_SKILL_BONUS_CR_21 ; max = FW_MAX_SKILL_BONUS_CR_21 ;  break;
		case 22: min = FW_MIN_SKILL_BONUS_CR_22 ; max = FW_MAX_SKILL_BONUS_CR_22 ;  break;
		case 23: min = FW_MIN_SKILL_BONUS_CR_23 ; max = FW_MAX_SKILL_BONUS_CR_23 ;  break;
   		case 24: min = FW_MIN_SKILL_BONUS_CR_24 ; max = FW_MAX_SKILL_BONUS_CR_24 ;  break;
		case 25: min = FW_MIN_SKILL_BONUS_CR_25 ; max = FW_MAX_SKILL_BONUS_CR_25 ;  break;
		case 26: min = FW_MIN_SKILL_BONUS_CR_26 ; max = FW_MAX_SKILL_BONUS_CR_26 ;  break;
   		case 27: min = FW_MIN_SKILL_BONUS_CR_27 ; max = FW_MAX_SKILL_BONUS_CR_27 ;  break;
		case 28: min = FW_MIN_SKILL_BONUS_CR_28 ; max = FW_MAX_SKILL_BONUS_CR_28 ;  break;
		case 29: min = FW_MIN_SKILL_BONUS_CR_29 ; max = FW_MAX_SKILL_BONUS_CR_29 ;  break;
   		case 30: min = FW_MIN_SKILL_BONUS_CR_30 ; max = FW_MAX_SKILL_BONUS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_SKILL_BONUS_CR_31 ; max = FW_MAX_SKILL_BONUS_CR_31 ;  break;
		case 32: min = FW_MIN_SKILL_BONUS_CR_32 ; max = FW_MAX_SKILL_BONUS_CR_32 ;  break;
		case 33: min = FW_MIN_SKILL_BONUS_CR_33 ; max = FW_MAX_SKILL_BONUS_CR_33 ;  break;
   		case 34: min = FW_MIN_SKILL_BONUS_CR_34 ; max = FW_MAX_SKILL_BONUS_CR_34 ;  break;
		case 35: min = FW_MIN_SKILL_BONUS_CR_35 ; max = FW_MAX_SKILL_BONUS_CR_35 ;  break;
		case 36: min = FW_MIN_SKILL_BONUS_CR_36 ; max = FW_MAX_SKILL_BONUS_CR_36 ;  break;
   		case 37: min = FW_MIN_SKILL_BONUS_CR_37 ; max = FW_MAX_SKILL_BONUS_CR_37 ;  break;
		case 38: min = FW_MIN_SKILL_BONUS_CR_38 ; max = FW_MAX_SKILL_BONUS_CR_38 ;  break;
		case 39: min = FW_MIN_SKILL_BONUS_CR_39 ; max = FW_MAX_SKILL_BONUS_CR_39 ;  break;
   		case 40: min = FW_MIN_SKILL_BONUS_CR_40 ; max = FW_MAX_SKILL_BONUS_CR_40 ;  break;
		
		case 41: min = FW_MIN_SKILL_BONUS_CR_41_OR_HIGHER; max = FW_MAX_SKILL_BONUS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   int nSkill;
   if (min < 1)
      min = 1;
   if (min > 50)
      min = 50;
   if (max < 1)
      max = 1;
   if (max > 50)
      max = 50;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }

   int nReRoll = TRUE;
   while (nReRoll)
   {
      // As of 10 July 2007 there are 30 skills in NWN 2. See "skills.2da"
      nSkill = Random (30);
      switch (nSkill)
      {
         // NWN 2 removed the skills: Animal Empathy and Ride. That's what
         // these two checks are for.  Don't change these values.
         // 0 = animal empathy.
         case 0: nReRoll = TRUE;
            break;
         // 28 = ride.
         case 28: nReRoll = TRUE;
            break;

         // If you want to disallow skills, do it here.  I've shown 3 examples
         // of how this is done. change what I've chosen for what you want
         // disallowed.
         /*
         case SKILL_APPRAISE: nReRoll = TRUE;
            break;
         case SKILL_USE_MAGIC_DEVICE: nReRoll = TRUE;
            break;
         case SKILL_TUMBLE: nReRoll = TRUE;
            break;
         */
         //**************************************
         // We found an acceptable spell!!
         // NEVER CHANGE THIS.
         default: nReRoll = FALSE;
            break;
      } // end of switch
   } // end of while
   ipAdd = ItemPropertySkillBonus (nSkill, iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a random spell school immunity to give to an item.
//
itemproperty FW_Choose_IP_Spell_Immunity_School ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_SPELL_IMMUNITY_SCHOOL == FALSE)
      return ipAdd;
   int iRoll;
   int nSpellSchool;

   iRoll = Random (10);
   switch (iRoll)
   {
      case 0: nSpellSchool = IP_CONST_SPELLSCHOOL_ABJURATION;
         break;
      case 1: nSpellSchool = IP_CONST_SPELLSCHOOL_CONJURATION;
         break;
      case 2: nSpellSchool = IP_CONST_SPELLSCHOOL_DIVINATION;
         break;
      case 3: nSpellSchool = IP_CONST_SPELLSCHOOL_ENCHANTMENT;
         break;
      case 4: nSpellSchool = IP_CONST_SPELLSCHOOL_EVOCATION;
         break;
      case 5: nSpellSchool = IP_CONST_SPELLSCHOOL_ILLUSION;
         break;
      case 6: nSpellSchool = IP_CONST_SPELLSCHOOL_NECROMANCY;
         break;
      case 7: nSpellSchool = IP_CONST_SPELLSCHOOL_TRANSMUTATION;
         break;
      default: break;
   }
   ipAdd = ItemPropertySpellImmunitySchool (nSpellSchool);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a random specific spell immunity to give to an item.
//
itemproperty FW_Choose_IP_Spell_Immunity_Specific ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_SPELL_IMMUNITY_SPECIFIC == FALSE)
      return ipAdd;
   int nReRoll = TRUE;
   int iSpellId;
   while (nReRoll)
   {
      // As of 10 July 2007 there are 187 IP_CONST_IMMUNITYSPELL_* to choose.
      iSpellId = Random (188);
      switch (iSpellId)
      {
        //**************************************
        //
        //  EXCLUDE SPELL IMMUNITY SPECIFIC IN THIS SECTION
        //
        // I gave 3 examples below of how to exclude a spell immunity from being
        // added to an item.  In the examples, if Chain Lightning, Darkness, or
        // dispel magic is rolled as a random specific spell immunity, then the
        // generator re-rolls until a spell that isn't disallowed is found.  If
        // you uncomment this section of code, ALWAYS leave the default alone.
        // The default guarantees that this function doesn't get stuck in a loop
        // forever by setting nReRoll to FALSE.  Don't change it.  Substitute
        // the IP_CONST_IMMUNITYSPELL_* that you do not want to appear in for
        // one of my examples. If you desire to disallow more than 3, then
        // you'll need to make additional case statements like in the examples
        // shown.
        //
        //
        // WARNING: There is a possibility of creating significant lag if you
        //    have a whole lot of disallowed spells with only a couple of
        //    acceptable ones. The reason is the while statement keeps
        //    re-rolling a number between 0 and 187.  It might take it a LONG
        //    time to pick an acceptable spell if you disallow almost everything.
        //    It would be better to rewrite this function a different way if you
        //    are going to disallow more than half of the spells.
        // VITALLY IMPORTANT NOTE: Don't disallow everything or else this will
        //    crash the game because it will get stuck in a loop forever. If you
        //    want to disallow ALL spells from appearing on an item, do so
        //    by setting FW_ALLOW_SPELL_IMMUNITY_SPECIFIC = FALSE;
        /*
        case IP_CONST_IMMUNITYSPELL_CHAIN_LIGHTNING: nReRoll = TRUE;
           break;
        case IP_CONST_IMMUNITYSPELL_DARKNESS: nReRoll = TRUE;
           break;
        case IP_CONST_IMMUNITYSPELL_DISPEL_MAGIC: nReRoll = TRUE;
           break;
        */
        //**************************************
        // We found an acceptable spell!!
        // NEVER TAKE THIS OUT OR YOU'LL CRASH THE GAME
        default: nReRoll = FALSE;
           break;
      } // end of switch
   } // end of while
   ipAdd = ItemPropertySpellImmunitySpecific (iSpellId);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses the thieves tools modifier to be added to an item.
// * You can specify the min or max if you want, but any value less than 1 is
// * changed to 1 and any value greater than 12 is changed to 12.
//
itemproperty FW_Choose_IP_Thieves_Tools (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_THIEVES_TOOLS == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_THIEVES_TOOLS_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_THIEVES_TOOLS_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_THIEVES_TOOLS_CR_0 ; max = FW_MAX_THIEVES_TOOLS_CR_0 ;    break;
		
		case 1: min = FW_MIN_THIEVES_TOOLS_CR_1 ; max = FW_MAX_THIEVES_TOOLS_CR_1 ;    break;
		case 2: min = FW_MIN_THIEVES_TOOLS_CR_2 ; max = FW_MAX_THIEVES_TOOLS_CR_2 ;    break;
		case 3: min = FW_MIN_THIEVES_TOOLS_CR_3 ; max = FW_MAX_THIEVES_TOOLS_CR_3 ;    break;
   		case 4: min = FW_MIN_THIEVES_TOOLS_CR_4 ; max = FW_MAX_THIEVES_TOOLS_CR_4 ;    break;
		case 5: min = FW_MIN_THIEVES_TOOLS_CR_5 ; max = FW_MAX_THIEVES_TOOLS_CR_5 ;    break;
		case 6: min = FW_MIN_THIEVES_TOOLS_CR_6 ; max = FW_MAX_THIEVES_TOOLS_CR_6 ;    break;
   		case 7: min = FW_MIN_THIEVES_TOOLS_CR_7 ; max = FW_MAX_THIEVES_TOOLS_CR_7 ;    break;
		case 8: min = FW_MIN_THIEVES_TOOLS_CR_8 ; max = FW_MAX_THIEVES_TOOLS_CR_8 ;    break;
		case 9: min = FW_MIN_THIEVES_TOOLS_CR_9 ; max = FW_MAX_THIEVES_TOOLS_CR_9 ;    break;
   		case 10: min = FW_MIN_THIEVES_TOOLS_CR_10 ; max = FW_MAX_THIEVES_TOOLS_CR_10 ; break;
		
		case 11: min = FW_MIN_THIEVES_TOOLS_CR_11 ; max = FW_MAX_THIEVES_TOOLS_CR_11 ;  break;
		case 12: min = FW_MIN_THIEVES_TOOLS_CR_12 ; max = FW_MAX_THIEVES_TOOLS_CR_12 ;  break;
		case 13: min = FW_MIN_THIEVES_TOOLS_CR_13 ; max = FW_MAX_THIEVES_TOOLS_CR_13 ;  break;
   		case 14: min = FW_MIN_THIEVES_TOOLS_CR_14 ; max = FW_MAX_THIEVES_TOOLS_CR_14 ;  break;
		case 15: min = FW_MIN_THIEVES_TOOLS_CR_15 ; max = FW_MAX_THIEVES_TOOLS_CR_15 ;  break;
		case 16: min = FW_MIN_THIEVES_TOOLS_CR_16 ; max = FW_MAX_THIEVES_TOOLS_CR_16 ;  break;
   		case 17: min = FW_MIN_THIEVES_TOOLS_CR_17 ; max = FW_MAX_THIEVES_TOOLS_CR_17 ;  break;
		case 18: min = FW_MIN_THIEVES_TOOLS_CR_18 ; max = FW_MAX_THIEVES_TOOLS_CR_18 ;  break;
		case 19: min = FW_MIN_THIEVES_TOOLS_CR_19 ; max = FW_MAX_THIEVES_TOOLS_CR_19 ;  break;
   		case 20: min = FW_MIN_THIEVES_TOOLS_CR_20 ; max = FW_MAX_THIEVES_TOOLS_CR_20 ;  break;
   
   		case 21: min = FW_MIN_THIEVES_TOOLS_CR_21 ; max = FW_MAX_THIEVES_TOOLS_CR_21 ;  break;
		case 22: min = FW_MIN_THIEVES_TOOLS_CR_22 ; max = FW_MAX_THIEVES_TOOLS_CR_22 ;  break;
		case 23: min = FW_MIN_THIEVES_TOOLS_CR_23 ; max = FW_MAX_THIEVES_TOOLS_CR_23 ;  break;
   		case 24: min = FW_MIN_THIEVES_TOOLS_CR_24 ; max = FW_MAX_THIEVES_TOOLS_CR_24 ;  break;
		case 25: min = FW_MIN_THIEVES_TOOLS_CR_25 ; max = FW_MAX_THIEVES_TOOLS_CR_25 ;  break;
		case 26: min = FW_MIN_THIEVES_TOOLS_CR_26 ; max = FW_MAX_THIEVES_TOOLS_CR_26 ;  break;
   		case 27: min = FW_MIN_THIEVES_TOOLS_CR_27 ; max = FW_MAX_THIEVES_TOOLS_CR_27 ;  break;
		case 28: min = FW_MIN_THIEVES_TOOLS_CR_28 ; max = FW_MAX_THIEVES_TOOLS_CR_28 ;  break;
		case 29: min = FW_MIN_THIEVES_TOOLS_CR_29 ; max = FW_MAX_THIEVES_TOOLS_CR_29 ;  break;
   		case 30: min = FW_MIN_THIEVES_TOOLS_CR_30 ; max = FW_MAX_THIEVES_TOOLS_CR_30 ;  break;		
		
		case 31: min = FW_MIN_THIEVES_TOOLS_CR_31 ; max = FW_MAX_THIEVES_TOOLS_CR_31 ;  break;
		case 32: min = FW_MIN_THIEVES_TOOLS_CR_32 ; max = FW_MAX_THIEVES_TOOLS_CR_32 ;  break;
		case 33: min = FW_MIN_THIEVES_TOOLS_CR_33 ; max = FW_MAX_THIEVES_TOOLS_CR_33 ;  break;
   		case 34: min = FW_MIN_THIEVES_TOOLS_CR_34 ; max = FW_MAX_THIEVES_TOOLS_CR_34 ;  break;
		case 35: min = FW_MIN_THIEVES_TOOLS_CR_35 ; max = FW_MAX_THIEVES_TOOLS_CR_35 ;  break;
		case 36: min = FW_MIN_THIEVES_TOOLS_CR_36 ; max = FW_MAX_THIEVES_TOOLS_CR_36 ;  break;
   		case 37: min = FW_MIN_THIEVES_TOOLS_CR_37 ; max = FW_MAX_THIEVES_TOOLS_CR_37 ;  break;
		case 38: min = FW_MIN_THIEVES_TOOLS_CR_38 ; max = FW_MAX_THIEVES_TOOLS_CR_38 ;  break;
		case 39: min = FW_MIN_THIEVES_TOOLS_CR_39 ; max = FW_MAX_THIEVES_TOOLS_CR_39 ;  break;
   		case 40: min = FW_MIN_THIEVES_TOOLS_CR_40 ; max = FW_MAX_THIEVES_TOOLS_CR_40 ;  break;
		
		case 41: min = FW_MIN_THIEVES_TOOLS_CR_41_OR_HIGHER; max = FW_MAX_THIEVES_TOOLS_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch 	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 12)
      min = 12;
   if (max < 1)
      max = 1;
   if (max > 12)
      max = 12;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyThievesTools(iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a random amount of turn resistance to be added to an
// * item. Limits for min and max are 1 and 50:  1,2,3,...,50
//
itemproperty FW_Choose_IP_Turn_Resistance (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_TURN_RESISTANCE == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_TURN_RESISTANCE_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_TURN_RESISTANCE_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_TURN_RESISTANCE_CR_0 ; max = FW_MAX_TURN_RESISTANCE_CR_0 ;    break;
		
		case 1: min = FW_MIN_TURN_RESISTANCE_CR_1 ; max = FW_MAX_TURN_RESISTANCE_CR_1 ;    break;
		case 2: min = FW_MIN_TURN_RESISTANCE_CR_2 ; max = FW_MAX_TURN_RESISTANCE_CR_2 ;    break;
		case 3: min = FW_MIN_TURN_RESISTANCE_CR_3 ; max = FW_MAX_TURN_RESISTANCE_CR_3 ;    break;
   		case 4: min = FW_MIN_TURN_RESISTANCE_CR_4 ; max = FW_MAX_TURN_RESISTANCE_CR_4 ;    break;
		case 5: min = FW_MIN_TURN_RESISTANCE_CR_5 ; max = FW_MAX_TURN_RESISTANCE_CR_5 ;    break;
		case 6: min = FW_MIN_TURN_RESISTANCE_CR_6 ; max = FW_MAX_TURN_RESISTANCE_CR_6 ;    break;
   		case 7: min = FW_MIN_TURN_RESISTANCE_CR_7 ; max = FW_MAX_TURN_RESISTANCE_CR_7 ;    break;
		case 8: min = FW_MIN_TURN_RESISTANCE_CR_8 ; max = FW_MAX_TURN_RESISTANCE_CR_8 ;    break;
		case 9: min = FW_MIN_TURN_RESISTANCE_CR_9 ; max = FW_MAX_TURN_RESISTANCE_CR_9 ;    break;
   		case 10: min = FW_MIN_TURN_RESISTANCE_CR_10 ; max = FW_MAX_TURN_RESISTANCE_CR_10 ; break;
		
		case 11: min = FW_MIN_TURN_RESISTANCE_CR_11 ; max = FW_MAX_TURN_RESISTANCE_CR_11 ;  break;
		case 12: min = FW_MIN_TURN_RESISTANCE_CR_12 ; max = FW_MAX_TURN_RESISTANCE_CR_12 ;  break;
		case 13: min = FW_MIN_TURN_RESISTANCE_CR_13 ; max = FW_MAX_TURN_RESISTANCE_CR_13 ;  break;
   		case 14: min = FW_MIN_TURN_RESISTANCE_CR_14 ; max = FW_MAX_TURN_RESISTANCE_CR_14 ;  break;
		case 15: min = FW_MIN_TURN_RESISTANCE_CR_15 ; max = FW_MAX_TURN_RESISTANCE_CR_15 ;  break;
		case 16: min = FW_MIN_TURN_RESISTANCE_CR_16 ; max = FW_MAX_TURN_RESISTANCE_CR_16 ;  break;
   		case 17: min = FW_MIN_TURN_RESISTANCE_CR_17 ; max = FW_MAX_TURN_RESISTANCE_CR_17 ;  break;
		case 18: min = FW_MIN_TURN_RESISTANCE_CR_18 ; max = FW_MAX_TURN_RESISTANCE_CR_18 ;  break;
		case 19: min = FW_MIN_TURN_RESISTANCE_CR_19 ; max = FW_MAX_TURN_RESISTANCE_CR_19 ;  break;
   		case 20: min = FW_MIN_TURN_RESISTANCE_CR_20 ; max = FW_MAX_TURN_RESISTANCE_CR_20 ;  break;
   
   		case 21: min = FW_MIN_TURN_RESISTANCE_CR_21 ; max = FW_MAX_TURN_RESISTANCE_CR_21 ;  break;
		case 22: min = FW_MIN_TURN_RESISTANCE_CR_22 ; max = FW_MAX_TURN_RESISTANCE_CR_22 ;  break;
		case 23: min = FW_MIN_TURN_RESISTANCE_CR_23 ; max = FW_MAX_TURN_RESISTANCE_CR_23 ;  break;
   		case 24: min = FW_MIN_TURN_RESISTANCE_CR_24 ; max = FW_MAX_TURN_RESISTANCE_CR_24 ;  break;
		case 25: min = FW_MIN_TURN_RESISTANCE_CR_25 ; max = FW_MAX_TURN_RESISTANCE_CR_25 ;  break;
		case 26: min = FW_MIN_TURN_RESISTANCE_CR_26 ; max = FW_MAX_TURN_RESISTANCE_CR_26 ;  break;
   		case 27: min = FW_MIN_TURN_RESISTANCE_CR_27 ; max = FW_MAX_TURN_RESISTANCE_CR_27 ;  break;
		case 28: min = FW_MIN_TURN_RESISTANCE_CR_28 ; max = FW_MAX_TURN_RESISTANCE_CR_28 ;  break;
		case 29: min = FW_MIN_TURN_RESISTANCE_CR_29 ; max = FW_MAX_TURN_RESISTANCE_CR_29 ;  break;
   		case 30: min = FW_MIN_TURN_RESISTANCE_CR_30 ; max = FW_MAX_TURN_RESISTANCE_CR_30 ;  break;		
		
		case 31: min = FW_MIN_TURN_RESISTANCE_CR_31 ; max = FW_MAX_TURN_RESISTANCE_CR_31 ;  break;
		case 32: min = FW_MIN_TURN_RESISTANCE_CR_32 ; max = FW_MAX_TURN_RESISTANCE_CR_32 ;  break;
		case 33: min = FW_MIN_TURN_RESISTANCE_CR_33 ; max = FW_MAX_TURN_RESISTANCE_CR_33 ;  break;
   		case 34: min = FW_MIN_TURN_RESISTANCE_CR_34 ; max = FW_MAX_TURN_RESISTANCE_CR_34 ;  break;
		case 35: min = FW_MIN_TURN_RESISTANCE_CR_35 ; max = FW_MAX_TURN_RESISTANCE_CR_35 ;  break;
		case 36: min = FW_MIN_TURN_RESISTANCE_CR_36 ; max = FW_MAX_TURN_RESISTANCE_CR_36 ;  break;
   		case 37: min = FW_MIN_TURN_RESISTANCE_CR_37 ; max = FW_MAX_TURN_RESISTANCE_CR_37 ;  break;
		case 38: min = FW_MIN_TURN_RESISTANCE_CR_38 ; max = FW_MAX_TURN_RESISTANCE_CR_38 ;  break;
		case 39: min = FW_MIN_TURN_RESISTANCE_CR_39 ; max = FW_MAX_TURN_RESISTANCE_CR_39 ;  break;
   		case 40: min = FW_MIN_TURN_RESISTANCE_CR_40 ; max = FW_MAX_TURN_RESISTANCE_CR_40 ;  break;
		
		case 41: min = FW_MIN_TURN_RESISTANCE_CR_41_OR_HIGHER; max = FW_MAX_TURN_RESISTANCE_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 50)
      min = 50;
   if (max < 1)
      max = 1;
   if (max > 50)
      max = 50;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyTurnResistance (iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses the unlimited ammo item property and also the amount
// * (if any) of extra damage that will be done.
//
itemproperty FW_Choose_IP_Unlimited_Ammo ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_UNLIMITED_AMMO == FALSE)
      return ipAdd;
   int nAmmoDamage;
   int iRoll = Random (9);
   switch (iRoll)
   {
      case 0: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_BASIC;
         break;
      case 1: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_PLUS1;
         break;
      case 2: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_PLUS2;
         break;
      case 3: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_PLUS3;
         break;
      case 4: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_1D6COLD;
         break;
      case 5: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_1D6FIRE;
         break;
      case 6: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
         break;
      case 7: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_PLUS4;
         break;
      case 8: nAmmoDamage = IP_CONST_UNLIMITEDAMMO_PLUS5;
         break;
   }
   ipAdd = ItemPropertyUnlimitedAmmo (nAmmoDamage);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that chooses a vampiric regeneration bonus that an item can have.
// * Limits for min and max are positive integers: 1,2,3,...,20
//
itemproperty FW_Choose_IP_Vampiric_Regeneration (int nCR = 0)
{
   itemproperty ipAdd;
   if (FW_ALLOW_VAMPIRIC_REGENERATION == FALSE)
      return ipAdd;
	  
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_VAMPIRIC_REGENERATION_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_VAMPIRIC_REGENERATION_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_VAMPIRIC_REGENERATION_CR_0 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_0 ;    break;
		
		case 1: min = FW_MIN_VAMPIRIC_REGENERATION_CR_1 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_1 ;    break;
		case 2: min = FW_MIN_VAMPIRIC_REGENERATION_CR_2 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_2 ;    break;
		case 3: min = FW_MIN_VAMPIRIC_REGENERATION_CR_3 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_3 ;    break;
   		case 4: min = FW_MIN_VAMPIRIC_REGENERATION_CR_4 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_4 ;    break;
		case 5: min = FW_MIN_VAMPIRIC_REGENERATION_CR_5 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_5 ;    break;
		case 6: min = FW_MIN_VAMPIRIC_REGENERATION_CR_6 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_6 ;    break;
   		case 7: min = FW_MIN_VAMPIRIC_REGENERATION_CR_7 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_7 ;    break;
		case 8: min = FW_MIN_VAMPIRIC_REGENERATION_CR_8 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_8 ;    break;
		case 9: min = FW_MIN_VAMPIRIC_REGENERATION_CR_9 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_9 ;    break;
   		case 10: min = FW_MIN_VAMPIRIC_REGENERATION_CR_10 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_10 ; break;
		
		case 11: min = FW_MIN_VAMPIRIC_REGENERATION_CR_11 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_11 ;  break;
		case 12: min = FW_MIN_VAMPIRIC_REGENERATION_CR_12 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_12 ;  break;
		case 13: min = FW_MIN_VAMPIRIC_REGENERATION_CR_13 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_13 ;  break;
   		case 14: min = FW_MIN_VAMPIRIC_REGENERATION_CR_14 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_14 ;  break;
		case 15: min = FW_MIN_VAMPIRIC_REGENERATION_CR_15 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_15 ;  break;
		case 16: min = FW_MIN_VAMPIRIC_REGENERATION_CR_16 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_16 ;  break;
   		case 17: min = FW_MIN_VAMPIRIC_REGENERATION_CR_17 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_17 ;  break;
		case 18: min = FW_MIN_VAMPIRIC_REGENERATION_CR_18 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_18 ;  break;
		case 19: min = FW_MIN_VAMPIRIC_REGENERATION_CR_19 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_19 ;  break;
   		case 20: min = FW_MIN_VAMPIRIC_REGENERATION_CR_20 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_20 ;  break;
   
   		case 21: min = FW_MIN_VAMPIRIC_REGENERATION_CR_21 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_21 ;  break;
		case 22: min = FW_MIN_VAMPIRIC_REGENERATION_CR_22 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_22 ;  break;
		case 23: min = FW_MIN_VAMPIRIC_REGENERATION_CR_23 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_23 ;  break;
   		case 24: min = FW_MIN_VAMPIRIC_REGENERATION_CR_24 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_24 ;  break;
		case 25: min = FW_MIN_VAMPIRIC_REGENERATION_CR_25 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_25 ;  break;
		case 26: min = FW_MIN_VAMPIRIC_REGENERATION_CR_26 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_26 ;  break;
   		case 27: min = FW_MIN_VAMPIRIC_REGENERATION_CR_27 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_27 ;  break;
		case 28: min = FW_MIN_VAMPIRIC_REGENERATION_CR_28 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_28 ;  break;
		case 29: min = FW_MIN_VAMPIRIC_REGENERATION_CR_29 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_29 ;  break;
   		case 30: min = FW_MIN_VAMPIRIC_REGENERATION_CR_30 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_30 ;  break;		
		
		case 31: min = FW_MIN_VAMPIRIC_REGENERATION_CR_31 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_31 ;  break;
		case 32: min = FW_MIN_VAMPIRIC_REGENERATION_CR_32 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_32 ;  break;
		case 33: min = FW_MIN_VAMPIRIC_REGENERATION_CR_33 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_33 ;  break;
   		case 34: min = FW_MIN_VAMPIRIC_REGENERATION_CR_34 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_34 ;  break;
		case 35: min = FW_MIN_VAMPIRIC_REGENERATION_CR_35 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_35 ;  break;
		case 36: min = FW_MIN_VAMPIRIC_REGENERATION_CR_36 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_36 ;  break;
   		case 37: min = FW_MIN_VAMPIRIC_REGENERATION_CR_37 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_37 ;  break;
		case 38: min = FW_MIN_VAMPIRIC_REGENERATION_CR_38 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_38 ;  break;
		case 39: min = FW_MIN_VAMPIRIC_REGENERATION_CR_39 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_39 ;  break;
   		case 40: min = FW_MIN_VAMPIRIC_REGENERATION_CR_40 ; max = FW_MAX_VAMPIRIC_REGENERATION_CR_40 ;  break;
		
		case 41: min = FW_MIN_VAMPIRIC_REGENERATION_CR_41_OR_HIGHER; max = FW_MAX_VAMPIRIC_REGENERATION_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch	  
   } // end of else	  
   int iBonus;
   if (min < 1)
      min = 1;
   if (min > 20)
      min = 20;
   if (max < 1)
      max = 1;
   if (max > 20)
      max = 20;
   // This check is to stop people who inadvertently place a larger value on
   // the max than they have on the min.
   if (min > max)
      {  iBonus = 1;  }
   else if (min == max)
      {  iBonus = min;  }
   else
   {
      int iValue = max - min + 1;
      iBonus = Random(iValue)+ min;
   }
   ipAdd = ItemPropertyVampiricRegeneration (iBonus);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a weight increase to be added to an item
// * from the IP_CONST_WEIGHTINCREASE_* values.  Possible return values are: 5,
// * 10, 15, 30, 50, and 100 pounds.
//
itemproperty FW_Choose_IP_Weight_Increase ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_WEIGHT_INCREASE == FALSE)
      return ipAdd;
   int nWeight;
   int iRoll = Random (6);
   switch (iRoll)
   {
      case 0: nWeight = IP_CONST_WEIGHTINCREASE_5_LBS;
         break;
      case 1: nWeight = IP_CONST_WEIGHTINCREASE_10_LBS;
         break;
      case 2: nWeight = IP_CONST_WEIGHTINCREASE_15_LBS;
         break;
      case 3: nWeight = IP_CONST_WEIGHTINCREASE_30_LBS;
         break;
      case 4: nWeight = IP_CONST_WEIGHTINCREASE_50_LBS;
         break;
      case 5: nWeight = IP_CONST_WEIGHTINCREASE_100_LBS;
         break;
      default: break;
   }
   ipAdd = ItemPropertyWeightIncrease (nWeight);
   return ipAdd;
}

////////////////////////////////////////////
// * Function that randomly chooses a weight reduction % to be added to an item.
// * Possible return values are: 10%, 20%, 40%, 60%, and 80%.
//
itemproperty FW_Choose_IP_Weight_Reduction ()
{
   itemproperty ipAdd;
   if (FW_ALLOW_WEIGHT_REDUCTION == FALSE)
      return ipAdd;
   int nWeight;
   int iRoll = Random (5);
   switch (iRoll)
   {
      case 0: nWeight = IP_CONST_REDUCEDWEIGHT_10_PERCENT;
         break;
      case 1: nWeight = IP_CONST_REDUCEDWEIGHT_20_PERCENT;
         break;
      case 2: nWeight = IP_CONST_REDUCEDWEIGHT_40_PERCENT;
         break;
      case 3: nWeight = IP_CONST_REDUCEDWEIGHT_60_PERCENT;
         break;
      case 4: nWeight = IP_CONST_REDUCEDWEIGHT_80_PERCENT;
         break;
      default: break;
   }
   ipAdd = ItemPropertyWeightReduction (nWeight);
   return ipAdd;
}


// *****************************************
//
//              IMPLEMENTATION
//
// *****************************************

////////////////////////////////////////////
// * Function that chooses a random metal armor and returns it.
// -nArmorType is a constant of type: FW_ARMOR_*_*2, where * = HEAVY,
//  MEDIUM, or LIGHT and where *2 = one of the metal types of armor 
//  (i.e. Breastplate and FullPlate, but not hide or leather, etc.)
//
object FW_Get_Random_Metal_Armor (int nArmorType)
{
	int nMaterial = FW_WhatMetalArmorMaterial();
	object oItem;
	
	switch (nArmorType)
	{
		case FW_ARMOR_HEAVY_BANDED:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_bandedmail");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_hvbm_ada_3");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_hvbm_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl011");        }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_hvbm_mth_3");     }
			
			break;
		
		case FW_ARMOR_HEAVY_FULLPLATE:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_fullplate");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_hvfp_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_hvfp_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl007");        }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_hvfp_mth_4");     }
					
			break;
			
		case FW_ARMOR_HEAVY_HALFPLATE:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_halfplate");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_hvhp_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_hvhp_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl006");        }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_hvhp_mth_4");     }
					
			break;
			
		case FW_ARMOR_LIGHT_CHAINSHIRT:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_chainshirt");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_ltcs_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_ltcs_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl012");     }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_ltcs_mth_4");     }
				
			break;
			
		case FW_ARMOR_MEDIUM_BREASTPLATE:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_breastplate");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_mdbp_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_mdbp_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl010");     }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_mdbp_mth_4");     }
				
			break;
			
		case FW_ARMOR_MEDIUM_CHAINMAIL:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_chainmail");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_mdcm_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_mdcm_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl004");     }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_mdcm_mth_4");     }
				
			break;
			
		case FW_ARMOR_MEDIUM_SCALEMAIL:
			if      (nMaterial == FW_MATERIAL_NON_SPECIFIC) { oItem = CreateItemOnObject ("fw_itm_armor_generic_scalemail");     }
			else if (nMaterial == FW_MATERIAL_ADAMANTINE)	{ oItem = CreateItemOnObject ("mwa_mdsm_ada_4");     }
			else if (nMaterial == FW_MATERIAL_DARK_STEEL)	{ oItem = CreateItemOnObject ("mwa_mdsm_drk_3");     }
			else if (nMaterial == FW_MATERIAL_IRON) 		{ oItem = CreateItemOnObject ("nw_aarcl003");     }
			else  /* nMaterial == FW_MATERIAL_MITHRAL */    { oItem = CreateItemOnObject ("mwa_mdsm_mth_4");     }
				
			break;
			
		default: break;
	}
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random book and returns it.
//
object FW_Get_Random_Book (struct MyStruct strStruct)
{		
	// Bioware's hard-coded systems do not allow for easy migration to NWN2 due
	// to an excess of hard-coded data values integrated with their logic. 
	// This is valid in NWN2, but not necessarily NWN1.
	int FW_MAX_NUM_ITEMS_BOOKS = 32;
   	int iBookRoll = Random(21) + 1;
			
		if (iBookRoll <= 17)
		{
			int iBook = Random(27) + 1;
			// highest book is 29, but 22 and 26 are skipped
			if (iBook>=22) iBook++;
			if (iBook>=26) iBook++;
			
        	string sRes = "n2_crft_book_recipe0";
        	if (iBook < 10)
        	{
            	sRes += "0";
        	}
        	sRes += IntToString(iBook);        	
			strStruct.oItem = CreateItemOnObject(sRes);
		}
		else if ((iBookRoll >= 18) && (iBookRoll <= 20))
		{
			//int nBook1 = Random(31) + 1;	// totally awesome magic numbers, guys!;
            int nBook1 = Random(FW_MAX_NUM_ITEMS_BOOKS ) + 1;
        	string sRes = "NW_IT_BOOK0";
       		if (nBook1 < 10)
        	{
            	sRes = sRes + "0" + IntToString(nBook1);
        	}
        	else 
        	{
            	sRes = sRes + IntToString(nBook1);
        	}
        	strStruct.oItem = CreateItemOnObject(sRes);
		}
		else  // iBookRoll = 21.
		{
			strStruct.oItem = CreateItemOnObject ("fw_misc_book_cdaulepp_tribute");		
		}
	return strStruct.oItem;
}




////////////////////////////////////////////
// * Function that chooses a random crafting ALCHEMY material and returns it.
//
object FW_Get_Random_Crafting_Alchemy ()
{
	object oItem;
	int iRoll = Random (11) + 1;
	switch (iRoll)
	{
		case 1: oItem = CreateItemOnObject ("nw_it_msmlmisc23");
			break;
		case 2: oItem = CreateItemOnObject ("n2_alc_dmnddust");
			break;
		case 3: oItem = CreateItemOnObject ("n2_alc_disalcohol");
			break;
		case 4: oItem = CreateItemOnObject ("nw_it_msmlmisc19");
			break;
		case 5: oItem = CreateItemOnObject ("nw_it_msmlmisc24");
			break;
		case 6: oItem = CreateItemOnObject ("n2_alc_beegland");
			break;	
		case 7: oItem = CreateItemOnObject ("n2_alc_centgland");
			break;
		case 8: oItem = CreateItemOnObject ("n2_alc_scorpgland");
			break;
		case 9: oItem = CreateItemOnObject ("n2_alc_powsilver");
			break;
		case 10: oItem = CreateItemOnObject ("n2_alc_quicksilver");
			break;
		case 11: oItem = CreateItemOnObject ("n2_alc_venomgland");
			break;			
			
		default: break;
	}
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random crafting BASIC material and returns it.
//
object FW_Get_Random_Crafting_Basic ()
{
	object oItem;
	int iRoll = Random (17) + 1;
	switch (iRoll)
	{
		case 1: oItem = CreateItemOnObject ("mortar");
			break;
		case 2: oItem = CreateItemOnObject ("smithhammer");
			break;
		case 3: oItem = CreateItemOnObject ("n2_crft_ingadamant");
			break;
		case 4: oItem = CreateItemOnObject ("n2_crft_ingsilver");
			break;
		case 5: oItem = CreateItemOnObject ("n2_crft_ingcldiron");
			break;
		case 6: oItem = CreateItemOnObject ("n2_crft_ingdrksteel");
			break;	
		case 7: oItem = CreateItemOnObject ("n2_crft_plkdskwood");
			break;
		case 8: oItem = CreateItemOnObject ("n2_crft_ingiron");
			break;
		case 9: oItem = CreateItemOnObject ("n2_crft_hideleather");
			break;
		case 10: oItem = CreateItemOnObject ("n2_crft_ingmithral");
			break;
		case 11: oItem = CreateItemOnObject ("n2_crft_hidedragon");
			break;
		case 12: oItem = CreateItemOnObject ("n2_crft_hidesalam");
			break;
		case 13: oItem = CreateItemOnObject ("n2_crft_plkshed");
			break;
		case 14: oItem = CreateItemOnObject ("n2_crft_hideumber");
			break;
		case 15: oItem = CreateItemOnObject ("n2_crft_plkwood");
			break;
		case 16: oItem = CreateItemOnObject ("n2_crft_hidewyvern");
			break;	
		case 17: oItem = CreateItemOnObject ("n2_crft_plkzalantar");
			break;	
			
		default: break;
	}
	return oItem;
}



////////////////////////////////////////////
// * Function that chooses a random crafting DISTILLABLE material and returns it.
//
object FW_Get_Random_Crafting_Distillable ()
{
	object oItem;
	int iRoll = Random (39) + 1;
	// item number n2_crft_dist013 seems not to be in the list, so
	// if we roll a 13 we create #14. This makes 14 appear slightly
	// more often than others, but oh well.  Only a 2% chance more of 
	// #14 than anything else.
	if (iRoll == 13)
	   iRoll++;
	string sMaterial = IntToString(iRoll);
	string sResRef = "n2_crft_dist0" + sMaterial;
	oItem = CreateItemOnObject (sResRef);	
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random crafting ESSENCES material and returns it.
//
object FW_Get_Random_Crafting_Essence ()
{
	object oItem;
    int nElement = Random (5) + 1;
	string sElement;
	switch (nElement)
	{
		case 1: sElement = "air";  break;
		case 2: sElement = "earth"; break;
		case 3: sElement = "fire"; break;
		case 4: sElement = "power"; break;
		case 5: sElement = "water"; break;
		
		default: break;
	}
	// There are 4 types of essences.
	int nType = Random (4) + 1;
	string sResRef = "cft_ess_" + sElement + IntToString(nType);
	oItem = CreateItemOnObject (sResRef);
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random crafting MOLD material and returns it.
//
object FW_Get_Random_Crafting_Mold ()
{
	object oItem;
	int iRoll = Random (46) + 1;
	switch (iRoll)
	{
		case 1: oItem = CreateItemOnObject ("n2_crft_mold_hvbm");
			break;
		case 2: oItem = CreateItemOnObject ("n2_crft_mold_swbs");
			break;
		case 3: oItem = CreateItemOnObject ("n2_crft_mold_axbt");
			break;
		case 4: oItem = CreateItemOnObject ("n2_crft_mold_mdbp");
			break;
		case 5: oItem = CreateItemOnObject ("n2_crft_mold_ltcs");
			break;
		case 6: oItem = CreateItemOnObject ("n2_crft_mold_mdcm");
			break;	
		case 7: oItem = CreateItemOnObject ("n2_crft_mold_blcl");
			break;
		case 8: oItem = CreateItemOnObject ("n2_crft_mold_swdg");
			break;
		case 9: oItem = CreateItemOnObject ("n2_crft_mold_axdv");
			break;
		case 10: oItem = CreateItemOnObject ("n2_crft_mold_swfl");
			break;
		case 11: oItem = CreateItemOnObject ("n2_crft_mold_blfl");
			break;
		case 12: oItem = CreateItemOnObject ("n2_crft_mold_hvfp");
			break;
		case 13: oItem = CreateItemOnObject ("n2_crft_mold_axgr");
			break;
		case 14: oItem = CreateItemOnObject ("n2_crft_mold_swgs");
			break;
		case 15: oItem = CreateItemOnObject ("n2_crft_mold_plhb");
			break;
		case 16: oItem = CreateItemOnObject ("n2_crft_mold_hvhp");
			break;	
		case 17: oItem = CreateItemOnObject ("n2_crft_mold_axhn");
			break;
		case 18: oItem = CreateItemOnObject ("n2_crft_mold_bwxh");
			break;	
		case 19: oItem = CreateItemOnObject ("n2_crft_mold_shhv");
			break;
		case 20: oItem = CreateItemOnObject ("n2_crft_mold_mdhd");
			break;
		case 21: oItem = CreateItemOnObject ("n2_crft_mold_spka");
			break;
		case 22: oItem = CreateItemOnObject ("n2_crft_mold_ltlt");
			break;
		case 23: oItem = CreateItemOnObject ("n2_crft_mold_bwxl");
			break;
		case 24: oItem = CreateItemOnObject ("n2_crft_mold_blhl");
			break;
		case 25: oItem = CreateItemOnObject ("n2_crft_mold_shlt");
			break;
		case 26: oItem = CreateItemOnObject ("n2_crft_mold_bwln");
			break;	
		case 27: oItem = CreateItemOnObject ("n2_crft_mold_swls");
			break;
		case 28: oItem = CreateItemOnObject ("n2_crft_mold_blml");
			break;
		case 29: oItem = CreateItemOnObject ("n2_crft_mold_blms");
			break;
		case 30: oItem = CreateItemOnObject ("n2_crft_mold_ltpd");
			break;
		case 31: oItem = CreateItemOnObject ("n2_crft_mold_dbqs");
			break;
		case 32: oItem = CreateItemOnObject ("n2_crft_mold_swrp");
			break;
		case 33: oItem = CreateItemOnObject ("n2_crft_mold_mdsm");
			break;
		case 34: oItem = CreateItemOnObject ("n2_crft_mold_swsc");
			break;
		case 35: oItem = CreateItemOnObject ("n2_crft_mold_plsc");
			break;
		case 36: oItem = CreateItemOnObject ("n2_crft_mold_swss");
			break;	
		case 37: oItem = CreateItemOnObject ("n2_crft_mold_bwsh");
			break;
		case 38: oItem = CreateItemOnObject ("n2_crft_mold_spsc");
			break;
		case 39: oItem = CreateItemOnObject ("n2_crft_mold_plss");
			break;
		case 40: oItem = CreateItemOnObject ("n2_crft_mold_ltsl");
			break;
		case 41: oItem = CreateItemOnObject ("n2_crft_mold_shtw");
			break;
		case 42: oItem = CreateItemOnObject ("n2_crft_mold_trap");
			break;
		case 43: oItem = CreateItemOnObject ("n2_crft_mold_blhw");
			break;
		case 44: oItem = CreateItemOnObject ("n2_crft_mold_bldm");
			break;
		case 45: oItem = CreateItemOnObject ("n2_crft_mold_swka");
			break;
		case 46: oItem = CreateItemOnObject ("n2_crft_mold_spku");
			break;	
			
		default: break;
	}
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random crafting TRADESKILL material and returns it.
//
object FW_Get_Random_Crafting_Tradeskill ()
{
	object oItem;
	int iRoll = Random (17) + 1;
	switch (iRoll)
	{
		case 1: oItem = CreateItemOnObject ("x2_it_cfm_bscrl");
			break;
		case 2: oItem = CreateItemOnObject ("x2_it_cfm_wand"); 
			break;
		case 3: oItem = CreateItemOnObject ("x2_it_poison021"); 
			break;
		case 4: oItem = CreateItemOnObject ("x2_it_poison039");
			break;
		case 5: oItem = CreateItemOnObject ("x2_it_poison015");
			break;
		case 6: oItem = CreateItemOnObject ("x2_it_poison027");
			break;
		case 7: oItem = CreateItemOnObject ("x2_it_poison020"); 
			break;
		case 8: oItem = CreateItemOnObject ("x2_it_poison038"); 
			break;
		case 9: oItem = CreateItemOnObject ("x2_it_poison014");
			break;
		case 10: oItem = CreateItemOnObject ("x2_it_poison026");
			break;
		case 11: oItem = CreateItemOnObject ("x2_it_poison019");
			break;
		case 12: oItem = CreateItemOnObject ("x2_it_poison037"); 
			break;
		case 13: oItem = CreateItemOnObject ("x2_it_poison013"); 
			break;
		case 14: oItem = CreateItemOnObject ("x2_it_poison025");
			break;
		case 15: oItem = CreateItemOnObject ("x2_it_pcpotion");
			break;
		case 16: oItem = CreateItemOnObject ("x2_it_pcwand");
			break;
		case 17: oItem = CreateItemOnObject ("x2_it_cfm_pbottl"); 
			break;		
			
		default: break;
	}
	return oItem;
}

////////////////////////////////////////////
// * Function that chooses a random gem and returns it.
//
object FW_Get_Random_Gem (struct MyStruct strStruct)
{
	int iRoll = Random (24);
	switch (iRoll)
	{   
		case 0: strStruct.oItem = CreateItemOnObject("nw_it_gem013");
		   break;
		case 1: strStruct.oItem = CreateItemOnObject("nw_it_gem003");
		   break;
		case 2: strStruct.oItem = CreateItemOnObject("nw_it_gem014");
		   break;
		case 3: strStruct.oItem = CreateItemOnObject("nw_it_gem005");
		   break;
		case 4: strStruct.oItem = CreateItemOnObject("nw_it_gem012");
		   break;
		case 5: strStruct.oItem = CreateItemOnObject("nw_it_gem002");
		   break;
		case 6: strStruct.oItem = CreateItemOnObject("nw_it_gem009");
		   break;
		case 7: strStruct.oItem = CreateItemOnObject("nw_it_gem015");
		   break;
		case 8: strStruct.oItem = CreateItemOnObject("nw_it_gem011");
		   break;
		case 9: strStruct.oItem = CreateItemOnObject("nw_it_gem001");
		   break;
		case 10: strStruct.oItem = CreateItemOnObject("nw_it_gem007");
		   break;
		case 11: strStruct.oItem = CreateItemOnObject("nw_it_gem004");
		   break;
		case 12: strStruct.oItem = CreateItemOnObject("nw_it_gem006");
		   break;
		case 13: strStruct.oItem = CreateItemOnObject("nw_it_gem008");
		   break;
		case 14: strStruct.oItem = CreateItemOnObject("nw_it_gem010");
		   break;
		case 15: strStruct.oItem = CreateItemOnObject("cft_gem_14");
		   break;
		case 16: strStruct.oItem = CreateItemOnObject("cft_gem_01");
		   break;
		case 17: strStruct.oItem = CreateItemOnObject("cft_gem_12");
		   break;
		case 18: strStruct.oItem = CreateItemOnObject("cft_gem_09");
		   break;
		case 19: strStruct.oItem = CreateItemOnObject("cft_gem_11");
		   break;
		case 20: strStruct.oItem = CreateItemOnObject("cft_gem_15");
		   break;
		case 21: strStruct.oItem = CreateItemOnObject("cft_gem_03");
		   break;
		case 22: strStruct.oItem = CreateItemOnObject("cft_gem_13");
		   break;
		case 23: strStruct.oItem = CreateItemOnObject("cft_gem_10");
		   break;
		default: break;
	} // end of switch	
	return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random crafting material and returns it.
//
object FW_Get_Random_Crafting_Material (struct MyStruct strStruct)
{	
	int iRoll = Random (6) + 1;
	switch (iRoll)
	{
		case 1: strStruct.oItem = FW_Get_Random_Crafting_Alchemy();
			break;
		case 2: strStruct.oItem = FW_Get_Random_Crafting_Basic();
			break;
		case 3: strStruct.oItem = FW_Get_Random_Crafting_Distillable();
			break;
		case 4: strStruct.oItem = FW_Get_Random_Crafting_Essence();
			break;
		case 5: strStruct.oItem = FW_Get_Random_Crafting_Mold();
			break;
		case 6: strStruct.oItem = FW_Get_Random_Crafting_Tradeskill();
			break;
			
		default: break;
	}
	return strStruct.oItem;
}


////////////////////////////////////////////
// * Function that chooses a random amount of gold based off 
// * creature rating.  This scales with CR.
//
object FW_Get_Random_Gold (int min = FW_MIN_MODULE_GOLD, int max = FW_MAX_MODULE_GOLD)
{
	int nCR = FloatToInt( CSLGetChallengeRating(OBJECT_SELF) );	
	if (nCR <= 0)
	{
		nCR = 1;  
	}	 
	
	int nUpperRange = FloatToInt(nCR * FW_MAX_GOLD_MODIFIER);
	int nLowerRange = FloatToInt(nCR * FW_MIN_GOLD_MODIFIER);	
	
	int nReturnValue;	
	int iValue = nUpperRange - nLowerRange + 1;
    nReturnValue = Random(iValue)+ nLowerRange;
	
	if (nReturnValue < min)
	   nReturnValue = min;
	if (nReturnValue > max)
	   nReturnValue = max;
	object oGold = CreateItemOnObject("NW_IT_GOLD001", OBJECT_SELF, nReturnValue);
	return oGold;
}

////////////////////////////////////////////
// * Function that chooses a random heal kit and returns it.
//
object FW_Get_Random_Heal_Kit (struct MyStruct strStruct)
{
	int iRoll = Random (4);
	switch (iRoll)
	{
		case 0: strStruct.oItem = CreateItemOnObject ("nw_it_medkit001");
			break;
		case 1: strStruct.oItem = CreateItemOnObject ("nw_it_medkit002");
			break;
		case 2: strStruct.oItem = CreateItemOnObject ("nw_it_medkit003");
			break;
		case 3: strStruct.oItem = CreateItemOnObject ("nw_it_medkit004");
			break;	
		default: break;
	}
	return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random end-user custom item
// * and returns it.
//
object FW_Get_Random_Misc_Custom_Item (struct MyStruct strStruct)
{
	// Each time you add more items to this function you need to update
	// the value of the integer 'nTotalNumItems'.  By default it is set
	// to 0 until you put in some of your own custom items.  For example,
	// If I have 3 custom items, then 'nTotalNumItems' should be set = 3;
	// If I have 10 custom items, it should be set = 10; And so forth. 
	// Don't forget to update this value or else the random generator
	// won't roll your custom items.
	int nTotalNumItems = 0;
	
	int iRoll = Random (nTotalNumItems) + 1;	
	switch (iRoll)
	{
	
		// Here is an example of exactly how you would add your custom
		// item(s).  Find out what the ResRef of your custom item
		// is by looking at its properties in the toolset.
		
		// In this example, we'll say the custom item I want added to be
		// part of the random loot generator has a ResRef = custom_item_1
		// I've shown below exactly what the line should look like so that
		// your item will become available.
		
		case 1:  // strStruct.oItem = CreateItemOnObject ("custom_item_1");
			break;
			
		// Did you see how I did that?  If you need more examples, 
		// just scroll up to the Get_Random_Heal_Kit function above this
		// one to see another example of how it works. 
		
		case 2:  // strStruct.oItem = CreateItemOnObject ("custom_item_2"); 
			break;
		case 3:  // strStruct.oItem = CreateItemOnObject ("custom_item_3");
			break;
		case 4:  // strStruct.oItem = CreateItemOnObject ("custom_item_4");
			break;
		case 5:  // strStruct.oItem = CreateItemOnObject ("custom_item_5");
			break;
		case 6:  // strStruct.oItem = CreateItemOnObject ("custom_item_6");
			break;
		/*		
		// You should have one case statement for each custom item.
		// Continue with as many case statements as you need.
		
		case 7:  // strStruct.oItem = CreateItemOnObject ("custom_item_7");
			break;
		.
		.
		.
		case nth // strStruct.oItem = CreateItemOnObject ("custom_item_nth");
			break;		
		*/
		
		default: break;
	}
	return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random piece of equippable item that a damage
// * shield will be added to.
// - This function also adds the "Unique Power Self Only: One Use Per Day"
//   item property to the returning item.
//
object FW_Get_Random_Misc_Damage_Shield_Item (struct MyStruct strStruct)
{
	itemproperty ipAdd;
			
	int iRoll = Random (15) + 1;
	switch (iRoll)
	{
		case 1: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_ligh" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 2: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_heav" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 3: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_towe" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 4: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_clothes" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 5: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_bandedmail" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 6: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_halfplate" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 7: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_fullplate" , OBJECT_SELF, 1, "fw_damage_shield");
			break;		
		case 8: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_padded" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 9: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_leather" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 10: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_studded" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 11: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_chainshirt" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 12: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_hide" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 13: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_scalemail" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 14: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_chainmail" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		case 15: strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_breastplate" , OBJECT_SELF, 1, "fw_damage_shield");
			break;
		
		default: break;
	} // end of switch
	
	// Check to see if damage shields are allowed or not. If they aren't allowed
	// we return the created item before adding the unique power activation 
	// item property.  Because we return before adding the activation property
	// the script that actually adds the damage shield would never fire if 
	// FW_ALLOW_DAMAGE_SHIELDS is set to FALSE because the onEventActivate would
	// never be an option for the PC to use.  
	if (FW_ALLOW_DAMAGE_SHIELDS == FALSE)
		return strStruct.oItem;
	// If damage shields are allowed, we need to add the activation property
	// unique power self only 1 time per day so the PC can activate the item
	// and cause the damage shield effect script (tag based) to fire.	
	ipAdd = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
	CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
	
	// Set the description of the item, noting that it is of "GODLIKE RARE" quality
	// and give credit to cdaulepp for all his hard work!!!
	
	// As of 19 July 2007, it appears that SetDescription is broken.  I'm going to
	// send this to the PC as a message when they activate the item. Copying this
	// message over to file "i_fw_damage_shield_ac"
	// Whenever Obsidian fixes SetDescription, this will work!
	string sDescription;
	
	sDescription = "Long long ago, an ancient scholar named 'cdaulepp' sought knowledge where no one " +
		"had previously sought it.  His research lead him to discover a whole new " +
		"realm of defensive magical powers that he eventually learned to control.  " +
		"The Lesser and Greater Gods, unaware of this power's existence, had " +
		"not claimed it for their own portfolios.  Once mastered, cdaulepp used this power " +
		"to ascend to Godhood several millenia ago.  His magic portfolio, mainly of " +		
		"a defensive nature, was used to surround himself in a sphere of defensive " +
		"magical shields that protected him from the other Gods.  Legend has it that " +
		"artifacts dating from the time of cdaulepp's mortal existence and studies " +
		"still survive today.  Those artifacts, the rarest of all treasure, are " +
		"actually some of his experiments that failed.  These rejected items are " +
		"imbued with lesser versions of the defensive shields that cdaulepp uses " +
		"to protect himself.  If you should be so lucky as to be reading this message " +
		"it means you have found one of those rarest of rare artifacts.  Activate this " +
		"item and surround yourself in the power and protection of cdaulepp, the " +
		"ultimate master.";	
	
	DelayCommand(2.0, SetDescription (strStruct.oItem, sDescription));
	return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random item from the misc | other
// * category and returns it.
//
object FW_Get_Random_Misc_Other (struct MyStruct strStruct)
{
	int iRoll = Random (55) + 1;
	switch (iRoll)
	{
		case 1: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc16");
			break;
		case 2: strStruct.oItem = CreateItemOnObject ("x0_it_mmedmisc03");
			break;
		case 3: strStruct.oItem = CreateItemOnObject ("nw_it_contain006");
			break;
		case 4: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc06");
			break;
		case 5: strStruct.oItem = CreateItemOnObject ("x0_it_msmlmisc01");
			break;
		case 6: strStruct.oItem = CreateItemOnObject ("x0_it_msmlmisc02");
			break;
		case 7: strStruct.oItem = CreateItemOnObject ("n2_it_brokenitem");
			break;
		case 8: strStruct.oItem = CreateItemOnObject ("x0_it_mmedmisc01");
			break;
		case 9: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc18");
			break;
		case 10: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc21");
			break;
		case 11: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc04");
			break;
		case 12: strStruct.oItem = CreateItemOnObject ("x1_it_msmlmisc01");
			break;
		case 13: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc17");
			break;
		case 14: strStruct.oItem = CreateItemOnObject ("n2_it_drum");
			break;
		case 15: strStruct.oItem = CreateItemOnObject ("nw_it_mmidmisc02");
			break;
		case 16: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc05");
			break;
		case 17: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc06");
			break;
		case 18: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc13");
			break;
		case 19: strStruct.oItem = CreateItemOnObject ("nw_it_thnmisc001");
			break;
		case 20: strStruct.oItem = CreateItemOnObject ("nw_it_thnmisc002");
			break;		
		case 21: strStruct.oItem = CreateItemOnObject ("nw_it_thnmisc003");
			break;
		case 22: strStruct.oItem = CreateItemOnObject ("nw_it_thnmisc004");
			break;
		case 23: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc08");
			break;
		case 24: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc08");
			break;
		case 25: strStruct.oItem = CreateItemOnObject ("nw_it_flute");
			break;
		case 26: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc15");
			break;
		case 27: strStruct.oItem = CreateItemOnObject ("x0_it_msmlmisc03");
			break;
		case 28: strStruct.oItem = CreateItemOnObject ("x0_it_msmlmisc04");
			break;
		case 29: strStruct.oItem = CreateItemOnObject ("nw_it_gold001");
			break;
		case 30: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc14");
			break;
		case 31: strStruct.oItem = CreateItemOnObject ("nw_it_contain005");
			break;
		case 32: strStruct.oItem = CreateItemOnObject ("x0_it_msmlmisc06");
			break;
		case 33: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc18");
			break;
		case 34: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc10");
			break;
		case 35: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc11");
			break;
		case 36: strStruct.oItem = CreateItemOnObject ("nw_it_contain003");
			break;
		case 37: strStruct.oItem = CreateItemOnObject ("nw_it_lute");
			break;
		case 38: strStruct.oItem = CreateItemOnObject ("x0_it_mthnmisc16");
			break;
		case 39: strStruct.oItem = CreateItemOnObject ("nw_it_contain004");
			break;
		case 40: strStruct.oItem = CreateItemOnObject ("nw_it_contain002");
			break;
		case 41: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc11");
			break;
		case 42: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc21");
			break;
		case 43: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc05");
			break;
		case 44: strStruct.oItem = CreateItemOnObject ("nw_it_mmidmisc04");
			break;
		case 45: strStruct.oItem = CreateItemOnObject ("n2_it_mmidmisc01");
			break;
		case 46: strStruct.oItem = CreateItemOnObject ("nw_it_msmlmisc13");
			break;
		case 47: strStruct.oItem = CreateItemOnObject ("nw_it_mmidmisc06");
			break;
		case 48: strStruct.oItem = CreateItemOnObject ("n2_it_spoon");
			break;
		case 49: strStruct.oItem = CreateItemOnObject ("nw_it_stein");
			break;
		case 50: strStruct.oItem = CreateItemOnObject ("x2_it_msmlmisc05");
			break;
		case 51: strStruct.oItem = CreateItemOnObject ("nw_it_picks001");
			break;
		case 52: strStruct.oItem = CreateItemOnObject ("nw_it_picks002");
			break;
		case 53: strStruct.oItem = CreateItemOnObject ("nw_it_picks003");
			break;
		case 54: strStruct.oItem = CreateItemOnObject ("nw_it_picks004");
			break;
		case 55: strStruct.oItem = CreateItemOnObject ("csl_torch");
			break;
					
		default: break;		
	}
	return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random potion and returns it.
//
object FW_Get_Random_Potion (struct MyStruct strStruct)
{  
   itemproperty ipAdd;
   strStruct.oItem = CreateItemOnObject ("fw_itm_generic_potion");    
   int nReRoll = TRUE;
   int nDeletedMisprints = FALSE;
   while (nReRoll)
   {
      // There are 646 spells in NWN 2. as of 10 July 2007
	  int iSpellId = Random (646);
	  switch (iSpellId)
	  {
	     // this gets rid of all the spells that have potion use set to 1
		 // but shouldn't be. I.E. Ioun Stone, Dye Armor, Grenade Bombs, etc.
	     case 125: case 142: case 143: case 144: case 188: case 197: case 239: 
		 case 305: case 306: case 329: case 335: case 336: case 337: case 338: 
		 case 339: case 340: case 341: case 342: case 343: case 344: case 350:
		 case 351: case 353:
		 case 359: case 400: case 401: case 402: case 403: case 404: case 405: 
		 case 406: case 407: case 408: case 409: case 430: case 431: case 432:
		 case 433: case 434: case 435: case 436: case 437: case 460: case 490:
		 case 491: case 492: case 493: case 494: case 495: case 496: case 497:
		 case 498: case 499: case 500: case 513: case 526: case 527: case 528:
		 case 529: case 537: case 553: 
		 nDeletedMisprints = TRUE; break;		 
		 default: nDeletedMisprints = FALSE; break;	  
	  } // end of switch 	     
	   			
	  string sPotionUse = Get2DAString ("iprp_spells", "PotionUse", iSpellId);
	  int nPotionUse = StringToInt (sPotionUse);
	  string s2DALabel = Get2DAString ("iprp_spells", "Label", iSpellId);		
	  string sCheck = "";
      string s2DAName = Get2DAString ("iprp_spells", "Name", iSpellId);
	  // Reroll if a deleted spell, or if not flagged for a potion.
      if (s2DAName == sCheck)
	  {  nReRoll = TRUE;  }
	  else if (nPotionUse == 0) 
	  {  nReRoll = TRUE;  }
	  else if (nDeletedMisprints)
      {  nReRoll = TRUE;  }
	  else
	  {   
	     nReRoll = FALSE;
		 strStruct.sName = "Potion of: " + s2DALabel;
		 SetFirstName (strStruct.oItem, strStruct.sName);
		 // Now that we have a spell chosen that can be applied to a potion.	 
		 ipAdd = ItemPropertyCastSpell (iSpellId, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
	  }  
   } // end of while   
   CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
   return strStruct.oItem;
} // end of function

////////////////////////////////////////////
// * Function that chooses a random scroll and returns it.
//
object FW_Get_Random_Scroll (struct MyStruct strStruct)
{
   itemproperty ipAdd;
   strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_scroll");    
   int nReRoll = TRUE;
   int nDeletedMisprints = FALSE;
   while (nReRoll)
   {
      // There are 646 spells in NWN 2. as of 10 July 2007
	  int iSpellId = Random (646);
	  switch (iSpellId)
	  {
	  	 case 113: case 114: case 201: case 202: case 203: case 305: case 306:
		 case 314: case 315: case 316: case 317: case 318: case 319: case 320: 
	     case 329: case 330: case 331: case 332: case 335: case 336: case 337:
		 case 338: case 339: case 340: case 341: case 342: case 343: case 344: 
		 case 351: case 353: case 359: case 370: case 372: 
		 case 452: case 453: case 454: case 459: case 460: case 462: case 463:
		 case 465: case 468: case 469: case 470: case 471: case 478: 
		 case 490: case 491: case 492: case 493: case 494: case 495: case 496:
		 case 497: case 498: case 499: case 500: case 513: case 521: case 522:
		 case 523: case 524: case 526: case 527: case 536: case 537: case 538:
		 case 540: case 553: case 607: case 608: case 609: 
	     
		 nDeletedMisprints = TRUE; break;		 
		 default: nDeletedMisprints = FALSE; break;	  
	  } // end of switch 	     
	  	  
	  string s2DALabel = Get2DAString ("iprp_spells", "Label", iSpellId);		
	  string sCheck = "";
      string s2DAName = Get2DAString ("iprp_spells", "Name", iSpellId);
	  // Reroll if a deleted spell, or if not flagged for general use.
      if (s2DAName == sCheck)
	  {  nReRoll = TRUE;  }	  
	  else if (nDeletedMisprints)
      {  nReRoll = TRUE;  }
	  else
	  {   
	     nReRoll = FALSE;
		 strStruct.sName = "Scroll of: " + s2DALabel;
		 SetFirstName (strStruct.oItem, strStruct.sName);
		 // Now that we have a spell chosen that can be applied to a scroll.	 
		 ipAdd = ItemPropertyCastSpell (iSpellId, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
		 
		 // We need to limit the use of the scroll to the appropriate classes
		 string sSpellIndex = Get2DAString ("iprp_spells", "SpellIndex", iSpellId);
		 int nSpellIndex = StringToInt (sSpellIndex);
		 
		 itemproperty ipAddUseLimitation;		 
		 
		 string sBardCheck =  Get2DAString ("spells", "Bard", nSpellIndex);		 
		 if (sBardCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_BARD);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sClericCheck =  Get2DAString ("spells", "Cleric", nSpellIndex);
		 if (sClericCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_CLERIC);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sRangerCheck =  Get2DAString ("spells", "Ranger", nSpellIndex);
		 if (sRangerCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_RANGER);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sPaladinCheck =  Get2DAString ("spells", "Paladin", nSpellIndex);
		 if (sPaladinCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_PALADIN);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sDruidCheck =  Get2DAString ("spells", "Druid", nSpellIndex);
		 if (sDruidCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_DRUID);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sWiz_SorcCheck =  Get2DAString ("spells", "Wiz_Sorc", nSpellIndex);
		 if (sWiz_SorcCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_SORCERER);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
			ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_WIZARD);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }		 
	  } // end of else  
   } // end of while   
   CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
   return strStruct.oItem;
} // end of function

////////////////////////////////////////////
// * Function that chooses a random trap and returns it.
// - min and max are determined by end-user constants. Translates as follows:
//   0 = Minor, 1 = Average, 2 = Strong, 3 = Deadly, 4 = Epic
//
object FW_Get_Random_Trap (struct MyStruct strStruct, int nCR = 0)
{
   int min;
   int max;
   if (FW_ALLOW_FORMULA_BASED_CR_SCALING == TRUE)
   {   		
		max = FloatToInt(nCR * FW_MAX_TRAP_LEVEL_MODIFIER) + 1;
		min = FloatToInt(nCR * FW_MIN_TRAP_LEVEL_MODIFIER) + 1;
   }
   else
   { 
   switch (nCR)
   {
		case 0: min = FW_MIN_TRAP_LEVEL_CR_0 ; max = FW_MAX_TRAP_LEVEL_CR_0 ;    break;
		
		case 1: min = FW_MIN_TRAP_LEVEL_CR_1 ; max = FW_MAX_TRAP_LEVEL_CR_1 ;    break;
		case 2: min = FW_MIN_TRAP_LEVEL_CR_2 ; max = FW_MAX_TRAP_LEVEL_CR_2 ;    break;
		case 3: min = FW_MIN_TRAP_LEVEL_CR_3 ; max = FW_MAX_TRAP_LEVEL_CR_3 ;    break;
   		case 4: min = FW_MIN_TRAP_LEVEL_CR_4 ; max = FW_MAX_TRAP_LEVEL_CR_4 ;    break;
		case 5: min = FW_MIN_TRAP_LEVEL_CR_5 ; max = FW_MAX_TRAP_LEVEL_CR_5 ;    break;
		case 6: min = FW_MIN_TRAP_LEVEL_CR_6 ; max = FW_MAX_TRAP_LEVEL_CR_6 ;    break;
   		case 7: min = FW_MIN_TRAP_LEVEL_CR_7 ; max = FW_MAX_TRAP_LEVEL_CR_7 ;    break;
		case 8: min = FW_MIN_TRAP_LEVEL_CR_8 ; max = FW_MAX_TRAP_LEVEL_CR_8 ;    break;
		case 9: min = FW_MIN_TRAP_LEVEL_CR_9 ; max = FW_MAX_TRAP_LEVEL_CR_9 ;    break;
   		case 10: min = FW_MIN_TRAP_LEVEL_CR_10 ; max = FW_MAX_TRAP_LEVEL_CR_10 ; break;
		
		case 11: min = FW_MIN_TRAP_LEVEL_CR_11 ; max = FW_MAX_TRAP_LEVEL_CR_11 ;  break;
		case 12: min = FW_MIN_TRAP_LEVEL_CR_12 ; max = FW_MAX_TRAP_LEVEL_CR_12 ;  break;
		case 13: min = FW_MIN_TRAP_LEVEL_CR_13 ; max = FW_MAX_TRAP_LEVEL_CR_13 ;  break;
   		case 14: min = FW_MIN_TRAP_LEVEL_CR_14 ; max = FW_MAX_TRAP_LEVEL_CR_14 ;  break;
		case 15: min = FW_MIN_TRAP_LEVEL_CR_15 ; max = FW_MAX_TRAP_LEVEL_CR_15 ;  break;
		case 16: min = FW_MIN_TRAP_LEVEL_CR_16 ; max = FW_MAX_TRAP_LEVEL_CR_16 ;  break;
   		case 17: min = FW_MIN_TRAP_LEVEL_CR_17 ; max = FW_MAX_TRAP_LEVEL_CR_17 ;  break;
		case 18: min = FW_MIN_TRAP_LEVEL_CR_18 ; max = FW_MAX_TRAP_LEVEL_CR_18 ;  break;
		case 19: min = FW_MIN_TRAP_LEVEL_CR_19 ; max = FW_MAX_TRAP_LEVEL_CR_19 ;  break;
   		case 20: min = FW_MIN_TRAP_LEVEL_CR_20 ; max = FW_MAX_TRAP_LEVEL_CR_20 ;  break;
   
   		case 21: min = FW_MIN_TRAP_LEVEL_CR_21 ; max = FW_MAX_TRAP_LEVEL_CR_21 ;  break;
		case 22: min = FW_MIN_TRAP_LEVEL_CR_22 ; max = FW_MAX_TRAP_LEVEL_CR_22 ;  break;
		case 23: min = FW_MIN_TRAP_LEVEL_CR_23 ; max = FW_MAX_TRAP_LEVEL_CR_23 ;  break;
   		case 24: min = FW_MIN_TRAP_LEVEL_CR_24 ; max = FW_MAX_TRAP_LEVEL_CR_24 ;  break;
		case 25: min = FW_MIN_TRAP_LEVEL_CR_25 ; max = FW_MAX_TRAP_LEVEL_CR_25 ;  break;
		case 26: min = FW_MIN_TRAP_LEVEL_CR_26 ; max = FW_MAX_TRAP_LEVEL_CR_26 ;  break;
   		case 27: min = FW_MIN_TRAP_LEVEL_CR_27 ; max = FW_MAX_TRAP_LEVEL_CR_27 ;  break;
		case 28: min = FW_MIN_TRAP_LEVEL_CR_28 ; max = FW_MAX_TRAP_LEVEL_CR_28 ;  break;
		case 29: min = FW_MIN_TRAP_LEVEL_CR_29 ; max = FW_MAX_TRAP_LEVEL_CR_29 ;  break;
   		case 30: min = FW_MIN_TRAP_LEVEL_CR_30 ; max = FW_MAX_TRAP_LEVEL_CR_30 ;  break;		
		
		case 31: min = FW_MIN_TRAP_LEVEL_CR_31 ; max = FW_MAX_TRAP_LEVEL_CR_31 ;  break;
		case 32: min = FW_MIN_TRAP_LEVEL_CR_32 ; max = FW_MAX_TRAP_LEVEL_CR_32 ;  break;
		case 33: min = FW_MIN_TRAP_LEVEL_CR_33 ; max = FW_MAX_TRAP_LEVEL_CR_33 ;  break;
   		case 34: min = FW_MIN_TRAP_LEVEL_CR_34 ; max = FW_MAX_TRAP_LEVEL_CR_34 ;  break;
		case 35: min = FW_MIN_TRAP_LEVEL_CR_35 ; max = FW_MAX_TRAP_LEVEL_CR_35 ;  break;
		case 36: min = FW_MIN_TRAP_LEVEL_CR_36 ; max = FW_MAX_TRAP_LEVEL_CR_36 ;  break;
   		case 37: min = FW_MIN_TRAP_LEVEL_CR_37 ; max = FW_MAX_TRAP_LEVEL_CR_37 ;  break;
		case 38: min = FW_MIN_TRAP_LEVEL_CR_38 ; max = FW_MAX_TRAP_LEVEL_CR_38 ;  break;
		case 39: min = FW_MIN_TRAP_LEVEL_CR_39 ; max = FW_MAX_TRAP_LEVEL_CR_39 ;  break;
   		case 40: min = FW_MIN_TRAP_LEVEL_CR_40 ; max = FW_MAX_TRAP_LEVEL_CR_40 ;  break;
		
		case 41: min = FW_MIN_TRAP_LEVEL_CR_41_OR_HIGHER; max = FW_MAX_TRAP_LEVEL_CR_41_OR_HIGHER;  break;
		
		default: break; 
   } // end of switch
   } // end of else 
   // This stops people who put inappropriate values for min and max.   
   if (min < 0)
      min = 0;
   if (max < 0)
      max = 0;
   if (min > 3)
      min = 3;
   if (max > 3)
      max = 3;
   // check if someone accidentally swapped min and max.
   if (min > max)
      min = 0;      
   
   int iValue = max - min + 1;
   int nMinMaxRoll = Random (iValue) + min;	     
   // Determine trap type. There are 11 types.
   int iRoll = Random (11);        
   // Minor Traps.   
   if (nMinMaxRoll == 0)
   {  
      iRoll = iRoll * 4;	  	       
   }
   // Average Traps.
   else if (nMinMaxRoll == 1)   
   {
      iRoll = (iRoll * 4) + 1;	  	          
   }
   // Strong Traps.
   else if (nMinMaxRoll == 2)   
   {
      iRoll = (iRoll * 4) + 2;      
   }
   // Deadly Traps.
   else 
   {
      iRoll = (iRoll * 4) + 3;	  	           
   }    
   // I don't think epic traps have been implemented yet.  Coming in Mask of the
   // Betrayer. Epic traps are at the end of the traps.2da so you can't 
   // continue with the same formula for them when MotB comes out.
   string s2DAResRef = Get2DAString ("traps", "ResRef", iRoll);
   strStruct.oItem = CreateItemOnObject (s2DAResRef);
   return strStruct.oItem;
}

////////////////////////////////////////////
// * Function that chooses a random wand and returns it.
//
object FW_Get_Random_Wand (struct MyStruct strStruct)
{  
   itemproperty ipAdd;       
   int nReRoll = TRUE;
   int nDeletedMisprints = FALSE;
   while (nReRoll)
   {
      // There are 646 spells in NWN 2. as of 10 July 2007
	  int iSpellId = Random (646);
	  switch (iSpellId)
	  {
	     // this gets rid of all the spells that have wand use set to 1
		 // but shouldn't be. I.E. Ioun Stone, Dye Armor, Grenade Bombs, etc.
		 
		 case 46:
	     case 314: case 315: case 316: case 317: case 318: case 319: case 320:
		 case 329: case 335: case 344: case 351: case 353: case 359: 
		 case 370: case 372: case 431: case 432: case 433: case 434: case 435:
		 case 436: case 437: case 452: case 453: case 454: case 459: case 460:
		 case 462: case 463: case 465: case 478: case 482: case 490: case 491:
		 case 492: case 493: case 494: case 495: case 496: case 497: case 498:
		 case 499: case 500: case 513: case 526: case 527: case 528: case 529:
		 
		 nDeletedMisprints = TRUE; break;
		 		 
		 default: nDeletedMisprints = FALSE; break;	  
	  } // end of switch 	     
	   			
	  string sWandUse = Get2DAString ("iprp_spells", "WandUse", iSpellId);
	  int nWandUse = StringToInt (sWandUse);
	  string s2DALabel = Get2DAString ("iprp_spells", "Label", iSpellId);		
	  string sCheck = "";
      string s2DAName = Get2DAString ("iprp_spells", "Name", iSpellId);
	  // Reroll if a deleted spell, or if not flagged for a potion.
      if (s2DAName == sCheck)
	  {  nReRoll = TRUE;  }
	  else if (nWandUse == 0) 
	  {  nReRoll = TRUE;  }
	  else if (nDeletedMisprints)
      {  nReRoll = TRUE;  }
	  else
	  {   
	     nReRoll = FALSE;
		 // check if wand or rod.
		 if (GetBaseItemType(strStruct.oItem) == BASE_ITEM_MAGICWAND)
		 	{  strStruct.sName = "Wand of: " + s2DALabel;  }
		 else  // it is a magic rod.
		    {  strStruct.sName = "Rod of: " + s2DALabel;   }		 
		 SetFirstName (strStruct.oItem, strStruct.sName);
		 // Now we have to choose a random number of uses.
   		 int iRoll = Random (7);
		 int nNumUses;
   		 switch (iRoll)
   		 {
      		case 0: nNumUses = IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE;
         		break;
     		case 1: nNumUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
         		break;
      		case 2: nNumUses = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
         		break;
      		case 3: nNumUses = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
         		break;
      		case 4: nNumUses = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
         		break;
      		case 5: nNumUses = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;
         		break;
      		case 6: nNumUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
         		break;
   		 }
		 // We need to limit the use of the wand/rod to the appropriate classes
		 string sSpellIndex = Get2DAString ("iprp_spells", "SpellIndex", iSpellId);
		 int nSpellIndex = StringToInt (sSpellIndex);
		 
		 itemproperty ipAddUseLimitation;		 
		 
		 string sBardCheck =  Get2DAString ("spells", "Bard", nSpellIndex);		 
		 if (sBardCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_BARD);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sClericCheck =  Get2DAString ("spells", "Cleric", nSpellIndex);
		 if (sClericCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_CLERIC);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sRangerCheck =  Get2DAString ("spells", "Ranger", nSpellIndex);
		 if (sRangerCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_RANGER);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sPaladinCheck =  Get2DAString ("spells", "Paladin", nSpellIndex);
		 if (sPaladinCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_PALADIN);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sDruidCheck =  Get2DAString ("spells", "Druid", nSpellIndex);
		 if (sDruidCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_DRUID);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }
		 
		 string sWiz_SorcCheck =  Get2DAString ("spells", "Wiz_Sorc", nSpellIndex);
		 if (sWiz_SorcCheck == sCheck)  {  }
		 else
		 {
		 	ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_SORCERER);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
			ipAddUseLimitation = ItemPropertyLimitUseByClass (IP_CONST_CLASS_WIZARD);
			CSLSafeAddItemProperty (strStruct.oItem, ipAddUseLimitation);
		 }		 
		 // Now that we have a spell chosen that can be applied to a wand/rod.	 
		 ipAdd = ItemPropertyCastSpell (iSpellId, nNumUses);
	  }  
   } // end of while   
   CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
   return strStruct.oItem;
} // end of function

////////////////////////////////////////////
// * Function that iterates through all the types of exotic weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Exotic()
{
	object oItem;
    int nMaterial = FW_WhatMetalWeaponMaterial();
    int iRoll = Random(4);
    switch (iRoll)
    {
		// Kama
		case 0: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wspka001");
	  	   else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_spka_ada_3");
		   else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_spka_slv_3");
		   else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_spka_cld_3");
		   else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_spka_drk_3");
		   else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_spka_mth_3");
         break;
		// Bastard Sword
		case 1: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswbs001");
	  	   else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swbs_ada_3");
		   else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swbs_slv_3");
		   else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swbs_cld_3");
		   else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swbs_drk_3");
		   else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swbs_mth_3");
         break;
		// Dwarven Waraxe
		case 2: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("x2_wdwraxe001");
	  	   else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_axdv_ada_3");
		   else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_axdv_slv_3");
		   else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_axdv_cld_3");
		   else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_axdv_drk_3");
		   else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_axdv_mth_3");
         break;
		// Katana
		case 3: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswka001");
	  	   else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swka_ada_3");
		   else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swka_slv_3");
		   else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swka_cld_3");
		   else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swka_drk_3");
		   else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swka_mth_3");
         break; 
		
		default: break;	
	} // end of switch
	return oItem;
} // end of function

////////////////////////////////////////////
// * Function that iterates through all the types of ranged weapons and chooses
// * one randomly. 
//
object FW_Get_Random_Weapon_Ranged()
{
	object oItem;
    int nMaterial2 = FW_WhatWoodWeaponMaterial();
    int iRoll = Random(5);
    switch (iRoll)
    {
		// Heavy Crossbow
		case 0:  if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)  oItem = CreateItemOnObject ("nw_wbwxh");
         	else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)      oItem = CreateItemOnObject ("mwr_bwxh_dsk_4");
			else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/    oItem = CreateItemOnObject ("mwr_bwxh_zal_3");		 
			break;
		// Light Crossbow
		case 1:  if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)  oItem = CreateItemOnObject ("nw_wbwxl001");
         	else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)      oItem = CreateItemOnObject ("mwr_bwxl_dsk_4");
			else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/    oItem = CreateItemOnObject ("mwr_bwxl_zal_3");		 
			break;
		// Shortbow
		case 2:  if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)  oItem = CreateItemOnObject ("nw_wbwsh001");
         	else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)      oItem = CreateItemOnObject ("mwr_bwsh_dsk_4");
			else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/    oItem = CreateItemOnObject ("mwr_bwsh_zal_3");		 
			break;
		// Longbow
		case 3:  if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)  oItem = CreateItemOnObject ("nw_wbwln001");
         	else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)      oItem = CreateItemOnObject ("mwr_bwln_dsk_4");
			else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/    oItem = CreateItemOnObject ("mwr_bwln_zal_3");		 
			break;
		// Sling
		case 4:	 oItem = CreateItemOnObject ("nw_wbwsl001");
			break;
			
		default: break;	
	}
	return oItem;
}

////////////////////////////////////////////
// * Function that iterates through all the types of simple weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Simple()
{
   object oItem;
   int nMaterial = FW_WhatMetalWeaponMaterial();
   int nMaterial2 = FW_WhatWoodWeaponMaterial(); 
   int iRoll = Random(7);
   switch (iRoll)
   {
      // Dagger
      case 0: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswdg001");
	  	 else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swdg_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swdg_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swdg_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swdg_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swdg_mth_3");
         break;
      // Mace
      case 1: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wblml001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_blml_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_blml_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_blml_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_blml_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_blml_mth_3");
         break;
      // Sickle
      case 2: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wspsc001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_spsc_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_spsc_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_spsc_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_spsc_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_spsc_mth_3");
         break;
      // Club
      case 3: if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wblc001");
         else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)           oItem = CreateItemOnObject ("mst_blcl_dsk_3");
		 else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/         oItem = CreateItemOnObject ("mst_blcl_zal_3");
		 break;
      // Morningstar
      case 4: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wblms001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_blms_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_blms_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_blms_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_blms_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_blms_mth_3");
         break;
      // Quarterstaff
      case 5: if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wdbqs001");
         else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)           oItem = CreateItemOnObject ("mst_dbqs_dsk_3");
		 else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/         oItem = CreateItemOnObject ("mst_dbqs_zal_3");
		 break;
      // Spear
      case 6: if (nMaterial2 == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wplss001");
         else if (nMaterial2 == FW_MATERIAL_DUSKWOOD)           oItem = CreateItemOnObject ("mst_plss_dsk_3");
		 else /* (nMaterial2 == FW_MATERIAL_ZALANTAR)*/         oItem = CreateItemOnObject ("mst_plss_zal_3");
		 break;

      default: break;
   }  // end of simple switch
   return oItem;
} // end of function

////////////////////////////////////////////
// * Function that iterates through all the types of martial weapons and chooses
// * one randomly. Does not choose thrown or ranged weapons though.
//
object FW_Get_Random_Weapon_Martial()
{
   object oItem;
   int nMaterial = FW_WhatMetalWeaponMaterial();
   int iRoll = Random(16);
   switch (iRoll)
   {
      // Light Hammer
      case 0: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wblhl001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_blhl_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_blhl_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_blhl_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_blhl_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_blhl_mth_3");
         break;
      // Handaxe
      case 1: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_waxhn001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_axhn_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_axhn_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_axhn_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_axhn_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_axhn_mth_3");
         break;
      // Kukri
      case 2: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wspku001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_spku_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_spku_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_spku_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_spku_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_spku_mth_3");
         break;
      // ShortSword
      case 3: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswss001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swss_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swss_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swss_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swss_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swss_mth_3");
         break;
      // BattleAxe
      case 4: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_waxbt001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_axbt_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_axbt_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_axbt_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_axbt_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_axbt_mth_3");
         break;
      // Longsword
      case 5: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswls001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swls_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swls_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swls_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swls_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swls_mth_3");
         break;
      // Rapier
      case 6: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswrp001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swrp_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swrp_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swrp_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swrp_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swrp_mth_3");
         break;
      // Scimitar
      case 7: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswsc001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swsc_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swsc_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swsc_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swsc_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swsc_mth_3");
         break;
      // Warhammer
      case 8: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wblhw001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_blhw_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_blhw_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_blhw_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_blhw_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_blhw_mth_3");
         break;
      // Falchion
      case 9: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)        oItem = CreateItemOnObject ("nw_wswfl001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swfl_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swfl_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swfl_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swfl_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swfl_mth_3");
         break;
      // GreatAxe
      case 10: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_waxgr001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_axgr_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_axgr_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_axgr_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_axgr_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_axgr_mth_3");
         break;
      // Greatsword
      case 11: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wswgs001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_swgs_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_swgs_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_swgs_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_swgs_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_swgs_mth_3");
         break;
      // Halberd
      case 12: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wplhb001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_plhb_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_plhb_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_plhb_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_plhb_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_plhb_mth_3");
         break;
      // Scythe
      case 13: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wplsc001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_plsc_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_plsc_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_plsc_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_plsc_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_plsc_mth_3");
         break;
      // warmace
      case 14: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wdbma001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_bldm_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_bldm_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_bldm_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_bldm_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_bldm_mth_3");
         break;
      // light flail
      case 15: if (nMaterial == FW_MATERIAL_NON_SPECIFIC)       oItem = CreateItemOnObject ("nw_wblfl001");
         else if (nMaterial == FW_MATERIAL_ADAMANTINE)          oItem = CreateItemOnObject ("mst_blfl_ada_3");
		 else if (nMaterial == FW_MATERIAL_ALCHEMICAL_SILVER)   oItem = CreateItemOnObject ("mst_blfl_slv_3");
		 else if (nMaterial == FW_MATERIAL_COLD_IRON)           oItem = CreateItemOnObject ("mst_blfl_cld_3");
		 else if (nMaterial == FW_MATERIAL_DARK_STEEL)          oItem = CreateItemOnObject ("mst_blfl_drk_3");
		 else /* (nMaterial == FW_MATERIAL_MITHRAL) */          oItem = CreateItemOnObject ("mst_blfl_mth_3");
         break;

      default: break;
   }  // end of simple switch
   return oItem;
} // end of function