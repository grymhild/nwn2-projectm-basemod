#include "_CSLCore_Nwnx"
#include "_SCInclude_Class"
#include "_SCInclude_Events"
// #include "hcr2_core_i"
//#include "x2_inc_switches"
//#include "elu_functions_i"


void CSLEvent_Mod_OnAcquireItem()
{
	object oPC = GetModuleItemAcquiredBy();
   
   if (!GetIsPC(oPC)) return;
   if (!GetLocalInt(oPC, "LOADED")) return;

   object oItem = GetModuleItemAcquired();
    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
	h2_RunModuleEventScripts(H2_EVENT_ON_ACQUIRE_ITEM);   
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oItem = GetModuleItemAcquired();
    object oAcquiredFrom = GetModuleItemAcquiredFrom();
    object oAcquiredBy = GetModuleItemAcquiredBy();
    int nItemStackSize = GetModuleItemAcquiredStackSize(), bLogEvent = TRUE;

	// SendMessageToAllDMs("Acquired Item: "+GetName(oItem)+" by "+GetName(oAcquiredBy)+" with valid: "+IntToString(GetIsObjectValid(oAcquiredBy))+ " in area "+GetName(GetArea(oAcquiredBy))+" with valid: "+IntToString(GetIsObjectValid(GetArea(oAcquiredBy))));
 
	// only process player acquisitions
	if (! GetIsPC(oAcquiredBy)) { return; }

	// ignore acquisition events triggered by DMs (for logging only)
	if (GetIsDM(oAcquiredBy) || GetIsDMPossessed(oAcquiredBy)) { bLogEvent = FALSE; }

	// ignore acquisition events triggered by logins (for logging only)
	else if (! GetIsObjectValid(GetArea(oAcquiredBy))) { bLogEvent = FALSE; }
	
	ACR_ItemOnAcquire(oItem, oAcquiredBy, oAcquiredFrom);
	
    // track the presence of non-detection items
	//  We don't use these yet, skip this call.
    //ACR_ManageNonDetectionOnAcquire(oItem, oAcquiredBy);

    // trap items with illegal properties
	// Since we don't use this yet, commenting out.
	//  if/when this is restored, should cache the list to a local array on the module
	//   as querying the database each time is extremely inefficient.
	
    //if (ACR_GetHasIllegalProperties(oItem))
    //{
    //    sEvent = ACR_LOG_ACQUIRE_ILLEGAL;
    //            
    //    // quarantine the item?
   // }
	
	
    // log item acquisitions
	if (GetTag(oItem) == "acr_nld_fist") {
	    // don't need to log this, OOC from toggling subdual mode
	} else if (bLogEvent) {
		ACR_LogOnAcquired(oItem, oAcquiredBy, GetStolenFlag(oItem));
		// Also only need to process quest item acquisitions if PC is already in the mod.
		// grant quest XP for acquired quest items
    	ACR_QuestItemOnAcquire(oAcquiredBy, oItem);
    }    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
   DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   

   StoneOnAcquired(oPC, oItem); // RECORD WHO PICKED UP THE STONE
   
   CSLDollEquipItem( oItem, oPC );
   
   

   if (GetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM")) {
      DeleteLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM");
   }
   
   if (GetLocalInt(oItem, "CRAFTING")) {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(50, DAMAGE_TYPE_MAGICAL), oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
      TakeGoldFromCreature(GetGoldPieceValue(oItem), oPC, TRUE);
      SDB_LogMsg("CRAFTSTEAL", "Item marked with CRAFTING flag. Value=" + IntToString(GetGoldPieceValue(oItem)), oPC);
      SendMessageToPC(oPC, "Your slight of hand has not gone unnoticed. You anger me when you try to steal...");
      DestroyObject(oItem);     
   }

   CSLRemoveAllItemProperties(oItem,  DURATION_TYPE_TEMPORARY);

   object oBartered = GetLocalObject(oItem, "BARTER_FROM");
   if (oBartered!=OBJECT_INVALID) {
      SDB_UpdatePlayerStatus(oBartered); // SAVE PC STATUS OF PERSON WHO BARTERED THIS ITEM      
   }
   DeleteLocalObject(oItem, "BARTER_FROM");
   DeleteLocalInt(oItem, "BARTER_PLID");

   string sItem = GetName(oItem);

   if (GetLocalInt(oPC, "LOADING")) return; // DON'T SHOW ACQUIRE TELLS IF CLIENT JUST JOINED MODULE
   else SDB_UpdatePlayerStatus(oPC); // SAVE PC STATUS

   if (CSLGetIsInTown(oPC)) return; // DON'T SHOW ACQUIRE TELLS IN TOWN
   if (IsInConversation(oPC)) return; // COULD BE CRAFTING
   if (sItem=="") return; // DON'T SHOW ACQUIRE TELLS IF WE CAN'T TELL WHAT WAS ACQUIRED (GOLD FOR EXAMPLE)
   int nStack = GetItemStackSize(oItem);
   if (nStack>1) sItem += " (" + IntToString(nStack) + ")";
   object oMember = GetFirstFactionMember(oPC);
   while (GetIsObjectValid(oMember)) {
      if (oPC==oMember) SendMessageToPC(oMember, "You picked up " + sItem);
      else if (GetDistanceBetween(oPC, oMember) <= 15.0) SendMessageToPC(oMember, "You see " + GetName(oPC) + " pick up " + sItem);
      oMember = GetNextFactionMember(oPC);
   }
    
    
    */
}

void CSLEvent_Mod_OnActivateItem()
{

	object oItem = GetItemActivated();
	object oPC = GetItemActivator();
	string sTag = GetTag(oItem);   
	object oTarget = GetItemActivatedTarget(); 
   
    SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ACTIVATE );
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
 
 	h2_RunModuleEventScripts(H2_EVENT_ON_ACTIVATE_ITEM);   
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oItem = GetItemActivated();
    object oActivator = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location locTarget = GetItemActivatedTargetLocation();

	// handle items.
    ACR_ItemOnActivate(oItem, oActivator, oTarget, locTarget);

    // log item activation
    ACR_LogEvent(oActivator, ACR_LOG_ACTIVATE, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oActivator)));
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
       DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   
     
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

   } else if (sTag == "dmsco") { //
      //if (!SCCheckDMItem(oPC)) return;
      string sDB = "PCS";
      sTag = "PLID_" + SDB_GetPLID(oTarget);
      StoreCampaignObject(sDB, sTag, oTarget);
      SendMessageToPC(oPC, sDB + ":: Stored Campaign Object " + GetName(oTarget) + " as " + sTag);

   } else if (sTag == "dmrco") { //
      DisplayInputBox(oPC, 0, "Enter LEVEL or RMID (enter as negative) of the clone to retrieve:", "gui_dmrco_ok");
         
   } else if (sTag == "fky_chat_ventril") { //
      if (!SCCheckDMItem(oPC)) return;
      ExecuteScript("_SCChat_ventril", oPC);

   } else if (sTag=="healkit") {
      SCCurePC(oPC, oTarget, 0);

   } else if (sTag == "healkit100") { // CREATE A FRESH STACK OF HEAL KITS
      CreateItemOnObject("healkit", oPC, 10);
      SCDestroyEmpties(oItem);

   } else if (sTag == "curepotion100") { // CREATE A FRESH STACK OF CURE POTIONS
      CreateItemOnObject("curepotion", oPC, 10);
      SCDestroyEmpties(oItem);

   } else if (sTag == "townportal_scroll") { // Single use town portal (Makes it possible to return)
      CreateTownPortal(oItem, oPC);

   } else if (sTag == "townstone") { // Always use (Not possible to return)
      UsePortStone(oPC, oItem);

   } else if (sTag == "bindstone")
   { // return to bind point
      UseBindStone(oPC);

   } else if (sTag == "prop_stripper") { //
      ExecuteScript("dm_propstrip_start", oPC);

   } else if (sTag == "faction_tool") { //
      ExecuteScript("faction_tool_start", oPC);
	
   } else if (sTag == "nw_wmscmanage" ) { //
	  //ExecuteScript("faction_tool_start", oPC);
	  CSLOpenNextDlg(oPC, GetItemActivated(), "SCDevWandConversation", TRUE, FALSE);
	  
   } else if ( CSLStringStartsWith(sTag, "AB_")) {
      SCUseAmmoBox(oPC, oItem);
      SCDestroyEmpties(oItem);

   } else if (CSLStringStartsWith(sTag, "SMS_")) {  
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
          CSLSendLoggedMessageToPC(oPC, sName + "CR  = " + FloatToString(GetChallengeRating(oTarget)));
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
   ///////////// End Pain, Quickening Item ////////////////
    
    */
}


void CSLEvent_Mod_OnClientEnter()
{
	object oPC = GetEnteringObject();
	SetLocalInt(oPC, "LOADED", TRUE);
	CSLTimedFlag(oPC, "LOADING", 4.0);
	DeleteLocalInt(oPC, "TRANS");
    
	SetLocalString(oPC, "MyName", GetName(oPC) );
	SetLocalString(oPC, "IPAddress", GetPCIPAddress(oPC) );
	SetLocalString(oPC, "PublicCDKey", GetPCPublicCDKey(oPC) );
	SetLocalString(oPC, "PlayerName",  GetPCPlayerName(oPC) );
   
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
	object oPC = GetEnteringObject();
    int bIsDM = GetIsDM(oPC);

	int bIsBanned = h2_GetIsBanned(oPC);
    if (bIsBanned)
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_YOU_ARE_BANNED);
        return;
    }

    if (!bIsDM && h2_MaximumPlayersReached())
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_SERVER_IS_FULL, 10.0);
        return;
    }

    if (!bIsDM && h2_GetModLocalInt(H2_MODULE_LOCKED))
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_MODULE_LOCKED, 10.0);
        return;
    }

    int iPlayerState = h2_GetPlayerState(oPC);
    if (!bIsDM && iPlayerState == H2_PLAYER_STATE_RETIRED)
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_RETIRED_PC_BOOT, 10.0);
        return;
    }

    if (!bIsDM && H2_REGISTERED_CHARACTERS_ALLOWED > 0 && GetXP(oPC) == 0)
    {
        int nRegisteredCharCount = h2_GetRegisteredCharCount(oPC);
        if (nRegisteredCharCount >= H2_REGISTERED_CHARACTERS_ALLOWED)
        {
            SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
            h2_BootPlayer(oPC, H2_TEXT_TOO_MANY_CHARS_BOOT, 10.0);
            return;
        }
    }
    if (!bIsDM)
    {
        int iPlayerCount = h2_GetModLocalInt(H2_PLAYER_COUNT);
        h2_SetModLocalInt(H2_PLAYER_COUNT, iPlayerCount + 1);
    }

    SetLocalString(oPC, H2_PC_PLAYER_NAME, GetPCPlayerName(oPC));
    SetLocalString(oPC, H2_PC_CD_KEY, GetPCPublicCDKey(oPC));    

    h2_RunModuleEventScripts(H2_EVENT_ON_CLIENT_ENTER);
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetEnteringObject(), oCorpse = OBJECT_INVALID;

    // exit if the database is unavailable
    if (ACR_GetModuleStatus(ACR_MOD_NWNX_FAILED))
	{
       	// boot players and log the error
       	if (! GetIsDM(oPC)) { BootPC(oPC); return; }
	    ACR_PrintDebugMessage("acr_mod_events_i: ERROR - NWNX Unavailable on " + GetName(oPC) + " login.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);
	}

    // Code executed for DMs and PCs goes here

    // initialize the player - RUN THIS BEFORE INITIALIZING OTHER SYSTEMS
    ACR_PCOnClientEnter(oPC);
	
	//initialize for chatlogging
	ACR_ChatOnClientEnter(oPC);

	// Initialize DM Client Extension pack (optional)
	ExecuteScript("wand_init", oPC);
	
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
	    // log the entry
	    ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + " from IP: "+GetPCIPAddress(oPC));
    }
    else
    {
	    // log the entry
    	ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC))+ " from IP: "+GetPCIPAddress(oPC));
		
        // manage dead PCs - important for this to be done first
        ACR_DeathOnClientEnter(oPC);
		ACR_SkillsOnClientEnter(oPC);
    }
        
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
       DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oPC = GetEnteringObject();
   SetLocalInt(oPC, "LOADED", TRUE);
   CSLTimedFlag(oPC, "LOADING", 4.0);
   DeleteLocalInt(oPC, "TRANS");
   SetLocalInt(oPC, "X1_AllowSdThf", FALSE); // ALLOW SHADOW THIEF CLASS
   //SendMessageToPC( GetFirstPC(), "Client enter" );
   string sName = GetName(oPC);
   string sIPAddress = GetPCIPAddress(oPC);
   string sPublicCDKey = GetPCPublicCDKey(oPC);
   string sPlayerName = GetPCPlayerName(oPC);
   
   SetLocalString(oPC, "MyName", sName);
   SetLocalString(oPC, "IPAddress", sIPAddress);
   SetLocalString(oPC, "PublicCDKey", sPublicCDKey);
   SetLocalString(oPC, "PlayerName",  sPlayerName);
	//CSLTableShowListUI(oPC, CSL_PAGE_FIRST );

    
    */
}

void CSLEvent_Mod_OnClientLeave()
{
	object oPC = GetExitingObject();
    
    CSLPlayerList_ClientExit(oPC);
    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
	object oPC = GetExitingObject();
    if (GetLocalInt(oPC, H2_LOGIN_BOOT))
        return;
	h2_LogOutPC(oPC);		
    if (!GetIsDM(oPC))
    {
        int iPlayerCount = h2_GetModLocalInt(H2_PLAYER_COUNT);
        h2_SetModLocalInt(H2_PLAYER_COUNT, iPlayerCount - 1); 
		h2_RemoveEffects(oPC);       
    }
    h2_RunModuleEventScripts(H2_EVENT_ON_CLIENT_LEAVE);
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
	object oPC = GetExitingObject();

    // Code executed for DMs and PCs goes here.

    if(GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        // Code only executed for DMs goes here.

        // log the departure
	    ACR_LogEvent(oPC, ACR_LOG_LOGOUT, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)));
    }
    else
    {
        // Code only executed for PCs goes here.

        // log the departure
    	ACR_LogOnExit(oPC);

        object oItem = GetFirstItemInInventory(oPC);
		// Commented this loop out for now, since we don't do anything there
		//
        //while(oItem != OBJECT_INVALID)
        //{
         //   // Code which executes on a PC's items goes here.
         //   oItem = GetNextItemInInventory();
        //}
		//
        // track resting across sessions
        ACR_RestOnClientLeave(oPC);
		
		// clean up Subdual mode leftovers
		ACR_NonLethalOnClientExit(oPC);
   	    ACR_SkillsOnClientExit(oPC);
    }
	
	ACR_PCOnClientLeave(oPC);
	
	// bank logged XP
	ACR_XPOnClientExit(oPC);

	// clean up chatlogging pointers
	ACR_ChatOnClientExit(oPC);
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
     DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oPC = GetExitingObject();
   
   CSLNWNX_SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +CSLDelimList(CSLInQs(SDB_GetSEID()), CSLInQs(SDB_GetPLID(oPC)), CSLInQs("O"), CSLInQs(CSLGetMyName(oPC)+" ("+CSLGetMyPlayerName(oPC)+") has logged out"), "0") + ")");
	
	CSLPlayerList_ClientExit(oPC);
	
   SDB_OnClientExit(oPC);
   
   //Speech_OnClientExit(oPC);
      
   SCDestroyUndead(oPC, TRUE); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
         
   //StoreUses(oPC);
    */
}

void CSLEvent_Mod_OnCutsceneAbort()
{

    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
     h2_RunModuleEventScripts(H2_EVENT_ON_CUTSCENE_ABORT);   
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetLastPCToCancelCutscene();

    // End the scrying effect for the PC aborting the cutscene
    if (ACR_GetIsScrying(oPC)) { ACR_ScryEnd(oPC); }
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
    
    */
}

void CSLEvent_Mod_OnEquipItem()
{
	object oItem = GetPCItemLastEquipped();
	object oPC   = GetPCItemLastEquippedBy();
	
	if (GetLocalInt(oPC, "LOADING")) { return; } // SKIP THIS IN THE PC-LOAD PHASE & WHEN POLYMORPHING
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_CLOAK && CSLStringStartsWith( GetTag(oItem), "steed", FALSE ) )
	{
		ExecuteScript("_mod_onmount", oPC );
		return;
	}
	
	cmi_player_equip( oPC );
	
	//CSLApplyItemProperties( oPC );
	DeleteLocalInt( oPC, "SC_ITEM_CACHED");
	DelayCommand( 0.5f, CSLCacheCreatureItemInformation( oPC ) );
	
	CSLEnviroEquip( oItem, oPC );
	
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////

	object oItem = GetPCItemLastEquipped();	
	h2_AddOnHitProperty(oItem);	
    h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_EQUIP_ITEM);    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////

    object oItem = GetPCItemLastEquipped();
	object oPC = GetPCItemLastEquippedBy();
	
	// handle equipped items.
    ACR_ItemOnEquip(oItem, oPC);
	
	// handle nonlethal damage modes
	ACR_NLD_OnWeaponSwitch(oPC, oItem);
    
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    	//OBJECT_SELF is assumed to be the module
	object oItem = GetPCItemLastEquipped();
	object oPC   = GetPCItemLastEquippedBy();
	
	SCUnlimAmmo_Equip(oPC, oItem);
	
	if (GetLocalInt(oPC, "LOADING")) return; // SKIP THIS IN THE PC-LOAD PHASE & WHEN POLYMORPHING
	
	DoStormWeapon(oPC, oItem); // supports the storm lord classes item properties, dex specific
      
	CSLBulletCastingCheck( oItem, oPC ); // does blocking and logging for when players are bullet casting
   
   // this enforces the dex rule which makes minotars have to wear leather armor, otherwise they look awful since tints don't match up
	if ( GetBaseItemType(oItem) == BASE_ITEM_ARMOR && GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		//AssignCommand( oPC, ActionUnequipItem(oItem) );
		CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "NW_CLOTH001", TRUE );
	}
   
   // this blocks the exploit where a players hit points are too high
   if ( CSLGetItemPropertyExists(oItem, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON))
   {
      int nHP = GetCurrentHitPoints(oPC);
      int nMaxHP = GetMaxHitPoints(oPC);
      if (nHP>nMaxHP * 3/2) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nMaxHP, DAMAGE_TYPE_MAGICAL), oPC);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
         SDB_LogMsg("MAXHP", "Too Many Hitpoints: max " + IntToString(nMaxHP) + " / cur " + IntToString(nHP), oPC);
         SendMessageToPC(oPC, "Your hitpoints are too high.");
      }
   }
	
	// this blocks the exploit where sacred fist damage is applied on weapon usage
   CSLSacredFlamesWeaponCheck( oItem, oPC );
   
   cmi_player_equip( oPC );
   //ExecuteScript("cmi_player_equip", OBJECT_SELF);
   
   // fix for missing hide attributes from items
   CSLApplyItemProperties( oPC );
   
   CSLEnviroEquip( oItem, oPC );
    
    */
    
     
}

void CSLEvent_Mod_OnHeartbeat()
{
	object oPC;
	oPC = GetFirstPC();
	while ( GetIsObjectValid( oPC ) )
	{
		
		checkHeartBeatElaborateParry( oPC );
		checkHeartBeatDeadlyDefense( oPC );
		checkHeartBeatTwoWeaponDefense( oPC );
		checkHeartBeatDervishParry( oPC );
		oPC = GetNextPC();
	}
	
	
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    int nSecond = GetTimeSecond();
	if (nSecond >= 0 && nSecond < 6)
	{
		h2_SaveCurrentCalendar();    
	}
    h2_RunModuleEventScripts(H2_EVENT_ON_HEARTBEAT);
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
	DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC;
	oPC = GetFirstPC();
	while ( GetIsObjectValid( oPC ) )
	{
		
		checkHeartBeatElaborateParry( oPC );
		checkHeartBeatDeadlyDefense( oPC );
		checkHeartBeatTwoWeaponDefense( oPC );
		checkHeartBeatDervishParry( oPC );
		oPC = GetNextPC();
	}
	
	*/
}

void CSLEvent_Mod_OnLevelup()
{
	object oPC = GetPCLevellingUp();
	
    SetLocalInt( oPC, "SC_HitDice", 0 );
    
    // kaedrins event 
     cmi_levelup( oPC );
     
    if ( GetHitDice(oPC) > 1 ) // this only happens on level 2 and above, it uses init on the first time when it inits
	{
		DelayCommand(0.05, ExecuteScript("_mod_onlanguagelevelup", oPC));
	}
	
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
	object oPC = GetPCLevellingUp();
	string sLevelUpLog = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_LOG_PLAYER_LEVELUP + IntToString(GetHitDice(oPC));
    h2_LogMessage(H2_LOG_INFO,sLevelUpLog);							
    h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_LEVEL_UP);	
	if (H2_EXPORT_CHARACTERS_INTERVAL > 0.0)
		ExportSingleCharacter(oPC);
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetPCLevellingUp();

    // handle the level up attempt
    ACR_ProcessLevelUpAttempt(oPC);
	
	// apply any hidden skill changes  
	ACR_SkillsOnPCLevelUp(oPC);

	// apply extra languages if necessary
	ACR_LanguagesOnLevelUp(oPC);
	
    // log the level up attempt
    ACR_LogEvent(oPC, ACR_LOG_LEVELUP, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + ", Level: " + IntToString(GetHitDice(oPC)));

    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
       object oPC = GetPCLevellingUp();
   SetLocalInt( oPC, "SC_HitDice", 0 );
   
   int iLevel = GetHitDice(oPC);
	
   SDB_OnPCLevelUp(oPC);
	
   cmi_levelup( oPC );
   
   string sMsg = CSLColorText(GetName(oPC)+" has advanced to level "+ IntToString(iLevel), COLOR_GREEN);
   FloatingTextStringOnCreature(sMsg, oPC);
   if ( GetHitDice(oPC)==30-CSLGetRaceDataECLCap( GetSubRace(oPC) ))
   {
      int nXP = SDB_GetPCBankXP(oPC);
      sMsg = CSLSexString(oPC, "He", "She");
      sMsg = CSLColorText("All Hail " + GetName(oPC)+" the " + CSLGetSubraceName(GetSubRace(oPC)) + "! " + sMsg + " has attained max level " + IntToString(iLevel) + " and claimed " + IntToString(nXP) + " cached XP.", COLOR_CYAN);
      CSLShoutMsg(sMsg);
   }
   else if (iLevel % 5 == 0)
   {
      CSLShoutMsg(sMsg);
   }
	
	// this gives a special item at level 13, did this for hallween one year
	//if ( iLevel == 13 && !CSLHasItemByTag(oPC, "dex_skullhelm") )
	//{
	//	SendMessageToPC(oPC, "HAPPY HALLOWEEN! You have hit the unlucky level, and as such get a special halloween mask on this unlucky day.");
	//	
	//	object oMask = CreateItemOnObject("dex_skullhelm", oPC, 1);    // Skull Helm
	//	SetIdentified(oMask, TRUE);
	//	DelayCommand( 6.0f, AssignCommand(oPC, ActionEquipItem(oMask, INVENTORY_SLOT_HEAD)));
	//}
	
	
	// ExecuteScript( "cmi_player_levelup", OBJECT_SELF );
	
	
   if (!GetHasFeat(FEAT_EPITHET_SHADOWTHIEFAMN, oPC))
   {
      int nBluff = GetSkillRank(SKILL_BLUFF, oPC, TRUE);
      int nHide = GetSkillRank(SKILL_HIDE, oPC, TRUE);
      int nMoveSilent = GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE);
      int nInitimidate = GetSkillRank(SKILL_INTIMIDATE, oPC, TRUE);
      int bStealthy = GetHasFeat(FEAT_STEALTHY, oPC);
      if (nBluff>=3 && nHide>=8 && nMoveSilent>=3 && nInitimidate>=3 && bStealthy)
      {
         FeatAdd(oPC, FEAT_EPITHET_SHADOWTHIEFAMN, FALSE);
         FloatingTextStringOnCreature("You have been contacted by the Shadow Thieves about joining the guild.", oPC);
      }
   }

    
    */
}

void CSLEvent_Mod_OnModuleLoad()
{
	SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
	SetModuleSwitch(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, TRUE);
	SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
	SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
		
	SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", IntToString( Random(5)+1) );
	SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NW_FACTION", IntToString( Random(5)+1) );
	
	//	SetModuleOverrideSpellscript("_mod_spell_overides"); // THIS RUNS BEFORE ANY SPELL IS CAST AND ALLOWS YOU TO ABORT THE CALL
	SetModuleOverrideSpellscript("_SCDexSpellHooks"); // THIS RUNS BEFORE ANY SPELL IS CAST AND ALLOWS YOU TO ABORT THE CALL
	
	SetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_PLAYER", 0 );
	SetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_TESTER", 0 );
	
	SetLocalInt( GetModule(), "CSL_HIDEDMONINVIS", TRUE );
	
	SetLocalInt( GetModule(), "SC_MPINVISFIX", FALSE );

    SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
	
	DelayCommand( 1.0f, CSLsetTimeBasedOnRealTime()  );
	
	CSLEnviroGetControl();
	
	DelayCommand(3.0f, SCLoadDataObjects() ); // loads the data objects in the module
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
    object oMod = GetModule();	//Turn on Debug and 
	h2_CreateDataPoint(H2_CORE_DATA_POINT);	
	if (GetName(oMod) == "HCR2_TEST")
		h2_SetModLocalInt(H2_LOGLEVEL, H2_LOG_DEBUG); 
	else
		h2_SetModLocalInt(H2_LOGLEVEL, H2_DEFAULT_LOGLEVEL);
		
	h2_LogMessage(H2_LOG_INFO, H2_TEXT_USING_PERSISTENCE + H2_PERSISTENCE_SYSTEM_NAME);    	
	h2_InitializeDatabase();
    h2_CopyEventVariablesToCoreDataPoint();    
	h2_CreateDataPoint(H2_FEATUSES_DATA_POINT);
	//h2_SetUpFeatUsesData may cause a TMI timeout 
	//if not used w/ DelayCommand
	DelayCommand(0.0, h2_SetUpFeatUsesData());
	
	if (GetName(oMod) == "HCR2_TEST")
	{	//Set up some testing data and events.		
		int index = 1;
	    string scriptname = h2_GetModLocalString(H2_EVENT_ON_MODULE_LOAD + IntToString(index));
	    while (scriptname != "")
	    {        
	        index++;
	        scriptname = h2_GetModLocalString(H2_EVENT_ON_MODULE_LOAD + IntToString(index));
	    }
		h2_SetModLocalString(H2_EVENT_ON_MODULE_LOAD + IntToString(index), "test_moduleload");
		h2_LogMessage(H2_LOG_DEBUG,"Added test_moduleload");
	}
	
    h2_RestoreSavedCalendar();
    h2_SaveServerStartTime();
    h2_StartCharExportTimer();	
	
	LoadClass2DAData();
	LoadSkill2DAData();	
	
    h2_RunModuleEventScripts(H2_EVENT_ON_MODULE_LOAD);
	
	SetGlobalInt("bNX2_TRANSITIONS", TRUE);
	string sOverrideSpellScript = GetLocalString(oMod, MODULE_VAR_OVERRIDE_SPELLSCRIPT);
	//This is placed AFTER the RunModuleEventScripts in case some moduleload event script tried to re-assigned this value.	
	SetLocalString(oMod, MODULE_VAR_OVERRIDE_SPELLSCRIPT, H2_SPELLHOOK_EVENT_SCRIPT);		
	if (sOverrideSpellScript !=  "" && sOverrideSpellScript != H2_SPELLHOOK_EVENT_SCRIPT)
	{	//log a warning that some system tried to reset the value.
		h2_LogMessage(H2_LOG_WARN, "Some subsystem attempted to reset the MODULE_VAR_OVERRIDE_SPELLSCRIPT to: " + sOverrideSpellScript +
			". This has been reset to the proper value needed by HCR2, but you should look over your OnModuleLoadX scripts and determine if " + 
			sOverrideSpellScript + " needs to be added as an OnSpellHookX module variable.");
	}

    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
	object oModule = GetModule();
    
    // ORDER MATTERS !!

    // Start the debuging system and create debugging ids for the module event scripts
    ACR_InitializeDebugging();
    ACR_CreateDebugSystem(_ONLOAD_DEBUG, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB);
    string sServerId = IntToString(ACR_SERVER_ID);
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA " + sServerId + " loading version " + ACR_VERSION + " of the ALFA Core Rules.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Check NWNX status
    if (! CSLNWNX_Installed())
    {
        // record the status
        ACR_SetModuleStatus(ACR_MOD_NWNX_FAILED);
        ACR_PrintDebugMessage("acr_mod_events_i: NWNX unavailable on ALFA server " + sServerId + ". Rescheduling OnModuleLoad(). Server restart may be required.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);

        // reschedule the OnModuleLoad() handler
        DelayCommand(ACR_MOD_RELOAD_CYCLE, ACR_ModuleOnModuleLoad());
        return;
    }
	else
	{
		// create the SQL tables if need be
		ACR_CreateSQLTables();
	}	

    // Initialize spell hook
    SetLocalString(oModule, "X2_S_UD_SPELLSCRIPT", "acr_spellhook");

    // Initialize storage objects used by many systems.
    // ACR_InitializeStorageObjects();

    // Initialize game engine constants.
    //ACR_InitializeGameConstants();

    // Initialize the spawn system.
    ACR_InitializeSpawns();

    // Initialize the time system.
    ACR_InitializeTime();
//    ACR_PrintDebugMessage("acr_mod_events_i: Starting date: " + GetDateAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
//    ACR_PrintDebugMessage("acr_mod_events_i: Sarting time: " + GetTimeAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
    ACR_PrintDebugMessage("acr_mod_events_i: Time compression ratio: " + FloatToString(ACR_GetGameToRealTimeRatio()), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Initialize one-time PC status setups
    ACR_PCOnModuleLoad();

    // Recreate player corpses
    ACR_RestoreCorpsesOnModuleLoad();

    // Set bioware/obsidian module switches as desired:
    SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);
    //SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
    SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);

	string sSID = IntToString(ACR_SERVER_ID);
	// grab the server name from the module properties so it will be updated.
	string sServerName = GetName(oModule);
    // check that the server information is in the database
    ACR_SQLQuery("SELECT * FROM servers WHERE ID=" + sSID);

    // create the record if it does not already exist
    if (ACR_SQLFetch() != CSLSQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO servers (ID, Name, IPAddress) VALUES(" + sSID + ",'" + ACR_SQLEncodeSpecialChars(sServerName) + "','" + ACR_SERVER_IP + "')"); 
    }
	else
	{	
		// update server name and ip address if they've changed
		if (ACR_SQLGetData(1) != sServerName || ACR_SQLGetData(2) != ACR_SERVER_IP)
		{
			ACR_SQLQuery("UPDATE servers SET Name='" + ACR_SQLEncodeSpecialChars(sServerName) + "', IPAddress='" + ACR_SERVER_IP + "' WHERE ID=" + sSID);
		}
	}

    // clear all online statuses
    ACR_SQLQuery("UPDATE characters SET IsOnline=0");
	
	// Initialize chatlogging buffer
	ACR_InitializeChat();

    // This should be the last time in this function.
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA server " + sServerId + " loaded.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    	DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
	SetModuleSwitch(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, TRUE);
	SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
	SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
		
	SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", IntToString( Random(5)+1) );
	SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NW_FACTION", IntToString( Random(5)+1) );
	
	//	SetModuleOverrideSpellscript("_mod_spell_overides"); // THIS RUNS BEFORE ANY SPELL IS CAST AND ALLOWS YOU TO ABORT THE CALL
	SetModuleOverrideSpellscript("_SCDexSpellHooks"); // THIS RUNS BEFORE ANY SPELL IS CAST AND ALLOWS YOU TO ABORT THE CALL
	// same as the above, you can set the following in the module properties directly
	//SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "_SCDexSpellHooks");
	// set up the messages system
	// Change this to 7-9 to see lot of debug data, plan on making this settable via dialog later
	SetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_PLAYER", 0 );
	SetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_TESTER", 0 );
	SetLocalInt( GetModule(), "SC_MPINVISFIX", FALSE );
	//DelayCommand( 30.0, SetEventHandler( GetModule(), SCRIPT_MODULE_ON_HEARTBEAT, "_SCModule_Heartbeat") );
	
	// * Item Event Scripts: Check "x2_it_example.nss" for an example.
	SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
	
	DelayCommand( 1.0f, CSLsetTimeBasedOnRealTime()  );
	
	CSLEnviroGetControl();
	
	
	DelayCommand(30.0f, CSLServerRebootTimer(SDB_GetSEID(), TRUE));
	DelayCommand(60.0f, BootInactivePlayers());
	DelayCommand(10.0f, SCMakeThemWalk());
	//SCMakeThemWalk(); // CREATURES WANDER AROUND THEIR AREA
	DelayCommand(10.0f, ExecuteScript("_mod_onmoduleloaddata", OBJECT_SELF) );
	
	ExecuteScript("nwnx_craft_set_constants", GetModule() );
	
	SDB_OnModuleLoad();
	DelayCommand(2.0f, SDB_FactionOnModuleLoad() );
	
	SetLocalString(GetModule(), "SERVERMSG", GetServerMsg());
	
	object oClancy = GetObjectByTag("QUEST_LOFT");
	//SetLocalString(oClancy, "QU_AWARDITEM", "dex_bootsvelocity");
	
	CSLAssignMainShouter(oClancy);
	ExecuteScript("towngossip", oClancy);

	DestroyObject(GetObjectByTag("loftpond_fakebridge"));
    
    */
}

void CSLEvent_Mod_OnModuleStart()
{
	//CSLSetupModuleEvents();
    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
    
    */
}

void CSLEvent_Mod_OnPCLoaded()
{
	object oPC = GetEnteringObject();
	
	if ( GetIsDM( oPC ) && CSLGetPreferenceSwitch( "HideDMInChat", FALSE) )
	{
		if ( CSLGetPreferenceSwitch( "HideDMInChatOnDMHidden", FALSE) )
		{
			CSLPlayerList_SetHidden( oPC, TRUE  );
		}
	}
	
	if (GetActionMode(oPC, 24) == TRUE)
	{
		SetActionMode(oPC, 24, FALSE);
		SetActionMode(oPC, 24, TRUE);		
	}
	
	DelayCommand(3.0, SCDestroyUndead(oPC, TRUE) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM, this is dex specific but blocks an exploit
	
	CSLPlayerList_ClientEnter(oPC);
	CSLSetChatMessenger( "DM_GHOST" );
	
	// kaedrins events
	cmi_pc_loaded( oPC );
	
	
	if ( CSLGetIsDM(oPC, TRUE) || GetIsSinglePlayer() )
	{
		SetLocalInt(oPC, "CSL_UseTrueDMCasterLevel", FALSE ); // sets the dm to use their actual level, normally it sets to have dm's cast spells at level 60
		CSLShowDMBar( oPC );
	}
	DisplayGuiScreen(oPC, "SCREEN_GUI_CONTROL", FALSE, "uicontrol.XML"); 
	
	DelayCommand(2.5, DMFI_ClientEnter(oPC) );
	
	DelayCommand(0.05, ExecuteScript("_mod_onlanguageinit", oPC));
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetEnteringObject();
	if (GetLocalInt(oPC, H2_LOGIN_BOOT))
	{
		string sBootMessage = GetLocalString(oPC, H2_BOOT_MESSAGE);
		SendMessageToPC(oPC, sBootMessage);
        return;
	}
	int bIsDM = GetIsDM(oPC);

    if (!H2_READ_CHECK)
        SendMessageToPC(oPC, H2_TEXT_SETTINGS_NOT_READ);
    else
        SendMessageToPC(oPC, H2_TEXT_ON_LOGIN_MESSAGE);
    
	string sCurrentGameTime = h2_GetCurrentGameTime(H2_SHOW_DAY_BEFORE_MONTH_IN_LOGIN);		
	SendMessageToPC(oPC, sCurrentGameTime);
	h2_LogInPC(oPC);
    if (!bIsDM)    
        h2_InitializePC(oPC);    
 
    h2_RunModuleEventScripts(H2_EVENT_ON_PC_LOADED);
	
	//Do this after pcloaded hook-in scripts are executed. in case one of them 
	//added a skin already
	h2_AddPlayerSkin(oPC);
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events /////////////
    ///////////////////////////////////////////////
    
	object oPC = GetEnteringObject();
	
	// process DMs
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
	    if (GetItemPossessedBy(oPC, "abr_spawn_debug") == OBJECT_INVALID) { CreateItemOnObject("acr_spawn_debug", oPC); }
		if (GetItemPossessedBy(oPC, "acr_dcsetter") == OBJECT_INVALID) { CreateItemOnObject("abr_it_dmdcsetter", oPC); }
		ExecuteScript("dmfi_mod_pcload", GetModule());
    }
	// process players
    else
    {
		int bSave = FALSE;
		
        // PC has Wizard levels, issue them a spellbook if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "ARCANE")) {
		    if (!ACR_GetPersistentInt(oPC, ACR_MOD_SPELLBOOK)) {
			    bSave = TRUE;
                SetIdentified(CreateItemOnObject(ACR_MOD_SPELLBOOK_RESREF, oPC), TRUE);
                ACR_SetPersistentInt(oPC, ACR_MOD_SPELLBOOK, TRUE);
			}
        }
        // PC has Cleric/Ranger/Druid levels, issue them a holy symbol if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "DIVINE")) {
		    if  (!ACR_GetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL)) {
				bSave = TRUE;
            	SetIdentified(CreateItemOnObject(ACR_MOD_HOLYSYMBOL_RESREF, oPC), TRUE);
            	ACR_SetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL, TRUE);
			}    
        }
		if (!ACR_GetPersistentInt(oPC, ACR_MOD_STARTINGGOLD))
		{
		    GiveGoldToCreature(oPC, 300);
			ACR_SetPersistentInt(oPC, ACR_MOD_STARTINGGOLD, TRUE);
			bSave = TRUE;
	    }
		if ((GetXP(oPC) <= 1) && !ACR_GetPersistentInt(oPC, ACR_MOD_STARTARMORX))
		{
		    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
			ACR_SetPersistentInt(oPC, ACR_MOD_STARTARMORX, TRUE);
			bSave = TRUE;
	    }
		if (!ACR_GetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT))
		{
		    SetIdentified(CreateItemOnObject(ACR_MOD_HEALKIT_RESREF, oPC), TRUE);
			ACR_SetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT, TRUE);
			bSave = TRUE;
		}

		// DO THIS FIRST
		// restore the player's status and location
    	ACR_PCOnPCLoaded(oPC);

		// process dead players
		ACR_DeathOnPCLoaded(oPC);

        // rebuild the characters journal quest entries
        ACR_RebuildJournalQuestEntries(oPC);
		
		// queue up the skillpoint convo if it's an unconverted PC
		ACR_SkillsOnPCLoaded(oPC);

		// save the bic if inventory has been modified
		if (bSave) { ACR_PCSave(oPC, FALSE); }
							
	    // Initialize nonlethal damage system for the PC
	    DelayCommand(4.0, ACR_NLD_OnPCLoaded(oPC));
	
		//  only do this if the PC is already adapted to custom skills.
		if (GetSkillRank(0, oPC, TRUE) == 2) {
			// Initialize DMFI for the entering player or DM
			ExecuteScript("dmfi_mod_pcload", GetModule());
			// initialize/award RP XP, start this after the PC is already in.
			DelayCommand(30.0, ACR_XPOnClientLoaded(oPC));
			// process simulated rest (spell uses handled accordingly)
			//  delay this long enough for the status restore to take effect for HP.
        	DelayCommand(1.5, ACR_RestOnClientEnter(oPC));
		}
	}    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    object oPC = GetEnteringObject();
   
   if ( GetIsDM( oPC ) )
   {
	   CSLPlayerList_SetHidden( oPC, TRUE  );
   }
   
   if ( CSLGetIsDM(oPC, TRUE) )
   { 
	   DEBUGGING = 9;//GetLocalInt( GetModule(), "DEBUGLEVEL" );
   }
   else
   {
	   DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   }
   
   SendMessageToPC( oPC, "Running the PC Loading Script");
   
   DelayCommand( 0.1f, SCFixFeats(oPC) );
   DelayCommand( 60.0, CSLRemoveOrphanedEffects(oPC) );
    
   string sName = CSLGetMyName(oPC);
   string sIPAddress = CSLGetMyIPAddress(oPC);
   string sPublicCDKey = CSLGetMyPublicCDKey(oPC);
   string sPlayerName = CSLGetMyPlayerName(oPC);
   
   string sFactionName = SDB_FactionGetName( SDB_GetFAID( oPC ) );
   
   //SendMessageToPC( oPC, "1");
   DelayCommand( 12.0f, CSLCleanCharacterText( oPC ) );  
   
   if (sName=="") sName = GetName(oPC);
   if (sPublicCDKey=="") sPublicCDKey = GetPCPublicCDKey(oPC);
   if (sPlayerName=="") sPlayerName = GetPCPlayerName(oPC);
   if (sIPAddress=="") sIPAddress = GetPCIPAddress(oPC);
   
   DelayCommand(3.0, SCDestroyUndead(oPC, TRUE) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
	if (!GetIsSinglePlayer())
	{
   		if (sName=="")
   		{
   			SCBooter(oPC, "Name is missing");
   			return;
   		}
   		if (sPublicCDKey=="")
   		{
   			SCBooter(oPC, "PublicCDKey is missing");
   			return;
   		}
   		if (sPlayerName=="")
   		{
   			SCBooter(oPC, "PlayerName is missing");
   			return;
   		}
   		if (sIPAddress=="")
   		{
   			SCBooter(oPC, "IP Address is missing");
   			return;
   		}
   		
   		if ( CSLIsCharacterFirstClassValid( oPC ) == FALSE)
		{
		 	CSLNWNX_SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" + CSLDelimList(CSLInQs(SDB_GetSEID()), CSLInQs(SDB_GetPLID(oPC)), CSLInQs("L"), CSLInQs(sName+" ("+sPlayerName+") is invalid" ), "0") + ")");
			SCBooter(oPC, "Your character is Invalid"); 
		}
   		
	}
	else
	{
		SetLocalInt( oPC, "SC_TESTER", TRUE );
	}   

   SetLocalString(oPC, "MyName", sName);
   SetLocalString(oPC, "IPAddress", sIPAddress);
   SetLocalString(oPC, "PublicCDKey", sPublicCDKey);
   SetLocalString(oPC, "PlayerName",  sPlayerName);
   
   
   SendMessageToPC( oPC, "3");
	if (CSLNWNX_Installed())
	{
		SCLogInMessage(oPC, "NWNX4 Installed and Running...");
		SDB_OnClientEnter(oPC);
		SDB_FactionOnClientEnter(oPC);
		
		if (SDB_GetCKID(oPC)=="1") // seed
		{
			SetLocalObject(GetModule(), "IAMSEED", oPC);  
		}  
		if (SDB_GetCKID(oPC)=="3400") // pain
		{
			//SetLocalObject(GetModule(), "IAMSEED", oPC);  
			SetLocalInt( oPC, "SC_TESTER", TRUE );
			SetLocalObject(GetModule(), "IAMPAIN", oPC);  
		}
		
		string sPlayerID = SDB_GetPLID(oPC);
		SetLocalString(oPC, "PlayerID",  sPlayerID ); // unique identifier for use later in the database
		
		int nBankGold = SDB_GetBankGold(oPC);
		int nBankXP = SDB_GetBankXP(oPC);
		if (nBankGold) SCLogInMessage(oPC, "<color=yellow>Your bank account contains " + IntToString(nBankGold) + " gold.</color>", 12.0);
		if (nBankXP) SCLogInMessage(oPC, "<color=limegreen>Your bank account contains " + IntToString(nBankXP) + " XP.</color>", 13.0);
		
		int nPCBankGold = SDB_GetPCBankGold(oPC);
		int nPCBankXP = SDB_GetPCBankXP(oPC);
		if (nPCBankGold) SCLogInMessage(oPC, "<color=yellow>Your PC Gold Cache contains " + IntToString(nPCBankGold) + " gold.</color>", 12.0);
		if (nPCBankXP) SCLogInMessage(oPC, "<color=limegreen>Your PC XP Cache contains " + IntToString(nPCBankXP) + " XP.</color>", 13.0);
		
		
		
		
		SCLogInMessage(oPC, "You have joined DEX Session #" + SDB_GetSEID() + ".", 8.0);
		SCLogInMessage(oPC, "The DEX ID for this character is " + sPlayerID + ".", 9.0);
		SCLogInMessage(oPC, "Visit www.dungeoneternal.com for PvP stats on this character.", 10.0);
		
		if ( SDB_GetIsShoutBanned(oPC) )
		{
			CSLSetIsShoutBanned( oPC );
		}
		
		
		CSLNWNX_SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" + CSLDelimList(CSLInQs(SDB_GetSEID()), CSLInQs(SDB_GetPLID(oPC)), CSLInQs("L"), CSLInQs(sName + " (" + sPlayerName + ") has logged in" ), "0") + ")");
	
	}
	else
	{
		SCLogInMessage(oPC, "NWNX4 Is NOT Running...");
		
		SCLogInMessage(oPC, "Welcome to Dex in Single Player, Visit www.dungeoneternal.com for for more info.", 9.0);
		
		SetLocalString(oPC, "PlayerID",  CSLGetCreatureIdentifier(oPC)  );
		
	}
	CSLPlayerList_ClientEnter(oPC);
	CSLSetChatMessenger( "DM_GHOST" );
	
	//   if (!CSLHasItemByTag(oPC, "EL_ESTHETIC_CRAFTER")) CreateItemOnObject("el_esthetic_crafter", oPC); // GIVE IF NOT THERE
	
	 
	if ( GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "nw_cloth015", TRUE );
	}
	
	SendMessageToPC( oPC, "5");
	if (!GetXP(oPC) && !CSLGetIsDM(oPC, FALSE))  // CHECK IF NEW CHARACTER
	{
		SetXP(oPC, 1);
		GiveGoldToCreature(oPC, 500);
		CreateItemOnObject("stone_loftenwood", oPC, 1);    // Loftenwood Stone
		CreateItemOnObject("csl_torch", oPC, 1);      // TORCH
		object oGuide = CreateItemOnObject("bookofthenoob", oPC, 1);      // NOOB GUIDE
		CreateItemOnObject("nw_aarcl002", oPC, 1);         // STUDDED LEATHER
		CreateItemOnObject("nw_wdbqs001", oPC, 1);         // QUARTERSTAFF
		CreateItemOnObject("nw_wbwxl001", oPC, 1);         // LIGHT CROSSBOW
		CreateItemOnObject("nw_wambo001", oPC, 50);        // BOLTS
		object oMap = CreateItemOnObject("Dex_dexmap", oPC, 1);          // map of dex
		SetIdentified(oMap, TRUE);
		SetIdentified(oGuide, TRUE);
		CreateItemOnObject("curepotion", oPC, 5);    // 5 EXILIR OF CURING
		
		SCLogInMessage(oPC, "Welcome to DungeonEternalX!\n.You have been given 500 gold, a Loftenwood Port Stone, and some basic gear.\nYou have been given a book in your inventory that explains some things about the module.", 3.0);
		
		if ( !GetIsSinglePlayer() )
		{
			DelayCommand(6.0, CSLMsgBox(oPC, "DEX is a full PvP module. When you get killed don't get mad, get even.", "I Agree"));
		}
	}
	
	if ( CSLGetIsDM(oPC, TRUE) || GetIsSinglePlayer() )
	{
		CSLShowDMBar( oPC );
		
		SendMessageToPC( oPC, "Your CD Key is "+sPublicCDKey );
		
		CSLCreateSingleItemOnObject("dmsco", oPC, 1, "dmsco");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("dmrco", oPC, 1, "dmsco");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("stone_loftenwood", oPC, 1, "townstone");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("bindstone", oPC, 1, "bindstone");    // Loftenwood Stone
		//StoneCreate(oPC, "stone_skill", "Skill Stone", "SMS_SKILL");
		CSLCreateSingleItemOnObject("dex_trollheart", oPC, 5, "dex_trollheart");          // map of dex
		
		//StoneCreate(oPC, "stone_masscrit", "Stone of MassCrit Damage", "SMS_MASSCRIT");
		object oMap = CSLCreateSingleItemOnObject("dex_dexmap", oPC, 1, "dex_dexmap");          // map of dex
		SetIdentified(oMap, TRUE);
		
	}
	SetHasPrayed(oPC, TRUE);
	DisplayGuiScreen(oPC, "SCREEN_GUI_CONTROL", FALSE, "uicontrol.XML"); 
	// CloseGUIScreen(oPC, "SCREEN_MINIMAP");
	//SendMessageToPC( oPC, "7");
	DelayCommand(0.2, SCReQuip(oPC, INVENTORY_SLOT_BOOTS));
	DelayCommand(0.4, SCReQuipHands(oPC));
	DelayCommand(0.6, SCReQuip(oPC, INVENTORY_SLOT_LEFTRING));
	DelayCommand(0.8, SCReQuip(oPC, INVENTORY_SLOT_RIGHTRING));
	
	//RemoveEffectsFromSpell(oPC, SPELL_AID);
	//RemoveEffectsFromSpell(oPC, SPELL_BLESS);
	//RemoveEffectsFromSpell(oPC, SPELL_HASTE);
	
	//Want to destroy their book and replace it with the latest revision
	//void SCCheckInv(object oPC) {
	//object oItem = GetFirstItemInInventory(oPC);
	//while (GetIsObjectValid(oItem)) {
	//   if (GetResRef(oItem)=="bookofthenoob") {
	//      DestroyObject(oItem, 0.1);
	//   }
	//oItem = GetNextItemInInventory(oPC);
	//}
	//CreateItemOnObject("bookofthenoob", oPC, 1);      // NOOB GUIDE
	
	
	//SendMessageToPC( oPC, "8");
	DelayCommand(1.0, SCRemoveTempWeaponBuffs(oPC));
	//DelayCommand(2.0, RestoreUses(oPC));
	DeleteLocalInt (oPC, "LASTREST"); // THEY CAN REST AGAIN AFTER A LOGIN
	//SendMessageToPC( oPC, "9");
	object oParty = CSLGetParty(oPC); // IF THEY HAVE A PARTY STORED ON THEM, REJOIN IN CASE OF CRASH
	if (oParty!=OBJECT_INVALID)
	{
		DelayCommand(4.0,AddToParty(oPC, oParty) );
		SendMessageToPC(oPC, "Welcome back! You have rejoined your party.");
	}
	//SendMessageToPC( oPC, "10");
	DelayCommand(5.0,SCCheckInv(oPC));
	
	//DelayCommand(2.5, DMFI_ClientEnter(oPC) );

	
    
    */
}

void CSLEvent_Mod_OnPlayerDeath()
{

    object oKilled = GetLastPlayerDied();
	object oKiller = CSLGetKiller(oKilled);
	object oArea = GetArea(oKilled);
	

    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////

    object oPC = GetLastPlayerDied();
	SetLocalLocation(oPC, H2_LOCATION_LAST_DIED, GetLocation(oPC));
    h2_SetPlayerState(oPC, H2_PLAYER_STATE_DEAD);
    h2_RemoveEffects(oPC);
    object oKiller = GetLastHostileActor(oPC);
	string sDeathLog = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_LOG_PLAYER_HAS_DIED;
    sDeathLog += GetName(oKiller);
    if (GetIsPC(oKiller))
        sDeathLog += "_" + GetPCPlayerName(oKiller);
    sDeathLog += H2_TEXT_LOG_PLAYER_HAS_DIED2 + GetName(GetArea(oPC));
    h2_LogMessage(H2_LOG_INFO, sDeathLog);
    h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_DEATH);    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oDead = GetLastPlayerDied();
    object oKiller = GetLastHostileActor();

	// *** check for disguises here - player names need to be restored for proper data logging on death ***
	
    // process the player death
    ACR_PlayerOnDeath(oDead, oKiller);
	// logging handled in ACR_PlayerOnDeath() - so we don't log false-positives from instakill protection.
	ACR_NLD_OnDeath(oDead);
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
	DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oKilled = GetLastPlayerDied();
	object oKiller = CSLGetKiller(oKilled);
	object oArea = GetArea(oKilled);
	
	//if ( GetIsSinglePlayer() )
	//{
	//	trainerDeath( oKilled );
	//	return;
	//}
	


	if ( SDB_GetARID(oArea)=="1" && !CSLGetIsDM( oKiller ) )  // LOFTENWOOD DEATH
	{ 
		SCRaise( oKilled );
		if ( oKiller==oKilled || SDB_GetMOID(oKiller)=="517" )
		{
			return;
		}
		object oPC = GetLocalObject(oKiller, "DOMINATED");
		if ( oPC != OBJECT_INVALID )
		{
			AssignCommand(oKilled, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
		}
		AssignCommand(oKilled, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oKiller));
	}   
	
	// EXPLODE THEM
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L.sef"), oKilled);
	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1.sef"), oKilled));
	
	SCDestroyUndead(oKilled); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
	
	if ( SCGetIsInArena(oKilled) )
	{ // NO PENALTY
		SCShowArenaDeathScreen(oKilled);
		return;
	}
	
	if ( GetLocalInt( oArea, "SC_AREABASH" ) == 1 )
	{ // NO PENALTY
		DelayCommand( 60.0f, SCRaise(oKilled) );
		SCShowBashDeathScreen(oKilled);
		return;
	}
	
	
	int nDeaths = SDB_OnPCDeath(oKilled, oKiller); // FUNCTION RECORDS THE DEATH AND RETURN THE NUMBER OF TIMES THEY DIED
	SDB_FactionOnPCDeath(oKilled, oKiller); // RECORD THE FACTION KILL
	
	SCKillShoutAndSpreeBonus(oKiller, oKilled); // SHOUTS AND SPREE BONUSES
	SetLocalObject(oKilled, "LASTKILLER", oKiller); // SAVE IT FOR LATER
	DropDeathGold(oKiller, oKilled);
	
	DelayCommand(2.5f, ShowDeathScreen(oKilled));
	
	if (d4()==1) SCStealItem(oKiller, oKilled);
	
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann201", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann202", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann203", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann204", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann205", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann206", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann207", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann208", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann209", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann210", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann211", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann212", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann213", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann214", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann215", oKilled, TRUE ) );
	DelayCommand(CSLRandomBetweenFloat(0.5f, 2.0f), CSLDropItem("nw_it_bann216", oKilled, TRUE ) );

    
    */
}

void CSLEvent_Mod_OnPlayerDying()
{

    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////

    object oPC = GetLastPlayerDying();
    if (h2_GetPlayerState(oPC) != H2_PLAYER_STATE_DEAD)
        h2_SetPlayerState(oPC, H2_PLAYER_STATE_DYING);
    h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_DYING);    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////

    object oDying = GetLastPlayerDying();
    object oAttacker = GetLastAttacker();

    // process the player dying
    ACR_PlayerOnDying(oDying, oAttacker);
    
    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
    
    */
}

void CSLEvent_Mod_OnPlayerRespawn()
{

    
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetLastRespawnButtonPresser();    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
    
    */
}

void CSLEvent_Mod_OnPlayerRest()
{
	object oPC = GetLastPCRested();
	int iCharState = GetLocalInt(oPC, "CSL_CHARSTATE");
	int iAreaState = GetLocalInt(oPC, "CSL_ENVIRO");
	
	// this is just a safety check, depending on how things are set up, this may or may not block rests for you
	if ( !GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))) )
	{
		SCStopResting(oPC, "Invalid Area.");
		return;
	}
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
        object oPC = GetLastPCRested();
	if (H2_EXPORT_CHARACTERS_INTERVAL > 0.0)
		ExportSingleCharacter(oPC);
		
    int nRestEventType = GetLastRestEventType();    
    object oPM;
	switch (nRestEventType)
    {
        case REST_EVENTTYPE_REST_STARTED:
			oPM = GetFirstFactionMember(oPC, FALSE);
			while (GetIsObjectValid(oPM))
			{
				if (!GetIsPC(oPM) || oPM == oPC)
				{
					h2_SetAllowRest(oPM, TRUE);
		            h2_SetAllowSpellRecovery(oPM, TRUE);
					h2_SetAllowFeatRecovery(oPM, TRUE);
		            h2_SetPostRestHealAmount(oPM, GetMaxHitPoints(oPM));            
		        }
				oPM = GetNextFactionMember(oPM, FALSE);
			}                
            h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_REST_STARTED);
            if (h2_GetAllowRest(oPC) && !GetLocalInt(oPC, H2_SKIP_REST_MESSAGEBOX))			              
				h2_DisplayRestMessageBox(oPC);			
            else if (!h2_GetAllowRest(oPC))
            {
                SetLocalInt(oPC, H2_SKIP_CANCEL_REST, TRUE);
                AssignCommand(oPC, ClearAllActions());
                SendMessageToPC(oPC, H2_TEXT_REST_NOT_ALLOWED_HERE);
            }
            DeleteLocalInt(oPC, H2_SKIP_REST_MESSAGEBOX);
            break;
        case REST_EVENTTYPE_REST_CANCELLED:
			if (!GetLocalInt(oPC, H2_SKIP_CANCEL_REST))
                h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_REST_CANCELLED);
            DeleteLocalInt(oPC, H2_SKIP_CANCEL_REST);
            break;
        case REST_EVENTTYPE_REST_FINISHED:
			if (h2_GetAllowSpellRecovery(oPC))
			{
				h2_SavePCSpellsAvailable(oPC);
				DeleteLocalString(oPC, H2_SPELL_TRACK);
				DeleteLocalString(oPC, H2_SPELL_TRACK_SP);
			}
            h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_REST_FINISHED);
            break;
    }
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oPC = GetLastPCRested();
    int nRestState = GetLastRestEventType();

    ACR_OnPlayerRest(oPC, nRestState);

    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
      // Script Settings (Variable Declaration)
  int nLevelAffected = 5;   // The min. PC Level at which the Rest-restrictions will be applied
  int nRestDelay = 2;       // The ammount of hours a player must wait between Rests
  int nHostileRange = 20;   // The radius around the players that must be free of hostiles in order to rest.

   // Variable Declarations
   object oPC = GetLastPCRested(); // THIS SCRIPT ONLY AFFECTS PLAYER CHARACTERS. FAMILIARS, SUMMONED CREATURES AND PROBABLY HENCHMEN WILL REST!
   object oMod = GetModule();
   string sName=GetName(oPC);
   int iLevel = GetHitDice(oPC);
   
   int iCharState = GetLocalInt(oPC, "CSL_CHARSTATE");
   int iAreaState = GetLocalInt(oPC, "CSL_ENVIRO");
   
   
   
   

   

   if ( CSLGetIsInTown(oPC) || SCGetIsInArena(oPC))
   {
      DeleteLocalInt (oPC, "LASTREST");
   }
   else if (iLevel >= nLevelAffected) // CHECK IF REST-RESTRICTIONS APPLY TO THE PLAYER
   {
		if (GetLastRestEventType()==REST_EVENTTYPE_REST_STARTED)
		{
         
			if ( iCharState & CSL_CHARSTATE_SUBMERGED && GetLocalInt(oPC, "CSL_HOLDBREATH") )
			{
				SCStopResting(oPC, "You cannot rest when you cannot breathe.");
				return;
			}

			int nCurrentCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
			int nBaseCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
			int nHD = GetHitDice(oPC);
			int nHeal = nHD * ((nCurrentCon - nBaseCon) / 2);
			if (nHeal > 0)
			{
				int nCurrentHP = GetCurrentHitPoints(oPC);
				if (nCurrentHP < (nHeal + 1) )
				{
					int nHealVal = nHeal - nCurrentHP + 1;
					effect eHeal = EffectHeal(nHealVal);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
					SetLocalInt(oPC, "HealFixValue", nHealVal);			
				}
			}
         
         
         nRestDelay = iLevel / 5; // 5=1, 10=2, 15=3, 20=4, 25=5, 30=6
         int nNow = CSLTimeStamp();
         int nLastRest = CSLGetLastRest(oPC);
         int nNextRest = nLastRest + nRestDelay;
         if ((nNow < nNextRest)) // RESTING IS NOT ALLOWED // LASTREST IS 0 WHEN THE PLAYER ENTERS THE MODULE
         {
            nNextRest = nNextRest - nNow;
            SCStopResting(oPC, "You must wait " + IntToString(nNextRest) + CSLAddS(" hour", nNextRest) + " before resting again.");
            return;
         }
         else// ENOUGH TIME HAS PASSED TO REST AGAIN
         {
            object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
            if (GetDistanceToObject(oCreature)<=IntToFloat(nHostileRange)) { // IF NO HOSTILES WITHIN HOSTILE RADIUS: INITIATE RESTING
               CSLSetLastRest(oPC, nNow); // SUCCESS!! SET LAST REST TIME
            } else { // Resting IS NOT allowed
               SCStopResting(oPC, "A nearby enemy prevents you from resting.");
               return;
            }
         }
      }
   }
   
   DeleteLocalInt(oPC, "AOESTACK"); // CLEAR THE STACK WHEN RESTING

   DelayCommand(1.0f, SCDestroyUndead(oPC, TRUE) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
   DelayCommand(0.5f, SCSummonsExecuteScript(oPC) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
   
   if (GetLastRestEventType()==REST_EVENTTYPE_REST_CANCELLED)
   {
     if (GetLocalInt(oPC, "STOPREST")) { // WE FORCED THEM TO STOP
        DeleteLocalInt(oPC, "STOPREST");
        return;
      }
      
      int nHealFixValue = GetLocalInt(oPC, "HealFixValue");

			if (nHealFixValue > 0)
			{
				effect eBadPlayerSlap = EffectDamage(nHealFixValue, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBadPlayerSlap, oPC);
				SetLocalInt(oPC, "HealFixValue", 0);	
			}
      
      
      object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
      if (oCreature!=OBJECT_INVALID) {
         if (GetDistanceBetween(oPC, oCreature) <= 25.0) {
            return; // NO PENALTY FOR CANCLING REST IF ENEMY APPROACHING
         }
      }
	  DelayCommand( 1.5, CSLRemoveAllEffects( oPC ) );
   }
   
	
	
   //return;
   
   if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
   {
		SetLocalInt(oPC, "HealFixValue", 0);
		SetLocalInt(oPC, "PARTY_PORT", FALSE); 
		DeleteLocalInt(oPC, "TRANS");
		SDB_OnPCRest(oPC);
		SDB_FactionOnPCRest(oPC);
		SetLocalInt( oPC, "SC_HitDice", 0 );
		
		
		if ( CSLGetPreferenceSwitch("UseSacredFistFix",FALSE) )
		{
			//This fixes characters who were incorrectly given the feat.
			if ( (GetLevelByClass(CLASS_TYPE_SACREDFIST) == 0) && (GetHasFeat(FEAT_SACREDFIST_CODE_OF_CONDUCT, OBJECT_SELF)) )
			{
				FeatRemove(OBJECT_SELF, FEAT_SACREDFIST_CODE_OF_CONDUCT);
			}
		}
		
		object oPoly = GetItemPossessedBy(OBJECT_SELF, "cmi_cursedpoly");
		DestroyObject(oPoly, 0.1f, FALSE);
		
		if(GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oPC) > 1)
		{
			DelayCommand(1.0f, ExecuteScript("EQ_deathsruin",oPC));		
		}
		
		//DelayCommand( 1.0, StoreUses(oPC) );
   }
    
    */
}

void CSLEvent_Mod_OnUnequipItem()
{
	object oItem = GetPCItemLastUnequipped();
	object oPC = GetPCItemLastUnequippedBy();
	
	if (GetLocalInt(oPC, "LOADING")) return;
	
	// fix for missing hide attributes from items
	//CSLApplyItemProperties( oPC, oItem );
	DeleteLocalInt( oPC, "SC_ITEM_CACHED");
	DelayCommand( 0.5f, CSLCacheCreatureItemInformation( oPC ) );
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_CLOAK && CSLStringStartsWith( GetTag(oItem), "steed", FALSE ) )
	{
		DelayCommand( 0.5f, ExecuteScript("_mod_onmount", oPC ));
		return;
	}
	
	cmi_player_unequip(oPC);
	
	CSLEnviroUnequip( oItem, oPC );
	//ExecuteScript("cmi_player_unequip", OBJECT_SELF);
	
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
	object oItem = GetPCItemLastUnequipped();
	h2_RemoveAddedOnHitProperty(oItem);
    h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_UNEQUIP_ITEM);

    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
	
	// handle unequipped items
	ACR_ItemOnUnEquip(oItem, oPC);
	
	// Subdual / nonlethal handling
    DelayCommand(0.1, ACR_NLD_OnWeaponSwitch(oPC, oItem, FALSE));

    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
       object oItem = GetPCItemLastUnequipped();
   object oPC = GetPCItemLastUnequippedBy();

   if (GetLocalInt(oPC, "LOADING")) return; // SKIP THIS IN THE PC-LOAD PHASSE
   
   if (GetBaseItemType(oItem)==BASE_ITEM_RING)
   {
      if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N))
      {
	     SetLocalInt(oItem, "SPELLRING", GetGoldPieceValue(oItem));
	  }
   }
   
   
	if ( GetBaseItemType(oItem) == BASE_ITEM_ARMOR && GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		DelayCommand( 3.0f, CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "nw_cloth015", TRUE ) );
	}
	
	
	
	
    
    */
}

void CSLEvent_Mod_OnUnaquireItem()
{
	object oPC = GetModuleItemLostBy();
	object oItem = GetModuleItemLost();
	
	// ignore this, is being dropped/removed via a special script
	if ( GetLocalInt(oItem, "ItemDestroyed") ) { return; }
	
	object oFinder = GetItemPossessor(oItem);
	object oWeapon = GetLastWeaponUsed(oPC);
	
	CSLDropItemAndMakePlaceable(oPC, oItem);
	
    
    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////

	object oPC = GetModuleItemLostBy();	
	object oItem = GetModuleItemLost();
	h2_RemoveAddedOnHitProperty(oItem);	
	ClearHotbarButtonItemData(oPC, oItem);
    h2_RunModuleEventScripts(H2_EVENT_ON_UNACQUIRE_ITEM);    
    
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    object oItem = GetModuleItemLost();
    object oLostBy = GetModuleItemLostBy();
	
	// only process player drops
	if (! GetIsPC(oLostBy)) { return; }
 
	// fire handler for special items.
	ACR_ItemOnUnAcquire(oItem, oLostBy);

	// Nonlethal / subdual handling:
	ACR_NLD_OnWeaponSwitch(oLostBy, oItem, FALSE);
	
	// destroyed item in inventory are invalid but not OBJECT_INVALID
	// Items sold to stores fall into this category, so run scripts on them anyway
	//if (! GetIsObjectValid(oItem)) {
	//	SendMessageToPC(oLostBy, "Item has been destroyed.");
	//	return; 
	//}
	
    // track the presence of non-detection items
    ACR_ManageNonDetectionOnUnAcquire(oItem, oLostBy);

    // trap items with illegal properties
	//  Again, we don't have this managed via SQL tables, large waste of resources.
	//  commenting out for now, will replace with a locally cached version if it comes back later.
	
    //if (ACR_GetHasIllegalProperties(oItem))
    //{
    //    // log the event
     //   ACR_LogEvent(oLostBy, ACR_LOG_DROP_ILLEGAL, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oLostBy)));
     //           
     //   // quarantine the item?
    //}
    else 
	if (GetTag(oItem) == "acr_nld_fist")
	{
	    // don't need to log this, OOC from toggling subdual mode
	} else {
        // log item acquisitions
		ACR_LogOnUnacquired(oItem, oLostBy, GetStolenFlag(oItem));
    }    
    
    */
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC = GetModuleItemLostBy();
	object oItem = GetModuleItemLost();
	
	//if (DEBUGGING >= 2) { SendMessageToPC(oPC, "unacquire 2"); }
	
	if ( GetLocalInt(oItem, "ItemDestroyed") )
	{
		// ignore this, is being dropped/removed via a special script
		return;
	}
	

   
   object oFinder = GetItemPossessor(oItem);
   object oWeapon = GetLastWeaponUsed(oPC);

   int bBarter = oItem!=OBJECT_INVALID && oFinder==OBJECT_INVALID; // VALID ITEM BUT NOT VALID FINDER, MUST BE BARTER WINDOW

   if (GetLocalInt(oItem, "TENSORS_SWORD")) {
      DestroyObject(oItem);
      SDB_LogMsg("TENSOR", "destroyed tensor sword", oPC);
      return;
   }
   if ( GetTag(oItem) == "dmfi_exe_tool" ||
   		GetResRef(oItem) == "dmfi_exe_tool" ||
		GetTag(oItem) == "dmsco" ||
		GetTag(oItem) ==  "dmrco" ||
		GetTag(oItem) ==  "cmi_cursedpoly"
   )
   {
      SetPlotFlag(oItem, FALSE);
      DestroyObject(oItem);
      return;
   }
   

   if (GetBaseItemType(oItem)==BASE_ITEM_CREATUREITEM)
   { // LOST CREATURE SKIN, THEY HAVE UNSHIFTED
      CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELL_TENSERS_TRANSFORMATION, SPELL_NATURE_AVATAR);
      //RemoveEffectsFromSpell(oPC, SPELL_SHAPECHANGE);
      //RemoveEffectsFromSpell(oPC, SPELLABILITY_WILD_SHAPE);
      //RemoveEffectsFromSpell(oPC, SPELL_I_WORD_OF_CHANGING);
      //RemoveEffectsFromSpell(oPC, SPELL_POLYMORPH_SELF);
   }

   if (bBarter) {
      if (oItem==GetLocalObject(oPC, "CRAFTER_LIST_COPY")) { // UNACQUIRED AN ITEM CURRENTLY BEING CRAFTED, BAD BOY!
         if (IsInConversation(oPC)) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(50, DAMAGE_TYPE_MAGICAL), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
            SendMessageToPC(oPC, "Your slight of hand has not gone unnoticed. You anger me when you try to steal...");
            SDB_LogMsg("CRAFTBARTER", "put " + GetName(oItem) + " in barter window.", oPC);
            DestroyObject(oItem);
            return;
         }
         DeleteLocalObject(oPC, "CRAFTER_LIST_COPY");
         DeleteLocalInt(oPC, "CRAFTER_LIST_COPY");;
      }
      SetLocalObject(oItem, "BARTER_FROM", oPC); // SAVE THE ORIGINAL OWNER
      SetLocalString(oItem, "BARTER_PLID", SDB_GetPLID(oPC));
   } else { // NOT BARTERING, SAVE THE PC NOW
      SDB_UpdatePlayerStatus(oPC, "1", FALSE); // SAVE PC STATUS - FALSE MEANS DON'T SHOW SAVE MESSAGE IF LOSING AN ITEM
   }

   if (GetIsInCombat(oPC)) {
      if (CSLItemGetIsAWeapon(oItem)) {
         if (GetStolenFlag(oItem)) {
            SendMessageToPC(oPC, "This disarmed weapon was flagged as stolen. Please tell Seed!!");
            SDB_LogMsg("DISARM", GetName(oItem) + ": Disarmed weapon flagged as stolen. Owner was " + GetName(oPC), oFinder);
            DelayCommand(300.0, SetStolenFlag(oItem, FALSE));
         } else {
            DelayCommand(1.0, SCItemSoldCheck(oItem, oPC));
            effect eVis = EffectNWN2SpecialEffectFile("seed_disarm.sef");
            effect eABLoss = EffectAttackDecrease(5);
            effect eSpeed = EffectMovementSpeedDecrease(50);
            effect eLink = EffectLinkEffects(eABLoss, eVis);
            eLink = EffectLinkEffects(eLink, eSpeed);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 12.0);
            FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC);
            DelayCommand(3.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            DelayCommand(6.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            DelayCommand(9.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            return;
         }
      }
   }

   if (GetStolenFlag(oItem) && GetIsPC(oFinder) && !GetIsDM(oFinder)) {
      if (GetDroppableFlag(oItem)) {
         int nSkill = GetSkillRank(SKILL_SLEIGHT_OF_HAND, oFinder);
         int nWeight = CSLGetMin(50, GetWeight(oItem));
         int iRoll = nSkill > 0 ? d20(1) : 1; // IF NO SKILL, ALWAYS CRITICAL FAILURE
         if (iRoll==20 && nWeight>20) iRoll = d20(); // IF NAT 20 ON HEAVY ITEM, ROLL IT AGAIN
         if (iRoll==1) {
            SendMessageToPC(oFinder, "Pick Pocket critical failure.");
            SendMessageToPC(oPC, "You feel a hand in your pocket.");
            object oItem2 = CopyItem(oItem, oPC, TRUE);
            SetIdentified(oItem2, TRUE);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
         } else if (iRoll==20) {
            SendMessageToPC(oFinder, "Pick Pocket finesse! You acquired "+GetName(oItem)+".");
         } else {
            int nLvl = GetHitDice(oPC);
            int nSpot = GetSkillRank(SKILL_SPOT, oPC);
            int nStack = GetItemStackSize(oItem);
            int iDC = nLvl + nSpot + nWeight + nStack;
            int iClass = GetLevelByClass(CLASS_TYPE_ROGUE, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_BARD, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_ASSASSIN, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_HARPER, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oFinder);
            string sMsg = "Pick Pocket [skill "+IntToString(nSkill)+"+class "+IntToString(iClass)+"+roll "+IntToString(iRoll)+"] = " + IntToString(iRoll+nSkill+iClass) + " VS DC "+IntToString(iDC)+" [level " + IntToString(nLvl) + "+spot "+IntToString(nSpot) + "+weight "+IntToString(nWeight) + "+stack "+IntToString(nStack) + "]";
            if (nSkill+iRoll+iClass >= iDC) {
               sMsg = "<color=limegreen>*Success* " + sMsg;
            } else {
               sMsg = "<color=pink>*Failure* " + sMsg;
               object oItem2 = CopyItem(oItem, oPC, TRUE);
               SetIdentified(oItem2, TRUE);
               SetPlotFlag(oItem, FALSE);
               DestroyObject(oItem);
            }
            SendMessageToPC(oFinder, sMsg);
         }
      }
	  
      return;
	  
   }

   
  CSLDropItemAndMakePlaceable(oPC, oItem);
    
    */
}

void CSLEvent_Mod_OnUserDefined()
{

    /*
	///////////////////////////////////////////////
    //////////// from the HCR events //////////////
    ///////////////////////////////////////////////
    
    h2_RunModuleEventScripts(H2_EVENT_ON_USER_DEFINED);
    
    */
    
    /*
	///////////////////////////////////////////////
    //////////// from the ALFA events //////////////
    ///////////////////////////////////////////////
    
    
    int nEvent = GetUserDefinedEventNumber();
	
	*/
    
    
    /*
	///////////////////////////////////////////////
    ///////// from the dex module events //////////
    ///////////////////////////////////////////////
    
    
    
    */
}



// attempts to set the module events dynamically, mainly to see if this is even an option, does not appear to even work.
void CSLSetupModuleEvents()
{
	//SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED
	
	//SCRIPT_MODULE_ON_USER_DEFINED_EVENT
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ACQUIRE_ITEM , "_CSLEvent_Mod_OnAcquireItem");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ACTIVATE_ITEM , "_CSLEvent_Mod_OnActivateItem");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_CLIENT_ENTER , "_CSLEvent_Mod_OnClientEnter");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_CLIENT_EXIT , "_CSLEvent_Mod_OnClientLeave");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE , "_CSLEvent_Mod_OnCutsceneAbort");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_HEARTBEAT , "_CSLEvent_Mod_OnHeartbeat");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_MODULE_LOAD , "_CSLEvent_Mod_OnModuleLoad");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_MODULE_START , "_CSLEvent_Mod_OnModuleStart");
	//SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ , "_CSLEvent_Mod_OnPCLoaded");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_PLAYER_DEATH , "_CSLEvent_Mod_OnPlayerDeath");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_PLAYER_DYING , "_CSLEvent_Mod_OnPlayerDying");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_EQUIP_ITEM , "_CSLEvent_Mod_OnEquipItem");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_PLAYER_LEVEL_UP , "_CSLEvent_Mod_OnLevelUp");
	//SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ , "_CSLEvent_Mod_OnPlayerRespawn");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_PLAYER_REST , "_CSLEvent_Mod_OnPlayerRest");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_UNEQUIP_ITEM , "_CSLEvent_Mod_OnPlayerUnequip");
	SetEventHandler( GetModule(), SCRIPT_MODULE_ON_LOSE_ITEM , "_CSLEvent_Mod_OnUnaquireItem");
	//SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ , "_CSLEvent_Mod_OnUserDefined");
	//SetEventHandler( GetModule(), SCRIPT_MODULE_ON_ , "_CSLEvent_Mod_OnChat");

	object oArea = GetFirstArea();
	while( oArea != OBJECT_INVALID )
	{
		// Module
		SendMessageToPC( GetFirstPC(), "Setting up Area "+GetName(oArea) );
		SetEventHandler( oArea, SCRIPT_AREA_ON_HEARTBEAT , "_CSLEvent_Area_OnHeartbeat" ); //             = 0;
		SetEventHandler( oArea, SCRIPT_AREA_ON_USER_DEFINED_EVENT, "_CSLEvent_Area_OnUserDefined" ); //      = 1;
		SetEventHandler( oArea, SCRIPT_AREA_ON_ENTER, "_CSLEvent_Area_OnEnter" ); //             = 2;
		SetEventHandler( oArea, SCRIPT_AREA_ON_EXIT, "_CSLEvent_Area_OnExit" ); //            = 3;
		SetEventHandler( oArea, SCRIPT_AREA_ON_CLIENT_ENTER, "_CSLEvent_Area_OnClientEnter" ); //            = 4;
		
		oArea = GetNextArea();
	}
}

/*


SCRIPT_MODULE_ON_ACQUIRE_ITEM
SCRIPT_MODULE_ON_ACTIVATE_ITEM
SCRIPT_MODULE_ON_CLIENT_ENTER
SCRIPT_MODULE_ON_CLIENT_EXIT
SCRIPT_MODULE_ON_EQUIP_ITEM
SCRIPT_MODULE_ON_HEARTBEAT
SCRIPT_MODULE_ON_LOSE_ITEM
SCRIPT_MODULE_ON_MODULE_LOAD
SCRIPT_MODULE_ON_MODULE_START
SCRIPT_MODULE_ON_MODULE_START
SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE
SCRIPT_MODULE_ON_PLAYER_DEATH
SCRIPT_MODULE_ON_PLAYER_DYING
SCRIPT_MODULE_ON_PLAYER_LEVEL_UP
SCRIPT_MODULE_ON_PLAYER_REST
SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED
SCRIPT_MODULE_ON_UNEQUIP_ITEM
SCRIPT_MODULE_ON_USER_DEFINED_EVENT

_CSLEvent_Mod_OnAcquireItem
_CSLEvent_Mod_OnActivateItem
_CSLEvent_Mod_OnClientEnter
_CSLEvent_Mod_OnClientLeave
_CSLEvent_Mod_OnCutsceneAbort
_CSLEvent_Mod_OnHeartbeat
_CSLEvent_Mod_OnModuleLoad
_CSLEvent_Mod_OnModuleStart
_CSLEvent_Mod_OnPCLoaded
_CSLEvent_Mod_OnPlayerDeath
_CSLEvent_Mod_OnPlayerDying
_CSLEvent_Mod_OnEquipItem
_CSLEvent_Mod_OnLevelUp
_CSLEvent_Mod_OnPlayerRespawn
_CSLEvent_Mod_OnPlayerRest
_CSLEvent_Mod_OnPlayerUnequip
_CSLEvent_Mod_OnUnaquireItem
_CSLEvent_Mod_OnUserDefined
_CSLEvent_Mod_OnChat

_CSLEvent_Area_OnClientEnter
_CSLEvent_Area_OnEnter
_CSLEvent_Area_OnExit
_CSLEvent_Area_OnHeartbeat
_CSLEvent_Area_OnUserDefined
*/

/*
// Brock H. - OEI 03/26/06 These are the script event types
// Supported by SetEventHandler() / GetEventHandler
int CREATURE_SCRIPT_ON_HEARTBEAT              = 0;
int CREATURE_SCRIPT_ON_NOTICE                 = 1;
int CREATURE_SCRIPT_ON_SPELLCASTAT            = 2;
int CREATURE_SCRIPT_ON_MELEE_ATTACKED         = 3;
int CREATURE_SCRIPT_ON_DAMAGED                = 4;
int CREATURE_SCRIPT_ON_DISTURBED              = 5;
int CREATURE_SCRIPT_ON_END_COMBATROUND        = 6;
int CREATURE_SCRIPT_ON_DIALOGUE               = 7;
int CREATURE_SCRIPT_ON_SPAWN_IN               = 8;
int CREATURE_SCRIPT_ON_RESTED                 = 9;
int CREATURE_SCRIPT_ON_DEATH                  = 10;
int CREATURE_SCRIPT_ON_USER_DEFINED_EVENT     = 11;
int CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR        = 12;
// Trigger
int SCRIPT_TRIGGER_ON_HEARTBEAT          = 0;
int SCRIPT_TRIGGER_ON_OBJECT_ENTER       = 1;
int SCRIPT_TRIGGER_ON_OBJECT_EXIT        = 2;
int SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT = 3;
int SCRIPT_TRIGGER_ON_TRAPTRIGGERED      = 4;
int SCRIPT_TRIGGER_ON_DISARMED           = 5;
int SCRIPT_TRIGGER_ON_CLICKED            = 6;
// Area
int SCRIPT_AREA_ON_HEARTBEAT            = 0;
int SCRIPT_AREA_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AREA_ON_ENTER                = 2;
int SCRIPT_AREA_ON_EXIT                 = 3;
int SCRIPT_AREA_ON_CLIENT_ENTER         = 4;
// Door
int SCRIPT_DOOR_ON_OPEN            = 0;
int SCRIPT_DOOR_ON_CLOSE           = 1;
int SCRIPT_DOOR_ON_DAMAGE          = 2;
int SCRIPT_DOOR_ON_DEATH           = 3;
int SCRIPT_DOOR_ON_DISARM          = 4;
int SCRIPT_DOOR_ON_HEARTBEAT       = 5;
int SCRIPT_DOOR_ON_LOCK            = 6;
int SCRIPT_DOOR_ON_MELEE_ATTACKED  = 7;
int SCRIPT_DOOR_ON_SPELLCASTAT     = 8;
int SCRIPT_DOOR_ON_TRAPTRIGGERED   = 9;
int SCRIPT_DOOR_ON_UNLOCK          = 10;
int SCRIPT_DOOR_ON_USERDEFINED     = 11;
int SCRIPT_DOOR_ON_CLICKED         = 12;
int SCRIPT_DOOR_ON_DIALOGUE        = 13;
int SCRIPT_DOOR_ON_FAIL_TO_OPEN    = 14;
// Encounter
int SCRIPT_ENCOUNTER_ON_OBJECT_ENTER        = 0;
int SCRIPT_ENCOUNTER_ON_OBJECT_EXIT         = 1;
int SCRIPT_ENCOUNTER_ON_HEARTBEAT           = 2;
int SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED = 3;
int SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT  = 4;
// Module
int SCRIPT_MODULE_ON_HEARTBEAT              = 0;
int SCRIPT_MODULE_ON_USER_DEFINED_EVENT     = 1;
int SCRIPT_MODULE_ON_MODULE_LOAD            = 2;
int SCRIPT_MODULE_ON_MODULE_START           = 3;
int SCRIPT_MODULE_ON_CLIENT_ENTER           = 4;
int SCRIPT_MODULE_ON_CLIENT_EXIT            = 5;
int SCRIPT_MODULE_ON_ACTIVATE_ITEM          = 6;
int SCRIPT_MODULE_ON_ACQUIRE_ITEM           = 7;
int SCRIPT_MODULE_ON_LOSE_ITEM              = 8;
int SCRIPT_MODULE_ON_PLAYER_DEATH           = 9;
int SCRIPT_MODULE_ON_PLAYER_DYING           = 10;
int SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED = 11;
int SCRIPT_MODULE_ON_PLAYER_REST            = 12;
int SCRIPT_MODULE_ON_PLAYER_LEVEL_UP        = 13;
int SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE = 14;
int SCRIPT_MODULE_ON_EQUIP_ITEM             = 15;
int SCRIPT_MODULE_ON_UNEQUIP_ITEM           = 16;
// Placeable
int SCRIPT_PLACEABLE_ON_CLOSED              = 0;
int SCRIPT_PLACEABLE_ON_DAMAGED             = 1;
int SCRIPT_PLACEABLE_ON_DEATH               = 2;
int SCRIPT_PLACEABLE_ON_DISARM              = 3;
int SCRIPT_PLACEABLE_ON_HEARTBEAT           = 4;
int SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED  = 5;
int SCRIPT_PLACEABLE_ON_LOCK                = 6;
int SCRIPT_PLACEABLE_ON_MELEEATTACKED       = 7;
int SCRIPT_PLACEABLE_ON_OPEN                = 8;
int SCRIPT_PLACEABLE_ON_SPELLCASTAT         = 9;
int SCRIPT_PLACEABLE_ON_TRAPTRIGGERED       = 10;
int SCRIPT_PLACEABLE_ON_UNLOCK              = 11;
int SCRIPT_PLACEABLE_ON_USED                = 12;
int SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT  = 13;
int SCRIPT_PLACEABLE_ON_DIALOGUE            = 14;
// AOE
int SCRIPT_AOE_ON_HEARTBEAT            = 0;
int SCRIPT_AOE_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AOE_ON_OBJECT_ENTER         = 2;
int SCRIPT_AOE_ON_OBJECT_EXIT          = 3;
// Store
int SCRIPT_STORE_ON_OPEN              = 0;
int SCRIPT_STORE_ON_CLOSE             = 1;



// Brock H. - OEI 03/28/06 -- These must match the values in NWN2_ScriptSets.2da
int SCRIPTSET_INVALID               = -1;
int SCRIPTSET_NOAI                  = 0;
int SCRIPTSET_PCDOMINATE            = 1;
int SCRIPTSET_DMPOSSESSED           = 2;
int SCRIPTSET_PLAYER_DEFAULT        = 3; // These are the default scripts that are loaded onto the player character
int SCRIPTSET_COMPANION_POSSESSED   = 4; // The scripts that are applied on the player when he is controlled by
int SCRIPTSET_NPC_DEFAULT           = 9; // The default scripts for generic NPCs
int SCRIPTSET_NPC_ASSOCIATES        = 10; // The default scripts for NPC associates (summoned creatures, henchmen, etc)

*/


/// what is this???? ALFA stuff
/*
int ACR_GetModuleStatus(int nStatus) {
    return (GetLocalInt(GetModule(), ACR_MOD_STATUS) & nStatus);
}

void ACR_SetModuleStatus(int nStatus) {
    object oModule = GetModule();
    SetLocalInt(oModule, ACR_MOD_STATUS, GetLocalInt(oModule, ACR_MOD_STATUS) | nStatus);
}
*/