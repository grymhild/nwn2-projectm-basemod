#include "_CSLCore_Player"
#include "_SCInclude_DMFI" // required only for DMFI_RenameObject
#include "_SCInclude_Healing"
#include "_SCInclude_AmmoBox"
#include "_SCInclude_MagicStone"
#include "_SCInclude_UnlimitedAmmo"
#include "_SCInclude_Abjuration"
#include "_SCInclude_Transmutation"
#include "_SCInclude_Chat_c"
#include "_SCInclude_Graves"
#include "_SCInclude_Events"
#include "_SCInclude_DynamConvos"
#include "_SCInclude_Language"

void main()
{  
   //DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oItem = GetItemActivated(); ///<color=SlateGray> 
   object oPC = GetItemActivator();
   string sTag = GetTag(oItem);   
   object oTarget = GetItemActivatedTarget(); 
   if (DEBUGGING >= 5) { CSLDebug(  "onactivateitem oPC="+GetName(oPC)+" oTarget="+GetName(oTarget)+" oItem="+GetName(oItem)+" sTag="+sTag+" oItem="+GetName(oItem), oPC ); }
    //SendMessageToPC(oPC,);
   //SendMessageToPC(oPC, "Activating "+sTag );

   SCUnlimAmmo_Activate(oPC, oItem);
   
   if (sTag=="curepotion")
   {
      SCCurePC(oPC, oPC, 15);
      
//   } else if (sTag == "EL_ESTHETIC_CRAFTER") { // EL_ESTHETIC_CRAFTER
//      AssignCommand(oPC, ClearAllActions(TRUE));
//      AssignCommand(oPC, ActionStartConversation(oPC, "dlg_nwnx_craft", TRUE, FALSE));

   }
   else if (sTag == "csl_torch")// DMFI DM TOOL
   {
      CSLTorchToggle( oItem, oPC );
   }
   else if (sTag == "dmfi_exe_tool")// DMFI DM TOOL
   {
      if (!SCCheckDMItem(oPC)) return;
      SetLocalObject(oItem, DMFI_TARGET, oTarget);
      DMFI_RenameObject(oPC, oTarget);      

   } 
   else if (sTag == "dmsco") { //
      //if (!SCCheckDMItem(oPC)) return;
      string sDB = "PCS";
      sTag = "PLID_" + SDB_GetPLID(oTarget);
      StoreCampaignObject(sDB, sTag, oTarget);
      SendMessageToPC(oPC, sDB + ":: Stored Campaign Object " + GetName(oTarget) + " as " + sTag);

   } 
   else if (sTag == "dmrco") { //
      DisplayInputBox(oPC, 0, "Enter LEVEL or RMID (enter as negative) of the clone to retrieve:", "gui_dmrco_ok");
         
   } 
   else if (sTag == "fky_chat_ventril") { //
      if (!SCCheckDMItem(oPC)) return;
      ExecuteScript("_SCChat_ventril", oPC);

   } 
   else if (sTag=="healkit") {
      SCCurePC(oPC, oTarget, 0);

   } 
   else if (sTag == "healkit100") // CREATE A FRESH STACK OF HEAL KITS
   {
      CreateItemOnObject("healkit", oPC, 10);
      SCDestroyEmpties(oItem);

   } 
   else if (sTag == "curepotion100") { // CREATE A FRESH STACK OF CURE POTIONS
      CreateItemOnObject("curepotion", oPC, 10);
      SCDestroyEmpties(oItem);

   } 
   else if (sTag == "townportal_scroll") // Single use town portal (Makes it possible to return)
   {
      CreateTownPortal(oItem, oPC);
   } 
   else if (sTag == "townstone") { // Always use (Not possible to return)
      UsePortStone(oPC, oItem);

   } 
   else if (sTag == "bindstone")
   { // return to bind point
      UseBindStone(oPC);

   }
   else if (sTag == "prop_stripper")
   { //
      ExecuteScript("dm_propstrip_start", oPC);

   } else if (sTag == "faction_tool") { //
      ExecuteScript("faction_tool_start", oPC);
	
   } else if (sTag == "nw_wmscmanage" ) { //
	  //ExecuteScript("faction_tool_start", oPC);
	  CSLOpenNextDlg(oPC, GetItemActivated(), "SCDevWandConversation", TRUE, FALSE);
	  
   }
   else if ( CSLStringStartsWith(sTag, "AB_"))
   {
      if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box", oPC ); }
      SCUseAmmoBox(oPC, oItem);
      SCDestroyEmpties(oItem);

   }
   else if (CSLStringStartsWith(sTag, "SMS_"))
   {  
      StoneOnUsed(oPC, oTarget, oItem);   

   }
   else if (sTag == "aquastone")
   { // 
      SetLocalInt(oPC, "AQUALUNG", TRUE);
     DelayCommand(180.0, DeleteLocalInt(oPC, "AQUALUNG"));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("water_bubbles.sef"), oPC, 180.0);    
     
	}
	else if (sTag == "dex_trollheart")
	{ // 
		SendMessageToPC(oPC, "You eat a troll heart" );	
		FloatingTextStringOnCreature("<color=red>Fire Immunity!!</color>", oPC, TRUE);
		int iCasterLevel = 15; // OldGetCasterLevel(OBJECT_SELF);
		float fDuration = HoursToSeconds(24);
		SCUnstackEnergyImmunity( SPELL_ENERGY_IMMUNITY_FIRE, oPC, oPC );
		
		effect eImmu = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0);
		eImmu = SetEffectSpellId(eImmu, SPELL_ENERGY_IMMUNITY_FIRE);
		effect eHit = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_IMMUNITY ); // NWN2 VFX
		
		SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ENERGY_IMMUNITY_FIRE, FALSE));
		
		HkUnstackApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImmu, oPC, fDuration, SPELL_ENERGY_IMMUNITY_FIRE ); 
   }
   else if ( sTag == "dex_dexmap" )
   {
		SendMessageToPC(oPC, "You open the map" );			
		DisplayGuiScreen(oPC, "SCREEN_DEXMAP", FALSE, "_SCmap.xml");
   }
   else if (sTag == "KNOWER")
   {
      if (!SCCheckDMItem(oPC)) return;
       // KNOWER
       string sName = GetName(oTarget) + ": "; 
       if (GetIsPC(oTarget)) {
          CSLSendLoggedMessageToPC(oPC, sName + "PCName = " + CSLGetMyPlayerName(oTarget)); // + GetPCPlayerName(oTarget));
          CSLSendLoggedMessageToPC(oPC, sName + "IP     = " + CSLGetMyIPAddress(oTarget)); //GetPCIPAddress(oTarget));
          CSLSendLoggedMessageToPC(oPC, sName + "CDKey  = " + CSLGetMyPublicCDKey(oTarget)); // + GetPCPublicCDKey(oTarget));
          ActionCastSpellAtObject(SPELL_LESSER_RESTORATION, oTarget, METAMAGIC_ANY, TRUE);
       } else {
          CSLSendLoggedMessageToPC(oPC, sName + "Tag = " + GetTag(oTarget));
          CSLSendLoggedMessageToPC(oPC, sName + "Ref = " + GetResRef(oTarget));
       }
       if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) { 
          CSLSendLoggedMessageToPC(oPC, sName + "BAB = " + IntToString(GetBaseAttackBonus(oTarget)));
          CSLSendLoggedMessageToPC(oPC, sName + "AC  = " + IntToString(GetAC(oTarget)));
          CSLSendLoggedMessageToPC(oPC, sName + "CR  = " + FloatToString(CSLGetChallengeRating(oTarget)));
          CSLSendLoggedMessageToPC(oPC, sName + "HD  = " + IntToString(GetHitDice(oTarget)));
          if (GetLevelByPosition(1,oTarget)) CSLSendLoggedMessageToPC(oPC, sName + "       " + CSLGetClassesDataName(GetClassByPosition(1,oTarget)) + "   " + IntToString(GetLevelByPosition(1,oTarget)));
          if (GetLevelByPosition(2,oTarget)) CSLSendLoggedMessageToPC(oPC, sName + "       " + CSLGetClassesDataName(GetClassByPosition(2,oTarget)) + "   " + IntToString(GetLevelByPosition(2,oTarget)));
          if (GetLevelByPosition(3,oTarget)) CSLSendLoggedMessageToPC(oPC, sName + "       " + CSLGetClassesDataName(GetClassByPosition(3,oTarget)) + "   " + IntToString(GetLevelByPosition(3,oTarget)));
          if (GetLevelByPosition(4,oTarget)) CSLSendLoggedMessageToPC(oPC, sName + "       " + CSLGetClassesDataName(GetClassByPosition(4,oTarget)) + "   " + IntToString(GetLevelByPosition(4,oTarget)));
          CSLSendLoggedMessageToPC(oPC, sName + "Str = " + IntToString(GetAbilityScore(oTarget, ABILITY_STRENGTH))    + "  (" + IntToString(GetAbilityModifier(ABILITY_STRENGTH, oTarget)) + " )");
          CSLSendLoggedMessageToPC(oPC, sName + "Dex = " + IntToString(GetAbilityScore(oTarget, ABILITY_DEXTERITY))   + "  (" + IntToString(GetAbilityModifier(ABILITY_DEXTERITY, oTarget)) + " )");
          CSLSendLoggedMessageToPC(oPC, sName + "Con = " + IntToString(GetAbilityScore(oTarget, ABILITY_CONSTITUTION))+ "  (" + IntToString(GetAbilityModifier(ABILITY_CONSTITUTION, oTarget)) + " )");
          CSLSendLoggedMessageToPC(oPC, sName + "Int = " + IntToString(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE))+ "  (" + IntToString(GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget)) + " )");
          CSLSendLoggedMessageToPC(oPC, sName + "Wis = " + IntToString(GetAbilityScore(oTarget, ABILITY_WISDOM))      + "  (" + IntToString(GetAbilityModifier(ABILITY_WISDOM, oTarget)) + " )");
          CSLSendLoggedMessageToPC(oPC, sName + "Cha = " + IntToString(GetAbilityScore(oTarget, ABILITY_CHARISMA))    + "  (" + IntToString(GetAbilityModifier(ABILITY_CHARISMA, oTarget)) + " )");
       }
       
   } else if (sTag=="bottomless_mug") {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      effect eBoost = EffectVisualEffect(VFX_DUR_SPELL_VIRTUE);
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4));
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_WISDOM, 4));
      eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoost, oPC, HoursToSeconds(6));
   }
   ///////////// Pain, Quickening Item //////////////// 
    else if (sTag=="GEM_QUICKENING")
    {
     if (CSLGetHasEffectType( oPC, EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)) {
        SendMessageToPC(oPC, "You are already moving too fast...");
     } else {	 
       object oQuick = GetItemPossessedBy(oPC, "quickstone"); // Bonus
       
       if (GetIsObjectValid(oQuick))
	   {
	      float fDuration = HoursToSeconds(24);
	      FloatingTextStringOnCreature("<color=limegreen>Haste!!</color>", oPC, TRUE);
	      //UnstackSpellEffects(oPC, SPELL_HASTE);
          //UnstackSpellEffects(oPC, 647, "Blinding Speed");
          //UnstackSpellEffects(oPC, SPELL_MASS_HASTE, "Mass Haste");
          //UnstackSpellEffects(oPC, SPELL_EXPEDITIOUS_RETREAT, "Expeditious Retreat");
		  
	  	  //effect eLink = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
          //eLink = EffectLinkEffects(eLink, EffectHaste());
		 
		  int iDurType = DURATION_TYPE_TEMPORARY;
          //SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_HASTE, FALSE));
         // ApplyEffectToObject(iDurType, eLink, oPC, fDuration);
          
          SCApplyHasteEffect( oPC, oPC, SPELL_HASTE, fDuration, iDurType );
          
          
	   } 
	   else if ( !GetHasSpellEffect(SPELL_HASTE, oPC))
	   {
          FloatingTextStringOnCreature("Speed!", oPC, TRUE);
          float fDuration = HoursToSeconds(24);
          //effect eDur = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );  // NWN2 VFX
          //effect eLink = EffectMovementSpeedIncrease(150);
          //eLink = EffectLinkEffects(eLink, eDur);
          //eLink = SetEffectSpellId(eLink, );
		 int iDurType = DURATION_TYPE_TEMPORARY;
          //SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_EXPEDITIOUS_RETREAT, FALSE));
          //ApplyEffectToObject(iDurType, eLink, oPC, fDuration);
          
          SCApplyHasteEffect( oPC, oPC, SPELL_EXPEDITIOUS_RETREAT, fDuration, iDurType );
	   }
	   }
   }
   else if ( GetBaseItemType(oItem) == BASE_ITEM_BOOK )
   {
   		if ( CSLBookAcquire( oItem, oPC) )
   		{
   			return;
   		}
   }
   ///////////// End Pain, Quickening Item ////////////////
   
   SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ACTIVATE );
}