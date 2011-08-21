#include "_CSLCore_Reputation"
#include "_SCInclude_Encounter"
#include "_SCInclude_Treasure" 
#include "_SCInclude_MagicStone"
#include "_SCInclude_UnlimitedAmmo"
#include "_SCInclude_RandomMonster"
//#include "_SCInclude_AI"
//#include "_SCInclude_AI_Advanced"

void SetSpawnIn(object oMinion, int nCondition, int bValid = TRUE)
{
    int nCurrentCond = GetLocalInt(oMinion, "NW_GENERIC_MASTER");
    if (bValid) SetLocalInt(oMinion, "NW_GENERIC_MASTER",  nCurrentCond | nCondition);
    else SetLocalInt(oMinion, "NW_GENERIC_MASTER", nCurrentCond & ~nCondition);
}

void SetCombatIn(object oMinion, int nCond, int bValid=TRUE) {
    int nCurrentCond = GetLocalInt(oMinion, "X0_COMBAT_CONDITION");
    if (bValid) SetLocalInt(oMinion, "X0_COMBAT_CONDITION", nCurrentCond | nCond);
    else SetLocalInt(oMinion, "X0_COMBAT_CONDITION", nCurrentCond & ~nCond);
}
 
void VolcanoErupt(object oMinion, object oPC) {
   AssignCommand(oMinion, ActionCastSpellAtLocation(SPELL_METEOR_SWARM, GetLocation(oMinion), METAMAGIC_ANY, TRUE));
   AssignCommand(oMinion, ActionAttack(oPC, TRUE));
}

void WalkCity(object oMinion, string sWP, int nNext) {
   if (oMinion==OBJECT_INVALID || GetIsDead(oMinion)) return;
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oMinion);
   if (oPC==OBJECT_INVALID || GetIsInCombat(oMinion)) { // NO ONE HERE OR FIGHTING, DO NOTHING CHECK LATER
      DelayCommand(90.0, WalkCity(oMinion, sWP, nNext));
      return; // DO NOTHING FOR NOW
   }   
   oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oMinion, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);   
   if (oPC!=OBJECT_INVALID) {
      SetActionMode(oMinion, ACTION_MODE_STEALTH, TRUE);
      DelayCommand(30.0, WalkCity(oMinion, sWP, nNext));
      AssignCommand(oMinion, ClearAllActions());
      AssignCommand(oMinion, ActionMoveToObject(oPC, FALSE, 20.0));
      AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1, DAMAGE_TYPE_MAGICAL), oMinion));
      //AssignCommand(oMinion, DetermineCombatRound(oPC));
      return;
   }
   SetActionMode(oMinion, ACTION_MODE_STEALTH, FALSE);
   nNext++;
   if (nNext==5) nNext = 1; // RESTART
   string sWPTag = "WP_" + sWP + "_0" + IntToString(nNext);
   object oLocator = GetObjectByTag(sWPTag);
   AssignCommand(oMinion, ClearAllActions());   
   AssignCommand(oMinion, ActionMoveToObject(oLocator, TRUE, 5.0));
   AssignCommand(GetModule(), DelayCommand(30.0, WalkCity(oMinion, sWP, nNext)));
} 
 
void MakeRandomDrow(object oPC, string sWhich, int bWalkCity = TRUE) {
   int i;
   object oLocator; 
   object oMinion;
   object oItem;  
   string sWP;   
   int nLvl = CSLGetMax(25, GetHitDice(oPC));
   sWP = "WP_" + sWhich + "_0" + IntToString(d4());
   oLocator = GetObjectByTag(sWP);
   if ( d100() <= 5 )
   {
      string sDrow = CSLPickOne("drowmatron", "drowfirstdaughter", "drowfirstboy", "drowsecondboy", "drowthirdboy");
      oMinion = SpawnBoss(sDrow, oLocator);
      if (d10()==1) StoneCreate(oMinion, "stone_ac", "Link of Protection", "SMS_AC");
      else if (d20()==1) StoneCreate(oMinion, "stone_ability", "Tome of Power", "SMS_ABILITY");
      else if (d20()==1) {
         sDrow = "ula_sling_" + CSLPickOne("adam", "silver");
         oItem = CreateItemOnObject(sDrow, oMinion);
         SetFirstName(oItem, "Death Flinger");
         if (d4()==1) SCUnlimAmmo_AllowMagical(oItem);
         if (d4()==1) SCUnlimAmmo_AllowDivine(oItem);
         if (d4()==1) SCUnlimAmmo_AllowPositive(oItem);
         if (d4()==1) SCUnlimAmmo_AllowAcid(oItem);
         if (d4()==1) SCUnlimAmmo_AllowNegative(oItem);
         if (d4()==1) SCUnlimAmmo_AllowSonic(oItem);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(4), oItem);
      }
   } else {
      string sOrder = CSLPickOne("rm_str", "rm_dex", "rm_con", "rm_wis", "rm_int", "rm_cha");
      sOrder = CSLPickOne("rm_str", "rm_dex", "rm_con", sOrder);
      //int nDrowLvl = nLvl + Random(3);
      oMinion = GetRandomMonster(oLocator, "PCDROW", nLvl, "1=1", sOrder, "", "drownoblewear"); // 
      SetLastName(oMinion, "Imphraezl"); 
      FeatAdd(oMinion, 1075, FALSE);
      if (GetGender(oMinion)==GENDER_MALE) {
         SetSoundSet(oMinion, CSLPickOneInt(363, 364, 365, 366, 465, 466, 467, 468, 469));
      } else {
         SetSoundSet(oMinion, CSLPickOneInt(357, 358, 359, 360, 361, 433, 460, 462, 463, 464));      
      }
   }
   SetSpawnIn(oMinion, CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
   SetSpawnIn(oMinion, CSL_FLAG_AMBIENT_ANIMATIONS);        
   if (d2()==1) SetSpawnIn(oMinion, CSL_FLAG_STEALTH);
   if (d2()==1) SetCombatIn(oMinion, CSL_COMBAT_FLAG_AMBUSHER);
   if (bWalkCity) WalkCity(oMinion, sWhich, 4); 
   SCTreas_CreateGems(oMinion, GoldValue(oMinion)/3);
   SCTreas_CreateRandomPotion(oMinion, 1);
   if (d20()==1) {
      sWhich = CSLPickOne("MAGICAL", "DIVINE", "POSITIVE", "NEGATIVE"); // PICK A RARE ONE
      sWhich = CSLPickOne("BLUDGEONING", "PIERCING", "SLASHING", "SONIC", sWhich); // PICK A RARE ONE
      sWhich = CSLPickOne("ACID", "ELECTRICAL", "FIRE", "COLD", sWhich); // THEN GIVE SMALL CHANCE OF ACTUALLY DROPPING IT
      StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sWhich) + " Damage", "SMS_DAMAGE_" + sWhich);
   }
}
 
//Hatred tries to emulate what Seed did for Drow for Dwarves here
void MakeRandomDwarf(object oPC, string sWhich, int bWalkCity = TRUE)
{
   object oLocator; 
   object oMinion;
   string sWP;   
   int nLvl = CSLGetMax(25, GetHitDice(oPC));
   sWP = "WP_" + sWhich + "_0" + IntToString(d4());//determines which path of WP it will spawn on?
   oLocator = GetObjectByTag(sWP);
   string sDwarf = CSLPickOne("DWARFCLANLB", "DWARFCLANIA", "DWARVENCOMMANDERB", "DWARVENCOMMANDERC");
   oMinion = SpawnBoss(sDwarf, oLocator);
   if (d20()==1) StoneCreate(oMinion, "stone_ac", "Link of Protection", "SMS_AC");
   else if (d20()==20) StoneCreate(oMinion, "stone_ability", "Tome of Power", "SMS_ABILITY");
   SCTreas_CreateGems(oMinion, GoldValue(oMinion)/2);
   SCTreas_CreateRandomPotion(oMinion, 1);
   if (d20()==10)
   {
      sWhich = CSLPickOne("MAGICAL", "DIVINE", "POSITIVE", "NEGATIVE"); // PICK A RARE ONE
      sWhich = CSLPickOne("BLUDGEONING", "PIERCING", "SLASHING", "SONIC", sWhich); // PICK A RARE ONE
      sWhich = CSLPickOne("ACID", "ELECTRICAL", "FIRE", "COLD", sWhich); // THEN GIVE SMALL CHANCE OF ACTUALLY DROPPING IT
      StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sWhich) + " Damage", "SMS_DAMAGE_" + sWhich);
   }
}   


void main()
{
   object oEnc = OBJECT_SELF;

   object oPC=GetEnteringObject();
   string sWhich=GetTag(oEnc);
   int i, j, k;

   if (!GetEncounterActive(oEnc)) return; // NOT CURRENTLY ACTIVE
   if (GetSpawnState(oEnc)!=SPAWN_STATE_READY) return; // ENCOUNTER IS NOT READY TO RESPAWN YET
   object oMinion;
   object oLocator;
   object oItem;
   itemproperty ipAdd;
   location lSpawn;
   effect eEffect;
   float l;
   string sRef;
   int PartyCnt;
   int nGoldValue;

//****************   GRAVEYARD ZOMBIE LIGHTNING EFFECT FOR FUN
   if (sWhich=="ENC_GRAVEYARD_LIGHTNING") {
      ResetSpawnState(oEnc, 120.0); // THIS ONE CAN REFIRE WITHOUT 15 minute DELAY
      for (i=0;i<4;i++) { // oMinion = Previous Zombie, oLocator = Current Zombie, oItem = First Zombie
         oLocator = GetObjectByTag("GRAVEYARD_COFFIN", i);
         if (GetHasInventory(oLocator)) SCTreas_CreateGems(oLocator, 150);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oLocator));
         oLocator = GetNearestObjectByTag("zombie_weak2", oLocator);
         if (d4()==1) SCTreas_CreateGems(oLocator, 150);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), GetLocation(oLocator));
         if (i==0) {
            oItem = oLocator; // SAVE THE FIRST ONE TO CONNECT TO THE LAST ONE OUTSIDE OF LOOP
         } else { // NOT THE FIRST ONE CAUSE THERE IS NO ONE TO CONNECT HIM TO YET
            eEffect = EffectBeam(VFX_BEAM_NECROMANCY, oMinion, BODY_NODE_CHEST); //VFX_BEAM_SHOCKING_GRASP
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oLocator, 1.5);
         }
         oMinion = oLocator;
      }
      eEffect = EffectBeam(VFX_BEAM_NECROMANCY, oMinion, BODY_NODE_HAND);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oItem, 1.0); // LAST ONE HITS THE FIRST ONE

//***** GOBLINS
   } else if (sWhich=="ENC_GOBLIN_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 5)) return;
      oLocator = GetObjectByTag("WP_GOBLIN_BOSS");
      oMinion = SpawnBoss("stonehead", oLocator);
      nGoldValue = GoldValue(oMinion);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_STONEHEAD");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGETYPE_POSITIVE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      SetFirstName(oItem, "Stonehead's Axe");
      oLocator = GetObjectByTag("GOBLIN_BOSS_CHEST");
      SCTreas_CreateGems(oLocator, nGoldValue);
      for (j=0;j<2;j++) SCTreas_CreateRandomPotion(oLocator, 1);

// ***** KOBOLDS
   } else if (sWhich=="ENC_KOBOLD_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 6)) return;
      if (d2()==1) oLocator = GetObjectByTag("WP_koboldking_0" + IntToString(1 + d4()));
      else oLocator = GetObjectByTag("WP_koboldking_01");
      oMinion = SpawnBoss("koboldking", oLocator, TRUE);
      nGoldValue = GoldValue(oMinion);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_KOBOLD");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGETYPE_BLUDGEONING), IP_CONST_DAMAGEBONUS_1d4), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      SCTreas_CreateGems(oMinion, nGoldValue/2);
      oLocator = GetObjectByTag("CHEST_KOBOLD_KING");
      SCTreas_CreateGems(oLocator, nGoldValue/2);
      oLocator = GetObjectByTag("LOCKBOX_KOBOLD_KING");
      SCTreas_CreateGems(oLocator, nGoldValue/2);
      CreateItemOnObject("gem_tunnelborer", oLocator);

// ***** SAURIA
   } else if (sWhich=="ENC_SAURIA_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 7)) return;
      oLocator = GetObjectByTag("WP_SAURIA_BOSS");
      oMinion = SpawnBoss("axolotl", oLocator);
      nGoldValue = GoldValue(oMinion);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_AXOLOTL");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGETYPE_ACID), IP_CONST_DAMAGEBONUS_1d6), oItem);
      SetFirstName(oItem, "Axolotl's Falchion");
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_SAURIA_BOSS", i);
         SCTreas_CreateGems(oLocator, nGoldValue/2);
         SCTreas_CreateRandomScroll(oLocator, 8);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
      }

   } else if (sWhich=="ENC_QUAGKEEP_JAIL") { // FILL THE JAIL
      if (!CheckRandomSpawn(3, oPC)) return;
      for (i=0;i<3;i++) {
         oLocator = GetObjectByTag("DOOR_QUAGKEEP_JAIL", i);
         AssignCommand(oLocator, ActionCloseDoor(oLocator));
         SetLocked(oLocator, TRUE);
         oLocator = GetObjectByTag("WP_QUAGKEEP_JAIL", i);
         oMinion = MakeCreature(CSLPickOne("goblin_scout01", "goblin_soldier03", "ogre_club"), oLocator, FALSE);
         CSLDestroyInventory(oMinion);
      }

// ***** ORC MINES
   } else if (sWhich=="ENC_ORC_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 8)) return;
      oLocator = GetObjectByTag("WP_ORC_BOSS");
      oMinion = SpawnBoss("pigfoot", oLocator);
      nGoldValue = GoldValue(oMinion);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTRING, "RING_PIGFOOT"); // THIS ITEM CANNOT BE MODIFIED BY A CRAFTER
      SetFirstName(oItem, "Ring of Pigfoot");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE), oItem);
      SetItemCharges(oItem, 50);

      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "STONECLEAVER");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6), oItem);
      SetFirstName(oItem, "The Stone Cleaver");
      SetDescription(oItem, "This hammer has the power to cleave any stone in two.");

      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_ORC_BOSS", i);
         SCTreas_CreateGems(oLocator, nGoldValue/2);
         SCTreas_CreateRandomScroll(oLocator, 8);
         SCTreas_CreateRandomScroll(oLocator, 8);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
      }

// ***** DRUID HOLLOW
   } else if (sWhich=="ENC_DRYAD_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 9)) return;
      oLocator = GetObjectByTag("WP_uisgebeatha_01");
      oMinion = SpawnBoss("uisgebeatha", oLocator, TRUE);
      nGoldValue = GoldValue(oMinion);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_DRYAD");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oItem);
      SCTreas_CreateGems(oMinion, nGoldValue/2);
      oLocator = GetObjectByTag("ALTAR_DRYAD");
      SCTreas_CreateGems(oLocator, nGoldValue/2);

   } else if (sWhich=="ENC_TRENCHSPIDER_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 9)) return;
      oLocator = GetObjectByTag("WP_boris_0" + IntToString(d2()));
      oMinion = SpawnBoss("boris", oLocator, TRUE);
      CreateItemOnObject("gem_spiderskin", oMinion);
      nGoldValue = GoldValue(oMinion);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      SCTreas_CreateGems(oMinion, nGoldValue/2);
      oLocator = GetObjectByTag("BORIS_CORPSE");
      SCTreas_CreateGems(oLocator, nGoldValue/2);

   } else if (sWhich=="ENC_DRUID_CIRCLE") {
      if (!CheckRandomSpawn(3, oPC, 9)) return;
      oLocator = GetNearestObjectByTag("DRUID_CIRCLE");
      CreateObject(OBJECT_TYPE_ITEM, "ptn_earthprt", GetLocation(oLocator));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oLocator));

// ***** OGRE CAVES
   } else if (sWhich=="ENC_OGRE_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 9)) return;
      oLocator = GetObjectByTag("WP_OGRE_BOSS");
      oMinion = SpawnBoss("mudlark", oLocator);
      nGoldValue = GoldValue(oMinion);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTRING, "NOCRAFT_MUDLARK"); // THIS ITEM CANNOT BE MODIFIED BY A CRAFTER
      SetFirstName(oItem, "Ring of Mudlark");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_STONESKIN_7, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE), oItem);
      SetItemCharges(oItem, 50);
      oItem = SCTreas_CreateGoldPile(nGoldValue/2, "WP_OGRE_GOLD", "pile_of_gold");
      oLocator = GetObjectByTag("OGRE_GEM_PILE");
      SCTreas_CreateGems(oLocator, nGoldValue/2);
      oLocator = GetObjectByTag("OGRE_THRONE");
      SCTreas_CreateRandomScroll(oLocator, 10);
      SCTreas_CreateGems(oLocator, nGoldValue/2);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);

// ***** CRYPT TREASURE SPAWNS
   } else if (sWhich=="ENC_CRYPT1_COFFIN") {
      ResetSpawnState(oEnc, 180.0); // THIS ONE CAN FIRE EVERY 3 MINUTES
      for (i=0;i<=1;i++) {
         oLocator = GetObjectByTag("CRYPT1_COFFIN", i);
         SCTreas_CreateGems(oLocator, 150);
         if (d4()==1) SCTreas_CreateRandomScroll(oLocator, 4);
         if (d4()==1) SCTreas_CreateRandomPotion(oLocator, 1);
      }
   } else if (sWhich=="ENC_CRYPT2_COFFIN") {
      ResetSpawnState(oEnc, 180.0); // THIS ONE CAN FIRE EVERY 3 MINUTES
      for (i=0;i<=1;i++) {
         oLocator = GetObjectByTag("CRYPT2_COFFIN", i);
         SCTreas_CreateGems(oLocator, 200);
         if (d4()==1) SCTreas_CreateRandomScroll(oLocator, 5);
         if (d4()==1) SCTreas_CreateRandomPotion(oLocator, 1);
      }
   } else if (sWhich=="ENC_CRYPT3_COFFIN") {
      ResetSpawnState(oEnc, 180.0); // THIS ONE CAN FIRE EVERY 3 MINUTES
      for (i=0;i<=1;i++) {
         oLocator = GetObjectByTag("CRYPT3_COFFIN", i);
         SCTreas_CreateGems(oLocator, 250);
         if (d4()==1) SCTreas_CreateRandomScroll(oLocator, 6);
         if (d4()==1) SCTreas_CreateRandomPotion(oLocator, 1);
      }
      if (d3()==1) CreateItemOnObject("foldingboat", oLocator);

// ***** CRYPT 4 MUNTI
   } else if (sWhich=="ENC_CRYPT4_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 10)) return;
      oLocator = GetObjectByTag("WP_CRYPT4_BOSS");
      oMinion = SpawnBoss("munti", oLocator);
      nGoldValue = GoldValue(oMinion);
      for (i=1;i<=3;i++) SCTreas_CreateArcaneScroll(oMinion, 11); // GIVE 3 RANDOM SCROLLS
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTRING, "NOCRAFT_MUNTI"); // THIS ITEM CANNOT BE MODIFIED BY A CRAFTER
      SetFirstName(oItem, "Ring of Munti");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_UNDEAD_11, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE), oItem);
      SetItemCharges(oItem, 50);
      for (i=0;i<3;i++) {
         oLocator = GetObjectByTag("CHEST_CRYPT4_BOSS", i);
         SCTreas_CreateRandomScroll(oLocator, 10);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/3);
      }

// ***** SMUGGLER STRONGHOLD
   } else if (sWhich=="ENC_SMUGGLER_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 10)) return;
      oLocator = GetObjectByTag("WP_SMUGGLER_BOSS");
      oMinion = SpawnBoss("gnash", oLocator);

      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(CSLPickOneInt(IP_CONST_ONHIT_BLINDNESS, IP_CONST_ONHIT_FEAR, IP_CONST_ONHIT_SLOW), IP_CONST_ONHIT_SAVEDC_14), oItem);

     nGoldValue = GoldValue(oMinion);
      for (i=1;i<=3;i++) SCTreas_CreateArcaneScroll(oMinion, 11); // GIVE 3 RANDOM SCROLLS
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTRING, "NOCRAFT_GNASH"); // THIS ITEM CANNOT BE MODIFIED BY A CRAFTER
      SetFirstName(oItem, "Ring of Gnash");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE), oItem);
      SetItemCharges(oItem, 50);

      oItem = StoneCreate(oMinion, "stone_ammo", "String of the Elements", "SMS_AMMO");

      oItem = SCTreas_CreateGoldPile(nGoldValue/2, "WP_SMUGGLER_GOLD", "stack_of_gold");
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_SMUGGLER_BOSS", i);
         SCTreas_CreateRandomScroll(oLocator, 11);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/4);
      }

// ***** GNOLL CAVE
   } else if (sWhich=="ENC_GNOLL_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 13)) return;
      oLocator = GetObjectByTag("WP_GNOLL_BOSS");
      oMinion = SpawnBoss("anathema", oLocator);
      StoneCreate(oMinion, "stone_mighty", "Magic Cat Gut", "SMS_MIGHTY");
      nGoldValue = GoldValue(oMinion);
      for (i=1;i<=3;i++) SCTreas_CreateArcaneScroll(oMinion, 13); // GIVE 3 RANDOM SCROLLS
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_GNOLL_BOSS", i);
         if (d2()==1) SCTreas_CreateRandomScroll(oLocator, 13);
         if (d2()==1) for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/2);
      }

// ***** TROLL CAVE
   } else if (sWhich=="ENC_TROLL_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 14)) return;
      oLocator = GetObjectByTag("WP_TROLL_BOSS");
      oMinion = SpawnBoss("regalia", oLocator);
      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(CSLPickOneInt(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_CONFUSION), IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_10_PERCENT_2_ROUNDS), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_2d4), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d4), oItem);
      nGoldValue = GoldValue(oMinion);
      oItem = StoneCreate(oMinion, "stone_regen", "Troll Teeth", "SMS_REGEN");
      oItem = SCTreas_CreateGoldPile(nGoldValue/2, "WP_TROLL_GOLD", "pile_of_gold");
      //CreateItem("nw_it_gold001", oLocator, RandomUpperHalf(nGoldValue/2));
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_TROLL_BOSS", i);
         SCTreas_CreateRandomScroll(oLocator, 14);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/4);
      }

// ***** LUNKER CAVE
   } else if (sWhich=="ENC_VODYANOI_BOSS") {
      oLocator = GetObjectByTag("WP_VODYANOI_GOLD3");
      oMinion = SpawnBoss("lunker", oLocator);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_LUNKER");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_FEAR, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_10_PERCENT_2_ROUNDS), oItem);
      CreateItemOnObject("aquastone", oMinion);
      CreateItemOnObject("aquastone", oMinion);
      CreateItemOnObject("aquastone", oMinion);
      CreateItemOnObject("aquastone", oMinion);
      CreateItemOnObject("aquastone", oMinion);
      nGoldValue = GoldValue(oMinion)/3;
      SCTreas_CreateGems(oMinion, nGoldValue);
      for (i=0;i<4;i++) {
         oItem = SCTreas_CreateGoldPile( CSLRandomUpperHalf(nGoldValue), "WP_VODYANOI_GOLD" + IntToString(i), CSLPickOne("bag_of_gold", "pile_of_treasure", "pile_of_gold"));
      }

// ***** DRAKKEN MANOR
   } else if (sWhich=="ENC_DRAKKEN_IGOR") {
      if (!CheckRandomSpawn(3, oPC, 15)) return;
      oLocator = GetObjectByTag("WP_DRAKKEN_IGOR");
      oMinion = SpawnBoss("igor", oLocator);
      oLocator = GetObjectByTag("DRAKKEN_BOSS_THRONE");
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oLocator, nGoldValue);

   } else if (sWhich=="ENC_DRAKKEN_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 15)) return;
      int nDrop = d2();
      oLocator = GetObjectByTag("WP_DRAKKEN_BOSS", 0);
      oMinion = SpawnBoss("avaleuses", oLocator);
      nGoldValue = GoldValue(oMinion);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(90), oMinion, 60.0);
      if (nDrop==1) {
         oItem = CreateItemOnObject("ula_heavyxbow_silver", oMinion);
         SetFirstName(oItem, "Avaleuses' Kiss");
         SCUnlimAmmo_AllowAcid(oItem);
         SCUnlimAmmo_AllowNegative(oItem);
         if (d4()==1) SCUnlimAmmo_AllowPiercing(oItem);
         if (d4()==1) SCUnlimAmmo_AllowSonic(oItem);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(3), oItem);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMaxRangeStrengthMod(3), oItem);
      }
      oLocator = GetObjectByTag("WP_DRAKKEN_BOSS", 1);
      oMinion = SpawnBoss("netopyr", oLocator);
      oItem = StoneCreate(oMinion, "stone_vampregen", "Fang of Netopyr", "SMS_VAMPREGEN");
      if (nDrop==2) {
         oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_NETOPYR");
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6), oItem);
      }
      oLocator = GetObjectByTag("DRAKKEN_BOSS_COFFIN", 0);
      SCTreas_CreateGems(oLocator, nGoldValue);
      oLocator = GetObjectByTag("DRAKKEN_BOSS_COFFIN", 1);
      SCTreas_CreateGems(oLocator, nGoldValue);

// ***** SVARTALFHEIM
   } else if (sWhich=="ENC_SVART_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 15)) return;
      oLocator = GetObjectByTag("WP_SVART_BOSS");
      oMinion = SpawnBoss("svartalfar_king", oLocator);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_RUBE");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGETYPE_NEGATIVE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      nGoldValue = GoldValue(oMinion);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      oItem = SCTreas_CreateGoldPile(nGoldValue/2, "WP_SVART_GOLD", "pile_of_gold");
      oLocator = GetObjectByTag("CHEST_SVART_BOSS");
      SCTreas_CreateGems(oLocator, nGoldValue/2);
      oLocator = GetObjectByTag("WP_SVART_MAGE");
      oMinion = MakeCreature("svartalfar_illusion", oLocator, FALSE);
      for (i=0;i<2;i++) SCTreas_CreateArcaneScroll(oMinion, 15);
      oLocator = GetObjectByTag("WP_SVART_MONK");
      oMinion = MakeCreature("svartalfar_monk", oLocator, FALSE);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d4), oItem);
      SetDroppableFlag(oItem, d20()==1);
      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d4), oItem);
      SetDroppableFlag(oItem, d20()==1);

// ***** INDADU
   } else if (sWhich=="ENC_INDADU_PARTY") {
      if (!CheckRandomSpawn(3, oPC, 13)) return;
      oLocator = GetObjectByTag("WP_indadupriest_0" + IntToString(d4()));
      object oLast = MakeCreature("indadupriest", oLocator);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHaste(), oLast);
      SCTreas_CreateGems(oLast, 1000);
      CreateItemOnObject("foldingboat", oLast);
      oMinion = MakeCreature("iriomote", oLocator);
      AssignCommand(oMinion, ActionForceFollowObject(oLast, 1.0));
      oLast = oMinion;
      oMinion = MakeCreature(CSLPickOne("indadufighter","indaduatlatl"), oLocator);
      AssignCommand(oMinion, ActionForceFollowObject(oLast, 1.5));
      oLast = oMinion;
      oMinion = MakeCreature(CSLPickOne("indadufighter","indaduatlatl"), oLocator);
      AssignCommand(oMinion, ActionForceFollowObject(oLast, 1.5));

   } else if (sWhich=="ENC_INDADU_KEY") {
      oLocator = GetObjectByTag("WP_INDADU_KEY");
      oMinion = SpawnBoss("indaduhighpriest", oLocator);
      CreateItemOnObject("indadu_temple_key", oMinion);
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue);
      for (i=1;i<=d2();i++) {
         SCTreas_CreateDivineScroll(oMinion, 13); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateRandomPotion(oMinion, 1);
      }

   } else if (sWhich=="ENC_INDADU_BOSS") {
      oLocator = GetObjectByTag("WP_INDADU_BOSS");
      oMinion = SpawnBoss("gukumatz", oLocator);
      CreateItemOnObject("sealich_tomb_key", oMinion);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_GUKUMATZ");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      oItem = CreateItemOnObject(CSLPickOne("poison_101", "poison_119", "poison_137", "poison_155", "poison_173", "poison_191"), oMinion);      
      for (i=1;i<=d2();i++) {
         SCTreas_CreateDivineScroll(oMinion, 15); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateRandomPotion(oMinion, 1);
      }
      nGoldValue = GoldValue(oMinion)/3;
      oLocator = GetObjectByTag("INDADU_CHEST");
      for (i=1;i<=2;i++) SCTreas_CreateRandomPotion(oLocator, 1);
      SCTreas_CreateGems(oLocator, nGoldValue);
      for (i=0;i<4;i++) {
         oItem = SCTreas_CreateGoldPile(CSLRandomUpperHalf(nGoldValue), "WP_INDADU_GOLD" + IntToString(i), CSLPickOne("bag_of_gold", "pile_of_treasure", "pile_of_gold"));
      }

// ***** SEA LICH TOMB
   } else if (sWhich=="ENC_SEALICH_BOSS") {
      oLocator = GetObjectByTag("WP_SEALICH_BOSS");
      oMinion = SpawnBoss("sealich", oLocator);
      CreateItemOnObject("sealich_skeleton_key", oMinion);
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue);
      for (i=1;i<=d3();i++) {
         SCTreas_CreateArcaneScroll(oMinion, 17); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateRandomPotion(oMinion, 1);
      }
      oLocator = GetObjectByTag("SEALICH_COFFIN");
      SCTreas_CreateGems(oLocator, nGoldValue);
      for (j=0;j<d4();j++) SCTreas_CreateRandomPotion(oLocator, 1);
      if (GetObjectByTag("SEALICH_IDOL")==OBJECT_INVALID) {
         oLocator = GetObjectByTag("WP_SEALICH_IDOL");
         CreateObject(OBJECT_TYPE_PLACEABLE, "sealich_idol", GetLocation(oLocator));
      }

// ***** TROLL CAVE CRYPT
   } else if (sWhich=="ENC_TROLLUNDEAD_BOSS") {
/*
         oLocator = GetNearestObjectByTag("enc_regaliaghast", oPC, d4());
         int iLevel = GetHitDice(oPC);
         string sOrder = PickOne("rm_int", "rm_cha", "rm_wis", "rm_dex");
         oMinion = GetRandomMonster(oLocator, iLevel, "", sOrder);
         SetLastName(oMinion, "-=Mystik=-");
//         if (GetSubRace(oMinion)==RACIAL_SUBTYPE_HUMAN) SetCreatureAppearanceType(oMinion, PickOneInt(0,1,4,5,6));
         SCTreas_CreateGems(oMinion, GoldValue(oMinion)/2);
         SCTreas_CreateRandomPotion(oMinion, 2);
*/

      if (!CheckRandomSpawn(3, oPC, 17)) return;
      oLocator = GetObjectByTag("WP_TROLLUNDEAD_BOSS");
      oMinion = SpawnBoss("miasmas", oLocator);
      StoneCreate(oMinion, "stone_ability", "Tome of Power", "SMS_ABILITY");
      nGoldValue = GoldValue(oMinion);
      for (i=0;i<3;i++) SCTreas_CreateArcaneScroll(oMinion, 17);
      // JUICE UP HIS STAFF
      oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_FEAR, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_10_PERCENT_2_ROUNDS), oItem);
      // SOME PRETTY VISUALS AND BOOSTS FOR NEARBY BUDDIES
      AssignCommand(oMinion, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oMinion));
      effect eShield = EffectDamageShield(8, DAMAGE_BONUS_2d4, DAMAGE_TYPE_NEGATIVE);
      eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_DEATH_ARMOR));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oMinion, 180.0); // SHIELD FOR BOSS
      effect eBeam = EffectBeam(VFX_BEAM_NECROMANCY, oMinion, BODY_NODE_CHEST);
      for (i=0;i<4;i++) {
         oMinion = GetNearestObjectByTag("regaliaghast", oLocator, i);
         if (oMinion!=OBJECT_INVALID) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oMinion, 5.0);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), GetLocation(oMinion));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oMinion, 180.0); // SHIELD FOR MINION
            SCTreas_CreateGems(oMinion, nGoldValue/6);
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_2d4), oItem);
         }
      }
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("CHEST_TROLLUNDEAD_BOSS", i);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/4);
      }

// ***** MOONMOORE
   } else if (sWhich=="ENC_FIREGIANT_VOLCANO") {
      ResetSpawnState(oEnc, 600.0); // THIS ONE CAN FIRE EVERY 10 MINUTES
      oLocator = GetObjectByTag("WP_VOLCANO_ERUPT");
      oMinion = MakeCreature("firegiantvolcanist", oLocator, FALSE);
      CreateItemOnObject("nw_it_gem009", oMinion, 2);
      SCTreas_CreateDivineScroll(oMinion, 16);
      SCTreas_CreateRandomPotion(oMinion, 1);
      AssignCommand(oMinion, DelayCommand(1.0f, VolcanoErupt(oMinion, oPC)));

   } else if (sWhich=="ENC_FIREGIANTHERSIR") { //  WANDERING VOLCANISTS
      if (GetObjectByTag("firegiantvolcanist", 4)!=OBJECT_INVALID) return; // KEEP IT TO 4 FV'S IN MODULE AT ONCE
      if (!CheckRandomSpawn(3, oPC)) return;
      oLocator = GetObjectByTag("WP_firegiantvolcanist_0" + IntToString(d6()));
      oMinion = MakeCreature("firegiantvolcanist", oLocator, FALSE);
      if (d3()==1) {
         AssignCommand(oMinion, ClearAllActions());
         AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 30.0));
         AssignCommand(oMinion, ActionAttack(oPC));
      }
      AssignCommand(GetModule(), DelayCommand(240.0f, Despawn(OBJECT_SELF)));

// ***** SURT'S CASTLE
   } else if (sWhich=="ENC_FIREGIANT_BOSSWANDER") {
      if (!CheckRandomSpawn(25, oPC, 19)) return;
      oLocator = GetObjectByTag("WP_FIREGIANT_BOSS");
      sWhich = CSLPickOne("surtr","ladysinmore");
      oMinion = SpawnBoss(sWhich, oLocator);
      for (i=0;i<2;i++) SCTreas_CreateDivineScroll(oMinion, 16);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_" + GetStringUpperCase(sWhich));
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGETYPE_POSITIVE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oMinion, 200.0f);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 30.0));
      AssignCommand(oMinion, ActionAttack(oPC));

   } else if (sWhich=="ENC_FIREGIANT_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 19)) return;
      int nDrop = d2();
      oLocator = GetObjectByTag("WP_FIREGIANT_BOSS", 0);
      oMinion = SpawnBoss("ladysinmore", oLocator);
      if (nDrop==1) {
         oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_SINMORE");
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGETYPE_POSITIVE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      }
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 30.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      nGoldValue = GoldValue(oMinion);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      for (i=0;i<2;i++) SCTreas_CreateDivineScroll(oMinion, 16);
      oLocator = GetObjectByTag("FIREGIANT_BOSS_THRONE", 0);
      SCTreas_CreateGems(oLocator, nGoldValue);

      oLocator = GetObjectByTag("WP_FIREGIANT_BOSS", 1);
      oMinion = SpawnBoss("surtr", oLocator);
      oItem = StoneCreate(oMinion, "stone_dr10", "Oil of Toughening", "SMS_DR10");
      if (nDrop==2) {
         oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND, "NOCRAFT_SURT");
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGETYPE_MAGICAL), IP_CONST_DAMAGEBONUS_1d4), oItem);
      }
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 30.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      oLocator = GetObjectByTag("FIREGIANT_BOSS_THRONE", 1);
      SCTreas_CreateGems(oLocator, nGoldValue);


// ***** UMBER HULK CAVE
   } else if (sWhich=="ENC_YEEUMBER_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 18)) return;
      oLocator = GetObjectByTag("WP_YEEUMBER_BOSS");
      oMinion = SpawnBoss("yeeumberqueen", oLocator);
      nGoldValue = GoldValue(oMinion);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      SCTreas_CreateGems(oMinion, nGoldValue);
      oItem = CreateItemOnObject("potentialstaff", oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_5_PERCENT_2_ROUNDS), oItem);

// ***** SHADOWS DARK
   } else if (sWhich=="ENC_ANIBOSS_REAPER") {
      if (!CheckRandomSpawn(3, oPC, 22)) return;
      oLocator = GetObjectByTag("WP_ANIBOSS_REAPER");
      oMinion = SpawnBoss("zachary", oLocator, TRUE);
      nGoldValue = GoldValue(oMinion);
      sWhich = CSLPickOne("SONIC", "DIVINE", "POSITIVE", "NEGATIVE"); // PICK A RARE ONE
      sWhich = CSLPickOne("ACID", "ELECTRICAL", "FIRE", "COLD", sWhich); // THEN GIVE SMALL CHANCE OF ACTUALLY DROPPING IT
      StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sWhich) + " Damage", "SMS_DAMAGE_" + sWhich);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
      oLocator = GetObjectByTag("SD_CHEST_REAPER");
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
      SCTreas_CreateArcaneScroll(oLocator, 20);
      SCTreas_CreateGems(oMinion, GoldValue(oMinion));

   } else if (CSLStringStartsWith(sWhich, "ENC_ANIBOSS_")) {
      if (!CheckRandomSpawn(3, oPC, 19)) return;
      sWhich = GetStringRight(sWhich, GetStringLength(sWhich)-12);
      oLocator = GetObjectByTag("ANIARMOR_SIGIL_" + sWhich);
      oMinion = MakeCreature("aniarmor_reaper", oLocator);
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, GoldValue(oMinion)/2);
      oLocator = GetObjectByTag("SD_CHEST_" + sWhich);
      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
      SCTreas_CreateArcaneScroll(oLocator, 20);
      string sStone = sWhich;
      if (d6()==1) StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sStone) + " Damage", "SMS_DAMAGE_" + sStone);
      if (CheckRandomSpawn(2, oPC)) {
         SCTreas_CreateGems(oLocator, GoldValue(oMinion));
         oLocator = GetObjectByTag("WP_ANIBOSS_" + sWhich);
         oMinion = SpawnBoss("zachary", oLocator, TRUE);
         StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sStone) + " Damage", "SMS_DAMAGE_" + sStone);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
     }

// ***** DORESAIN'S CRYPT
   } else if (sWhich=="ENC_YEEGHOUL_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 20)) return;
      oLocator = GetObjectByTag("WP_YEEGHOUL_BOSS");
      oMinion = SpawnBoss("doresain", oLocator);
      StoneCreate(oMinion, "stone_ac", "Link of Protection", "SMS_AC");
      CreateItemOnObject("ptn_deathward", oMinion, 5);
      for (i=1;i<=d3();i++) SCTreas_CreateRandomPotion(oMinion, 1);
      nGoldValue = GoldValue(oMinion)/3;
      oLocator = GetObjectByTag("YEEGHOUL_THRONE");
      for (i=1;i<=d2();i++) SCTreas_CreateRandomPotion(oLocator, 1);
      SCTreas_CreateGems(oLocator, nGoldValue);

// ***** THE HOLDING COMPANY
   } else if (sWhich=="ENC_PAWN_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 23)) return;
      oLocator = GetObjectByTag("WP_janis_0" + IntToString(d8()));
      oMinion = SpawnBoss("janis", oLocator);
      nGoldValue = GoldValue(oMinion);
      for (i=1;i<=d2();i++) SCTreas_CreateRandomPotion(oMinion, 1);
      oLocator = GetObjectByTag("HOLDING_CHEST");
      SCTreas_CreateGems(oLocator, nGoldValue);
      if (GetCreatureSize(oPC)==CREATURE_SIZE_SMALL) {
         sWhich = "ula_shortbow_" + CSLPickOne("adam", "silver");
         oItem = CreateItemOnObject(sWhich, oMinion);
         SetFirstName(oItem, "Sugar Baby");
         if (d4()==1) SCUnlimAmmo_AllowDivine(oItem);
         if (d4()==1) SCUnlimAmmo_AllowPositive(oItem);
      } else {
         sWhich = "ula_longbow_" + CSLPickOne("adam", "silver");
         oItem = CreateItemOnObject(sWhich, oMinion);
         SetFirstName(oItem, "Sugar Mama");
      }
      if (d4()==1) SCUnlimAmmo_AllowAcid(oItem);
      if (d4()==1) SCUnlimAmmo_AllowNegative(oItem);
      if (d4()==1) SCUnlimAmmo_AllowSonic(oItem);
      if (FindSubString(sWhich, "silver")!=-1) {
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(2), oItem);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMaxRangeStrengthMod(2), oItem);
      }
      oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGETYPE_POSITIVE), IP_CONST_DAMAGEBONUS_1d6), oItem);

// ***** YEENOGHU'S CASTLE
   } else if (sWhich=="ENC_YEENOGHU_BOSS") {
      if (!CheckRandomSpawn(3, oPC, 30)) return;
         oLocator = GetObjectByTag("WP_YEENOGHU_BOSS");
         oMinion = SpawnBoss("yeenoghu", OBJECT_SELF);
         StoneCreate(oMinion, "stone_attack", "Stone of Attack", "SMS_ATTACK");
         nGoldValue = GoldValue(oMinion);
         SCTreas_CreateGems(oMinion, nGoldValue/3);
         for (i=1;i<=d3();i++) {
            SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
            SCTreas_CreateRandomPotion(oMinion, 1);
         }
         oLocator = GetObjectByTag("YEE_THRONE");
         SCTreas_CreateRandomPotion(oMinion, 1);
         SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
         for (i=0;i<=1;i++) {
            oLocator = GetObjectByTag("YEE_CHEST", i);
            SCTreas_CreateRandomPotion(oMinion, 1);
            SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
            SCTreas_CreateGems(oMinion, nGoldValue/3);
         }

// ***** SLAG
   } else if (sWhich=="ENC_MOONMOORE_DRAGON") {
      if (CheckRandomSpawn(10, oPC)) {
          oLocator = GetObjectByTag("WP_slag_0" + IntToString(d4()));
          oMinion = MakeCreature(CSLPickOne("reddragon", "reddragon1"), oLocator, TRUE);
          AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
          AssignCommand(oMinion, ActionAttack(oPC));
          SCTreas_CreateGems(oMinion, GoldValue(oMinion));
          return;
      }
      if (!CheckRandomSpawn(10, oPC)) return;
      oLocator = GetObjectByTag("WP_slag_0" + IntToString(d4()));
      oMinion = SpawnBoss("slag", oLocator, TRUE);
      oItem = StoneCreate(oMinion, "stone_sr", "Slag's Toenail", "SMS_SR");
      oItem = CreateItemOnObject("spottersplate", oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_SPOT, 7), oItem);
      if (d2()==1) StoneCreate(oMinion, "stone_ability", "Tome of Power", "SMS_ABILITY");
      sWhich = CSLPickOne("SONIC", "DIVINE", "POSITIVE", "FIRE"); // PICK A RARE ONE
      StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sWhich) + " Damage", "SMS_DAMAGE_" + sWhich);

      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      SCTreas_CreateGems(oMinion, GoldValue(oMinion));

   } else if (sWhich=="ENC_NEST_DRAGON") {
      int nEvery = d4()+2; // DETERMINE PCT CHANCE
      nGoldValue = 50 * nEvery;
      for (i=0;i<18;i++) {
        if (!Random(nEvery)) oItem = SCTreas_CreateGoldPile(CSLRandomUpperHalf(nGoldValue), "WP_DRAGON_GOLD" + IntToString(i), CSLPickOne("bag_of_gold", "stack_of_gold", "pile_of_treasure", "pile_of_gold"));
      }
      oMinion = GetNearestObjectByTag("reddragon");
      SCTreas_CreateRandomPotion(oMinion, 2);
      SCTreas_CreateGems(oMinion, nGoldValue);

      if (!CheckRandomSpawn(60, oPC)) return;
      oLocator = GetObjectByTag("WP_DRAGON_GOLD"  + IntToString(d10()));
      oMinion = SpawnBoss("slag", oLocator, TRUE);
      oItem = StoneCreate(oMinion, "stone_sr", "Slag's Toenail", "SMS_SR");
      oItem = CreateItemOnObject("spottersplate", oMinion);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_SPOT, 7), oItem);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      SCTreas_CreateGems(oMinion, GoldValue(oMinion));

   } else if (sWhich=="ENC_SLIME_PLID") {
/*   
      if (!CheckRandomSpawn(2, oPC)) return;
      oLocator = GetNearestObjectByTag("ENC_SLIME_PLID", oPC, 2);
      string sOrder = PickOne("rm_str", "rm_str", "rm_dex", "rm_con"); // MOST LIKELY TO BE A SNEAKER OR A TANK
      oMinion = GetRandomMonster(oLocator, GetHitDice(oPC), "", sOrder);
      SetLastName(oMinion, "Uruk-Hai");
     // SetCreatureAppearanceType(oMinion, PickOneInt(5, 5, 140));
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      SCTreas_CreateGems(oMinion, GoldValue(oMinion)/2);
      SCTreas_CreateRandomPotion(oMinion, 2);
*/      

   } else if (sWhich=="ENC_UNDERWEB_BOSS") {
      if (!CheckRandomSpawn(4, oPC, 28)) return;
      oLocator = GetObjectByTag("WP_UNDERWEB_BOSS");
      oMinion = SpawnBoss("attercop", oLocator);
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue/4);
      oItem = SCTreas_CreateGoldPile(CSLRandomUpperHalf(nGoldValue), "WP_UNDERWEB_BOSS", "pile_of_gold");
      if (d4()==1) {
         oItem = CreateItemOnObject("hammeradam", oMinion);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_2d4), oItem);
      }
      oItem = CreateItemOnObject(CSLPickOne("poison_161", "poison_167", "poison_173", "poison_179"), oMinion);
      oLocator = GetObjectByTag("UNDERWEB_LIGHT_STROBE");
      SetLightActive(oLocator, TRUE);
      AssignCommand(GetModule(), DelayCommand(120.0, SetLightActive(oLocator, FALSE)));
      oLocator = GetObjectByTag("UNDERWEB_LIGHT_NORMAL");
      SetLightActive(oLocator, FALSE);
      AssignCommand(GetModule(), DelayCommand(120.0, SetLightActive(oLocator, TRUE)));

   } else if (CSLStringStartsWith(sWhich, "ENC_DROWCITY_RANDOM"))
   {
      if (!CheckRandomSpawn(3, oPC)) return;
      sWhich = GetStringRight(sWhich, GetStringLength(sWhich)-4);
      j = CSLCountParty(oPC) + 1;
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDrow(oPC, sWhich)));

	  //Here, Hatred tries to copy what Seed did for Drow for Dwarves
   } else if (CSLStringStartsWith(sWhich, "ENC_DWARF_RANDOM")) {
      if (!CheckRandomSpawn(3, oPC)) return;
      sWhich = GetStringRight(sWhich, GetStringLength(sWhich)-4);
      j = CSLCountParty(oPC) + 1;
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDwarf(oPC, sWhich)));	  
	  
	  
	  
	  
   } else if (sWhich=="ENC_DROW_BUGBEAR") {
      if (!CheckRandomSpawn(100, oPC, 28)) return;
      oLocator = GetObjectByTag("WP_pruuma_0" + IntToString(d3()));
      oMinion = SpawnBoss("pruuma", oLocator);
      for (i=0;i<2;i++) SCTreas_CreateRandomPotion(oMinion, 2);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTHAND, "NOCRAFT_PRUUMA");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGETYPE_MAGICAL), IP_CONST_DAMAGEBONUS_1d6), oItem);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oMinion, 200.0f);
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 20.0));
      AssignCommand(oMinion, ActionAttack(oPC));

   } else if (sWhich=="ENC_THIRDBOY") {
      if (!CheckRandomSpawn(3, oPC, 30)) return;
      oLocator = GetObjectByTag("WP_THIRDBOY");
      oMinion = SpawnBoss("drowthirdboy", oLocator);
      oItem = CreateItemOnObject("sneakamulet", oMinion, 1, "NOCRAFT_THIRDBOY");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_BLUFF, 5), oItem);
      for (i=1;i<=d3();i++) SCTreas_CreateRandomPotion(oMinion, 1);
      nGoldValue = GoldValue(oMinion);
      // SOME PRETTY VISUALS AND BOOSTS FOR NEARBY BUDDIES
      AssignCommand(oMinion, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oMinion));
      effect eShield = EffectDamageShield(8, DAMAGE_BONUS_2d6, DAMAGE_TYPE_NEGATIVE);
      eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_DEATH_ARMOR));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oMinion, 180.0); // SHIELD FOR BOSS
      effect eBeam = EffectBeam(VFX_BEAM_SHOCKING_GRASP, oMinion, BODY_NODE_CHEST);
      for (i=0;i<4;i++) {
         oMinion = GetNearestObjectByTag("deathknight", oLocator, i);
         if (oMinion!=OBJECT_INVALID) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oMinion, 5.0);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), GetLocation(oMinion));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oMinion, 180.0); // SHIELD FOR MINION
            SCTreas_CreateGems(oMinion, nGoldValue/3);
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6), oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_2d6), oItem);
         }
      }
      for (i=0;i<2;i++) {
         oLocator = GetObjectByTag("THIRDBOY_CHEST", i);
         for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateGems(oLocator, nGoldValue/2);
      }
            
   } else if (sWhich=="ENC_DROWJAIL_BOSS") {
      if (!CheckRandomSpawn(3, oPC)) return;
      j = CSLGetMin(CSLGetMax(1, CSLCountParty(oPC)-1), 5);
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDrow(oPC, "DROWJAIL_BOSS", FALSE)));
      if (!CheckRandomSpawn(3, oPC, 30)) return;
      oLocator = GetObjectByTag("WP_DROWJAIL_BOSS_0" + IntToString(d4()));
      oMinion = SpawnBoss("drowfirstboy", oLocator);
      for (i=0;i<2;i++) SCTreas_CreateRandomPotion(oMinion, 2);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_LEFTHAND, "NOCRAFT_FIRSBOY");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGETYPE_MAGICAL), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(CSLPickOneInt(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGETYPE_ELECTRICAL), IP_CONST_DAMAGEBONUS_2d4), oItem);

   } else if (sWhich=="ENC_DROWSHROOM_BOSS") {
      if (!CheckRandomSpawn(3, oPC)) return;
      j = CSLGetMin(CSLGetMax(1, CSLCountParty(oPC)-1), 5);
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDrow(oPC, "DROWSHROOM_BOSS", TRUE)));
      if (!CheckRandomSpawn(3, oPC, 30)) return;
      oLocator = GetObjectByTag("WP_DROWSHROOM_BOSS_0" + IntToString(d4()));
      oMinion = SpawnBoss("drowsecondboy", oLocator);
      oItem = StoneCreate(oMinion, "stone_masscrit", "Stone of Dreadful Wounds", "SMS_MASSCRIT");
      WalkCity(oMinion, "DROWSHROOM_BOSS", 4);
      for (i=0;i<2;i++) SCTreas_CreateRandomPotion(oMinion, 2);
     
   } else if (sWhich=="ENC_DROWHOUSE_BOSS") {
      if (!CheckRandomSpawn(3, oPC)) return;
      j = CSLGetMin(CSLGetMax(1, CSLCountParty(oPC)-1), 5);
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDrow(oPC, "DROWHOUSE_BOSS", TRUE)));
      if (!CheckRandomSpawn(3, oPC, 30)) return;
      oLocator = GetObjectByTag("WP_DROWHOUSE_BOSS_0" + IntToString(d4()));
      oMinion = SpawnBoss("drowfirstdaugther", oLocator);
      oItem = StoneCreate(oMinion, "stone_skill", "Book of Superior Talents", "SMS_SKILL");
      for (i=0;i<2;i++) SCTreas_CreateRandomPotion(oMinion, 2);    

   } else if (sWhich=="ENC_DROWHALL_BOSS") {
      if (!CheckRandomSpawn(3, oPC)) return;
      j = CSLGetMin(CSLGetMax(1, CSLCountParty(oPC)), 5);
      for (i=0;i<j;i++) AssignCommand(GetModule(), DelayCommand(i*30.0, MakeRandomDrow(oPC, "DROWHALL_BOSS", TRUE)));
      if (!CheckRandomSpawn(3, oPC, 30)) return;
      oLocator = GetObjectByTag("WP_DROWHALL_BOSS_0" + IntToString(d4()));
      oMinion = SpawnBoss("drowmatron", oLocator);
      oItem = CreateItemOnObject("quickstone", oMinion, 1);
      for (i=0;i<2;i++) SCTreas_CreateRandomPotion(oMinion, 2);    

	  
//New Boss Encounters by Hatred below here	  
	  
   } else if (sWhich=="ENC_DWARVENROYALTY") {
      if (!CheckRandomSpawn(3, oPC, 34)) return;
      oLocator = GetObjectByTag("WP_DWARVENROYALTY", 0);//This is also the first step for creating a set of wp for the boss to patrol upon
      oMinion = SpawnBoss("DWARFQUEEN", oLocator);	  
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue/3);
      for (i=1;i<=d3();i++) {
         SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateRandomPotion(oMinion, 1);
      }
      oLocator = GetObjectByTag("CHEST_DWARFQUEEN");
      SCTreas_CreateRandomPotion(oMinion, 1);
      SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
      for (i=0;i<=1;i++) {
         oLocator = GetObjectByTag("CHEST_DWARFKING", i);
         SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateArcaneScroll(oLocator, 20); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateGems(oLocator, nGoldValue/3);		 
	  }	 
	  oLocator = GetObjectByTag("WP_DWARVENROYALTY", 1);
      oMinion = SpawnBoss("DWARFKING", oLocator);
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue/3);
      oLocator = GetObjectByTag("CHEST_DWARFKING");
      SCTreas_CreateRandomPotion(oLocator, 1);
      SCTreas_CreateArcaneScroll(oLocator, 20); // GIVE 3 RANDOM SCROLLS
      for (i=0;i<=1;i++) {
         oLocator = GetObjectByTag("CHEST_DWARFQUEEN", i);
         SCTreas_CreateRandomPotion(oLocator, 1);
         SCTreas_CreateArcaneScroll(oLocator, 20); // GIVE 3 RANDOM SCROLLS
         SCTreas_CreateGems(oLocator, nGoldValue/3);	  
	  }
	  	 
   } else if (sWhich=="ENC_DWARVENCOMMANDERA") {
      if (!CheckRandomSpawn(3, oPC, 34)) return;
      oLocator = GetObjectByTag("WP_DWARVENCOMMANDERA");//This is also the first step for creating a set of wp for the boss to patrol upon
      oMinion = SpawnBoss("DWARVENCOMMANDERA", oLocator);	  
      nGoldValue = GoldValue(oMinion);
      SCTreas_CreateGems(oMinion, nGoldValue/2);	  
	  
  
   } else {
     SendMessageToPC(oPC, "Unknown boss encounter. Tag = " + sWhich);
     }
// END IF
// FLAG THE ENCOUNTER AS SPAWNED
   SetSpawnState(oEnc, SPAWN_STATE_ACTIVE); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER
}


		  
//   Template for adding new bosses:
//   } else if (sWhich=="DWARFKING") {
//      if (!CheckRandomSpawn(3, oPC, 34)) return;
//      oLocator = GetObjectByTag("WP_DWARFKING");//This is also the first step for creating a set of wp for the boss to patrol upon
//      oMinion = SpawnBoss("DWARFKING", oLocator);	  
//      nGoldValue = GoldValue(oMinion);
//      SCTreas_CreateGems(oMinion, nGoldValue/3);
//      for (i=1;i<=d3();i++) {
//         SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
//         SCTreas_CreateRandomPotion(oMinion, 1);
//      }
//      oLocator = GetObjectByTag("CHEST_DWARFKING");
//      SCTreas_CreateRandomPotion(oMinion, 1);
//      SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
//      for (i=0;i<=1;i++) {
//         oLocator = GetObjectByTag("CHEST_DWARFQUEEN", i);
//         SCTreas_CreateRandomPotion(oMinion, 1);
//         SCTreas_CreateArcaneScroll(oMinion, 20); // GIVE 3 RANDOM SCROLLS
//        SCTreas_CreateGems(oMinion, nGoldValue/3);		 
//	  }	 
		 

// How to spawn an item as opposed to putting it in blueprint invetory
//      oItem = CreateItemOnObject("potentialstaff", oMinion);
// And then how to add an item property
//      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_5_PERCENT_2_ROUNDS), oItem);

// Damage Stone creation
//      sWhich = PickOne("SONIC", "DIVINE", "POSITIVE", "NEGATIVE"); // PICK A RARE ONE
//      sWhich = PickOne("ACID", "ELECTRICAL", "FIRE", "COLD", sWhich); // THEN GIVE SMALL CHANCE OF ACTUALLY DROPPING IT
//      StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sWhich) + " Damage", "SMS_DAMAGE_" + sWhich);
//      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oMinion, 1);
//      oLocator = GetObjectByTag("SD_CHEST_REAPER");
//      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
//      SCTreas_CreateArcaneScroll(oLocator, 20);
//      SCTreas_CreateGems(oMinion, GoldValue(oMinion));

//   } else if (CSLStringStartsWith(sWhich, "ENC_ANIBOSS_")) {
//      if (!CheckRandomSpawn(3, oPC, 19)) return;
//      sWhich = GetStringRight(sWhich, GetStringLength(sWhich)-12);
//      oLocator = GetObjectByTag("ANIARMOR_SIGIL_" + sWhich);
//     oMinion = MakeCreature("aniarmor_reaper", oLocator);
//      nGoldValue = GoldValue(oMinion);
//      SCTreas_CreateGems(oMinion, GoldValue(oMinion)/2);
//      oLocator = GetObjectByTag("SD_CHEST_" + sWhich);
//      for (j=0;j<d2();j++) SCTreas_CreateRandomPotion(oLocator, 1);
//      SCTreas_CreateArcaneScroll(oLocator, 20);
//      string sStone = sWhich;
//      if (d6()==1) StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sStone) + " Damage", "SMS_DAMAGE_" + sStone);
//      if (CheckRandomSpawn(2, oPC)) {
//         SCTreas_CreateGems(oLocator, GoldValue(oMinion));
//         oLocator = GetObjectByTag("WP_ANIBOSS_" + sWhich);
//         oMinion = SpawnBoss("zachary", oLocator, TRUE);
//         StoneCreate(oMinion, "stone_damage", "Stone of " + CSLInitCap(sStone) + " Damage", "SMS_DAMAGE_" + sStone);


   