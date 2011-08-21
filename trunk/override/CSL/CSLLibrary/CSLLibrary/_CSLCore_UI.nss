/** @file
* @brief User Interface functions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/*
These are the basic Utitlities
*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////

/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

// AI related constants
//const string GUI_SCREEN_PLAYERMENU				= "SCREEN_PLAYERMENU";
//const string GUI_PLAYERMENU_AI_OFF_BUTTON		= "AI_OFF_BUTTON";
//const string GUI_PLAYERMENU_AI_ON_BUTTON		= "AI_ON_BUTTON";
//const string GUI_PLAYERMENU_AI_MIXED_BUTTON		= "AI_MIXED_BUTTON";

const string GUI_PLAYERMENU_CLOCK_BUTTON 	= "CLOCK_BUTTON";
const string SCREEN_OL_FRAME 				= "SCREEN_OL_MENU";
const string OL_DETAIL_CLOCK				= "OL_CLOCK";

//const string SCREEN_CHARACTER 					= "SCREEN_CHARACTER";
//const string SCREEN_CREATUREEXAMINE				= "SCREEN_CREATUREEXAMINE";
//const string BEHAVIORDESC_TEXT 					= "BEHAVIORDESC_TEXT";


//const string BEHAVIOR_FOLLOWDIST_NEAR 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR";
//const string BEHAVIOR_FOLLOWDIST_MED 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED";
//const string BEHAVIOR_FOLLOWDIST_FAR 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR";

//const string BEHAVIOR_DEF_MASTER_ON 			= "BEHAVIOR_DEF_MASTER_STATE_BUTTON_ON";
//const string BEHAVIOR_DEF_MASTER_OFF 			= "BEHAVIOR_DEF_MASTER_STATE_BUTTON_OFF";

//const string BEHAVIOR_RETRY_LOCKS_ON			= "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_ON";
//const string BEHAVIOR_RETRY_LOCKS_OFF			= "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_OFF";

//const string BEHAVIOR_STEALTH_MODE_NONE			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_NONE"; // 0
//const string BEHAVIOR_STEALTH_MODE_PERM			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_PERM"; // 1
//const string BEHAVIOR_STEALTH_MODE_TEMP			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_TEMP"; // 2

//const string BEHAVIOR_DISARM_TRAPS_ON			= "BEHAVIOR_DISARM_STATE_BUTTON_ON";
//const string BEHAVIOR_DISARM_TRAPS_OFF			= "BEHAVIOR_DISARM_STATE_BUTTON_OFF";

//const string BEHAVIOR_DISPEL_ON					= "BEHAVIOR_DISPEL_STATE_BUTTON_ON";
//const string BEHAVIOR_DISPEL_OFF				= "BEHAVIOR_DISPEL_STATE_BUTTON_OFF";

//const string BEHAVIOR_CASTING_ON				= "BEHAVIOR_CASTING_STATE_BUTTON_ON";
//const string BEHAVIOR_CASTING_OFF				= "BEHAVIOR_CASTING_STATE_BUTTON_OFF";
//const string BEHAVIOR_CASTING_OVERKILL			= "BEHAVIOR_CASTING_STATE_BUTTON_OVERKILL";
//const string BEHAVIOR_CASTING_POWER				= "BEHAVIOR_CASTING_STATE_BUTTON_POWER";
//const string BEHAVIOR_CASTING_SCALED			= "BEHAVIOR_CASTING_STATE_BUTTON_SCALED";

//const string BEHAVIOR_ITEM_USE_ON				= "BEHAVIOR_ITEM_USE_STATE_BUTTON_ON";
//const string BEHAVIOR_ITEM_USE_OFF				= "BEHAVIOR_ITEM_USE_STATE_BUTTON_OFF";
//const string BEHAVIOR_FEAT_USE_ON				= "BEHAVIOR_FEAT_USE_STATE_BUTTON_ON";
//const string BEHAVIOR_FEAT_USE_OFF				= "BEHAVIOR_FEAT_USE_STATE_BUTTON_OFF";

//const string BEHAVIOR_PUPPET_ON					= "BEHAVIOR_PUPPET_STATE_BUTTON_ON";
//const string BEHAVIOR_PUPPET_OFF				= "BEHAVIOR_PUPPET_STATE_BUTTON_OFF";

//const string BEHAVIOR_COMBAT_MODE_USE_ON		= "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_ON";
//const string BEHAVIOR_COMBAT_MODE_USE_OFF		= "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_OFF";


const string SCREEN_CONTEXTMENU = "contextmenu.xml";


const int CSL_LISTBOXROW_ADD = 1;
const int CSL_LISTBOXROW_MODIFY = 2;
const int CSL_LISTBOXROW_REMOVE = 3;

const string SCREEN_DMAPPEAR = "SCREEN_CSLDMAPPEAR";
const string XML_DMAPPEAR = "csldmappear.xml";

const string SCREEN_WEATHER = "SCREEN_WEATHER";
const string XML_WEATHER = "cslweather.xml";

const string SCREEN_MACRO = "SCREEN_MACRO";
const string XML_MACRO = "cslmacro.xml";

const string SCREEN_CLOCK = "SCREEN_CLOCK";
const string XML_CLOCK = "cslclock.xml";

const string SCREEN_BOOK = "SCREEN_BOOK";
const string XML_BOOK = "cslbook.xml";

const string SCREEN_EFFECTS = "SCREEN_EFFECTS";
const string XML_EFFECTS = "csleffects.xml";

const string SCREEN_CHARACTEREDIT = "SCREEN_CSLCHAREDIT";
const string XML_CHARACTEREDIT = "cslcharedit.xml";

const string SCREEN_ARTILLERY = "SCREEN_ARTILLERY";
const string XML_ARTILLERY = "cslartillery.xml";

const string SCREEN_CHARACTERDATA = "SCREEN_CHAR_DATA";
const string XML_CHARACTERDATA = "_SCgui_data.xml";

const string SCREEN_LEVELUPLANGUAGES = "SCREEN_CSL_LEVELUP_LANGUAGES";
const string XML_LEVELUPLANGUAGES = "csl_levelup_languages.xml";

const string SCREEN_CHATSELECT = "SCREEN_CHATSELECT";
//const string XML_CHATSELECT = "_SCgui_data.xml";

const string SCREEN_DM_CSLTABLELIST = "CSLtablelist";

const int CSL_PAGE_FIRST = -1; // always the first page
const int CSL_PAGE_CURRENT = -2; // Uses the current viewed page
const int CSL_PAGE_PREVIOUS = -3; // uses the previous page
const int CSL_PAGE_NEXT = -4; // yses the next page
const int CSL_PAGE_LAST = -5; // uses the last page



// UI CONSTANTS
const string SCREEN_DMFI_SKILLS = "SCREEN_DMFI_SKILLS";
const string SCREEN_DMFI_CHGITEM = "SCREEN_DMFI_CHGITEM";
const string SCREEN_DMFI_CHGNAME = "SCREEN_DMFI_CHGNAME";
const string SCREEN_DMFI_PLAYER = "SCREEN_DMFI_PLAYER";
//const string SCREEN_DMFI_FOLLOWOFF = "SCREEN_DMFI_FOLLOWOFF";
const string SCREEN_DMFI_LANGOFF = "SCREEN_DMFI_LANGOFF";
const string SCREEN_DMFI_LIST = "SCREEN_DMFI_LIST";
const string SCREEN_DMFI_VFXTOOL = "SCREEN_DMFI_VFXTOOL";
const string SCREEN_DMFI_AMBTOOL = "SCREEN_DMFI_AMBTOOL";
const string SCREEN_DMFI_DMLIST = "SCREEN_DMFI_DMLIST";
const string SCREEN_DMFI_COMMANDREF = "SCREEN_DMFI_COMMANDREF";
const string SCREEN_DMFI_SNDTOOL = "SCREEN_DMFI_SNDTOOL";
const string SCREEN_DMFI_MUSICTOOL = "SCREEN_DMFI_MUSICTOOL";
const string SCREEN_DMFI_DICETOOL = "SCREEN_DMFI_DICETOOL";
const string SCREEN_DMFI_ = "SCREEN_DMFI_";
const string SCREEN_DMFI_DM = "SCREEN_DMFI_DM";
const string SCREEN_DMFI_TEXT = "SCREEN_DMFI_TEXT";
const string SCREEN_DMFI_CHOOSE = "SCREEN_DMFI_CHOOSE";
const string SCREEN_DMFI_BATTLE = "SCREEN_DMFI_BATTLE";
const string SCREEN_DMFI_TRGTOOL = "SCREEN_DMFI_TRGTOOL";
const string SCREEN_DMFI_MNGRTOOL = "SCREEN_DMFI_MNGRTOOL";
const string SCREEN_DMFI_VFXINPUT = "SCREEN_DMFI_VFXINPUT";
const string SCREEN_DMFI_DESC = "SCREEN_DMFI_DESC";
const string DMFI_UI_ACTIVELANG = "ActiveLang";
const string DMFI_UI_LISTTITLE = "ListTitle";
const string DMFI_UI_SKILLTITLE = "SkillTitle";
const string DMFI_UI_LIST = "List";
const string DMFI_UI_DMLIST ="dmlist";

const string DMFI_REQ_INT = "DMFI_REQ_INT";
const string DMFI_UI_PAGE = "DMFI_UI_PAGE";
const string DMFI_UI_LIST_TITLE = "DMFILISTTITLE";
const string DMFI_LAST_UI_COM = "DMFILastUICom";
const string DMFI_AMB_NIGHT = "DMFIAmbNight";
const string DMFI_MUSIC_TIME = "DMFIMusicTime";
const string DMFI_CURRENT = "CURRENT";

const string DMFI_LIST_PRIOR = "DMFI_LIST_PRIOR";
const int DMFI_LIST_ABILITY = 1;
const int DMFI_LIST_LANG = 2;
const int DMFI_LIST_NUMBER = 3;
const int DMFI_LIST_TYPE = 4;

const string DMFI_MODE_CHAT = "PlayerModeChat";

//const string SCREEN_MESSAGEBOX_REPORT = "SCREEN_MESSAGEBOX_REPORT";
//const string SCREEN_MESSAGEBOX_DEFAULT = "SCREEN_MESSAGEBOX_DEFAULT";

/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Messages"
#include "_CSLCore_Config"


/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////




/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

void CSLDMFI_ClearUIData(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "CSLDMFI_ClearUIData Start", oPC ); }
	
	DeleteLocalInt(oPC, DMFI_REQ_INT);
	DeleteLocalString(oPC, DMFI_LAST_UI_COM);
	DeleteLocalString(oPC, DMFI_UI_PAGE);
	// if (DEBUGGING >= 8) { CSLDebug(  "CSLDMFI_ClearUIData End", oPC ); }
}	

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// * sets buttons up that are not in a listbox
void CSLSetGuiObjectButton( object oPlayer, string sScreenName, string sButtonName, string sButtonText = "", string sIcon = "-1" )
{
	if ( sButtonText == "" )
	{
		SetGUIObjectHidden( oPlayer, sScreenName, sButtonName, TRUE );
	}
	else
	{
		SetGUIObjectHidden( oPlayer, sScreenName, sButtonName, FALSE );
		SetGUIObjectText( oPlayer, sScreenName, sButtonName, -1, sButtonText  );
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLUIBroadCastRemoveListBoxRow( string sScreenName, string sListBox, string sRowName )
{
	object oCurrentPC = GetFirstPC();
	while ( GetIsObjectValid(oCurrentPC) )
	{
		RemoveListBoxRow( oCurrentPC, sScreenName, sListBox, sRowName );
		oCurrentPC = GetNextPC();
	}
}


/**  
* @author
* @param 
* @see 
* @replaces DMFI_ShowDMListUI
* @return 
*/
void CSLTableShowListUI(object oPC, int iPageNumber = CSL_PAGE_FIRST, string sSubCategory = "", string sTableName = "", string sPageTitle = "", string sScreen=SCREEN_DM_CSLTABLELIST)
{
	//Purpose: Shows the DM list - builds the 30 entries and handles page updates.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/27/6
	// Refactored completely by Pain, 12/26/09
	
	//if (DEBUGGING >= 8) { CSLDebug(  "CSLTableShowListUI Start", oPC ); }
	
	int n, nCurrent, nModal;
	
	if ( sTableName == "" )
	{
		sTableName = GetLocalString(oPC, "CSL_CSLTABLE_TABLENAME");
	}
	else
	{
		SetLocalString(oPC, "CSL_CSLTABLE_TABLENAME", sTableName);
	}
	
	object oTable = CSLDataObjectGet( sTableName );
	
	
	
	
	if ( sPageTitle == "" )
	{
		sPageTitle = GetLocalString(oPC, "CSL_CSLTABLE_PAGETITLE");
		if ( sPageTitle == "" )
		{
			sPageTitle = sTableName;
			SetLocalString(oPC, "CSL_CSLTABLE_PAGETITLE", sPageTitle);
		}
	}
	else
	{
		SetLocalString(oPC, "CSL_CSLTABLE_PAGETITLE", sPageTitle);
	}
		
	
	int iItemsPerPage = 30;
	
	string sCategory = GetStringUpperCase( GetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY" ) );
	SetLocalGUIVariable(oPC, sScreen, 900, sCategory);
	int iStartRow = -1;
	int iTotalItems = -1;
	int iTotalPages = 0;
	
	if ( sCategory == "" || sCategory == "*"  || sCategory == "#" )
	{
		iStartRow = 0;
		iTotalItems = CSLDataTableCount( oTable );
	}
	else
	{
		iStartRow = GetLocalInt(oTable, "DATATABLE_SORTSTART_"+sCategory );
		iTotalItems = GetLocalInt(oTable, "DATATABLE_SORTQUANTITY_"+sCategory );
		
		//SendMessageToPC( GetFirstPC(), "Doing category "+sCategory+" which has "+"DATATABLE_SORTQUANTITY_"+sCategory+"="+IntToString(iTotalItems)+" members and starts on "+ "DATATABLE_SORTSTART_"+sCategory+"="+IntToString(iStartRow) );
	}

	iTotalPages = (iTotalItems/iItemsPerPage)-CSLGetIsDivisible(iTotalItems, iItemsPerPage);
	//SendMessageToPC(oPC, "CSLTableShowListUI "+sCategory );
	if ( iPageNumber < 0 ) // need to use a variable page number
	{
		if ( iPageNumber == CSL_PAGE_CURRENT )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER");
		}
		else if ( iPageNumber == CSL_PAGE_FIRST )
		{
			iPageNumber = 0;
		}
		else if ( iPageNumber == CSL_PAGE_PREVIOUS )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER")-1;
		}
		else if ( iPageNumber == CSL_PAGE_NEXT )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER")+1;
		}
		else if ( iPageNumber == CSL_PAGE_LAST )
		{
			iPageNumber = iTotalPages;
		}
		
		SetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER", iPageNumber);
	}
	// @todo this logic is not correct in how it figures total pages
	string sPageLocation;
	if ( iTotalItems > 0 )
	{
		sPageLocation = " - Page "+IntToString(iPageNumber+1)+" of "+IntToString(iTotalPages+1)+" pages";
	}
	else
	{
		sPageLocation = "Nothing Found";
	}
	//if (sScreen==SCREEN_DMFI_CHOOSE)
	//{
	//	nModal=TRUE;
	//}
	//else
	//{
	nModal=FALSE;
	//}
			    
	DisplayGuiScreen(oPC, sScreen, nModal, "cslappearance.xml");
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sPageTitle+sPageLocation);
	
	if ( GetLocalInt(oTable, "DATATABLE_FULLYSORTED" ) )
	{
		SetGUIObjectHidden( oPC, sScreen, "FILTER_PANE", FALSE ); // true hides, false shows
		//SendMessageToPC( GetFirstPC(), "hiding");
	}
	else
	{
		SetGUIObjectHidden( oPC, sScreen, "FILTER_PANE", TRUE ); // true hides, false shows
		//SendMessageToPC( GetFirstPC(), "showing");
	}
	
	int iRealCurrent;
	string sString;
	int iRow; // this is the 2da row id, which starts a 0 but often skips sets of rows
	n = 0; // this is the physical row number
	while (n<31)
	{
		nCurrent = (iPageNumber*30) + iStartRow + n;
		iRealCurrent = (iPageNumber*30) + n;
		if ( iRealCurrent < iTotalItems )
		{
			iRow = CSLDataTableGetRowByIndex( oTable, nCurrent );
			sString = CSLDataTableGetStringFromNameColumn( oTable, iRow );
			
		}
		else
		{
			nCurrent = -1;
			sString = "";
			iRow = -1;
		}
		//sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		
		//CSLDataTableGetStringByRow( oTable, sField, iRow );
		
		if ( sString != "" )
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, sString);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
			SetLocalGUIVariable(oPC, sScreen, n+1+100, sTableName+"_"+IntToString( iRow ) ); // will store the actual row number as it goes
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
			SetLocalGUIVariable(oPC, sScreen, n+1+100, "" );
		}	
		n++;
	}

	// show the last, prev, next and first buttons as appropriate
	if (( iTotalPages <= iPageNumber )	) // || (sScreen!=SCREEN_DMFI_DMLIST)
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
		SetGUIObjectHidden(oPC, sScreen, "btn-last", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);
		SetGUIObjectHidden(oPC, sScreen, "btn-last", FALSE);	
	}
			
	if ((iPageNumber==0) ) // || (sScreen!=SCREEN_DMFI_DMLIST)
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
		SetGUIObjectHidden(oPC, sScreen, "btn-first", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);
		SetGUIObjectHidden(oPC, sScreen, "btn-first", FALSE);
	}
}

// Show appropriate Death screen for Single & Multiplayer
void CSLSetIsDeathPopUpDisplayed( object oPC, int bDisplayed )
{
	SetLocalInt( oPC, "__bKnockOutPopUpDisplayed", bDisplayed );
}

// Hides Death Screen for oPC
void CSLHideDeathScreen( object oPC )
{
	CloseGUIScreen( oPC, "SCREEN_PARTY_DEATH" );	
}

// Displays Hidden Death Screen ( full screen button ) to oPC
void CSLShowHiddenDeathScreen( object oPC )
{
	DisplayGuiScreen( oPC, "SCREEN_HIDDEN_DEATH", FALSE );
}

// Hides Hidden Death Screen for oPC
void CSLHideHiddenDeathScreen( object oPC )
{
	CloseGUIScreen( oPC, "SCREEN_HIDDEN_DEATH" );
}

// Determine if Death screen is visible
int CSLGetIsDeathPopUpDisplayed( object oPC=OBJECT_SELF )
{
	return ( GetLocalInt( oPC, "__bKnockOutPopUpDisplayed" ) ); // KNOCKOUT_POPUP_DISPLAYED
}

// Hide & Reset Death-related GUI screens
void CSLRemoveDeathScreens( object oPC=OBJECT_SELF )
{
	CSLHideDeathScreen( oPC );
	CSLHideHiddenDeathScreen( oPC );
	CSLSetIsDeathPopUpDisplayed( oPC, FALSE );
}

// Displays Death Screen to oPC
// - bModal: T/F, Display window modally
// - bRespawn: T/F, Enables Respawn button
// - bLoadGame: T/F, Enables Load Game button
// - bWaitForHelp: T/F, Enables Wait For Help button
void CSLShowDeathScreen( object oPC, int bModal=TRUE, int bRespawn=FALSE, int bLoadGame=FALSE, int bWaitForHelp=FALSE )
{
	SetGUIObjectHidden( oPC, "SCREEN_PARTY_DEATH", "BUTTON_WAIT_FOR_HELP", !bWaitForHelp );
	SetGUIObjectHidden( oPC, "SCREEN_PARTY_DEATH", "BUTTON_RESPAWN", !bRespawn );
	SetGUIObjectDisabled( oPC, "SCREEN_PARTY_DEATH", "BUTTON_LOAD_GAME", !bLoadGame );
	DisplayGuiScreen( oPC, "SCREEN_PARTY_DEATH", bModal );
}

void CSLShowProperDeathScreen( object oPC=OBJECT_SELF )
{
	// Force PC into original character
	oPC = SetOwnersControlledCompanion( oPC );

	int bWaitForHelp = FALSE;
	int bRespawn = FALSE;
	int bLoadGame = FALSE;
	int bMultiplayer = !GetIsSinglePlayer();
	
	// Wait For Help, Respawn options only available in MP
	if ( bMultiplayer == TRUE )
	{
		bWaitForHelp = TRUE;
		bRespawn = TRUE;
		bLoadGame = CSLGetIsPCHost(oPC);
	}
	else
	{
		bWaitForHelp = FALSE;
		bRespawn = FALSE;
		bLoadGame = TRUE;
	}

	CSLShowDeathScreen( oPC, TRUE, bRespawn, bLoadGame, bWaitForHelp );
	CSLSetIsDeathPopUpDisplayed( oPC, TRUE );
}

