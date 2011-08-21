/** @file
* @brief Include File for Dex Treasure System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//#include "_SCUtility"

#include "_CSLCore_Strings"
#include "_CSLCore_Math"
//#include "_CSLCore_Items"

/*
object SCTreas_CreateArcaneScroll(object oTarget, int iHD = 1);
object SCTreas_CreateDivineScroll(object oTarget, int iHD = 1);
void   SCTreas_CreateGems(object oObject, int nGold);
object SCTreas_CreateRandomPotion(object oTarget, int nStack = 0);
object SCTreas_CreateRandomScroll(object oTarget, int iHD = 1);
string SCTreas_PickArcaneScroll(int nLvl = 1);
string SCTreas_PickDivineScroll(int nLvl = 1);
int    SCTreas_PickScrollLevel(int iHD = 1);
int    SCTreas_TurnGoldIntoGems(object oObject, int nGold, int nGemValue, string sRef);
*/

string SCTreas_PickArcaneScroll(int nLvl = 1) {
   int nRandom = 0;
   if (nLvl==1) {
      nRandom = Random(23) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr102"; // 1 Amplify
         case  2: return "nw_it_sparscr112"; // 1 Burning_Hands
         case  3: return "n2_it_sparscr004"; // 1 Cause_Fear
         case  4: return "nw_it_sparscr107"; // 1 Charm_Person
         case  5: return "nw_it_sparscr110"; // 1 Color_Spray
         case  6: return "nw_it_sparscr101"; // 1 Endure_Elements
         case  7: return "n2_it_sparscr009"; // 1 Enlarge_Person
         case  8: return "x1_it_sparscr101"; // 1 Expeditious_Retreat
         case  9: return "nw_it_sparscr103"; // 1 Grease
         case 10: return "n2_it_sparscr019"; // 1 Joyful_Noise
         case 11: return "n2_it_sparscr021"; // 1 Low_Light_Vision
         case 12: return "nw_it_sparscr104"; // 1 Mage_Armor
         case 13: return "nw_it_sparscr109"; // 1 Magic_Missile
         case 14: return "x2_it_sparscr105"; // 1 Magic_Weapon
         case 15: return "nw_it_sparscr102"; // 1 PROTECTION_FROM_ALIGNMENT
         case 16: return "nw_it_sparscr111"; // 1 Ray_of_Enfeeblement
         case 17: return "nw_it_sparscr001"; // 1 Resistance
         case 18: return "x1_it_sparscr103"; // 1 Shield
         case 19: return "n2_it_sparscr028"; // 1 Shocking_Grasp
         case 20: return "nw_it_sparscr108"; // 1 Sleep
         case 21: return "nw_it_sparscr105"; // 1 Summon_Creature_I
         case 22: return "x1_it_sparscr104"; // 1 True_Strike
         case 23: return "nx1_it_sparscr04"; // 1 Lionheart                        
      }
   } else if (nLvl==2) {
      nRandom = Random(38) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr201"; // 2 BalagarnsIronHorn
         case  2: return "n2_it_sparscr002"; // 2 Bears_Endurance
         case  3: return "nw_it_sparscr211"; // 2 Blindness_and_Deafness
         case  4: return "n2_it_sparscr003"; // 2 Blindsight
         case  5: return "nw_it_sparscr212"; // 2 Bulls_Strength
         case  6: return "nw_it_sparscr213"; // 2 Cats_Grace
         case  7: return "x2_it_sparscr206"; // 2 Cloud_of_Bewilderment
         case  8: return "x2_it_sparscr201"; // 2 Combust
         case  9: return "nw_it_sparscr206"; // 2 Darkness
         case 10: return "x2_it_sparscr202"; // 2 Death_Armor
         case 11: return "nw_it_sparscr219"; // 2 Eagle_Splendor
         case 12: return "n2_it_sparscr010"; // 2 False_Life
         case 13: return "n2_it_sparscr011"; // 2 Fireburst
         case 14: return "x2_it_sparscr205"; // 2 Flame_Weapon
         case 15: return "nw_it_sparscr220"; // 2 Foxs_Cunning
         case 16: return "x2_it_sparscr203"; // 2 Gedlees_Electric_Loop
         case 17: return "nw_it_sparscr208"; // 2 Ghostly_Visage
         case 18: return "nw_it_sparscr209"; // 2 Ghoul_Touch
         case 19: return "n2_it_sparscr014"; // 2 Heroism
         case 20: return "nw_it_sparscr308"; // 2 Hold_Person
         case 21: return "nw_it_sparscr106"; // 2 Identify
         case 22: return "nw_it_sparscr207"; // 2 Invisibility
         case 23: return "nw_it_sparscr216"; // 2 Knock
         case 24: return "nw_it_sparscr218"; // 2 Lesser_Dispel
         case 25: return "nw_it_sparscr202"; // 2 Melfs_Acid_Arrow
         case 26: return "n2_it_sparscr023"; // 2 Mirror_Image
         case 27: return "nw_it_sparscr221"; // 2 Owls_Wisdom
         case 28: return "n2_it_sparscr025"; // 2 Protection_From_Arrows
         case 29: return "n2_it_sparscr026"; // 2 Rage
         case 30: return "nw_it_sparscr201"; // 2 Resist_Energy
         case 31: return "nw_it_sparscr210"; // 2 Scare
         case 32: return "nw_it_sparscr205"; // 2 See_Invisibility
         case 33: return "nw_it_sparscr203"; // 2 Summon_Creature_II
         case 34: return "x1_it_sparscr202"; // 2 Tashas_Hideous_Laughter
         case 35: return "nw_it_sparscr204"; // 2 Web
         case 36: return "nx1_it_sparscr00"; // 2 Curse_of_Blades                  
         case 37: return "nx1_it_sparscr03"; // 2 Touch_Of_Idiocy                  
         case 38: return "nx1_it_sparscr04"; // 2 Scorching_Ray_Single             
      }
   } else if (nLvl==3) {
      nRandom = Random(36) + 1;
      switch (nRandom) {
         case  1: return "nw_it_sparscr509"; // 3 Animate_Dead
         case  2: return "nw_it_sparscr414"; // 3 Bestow_Curse
         case  3: return "nw_it_sparscr405"; // 3 Charm_Monster
         case  4: return "nw_it_sparscr307"; // 3 Clairaudience_and_Clairvoyance
         case  5: return "nw_it_sparscr406"; // 3 Confusion
         case  6: return "nw_it_sparscr411"; // 3 Contagion
         case  7: return "n2_it_sparscr007"; // 3 Deep_Slumber
         case  8: return "nw_it_sparscr301"; // 3 Dispel_Magic
         case  9: return "x1_it_sparscr301"; // 3 Displacement
         case 10: return "nw_it_sparscr413"; // 3 Fear
         case 11: return "x2_it_sparscr305"; // 3 Find_Traps
         case 12: return "nw_it_sparscr309"; // 3 Fireball
         case 13: return "nw_it_sparscr304"; // 3 Flame_Arrow
         case 14: return "x2_it_sparscr304"; // 3 Greater_Magic_Weapon
         case 15: return "x1_it_sparscr303"; // 3 Gust_of_Wind
         case 16: return "nw_it_sparscr312"; // 3 Haste
         case 17: return "n2_it_sparscr022"; // 3 Improved_Mage_Armor
         case 18: return "nw_it_sparscr314"; // 3 Invisibility_Sphere
         case 19: return "x2_it_sparscr303"; // 3 Keen_Edge
         case 20: return "nw_it_sparscr310"; // 3 Lightning_Bolt
         case 21: return "nw_it_sparscr302"; // 3 Magic_Circle_against_Alignment
         case 22: return "x2_it_sparscr301"; // 3 Mestils_Acid_Breath
         case 23: return "nw_it_sparscr303"; // 3 Protection_from_Energy
         case 24: return "nw_it_sparscr402"; // 3 Remove_Curse
         case 25: return "x2_it_sparscr302"; // 3 Scintillating_Sphere
         case 26: return "nw_it_sparscr313"; // 3 Slow
         case 27: return "n2_it_sparscr031"; // 3 Spiderskin
         case 28: return "nw_it_sparscr305"; // 3 Stinking_Cloud
         case 29: return "nw_it_sparscr306"; // 3 Summon_Creature_III
         case 30: return "nw_it_sparscr311"; // 3 Vampiric_Touch
         case 31: return "n2_it_sparscr034"; // 3 War_Cry
         case 32: return "n2_it_sparscr035"; // 3 Weapon_of_Impact
         case 33: return "nx1_it_sparscr04"; // 3 Mass_Aid                         
         case 34: return "nx1_it_sparscr02"; // 3 Mass_Curse_Of_Blades             
         case 35: return "nx1_it_sparscr02"; // 3 Power_Word_Maladroit             
         case 36: return "nx1_it_sparscr03"; // 3 Power_Word_Weaken                
      }
   } else if (nLvl==4) {
      nRandom = Random(24) + 1;
      switch (nRandom) {
         case  1: return "n2_it_sparscr001"; // 4 Assay_Resistance
         case  2: return "n2_it_sparscr006"; // 4 Crushing_Despair
         case  3: return "nw_it_sparscr501"; // 4 Dismissal
         case  4: return "nw_it_sparscr503"; // 4 Dominate_Person
         case  5: return "nw_it_sparscr416"; // 4 Elemental_Shield
         case  6: return "nw_it_sparscr412"; // 4 Enervation
         case  7: return "nw_it_sparscr418"; // 4 Evards_Black_Tentacles
         case  8: return "nw_it_sparscr408"; // 4 Greater_Invisibility
         case  9: return "nw_it_sparscr505"; // 4 Hold_Monster
         case 10: return "x2_it_sparscr401"; // 4 Ice_Storm
         case 11: return "x1_it_sparscr401"; // 4 Isaacs_Lesser_Missile_Storm
         case 12: return "n2_it_sparscr020"; // 4 Least_Spell_Mantle
         case 13: return "n2_it_sparscr013"; // 4 Lesser_Globe_of_Invulnerability
         case 14: return "nw_it_sparscr401"; // 4 Lesser_Globe_of_Invulnerability
         case 15: return "nw_it_sparscr417"; // 4 Lesser_Spell_Breach
         case 16: return "nw_it_sparscr409"; // 4 Phantasmal_Killer
         case 17: return "nw_it_sparscr415"; // 4 Polymorph_Self
         case 18: return "nw_it_sparscr410"; // 4 Shadow_Conjuration
         case 19: return "nw_it_sparscr403"; // 4 Stoneskin
         case 20: return "nw_it_sparscr404"; // 4 Summon_Creature_IV
         case 21: return "nw_it_sparscr407"; // 4 Wall_of_Fire
         case 22: return "nx1_it_sparscr04"; // 4 Recitation                       
         case 23: return "nx1_it_sparscr03"; // 4 Shout                            
         case 24: return "nx1_it_sparscr00"; // 4 Greater_Resistance               
      }
   } else if (nLvl==5) {
      nRandom = Random(24) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr502"; // 5 Bigbys_Interposing_Hand
         case  2: return "nw_it_sparscr502"; // 5 Cloudkill
         case  3: return "nw_it_sparscr507"; // 5 Cone_of_Cold
         case  4: return "nw_it_sparscr608"; // 5 Ethereal_Visage
         case  5: return "nw_it_sparscr504"; // 5 Feeblemind
         case  6: return "x1_it_sparscr501"; // 5 Firebrand
         case  7: return "nw_it_sparscr602"; // 5 Greater_Dispelling
         case  8: return "n2_it_sparscr012"; // 5 Greater_Fireburst
         case  9: return "n2_it_sparscr015"; // 5 Greater_Heroism
         case 10: return "nw_it_sparscr508"; // 5 Greater_Shadow_Conjuration
         case 11: return "x2_it_sparscr602"; // 5 Legend_Lore
         case 12: return "nw_it_sparscr511"; // 5 Lesser_Mind_Blank
         case 13: return "nw_it_sparscr512"; // 5 Lesser_Planar_Binding
         case 14: return "nw_it_sparscr513"; // 5 Lesser_Spell_Mantle
         case 15: return "nw_it_sparscr506"; // 5 Mind_Fog
         case 16: return "n2_it_sparscr029"; // 5 Shroud_of_Flame
         case 17: return "n2_it_sparscr030"; // 5 Song_of_Discord
         case 18: return "nw_it_sparscr510"; // 5 Summon_Creature_V
         case 19: return "nw_it_sparscr606"; // 5 True_Seeing
         case 20: return "n2_it_sparscr033"; // 5 Vitriolic_Sphere
         case 21: return "nx1_it_sparscr01"; // 5 Mass_Contagion                   
         case 22: return "nx1_it_sparscr03"; // 5 Wall_Of_Dispel_Magic             
         case 23: return "nx1_it_sparscr02"; // 5 Power_Word_Disable               
         case 24: return "nx1_it_sparscr00"; // 5 Cacophonic_Burst                 
      }
   } else if (nLvl==6) {
      nRandom = Random(24) + 1;
      switch (nRandom) {
         case  1: return "nw_it_sparscr603"; // 6 Acid_Fog
         case  2: return "x1_it_sparscr602"; // 6 Bigbys_Forceful_Hand
         case  3: return "nw_it_sparscr607"; // 6 Chain_Lightning
         case  4: return "nw_it_sparscr610"; // 6 Circle_of_Death
         case  5: return "x1_it_sparscr601"; // 6 Dirge
         case  6: return "n2_it_sparscr008"; // 6 Disintegrate
         case  7: return "x1_it_sparscr605"; // 6 Flesh_to_stone
         case  8: return "nw_it_sparscr601"; // 6 Globe_of_Invulnerability
         case  9: return "nw_it_sparscr612"; // 6 Greater_Spell_Breach
         case 10: return "nw_it_sparscr613"; // 6 Greater_Stoneskin
         case 11: return "x1_it_sparscr603"; // 6 Isaacs_Greater_Missile_Storm
         case 12: return "nw_it_sparscr604"; // 6 Planar_Binding
         case 13: return "nw_it_sparscr609"; // 6 Shades
         case 14: return "n2_it_sparscr032"; // 6 Stone_Body
         case 15: return "x1_it_sparscr604"; // 6 Stone_to_flesh
         case 16: return "nw_it_sparscr605"; // 6 Summon_Creature_VI
         case 17: return "nw_it_sparscr614"; // 6 Tensers_Transformation
         case 18: return "x2_it_sparscr601"; // 6 Undeath_to_Death
         case 19: return "nx1_it_sparscr01"; // 6 Mass_Cat_Grace                   
         case 20: return "nx1_it_sparscr02"; // 6 Mass_Eagle_Splendor              
         case 21: return "nx1_it_sparscr01"; // 6 Mass_Bull_Strength               
         case 22: return "nx1_it_sparscr02"; // 6 Mass_Fox_Cunning                 
         case 23: return "nx1_it_sparscr01"; // 6 Mass_Bear_Endurance              
         case 24: return "nx1_it_sparscr03"; // 6 Superior_Resistance              
      }
   } else if (nLvl==7) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr701"; // 7 Bigbys_Grasping_Hand
         case  2: return "nw_it_sparscr707"; // 7 Control_Undead
         case  3: return "nw_it_sparscr704"; // 7 Delayed_Blast_Fireball
         case  4: return "nw_it_sparscr708"; // 7 Finger_of_Death
         case  5: return "n2_it_sparscr017"; // 7 Mass_Hold_Person
         case  6: return "nw_it_sparscr705"; // 7 Mordenkainens_Sword
         case  7: return "nw_it_sparscr702"; // 7 Power_Word_Stun
         case  8: return "nw_it_sparscr706"; // 7 Prismatic_Spray
         case  9: return "nw_it_sparscr802"; // 7 Protection_from_Spells
         case 10: return "x2_it_sparscr703"; // 7 Shadow_Shield
         case 11: return "nw_it_sparscr701"; // 7 Spell_Mantle
         case 12: return "nw_it_sparscr703"; // 7 Summon_Creature_VII
         case 13: return "nx1_it_sparscr00"; // 7 Avasculate                       
         case 14: return "nx1_it_sparscr01"; // 7 Hiss_Of_Sleep                    
         case 15: return "nx1_it_sparscr02"; // 7 Power_Word_Blind                 
      }
   } else if (nLvl==8) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr801"; // 8 Bigbys_Clenched_Fist
         case  2: return "x2_it_sparscr801"; // 8 Blackstaff
         case  3: return "nw_it_sparscr803"; // 8 Greater_Planar_Binding
         case  4: return "nw_it_sparscr809"; // 8 Horrid_Wilting
         case  5: return "nw_it_sparscr804"; // 8 Incendiary_Cloud
         case  6: return "n2_it_sparscr018"; // 8 Iron_Body
         case  7: return "nw_it_sparscr807"; // 8 Mass_Blindness_and_Deafness
         case  8: return "n2_it_sparscr005"; // 8 Mass_Charm_Monster
         case  9: return "nw_it_sparscr801"; // 8 Mind_Blank
         case 10: return "n2_it_sparscr024"; // 8 Polar_Ray
         case 11: return "nw_it_sparscr808"; // 8 Premonition
         case 12: return "nw_it_sparscr805"; // 8 Summon_Creature_VIII
         case 13: return "nx1_it_sparscr00"; // 8 Greater_Shout                    
         case 14: return "nx1_it_sparscr01"; // 8 Greater_Wall_Of_Dispel_Magic     
         case 15: return "nx1_it_sparscr03"; // 8 Power_Word_Petrify               
      }
   } else if (nLvl==9) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: return "x1_it_sparscr901"; // 9 Bigbys_Crushing_Hand
         case  2: return "nw_it_sparscr905"; // 9 Dominate_Monster
         case  3: return "nw_it_sparscr908"; // 9 Energy_Drain
         case  4: return "n2_it_sparscr036"; // 9 Etherealness
         case  5: return "nw_it_sparscr902"; // 9 Gate
         case  6: return "nw_it_sparscr912"; // 9 Greater_Spell_Mantle
         case  7: return "n2_it_sparscr016"; // 9 Mass_Hold_Monster
         case  8: return "nw_it_sparscr906"; // 9 Meteor_Swarm
         case  9: return "nw_it_sparscr901"; // 9 Mordenkainens_Disjunction
         case 10: return "nw_it_sparscr903"; // 9 Power_Word_Kill
         case 11: return "nw_it_sparscr910"; // 9 Shapechange
         case 12: return "nw_it_sparscr904"; // 9 Summon_Creature_IX
         case 13: return "nw_it_sparscr909"; // 9 Wail_of_the_Banshee
         case 14: return "nw_it_sparscr907"; // 9 Weird
         case 15: return "nx1_it_sparscr00"; // 9 Glacial_Wrath                    
      }
   }
   return "nw_it_sparscr101";
}

string SCTreas_PickDivineScroll(int nLvl = 1) {
   int nRandom = 0;
   if (nLvl==1) {
      nRandom = Random(16) + 1;
      switch (nRandom) {
         case  1: return "x1_it_spdvscr101"; // 1 Bane
         case  2: return "x2_it_spdvscr103"; // 1 Bless
         case  3: return "x2_it_spdvscr102"; // 1 Bless_Weapon
         case  4: return "x1_it_spdvscr107"; // 1 Camoflage
         case  5: return "x2_it_spdvscr104"; // 1 Cure_Light_Wounds
         case  6: return "x1_it_spdvscr102"; // 1 Divine_Favor
         case  7: return "x2_it_spdvscr105"; // 1 Doom
         case  8: return "x2_it_spdvscr106"; // 1 Entangle
         case  9: return "x1_it_spdvscr103"; // 1 Entropic_Shield
         case 10: return "n2_it_spdvscr015"; // 1 Foundation_of_Stone
         case 11: return "x1_it_spdvscr104"; // 1 Inflict_Light_Wounds
         case 12: return "x1_it_spdvscr106"; // 1 Magic_Fang
         case 13: return "x2_it_spdvscr107"; // 1 Remove_Fear
         case 14: return "x2_it_spdvscr108"; // 1 Sanctuary
         case 15: return "x1_it_spdvscr105"; // 1 Shield_of_Faith
         case 16: return "nx1_it_spdvscr01"; // 1 Lesser_Vigor                     
      }
   } else if (nLvl==2) {
      nRandom = Random(14) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr201"; // 2 Aid
         case  2: return "x1_it_spdvscr204"; // 2 AuraOfGlory
         case  3: return "x2_it_spdvscr202"; // 2 Barkskin
         case  4: return "n2_it_spdvscr014"; // 2 Body_of_the_Sun
         case  5: return "x2_it_spdvscr203"; // 2 Cure_Moderate_Wounds
         case  6: return "n2_it_spdvscr004"; // 2 Death_Knell
         case  7: return "x2_it_spdvscr204"; // 2 Hold_Animal
         case  8: return "x1_it_spdvscr201"; // 2 Inflict_Moderate_Wounds
         case  9: return "nw_it_spdvscr201"; // 2 Lesser_Restoration
         case 10: return "x2_it_spdvscr205"; // 2 Remove_Paralysis
         case 11: return "n2_it_spdvscr013"; // 2 Shield_Other
         case 12: return "nw_it_spdvscr203"; // 2 Silence
         case 13: return "nw_it_spdvscr204"; // 2 Sound_Burst
         case 14: return "nx1_it_spdvscr00"; // 2 Creeping_Cold                    
      }
   } else if (nLvl==3) {
      nRandom = Random(22) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr307"; // 3 Call_Lightning
         case  2: return "x2_it_spdvscr308"; // 3 Cure_Serious_Wounds
         case  3: return "x2_it_spdvscr309"; // 3 Dominate_Animal
         case  4: return "x2_it_spdvscr306"; // 3 Glyph_of_Warding
         case  5: return "x1_it_spdvscr303"; // 3 Greater_Magic_Fang
         case  6: return "x2_it_spdvscr301"; // 3 Infestation_of_Maggots
         case  7: return "x1_it_spdvscr302"; // 3 Inflict_Serious_Wounds
         case  8: return "x2_it_spdvscr310"; // 3 Invisibility_Purge
         case  9: return "n2_it_spdvscr016"; // 3 Jagged_Tooth
         case 10: return "x2_it_spdvscr304"; // 3 Magic_Vestment
         case 11: return "nw_it_spdvscr402"; // 3 Neutralize_Poison
         case 12: return "x2_it_spdvscr407"; // 3 Poison
         case 13: return "x2_it_spdvscr312"; // 3 Prayer
         case 14: return "x1_it_spdvscr305"; // 3 Quillfire
         case 15: return "nw_it_spdvscr301"; // 3 Remove_Blindness_and_Deafness
         case 16: return "nw_it_spdvscr302"; // 3 Remove_Disease
         case 17: return "x2_it_spdvscr313"; // 3 Searing_Light
         case 18: return "x1_it_spdvscr304"; // 3 Spike_Growth
         case 19: return "nx1_it_spdvscr01"; // 3 Hypothermia                      
         case 20: return "nx1_it_spdvscr03"; // 3 Vigor                            
         case 21: return "nx1_it_spdvscr03"; // 3 Visage_Of_The_Diety_Lesser       
         case 22: return "nx1_it_spdvscr02"; // 3 Mass_Lesser_Vigor                
      }
   } else if (nLvl==4) {
      nRandom = Random(12) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr402"; // 4 Cure_Critical_Wounds
         case  2: return "x2_it_spdvscr403"; // 4 Death_Ward
         case  3: return "x2_it_spdvscr404"; // 4 Divine_Power
         case  4: return "x1_it_spdvscr403"; // 4 Flame_Strike
         case  5: return "x2_it_spdvscr405"; // 4 Freedom_of_Movement
         case  6: return "x2_it_spdvscr406"; // 4 Hammer_of_the_Gods
         case  7: return "x2_it_spdvscr401"; // 4 Holy_Sword
         case  8: return "x1_it_spdvscr401"; // 4 Inflict_Critical_Wounds
         case  9: return "x1_it_spdvscr402"; // 4 Mass_Camoflage
         case 10: return "n2_it_spdvscr017"; // 4 Moon_Bolt
         case 11: return "nw_it_spdvscr401"; // 4 Restoration
         case 12: return "nx1_it_spdvscr00"; // 4 Greater_Creeping_Cold            
      }
   } else if (nLvl==5) {
      nRandom = Random(14) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr508"; // 5 Awaken
         case  2: return "x2_it_spdvscr501"; // 5 Battletide
         case  3: return "x2_it_spdvscr504"; // 5 Circle_of_Doom
         case  4: return "x2_it_spdvscr505"; // 5 Healing_Circle
         case  5: return "x1_it_spdvscr501"; // 5 Inferno
         case  6: return "x1_it_spdvscr502"; // 5 Owls_Insight
         case  7: return "nw_it_spdvscr501"; // 5 Raise_Dead
         case  8: return "n2_it_spdvscr019"; // 5 Rejuvenation_Cocoon
         case  9: return "n2_it_spdvscr012"; // 5 Righteous_Might
         case 10: return "x2_it_spdvscr506"; // 5 Slay_Living
         case 11: return "x2_it_spdvscr507"; // 5 Spell_Resistance
         case 12: return "x2_it_spdvscr503"; // 5 Vine_Mine
         case 13: return "nx1_it_spdvscr00"; // 5 Call_Lightning_Storm             
         case 14: return "nx1_it_spdvscr01"; // 5 Heal_Animal_Companion            
      }
   } else if (nLvl==6) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: return "x1_it_spdvscr601"; // 6 Banishment
         case  2: return "x2_it_spdvscr603"; // 6 Blade_Barrier
         case  3: return "x1_it_spdvscr605"; // 6 Create_Undead
         case  4: return "x2_it_spdvscr601"; // 6 Crumble
         case  5: return "x1_it_spdvscr604"; // 6 Drown
         case  6: return "x2_it_spdvscr604"; // 6 Harm
         case  7: return "x2_it_spdvscr605"; // 6 Heal
         case  8: return "n2_it_spdvscr002"; // 6 Mass_Cure_Moderate_Wounds
         case  9: return "n2_it_spdvscr010"; // 6 Mass_Inflict_Moderate_Wounds
         case 10: return "x1_it_spdvscr603"; // 6 Planar_Ally
         case 11: return "x2_it_spdvscr602"; // 6 Stonehold
         case 12: return "n2_it_spdvscr022"; // 6 Tortoise_Shell
         case 13: return "nx1_it_spdvscr03"; // 6 Vigorous_Cycle                   
         case 14: return "nx1_it_spdvscr04"; // 6 Extract_Water_Elemental          
         case 15: return "nx1_it_spdvscr02"; // 6 Mass_Owl_Wisdom                  
      }
   } else if (nLvl==7) {
      nRandom = Random(13) + 1;
      switch (nRandom) {
         case  1: return "x1_it_spdvscr701"; // 7 Aura_of_Vitality
         case  2: return "x1_it_spdvscr702"; // 7 Creeping_Doom
         case  3: return "x1_it_spdvscr703"; // 7 Destruction
         case  4: return "n2_it_spdvscr007"; // 7 Energy_Immunity
         case  5: return "x1_it_spdvscr704"; // 7 Fire_Storm
         case  6: return "nw_it_spdvscr701"; // 7 Greater_Restoration
         case  7: return "n2_it_spdvscr003"; // 7 Mass_Cure_Serious_Wounds
         case  8: return "n2_it_spdvscr011"; // 7 Mass_Inflict_Serious_Wounds
         case  9: return "x2_it_spdvscr702"; // 7 Regenerate
         case 10: return "nw_it_spdvscr702"; // 7 Resurrection
         case 11: return "x2_it_spdvscr803"; // 7 Sunbeam
         case 12: return "n2_it_spdvscr021"; // 7 Swamp_Lung
         case 13: return "x2_it_spdvscr701"; // 7 Word_of_Faith
      }
   } else if (nLvl==8) {
      nRandom = Random(10) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr804"; // 8 Aura_versus_Alignment
         case  2: return "x1_it_spdvscr803"; // 8 Bombardment
         case  3: return "x1_it_spdvscr804"; // 8 Create_Greater_Undead
         case  4: return "x1_it_spdvscr801"; // 8 Earthquake
         case  5: return "n2_it_spdvscr001"; // 8 Mass_Cure_Critical_Wounds
         case  6: return "x2_it_spdvscr801"; // 8 Mass_Heal
         case  7: return "n2_it_spdvscr009"; // 8 Mass_Inflict_Critical_Wounds
         case  8: return "n2_it_spdvscr020"; // 8 Storm_Avatar
         case  9: return "x1_it_spdvscr802"; // 8 Sunburst
         case 10: return "nx1_it_spdvscr02"; // 8 Mass_Death_Ward                  
      }
   } else if (nLvl==9) {
      nRandom = Random(7) + 1;
      switch (nRandom) {
         case  1: return "x2_it_spdvscr901"; // 9 Elemental_Swarm
         case  2: return "x2_it_spdvscr902"; // 9 Implosion
         case  3: return "n2_it_spdvscr018"; // 9 Nature_Avatar
         case  4: return "x2_it_spdvscr903"; // 9 Storm_of_Vengeance
         case  5: return "x1_it_spdvscr901"; // 9 Undeaths_Eternal_Foe
         case  6: return "nx1_it_spdvscr02"; // 9 Mass_Drown                       
         case  7: return "nx1_it_spdvscr01"; // 9 Greater_Visage_Of_The_Diety      
      }
   }
   return "nw_it_sparscr001";
}

object SCTreas_CreateRandomPotion(object oTarget, int nStack = 0) {
   string sPotion = "";
   int nRandom = Random(59) + 1;
   if (!nStack) nStack = 4+d6(); // IF NO QUANTITY SENT, CREATE BETWEEN 5-10
   switch (nRandom) {
      case  1: sPotion = "nw_it_mpotion001"; break;     case 26: sPotion = "ptn_displace";     break;
      case  2: sPotion = "nw_it_mpotion020"; break;     case 27: sPotion = "ptn_enlarge";      break;
      case  3: sPotion = "nw_it_mpotion009"; break;     case 28: sPotion = "ptn_earthprt";     break;
      case  4: sPotion = "x2_it_mpotion001"; break;     case 29: sPotion = "ptn_eavesdrop";    break;
      case  5: sPotion = "nw_it_mpotion002"; break;     case 30: sPotion = "ptn_flametwin";    break;
      case  6: sPotion = "nw_it_mpotion005"; break;     case 31: sPotion = "ptn_superhero";    break;
      case  7: sPotion = "nw_it_mpotion007"; break;     case 32: sPotion = "ptn_herocha";      break;
      case  8: sPotion = "nw_it_mpotion008"; break;     case 33: sPotion = "ptn_herocon";      break;
      case  9: sPotion = "nw_it_mpotion010"; break;     case 34: sPotion = "ptn_herodex";      break;
      case 10: sPotion = "nw_it_mpotion011"; break;     case 35: sPotion = "ptn_heroint";      break;
      case 11: sPotion = "nw_it_mpotion013"; break;     case 36: sPotion = "ptn_heroism";      break;
      case 12: sPotion = "nw_it_mpotion014"; break;     case 37: sPotion = "ptn_herostr";      break;
      case 13: sPotion = "nw_it_mpotion015"; break;     case 38: sPotion = "ptn_herowis";      break;
      case 14: sPotion = "nw_it_mpotion016"; break;     case 39: sPotion = "ptn_majelres";     break;
      case 15: sPotion = "nw_it_mpotion017"; break;     case 40: sPotion = "ptn_minelres";     break;
      case 16: sPotion = "nw_it_mpotion018"; break;     case 41: sPotion = "ptn_mystabs";      break;
      case 17: sPotion = "nw_it_mpotion019"; break;     case 42: sPotion = "ptn_mystprot";     break;
      case 18: sPotion = "x2_it_mpotion002"; break;     case 43: sPotion = "ptn_sunbody";      break;
      case 19: sPotion = "nw_it_mpotion003"; break;     case 44: sPotion = "ptn_rallycry";     break;
      case 20: sPotion = "nw_it_mpotion004"; break;     case 45: sPotion = "ptn_hero";         break;
      case 21: sPotion = "nw_it_mpotion006"; break;     case 46: sPotion = "ptn_shielding";    break;
      case 22: sPotion = "nw_it_mpotion012"; break;     case 47: sPotion = "x2_it_mpotion002"; break;
      case 23: sPotion = "ptn_burnretort";   break;     case 48: sPotion = "ptn_superhero";    break;
      case 24: sPotion = "ptn_clairvoy";     break;     case 49: sPotion = "ptn_traploc";      break;
      case 25: sPotion = "ptn_command";      break;     case 50: sPotion = "ptn_unfettered";   break;
      case 51: sPotion = "ptn_deathward";    break;
      case 52: sPotion = "nx1_it_mpotion001";    break;
      case 53: sPotion = "nx1_it_mpotion004";    break;
      case 54: sPotion = "nx1_it_mpotion010";    break;
      case 55: sPotion = "nx1_it_mpotion011";    break;
      case 56: sPotion = "nx1_it_mpotion041";    break;
      case 57: sPotion = CSLPickOne("poison_101", "poison_107", "poison_119", "poison_125"); break;
      case 58: sPotion = CSLPickOne("poison_137", "poison_143", "poison_155", "poison_161"); break;
      case 59: sPotion = CSLPickOne("poison_173", "poison_179", "poison_191", "poison_197"); break;
   }
   return CreateItemOnObject(sPotion, oTarget, nStack);
}

int SCTreas_PickScrollLevel(int iHD = 1) {
   if (iHD< 3) return Random(3) + 1;
   if (iHD< 6) return Random(3) + 2;
   if (iHD< 9) return Random(3) + 3;
   if (iHD<12) return Random(3) + 4;
   if (iHD<15) return Random(3) + 5;
   if (iHD<18) return Random(3) + 6;
   return Random(3) + 7;
}

int SCTreas_TurnGoldIntoGems(object oObject, int nGold, int nGemValue, string sRef) {
   int nGemCount = nGold / nGemValue;
   nGemCount = CSLGetMin(10, CSLRandomUpperHalf(nGemCount)); // Max of 0 - 10
   if (nGemCount && d3()==1) { // 33% CHANCE OF ACTUALLY MAKING A GEM WITH THIS VALUE, FOR A MORE RANDOM DISTRIBUTION
      CreateItemOnObject(sRef, oObject, nGemCount);
      nGold = nGold - (nGemCount * nGemValue);
   }
   return nGold;
}

void SCTreas_CreateGems(object oObject, int nGold) {
   if (nGold > 30000 && Random(1000)==1) {
      string sIon = CSLPickOne("x2_is_sandblue", "x2_is_blue", "x2_is_deepred", "x2_is_drose", "x2_is_paleblue", "x2_is_pink", "x2_is_pandgreen");
      CreateItemOnObject(sIon, oObject);
      nGold = nGold - 30000;
   }
   if (nGold>=10000) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold, 10000, "gem_10000");    // Dragons Eye
   if (nGold>= 5000) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  5000, "cft_gem_13");   // Rogue Stone
   if (nGold>= 4500) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  4500, "cft_gem_12");   // Blue Diamond
   if (nGold>= 4000) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  4000, "cft_gem_15");   // King's Tear
   if (nGold>= 3600) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  3600, "cft_gem_10");   // Star Sapphire
   if (nGold>= 3050) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  3050, "cft_gem_14");   // Beljuril
   if (nGold>= 3000) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  3000, "cft_gem_09");   // Canary Diamond
   if (nGold>= 1750) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  1750, "cft_gem_11");   // Jacinth
   if (nGold>= 1000) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,  1000, "nw_it_gem005"); // Diamond
   if (nGold>=  900) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   900, "nw_it_gem008"); // Sapphire
   if (nGold>=  850) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   850, "nw_it_gem012"); // Emerald
   if (nGold>=  750) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   750, "nw_it_gem009"); // Fire Opal
   if (nGold>=  675) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   675, "nw_it_gem006"); // Ruby
   if (nGold>=  600) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   600, "nw_it_gem010"); // Topaz
   if (nGold>=  500) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   500, "nw_it_gem013"); // Alexandrite
   if (nGold>=  300) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   300, "nw_it_gem011"); // Garnet
   if (nGold>=  200) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   200, "nw_it_gem001"); // Greenstone
   if (nGold>=  150) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   150, "nw_it_gem004"); // Phenalope
   if (nGold>=  125) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   125, "nw_it_gem014"); // Aventurine
   if (nGold>=  100) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,   100, "nw_it_gem003"); // Amethsyt
   if (nGold>=   50) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,    50, "nw_it_gem002"); // Fire Agate
   if (nGold>=   40) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,    40, "cft_gem_01");   // Bloodstone
   if (nGold>=   20) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,    20, "nw_it_gem015"); // Fluorspar
   if (nGold>=   15) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,    15, "cft_gem_03");   // Obsidian
   if (nGold>=   10) nGold = SCTreas_TurnGoldIntoGems(oObject, nGold,    10, "nw_it_gem007"); // Malachite

}

object SCTreas_CreateArcaneScroll(object oTarget, int iHD = 1) {
   return CreateItemOnObject(SCTreas_PickArcaneScroll(SCTreas_PickScrollLevel(iHD)), oTarget, d4());
}

object SCTreas_CreateDivineScroll(object oTarget, int iHD = 1) {
   return CreateItemOnObject(SCTreas_PickDivineScroll(SCTreas_PickScrollLevel(iHD)), oTarget, d4());
}

object SCTreas_CreateRandomScroll(object oTarget, int iHD = 1) {
   if (d2()==1) return SCTreas_CreateArcaneScroll(oTarget, iHD);
   return SCTreas_CreateDivineScroll(oTarget, iHD);
}



object SCTreas_CreateGoldPile(int nGold, string sWayPoint, string sResRef = "pile_of_gold") {
   location lWP = GetLocation(GetObjectByTag(sWayPoint));
   object oGold = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lWP);
   SetFirstName(oGold, "<color=yellow>" + GetName(oGold) + "</color> <color=green>" + IntToString(nGold) + "</color>");
   SetLocalInt(oGold, "GOLD", nGold);
   return oGold;
}