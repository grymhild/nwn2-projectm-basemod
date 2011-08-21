/** @file
* @brief Include File for 
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/

// core utility includes
#include "_CSLCore_Items"
#include "_CSLCore_Player"
#include "_CSLCore_Class"
#include "_CSLCore_Magic"

// spell casting system
#include "_HkSpell"

// chat includes
//#include "_SCInclude_Language"
#include "_SCInclude_Chat"
//#include "_SCInclude_Summon"
//#include "_SCInclude_Transmutation"
#include "_SCInclude_UnlimitedAmmo"
 
//#include "_SCInclude_Abjuration"
//#include "_SCInclude_AmmoBox"
//#include "_SCInclude_Arena"
#include "_SCInclude_Class"
//#include "_SCInclude_DMFI"
#include "_SCInclude_Encounter" 
#include "_SCInclude_Faction"
//#include "_SCInclude_Healing"
//#include "_SCInclude_Invisibility"
//#include "_SCInclude_MagicStone"
//#include "_SCInclude_Necromancy"
#include "_SCInclude_Playerlist"
#include "_SCInclude_Graves"

// these are older includes that need to be looked at
#include "_CSLCore_Nwnx"
//#include "_CSLCore_Nwnx"
#include "seed_db_inc"
//#include "x2_inc_restsys"
#include "x2_inc_switches"

//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------


/// from on module load
const int MAX_SERVER_COUNT = 50;

const int EVENT_PLACEABLE_SPAWN		= 100; // use w/ gp_pseudo_spawn_hb


const string EVENTS_CLEARED_FLAG 	= "EH_CLEARED";
const string EVENTS_SAVE_PREFIX 	= "EH_SAVE";

// Standard associate scripts                               // Reference value
const string SCRIPT_ASSOC_ATTACK    = "gb_assoc_attack";    // 5
const string SCRIPT_ASSOC_BLOCK     = "gb_assoc_block";     // e
const string SCRIPT_ASSOC_COMBAT    = "gb_assoc_combat";    // 3
const string SCRIPT_ASSOC_CONV      = "gb_assoc_conv";      // 4
const string SCRIPT_ASSOC_DAMAGE    = "gb_assoc_damage";    // 6
const string SCRIPT_ASSOC_DEATH     = "gb_assoc_death";     // 7
const string SCRIPT_ASSOC_DISTRB    = "gb_assoc_distrb";    // 8
const string SCRIPT_ASSOC_HEART     = "gb_assoc_heart";     // 1
const string SCRIPT_ASSOC_PERCEP    = "gb_assoc_percep";    // 2
const string SCRIPT_ASSOC_REST      = "gb_assoc_rest";      // a
const string SCRIPT_ASSOC_SPAWN     = "gb_assoc_spawn";     // 9
const string SCRIPT_ASSOC_SPELL     = "gb_assoc_spell";     // b
const string SCRIPT_ASSOC_USRDEF    = "gb_assoc_usrdef";    // d


// Standard default scripts                               // Reference value
const string SCRIPT_DEFAULT_ATTACK    = "nw_c2_default5";   // 5
const string SCRIPT_DEFAULT_BLOCK     = "nw_c2_defaulte";   // e
const string SCRIPT_DEFAULT_COMBAT    = "nw_c2_default3";   // 3
const string SCRIPT_DEFAULT_CONV      = "nw_c2_default4";   // 4
const string SCRIPT_DEFAULT_DAMAGE    = "nw_c2_default6";   // 6
const string SCRIPT_DEFAULT_DEATH     = "nw_c2_default7";   // 7
const string SCRIPT_DEFAULT_DISTRB    = "nw_c2_default8";   // 8
const string SCRIPT_DEFAULT_HEART     = "nw_c2_default1";   // 1
const string SCRIPT_DEFAULT_PERCEP    = "nw_c2_default2";   // 2
const string SCRIPT_DEFAULT_REST      = "nw_c2_defaulta";   // a
const string SCRIPT_DEFAULT_SPAWN     = "nw_c2_default9";   // 9
const string SCRIPT_DEFAULT_SPELL     = "nw_c2_defaultb";   // b
const string SCRIPT_DEFAULT_USRDEF    = "nw_c2_defaultd";   // d

// Misc scripts
const string SCRIPT_OBJECT_NOTHING    = "go_nothing";    // nothing script (for any object)

//---------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------


//---------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------

void SCDestroyUndead(object oPC, int bDestroy=FALSE) // KILLS ALL DOMINATED CREATURES OF A PC
{//   int nCnt = GetLocalInt(oPC, "UNDEADCOUNT"); // COMMENTED SO THAT IT HANDLES ALL DOMINATED MONSTERS
//   if (nCnt==0) return;
	object oArea = GetArea(oPC);
	object oMinion = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oMinion)) {
		if (GetLocalObject(oMinion, "DOMINATED")==oPC) {
			DeleteLocalObject(oMinion, "DOMINATED");
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_turn_undead.sef", oMinion), oMinion);
			if ( bDestroy || CSLGetIsInTown(oMinion))
			{
				effect eKill = EffectDamage(GetCurrentHitPoints(oMinion)*2);
				DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oMinion));
				DestroyObject(oMinion, 1.0);
			}
			else
			{
				ChangeToStandardFaction(oMinion, STANDARD_FACTION_HOSTILE);
				object oMember = GetFirstFactionMember(oPC);
				if (GetIsObjectValid(oMember)) {
					if (CSLPCIsClose(oMember, oMinion, 10)) {
						AssignCommand(oMinion, ActionMoveToObject(oMember, TRUE, 4.0));
						AssignCommand(oMinion, ActionAttack(oMember));
					}        
				}
			}
		}
		oMinion = GetNextObjectInArea(oArea);
	}
	DeleteLocalInt(oPC, "UNDEADCOUNT");
}

void CSLShowDMBar( object oPC )
{
	DisplayGuiScreen(oPC, "SCREEN_DMCTOOLBAR2", FALSE, "dmctoolbar2.xml"); // not sure how much of this will work, but i can likely do some work arounds on this to make it work better on the client.
	//
	int bHidden = ( GetIsDM( oPC ) || GetIsDMPossessed(oPC) );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "CREATOR_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "CREATOR_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "CHOOSER_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "TRAPS_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "VISIBILITY_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PAUSE_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "CAMERA_TOGGLE_BUTTON", !bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCINVISIBILITY_TOGGLE_BUTTON", bHidden );
	SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCVISIBILITY_TOGGLE_BUTTON", TRUE );
}

void DMFI_ClientEnter(object oPC)
{
	// if (DEBUGGING >= 6) { CSLDebug(  "DMFI_ClientEnter Start", oPC ); }
	// PURPOSE: Called from the module event OnClientEnter ONLY.  Gives the
	// entering player a DMFI Tool and lists plugins and languages granted.
	// Original Scripter: Demetrious
	// Last Modified By: Demetrious  1/10/7
	object oTool;
	string sTest, sResRef;
	string sVersion;
	int nAppear;
	
	// Delete this just in case
	DeleteLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	
	if (!GetIsPC(oPC))
	{
		return;
	}
	
	//return;
	
	//SendMessageToPC( oPC , "DMFI Client Enter");
	
	oTool = GetItemPossessedBy(oPC, DMFI_ITEM_TAG);
	sVersion = GetLocalString(oTool, DMFI_TOOL_VERSION);
	sResRef = GetResRef(oTool);
	
	// This block ensures PCs and DMs don't have each others tools.
	if (CSLGetIsDM(oPC))
	{
		if (sResRef!=DMFI_TOOL_RESREF)
		{
			SetPlotFlag(oTool, FALSE);
			DestroyObject(oTool);
			oTool=OBJECT_INVALID;
		}
	}
	else
	{
		if (sResRef!=DMFI_PCTOOL_RESREF)
		{
			SetPlotFlag(oTool, FALSE);
			DestroyObject(oTool);
			oTool=OBJECT_INVALID;
		}
	}
				
	// no longer destroying invalid tools
	// Verifies the version of the possessed tool	
	//if ((sVersion!=MOD_VERSION) && (GetIsObjectValid(oTool)))
	//{
	//	CSLMessage_SendText(oPC, "DMFI Tool Error: Incorrect Version / Updating.");
	//	//DMFI_TransferTempLangData(oTool, oPC);  // write a list to the PC as a temp listing
	//	SetPlotFlag(oTool, FALSE);
	//	DestroyObject(oTool);
	//	oTool=OBJECT_INVALID;
	//}	
		
	if (oTool==OBJECT_INVALID)
	{// Invalid Tool
		location lLoc = GetLocation(oPC);
		if (CSLGetIsDM(oPC))
		{ // DM invalid tool code
			sVersion = GetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION);
			if (sVersion!=MOD_VERSION)
			{
				
				DestroyCampaignDatabase(DMFI_DATABASE);
				CSLMessage_SendText(oPC, "DATABASE INVALID:  Requires rebuilding.");
				oTool = CreateItemOnObject(DMFI_TOOL_RESREF,oPC);
			}		
			else
			{
				oTool = RetrieveCampaignObject(DMFI_DATABASE, DMFI_TOOL_RESREF, lLoc, oPC);
				CSLMessage_SendText(oPC, "DMFI DATABASE Version: " + sVersion);
				if (!GetIsObjectValid(oTool))
				{
					oTool = CreateItemOnObject(DMFI_TOOL_RESREF,oPC);
				}
				else
				{
					CSLMessage_SendText(oPC, "DMFI Tool Retrieved from database.");
					AssignCommand(oPC, ActionPickUpItem(oTool));
				}
			}
			// clear any invalid dynamic data just in case	
			DeleteLocalInt(oTool, DMFI_VFX_RECENT);				
			SetLocalObject(oTool, "DMFIToolPC", oPC);
			SetLocalObject(oPC, DMFI_TOOL, oTool);
			SetDroppableFlag(oTool, FALSE);
	}
	else
	{ // PC invalid code
			sVersion = GetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION);
			if (sVersion!=MOD_VERSION)
			{
				DestroyCampaignDatabase(DMFI_DATABASE);
				CSLMessage_SendText(oPC, "DATABASE INVALID:  Requires rebuilding.");
				oTool = CreateItemOnObject(DMFI_PCTOOL_RESREF,oPC);
			}		
			else
			{
				oTool = RetrieveCampaignObject(DMFI_DATABASE, DMFI_PCTOOL_RESREF, lLoc, oPC);
				CSLMessage_SendText(oPC, "DMFI DATABASE Version: " + sVersion);
				if (!GetIsObjectValid(oTool))
				{
					oTool = CreateItemOnObject(DMFI_PCTOOL_RESREF,oPC);
				}
				else
				{
					CSLMessage_SendText(oPC, "DMFI Tool Retrieved from database.");
					AssignCommand(oPC, ActionPickUpItem(oTool));
				}
			}	
			
			SetLocalObject(oTool, "DMFIToolPC", oPC);
			SetLocalObject(oPC, DMFI_TOOL, oTool);
			SetDroppableFlag(oTool, FALSE);
	}
	} // Invalid Tool

	else
	{ // Valid Tool - simply link.
		SetLocalObject(oTool, "DMFIToolPC", oPC);
		SetLocalObject(oPC, DMFI_TOOL, oTool);
		SetDroppableFlag(oTool, FALSE);
	}
	
	//DMFI_InitializeModule(oPC);
	//DelayCommand(2.0, DMFI_VerifyToolData(oPC, oTool));
}


void DMFI_InitializeTool(object oPC, object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InitializeTool Start", oPC ); }
	//Purpose: Destroys the current Tool and creates a new one - this will reset
	// any preferences or variables on the tool
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/26/6
	string sResRef;	
	
	//DMFI_TransferTempLangData(oTool, oPC);  // write a list to the PC as a temp listing
	DestroyCampaignDatabase(DMFI_DATABASE);
	
	SetPlotFlag(oTool, FALSE);
	DestroyObject(oTool);
	object oListener = GetLocalObject(oPC, "oDMFIListener");
	DestroyObject(oListener);
	CSLMessage_SendText(oPC, "DMFI Database Detroyed.", TRUE, COLOR_GREEN);
	DelayCommand(3.0, DMFI_ClientEnter(oPC));
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InitializeTool End", oPC ); }
}

/*
void DMFI_InitializeModule(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InitializeModule Start", oPC ); }
	//Purpose: Gives version number and initialization text and if needed, will
	//call DMFI_InitializePlugins.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 7/7/6
	//CSLMessage_SendText(oPC, "DMFI Base System Version: " + MOD_NAME, FALSE, COLOR_CYAN);
	
	//if (GetObjectByTag(DMFI_FILE_LOCKER)==OBJECT_INVALID)
	//{
	//	DMFI_InitializePlugins(oPC);
	//}
	//DelayCommand( 7.0f, DMFI_ListPlugins(oPC) );
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InitializeModule End", oPC ); }
}
*/



void SCDestroyIfCursed(object oPC, object oItem)
{
   if (GetItemCursedFlag(oItem) && GetTag(oItem)!="dmfi_exe_tool")
   {
      SDB_LogMsg("CRAFT", "Destroy " + GetName(oItem), oPC);
      SetPlotFlag(oItem, FALSE);
      DestroyObject(oItem, 0.1);
   }
}

void SCCheckInv(object oPC)
{
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem))
	{
		if (GetResRef(oItem)=="bottomlessmug")
		{
			CreateItemOnObject("bottomless_mug", oPC);
			DestroyObject(oItem, 0.1);
		}
		SCDestroyIfCursed(oPC, oItem);
		oItem = GetNextItemInInventory(oPC);
	}
	int i;
	for (i = 0;i<INVENTORY_SLOT_CWEAPON_L;i++)
	{
		oItem = GetItemInSlot(i, oPC);
		if (GetIsObjectValid(oItem))
		{
			SCDestroyIfCursed(oPC, oItem);
		}
	}
}


void SCLoadDataObjects()
{
	DelayCommand( CSLRandomBetweenFloat( 0.1f, 0.25f ), CSLGetPreferenceDataObject() );
	//DelayCommand(60.0f, SendMessageToPC(GetFirstPC(),"Ran load dataobject function  60 secs ago") );
	DelayCommand(10.0f, ExecuteScript("_mod_onmoduleloaddata", OBJECT_SELF) );

}



void SCGrantHolyItems( object oPC )
{
	if( CSLGetPreferenceSwitch("RequireHolyItems", FALSE ) )
	{
		if ( CSLGetBaseCasterType( GetClassByPosition(1, oPC) ) == SC_SPELLTYPE_DIVINE || CSLGetBaseCasterType( GetClassByPosition(2, oPC) ) == SC_SPELLTYPE_DIVINE || CSLGetBaseCasterType( GetClassByPosition(3, oPC) ) == SC_SPELLTYPE_DIVINE || CSLGetBaseCasterType( GetClassByPosition(4, oPC) ) == SC_SPELLTYPE_DIVINE )
		{
			if ( !GetLocalInt(GetModule(), "CSL_HASHOLY_"+GetName(oPC) ) )
			{
				SetLocalInt(GetModule(), "CSL_HASHOLY_"+GetName(oPC), TRUE ); // this clears per reset basically
				object oHolyItem = CSLCreateSingleItemOnObject("cslholyitem", oPC, 1, "HOLY_ITEM_"+GetName(oPC) );    // Holy Item
				if ( GetIsObjectValid( oHolyItem ) )
				{
				// SetItemIcon(oHolyItem, 1249); // it_qi_tyrholysymbol
				SetFirstName(oHolyItem,"Holy Symbol of "+GetDeity(oPC));
				//SetLastName(oHolyItem,"");
				SetIdentified(oHolyItem, TRUE);
				SetDroppableFlag(oHolyItem, FALSE);
				SetPickpocketableFlag( oHolyItem, TRUE );
				
				SendMessageToPC( oPC, "You have been given a holy item, you need to keep possession of it or your god won't be able to hear you!");
				}
				else
				{
					SendMessageToPC( oPC, "Holy Item resref cslholyitem not found, disabling option");
					CSLSetPreferenceSwitch("RequireHolyItems", FALSE );
				
				}
			}
		}
	}
}


void SCRemoveTempWeaponBuffs(object oPC)
{
    CSLRemoveAllItemProperties(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), DURATION_TYPE_TEMPORARY);
    CSLRemoveAllItemProperties(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), DURATION_TYPE_TEMPORARY);
    CSLRemoveAllItemProperties(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), DURATION_TYPE_TEMPORARY);
    CSLRemoveAllItemProperties(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC),  DURATION_TYPE_TEMPORARY);
    CSLRemoveAllItemProperties(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), DURATION_TYPE_TEMPORARY);
}

void SCLogInMessage(object oPC, string sMsg, float fDelay = 0.0)
{
   if (fDelay>0.0) DelayCommand(fDelay, FloatingTextStringOnCreature(sMsg, oPC, FALSE));
   else FloatingTextStringOnCreature(sMsg, oPC, FALSE);
} 

void SCReQuipHands(object oPC, int bAgain = TRUE)
{
   object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   object oLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
   if (oRight!=OBJECT_INVALID) {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionUnequipItem(oRight));
      DelayCommand(0.1, AssignCommand(oPC, ActionEquipItem(oRight, INVENTORY_SLOT_RIGHTHAND)));
   }
   if (oLeft!=OBJECT_INVALID) {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionUnequipItem(oLeft));
      DelayCommand(0.2, AssignCommand(oPC, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND)));
   }
   if (bAgain) DelayCommand(0.5, SCReQuipHands(oPC, FALSE)); // DO IT A SECOND TIME
}

void SCReQuip(object oPC, int nSlot, int bAgain = TRUE)
{
   object oItem = GetItemInSlot(nSlot, oPC);
   if (oItem==OBJECT_INVALID) return;
   AssignCommand(oPC, ClearAllActions(TRUE));
   AssignCommand(oPC, ActionUnequipItem(oItem));
   DelayCommand(0.1, AssignCommand(oPC, ActionEquipItem(oItem, nSlot)));
   if (bAgain) DelayCommand(0.2, SCReQuip(oPC, nSlot, FALSE)); // DO IT A SECOND TIME
}


void SCBooter(object oPC, string sMsg)
{
   CSLMsgBox(oPC, "ERROR!! Please relog. " + sMsg, "Darn");
   DelayCommand(6.0, BootPC(oPC));  
}


void SCFixFeats( object oPC )
{
	if ( GetLevelByClass( CLASS_TYPE_SACREDFIST, oPC ) > 0 )
	{
		if ( CSLGetPreferenceSwitch("UseSacredFistFix",FALSE) )
		{
			if (GetHasFeat(2103, oPC))
			{
				FeatRemove(oPC, 2103);
				FeatAdd(oPC, FEAT_SACREDFIST_CODE_OF_CONDUCT, FALSE);
			}
		}
	}
	else
	{
		FeatRemove(oPC, FEAT_SACREDFIST_CODE_OF_CONDUCT );
	}
}


/// from on activate item
int SCCheckDMItem(object oDM)
{ 
   if (!CSLVerifyDMKey(oDM)) {
      object oItem = GetItemActivated();
      SetPlotFlag(oItem, FALSE); 
      DestroyObject(oItem);
      SendMessageToPC(oDM, "You are not a DM. Your action has been logged.");
      return FALSE;
   } 
   return TRUE;
}  



void SCDestroyEmpties(object oItem)
{  
   if (!GetItemCharges(oItem)) DestroyObject(oItem);  
}   


void SCWalkAround(object oWalker)
{
	AssignCommand(oWalker, ClearAllActions());
	AssignCommand(oWalker, ActionRandomWalk());
}

void SCMakeThemWalk()
{
	int i = 0;
	object oGhost = GetObjectByTag("LOSTSOUL", i);
	while (oGhost!=OBJECT_INVALID)
	{
		SCWalkAround(oGhost);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_SPELL_GHOSTLY_VISAGE)), oGhost);
		i++;
		oGhost = GetObjectByTag("LOSTSOUL", i);
	}
	SetLocalInt(GetModule(), "GHOSTCOUNT", i);
	SetLocalInt(GetModule(), "GHOSTCURRENT", 0);
	
	i = 0;
	object oChicken = GetObjectByTag("c_chicken", i);
	while (oChicken!=OBJECT_INVALID)
	{
		SCWalkAround(oChicken);
		oChicken = GetObjectByTag("c_chicken", ++i);
	}
	SCWalkAround(GetObjectByTag("c_cat"));
	DelayCommand(300.0, SCMakeThemWalk());
}

//void SCSetModuleClock()
//{
//
//
//
//
//}

void SCBootInactivePlayers() // RUNS ONCE EVERY 2 MINUTES
{
	
	int iMaxServerCount = CSLGetPreferenceInteger( "PWHeavyKickServerCount", 25);
	int iMinServerCount = CSLGetPreferenceInteger( "PWLightKickServerCount", 10);
	
	int nCount = CSLCountPlayers();
	
	if ( nCount < iMinServerCount )
	{
		return;
	}
	
	
	int iMinutesOverMax = CSLGetPreferenceInteger( "PWKickMinutesOverMax", 10);
	int iMinutesUnderMax = CSLGetPreferenceInteger( "PWKickMinutesUnderMax", 30);
	int iRoundsWithoutChat = CSLGetPreferenceInteger( "PWKickRoundsWithoutChat");
	int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
	if ( iCurrentRound == 0 )
	{
		// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
		// attached to environment since that is doing other work this is combined with
		CSLEnviroGetControl();
	}
	
	int nInactive;
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{
		if ( ! CSLGetIsDM(oPC, TRUE) )
		{
			if (nCount == iMaxServerCount ) // && !IsInConversation(oPC)
			{
				nInactive = iMinutesOverMax; // IF SERVER FULL AND NOT IN A CONVERSATION GIVE THEM 10 "Minutes" TO MOVE or talk
			}
			else
			{
				nInactive = iMinutesUnderMax; // GIVE THEM 24 "Minutes" TO MOVE or talk
			}
			//string sLocNow  = CSLSerializeLocation(GetLocation(oPC));
			//string sLocLast = GetLocalString(oPC, "LASTLOC");
			
			// if moving or talking let em continue
			if ( CSLCompareLastPosition( oPC, "LASTLOC" ) && ( iCurrentRound-GetLocalInt( oPC, "CSL_CHAT_LASTSPOKE_ROUND") ) <= iRoundsWithoutChat ) // THEY MOVED SAVE THE NEW LOCATION
			{
				SetLocalInt(oPC, "LASTLOCCNT", 0);
			}
			else
			{ // SAME LOCATION AS LAST CHECK
				int nBeatCnt = CSLIncrementLocalInt(oPC, "LASTLOCCNT");
				
				int nAreaInactive = GetLocalInt( GetArea( oPC ),"INACTIVE_MINUTES" );
				
				if ( nAreaInactive > 0 && nBeatCnt >= nAreaInactive )
				{
					// we have a lurker in the given area
					string sAreaBootScript = GetLocalString( GetArea( oPC ), "INACTIVE_SCRIPT" );
					if ( sAreaBootScript != "" )
					{
						DelayCommand( 0.1f, ExecuteScript( sAreaBootScript, oPC ) );
					}
				}
				
				
				
				
				if ( nCount < 6 )
				{
					// let them stay on regardless...
				}
				else if ( IsInConversation(oPC) && nBeatCnt >= nInactive && nBeatCnt < iMinutesUnderMax )
				{
					SendMessageToPC(oPC, "<color=red>You have been inactive for " + IntToString(nBeatCnt ) + " minutes but are in a conversation. You will be booted if you haven't moved for " + IntToString( iMinutesUnderMax ) + " minutes while in convo.</color>");
				}
				else if ( nBeatCnt >= nInactive ) // HAVEN'T MOVED IN MAX ALLOWED MINUTES, GIVE THEM THE BOOT
				{
					SetLocalInt(oPC, "LASTLOCCNT", 0);
					BootPC(oPC);
				}
				else if (nBeatCnt>=(nInactive-2)) // GIVE THE 2 MINUTE COUNT DOWN WARNING
				{
					SendMessageToPC(oPC, "<color=red>You have been inactive for " + IntToString(nBeatCnt ) + " minutes. You will be booted if you haven't moved for " + IntToString( nInactive ) + " minutes.</color>");
				}
				else if (nBeatCnt>=(nInactive-4)) // GIVE THE 4 MINUTE COUNT DOWN WARNING
				{
					SendMessageToPC(oPC, "<color=orange>You have been inactive for " + IntToString(nBeatCnt ) + " minutes. You will be booted if you haven't moved for " + IntToString( nInactive ) + " minutes.</color>");
				}
			}
			// *** HANDLE SAVING PARTY LEADER INFO TO REJOIN AFTER A CRASH
			CSLSaveParty(oPC, CSLGetPartyMember(oPC));
		}  
		oPC = GetNextPC();
	}
	//DelayCommand( 60.0f, BootInactivePlayers());
}

int SCGetMaxUptime()
{
	int iMaxUptime = GetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME" );
	if ( iMaxUptime == -1 )
	{
		return 0;
	}
	else if ( iMaxUptime == 0 ) // not set, go ahead and get it set
	{
		if ( CSLGetIsPreferenceDataObjectLoaded() )
		{
			iMaxUptime = CSLGetPreferenceInteger( "PWUptimeMinutesBeforeReset", 0);
			if ( iMaxUptime < 1 )
			{
				iMaxUptime = -1;
			}
			else if ( iMaxUptime > 60 ) // adjust for minutes, so as to allow servers to tend to restart on even hours
			{
				int iMinutes = 0;
				CSLNWNX_SQLExecDirect("select minute(now());");
				if (CSLNWNX_SQLFetch()) 
				{
					iMinutes = CSLNWNX_SQLGetDataInt(1);
					
				}
				iMaxUptime - iMinutes;
			}
			
			SetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME", iMaxUptime);
		}
	}
	return iMaxUptime;
}

void CheckItemForConBonus(object oItem)
{
	int nConBonusCount;
	itemproperty iProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ABILITY_BONUS)
		{	
			if (GetItemPropertySubType(iProp) == ABILITY_CONSTITUTION)
			{
				nConBonusCount = GetLocalInt(OBJECT_SELF, "ConBonusCount");
				nConBonusCount++;
				SetLocalInt(OBJECT_SELF, "ConBonusCount", nConBonusCount); 
			}
		}
		iProp = GetNextItemProperty(oItem);
	}
}

void cmi_pc_loaded( object oPC )	
{
	
//Reserved for future patching of PrC classes. 
/*
	object oPC = OBJECT_SELF;
		
	int bResetNeeded = FALSE;	
	if (bResetNeeded)
	{
		SendMessageToPC(oPC,"Level will be reset due to changes allowing community content for PrCs to be merged.  I apologize for the inconvenience.  This should be rare in the future.");	
		int iExp = GetXP(oPC);
		SetXP(oPC,1);
		SetXP(oPC,iExp);									
	}
*/

	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC ) > 0)
	{
		CSLFixFavoredWeaponFeat( oPC );
	}
	
	CSLFixCounterspellFeat( oPC );
	
	if (GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oPC) > 1)
	{
		DelayCommand(1.0f, ExecuteScript("EQ_deathsruin",oPC));		
	}
	
	if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE) > 0)
	{
		if (!GetHasFeat(FEAT_DRAGON_DIS_GENERAL, oPC))
		{
			FeatAdd(oPC, FEAT_DRAGON_DIS_GENERAL, FALSE);
			FeatAdd(oPC, FEAT_DRAGON_DIS_RED, FALSE);
			SetLocalInt(oPC, "DragonDisciple", 1);	
		}
	}
	
	if (GetLevelByClass(CLASS_LYRIC_THAUMATURGE) > 9)
	{
		if (!GetHasFeat(1246, oPC, TRUE)) //FEAT_PRACTICED_SPELLCASTER_BARD
		{
			FeatAdd(oPC,1246,FALSE);
		}
	}
	
	int nBladesinger = GetLevelByClass(CLASS_BLADESINGER,oPC);
	
	

	object oHideArmor = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
 	if (GetIsObjectValid(oHideArmor))
	{
		DelayCommand(0.1f, ActionUnequipItem(oHideArmor));
		DelayCommand(0.3f, ActionEquipItem(oHideArmor, INVENTORY_SLOT_CARMOUR ));
	}
	object oCWeap1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
 	if (GetIsObjectValid(oCWeap1))
	{
		DelayCommand(0.1f, ActionUnequipItem(oCWeap1));
		DelayCommand(0.3f, ActionEquipItem(oCWeap1, INVENTORY_SLOT_CWEAPON_B ));
	}
	object oCWeap2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
 	if (GetIsObjectValid(oCWeap2))
	{
		DelayCommand(0.1f, ActionUnequipItem(oCWeap2));
		DelayCommand(0.3f, ActionEquipItem(oCWeap2, INVENTORY_SLOT_CWEAPON_L ));
	}
	object oCWeap3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
 	if (GetIsObjectValid(oCWeap3))
	{
		DelayCommand(0.1f, ActionUnequipItem(oCWeap3));
		DelayCommand(0.3f, ActionEquipItem(oCWeap3, INVENTORY_SLOT_CWEAPON_R ));
	}


	if (GetLevelByClass(CLASS_TYPE_PALADIN) > 0)
	{
		if (!GetHasFeat(FEAT_LAYONHANDS_HOSTILE, oPC, TRUE))
		{
			FeatAdd(oPC,FEAT_LAYONHANDS_HOSTILE,FALSE);
		}
	}
	
	if (GetLevelByClass(CLASS_TYPE_DIVINECHAMPION) > 0)
	{
		if (!GetHasFeat(FEAT_LAYONHANDS_HOSTILE, oPC, TRUE))
		{
			FeatAdd(oPC,FEAT_LAYONHANDS_HOSTILE,FALSE);
		}
		if ( CSLGetPreferenceSwitch("DivChampSpellcastingProgression",FALSE) )
		{
			if (!GetHasFeat(FEAT_DIVCHA_SPELLCASTING))
			{
				FeatAdd(oPC,FEAT_DIVCHA_SPELLCASTING,FALSE);
			}
		}
	}
	
	if (GetLevelByClass(CLASS_HOSPITALER) > 0) //Hospitaler
	{
		if (!GetHasFeat(FEAT_LAYONHANDS_HOSTILE, oPC, TRUE))
		{
			FeatAdd(oPC,FEAT_LAYONHANDS_HOSTILE,FALSE);
		}	
	}
	
	
	if ( CSLGetPreferenceSwitch("PlanetouchedGetMartialWeaponProf",FALSE) )
	{
		if (GetRacialType(oPC) == 21)
		{
			if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL ,oPC))
			{
				FeatAdd(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL, TRUE);
			}
		}
	}
	
	
	if ((GetSubRace(oPC) == RACIAL_SUBTYPE_HUMAN_DEEP_IMASKARI_ROF) && (GetHitDice(oPC) == 1) )
	{	
		int iFirstClass = GetClassByPosition(1, oPC);
		if (iFirstClass == CLASS_TYPE_WIZARD)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_WIZARD_LEVEL1, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_SORCERER)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_SORCERER_LEVEL1, FALSE, TRUE,TRUE);	
		}
		else if (iFirstClass == CLASS_TYPE_BARD)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_BARD_LEVEL1, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_CLERIC)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_CLERIC_LEVEL1, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_FAVORED_SOUL)
		{
			FeatAdd(oPC, 2070, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_DRUID)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_DRUID_LEVEL1, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_PALADIN)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_PALADIN_LEVEL1, FALSE, TRUE,TRUE);					
		}
		else if (iFirstClass == CLASS_TYPE_RANGER)
		{
			FeatAdd(oPC, FEAT_EXTRA_SLOT_RANGER_LEVEL1, FALSE, TRUE,TRUE);
		}
		else if (iFirstClass == CLASS_TYPE_SPIRIT_SHAMAN)
		{
			FeatAdd(oPC, 2005, FALSE, TRUE,TRUE);			
		}
	}
	//SpeakString("cmi_pc_loaded" ,TALKVOLUME_SHOUT);
	/*
	if (GetLocalInt(GetModule(),"CMI_Supported"))
	{
		return;
	}
	else
	{
		ExecuteScript("cmi_pw_mod_start",GetModule());					
	}
	*/
					
	if (GetHasFeat(FEAT_CROSSBOW_SNIPER, oPC, TRUE))
	{
		DeleteLocalInt(oPC,"XbowSniper");
		//DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_crossbowsnip",oPC));
	}
	
	if (GetActionMode(OBJECT_SELF, 24) == TRUE)
	{
		SetActionMode(OBJECT_SELF, 24, FALSE);
		SetActionMode(OBJECT_SELF, 24, TRUE);		
	}
		
	//This will update the count of Con items on the player since localints are lost on logout
	object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
	CheckItemForConBonus(oItem);	
    oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	CheckItemForConBonus(oItem);
	
	

	
}



void SCDoSpreeBonus(object oKiller, object oKilled) {
   int nKilledKills = GetLocalInt(oKilled, "SPREEKILLS");
   if (nKilledKills >= 10) CSLShoutMsg(GetName(oKiller) + " broke " + GetName(oKilled) + "'s Killing Spree!");
   DeleteLocalInt(oKilled, "SPREEKILLS"); // CLEAR ANY SPREE THE KILLED PLAYER MAY HAVE BEEN ON
   if (oKilled==GetLocalObject(oKiller, "LASTKILLEDPC")) {
      SendMessageToPC(oKiller, "No Spree Bonus is awarded for killing the same player repeatedly.");
      return;
   }
   if ((GetHitDice(oKiller)-GetHitDice(oKilled)) >= 15) {
      SendMessageToPC(oKiller, "No Spree Bonus is awarded for killing a player that is 15 levels lower than you.");
      return;
   }
   SetLocalObject(oKiller, "LASTKILLEDPC", oKilled); // SAVE MY LAST KILL SO IT IS NOT COUNTED TWICE
   int nKills = CSLIncrementLocalInt(oKiller, "SPREEKILLS"); // GET VALUE AND ADD ONE
   if (nKills<10 || (nKills % 5)) return; // LESS THAN 10 or NOT A MULTIPLE OF 5 SO EXIT
   string sMsg = GetName(oKiller) + " is on a ";
   effect eBonus;
   if (nKills==10) {
      sMsg    += CSLColorText("KILLING SPREE", COLOR_BLUE_DARK);
      eBonus   = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
      eBonus   = EffectLinkEffects(eBonus, EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW));
   } else if (nKills==15) {
      sMsg    += CSLColorText("ENORMOUS KILLING SPREE", COLOR_BLUE);
      eBonus   = EffectConcealment(30);
   } else if (nKills==20) {
      sMsg    += CSLColorText("HUMONGOUS KILLING SPREE", COLOR_GREEN_DARK);
      eBonus   = EffectDamageReduction(15, DAMAGE_POWER_PLUS_TWENTY);
   } else if (nKills==25) {
      sMsg    += CSLColorText("MONSTROUS KILLING SPREE", COLOR_GREEN);
      eBonus   = EffectDamageShield(15, DAMAGE_BONUS_1d6, DAMAGE_TYPE_PIERCING);
   } else if (nKills==30) {
      sMsg    += CSLColorText("GLORIOUS KILLING SPREE", COLOR_YELLOW);
      eBonus   = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
   } else if (nKills==35) {
      sMsg    += CSLColorText("OUTRAGEOUS KILLING SPREE", COLOR_ORANGE);
      eBonus   = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
      eBonus   = EffectLinkEffects(eBonus, EffectVisualEffect(VFX_DUR_GLOW_RED));
   } else { // HOLY CRAP 40+ KILLS!!
      sMsg    += CSLColorText("PREPOSTEROUS KILLING SPREE", COLOR_RED);
      eBonus   = EffectHeal(100);
   }
   sMsg += " with " + IntToString(nKills) + " Kills!!";
   CSLShoutMsg(sMsg);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oKilled)), oKiller);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eBonus), oKiller);
}

void SCKillShoutAndSpreeBonus(object oKiller, object oKilled) {
   int bSlag = (GetTag(oKiller)=="slag"); 
   if (!bSlag && !GetIsPC(oKiller)) return; // ONLY SLAG && PC'S!
   string sKiller = GetName(oKiller) + " (" + IntToString(GetHitDice(oKiller)) + ")";
   string sKilled = GetName(oKilled) + " (" + IntToString(GetHitDice(oKilled)) + ")";
   string sMsg    = sKiller;
    // Check if this kill was a faction kill or suicide
   if (bSlag)
   {
      if ( Random(100) > 80 )
      { 
      	sMsg = "Slag managed to choke down the very tasteless and stringy " + sKilled;
      }
      else
      {
      	sMsg = "Slag has eaten " + sKilled;
      }
      SCDoSpreeBonus(oKiller, oKilled);   
   } else if (oKiller==oKilled) { // Do suicide
      sMsg += " has commited suicide!";
   } else if (SDB_GetFAID(oKiller)==SDB_GetFAID(oKilled) && SDB_FactionIsMember(oKiller)) {
      sMsg += " has killed his factionmate " + sKilled;
   } else {
      sMsg += " has killed " + sKilled;
      SCDoSpreeBonus(oKiller, oKilled);
   }
   CSLShoutMsg(sMsg);
   CSLNWNX_SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +
      CSLDelimList(CSLInQs(SDB_GetSEID()), "0", CSLInQs("X"), CSLInQs(sMsg), "0") + ")");

}

// Resurrect and remove negative effects from oPC
void SCRaise(object oPC) {
   effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)), oPC);
   //Search for negative effects
   effect eBad = GetFirstEffect(oPC);
   while(GetIsEffectValid(eBad)) {
      if (GetEffectType(eBad)==EFFECT_TYPE_ABILITY_DECREASE ||          GetEffectType(eBad)==EFFECT_TYPE_AC_DECREASE ||
          GetEffectType(eBad)==EFFECT_TYPE_ATTACK_DECREASE ||           GetEffectType(eBad)==EFFECT_TYPE_DAMAGE_DECREASE ||
          GetEffectType(eBad)==EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||  GetEffectType(eBad)==EFFECT_TYPE_SAVING_THROW_DECREASE ||
          GetEffectType(eBad)==EFFECT_TYPE_SPELL_RESISTANCE_DECREASE || GetEffectType(eBad)==EFFECT_TYPE_SKILL_DECREASE ||
          GetEffectType(eBad)==EFFECT_TYPE_BLINDNESS ||                 GetEffectType(eBad)==EFFECT_TYPE_DEAF ||
          GetEffectType(eBad)==EFFECT_TYPE_PARALYZE ||                  GetEffectType(eBad)==EFFECT_TYPE_NEGATIVELEVEL) {
         //Remove effect if it is negative.
         RemoveEffect(oPC, eBad);
      }
      eBad = GetNextEffect(oPC);
   }
   //Fire cast spell at event for the specified target
   SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
   CloseGUIScreen( oPC, GUI_DEATH );
   CloseGUIScreen( oPC, GUI_DEATH_HIDDEN );
   CSLEnviroRemoveEffects( oPC );
}

void SCStealItem(object oKiller, object oKilled, int bSteal=FALSE) {
   if (!GetIsPC(oKiller)) { // ONLY MONSTERS WILL KILL STEAL
      if (!bSteal) { // FIRST TIME IN, DO THE ANIMATION
         object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
         if (oCreature==OBJECT_INVALID || GetDistanceBetween(oCreature, oKiller) < 10.0) { // NO PLAYERS CLOSE BY, LET'S LOOT!
            AssignCommand(oKiller, ClearAllActions(TRUE));
            AssignCommand(oKiller, ActionMoveToObject(oKilled, TRUE));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW));
            AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_FIREFORGET_KNEELFIDGET, 1.0, 3.0));
            DelayCommand(6.0, SCStealItem(oKiller, oKilled, TRUE)); // CALL AGAIN, THIS TIME TO STEAL AN ITEM
         }
      } else { // SECOND PASS
         if (GetIsDead(oKilled) && !GetIsInCombat(oKiller)) { // HE'S STILL DEAD AND I'M NOT FIGHTING, SO LOOT THE SOB
            object oItem = GetFirstItemInInventory(oKilled);
            if (d2()==1) oItem = GetNextItemInInventory(oKilled);
            if (d3()==1) oItem = GetNextItemInInventory(oKilled);
            if (d4()==1) oItem = GetNextItemInInventory(oKilled);
            if (oItem!=OBJECT_INVALID) {
               SendMessageToPC(oKilled, GetName(oKiller) + " has stolen your " + GetName(oItem));
               SetLocalInt(oKiller, "THIEF", TRUE);
               AssignCommand(oKiller, ActionTakeItem(oItem, oKilled));
               SetDroppableFlag(oItem, TRUE);
            }
         }
      }
   }
}




void SCCauseFailure( object oTarget )
{
   		effect eSwapFailure = EffectSpellFailure(100);
		eSwapFailure = EffectLinkEffects(eSwapFailure, EffectMissChance(100, MISS_CHANCE_TYPE_NORMAL ) );
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSwapFailure, oTarget, RoundsToSeconds( 2 ) );
		ClearAllActions();
		ActionWait( RoundsToSeconds( 2 ) );
}

/*
void cmi_HealIfNeeded(object oPC, int nActualTableValue)
{
	//SendMessageToPC(OBJECT_SELF, "nCon1: " + IntToString(GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE)));
	//SendMessageToPC(OBJECT_SELF, "nCon2: " + IntToString(GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE)));
	int nConBonus = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
	int nTableValue;
	if (nConBonus > 0)
		nTableValue = (nActualTableValue + 1) / 2;
	else
		nTableValue = nActualTableValue / 2;
									
	if (nTableValue > 0)
	{	
		int nHeal = nTableValue * GetHitDice(oPC);
		effect eHeal = EffectHeal(nHeal);
		DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC));;		
	}		
}
*/


void cmi_HealIfNeeded(object oPC, int nActualTableValue)
{
	int nConBonus = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
	int	nBonus = StringToInt(Get2DAString("racialsubtypes.2da", "ConAdjust", GetSubRace(OBJECT_SELF)));
	nConBonus = nConBonus - nBonus;
	
	int nBase1 = (GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) + 1) / 2;
	int nBase2 = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) / 2;
	//SendMessageToPC(OBJECT_SELF, "nBase1: " + IntToString(nBase1));
	//SendMessageToPC(OBJECT_SELF, "nBase2: " + IntToString(nBase2));
	//SendMessageToPC(OBJECT_SELF, "nActualTableValue: " + IntToString(nActualTableValue));
	//SendMessageToPC(OBJECT_SELF, "nConBonus: " + IntToString(nConBonus));	
	
	int nTableValue;
	if (nConBonus > 0)
	{
		if ((nBase1 - nBase2) > 0)
		{
			nTableValue = (nActualTableValue) / 2;	
		}
		else
		{
			nTableValue = (nActualTableValue + 1) / 2;
		}
	}
	else
	{
		nTableValue = nActualTableValue / 2;
	}
		
	//if (nConBonus >= nActualTableValue)
	//	nTableValue = 0;	
									
	if (nTableValue > 0)
	{	
		int nHeal = nTableValue * GetHitDice(oPC);
		effect eHeal = EffectHeal(nHeal);
		//SendMessageToPC(oPC, "nHeal: " + IntToString(nHeal));
		DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC));;		
	}		
}




void cmi_conbonuscheck( object oItem, object oPC )
{
	// make this a real preference
	int nDisableConFix = GetLocalInt(oPC, "DisableConFix");
	if (!nDisableConFix)
	{
		int nCurrentHitPoints;
		int nMaxHitPoints;	
		effect eHeal = EffectHeal(1);
		effect eDamage;
		int nConValue;
		int nHD = GetHitDice(oPC);
		int nTableValue;
		int nBase1 = (GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) + 1) / 2;
		int nBase2 = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE) / 2;
		int nConBonusCount;
		itemproperty iProp = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(iProp))
		{
			if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ABILITY_BONUS)
			{	
				if (GetItemPropertySubType(iProp) == ABILITY_CONSTITUTION)
				{
					nCurrentHitPoints = GetCurrentHitPoints(oPC);
					nMaxHitPoints = GetMaxHitPoints(oPC);
					nConBonusCount = GetLocalInt(OBJECT_SELF, "ConBonusCount");
					nConBonusCount++;
					if (nCurrentHitPoints > nMaxHitPoints)
					{	
						DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC));	
					}
					else
					{
						if ((nBase1 - nBase2) > 0)
						{
							if (nConBonusCount > 1)
							{
								nConValue = ((GetItemPropertyCostTableValue(iProp) + 1)/2) * nHD;
								eDamage = EffectDamage(nConValue, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, TRUE);
								DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
								DelayCommand(0.2f, ClearAllActions(TRUE));
							}
						}
						else
						{
							nTableValue = GetItemPropertyCostTableValue(iProp);
							int nCon = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, FALSE);
							int nBase = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
							int	nBonus = StringToInt(Get2DAString("racialsubtypes.2da", "ConAdjust", GetSubRace(OBJECT_SELF)));
							
							int nAdjusted = nCon - (nBase + nBonus);
							if ((nAdjusted >= nTableValue) || (nConBonusCount == 1))
							{
								nConValue = (GetItemPropertyCostTableValue(iProp)/2) * nHD;
								eDamage = EffectDamage(nConValue, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, TRUE);
								DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
								DelayCommand(0.2f, ClearAllActions(TRUE));
							}
						}
	
					}
					SetLocalInt(OBJECT_SELF, "ConBonusCount", nConBonusCount); 												
				}																
			}
			iProp = GetNextItemProperty(oItem);	
		}	
	}
}


void cmi_player_equip( object oPC )	
{
	// object oPC = OBJECT_SELF;
	int iQuiet = GetLocalInt( oPC, "SC_QUIETMODE" );
	
	
	object oItem = GetPCItemLastEquipped();
	
	
	// not sure what this is doing, might be fixing con bug, lets find out how this works
	cmi_conbonuscheck( oItem, oPC );
	
	if (GetLevelByClass(CLASS_NINJA) > 0)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_ninjacbonus",oPC));
	}
	
	if (GetLevelByClass(CLASS_FIST_FOREST) > 1)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_fotfacbonus",oPC));
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_fotfunarmed",oPC));
	}
	
	if (GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION, oPC))
	{
		if (GetHasFeat(FEAT_GREATER_HEAVY_ARMOR_OPTIMIZATION, oPC))
		{
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_heavyarmorgr",oPC));
		}
		else
		{
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_heavyarmor",oPC));
		}
	}
	
	if (GetHasSpellEffect(SPELL_Blessed_Aim, oPC))
	{
		  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		  if (!GetIsObjectValid(oWeapon) || !GetWeaponRanged(oWeapon))
		  {	
			    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC,oPC, SPELL_Blessed_Aim);		
		  } 		
	}
	
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_B, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_b",oPC));
	}	
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_P, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_p",oPC));
	}	
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_S, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_s",oPC));
	}
				

	if ( CSLGetPreferenceSwitch("UseDmgResFix",FALSE) )
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ApplyDmgResFix(oPC, TRUE));
	}		

	if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_intuitiveatt",oPC));
	}
	
	if (GetLevelByClass(CLASS_DREAD_COMMANDO) > 1)
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_armoredease",oPC));	
	}
	
	if(GetHasFeat(FEAT_FIERY_FIST, oPC) && (GetHasSpellEffect(SPELLABILITY_FIERY_FIST)))
	{
	    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	    object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);

		if (GetIsObjectValid(oWeapon) || GetIsObjectValid(oWeapon2))
		{	
			//RemoveEffectsFromSpell(oPC, SPELLABILITY_FIERY_FIST);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,oPC, SPELLABILITY_FIERY_FIST);	
			if ( !iQuiet ) SendMessageToPC(oPC, "Fiery Fist can not be used while you have weapons equipped.");			
		}		
	}


	if(GetHasFeat(FEAT_SACREDFIST_CODE_OF_CONDUCT, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_sacredfistco",oPC));
	}	
	
	
	if(GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oPC) > 1)
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_deathsruin",oPC));		
	}	
	
	if (GetLevelByClass(CLASS_CHAMPION_WILD, oPC) > 1)
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_cwelegstrike",oPC));		
	
	if(GetHasFeat(FEAT_GTR_2WPN_DEFENSE, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_grt2weapdef",oPC));
	}	
	
	if (GetHasFeat(FEAT_ARMOR_SPECIALIZATION_MEDIUM, oPC) || GetHasFeat(FEAT_ARMOR_SPECIALIZATION_HEAVY, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateArmorSpec(oPC));
	}
	
	if (GetHasFeat(FEAT_OVERSIZE_TWO_WEAPON_FIGHTING, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateOver2WpnFight());
	}
	
	//if (GetHasFeat(FEAT_BATTLE_DANCER, oPC))
	//{
	//	DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateBattleDancer());
	//}	

	//Bladesinger
	int Bladesinger = GetLevelByClass(CLASS_BLADESINGER,oPC);
	if (Bladesinger > 0)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_bsbladesong",oPC));
		
		if ( Bladesinger > 7)
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f),ExecuteScript("EQ_bsbattlecast",oPC));
		else
		if ( Bladesinger > 5 )
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f),ExecuteScript("EQ_armorcaster",oPC));	
										
		//if ( Bladesinger == 10 )
		//	DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f),ExecuteScript("EQ_bssongfury",oPC));				
	}	
	
	// Tempest
	if (GetLevelByClass(CLASS_TEMPEST,oPC) > 0)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_tempestdefen",oPC));
	}	

	// Nightsong Enforcer
	if (GetLevelByClass(CLASS_NIGHTSONG_ENFORCER,oPC) > 0)
	{	
		DelayCommand( CSLRandomBetweenFloat(0.2f,2.0f) , ExecuteScript("EQ_nsagilitytra", oPC) );
	}	
	
	if (GetHasFeat(FEAT_RANGED_WEAPON_MASTERY, oPC, TRUE))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateRWM(oPC));
	}
		
	if (GetHasFeat(FEAT_UNARMED_COMBAT_MASTERY, oPC, TRUE))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateUCM(oPC));		
	}
			
	if (GetHasFeat(FEAT_CROSSBOW_SNIPER, oPC, TRUE))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_crossbowsnip",oPC));
	}
	
	if (GetLevelByClass(CLASS_ELEM_ARCHER,oPC) > 0)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_elemarchshot",oPC));
	}	
	
	if (GetHasFeat(FEAT_FOREST_MASTER_FOREST_HAMMER, oPC, TRUE))
	{
		// DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF,OBJECT_SELF, FOREST_MASTER_FOREST_HAMMER));
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_formasthamme",oPC));	
	}
	
	if(GetHasFeat(FEAT_BARDSONG_SNOWFLAKE_WARDANCE, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), IsSnowflakeStillValid(oPC));
	}
}


void cmi_levelup( object oPC = OBJECT_SELF )	
{
	
	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC ) > 0)
	{
		CSLFixFavoredWeaponFeat( oPC );
	}
	
	CSLFixCounterspellFeat( oPC );

	int nNinja = GetLevelByClass(CLASS_NINJA, oPC);
	if (nNinja > 0) //Stack Ki Power Uses
	{
		int nBonus;
		if (GetHasFeat(FEAT_ASCETIC_STALKER, oPC))
			nBonus += GetLevelByClass(CLASS_TYPE_MONK, oPC);
		if (GetHasFeat(FEAT_MARTIAL_STALKER, oPC))
		{
			nBonus += GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
			nBonus += GetLevelByClass(CLASS_THUG, oPC);
		}
		if (GetHasFeat(FEAT_EXPANDED_KI_POOL, oPC))
			nBonus += 3;		
		
		if (nBonus > 0)
		{
			int nCount = 0;
			int nStart = 3616 + nNinja + 1;
			for (nCount = nStart; nCount < (nStart + nBonus); nCount++)
			{
				if (nCount <= 3646)
				{
					FeatAdd(oPC, nCount, FALSE, FALSE, FALSE);
				}
				else
				{
					FeatAdd(oPC, nCount + 42, FALSE, FALSE, FALSE);
					//3647
					//3689-91
				}
			}
		}	
	}



	if ( CSLGetPreferenceSwitch("FreeEmberGuard",FALSE) )	
	{
		if (GetHasFeat(FEAT_ELEMENTAL_SHAPE, oPC) && !GetHasFeat(FEAT_ELEMSHAPE_EMBERGUARD))
		{
			FeatAdd(oPC, FEAT_ELEMSHAPE_EMBERGUARD, FALSE, TRUE, TRUE);
		}
	}

	SetLocalString(oPC, "cmi_animcomp", "");

	// object oPC = OBJECT_SELF;
	SendMessageToPC(oPC,"Leveling up.");
	if ( CSLGetPreferenceSwitch("UseSacredFistFix",FALSE) )
	{
		if (GetHasFeat(2103, oPC))
		{
			FeatRemove(oPC, 2103);
			FeatAdd(oPC, FEAT_SACREDFIST_CODE_OF_CONDUCT, FALSE);
		}
	}
	
	if (GetHasFeat(FEAT_FOREST_MASTER_FOREST_HAMMER, oPC, TRUE))
	{
		SendMessageToPC(oPC, "Forest Hammer disabled, recast to gain the benefits of your new level.");
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,oPC, FOREST_MASTER_FOREST_HAMMER);	
	}
	
	
	//Frost Mage	
	if (GetLevelByClass(CLASS_FROST_MAGE,oPC) > 0)
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,oPC, SPELLABILITY_ARMOR_FROST);		
	}
	
	//Barbarian

	if (GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 13)
	{	
		if (!GetHasFeat(FEAT_INDOMITABLE_WILL, oPC))
		{
			FeatAdd(oPC, FEAT_INDOMITABLE_WILL, FALSE, TRUE, TRUE);
		}
	}
	
	//Duelist
	if (GetLevelByClass(CLASS_TYPE_DUELIST,oPC) > 6)
	{	
		//Remove Elaborate Parry so it can be reapplied
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -1742 );					
	}	
	
	if (GetHitDice(oPC) == 2)
	{
		//Character may have been reset, need to clear out any feats granted by this script
		int iFeat;
		for (iFeat = 2993; iFeat< 3052; iFeat++)
		{
			if (GetHasFeat(iFeat,oPC,TRUE))
			{
				FeatRemove(oPC, iFeat);
			}
		}
		DeleteLocalInt(oPC,"Bladesong");
		DeleteLocalInt(oPC,"XbowSniper");
		DeleteLocalInt(oPC,"cmi_HOSP_Spellcaster");
	}
	
	if (GetHasFeat(FEAT_DAYLIGHT_ENDURANCE, oPC))
	{
		if (!GetHasFeat(2207)) 
			FeatAdd(oPC, 2207, FALSE, FALSE, FALSE);
	}
	
	int nStackSneakNeeded=0;
	int nStackDeathNeeded=0;
	int nStackWildshapeNeeded=0;
	int nStackBardsongUsesNeeded=0;
	int nStackEldBlastNeeded=0;
	int nStackBardMusicNeeded=0;	
	int nStackSwashbucklerGrace=0;
	int nStackSwashbucklerDodge=0;	

	// Bard
	if ((GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0) && GetHasFeat(FEAT_ARTIST,oPC))
	{
		nStackBardsongUsesNeeded=1;		
	}
	
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0)

	{

		InfuseDivineSpirit(oPC);

	}

	if (GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) > 0)

	{

		StackSpiritShaman(oPC);

	}
	
	if (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) > 0)

	{

		nStackSneakNeeded=1;

		nStackSwashbucklerGrace=1;

		nStackSwashbucklerDodge=1;				

	}	
	
	
	if (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0)

	{

		//Child of Night

		if (GetLevelByClass(CLASS_CHILD_NIGHT,oPC) > 0)

		{

			if (GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_WARLOCK, oPC))

				nStackEldBlastNeeded=1;		

		}	
		// Hellfire Warlock
		if (GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK,oPC) > 0)
		{
			nStackEldBlastNeeded=1;
		}	
		
		if (GetHasFeat(FEAT_FEY_POWER, oPC) || GetHasFeat(FEAT_FIENDISH_POWER, oPC))
		{
			nStackEldBlastNeeded=1;
		}
		// Eldritch Disciple

		if (GetLevelByClass(CLASS_ELDRITCH_DISCIPLE,oPC) > 0)
		{
			nStackEldBlastNeeded=1;
		}
		
		//Knight of Tierdrial

		if (GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oPC) > 0)
		{
			if (GetHasFeat(FEAT_KOT_SPELLCASTING_WARLOCK, oPC))
			{
				nStackEldBlastNeeded=1;		
			}
		}
		
		// Heartwarder
		if (GetLevelByClass(CLASS_HEARTWARDER,oPC) > 0)
		{
			if (GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_WARLOCK, oPC))
			{
				nStackEldBlastNeeded=1;
			}
		}
		
		// Dragon Slayer

		if (GetLevelByClass(CLASS_DRAGONSLAYER,oPC) > 0)

		{

			if (GetHasFeat(FEAT_DRSLR_SPELLCASTING_WARLOCK, oPC))
			{
				nStackEldBlastNeeded=1;
			}

		}

		

		// Daggerspell Mage

		if (GetLevelByClass(CLASS_DAGGERSPELL_MAGE,oPC) > 0)
		{

			if (GetHasFeat(FEAT_DMAGE_SPELLCASTING_WARLOCK, oPC))
			{
				nStackEldBlastNeeded=1;
			}
		}
		
		
	}
	// Dark Lantern
	if (GetLevelByClass(CLASS_DARK_LANTERN,oPC) > 1)
	{
		nStackSneakNeeded=1;
	}
	
	// Charnag Maelthra

	if (GetLevelByClass(CLASS_CHARNAG_MAELTHRA,oPC) > 0)
	{
		if (GetHasFeat(FEAT_CHARNAG_WAY_SHADOW, oPC))
		{
			nStackSneakNeeded=1;
		}
	}
	
	// Skullclan Hunter
	if (GetLevelByClass(CLASS_SKULLCLAN_HUNTER,oPC) > 2)
	{
		nStackSneakNeeded=1;
	}
			
	//Stormsinger	
	if (GetLevelByClass(CLASS_STORMSINGER,oPC) > 0)
	{
		nStackBardsongUsesNeeded = 1;		
	}	
	
	//Canaith Lyrist	
	if (GetLevelByClass(CLASS_CANAITH_LYRIST,oPC) > 0)
	{
		nStackBardsongUsesNeeded = 1;
		nStackBardMusicNeeded = 1;		
	}	

	if (GetLevelByClass(CLASS_DISSONANT_CHORD,oPC) > 0)
	{
		nStackBardsongUsesNeeded = 1;	
	}
	
	if (GetLevelByClass(CLASS_LYRIC_THAUMATURGE,oPC) > 0)
	{
		nStackBardsongUsesNeeded = 1;	
	}
	
	//Lion of Talisid	
	if (GetLevelByClass(CLASS_LION_TALISID,oPC) > 2)
	{
		nStackWildshapeNeeded = 1;		
	}
	
	// Nature's Warrior	
	if (GetLevelByClass(CLASS_NATURES_WARRIOR,oPC) > 0)
	{
		nStackWildshapeNeeded = 1;		
	}
	
	// CLASS_DAGGERSPELL_SHAPER

	if (GetLevelByClass(CLASS_DAGGERSPELL_SHAPER,oPC) > 0)
	{
		nStackWildshapeNeeded=1;
	}
	
	if (GetHasFeat(FEAT_REAL_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nStackWildshapeNeeded=1;	
	}
	if (GetHasFeat(FEAT_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nStackWildshapeNeeded=1;	
	}
			
	// Stack Wildshape if needed
	if ( nStackWildshapeNeeded == 1 )
	{
		StackWildshapeUses(oPC);
	}
		
	if (nStackEldBlastNeeded == 1)
	{
		StackEldBlast(oPC);
	}
				
	
	// Dread Commando
	if (GetLevelByClass(CLASS_DREAD_COMMANDO,oPC) > 0)
	{
		nStackSneakNeeded=1;
	}
		
	// Nightsong Enforcer
	if (GetLevelByClass(CLASS_NIGHTSONG_ENFORCER,oPC) > 0)
	{
		nStackSneakNeeded=1;
	}
	
	// Nightsong Infiltrator
	if (GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR,oPC) > 3)
	{
		nStackSneakNeeded=1;
	}
	
	// Rogue
	if (GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
	{
		nStackSneakNeeded=1;
		nStackSwashbucklerDodge = 1;
	}
	
	// CLASS_NINJA

	if (GetLevelByClass(CLASS_NINJA,oPC) > 0)
	{
		nStackSneakNeeded=1;
		nStackSwashbucklerDodge = 1;	
	}

	// CLASS_GHOST_FACED_KILLER

	if (GetLevelByClass(CLASS_GHOST_FACED_KILLER,oPC) > 1)
	{
		nStackSneakNeeded=1;
	}

	// CLASS_DAGGERSPELL_MAGE

	if (GetLevelByClass(CLASS_DAGGERSPELL_MAGE,oPC) > 2)
	{
		nStackSneakNeeded=1;
	}

	// CLASS_DAGGERSPELL_SHAPER

	if (GetLevelByClass(CLASS_DAGGERSPELL_SHAPER,oPC) > 2)
	{
		nStackSneakNeeded=1;
	}

	// CLASS_SCOUT
	if (GetLevelByClass(CLASS_SCOUT,oPC) > 0)
	{
		nStackSneakNeeded=1;
		nStackSwashbucklerDodge=1;
	}
	// CLASS_WILD_STALKER
	if (GetLevelByClass(CLASS_WILD_STALKER,oPC) > 1)
	{
		nStackSneakNeeded=1;
		nStackSwashbucklerDodge = 1;		
	}				
	
	// Stack Sneak Attack Dice if needed
	if (nStackSneakNeeded == 1)
	{
		SCStackSneakAttack(oPC);
	}
		
	// Blackguard
	if (GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC) > 0)
	{
		AddBGFeats(oPC);
		if (!(GetLocalInt(oPC, "BlackGuardCleaned") == 1))
		CleanBlackGuard(oPC);
	}		
	
	// Assassin
	if (GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC) > 0)
	{
		SCAddASNFeats(oPC);
		nStackDeathNeeded=1;
	}
	
	// Avenger
	if (GetLevelByClass(CLASS_TYPE_AVENGER,oPC) > 0)
	{
		SCAddASNFeats(oPC);
		nStackDeathNeeded=1;
		if (!(GetLocalInt(oPC, "AssassinCleaned") == 1))
		CleanAssassin(oPC);			
	}	
	
	// Black Flame Zealot
	if (GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT,oPC) > 2)
	{
		nStackDeathNeeded=1;		
	}
	
	// Stack Death Attack Dice if needed
	if (nStackDeathNeeded == 1)
	{
		StackDeathAttack(oPC);
	}
		
	// Stack Death Attack Dice if needed
	if (nStackDeathNeeded == 1)
	{
		StackDeathAttack(oPC);	
	}
		
	if (nStackBardsongUsesNeeded)	
	{
		StackBardicUses(oPC);
	}
		
	if (nStackBardMusicNeeded)	
	{
		StackBardMusicUses(oPC);	
	}
	
	if (nStackSwashbucklerGrace)
	{
		StackSwashbucklerGrace(oPC);
	}
		

	if (nStackSwashbucklerDodge)		
	{
		StackSwashbucklerDodge(oPC);
	}
	
	// Hospitaler
	//SendMessageToPC(oPC,"Outside Loop");
	//FloatingTextStringOnCreature("No caster feat.", oPC);
	if (GetLevelByClass(CLASS_HOSPITALER,oPC) > 0)
	{
		//SendMessageToPC(GetFirstPC(),"Inside Loop");
		if (!GetLocalInt(oPC,"cmi_HOSP_Spellcaster"))
		{	
			//SendMessageToPC(GetFirstPC(),"No localvar yet");
			
			int iHasCasterFeat = 0;
			if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_SPIRIT_SHAMAN,oPC))
			{
				iHasCasterFeat = 1;
			}
			else if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_CLERIC,oPC))
			{
				iHasCasterFeat = 1;
			}
			else if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_DRUID,oPC))
			{
				iHasCasterFeat = 1;
			}
			else if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_PALADIN,oPC))
			{
				iHasCasterFeat = 1;
			}
			else if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_RANGER,oPC))
			{
				iHasCasterFeat = 1;
			}
			else if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_FAVORED_SOUL,oPC))
			{
				iHasCasterFeat = 1;
			}
			
			int nValidClasses = 0;																			
			if (iHasCasterFeat == 0)
			{
				// lets deduce which class qualify for the progression, if just one, we can just give it to the player
				// lets see how many classes can get this feat, if one we'll jsut add it without a dialog
				int nFeatToAdd;
				
				string sClassText;
				if ( GetLevelByClass( CLASS_TYPE_CLERIC, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_CLERIC;
					sClassText = "Cleric spellcasting progression granted.";
				}
				
				if ( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_DRUID;
					sClassText = "Druid spellcasting progression granted.";	
				}
				
				if ( GetLevelByClass( CLASS_TYPE_FAVORED_SOUL, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_FAVORED_SOUL;
					sClassText = "Favored Soul spellcasting progression granted.";
				}
				
				if ( GetLevelByClass( CLASS_TYPE_PALADIN, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_PALADIN;
					sClassText = "Paladin spellcasting progression granted.";
				}
				
				if ( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_RANGER;
					sClassText = "Ranger spellcasting progression granted.";
				}
				
				if ( GetLevelByClass( CLASS_TYPE_SPIRIT_SHAMAN, oPC ) > 0 )
				{
					nValidClasses++;
					nFeatToAdd = FEAT_HOSPITALER_SPELLCASTING_SPIRIT_SHAMAN;
					sClassText = "Spirit Shaman spellcasting progression granted.";	
				}
				
				if ( nValidClasses == 1 )
				{
					// just add it
					FeatAdd(oPC,nFeatToAdd,FALSE);
					SendMessageToPC(oPC, sClassText);
				}
				else if ( nValidClasses > 1 )
				{
					// dialog to pick it now...
					SendMessageToPC(oPC, "No caster feat, launching a dialog for you to choose.");
					BeginConversation("c_hosp_levelup", oPC );
					SetLocalInt(oPC,"cmi_HOSP_Spellcaster",1);
				}																		
			}		
		}
	} // End Hospitaler	

}


void SCStopAssRest(object oMaster, int nAssType)
{
    object oAss=GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster);
    if(oAss!=OBJECT_INVALID) AssignCommand(oAss, ClearAllActions());
}

void SCStopResting(object oPC, string sMsg) {
    AssignCommand (oPC, ClearAllActions()); // Prevent Resting of master-char
    SendMessageToPC(oPC, sMsg);
    // stop resting of associates
    SCStopAssRest(oPC, ASSOCIATE_TYPE_ANIMALCOMPANION);
    SCStopAssRest(oPC, ASSOCIATE_TYPE_DOMINATED);
    SCStopAssRest(oPC, ASSOCIATE_TYPE_FAMILIAR);
    SCStopAssRest(oPC, ASSOCIATE_TYPE_HENCHMAN);
    SCStopAssRest(oPC, ASSOCIATE_TYPE_SUMMONED);
    SetLocalInt(oPC, "STOPREST", TRUE);
}


void cmi_player_unequip( object oPC )	
{
	//object oPC = OBJECT_SELF;
	object oItem = GetPCItemLastUnequipped();

	CSLRemoveTemporaryItemProperties(oItem);
	
	int nTableValue = 0;
	int nActualTableValue;
	itemproperty iProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ABILITY_BONUS)
		{	
			if (GetItemPropertySubType(iProp) == ABILITY_CONSTITUTION)
			{			
				//SendMessageToPC(oPC, "Test");
				nActualTableValue = GetItemPropertyCostTableValue(iProp);
				if (nActualTableValue > nTableValue) //Handles multiple con bonuses on one item
				{
					nTableValue	= nActualTableValue;
				}
				SetLocalInt(OBJECT_SELF, "ConBonusCount", (	GetLocalInt(OBJECT_SELF, "ConBonusCount") - 1));
				//effect eDmg = EffectDamage(1, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, TRUE);
				//ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oPC);					
			}																
		}
		iProp = GetNextItemProperty(oItem);	
	}
	if (nTableValue > 0)
	{	
		DelayCommand(0.3f, cmi_HealIfNeeded(oPC, nTableValue));
	}
	
	if(GetHasFeat(FEAT_CROSSBOW_SNIPER, oPC))
	{	
		DelayCommand(0.1f, ExecuteScript("cmi_s2_xbowsniper",oPC));
	}	
	
	if(GetHasFeat(FEAT_BARDSONG_SNOWFLAKE_WARDANCE, oPC))
	{	
		DelayCommand(0.1f, IsSnowflakeStillValid(oPC));
	}
	
	
	int iTemp;	
	
	
	
	
	if (GetLevelByClass(CLASS_NINJA) > 0)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_ninjacbonus",oPC));
	}
	
	if (GetLevelByClass(CLASS_FIST_FOREST) > 1)
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_fotfacbonus",oPC));
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("FT_fotfunarmed",oPC));
	}
	
	
	if (GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION, oPC))
	{
		if (GetHasFeat(FEAT_GREATER_HEAVY_ARMOR_OPTIMIZATION, oPC))
		{
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_heavyarmorgr",oPC));
		}
		else
		{
			DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_heavyarmor",oPC));
		}
	}
	
	if (GetHasSpellEffect(SPELL_Blessed_Aim, oPC))
	{
		  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		  if (!GetIsObjectValid(oWeapon) || !GetWeaponRanged(oWeapon))
		  {	
			   // RemoveEffectsFromSpell(oPC, SPELL_Blessed_Aim);
			   CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELL_Blessed_Aim );				
		  } 		
	}
		
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_B, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_b",oPC));		
	}	
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_P, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_p",oPC));
	}	
	if(GetHasFeat(FEAT_MELEE_WEAPON_MASTERY_S, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_mwpnmast_s",oPC));
	}		

	
	if ( CSLGetPreferenceSwitch("UseDmgResFix",FALSE) )
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ApplyDmgResFix(oPC, TRUE));
	}
		

	if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
	{	
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_intuitiveatt",oPC));
	}
	
	if (GetLevelByClass(CLASS_DREAD_COMMANDO) > 1)
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_armoredease",oPC));	
	}
	
	
	
	if(GetHasFeat(FEAT_SACREDFIST_CODE_OF_CONDUCT, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_sacredfistco",oPC));
	}	
		
	if (GetLevelByClass(CLASS_CHAMPION_WILD, oPC) > 1)
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_cwelegstrike",oPC));		
	}
	
	if (GetHasFeat(FEAT_ARMOR_SPECIALIZATION_MEDIUM, oPC) || GetHasFeat(FEAT_ARMOR_SPECIALIZATION_HEAVY, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateArmorSpec(oPC));
	}
	
	if(GetHasFeat(FEAT_GTR_2WPN_DEFENSE, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), ExecuteScript("EQ_grt2weapdef",oPC));
	}
	
	if (GetHasFeat(FEAT_OVERSIZE_TWO_WEAPON_FIGHTING, oPC))
	{
		DelayCommand(CSLRandomBetweenFloat(0.2f,2.0f), EvaluateOver2WpnFight());
	}
	
	//if (GetHasFeat(FEAT_BATTLE_DANCER, oPC))
	//{
	//	DelayCommand(0.1f, EvaluateBattleDancer());
	//}
	
	//Bladesinger
	int Bladesinger = GetLevelByClass(CLASS_BLADESINGER,oPC);
	if (Bladesinger > 0)
	{	
		DelayCommand(0.1f, ExecuteScript("EQ_bsbladesong",oPC));
		
		if ( GetHasFeat(FEAT_BATTLE_CASTER_BLADESINGER) )
		{
			DelayCommand(0.1f,ExecuteScript("EQ_bsbattlecast",oPC));						
		}
		else if ( GetHasFeat(FEAT_ARMORED_CASTER_BLADESINGER) )
		{
			DelayCommand(0.1f,ExecuteScript("EQ_armorcaster",oPC));	
		}	
		//if ( GetHasFeat(FEAT_BLADESINGER_SONG_FURY) )
		//{
		//	DelayCommand(0.1f,ExecuteScript("EQ_bssongfury",oPC));
		//}				
	}			
	
	// Tempest
	if (GetLevelByClass(CLASS_TEMPEST,oPC) > 0)
	{
		DelayCommand(0.1f,ExecuteScript("EQ_tempestdefen",oPC));
	}		


	// Nightsong Enforcer
	if (GetLevelByClass(CLASS_NIGHTSONG_ENFORCER,oPC) > 0)
	{	
		DelayCommand(0.1f,ExecuteScript("EQ_nsagilitytra",oPC));		
	}

	
	if (GetHasFeat(FEAT_RANGED_WEAPON_MASTERY, oPC, TRUE))
	{
		DelayCommand(0.1f, EvaluateRWM(oPC));
	}
		
	if (GetHasFeat(FEAT_UNARMED_COMBAT_MASTERY, oPC, TRUE))
	{
		DelayCommand(0.1f, EvaluateUCM(oPC));	
	}
		
	if (GetLevelByClass(CLASS_ELEM_ARCHER,oPC) > 0)
	{	
		DelayCommand(0.1f, ExecuteScript("EQ_elemarchshot",oPC));
	}

	if (GetHasFeat(FEAT_FOREST_MASTER_FOREST_HAMMER, oPC, TRUE))
	{
		DelayCommand(0.1f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oPC, oPC, FOREST_MASTER_FOREST_HAMMER ) );	
	}	
	// */
}



void SCItemSoldCheck(object oItem, object oPC)
{
	if (GetIsObjectValid(oItem))
	{
		AssignCommand(oPC, ClearAllActions());
		CopyItem(oItem, oPC, TRUE);
		DestroyObject(oItem);
	}
}


void CSLBulletCastingCheck( object oItem, object oPC = OBJECT_SELF )
{
	if (GetCurrentAction(oPC)==ACTION_CASTSPELL)
	{
		if (GetIsInCombat(oPC))
		{
			string sMsg = GetStringLowerCase(GetName(oItem));
			int iSpellId = GetLocalInt(oPC, "LASTSPELL");
			string sName = CSLGetSpellDataName(iSpellId) + "(" + IntToString(iSpellId) + ")";
			sMsg = GetName(oPC) + " swaps " + GetName(oItem) + " while casting " + sName;
			SendMessageToAllDMs(sMsg);
			SCCauseFailure( oPC );
			object oTarget = GetAttemptedSpellTarget();
			if (GetIsPC(oTarget) && oTarget!=oPC && GetIsReactionTypeHostile(oTarget, oPC))
			{
				SendMessageToPC(oTarget, "You see " + GetName(oPC) + " put on " + CSLSexString(oPC, "his ", "her ") + GetName(oItem));
			}
			if (oTarget!=OBJECT_INVALID)
			{
				sMsg += " on " + GetName(oTarget);
			}
			//SDB_LogMsg("BULLET", sMsg, oPC);
      	}
   }
}

void CSLSacredFlamesWeaponCheck( object oItem, object oPC = OBJECT_SELF )
{
	// begin sacred fist exception, designed to ensure flames are not active when armed 
   if (CSLItemGetIsAWeapon(oItem))
   { 
      if (GetHasSpellEffect(SPELLABILITY_SACRED_FLAMES, oPC))
      {

         effect eEffect;
	     eEffect = GetFirstEffect(oPC); 
         while (GetIsEffectValid(eEffect))
         {
            if (GetEffectSpellId(eEffect) == SPELLABILITY_SACRED_FLAMES)
            { 
               RemoveEffect(oPC, eEffect);    
               SendMessageToPC(oPC, "As what you carry, breaks your oath, so too do your sacred flame fizzle"); 
            }
            eEffect = GetNextEffect(oPC);
         }	 
      } 
 
   }

}

void CSLDollEquipItem( object oItem, object oPC = OBJECT_SELF )
{
	
   object oDoll = GetLocalObject(oPC, "DOLL");
   if (oDoll!=OBJECT_INVALID)
   {
      SendMessageToPC(oPC, GetName(oDoll) + " puts on " + GetName(oItem));
      int nSlot = -1;      
      switch (GetBaseItemType(oItem)) {
         case BASE_ITEM_BRACER     : nSlot = INVENTORY_SLOT_ARMS;      break;
         case BASE_ITEM_AMULET     : nSlot = INVENTORY_SLOT_NECK;      break;
         case BASE_ITEM_RING       : nSlot = INVENTORY_SLOT_RIGHTRING; break;
         case BASE_ITEM_BELT       : nSlot = INVENTORY_SLOT_BELT;      break;
         case BASE_ITEM_BOOTS      : nSlot = INVENTORY_SLOT_BOOTS;     break;
         case BASE_ITEM_CLOAK      : nSlot = INVENTORY_SLOT_CLOAK;     break;
         case BASE_ITEM_HELMET     : nSlot = INVENTORY_SLOT_HEAD;      break;
         case BASE_ITEM_ARMOR      : nSlot = INVENTORY_SLOT_CHEST;     break; 
         case BASE_ITEM_SMALLSHIELD: nSlot = INVENTORY_SLOT_CHEST;     break; 
         case BASE_ITEM_LARGESHIELD: nSlot = INVENTORY_SLOT_CHEST;     break; 
         case BASE_ITEM_TOWERSHIELD: nSlot = INVENTORY_SLOT_CHEST;     break; 
      }
      if (nSlot==-1)
      {
         if (StringToInt(Get2DAString("baseitems", "WeaponType", ItemProps.ItemBase))) nSlot = INVENTORY_SLOT_RIGHTHAND;
      
      }
      if (nSlot!=-1) {
         object oCopy = CopyObject(oItem, GetLocation(oDoll), oDoll);
         SetPickpocketableFlag(oCopy, FALSE);
         DestroyObject(GetItemInSlot(nSlot, oDoll));
         AssignCommand(oDoll, ActionEquipItem(oCopy, nSlot));
      }
   }   
}

/*
// X2_ITEM_EVENT_ACTIVATE
// X2_ITEM_EVENT_EQUIP
// X2_ITEM_EVENT_UNEQUIP
// X2_ITEM_EVENT_ONHITCAST
// X2_ITEM_EVENT_ACQUIRE
// X2_ITEM_EVENT_UNACQUIRE
// X2_ITEM_EVENT_SPELLCAST_AT
SCActivateItemBasedScript( nEvent );

SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ACTIVATE );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_EQUIP );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_UNEQUIP );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ONHITCAST );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ACQUIRE );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_UNACQUIRE );
SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_SPELLCAST_AT );
*/
void SCActivateItemBasedScript( object oItem, int nEvent )
{
	if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
	{
        if (GetIsObjectValid(oItem))
        {
			SetUserDefinedItemEventNumber( nEvent );
			int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
			if (nRet == X2_EXECUTE_SCRIPT_END)
			{
			   return;
			}
        }

     }
}



void SCSetAssociateEventHandlers(object oAssociate)
{
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_HEARTBEAT,        SCRIPT_ASSOC_HEART);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_NOTICE,           SCRIPT_ASSOC_PERCEP);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_SPELLCASTAT,      SCRIPT_ASSOC_SPELL);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_MELEE_ATTACKED,   SCRIPT_ASSOC_ATTACK);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DAMAGED,          SCRIPT_ASSOC_DAMAGE);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DISTURBED,        SCRIPT_ASSOC_DISTRB);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_END_COMBATROUND,  SCRIPT_ASSOC_COMBAT);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DIALOGUE,         SCRIPT_ASSOC_CONV);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_SPAWN_IN,         SCRIPT_ASSOC_SPAWN);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_RESTED,           SCRIPT_ASSOC_REST);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DEATH,            SCRIPT_ASSOC_DEATH);
	SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,SCRIPT_ASSOC_USRDEF);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,  SCRIPT_ASSOC_BLOCK);
}


// this will only replace event handlers determined to be safe to replace.
void SCConvertToAssociateEventHandler(int iEventHandler, string sNewEventScript)
{
    object oAssociate = OBJECT_SELF;
    
    // Only replace script event if it is one of the default ones we are confident is safe to replace.
    // Done with caution because one of these script could be called via ExecuteScript() and not 
    // actually be the event handler.
    string sVarName = "NotAReplaceableEventScript" + IntToString(iEventHandler);
    if (GetLocalInt(oAssociate, sVarName) == FALSE)
    {
        string sCurrentEventScript = GetEventHandler(oAssociate, iEventHandler);
        string sPrefix = GetStringLeft(sCurrentEventScript, 7); //
        int iLength = GetStringLength(sCurrentEventScript);
        if ((sPrefix == "nw_ch_a" && iLength == 9)
            || (sPrefix == "x0_ch_h") 
            || (sPrefix == "x0_hen_")
            || (sPrefix == "x2_hen_")
            )
            SetEventHandler(oAssociate, iEventHandler, sNewEventScript);
        else
            SetLocalInt(oAssociate, sVarName, TRUE);
    }            
    // in any case, execute the replacement script        
    ExecuteScript(sNewEventScript, OBJECT_SELF);
}


int SCGetEventsClearedFlag(object oObject)
{
	int bEventsCleared = GetLocalInt(oObject, EVENTS_CLEARED_FLAG);
	return (bEventsCleared);	
}

void SCSetEventsClearedFlag(object oObject, int bFlag)
{
	SetLocalInt(oObject, EVENTS_CLEARED_FLAG, bFlag);
}
/*
int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER		= 256;
int    OBJECT_TYPE_LIGHT            = 512;
int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
*/

			
int SCGetNumScripts(object oObject)
{
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules
	int iNumScripts = 0;
	
	// see nwscript.nss for list of script event handlers
	switch (iObjectType)
	{
		case OBJECT_TYPE_CREATURE:
			iNumScripts = 13;
			break;	
		case OBJECT_TYPE_ITEM: // items don't have scripts 
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_TRIGGER:
			iNumScripts = 7;	
			break;	
		case OBJECT_TYPE_DOOR:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_AREA_OF_EFFECT:
			iNumScripts = 4;	
			break;	
		case OBJECT_TYPE_WAYPOINT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACEABLE:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_STORE:
			iNumScripts = 2;	
			break;	
		case OBJECT_TYPE_ENCOUNTER:
			iNumScripts = 5;	
			break;	
		case OBJECT_TYPE_LIGHT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACED_EFFECT:
			iNumScripts = 0;	
			break;	
	}
	return (iNumScripts);	
}

void SCSaveEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = SCGetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		SetLocalString(oObject, sVarName, sEventHandler);
	}
}


// set all event handlers to the same script.
// this would typically only be "" or SCRIPT_OBJECT_NOTHING
void SCSetAllEventHandlers(object oObject, string sScriptName)
{
	int iNumScripts = SCGetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		SetEventHandler(oObject, i, sScriptName);
	}
}

void SCClearEventHandlers(object oObject)
{
	string sScriptName = "";
	SCSetAllEventHandlers(oObject, sScriptName);
	SCSetEventsClearedFlag(oObject, TRUE);
}

void SCRestoreEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = SCGetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		sEventHandler = GetLocalString(oObject, sVarName);
		SetEventHandler(oObject, i, sEventHandler);
	}
	SCSetEventsClearedFlag(oObject, FALSE);
}

void SCDeleteSavedEventHandlers(object oObject)
{
	string sVarName;
	int iNumScripts = SCGetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = "EH_SAVE" + IntToString(i);
		DeleteLocalString(oObject, sVarName);
	}
}

// save and clear event handlers if they haven't already been flagged as cleared.
void SCSafeClearEventHandlers(object oObject)
{
	if (SCGetEventsClearedFlag(oObject) == FALSE)		
	{
		SCSaveEventHandlers(oObject);
		SCClearEventHandlers(oObject);
	}		
}

//	restore event handlers if they were previously flagged as cleared.
void SCSafeRestoreEventHandlers(object oObject)
{
	if (SCGetEventsClearedFlag(oObject) == TRUE)		
	{
		SCRestoreEventHandlers(oObject);
		SCDeleteSavedEventHandlers(oObject);
	}			
}
	
void SCReportEventHandlers(object oObject)	
{	
	string sEventHandler;
	string sVarName;
	int iNumScripts = SCGetNumScripts(oObject);
	int i;
	
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules

	//PrettyDebug (" object type of " + GetName(oObject)+ " is " + IntToString(iObjectType));
	//PrettyDebug (" iNumScripts =  " + IntToString(iNumScripts));

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		//PrettyDebug(" Script " + IntToString(i) + " = " + sEventHandler);
	}
}