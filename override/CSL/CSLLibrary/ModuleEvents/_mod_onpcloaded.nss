#include "_CSLCore_Config"
#include "_CSLCore_Items"
#include "_CSLCore_Class"
#include "_CSLCore_Player"

#include "_CSLCore_Nwnx"
#include "seed_db_inc"

#include "_SCInclude_Chat"
#include "_SCInclude_Class"
//#include "_SCInclude_DMFI"
//#include "_SCInclude_Language"
#include "_SCInclude_Faction"
#include "_SCInclude_MagicStone"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Playerlist"
#include "_SCInclude_Graves"
#include "_SCInclude_Events"
#include "_SCInclude_Language"

void main()
{
	
	object oPC = GetEnteringObject();
	if (!GetXP(oPC) && !CSLGetIsDM(oPC, FALSE))  // CHECK IF NEW CHARACTER
	{
		CSLCleanCharacterText( oPC ); 
	}
	
	//if ( CSLGetPreferenceSwitch( "HideDMInChatOnDMHidden", FALSE) )
	//	if ( CSLGetPreferenceSwitch( "HideDMInChatOnDMInvis", FALSE) )
	//CSLGetPreferenceSwitch( "HideDMInChat", FALSE)
	
	if ( GetIsDM( oPC ) && CSLGetPreferenceSwitch( "HideDMInChat", FALSE) )
	{
		if ( CSLGetPreferenceSwitch( "HideDMInChatOnDMHidden", FALSE) )
		{
			CSLPlayerList_SetHidden( oPC, TRUE  );
		}
	}
	//int iHideDmOnInvisible = GetLocalInt( GetModule(), "CSL_HIDEDMONINVIS" ); // transfer var to player
	//SetLocalInt( oPC, "CSL_HIDEDMONINVIS", iHideDmOnInvisible );
	//if ( GetIsDM( oPC ) && iHideDmOnInvisible )
	//{
	//	CSLPlayerList_SetHidden( oPC, TRUE  );
	//	SetLocalInt( oPC, "CSL_HIDEDMSINCHAT", TRUE);
	//}
	
	
	//SendMessageToPC( oPC, "Running the PC Loading Script");
	
	DelayCommand( 0.1f, SCFixFeats(oPC) );
	DelayCommand( 60.0, CSLRemoveOrphanedEffects(oPC) );
	 
	string sName = CSLGetMyName(oPC);
	string sIPAddress = CSLGetMyIPAddress(oPC);
	string sPublicCDKey = CSLGetMyPublicCDKey(oPC);
	string sPlayerName = CSLGetMyPlayerName(oPC);
	
	string sFactionName = SDB_FactionGetName( SDB_GetFAID( oPC ) );
	/*
	if ( GetIsSinglePlayer() )
	{
		string sFactionName = "Dude";
	}
	*/
	//SendMessageToPC( oPC, "1");
	//DelayCommand( 12.0f, CSLCleanCharacterText( oPC ) );  
	
	//if (sName=="") sName = CSLGetMyName(oPC);
	//if (sPublicCDKey=="") sPublicCDKey = GetPCPublicCDKey(oPC);
	//if (sPlayerName=="") sPlayerName = GetPCPlayerName(oPC);
	//if (sIPAddress=="") sIPAddress = GetPCIPAddress(oPC);
	
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
		//CSLSuperCharge(oPC);
		CSLSetAsTester(oPC,TRUE);
		// SetLocalInt( oPC, "SC_TESTER", TRUE );
	}	
	//SetLocalInt( oPC, "SC_TESTER", TRUE );
	
	//if (sName=="") return;
	//if (sPublicCDKey=="") return;
	//if (sPlayerName=="") return;
	//if (sIPAddress=="") return;
	// SendMessageToPC( oPC, "2");
	SetLocalString(oPC, "MyName", sName);
	SetLocalString(oPC, "IPAddress", sIPAddress);
	SetLocalString(oPC, "PublicCDKey", sPublicCDKey);
	SetLocalString(oPC, "PlayerName",  sPlayerName);
	
	
	//SendMessageToPC( oPC, "3");
	if (CSLNWNX_Installed())
	{
		SCLogInMessage(oPC, "NWNX4 Installed and Running...");
		SDB_OnClientEnter(oPC);
		SDB_FactionOnClientEnter(oPC);
		
		if (SDB_GetCKID(oPC)=="1") // seed
		{
			SetLocalObject(GetModule(), "IAMSEED", oPC);
			CSLSetAsTester(oPC,TRUE);
		}  
		if (SDB_GetCKID(oPC)=="3400") // pain
		{
			//SetLocalObject(GetModule(), "IAMSEED", oPC);  
			CSLSetAsTester(oPC,TRUE);
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
	// SendMessageToPC( oPC, "4");
	CSLPlayerList_ClientEnter(oPC);
	//Speech_OnClientEnter(oPC);
	CSLSetChatMessenger( "DM_GHOST" );
	
	//	if (!CSLHasItemByTag(oPC, "EL_ESTHETIC_CRAFTER")) CreateItemOnObject("el_esthetic_crafter", oPC); // GIVE IF NOT THERE
	
	int bMinotaurArmor = FALSE;
	if ( GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		bMinotaurArmor = TRUE;
		CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "nw_cloth015", TRUE );
	}
	
	//SendMessageToPC( oPC, "5");
	if (!GetXP(oPC) && !CSLGetIsDM(oPC, FALSE))  // CHECK IF NEW CHARACTER
	{
		SetXP(oPC, 1);
		GiveGoldToCreature(oPC, 500);
		CreateItemOnObject("stone_loftenwood", oPC, 1);	 // Loftenwood Stone
		CreateItemOnObject("csl_torch", oPC, 1);		// TORCH
		object oGuide = CreateItemOnObject("bookofthenoob", oPC, 1);		// NOOB GUIDE
		
		
		string sWeapon = CSLGetAppropriateWeaponResRef( oPC );
		if ( sWeapon != "" )
		{
			int iQuantity = 1;
			if ( sWeapon == "nw_wthdt001" ) { iQuantity = 50;} //darts
			if ( sWeapon == "nw_wthsh001" ) { iQuantity = 50;} //shuriken
			if ( sWeapon == "nw_wthax001" ) { iQuantity = 25;} //throwing axe
			
			object oWeapon = CreateItemOnObject(sWeapon, oPC, iQuantity);
			AssignCommand(oPC, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
			
			// handle ranged items now which were given above
			if ( sWeapon == "nw_wbwxh001" || sWeapon == "nw_wbwxl001" ) // crossbows
			{
				object oBolts = CreateItemOnObject("nw_wambo001", oPC, 50); // BOLTS
				AssignCommand(oPC, ActionEquipItem(oBolts, INVENTORY_SLOT_BOLTS));
				
				//lets give them a weak melee item just in case
				CreateItemOnObject(CSLGetBaseItemResRef(CSLGetBestBaseItem(oPC,BASE_ITEM_DAGGER,BASE_ITEM_CLUB)), oPC, 1);
				
			}
			else if ( sWeapon == "nw_wbwln001" || sWeapon == "nw_wbwsh001" ) // bows
			{
				object oArrows = CreateItemOnObject("nw_wamar001", oPC, 50); // ARROWS
				AssignCommand(oPC, ActionEquipItem(oArrows, INVENTORY_SLOT_ARROWS));
				
				//lets give them a weak melee item just in case
				CreateItemOnObject(CSLGetBaseItemResRef(CSLGetBestBaseItem(oPC,BASE_ITEM_DAGGER,BASE_ITEM_CLUB)), oPC, 1);
				
			}
			else if ( sWeapon == "nw_wbwsl001"  ) // sling
			{
				object oBullets = CreateItemOnObject("nw_wambu001", oPC, 50); // BULLETS
				AssignCommand(oPC, ActionEquipItem(oBullets, INVENTORY_SLOT_BULLETS));
				
				//lets give them a weak melee item just in case
				CreateItemOnObject(CSLGetBaseItemResRef(CSLGetBestBaseItem(oPC,BASE_ITEM_DAGGER,BASE_ITEM_CLUB)), oPC, 1);
				
			}
			else // no ranged were given yet, lets give them a light crossbow just in case
			{
				CreateItemOnObject("nw_wbwxl001", oPC, 1); // LIGHT CROSSBOW
				object oBolts = CreateItemOnObject("nw_wambo001", oPC, 50); // BOLTS
				AssignCommand(oPC, ActionEquipItem(oBolts, INVENTORY_SLOT_BOLTS));
			
			}
			
		
		}
		
		SCBookLanguagesInstalled( oPC );
		
		string sShield = CSLGetBestShieldResref( oPC );
		if ( sShield != "" )
		{
			object oShield = CreateItemOnObject(sShield, oPC, 1);
			AssignCommand(oPC, ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND));
		}
		
		if ( bMinotaurArmor == FALSE ) // only do if don't have forced armor
		{
			string sArmor = CSLGetBestArmorResref( oPC ); // armor
			if ( sArmor != "" )
			{
				object oArmor = CreateItemOnObject(sArmor, oPC, 1);
				AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
			}
		}
		
		
		//CreateItemOnObject("nw_wdbqs001", oPC, 1);         // QUARTERSTAFF
		
		
		
		
		
		
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
	//SendMessageToPC( oPC, "6");
	
	if ( CSLGetIsDM(oPC, TRUE) || GetIsSinglePlayer() )
	{
		CSLShowDMBar( oPC );
		CSLSetAsTester(oPC,TRUE);
		
		SetLocalInt(oPC, "CSL_UseTrueDMCasterLevel", FALSE ); // sets the dm to use their actual level, normally it sets to have dm's cast spells at level 60
		
		SendMessageToPC( oPC, "Your CD Key is "+sPublicCDKey );
		
		CSLCreateSingleItemOnObject("dmsco", oPC, 1, "dmsco");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("dmrco", oPC, 1, "dmsco");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("stone_loftenwood", oPC, 1, "townstone");    // Loftenwood Stone
		CSLCreateSingleItemOnObject("stone_bind", oPC, 1, "bindstone");    // Loftenwood Stone
		//StoneCreate(oPC, "stone_skill", "Skill Stone", "SMS_SKILL");
		CSLCreateSingleItemOnObject("dex_trollheart", oPC, 5, "dex_trollheart");          // map of dex
		
		//StoneCreate(oPC, "stone_masscrit", "Stone of MassCrit Damage", "SMS_MASSCRIT");
		object oMap = CSLCreateSingleItemOnObject("dex_dexmap", oPC, 1, "dex_dexmap");          // map of dex
		SetIdentified(oMap, TRUE);
		
	}
	
	SCGrantHolyItems(oPC);
	
	SetHasPrayed(oPC, TRUE);
	DisplayGuiScreen(oPC, "SCREEN_GUI_CONTROL", FALSE, "uicontrol.XML"); 
	// CloseGUIScreen(oPC, "SCREEN_MINIMAP");
	//SendMessageToPC( oPC, "7");
	
	DelayCommand(0.0f, SetLocalInt(oPC, "DisableConFix", TRUE));
	//SetCommandable(FALSE,oPC);
	//int nCurrentHP2 = GetCurrentHitPoints(oPC);	
	
	DelayCommand(0.2, SCReQuip(oPC, INVENTORY_SLOT_BOOTS));
	DelayCommand(0.4, SCReQuipHands(oPC));
	DelayCommand(0.6, SCReQuip(oPC, INVENTORY_SLOT_LEFTRING));
	DelayCommand(0.8, SCReQuip(oPC, INVENTORY_SLOT_RIGHTRING));
	
	DelayCommand(1.0, SCReQuip(oPC, INVENTORY_SLOT_ARMS));
	DelayCommand(1.2, SCReQuip(oPC, INVENTORY_SLOT_CHEST));
	DelayCommand(1.4, SCReQuip(oPC, INVENTORY_SLOT_RIGHTHAND));
	DelayCommand(1.6, SCReQuip(oPC, INVENTORY_SLOT_LEFTHAND));
	DelayCommand(1.8, SCReQuip(oPC, INVENTORY_SLOT_NECK));
	DelayCommand(2.0, SCReQuip(oPC, INVENTORY_SLOT_CLOAK));
	DelayCommand(2.2, SCReQuip(oPC, INVENTORY_SLOT_BELT));
	DelayCommand(2.4, SCReQuip(oPC, INVENTORY_SLOT_HEAD));
	
	//int nCurrentHitPoints = GetCurrentHitPoints( oPC );
	//SendMessageToPC(OBJECT_SELF, "nHP: " + IntToString(nCurrentHitPoints));
	
	//if (nCurrentHP2 < nCurrentHitPoints)
	//{
	//	// Heal the diff
	//	effect eHeal = EffectHeal(nCurrentHitPoints - nCurrentHP2);
	//	DelayCommand(2.4f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC));
	//}
	//else if (nCurrentHP2 > nCurrentHitPoints)
	//{
	//	// Damage the diff
	//	effect eDamage = EffectDamage(nCurrentHP2 - nCurrentHitPoints, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, TRUE);
	//	DelayCommand(2.4f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
	//}
		
	DelayCommand(2.5f, SetLocalInt(OBJECT_SELF, "DisableConFix", FALSE));
	
	//DelayCommand(2.5f, SetCommandable(TRUE,oPC) );
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
	
	if (GetActionMode(oPC, 24) == TRUE)
	{
		SetActionMode(oPC, 24, FALSE);
		SetActionMode(oPC, 24, TRUE);		
	}
	
	//SendMessageToPC( oPC, "10");
	DelayCommand(5.0,SCCheckInv(oPC));
	
	DelayCommand(2.5, DMFI_ClientEnter(oPC) );

	cmi_pc_loaded( oPC );
	
	//SendMessageToPC( oPC, "11");
	//ExecuteScript("cmi_pc_loaded", oPC);
	DelayCommand(0.05, ExecuteScript("_mod_onlanguageinit", oPC));
	
}