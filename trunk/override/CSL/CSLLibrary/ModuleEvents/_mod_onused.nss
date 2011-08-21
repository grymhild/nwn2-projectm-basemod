// GLOBAL MODULE ONUSED CATCH-ALL SCRIPT
//#include "dmfi_inc_conv"

//#include "_SCUtility"
#include "_CSLCore_Items"
//#include "nw_i0_plot"

#include "_HkSpell"

#include "_SCInclude_Encounter" 
#include "_SCInclude_MagicStone" 
#include "_SCInclude_Arena"
#include "_SCInclude_DynamConvos"

void main()
{

   object oPC = GetLastUsedBy();
   string sTag=GetTag(OBJECT_SELF); 
   object oLocator; 
   object oMinion;
   object oArea;  
   location lTarget;
   int i;
    
   if (sTag=="LOFT_BELL") {  // SOMEONE RANG THE LOFT BELL
      effect eEffect=EffectVisualEffect(VFX_HIT_SPELL_SONIC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, OBJECT_SELF);
      AssignCommand(OBJECT_SELF, PlaySound("as_cv_bell2")); 
	  
   } else if (sTag=="BLOODSTONE_BELL") {  // SOMEONE RANG THE MT BLOODSTONE ALARM BELL
      effect eEffect=EffectVisualEffect(VFX_HIT_SPELL_SONIC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, OBJECT_SELF);
      AssignCommand(OBJECT_SELF, PlaySound("as_cv_bell2")); 	  

   } else if (sTag=="SERVER_CLOCK") {
      SendMessageToPC(oPC, "DEX2 has been up for " + CSLGetServerUpTime());
      SendMessageToPC(oPC, "The server will reboot in " + CSLGetServerRemainingUpTime());

   }
   else if (sTag=="REST_FOUNTAIN")
   {
      DeleteLocalInt(oPC, "LASTREST");
      AssignCommand(oPC, PlaySound("al_en_windgust_1"));
      FloatingTextStringOnCreature("You can now rest again", oPC, FALSE);

   } else if (sTag=="PILE_OF_GOLD") {
      if (GetIsInCombat(oPC)) {
         FloatingTextStringOnCreature("<color=yellow>Under Attack!</color>", oPC, TRUE);
         SendMessageToPC(oPC, "You cannot pick up coins during combat!");
         return;
      }
      int nGold = GetLocalInt(OBJECT_SELF, "GOLD");
      FloatingTextStringOnCreature("<color=yellow>*" + IntToString(nGold) + "*</color>", oPC, TRUE);
      GiveGoldToCreature(oPC, nGold);
      SetLocalInt(OBJECT_SELF, "GOLD", 0);
      PlaySound("it_coins");
      DestroyObject(OBJECT_SELF);

   } else if (CSLStringStartsWith(sTag, "MARSH_GATE")) {
      float fAngle;
      int bOpen = !GetLocalInt(OBJECT_SELF, "OPENED"); // REVERSE THE STATE
      if (bOpen) DelayCommand(1.0f, AssignCommand(OBJECT_SELF, PlaySound("as_dr_woodlgop1"))); // OPENING
      else DelayCommand(1.0f, AssignCommand(OBJECT_SELF, PlaySound("as_dr_woodvlgcl1"))); // CLOSING
      AssignCommand(OBJECT_SELF,  PlaySound("as_cv_woodframe1"));
      oLocator = GetObjectByTag("MARSH_GATE_LEFT");
      fAngle = (bOpen) ? -180.0 : -45.0;
      AssignCommand(oLocator, SetFacing(fAngle));
      SetLocalInt(oLocator, "OPENED", bOpen);
      oLocator = GetObjectByTag("MARSH_GATE_RIGHT");
      fAngle = (bOpen) ? -90.0 : -225.0;
      AssignCommand(oLocator, SetFacing(fAngle));
      SetLocalInt(oLocator, "OPENED", bOpen);

   }
   else if (sTag=="TROLL_BOULDER")
   {
      oPC = GetLastDamager();
      if (GetPlotFlag()) { // BOULDERS ARE CURRENTLY PLOT, MUST BE HIT WITH STONECLEAVER TO UN-PLOT
        if (GetItemPossessedBy(oPC, "STONECLEAVER")==OBJECT_INVALID) { // PC DOES NOT POSSESS THE HAMMER
         //if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))!="STONECLEAVER") {
            SendMessageToPC(oPC, "A special hammer is required to cleave this magical rock.");
            return;
         }
         SendMessageToPC(oPC, "The rock yields to the power of Stone Cleaver!");
         SetPlotFlag(OBJECT_SELF, FALSE); // PC HIT WITH STONECLEAVER, REMOVE PLOT AND LET THEM DESTORY IT
         SetLocalInt(OBJECT_SELF, "HPLAST", GetCurrentHitPoints(OBJECT_SELF));
         PlaySound("as_na_rockfallg2");
         ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_HIT_AOE_SONIC), GetLocation(OBJECT_SELF), 10.0);
      }
      int nHP = GetLocalInt(OBJECT_SELF, "HPLAST");
      int iDamage = nHP - GetCurrentHitPoints(OBJECT_SELF);
      if (iDamage<25) return; // NOT MUCH DAMAGE SKIP THE NOISE
      PlaySound("as_na_rockfalsm" + IntToString(d4()));
      if (d10()!=1) return; // % CHANCE OF WANDERING TROLL COMING TO INVESTIGATE THE NOISE
      oLocator = GetObjectByTag("WP_WANDERING_TROLL"+IntToString(d2()));
      oMinion = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("rocktroll_witch", "rocktroll_elder"), GetLocation(oLocator));
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 15.0));
      AssignCommand(oMinion, ActionAttack(oPC));

   } else if (sTag=="DEX_FAQ") {
      CSLOpenNextDlg(oPC, OBJECT_SELF, "seed_faq", TRUE, FALSE);

   } else if (sTag=="MONSTER_MANUAL") {
      AssignCommand(OBJECT_SELF, PlaySound("c_boar_atk1"));
      CSLOpenNextDlg(oPC, OBJECT_SELF, "monster_manual", TRUE, FALSE);

   } else if (sTag=="FEEDBACK") {
      if (GetLocalInt(oPC, "FEEDBACK")) { // ONLY ONCE PER 3 MINUTES
         SendMessageToPC(oPC, "You can only leave module feedback once every 3 minutes.");
         SetLocalInt(oPC, "FEEDBACK", 1);
         DelayCommand(180.0, DeleteLocalInt(oPC, "FEEDBACK"));
      } else {
         DisplayInputBox(oPC, 0, "Enter your message:", "gui_feedback_ok");
      }

   } else if (sTag=="LAVA_TRAP") {
      oPC = GetEnteringObject();
      if (GetIsPC(oPC)) {
         int iDamage = d20(2);
         iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oPC, 24, SAVING_THROW_TYPE_FIRE);
         if (!iDamage) return; // SAVED VS FIRE SO EXIT
         DelayCommand(0.25f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_FIRE), oPC));
         DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC));
         FloatingTextStringOnCreature(CSLPickOne("Yeow!","Ouch","Hot Foot!","Sizzle"), oPC, TRUE);
       //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("ror_lavabrst_ns_01.sef"), GetLocation(oPC), 4.0);
      }

   } else if (sTag=="DRAKKEN_COFFIN") {
      if (GetLocalInt(OBJECT_SELF, "FIRED")) return;
      SetLocalInt(OBJECT_SELF, "FIRED", TRUE);
      DelayCommand(300.0, DeleteLocalInt(OBJECT_SELF, "FIRED"));
      PlayAnimation(ANIMATION_PLACEABLE_OPEN);
      DelayCommand(30.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      if (GetFirstItemInInventory(OBJECT_SELF)!=OBJECT_INVALID) {
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(OBJECT_SELF));
         oMinion = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("drakkenfighter1", "drakkenmage"), GetLocation(OBJECT_SELF));
         AssignCommand(oMinion, PlayVoiceChat(VOICE_CHAT_BADIDEA));
         SCTreas_CreateGems(oMinion, 250);
      }

   } else if (sTag=="DRAKKEN_SECRETBOOK") {
      oLocator = GetObjectByTag("DRAKKEN_BOOKCASE");
      AssignCommand(oPC, PlaySound("al_en_explbarrel05"));
      DestroyObject(oLocator);
          
   } else if (sTag=="TRASH") { 
      oLocator = GetFirstItemInInventory(OBJECT_SELF);
      while (oLocator!=OBJECT_INVALID) {
         DestroyObject(oLocator);
         oLocator = GetNextItemInInventory(OBJECT_SELF);
      }
        
   } else if (sTag=="STRICKENTOWN") {
      oPC = GetEnteringObject();
      int bIsPC = (GetIsPC(oPC) || GetIsPC(GetMaster(oPC)));
      if (!GetLocalInt(oPC, "ALERT")) {
         SetLocalInt(oPC, "ALERT", TRUE);
         DelayCommand(5.0, DeleteLocalInt(oPC, "ALERT"));
         if (bIsPC) AssignCommand(oPC, PlaySound("gui_drumsong01"));
         for (i=0;i<2;i++) { // CROSS BEAM OF LIGHTNING
            oMinion = GetObjectByTag("strickenwatcher", i);
            if (!bIsPC) {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oMinion, BODY_NODE_HAND), oPC, 2.0);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING), oPC);
               DelayCommand(IntToFloat(i), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oPC)));
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1000, DAMAGE_TYPE_MAGICAL), oPC);          
            } else {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oMinion, BODY_NODE_HAND), oMinion, 1.0);
            }  
         }    
      }

   } else if (sTag=="GNOLL_LEVER") {
      object oCrystal = GetItemPossessedBy(oPC, "phase_crystal");
      if (oCrystal==OBJECT_INVALID) { // PC DOES NOT POSSESS A CRYSTAL
         FloatingTextStringOnCreature("*zizzztt*", oPC);
         SendMessageToPC(oPC, "You get a small shock from the lever.");
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(3, DAMAGE_TYPE_ELECTRICAL), oPC);
         return;
      }
      if (GetObjectByTag("PORT_YEENOGHU")!=OBJECT_INVALID) {
         FloatingTextStringOnCreature("*zhooommp*", oPC);
         SendMessageToPC(oPC, "A phase crystal discharges in your pocket!");
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(30, DAMAGE_TYPE_ELECTRICAL), oPC);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_ELECTRICAL), oPC);
         return;
      }
      DestroyObject(oCrystal);
      SendMessageToPC(oPC, "Your phase crystal has activated the portal!!");
      object oCurr = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("gnollshaman", "gnollfighter1", "yeeghoul"), GetLocation(GetObjectByTag("gnollwp_01")));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_WEB_OF_PURITY, oPC, BODY_NODE_CHEST), oCurr, 8.0);
      AssignCommand(oCurr, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oCurr, 6.0);
      object oNxt;
      for (i=2;i<=6;i++) { // CROSS BEAM OF LIGHTNING
         oNxt = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("gnollshaman", "gnollfighter1", "yeeghoul"), GetLocation(GetObjectByTag("gnollwp_0" + IntToString(i))));
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_WEB_OF_PURITY, oCurr, BODY_NODE_CHEST), oNxt, 8.0);
         oCurr = oNxt;
         AssignCommand(oCurr, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oCurr, 6.0);
      }
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_WEB_OF_PURITY, oNxt, BODY_NODE_CHEST), oPC, 8.0);
      ExecuteScript("yeeportal_create", oPC);
      
   } else if (sTag=="GNOLL_TREE") {
      oPC = GetLastDamager();
      int nHP = GetLocalInt(OBJECT_SELF, "HPLAST");
      int nCurrent = GetCurrentHitPoints(OBJECT_SELF);
      if (nCurrent<1) { // DEAD, BRING IN YEE HAW!
     // 
      //  if (GetLocalInt(OBJECT_SELF, "DEAD")==1) return;
      // SetLocalInt(OBJECT_SELF, "DEAD", 1);
      //   return;  
     //    
      }
      int iDamage = nHP - nCurrent;
      if (iDamage<25) return; // NOT MUCH DAMAGE SKIP THE NOISE
      PlaySound("metor_impact_0" + IntToString(d8()));
      if (d10()!=1) return; // % CHANCE OF WANDERING GNOLL COMING TO INVESTIGATE THE NOISE
      oLocator = GetObjectByTag("WP_WANDERING_GNOLL");
      oMinion = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("gnollshaman", "gnollfighter1"), GetLocation(oLocator));
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 15.0));
      AssignCommand(oMinion, ActionAttack(oPC));
     
        
   } else if (sTag=="BACCHUS_INDADU") {
      object oBoat = GetItemPossessedBy(oPC, "foldingboat");
      if (oBoat==OBJECT_INVALID) {
         SendMessageToPC(oPC, "You have no boat to use.");
         return;
      } else if (GetHitDice(oPC)>=17) {
         SendMessageToPC(oPC, "The boat will not open for one so powerful!");
         return;
      }
      SendMessageToPC(oPC, "You unfold and get in the boat. Under it's own power it sails off to an island!");
      oLocator = GetObjectByTag("WP_INDADU_BOAT");
      AssignCommand(oPC, JumpToObject(oLocator));
      //ActionStartConversation(oPC, "indadu_boat", TRUE);

   } else if (sTag=="SEALICH_IDOL") {
      if (GetLocalInt(OBJECT_SELF, "TAKEN")==1) return;
     SetLocalInt(OBJECT_SELF, "TAKEN", 1);
      DestroyObject(OBJECT_SELF);
     CreateItemOnObject("sealichidol", oPC);

   } else if (sTag=="ARENA_LEVER_1") {
      SCStartBattle("1");  
   } else if (sTag=="ARENA_LEVER_2") {
      SCStartBattle("2");
   } else if (sTag=="ARENA_PORT_DISABLE") {
     CSLToggleOnOff(OBJECT_SELF); 

   } else if (sTag=="ARENA_TOTEM") {
      SCPortPCToArena(oPC); 
	  
   } else if (sTag=="PORTAL_BATTLEFIELD") {
      SCPortPCToBattlefield(oPC); 	  
	 
	} else if (sTag=="PORTAL_DOGBEACH") {
		SCPortPCToArea1(oPC); 	  
		                
   } else if (sTag=="SUN_TOTEM") {
      CSLRemoveEffectByCreator(oPC, OBJECT_SELF);
      FloatingTextStringOnCreature("*burn*", oPC);
      effect eLink = EffectDamageResistance(DAMAGE_TYPE_FIRE, 25, 120);
      eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_MAGICAL, 5, 25));
      eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_ENDURE_ELEMENTS));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(25, DAMAGE_TYPE_MAGICAL), oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(25, DAMAGE_TYPE_FIRE), oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_FIRE), oPC);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 600.0);

   }
   else if (sTag=="PRAYER_GEM")
   {
      if (CSLGetIsEnemyClose(oPC, 35.0))
      {
         SendMessageToPC(oPC, "You cannot pray with an enemy so close.");
         return;
      }
      CSLRemoveEffectByCreator(oPC, OBJECT_SELF);
      if (GetGender(oPC)==GENDER_MALE) PlaySound("as_pl_chantingm2");
      else PlaySound("as_pl_chantingf2");
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 8.0));
      ActionCastSpellAtObject(SPELL_PRAYER, oPC, METAMAGIC_EXTEND, TRUE);
                  
   } else if (CSLStringStartsWith(sTag, "SD_OPENDOOR")) {
      if     (sTag=="SD_OPENDOOR_FIRE")       sTag="SD_FIRE_COLD"; 
      else if (sTag=="SD_OPENDOOR_COLD")       sTag="SD_COLD_ELECTRICAL";
      else if (sTag=="SD_OPENDOOR_ELECTRICAL") sTag="SD_ELECTRICAL_ACID";
      else if (sTag=="SD_OPENDOOR_ACID")       sTag="SD_ACID_REAPER";
      object oDoor = GetObjectByTag(sTag);
      if (GetIsInCombat(oPC)) {
         SendMessageToPC(oPC, "You cannot use the lever while fighting.");
      } else if (GetLocked(oDoor)) {
         SetLocked(oDoor, FALSE);
         CSLToggleOnOff(OBJECT_SELF, FALSE);
         SendMessageToPC(oPC, "You hear the clicking sound of a lock opening.");
         PlaySound("gui_picklockopen");
         DelayCommand(300.0, SetLocked(oDoor, TRUE));
         DelayCommand(300.0, CSLToggleOnOff(OBJECT_SELF, FALSE));
      } else {
         SendMessageToPC(oPC, "The door is unlocked.");
      }
      
   } else if (sTag=="PARTY_PORTAL") {
      int bPortFlag = GetLocalInt(oPC, "PARTY_PORT");
      if (bPortFlag!=0) {
         SendMessageToPC(oPC, "Yawn...You must rest before using the Party Portal again.");
         return;
      }
      object oLeader = GetFactionLeader(oPC);
      bPortFlag = 1;
      if (oPC!=oLeader)
      {
		if ( !CSLGetCanTeleport( oPC ) )
		{
			SendMessageToPC( oPC, "You are Dimensionally Anchored");
			return;
		}
	
         if (abs(GetHitDice(oLeader)-GetHitDice(oPC))>5) {
            SendMessageToPC(oPC, "The level difference between you and the Party Leader is too much. The max is 5 levels.");
            return;
         }
         if (GetHitDice(oPC)==30) {
            SendMessageToPC(oPC, "Sorry, you are level 30 and cannot use this portal.");
            return;
         }
         if (GetHitDice(oLeader)==30) {
            SendMessageToPC(oPC, "Sorry, your Party Leader is level 30 and cannot be ported to.");
            return;
         }
         oArea = GetArea(oLeader);
         if (oArea==OBJECT_INVALID) {
            SendMessageToPC(oPC, "Sorry, " + GetName(oLeader) + " is currently transitioning.");
            return; 
         }
		 
		if ( GetTag(oArea)=="deathplane" )
		{
			SendMessageToPC(oPC, "Sorry, " + GetName(oLeader) + " is currently a ghost.");
			return;
		}
			   
			   
         if (!CSLPCCanEnterArea(oPC, oArea)) {
            int nMax = GetLocalInt(oArea, "MAXLEVEL");
            SendMessageToPC(oPC, "Sorry, " + GetName(oLeader) + " is in an area restricted to level " + IntToString(nMax) + " and lower.");
            return; 
         }
         //lTarget = CSLGetFlankingRightLocation(oLeader);
         oLocator = oLeader;
         if (CSLGetIsEnemyClose(oLeader, 25.0)) {
            SendMessageToPC(oPC, "It is unsafe to port to the Party Leader. Try again in a few seconds.");
            oLocator = GetObjectByTag("BAD_PORT");
            bPortFlag = 0;
         }         
         SetLocalInt(oPC, "PARTY_PORT", bPortFlag);
         object oGrave = GetGrave(oPC);
         if (bPortFlag!=0 && oGrave!=OBJECT_INVALID) DestroyObject(oGrave);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
         AssignCommand(oPC, ClearAllActions());
         AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
         //DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(lTarget)));
         DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oLocator)));
         
      } else {
         SendMessageToPC(oPC, "One cannot port to one's self.");
      }

   } else if (CSLStringStartsWith(sTag, "GATE_DROW_")) {
      oPC = GetLastDamager();
      int nHP = GetLocalInt(OBJECT_SELF, "HPLAST");
      int nCurrent = GetCurrentHitPoints(OBJECT_SELF);
      if (nCurrent<1) { // DEAD, BRING IN YEE HAW!
      }
      int iDamage = nHP - nCurrent;
      if (iDamage<25) return; // NOT MUCH DAMAGE SKIP THE NOISE
      PlaySound("metor_impact_0" + IntToString(d8()));
      
      if (iDamage>50) {
         lTarget = GetLocation(OBJECT_SELF);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_20), lTarget);
         effect eNeg = SupernaturalEffect(EffectAbilityDecrease(ABILITY_STRENGTH, 2));
         effect eDam = EffectDamage(d6(5), DAMAGE_TYPE_NEGATIVE);
         if (!HkSavingThrow(SAVING_THROW_FORT, oPC, 18, SAVING_THROW_TYPE_TRAP)) {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNeg, oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oPC);
         }
         oPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
         while (GetIsObjectValid(oPC)) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
            oPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
         }    
      }
      
      if (d10()!=1) return; // % CHANCE OF WANDERING DROW COMING TO INVESTIGATE THE NOISE
      oLocator = GetObjectByTag("WP_DROWGATE_SPAWN");
      oMinion = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("drowcleric1", "drowsorcerer1"), GetLocation(oLocator));
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 15.0));
      AssignCommand(oMinion, ActionAttack(oPC));
      oMinion = CreateObject(OBJECT_TYPE_CREATURE, CSLPickOne("drowarcher2", "drowfighter2"), GetLocation(oLocator));
      AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 15.0));
      AssignCommand(oMinion, ActionAttack(oPC));
     
                  
   }
   else if (sTag=="TESTY")
   {
		//SendMessageToPC(oPC, "TESTING");
      if (!GetIsSinglePlayer()) return;
   
      StoneCreate(oPC, "stone_ammo", "Bow String of " + CSLPickOne("Flame", "Ice", "Static") + " Arrow", "SMS_AMMO");
      StoneCreate(oPC, "stone_damage", "Stone of BLUDGEONING Damage", "SMS_DAMAGE_BLUDGEONING");
      StoneCreate(oPC, "stone_damage", "Stone of PIERCING Damage", "SMS_DAMAGE_PIERCING");
      StoneCreate(oPC, "stone_damage", "Stone of SLASHING Damage", "SMS_DAMAGE_SLASHING");
      StoneCreate(oPC, "stone_damage", "Stone of MAGICAL Damage", "SMS_DAMAGE_MAGICAL");
      StoneCreate(oPC, "stone_damage", "Stone of ACID Damage", "SMS_DAMAGE_ACID");
      StoneCreate(oPC, "stone_damage", "Stone of COLD Damage", "SMS_DAMAGE_COLD");
      StoneCreate(oPC, "stone_damage", "Stone of DIVINE Damage", "SMS_DAMAGE_DIVINE");
      StoneCreate(oPC, "stone_damage", "Stone of ELECTRICAL Damage", "SMS_DAMAGE_ELECTRICAL");
      StoneCreate(oPC, "stone_damage", "Stone of FIRE Damage", "SMS_DAMAGE_FIRE");
      StoneCreate(oPC, "stone_damage", "Stone of NEGATIVE Damage", "SMS_DAMAGE_NEGATIVE");
      StoneCreate(oPC, "stone_damage", "Stone of POSITIVE Damage", "SMS_DAMAGE_POSITIVE");
      StoneCreate(oPC, "stone_damage", "Stone of SONIC Damage", "SMS_DAMAGE_SONIC");
      
   }
   
// */
}