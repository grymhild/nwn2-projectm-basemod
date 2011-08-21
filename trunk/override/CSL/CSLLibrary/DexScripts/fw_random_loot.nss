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
/*
This is my random loot generation system. Anyone can change the switches
and probability tables in the following files: 
"fw_inc_loot_switches"  
"fw_inc_probability_tables_misc"
"fw_inc_probability_tables_races"
"fw_inc_cr_scaling_formulas" 
"fw_inc_cr_scaling_constants"
"fw_inc_misc"

ONLY an EXPERIENCED scripter should change anything else. 
If you mess with the other things and break it, you've been warned.
*/

// *****************************************
//
//              UPDATES
//
// *****************************************
// VERSION 1.2
//
// -28 August 2007. I had made the classical assignment vs. boolean check
//     error on a couple of the items inside the function FW_Create_Loot_On_Object.
//     I fixed these.
//
// - 5 Sept. 2007.  I added some Item Level Restriction code to the function
//     FW_CreateLootOnObject.  I also added Item Level Restriction code
//     to the main function at the very bottom of this file.  Item Level
//     Restrictions can be enabled/disabled in the file "fw_inc_loot_switches"
//     
// - 9 Sept. 2007.  I changed the function: FW_WhatItemPropertyToAdd.
//     I had not included (until now) a probability table that lets you set
//     probabilities for individual item properties.  This meant that
//     some properties were appearing on items more frequently that I 
//     liked.  For example, the Limit Use by Alignment, Race, SAlign,
//     or Class item properties represented 4 entries in every single
//     category of loot.  While something like Item Property Light only
//     had one entry.  This meant you were 4 times more likely to get
//     some type of limit use on your item than a light bonus.  I decided
//     to combine similar properties and this is what you see in the edit
//     to the function FW_WhatItemPropertyToAdd.  I also didn't like the
//     frequency with which negative item properties were showing up, so
//     I combined them into single entries in this function.  This makes
//     them still possible, but lowers the likelihood of getting a negative
//     item property.  
//
// VERSION 1.1
//
// -27 July 2007. I updated the function FW_WhatItemPropertyToAdd to take
//     into consideration monster CR.  This allows for CR scaling now for
//     almost all of the item properties.
//
// -29 July 2007. I updated the function FW_CreateLootOnObject to make calls
//     to handle different types of metals and wood.  For example, the exotic
//     weapons now make a call to FW_Get_Random_Weapon_Exotic and this function
//     chooses a random exotic weapon and also chooses an appropriate metal
//     type based on the probability tables.  The same thing was done with 
//     simple, ranged, and martial weapons as well as metal armors.
//
// -31 July 2007. I added race specific loot drop checks.  I updated the 
//     function "FW_CreateLootOnObject" to do a race loot switch check.
//
// -20 Aug. 2007. I had an assignment error in the function FW_CreateLootOnObject.
//     I fixed it.
//
// *****************************************
//
//              INCLUDED FILES
//
// *****************************************
// I need the item property functions.
#include "_CSLCore_Items"
#include "_CSLCore_Player"

#include "_SCInclude_Loot"
// I need the FW_Get_Random_* functions.
/*
#include "fw_inc_get_random"
// I need the FW_Choose_IP_* functions. 
#include "fw_inc_choose_ip"
// I need the racial loot implementations.
#include "fw_inc_choose_loot_category"

// I need all the constants and switches.
#include "fw_inc_loot_switches"

// I need the probability tables.
#include "fw_inc_probability_tables_misc"
// I need the racial loot probability tables.
#include "fw_inc_probability_tables_races"

// I need the formula based CR scaling.
#include "fw_inc_cr_scaling_formulas"
// I need the constant based CR scaling
#include "fw_inc_cr_scaling_constants"

// I need the MyStruct data types and global variables
#include "fw_inc_misc"
// I need the Item Value Restriction constants and functions
#include "fw_inc_item_value_restrictions"
*/

// *****************************************
//              FUNCTION DECLARATIONS
//
//				DON't CHANGE
// *****************************************

//////////////////////////////////////////
// * This function returns the generic loot struct we're going to add
// * item property(s) to.  By default any type of loot can drop.  This 
// * function (as of version 1.1) now checks for race specific loot drops
// * when the switch for race specific loot drops is set.
//
struct MyStruct FW_CreateLootOnObject (struct MyStruct strStruct, int nCR = 0, int nNumReRolls = 100);

//////////////////////////////////////////
// * Function that determines what itemproperty to add to the dropping loot.
// * By default any type of item property can be chosen.  You can now set
// * upper and lower limits for each CR by editing the constants in the 
// * file "fw_inc_loot_cr_scaling"
//
itemproperty FW_WhatItemPropertyToAdd (struct MyStruct strStruct, int nCR = 0);


// *****************************************
//              IMPLEMENTATION
// *****************************************


//////////////////////////////////////////
// * This function returns the generic loot struct we're going to add
// * item property(s) to.  By default any type of loot can drop.  This 
// * function (as of version 1.1) now checks for race specific loot drops
// * when the switch for race specific loot drops is set.
//
struct MyStruct FW_CreateLootOnObject(struct MyStruct strStruct, int nCR = 0, int nNumReRolls = 100)
{
    int iRoll;
    int nMaterial;
    // Check to see if we're doing race specific loot drops.
    if (FW_RACE_SPECIFIC_LOOT_DROPS == FALSE)
    {
		strStruct.nLootType = FW_Get_Racial_Loot_Category ();	
    } 
	// Otherwise, we don't care what race the monster is, just drop
	// anything! That's what the else does.
	else
	{
		strStruct.nLootType = FW_Get_Default_Loot_Category ();	
	}
    
      switch (strStruct.nLootType)
      {
            /*
	  		case FW_ARMOR_BOOT:    { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_boot");      }
               break;
            case FW_ARMOR_CLOTHING:{ strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_clothes");   }
               break;
            case FW_ARMOR_HEAVY:
               iRoll = Random (3);
               // 0 = Banded, 1 = HalfPlate, 2 = FullPlate
               if      (iRoll == 0) { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_HEAVY_BANDED);     }									
               else if (iRoll == 1) { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_HEAVY_HALFPLATE); }
               else { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_HEAVY_FULLPLATE); }
               break;
            case FW_ARMOR_HELMET:  { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_helmet");   }
               break;
            case FW_ARMOR_LIGHT:
               iRoll = Random (4);
               // 0 = Padded, 1 = Leather, 2 = Studded Leather, 3 = Chain Shirt
               if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_padded");    }
               else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_leather");   }
               else if (iRoll == 2) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_studded");   }
               else { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_LIGHT_CHAINSHIRT); }
               break;
            case FW_ARMOR_MEDIUM:
               iRoll = Random (4);
               // 0 = Hide, 1 = ScaleMail, 2 = ChainMail, 3 = Breastplate
               if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_generic_hide");       }
               else if (iRoll == 1) { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_MEDIUM_SCALEMAIL);  }
               else if (iRoll == 2) { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_MEDIUM_CHAINMAIL);  }
               else { strStruct.oItem = FW_Get_Random_Metal_Armor (FW_ARMOR_MEDIUM_BREASTPLATE);}
               break;
            case FW_ARMOR_SHIELDS:
               iRoll = Random (3);
               // 0 = Light, 1 = Heavy, 2 = Tower
               if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_ligh"); }
               else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_heav"); }
               else                 { strStruct.oItem = CreateItemOnObject ("fw_itm_armor_shield_generic_towe"); }
               break;
			   */
            case FW_WEAPON_AMMUNITION:
                iRoll = Random (3);
                // 0 = Arrow, 1 = Bolt, 2 = Bullet
                if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("nw_wamar001", OBJECT_SELF, 99); }
                else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("nw_wambo001", OBJECT_SELF, 99); }
                else { strStruct.oItem = CreateItemOnObject ("nw_wambu001", OBJECT_SELF, 99); }
                break;
            /*
			case FW_WEAPON_SIMPLE:  { strStruct.oItem = FW_Get_Random_Weapon_Simple ();  }
                break;
            case FW_WEAPON_MARTIAL: { strStruct.oItem = FW_Get_Random_Weapon_Martial (); }
                break;
            case FW_WEAPON_EXOTIC:  { strStruct.oItem = FW_Get_Random_Weapon_Exotic ();  }
                break;
			case FW_WEAPON_MAGE_SPECIFIC:
                iRoll = Random (3);
                // 0 = Rod, 1 = Staff, 2 = Wand
                if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("fw_itm_weap_generic_rod");
									    FW_Get_Random_Wand (strStruct);								}
                else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("fw_itm_weap_generic_staff");  }
                else { strStruct.oItem = CreateItemOnObject ("fw_itm_weap_generic_wand");
									    FW_Get_Random_Wand (strStruct);								}
                break;
			
            case FW_WEAPON_RANGED:  { strStruct.oItem = FW_Get_Random_Weapon_Ranged ();  }
                break;
            case FW_WEAPON_THROWN:
                iRoll = Random (3);
                // 0 = Throwing Axe, 1 = Dart, 2 = Shuriken
                if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("nw_wthax001", OBJECT_SELF, 50); }
                else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("nw_wthdt001", OBJECT_SELF, 50); }
                else { strStruct.oItem = CreateItemOnObject ("nw_wthsh001", OBJECT_SELF, 50); }
			    break;
            case FW_MISC_CLOTHING:
               iRoll = Random (4);
               // 0 = Belt, 1 = Boot, 2 = Bracer, 3 = Cloak
               if      (iRoll == 0) { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_belt");   }
               else if (iRoll == 1) { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_boot");   }
               else if (iRoll == 2) { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_bracer"); }
               else { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_cloak");  }
               break;
            
			 case FW_MISC_JEWELRY:
               iRoll = Random (2);
               // 0 = Amulet, 1 = Ring
               if      (iRoll == 0)  { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_amulet");   }
               else { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_ring");     }
               break;
            
			case FW_MISC_GAUNTLET: { strStruct.oItem = CreateItemOnObject ("fw_itm_misc_generic_gauntlet"); }
               break;
			*/
			case FW_MISC_POTION:   { strStruct.oItem = FW_Get_Random_Potion (strStruct); }
               break;       
		    //case FW_MISC_TRAPS:    { strStruct.oItem = FW_Get_Random_Trap (strStruct, nCR);   }
			//   break;  
			//case FW_MISC_BOOKS:    { strStruct.oItem = FW_Get_Random_Book (strStruct);   }
            //   break; 
			case FW_MISC_GOLD:     { strStruct.oItem = FW_Get_Random_Gold ();            }
               break;               
            case FW_MISC_GEMS:     { strStruct.oItem = FW_Get_Random_Gem (strStruct);    }
               break;
            case FW_MISC_HEAL_KIT: { strStruct.oItem = FW_Get_Random_Heal_Kit (strStruct); }
                break;
			case FW_MISC_SCROLL:   { strStruct.oItem = FW_Get_Random_Scroll (strStruct);  }
                break; 
			//case FW_MISC_CRAFTING_MATERIAL: { strStruct.oItem = FW_Get_Random_Crafting_Material (strStruct);   }
            //    break;
            //case FW_MISC_OTHER:    { strStruct.oItem = FW_Get_Random_Misc_Other (strStruct);   }
            //    break; 
			
			/*
			case FW_MISC_DAMAGE_SHIELD: { strStruct.oItem = FW_Get_Random_Misc_Damage_Shield_Item (strStruct);      }
				break;                      
		    case FW_MISC_CUSTOM_ITEM:  { strStruct.oItem = FW_Get_Random_Misc_Custom_Item (strStruct);  		}
				break;
			*/	
			// It's always safe to add gold, so that's default
            default:               { strStruct.oItem = FW_Get_Random_Gold ();            }                              
			    break;
        } // end of switch        		
   
	// Now that we have an item chosen, if overall gold piece restrictions
	// are turned on, then this section makes sure the item isn't too valuable
	// for the CR of the monster.
	if ((FW_ALLOW_OVERALL_GP_RESTRICTIONS) && (FW_IsItemRolledTooExpensive(strStruct.oItem, nCR)))
	{
		if (nNumReRolls > 0)
		{
			// Destroy the item that is too valuable.
			DestroyObject (strStruct.oItem);
			nNumReRolls--;			
			// Pick a new item
			strStruct = FW_CreateLootOnObject (strStruct, nCR, nNumReRolls);
		}
		// When we've rerolled 10 times but we still haven't found acceptable
		// treasure yet, we default to gold.  I also have to let the random
		// loot generator know I switched loot type categories.
		else // nNumReRolls <= 0
		{
			strStruct.nLootType = FW_MISC_GOLD;
			strStruct.oItem = FW_Get_Random_Gold ();	
		}			
	} // end of if
		
	return strStruct;
} // end of function


//////////////////////////////////////////
// * Function that determines what itemproperty to add to the dropping loot.
// * By default any type of item property can be chosen.  You can now set
// * upper and lower limits for each CR by editing the constants in the 
// * file "fw_inc_loot_cr_scaling"
//
itemproperty FW_WhatItemPropertyToAdd (struct MyStruct strStruct, int nCR = 0)
{
   itemproperty ipAdd; 
   int iRoll;  
      
   if (strStruct.nLootType == FW_ARMOR_CLOTHING ||
       strStruct.nLootType == FW_ARMOR_HEAVY    ||
	   strStruct.nLootType == FW_ARMOR_LIGHT    ||
	   strStruct.nLootType == FW_ARMOR_MEDIUM   ||
	   strStruct.nLootType == FW_ARMOR_SHIELDS  ||
	   strStruct.nLootType == FW_MISC_DAMAGE_SHIELD )
   {
      iRoll = Random (32);
      switch (iRoll)
      {
      case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
         break;
      case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Arcane_Spell_Failure ();
         break;
      case 7: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      //case 8: ipAdd = FW_Choose_IP_Bonus_Feat ();
      //   break;
      //case 9: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
      //   break;
      case 10: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
         break;
      case 11: ipAdd = FW_Choose_IP_Cast_Spell ();
         break;
      /* Damage Reduction doesn't work in NWN 2 yet. If you uncomment this case
         then you'll need to go to the bottom and change LimitUseBySAlign.
      case 12: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      //case 12: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
      //   break;
      case 13: 
	     iRoll = Random(6) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	     }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR); }
		 else /* (iRoll == 6)*/ { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 break;
      case 14: ipAdd = ItemPropertyDarkvision ();
         break;      
      // Freedom of Movement
      //case 15: ipAdd = ItemPropertyFreeAction();
      //   break;
      //case 16: ipAdd = ItemPropertyHaste();
      //   break;
      //case 17: ipAdd = FW_Choose_IP_Immunity_Misc ();
      //   break;
      //case 18: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
      //   break;
      //case 19: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
      //   break;
      //case 20: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
      //   break;
      case 21: ipAdd = FW_Choose_IP_Damage_Immunity ();
         break;
      case 22: ipAdd = ItemPropertyImprovedEvasion();
         break;
      case 23: ipAdd = FW_Choose_IP_Light();
         break;
      //case 24: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
      //   break;
      //case 25: ipAdd = FW_Choose_IP_Regeneration (nCR);
      //   break;
      //case 26: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
      //   break;
      //case 27: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
      //   break;
      case 28: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      case 29: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
         break;
      //case 30: ipAdd = ItemPropertyTrueSeeing();
      //   break;
      case 31: 
	  	 iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
      
      default: break;
      }// end of switch
      return ipAdd;
   } // end of if

   else if (strStruct.nLootType == FW_ARMOR_HELMET ||
            strStruct.nLootType == FW_ARMOR_BOOT   || 
			strStruct.nLootType == FW_MISC_JEWELRY ||
			strStruct.nLootType == FW_MISC_CLOTHING )
   {      
      iRoll = Random (30);
      switch (iRoll)
      {
      //case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
      //   break;
      case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      //case 7: ipAdd = FW_Choose_IP_Bonus_Feat ();
      //   break;
      //case 8: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
      //   break;
      //case 9: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
      //   break;
      //case 10: ipAdd = FW_Choose_IP_Cast_Spell ();
      //   break;
      /* Damage Reduction doesn't work in NWN 2 yet.
      case 11: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      //case 11: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
       //  break;
      case 12: 
	     iRoll = Random(6) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	     }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR); }
		 else /* (iRoll == 6)*/ { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 break;
      case 13: ipAdd = ItemPropertyDarkvision ();
         break;
      // Freedom of Movement
      //case 14: ipAdd = ItemPropertyFreeAction();
      //   break;
     /// case 15: ipAdd = ItemPropertyHaste();
      //   break;
      //case 16: ipAdd = FW_Choose_IP_Immunity_Misc ();
      //   break;
      //case 17: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
      //   break;
      //case 18: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
      //   break;
     // case 19: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
       //  break;
      //case 20: ipAdd = FW_Choose_IP_Damage_Immunity ();
       //  break;
      //case 21: ipAdd = ItemPropertyImprovedEvasion();
       //  break;
      case 22: ipAdd = FW_Choose_IP_Light();
         break;
      //case 23: ipAdd = FW_Choose_IP_Regeneration (nCR);
       //  break;
      //case 24: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
      //   break;
      //case 25: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
      //   break;
     // case 26: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
     //    break;
      //case 27: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
      //   break;
      //case 28: ipAdd = ItemPropertyTrueSeeing();
       //  break;
      case 29: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
      default: break;
      }// end of switch
      return ipAdd;
   } // end of if

   else if (strStruct.nLootType == FW_WEAPON_MARTIAL ||
            strStruct.nLootType == FW_WEAPON_SIMPLE  ||
			strStruct.nLootType == FW_WEAPON_EXOTIC )
   {
      iRoll =  Random (49);
      switch (iRoll)
      {
      //case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
      //   break;
      //case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
       //  break;
      //case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
      //   break;
      //case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
       //  break;
      //case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
       //  break;
      //case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
      //   break;
      case 6: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 7: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Align (nCR);
         break;
      case 8: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Race (nCR);
         break;
      case 9: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_SAlign (nCR);
         break;
      case 10:
	     iRoll = Random(10) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	    	 }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);   }
		 else if (iRoll == 6)   { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 else if (iRoll == 7)   { ipAdd = FW_Choose_IP_Enhancement_Penalty (nCR);		 }
		 else if (iRoll == 8)   { ipAdd = FW_Choose_IP_Damage_Penalty (nCR);			 }
		 else if (iRoll == 9)   { ipAdd = ItemPropertyNoDamage ();						 }
		 else /* (iRoll == 10)*/ { ipAdd = FW_Choose_IP_Attack_Penalty (nCR);			 }
		 break;          
      case 11: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      //case 12: ipAdd = FW_Choose_IP_Bonus_Feat ();
      //   break;
      //case 13: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
      //   break;
      //case 14: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
       //  break;
      //case 15: ipAdd = FW_Choose_IP_Cast_Spell ();
      //   break;
      case 16: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 17: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 18: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 19: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;
      /* Damage Reduction doesn't work in NWN 2 yet.
      case 25: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      //case 20: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
      //   break;      
      case 21: ipAdd = ItemPropertyDarkvision ();
         break;
      case 22: ipAdd = FW_Choose_IP_Enhancement_Bonus (nCR);
         break;
      case 23: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Align (nCR);
         break;
      case 24: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Race (nCR);
         break;
      case 25: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (nCR);
         break;
      case 26: ipAdd = FW_Choose_IP_Extra_Melee_Damage_Type ();
         break;
      // Freedom of Movement
      //case 27: ipAdd = ItemPropertyFreeAction();
      //   break;
     // case 28: ipAdd = ItemPropertyHaste();
      //   break;
      case 29: ipAdd = ItemPropertyHolyAvenger();
         break;
     // case 30: ipAdd = FW_Choose_IP_Immunity_Misc ();
      //   break;
      //case 31: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
       //  break;
     // case 32: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
     //    break;
      //case 33: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
       //  break;
      //case 34: ipAdd = FW_Choose_IP_Damage_Immunity ();
      //   break;
      //case 35: ipAdd = ItemPropertyImprovedEvasion();
      //   break;
      case 36: ipAdd = ItemPropertyKeen();
         break;
      case 37: ipAdd = FW_Choose_IP_Light();
         break;
      case 38: ipAdd = FW_Choose_IP_Massive_Critical (nCR);
         break;      
      //case 39: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
      //   break;
      case 40: ipAdd = FW_Choose_IP_On_Hit_Props ();
         break;
      //case 41: ipAdd = FW_Choose_IP_Regeneration (nCR);
      //   break;
      case 42: ipAdd = FW_Choose_IP_Vampiric_Regeneration (nCR);
         break;
      //case 43: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
      //   break;
      //case 44: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
      //   break;
      //case 45: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
      //   break;
      //case 46: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
      //   break;
     // case 47: ipAdd = ItemPropertyTrueSeeing();
      //   break;
      case 48: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
      default: break;
      } // end of switch
      return ipAdd;
   } // end of if

   else if (strStruct.nLootType == FW_WEAPON_AMMUNITION)
   {
      iRoll = Random (11);
      switch (iRoll)
      {
      case 0: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      case 1: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;
      case 5: 
	     iRoll = Random(2) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);      }
		 else /* (iRoll == 2)*/ { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);  }
	     break;      
      case 6: ipAdd = FW_Choose_IP_Extra_Range_Damage_Type ();
         break;
      //case 7: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
      //   break;
      case 8: ipAdd = FW_Choose_IP_On_Hit_Props ();
         break;
      case 9: ipAdd = FW_Choose_IP_Vampiric_Regeneration (nCR);
         break;
      case 10: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
      } // end of switch
      return ipAdd;
   } // end of if

   else if (strStruct.nLootType == FW_WEAPON_RANGED)
   {
      iRoll = Random (38);
      switch (iRoll)
      {
      //case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
      //   break;
      //case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
      //   break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type(nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 7: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Align (nCR);
         break;
      case 8: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Race (nCR);
         break;
      case 9: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_SAlign (nCR);
         break;
      case 10: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      //case 11: ipAdd = FW_Choose_IP_Bonus_Feat ();
      //   break;
      case 12: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
         break;
      //case 13: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
      //   break;
      //case 14: ipAdd = FW_Choose_IP_Cast_Spell ();
      //   break;
      /* damage reduction doesn't work in NWN 2 yet.
      case 15: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      case 15: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
         break;
      case 16: 
	     iRoll = Random(8) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	    	 }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);   }
		 else if (iRoll == 6)   { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 else if (iRoll == 7)   { ipAdd = ItemPropertyNoDamage ();						 }
		 else /* (iRoll == 8)*/ { ipAdd = FW_Choose_IP_Attack_Penalty (nCR);			 }
		 break;  	    
      case 17: ipAdd = ItemPropertyDarkvision ();
         break;      
      case 18: ipAdd = FW_Choose_IP_Extra_Range_Damage_Type ();
         break;
      // Freedom of Movement
      case 19: ipAdd = ItemPropertyFreeAction();
         break;
     // case 20: ipAdd = ItemPropertyHaste();
      //   break;
      //case 21: ipAdd = FW_Choose_IP_Immunity_Misc ();
      //   break;
      //case 22: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
      //   break;
      //case 23: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
      //   break;
      //case 24: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
      //   break;
      //case 25: ipAdd = FW_Choose_IP_Damage_Immunity ();
      //   break;
      //case 26: ipAdd = ItemPropertyImprovedEvasion();
      //   break;
      case 27: ipAdd = FW_Choose_IP_Light();
         break;
      case 28: ipAdd = FW_Choose_IP_Massive_Critical (nCR);
         break;
      case 29: ipAdd = FW_Choose_IP_Mighty (nCR);
         break;      
      //case 30: ipAdd = FW_Choose_IP_Regeneration (nCR);
      //   break;
      case 31: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
         break;
      case 32: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
         break;
      case 33: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      //case 34: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
      //   break;
      //case 35: ipAdd = ItemPropertyTrueSeeing();
      //   break;
      case 36: ipAdd = FW_Choose_IP_Unlimited_Ammo ();
         break;
      case 37: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
      } // end of switch
      return ipAdd;
   } // end of if

   else if (strStruct.nLootType == FW_WEAPON_THROWN)
   {     
      iRoll = Random (29);
      switch (iRoll)
      {
      //case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
      //   break;
      case 1: 
	     iRoll = Random(10) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	    	 }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);   }
		 else if (iRoll == 6)   { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 else if (iRoll == 7)   { ipAdd = FW_Choose_IP_Enhancement_Penalty (nCR);		 }
		 else if (iRoll == 8)   { ipAdd = FW_Choose_IP_Damage_Penalty (nCR);			 }
		 else if (iRoll == 9)   { ipAdd = ItemPropertyNoDamage ();						 }
		 else /* (iRoll == 10)*/ { ipAdd = FW_Choose_IP_Attack_Penalty (nCR);			 }
		 break;  	 
      case 2: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Align (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      case 7: ipAdd = FW_Choose_IP_Bonus_Feat ();
         break;
      case 8: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
         break;
      case 9: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 10: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 11: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 12: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;      
      case 13: ipAdd = ItemPropertyDarkvision ();
         break;     
      case 14: ipAdd = FW_Choose_IP_Enhancement_Bonus (nCR);
         break;
      case 15: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Align (nCR);
         break;
      case 16: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Race (nCR);
         break;
      case 17: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (nCR);
         break;
      case 18: ipAdd = FW_Choose_IP_Extra_Range_Damage_Type ();
         break;
      case 19: ipAdd = ItemPropertyHaste();
         break;
      case 20: ipAdd = FW_Choose_IP_Light();
         break;
      case 21: ipAdd = FW_Choose_IP_Massive_Critical (nCR);
         break;
      case 22: ipAdd = FW_Choose_IP_Mighty (nCR);
         break;      
      //case 23: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
      //   break;
      //case 24: ipAdd = FW_Choose_IP_On_Hit_Props ();
      //   break;
      case 25: ipAdd = FW_Choose_IP_Vampiric_Regeneration (nCR);
         break;
      case 26: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      //case 27: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
      //   break;
      case 28: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
	  default: break;
      }	 // end of switch 
      return ipAdd;
   } // end of if
   
   else if (strStruct.nLootType == FW_MISC_GAUNTLET)
   {
      iRoll = Random (37);
      switch (iRoll)
      {
      case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
         break;
      case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 7: 
	     iRoll = Random(9) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	    	 }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);   }
		 else if (iRoll == 6)   { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 else if (iRoll == 7)   { ipAdd = FW_Choose_IP_Enhancement_Penalty (nCR);		 }
		 else if (iRoll == 8)   { ipAdd = FW_Choose_IP_Damage_Penalty (nCR);			 }
		 else /* (iRoll == 9)*/ { ipAdd = FW_Choose_IP_Attack_Penalty (nCR);			 }
		 break;
      case 8: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      case 9: ipAdd = FW_Choose_IP_Bonus_Feat ();
         break;
      case 10: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
         break;
      case 11: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
         break;
      case 12: ipAdd = FW_Choose_IP_Cast_Spell ();
         break;
      case 13: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 14: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 15: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 16: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;
      /* Damage Reduction doesn't work in NWN 2 yet.
      case 25: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      case 17: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
         break;      
      case 18: ipAdd = ItemPropertyDarkvision ();
         break;   
      // Freedom of Movement
      case 19: ipAdd = ItemPropertyFreeAction();
         break;
      case 20: ipAdd = ItemPropertyHaste();
         break;
      case 21: ipAdd = FW_Choose_IP_Immunity_Misc ();
         break;
      case 22: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
         break;
      case 23: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
         break;
      case 24: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
         break;
      case 25: ipAdd = FW_Choose_IP_Damage_Immunity ();
         break;
      case 26: ipAdd = ItemPropertyImprovedEvasion();
         break;
      case 27: ipAdd = FW_Choose_IP_Light();
         break;
      case 28: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
         break;
      case 29: ipAdd = FW_Choose_IP_On_Hit_Props ();
         break;
      case 30: ipAdd = FW_Choose_IP_Regeneration (nCR);
         break;
      case 31: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
         break;
      case 32: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
         break;
      case 33: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      case 34: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
         break;
      //case 35: ipAdd = ItemPropertyTrueSeeing();
      //   break;
      case 36:
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break; 
      default: break;
      } // end of switch
      return ipAdd;
   } // end of if

   else if ((strStruct.nLootType == FW_WEAPON_MAGE_SPECIFIC)
             && (BASE_ITEM_MAGICSTAFF == GetBaseItemType(strStruct.oItem)))
   {
   	  iRoll =  Random (46);
      switch (iRoll)
      {
      case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
         break;
      case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 7: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Align (nCR);
         break;
      case 8: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Race (nCR);
         break;
      case 9: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_SAlign (nCR);
         break;
      case 10: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      case 11: ipAdd = FW_Choose_IP_Bonus_Feat ();
         break;
      case 12: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
         break;
      case 13: ipAdd = FW_Choose_IP_Bonus_Level_Spell(nCR);
         break;
      case 14: ipAdd = FW_Choose_IP_Cast_Spell ();
         break;
      case 15: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 16: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 17: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 18: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;
      /* Damage Reduction doesn't work in NWN 2 yet.
      case 25: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      */
      case 19: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
         break;
      case 20: 
	     iRoll = Random(10) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Damage_Vulnerability ();	    	 }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Decrease_Ability (nCR); 	 	 	 }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Decrease_AC (nCR); 		 	 	 }
		 else if (iRoll == 4)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);	 	 }
		 else if (iRoll == 5)   { ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);   }
		 else if (iRoll == 6)   { ipAdd = FW_Choose_IP_Decrease_Skill (nCR);			 }
		 else if (iRoll == 7)   { ipAdd = FW_Choose_IP_Enhancement_Penalty (nCR);		 }
		 else if (iRoll == 8)   { ipAdd = FW_Choose_IP_Damage_Penalty (nCR);			 }
		 else if (iRoll == 9)   { ipAdd = ItemPropertyNoDamage ();						 }
		 else /* (iRoll == 10)*/ { ipAdd = FW_Choose_IP_Attack_Penalty (nCR);			 }
		 break;  	  
      case 21: ipAdd = ItemPropertyDarkvision ();
         break;
      case 22: ipAdd = FW_Choose_IP_Enhancement_Bonus (nCR);
         break;
      case 23: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Align (nCR);
         break;
      case 24: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Race (nCR);
         break;
      case 25: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (nCR);
         break;
      case 26: ipAdd = FW_Choose_IP_Extra_Melee_Damage_Type ();
         break;     
      case 27: ipAdd = ItemPropertyHaste();
         break;      
      case 28: ipAdd = FW_Choose_IP_Immunity_Misc ();
         break;
      case 29: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
         break;
      case 30: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
         break;
      case 31: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
         break;
      case 32: ipAdd = FW_Choose_IP_Damage_Immunity ();
         break;
      case 33: ipAdd = ItemPropertyImprovedEvasion();
         break;      
      case 34: ipAdd = FW_Choose_IP_Light();
         break;
      case 35: ipAdd = FW_Choose_IP_Massive_Critical (nCR);
         break;
      case 36: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
         break;
      case 37: ipAdd = FW_Choose_IP_On_Hit_Props ();
         break;
      case 38: ipAdd = FW_Choose_IP_Regeneration (nCR);
         break;
      case 39: ipAdd = FW_Choose_IP_Vampiric_Regeneration (nCR);
         break;
      case 40: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
         break;
      case 41: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
         break;
      case 42: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      case 43: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
         break;
//      case 44: ipAdd = ItemPropertyTrueSeeing();
//         break;
      case 45: 
	     iRoll = Random(4) + 1;
		 if      (iRoll == 1)   { ipAdd = FW_Choose_IP_Limit_Use_By_Align ();  }
		 else if (iRoll == 2)   { ipAdd = FW_Choose_IP_Limit_Use_By_Class ();  }
		 else if (iRoll == 3)   { ipAdd = FW_Choose_IP_Limit_Use_By_Race ();   }
		 else /* (iRoll == 4)*/ { ipAdd = FW_Choose_IP_Limit_Use_By_SAlign (); }
	     break;
		 
      default: break;
      } // end of switch
	  return ipAdd;   
   } // end of if   

   // Below is the listing of all 68 item properties.  This would only get
   // executed if for some reason there was an error above and some type
   // of loot was of a different category than the ones I have above.  I 
   // believe I got everything above, but just in case I didn't, I list
   // them all here.  All the categories above exclude 1 or more items from
   // the master list here.
   iRoll = Random (67);   
   switch (iRoll)
   {      
      //case 0: ipAdd = FW_Choose_IP_Ability_Bonus (nCR);
      //   break;
      case 1: ipAdd = FW_Choose_IP_AC_Bonus (nCR);
         break;
      case 2: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Align (nCR);
         break;
      case 3: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Damage_Type (nCR);
         break;
      case 4: ipAdd = FW_Choose_IP_AC_Bonus_Vs_Race (nCR);
         break;
      case 5: ipAdd = FW_Choose_IP_AC_Bonus_Vs_SAlign (nCR);
         break;
      case 6: ipAdd = FW_Choose_IP_Arcane_Spell_Failure ();
         break;
      case 7: ipAdd = FW_Choose_IP_Attack_Bonus (nCR);
         break;
      case 8: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Align (nCR);
         break;
      case 9: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_Race (nCR);
         break;
      case 10: ipAdd = FW_Choose_IP_Attack_Bonus_Vs_SAlign (nCR);
         break;
      case 11: ipAdd = FW_Choose_IP_Attack_Penalty (nCR);
         break;
      case 12: ipAdd = FW_Choose_IP_Bonus_Feat ();
         break;
      case 13: ipAdd = FW_Choose_IP_Bonus_Hit_Points (nCR);
         break;
      case 14: ipAdd = FW_Choose_IP_Bonus_Level_Spell (nCR);
         break;
      case 15: ipAdd = FW_Choose_IP_Bonus_Saving_Throw (nCR);
         break;
      case 16: ipAdd = FW_Choose_IP_Bonus_Saving_Throw_VsX (nCR);
         break;
      case 17: ipAdd = FW_Choose_IP_Bonus_Spell_Resistance (nCR);
         break;
      case 18: ipAdd = FW_Choose_IP_Cast_Spell ();
         break;
      case 19: ipAdd = FW_Choose_IP_Damage_Bonus (nCR);
         break;
      case 20: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Align (nCR);
         break;
      case 21: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_Race (nCR);
         break;
      case 22: ipAdd = FW_Choose_IP_Damage_Bonus_Vs_SAlign (nCR);
         break;
      case 23: ipAdd = FW_Choose_IP_Damage_Immunity ();
         break;
      case 24: ipAdd = FW_Choose_IP_Damage_Penalty (nCR);
         break;
      case 25: ipAdd = FW_Choose_IP_Damage_Reduction (nCR);
         break;
      case 26: ipAdd = FW_Choose_IP_Damage_Resistance (nCR);
         break;
      case 27: ipAdd = FW_Choose_IP_Damage_Vulnerability ();
         break;
      case 28: ipAdd = ItemPropertyDarkvision ();
         break;
      case 29: ipAdd = FW_Choose_IP_Decrease_Ability (nCR);
         break;
      case 30: ipAdd = FW_Choose_IP_Decrease_AC (nCR);
         break;
      case 31: ipAdd = FW_Choose_IP_Decrease_Skill (nCR);
         break;
      case 32: ipAdd = FW_Choose_IP_Enhancement_Bonus (nCR);
         break;
      case 33: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Align (nCR);
         break;
      case 34: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_Race (nCR);
         break;
      case 35: ipAdd = FW_Choose_IP_Enhancement_Bonus_Vs_SAlign (nCR);
         break;
      case 36: ipAdd = FW_Choose_IP_Enhancement_Penalty (nCR);
         break;
      case 37: ipAdd = FW_Choose_IP_Extra_Melee_Damage_Type ();
         break;
      case 38: ipAdd = FW_Choose_IP_Extra_Range_Damage_Type ();
         break;
      // Freedom of Movement
      case 39: ipAdd = ItemPropertyFreeAction();
         break;
      case 40: ipAdd = ItemPropertyHaste();
         break;
      /* Making an item healer's kit doesn't work dynamically
      case 40: ipAdd = FW_Choose_IP_Healer_Kit (nCR);
         break;  */
      case 41: ipAdd = ItemPropertyHolyAvenger();
         break;
      //case 42: ipAdd = FW_Choose_IP_Immunity_Misc ();
      //   break;
      //case 43: ipAdd = FW_Choose_IP_Immunity_To_Spell_Level (nCR);
      //   break;
      //case 44: ipAdd = ItemPropertyImprovedEvasion();
      //   break;
      case 45: ipAdd = ItemPropertyKeen();
         break;
      case 46: ipAdd = FW_Choose_IP_Light();
         break;
      case 47: ipAdd = FW_Choose_IP_Limit_Use_By_Align ();
         break;
      case 48: ipAdd = FW_Choose_IP_Limit_Use_By_Class ();
         break;
      case 49: ipAdd = FW_Choose_IP_Limit_Use_By_Race ();
         break;
      case 50: ipAdd = FW_Choose_IP_Limit_Use_By_SAlign ();
         break;
      case 51: ipAdd = FW_Choose_IP_Massive_Critical (nCR);
         break;
      case 52: ipAdd = FW_Choose_IP_Mighty (nCR);
         break;
      case 53: ipAdd = ItemPropertyNoDamage ();
         break;
      //case 54: ipAdd = FW_Choose_IP_On_Hit_Cast_Spell ();
      //   break;
      //case 55: ipAdd = FW_Choose_IP_On_Hit_Props ();
      //   break;
      case 56: ipAdd = FW_Choose_IP_Reduced_Saving_Throw (nCR);
         break;
      case 57: ipAdd = FW_Choose_IP_Reduced_Saving_Throw_VsX (nCR);
         break;
      //case 58: ipAdd = FW_Choose_IP_Regeneration (nCR);
      //   break;
      case 59: ipAdd = FW_Choose_IP_Skill_Bonus (nCR);
         break;
      case 60: ipAdd = FW_Choose_IP_Spell_Immunity_School ();
         break;
      case 61: ipAdd = FW_Choose_IP_Spell_Immunity_Specific ();
         break;
      case 62: ipAdd = FW_Choose_IP_Thieves_Tools ();
         break;
      //case 63: ipAdd = ItemPropertyTrueSeeing();
      //   break;
		 
      /* Turn Resistance is broken as of 10 July 2007
      case 64: ipAdd = FW_Choose_IP_Turn_Resistance (nCR);
         break;
      */
      case 64: ipAdd = FW_Choose_IP_Unlimited_Ammo ();
         break;
      case 65: ipAdd = FW_Choose_IP_Vampiric_Regeneration (nCR);
         break;
      /* Weight Increase.  Weight increase didn't work as of 10 July 2007.
      case 66: ipAdd = FW_Choose_IP_Weight_Increase ();
         break;
      */
      case 66: ipAdd = FW_Choose_IP_Weight_Reduction ();
         break;
      default: break;
   } // end of switch 
  
   return ipAdd;
}


// *****************************************
//              MAIN
//
// For convenience I show here the basic logic flow of how
// this main () works.
//
/*
	1. Monster spawns.

	2. Does the monster drop loot? 
		a. If yes, go to step 3.
		b. If no, exit.

	3. Determine how many items drop.

	4. Pick an item to put in monster's inventory 
		a. If the item picked can have item properties added
		   to it (i.e. weapon, armor, etc), go to step 5. 
		b. If the item picked can NOT have item properties added
		   to it (i.e. gold, books, traps, etc) go to step 9.

	5. Determine how many item PROPERTIES the item will have.
		a. If zero properties (i.e. generic weapon, armor, etc), 
		   go to step 9.
		b. If one or more properties (magical loot) go to step 6.

	6. Choose an acceptable item property for the type of item chosen.
		a. If Overall item Value Restrictions are turned OFF,
		   go to step 7.
		b. If Overall Item Value Restrictions are turned ON
		   and the acceptable item property will NOT put the item's
		   value over the limit go to step 7.
		c. If Overall Item Value Restrictions are turned ON
		   and the acceptable item property will put the item's
		   value over the limit go to step 9.
		   
	7. Add the item property to the item.

	8. Repeat steps 6-7 for all additional item properties (if any).
	
	9. Make the item droppable.

	10. Make the item pick-pocketable.
	
	11. Make the item unidentified.

	12. Determine if the item is cursed.
		a. If cursed, set it to cursed.
		b. If NOT cursed, leave the item alone.

	13. Repeat steps 4-12 for all additional items (if any).

	14. Done. Monster spawns into the game with random loot in its 
	    inventory.
*/	
//
// *****************************************
void main()
{
   // CR is used for sliding scale and probabilities.
   int nCR = FloatToInt(CSLGetChallengeRating (OBJECT_SELF)); 
    
   if (nCR < 0)
   		nCR = 0;
   if (nCR > 41)
   		nCR = 41;   
      
   int Loot = FW_DoesMonsterDropLoot (nCR);
   
   if (Loot)
   {
      int nNumItems = FW_HowManyItemsDrop ();
      while (nNumItems > 0)
      {
	  	 // The call to FW_CreateLootOnObject does most of the work of this 
		 // program.  
         struct MyStruct strStruct;
         strStruct = FW_CreateLootOnObject (strStruct, nCR);
		  
         if (strStruct.nLootType == FW_MISC_POTION   ||
		     strStruct.nLootType == FW_MISC_TRAPS    ||
			 strStruct.nLootType == FW_MISC_BOOKS    ||
			 strStruct.nLootType == FW_MISC_GOLD     ||
			 strStruct.nLootType == FW_MISC_GEMS     ||
			 strStruct.nLootType == FW_MISC_HEAL_KIT ||
			 strStruct.nLootType == FW_MISC_SCROLL   ||
			 strStruct.nLootType == FW_MISC_CRAFTING_MATERIAL ||
			 strStruct.nLootType == FW_MISC_OTHER    ||
			 ((strStruct.nLootType == FW_WEAPON_MAGE_SPECIFIC) && (BASE_ITEM_MAGICWAND == GetBaseItemType(strStruct.oItem))) ||
			 ((strStruct.nLootType == FW_WEAPON_MAGE_SPECIFIC) && (BASE_ITEM_MAGICROD == GetBaseItemType(strStruct.oItem)))
			 ) // close parenthesis on if.
	     {
		    // Do nothing. Randomness already taken care of.	
		 }		 
		 else // we rolled an item that could have an IP added.
		 {
		    int nNumIP = FW_HowManyIP ();
            while (nNumIP > 0)
            {
				itemproperty ipAdd = FW_WhatItemPropertyToAdd (strStruct, nCR);
               
				// Overall Gold Piece value check added in version 1.2
				if (FW_ALLOW_OVERALL_GP_RESTRICTIONS)
				{
               		// Here's the new part for ILR.              		
               		object oTemporaryItem = CopyItem(strStruct.oItem, OBJECT_SELF, FALSE);
               		CSLSafeAddItemProperty (oTemporaryItem, ipAdd);                              		
               		if (FW_IsItemRolledTooExpensive (oTemporaryItem, nCR))
               		{   
						nNumIP--;  						
					}
               		else
               		{
						CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
                    	nNumIP--;						             									
               		}
					DestroyObject (oTemporaryItem);
				} 				
				// If we don't care what the overall gp value is. 
				else  // FW_ALLOW_OVERALL_GP_RESTRICTIONS == FALSE;
				{
					CSLSafeAddItemProperty (strStruct.oItem, ipAdd);
               		nNumIP--;
				}
            } // end of while

            if (FW_ALLOW_CURSED_ITEMS == TRUE)
            {
               if (FW_IsItemCursed ())
               {
                  SetItemCursedFlag (strStruct.oItem, TRUE);
               }
            }
		 } // end of else
         SetDroppableFlag (strStruct.oItem, TRUE);
         SetPickpocketableFlag (strStruct.oItem, TRUE);
         // For testing I will set to identified. Normally the item won't be
         // identified. Change to FALSE after testing.
         SetIdentified (strStruct.oItem, FALSE);
         nNumItems--;
      } // end of while
   } // end of if (Loot)
} // end of main