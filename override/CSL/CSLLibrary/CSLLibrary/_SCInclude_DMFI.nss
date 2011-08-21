/** @file
* @brief Include File for DMFI
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

const int bTEXTDEBUG = FALSE;


// this i am keeping
const int SPELLDM_INVIS = -55;




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_SCInclude_DMFI_c"
#include "_SCInclude_Chat_c"

#include "_CSLCore_Config"

#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Appearance"
#include "_CSLCore_Visuals"
#include "_CSLCore_Messages"
#include "_CSLCore_Player"
#include "_CSLCore_Position"



#include "_CSLCore_UI"

#include "_SCInclude_Language"
#include "_SCInclude_Playerlist"
#include "_SCInclude_DMInven"
#include "_SCInclude_CharEdit"
#include "_CSLCore_ObjectArray"
#include "_SCInclude_DynamConvos"
// ******* FOR TRANSLATIONS - CHANGE THIS TO MATCH YOUR TRANSLATION FILE *******
//#include "_CSLCore_DMFIEnglish"

// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

//void CSLLanguageGive(object oPC, string sLang);

//void DMFI_GrantOutsider(object oPC);

//void DMFI_GrantLanguage(object oPC, string sLang);


//int DMFI_IsLanguageKnown(object oPC, string sLang);

//void DMFI_InitializeModule(object oPC = OBJECT_INVALID);

//void DMFI_VerifyToolData(object oPC, object oTool);

//void DMFI_ListLanguages(object oDM, object oTarget);

//void DMFI_InitializePlugins(object oPC);

//void DMFI_ListPlugins(object oPC);

//void DMFI_InsertionSort(object oWPLocker, string sPrefix, int nMax);


void DMFI_ShowDMListUI(object oPC, string sScreen=SCREEN_DMFI_DMLIST);

//void DMFI_GrantChoosenLanguages(object oPC);

/*
void CSLDMFI_ClearUIData(object oPC);





// FILE: dmfi_inc_langexe
//Purpose: Sets sLang as a valid language for oPC.  List starts at a value of 0.
//Includes a check for DMFI_IsLanguageKnown within this function.

//FILE: dmfi_inc_langexe
//Purpose: Returns TRUE / FALSE whether sLang is known by oPC


//FILE: dmfi_inc_langexe
//Purpose: Reports oTarget's languages to oDM for review
void DMFI_ListLanguages(object oDM, object oTarget);

//FILE: dmfi_inc_langexe
//Purpose: Returns a default language that has been linked to a new name via
//a plugin.  sLang is the name of the NEW Language - a default DMFI Language
//is returned.  If there is no link it returns ""
string DMFI_NewLanguage(string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Removes sLang as a valid Language for oPC and decrements the max number
// of known languages.  The player is informed of the action.
int DMFI_RemoveLanguage(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Sends sTranslate to any nearby speakers of sLang.  NOTE: sTranslate
//is the original text before it is translated so we just send it as is.
void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI);



// FILE: dmfi_inc_initial
// OnClient Enter function to give a Tool to the entering PC / DM.  It
// calls DMFI_InitializeModule() to list/acquire plugins and calls
// DMFI_InitializeLanguage() to define languages for player.
void DMFI_ClientEnter(object oPC);

// FILE: dmfi_inc_initial
//Purpose: Gives version number and initialization text and if needed, will
//call DMFI_InitializePlugins.


// FILE: dmfi_inc_initial
//Purpose: Initializes any Language Plugins for the module
void DMFI_InitializeLanguagePlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Initializes any Command Plugins for the module
void DMFI_InitializeCommandPlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Initializes any Emote Plugins for the module
void DMFI_InitializeEmotePlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Creates a list of known languages on oTool based	upon base rules,
// previously DM granted languages, and plugins.  Note:  As of 1.02, languages
// are persistent and DM granted languages should remain until deleted.
// oPC is the player, oTool is oPCs tool, and oDM is an optional requesting DM.
void DMFI_InitializeLanguage(object oPC, object oTool, object oDM=OBJECT_INVALID);

// FILE: dmfi_inc_initial
//Purpose: Creates a Waypoint Locker and calls the subroutines for loading the
//individual plugin


// FILE: dmfi_inc_initial
// oTool is the OLD tool.  It will be destroyed.  A new tool will be created
// for oPC to reset any and all variables / preferences.
void DMFI_InitializeTool(object oPC, object oTool);

// FILE: dmfi_inc_initial
// An insertion sort routine to order any found plugins into order.  It is NOT
// a generic sort routine.  It is designed to work with plugins only due to how
// variables are refernced.  sPrefix is DMFI_DM or DMFI_PC + the type of plugin.
// nMax is the nDMSlot or nPCSlot which is the number of items in the array +1


// FILE: dmfi_inc_initial
// Lists current plugins that are loaded for the module.



// FILE: dmfi_inc_initial
//Purpose: Runs Command Plugins
int DMFI_RunCommandPlugins(object oPC);



// FILE: dmfi_inc_initial
// Runs any plugins found on initialization of the module.  sType is the type
// like emote, language, command, or prefix.
void DMFI_RunPlugins(object oPC, string sType);

// FILE: dmfi_inc_initial
// Small function to write the tool to the database after loading with data.
void DMFI_StoreTool(object oPC, string sResRef, object oTool);

// FILE: dmfi_inc_initial
// This function transfers langauge listing between to objects.
void DMFI_TransferTempLangData(object oStart, object oFinish);

// FILE: dmfi_inc_initial
// Adds data (variables) to the tool if none is present.
// This is called from the OnAcquire Module event.


// FILE: dmfi_inc_inc_com
// Creates effects with NO PARAMETERS - simplest form of effects only are
// applied via this function.
void DMFI_CreateEffect(string sCommand, string sParam1, object oPC, object oTarget);

// FILE: dmfi_inc_inc_com
// Creates a sound at a specified location.  sCommand is referenced in DMFI_INC_STRINGS
void DMFI_CreateSound(object oTool, object oPC, object oTarget, object oSpeaker, location lTargetLoc,  string sCommand, string sParam1);

// FILE: dmfi_inc_inc_com
//Purpose: Create a Visual effect according to preferences.  sText is the
//Label for the VFX and sParam is the row of the 2da file.
void DMFI_CreateVFX(object oTool, object oSpeaker, string sText, string sParam);

// Breaks sOriginal into sTool, sCommand, sParam1, sParam2 and sets these values
// on oPC.  Allows easy use by Command code and any command plugins.
void DMFI_DefineStructure(object oPC, string sOriginal);

// FILE: dmfi_inc_inc_com
// Returns a EMT form of a partial skill to allow for the end user DM to type
// only a portion of a skill as a shortcut.
string DMFI_FindPartialSkill(string sCommand);

// FILE: dmfi_inc_inc_com
// DMFI Follow Function: oPC will follow a target.  The target is stored on the
// DMFI Tool.  It will repeat until the target is not valid (.follow off command).
void DMFI_Follow(object oPC);

// FILE: dmfi_inc_inc_com
//Purpose: Returns Net Worth value for oTarget
int DMFI_GetNetWorth(object oTarget);

// FILE: dmfi_inc_inc_com
// Identifies all of oTargets inventory at the request of oDM.
void DMFI_IdentifyInventory(object oTarget, object oDM);

// FILE: dmfi_inc_inc_com
//Purpose: Stores the default local music as default music - only runs once.
void DMFI_InitializeAreaMusic(object oPC);

// FILE: dmfi_inc_inc_com
// DMFI Follow Function: oPC has directed an NPC to follow a target.  Both target's
// are stored on oPC's DMFI Tool.  It will repeat until the follower is no longer
// valid on the DMFI Tool (.npc follow off command).
void DMFI_NPCFollow(object oPC);

// FILE: dmfi_inc_inc_com
// Removes items more valuable than the max value listed for sLevel in the 2da
// max item value file.  Reports action to oPC.
void DMFI_RemoveUber(object oPC, object oTarget, string sLevel);

// FILE: dmfi_inc_inc_com
// Function to report information about all characters on the server to oPC
void DMFI_Report(object oPC, object oTool, string sCommand);

// FILE: dmfi_inc_inc_com
// Rolls dice for oTarget.  oPC can be a DM or Player.  Format: 2d4
void DMFI_RollBones(object oPC, object oTarget, string sCommand);

// Rolls checks for the DMFI
void DMFI_RollCheck(object oSpeaker, string sSkill, int bDMRequest=FALSE, object oDM=OBJECT_INVALID, object oTool=OBJECT_INVALID);

// FILE: dmfi_inc_inc_com
// Removes all inventory from oTarget.  Requested by oDM.  Server log is created
// to log this action.
void DMFI_StripInventory(object oTarget, object oDM);

// FILE: dmfi_inc_inc_com
// Returns a players storage unit for any DMFI taken items


// FILE: dmfi_inc_tool	Builds a list of the names / labels from a 2da file onto
// the users DMFI Tool.  Just use the DMFI_2DA constant - you don't have to worry
// about which column or converting to / from StrRef - this function handles all
// that automatically.
void DMFI_Build2DAList(object oTool, string sPage, string sFileName);

// FILE: dmfi_inc_tool	Builds a listing of effects on a particular target onto the
// users DMFI tool
void DMFI_BuildEffectList(object oTool, object oTarget);

// FILE: dmfi_inc_tool
// Builds a complete listing of all possible effects onto oTool.
void DMFI_BuildEffectsPossList(object oTool);

// FILE: dmfi_inc_tool	Builds a listing of ItemProps on a particular target onto
// the users DMFI tool
void DMFI_BuildItemPropList(object oTool, object oTarget);

// FILE: dmfi_inc_tool
// Builds a list of oPCs known languages onto oTool.
void DMFI_BuildLanguageList(object oTool, object oPC);

// FILE: dmfi_inc_tool
// Returns sWord with the first letter as an upper case
//string CSLStringToProper(string sWord);

// FILE: dmfi_inc_tool
// Checks for DM status EITHER as DM or by Possession
//int CSLGetIsDM(object oPC);

// FILE: dmfi_inc_tool
// Returns the appropriate tool for oPC regardless of possession issues.



// FILE: dmfi_inc_tool
// Sorts the large VFX data into 4 different subsets
void DMFI_SortVFXList(string sResult, int n, object oTool);

// FILE: dmfi_inc_tool
// This function will toggle a DMFI Prefernce.  sCommand is the type of command
// you wish to toggle (ie "detail").  It is called from the dmfi_exe_conv to
// refresh conversation tokens and also called from dmfi_exe_main.
// NUMBER preference values are set via a page call to a number listing so they
// are not included in this technique - ie they are not toggles.
// Returns the new value set to the appropriate variable.
string DMFI_TogglePreferences(object oTool, string sCommand);

// FILE: dmfi_inc_tool
// Function handles setting the speaker and target.  It is required for possession
// states on the player side and DM client side.  It returns the current controlled
// character of the PC client that hit the UI button or typed the text.
object DMFI_UITarget(object oPC, object oTool);

// FILE: dmfi_inc_tool
// Returns sInput with spaces for underscores.  Needed for UI support.
//string DMFI_UnderscoreToSpace(string sInput);

// FILE: dmfi_inc_tool
// Updates a number value CUSTOM TOKEN.  Similiar to DMFI_TogglePreferences which
// updates a string value.
void DMFI_UpdateNumberToken(object oTool, string sCommand, string sNewValue);

string DMFI_GetSoundString(int nValue, string sParam);

//string DMFI_GetEffectString(string sValue);
*/

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

void DoDMInvis(object  oPC)
{
	if ( !GetIsDMPossessed( oPC ) && !GetIsDM( oPC )  )
 	{
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCINVISIBILITY_TOGGLE_BUTTON", TRUE );
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCVISIBILITY_TOGGLE_BUTTON", FALSE );
	}
	
	effect eEffect = EffectCutsceneGhost();
	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY) );
	eEffect = EffectLinkEffects(eEffect, EffectEthereal() );
	eEffect = SupernaturalEffect( eEffect );
	eEffect = SetEffectSpellId(eEffect, SPELLDM_INVIS );
	SetCollision(oPC, FALSE);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC );
	if ( CSLGetPreferenceSwitch( "HideDMInChat", FALSE) == TRUE  && CSLGetPreferenceSwitch( "HideDMInChatOnDMInvis", FALSE) == TRUE )
	{
		CSLPlayerList_SetHidden( oPC, TRUE  );
	}
 	
}

void DoDMUninvis(object oPC)
{
	if ( !GetIsDMPossessed( oPC ) && !GetIsDM( oPC )  )
 	{
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCINVISIBILITY_TOGGLE_BUTTON", FALSE );
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCVISIBILITY_TOGGLE_BUTTON", TRUE );
	}
	
	SetCollision(oPC, TRUE); // GetIsDM( oPC ) &&
	if (  CSLGetPreferenceSwitch( "HideDMInChat", FALSE) == TRUE  && CSLGetPreferenceSwitch( "HideDMInChatOnDMInvis", FALSE) == TRUE )
	{
		CSLPlayerList_SetHidden( oPC, FALSE  );
	}
	//if ( GetIsDM( oPC ) && CSLGetPreferenceSwitch( "HideDMInChat", FALSE) && CSLGetPreferenceSwitch( "HideDMInChatOnDMInvis", FALSE))
	//{
	//	CSLPlayerList_SetHidden( oPC, FALSE );
	//}
	//else
	//{
	//	CSLPlayerList_SetHidden( oPC, FALSE  );
	//}
	
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLDM_INVIS );
}




// ************************** FUNCTIONS ****************************************



	


///////////////////// DO NOT EDIT BELOW THIS!! ///////////////////////////////



void DMFI_InsertionSort(object oWPLocker, string sPrefix, int nMax)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InsertionSort Start", GetFirstPC() ); }
	//Purpose: Insertion Sort to properly order any DMFI Plugins according to Priority
	//Original Scripter: EPOlson from DMFI Guild
	//Last Modified By: EPOlson 6/24/6
	int i, j;			// iterators
	float fSortPriority;  //value we will sort by
	float fListPriority;
	string sPluginName;	// item we are inserting
	string sReplace;
	
	for (i=1; i < nMax; i++)
	{
		sPluginName = GetLocalString(oWPLocker, sPrefix + "'Name" + IntToString(i));
		fSortPriority = GetLocalFloat(oWPLocker, sPrefix + "Priority" + sPluginName);
	
		j = i;
		while ((j > 0) && ( fSortPriority > GetLocalFloat(oWPLocker, sPrefix + "Priority"+GetLocalString(oWPLocker, sPrefix + "'Name" + IntToString(j-1)))))
		{
			SetLocalString(oWPLocker, sPrefix + "'Name" + IntToString(j),
			GetLocalString(oWPLocker, sPrefix + "'Name" + IntToString(j-1)));
			j=j-1;
		}
		SetLocalString(oWPLocker, sPrefix + "'Name" + IntToString(j), sPluginName);
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InsertionSort End", GetFirstPC() ); }
}





void DMFI_StoreTool(object oPC, string sResRef, object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_StoreTool Start", oPC ); }
	//Purpose: Function to simply delay storing of item to database.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/26/6
	CSLMessage_SendText(oPC, "DMFI Tool stored to database.");
	SetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION, MOD_VERSION);
	StoreCampaignObject(DMFI_DATABASE, sResRef, oTool);
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_StoreTool End", oPC ); }
}		
	






void DMFI_Build2DAASoundsList()
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Build2DAASoundsList Start", GetFirstPC() ); }
		//Purpose: Build a list of the ambeintsounds onto oTool
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/22/6
	string sResult, sResource;
	int n=1;		// File starts with 1
		
	while (n<148)
	{
		sResult = Get2DAString("ambientsound", "Description", n);
		sResource = Get2DAString("ambientsound", "Resource", n);
		sResult=GetStringByStrRef(StringToInt(sResult));
		if (FindSubString(sResource, "_pl_")!=-1)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_AMBIENT_PEOPLE");	
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else if (FindSubString(sResource, "_cv_")!=-1)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_AMBIENT_CAVE");	
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else if ((FindSubString(sResource, "_na_")!=-1) || (FindSubString(sResource, "_mg_")!=-1))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_AMBIENT_MAGIC");	
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_AMBIENT_MISC");	
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		
		n++;
		if (n==95) n++;  //deal with padding
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Build2DAASoundsList End", GetFirstPC() ); }
}


void DMFI_Build2DAAMusicList()
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Build2DAAMusicList Start", GetFirstPC() ); }
	//Purpose: Build a list of the ambientmusic onto oTool
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/22/6
	string sResult;
	int n=1;		// File starts with 1
	
	while (n<168)
	{
		sResult = Get2DAString("ambientmusic", "Description", n);
		sResult=GetStringByStrRef(StringToInt(sResult));
		if (n<34)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_MUSIC_NWN1");
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else if (((n>33) &&  (n<49))  || (n==60) || (n==57) || ((n>69) &&  (n<76)))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_MUSIC_BATTLE");
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else if ((n>94)&&(n<117))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_MUSIC_NWN2");
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		//modified qk 10/07/07
		else if ((n>125))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_MUSIC_MOTB");
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
		else
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_MUSIC_XP");
			CSLAddReplyLinkInt(sResult, "", COLOR_NONE, n);
		}
	
		n++;
		if (n==76) n=95;	//deal with padding
		if (n==100) n++;	//deal with padding
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Build2DAAMusicList End", GetFirstPC() ); }
}			

void DMFI_Build2DAList(object oTool, string sPage, string sFileName)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Build2DAList Start", GetFirstPC() ); }
	//Purpose: Build a list of the 2da file sFile onto oTool
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/22/6
	string sColumn;
	string sResult;
	int n=0;
	// Handle special exceptions to the Label rule
	if (sFileName == "polymorph")
	{
		sColumn = "Name";
	}
	else
	{
		sColumn = "Label";
	}
	sResult = Get2DAString(sFileName, sColumn, n);
	while (sResult!="")
	{
		// Process the StrRef numbers for the exceptions of ambientmusic/ambientsound
		if ((sFileName=="ambientmusic") || (sFileName=="ambientsound"))
		{
			sResult=GetStringByStrRef(StringToInt(sResult));
		}
		//NWN2 edit - ignore any deleted data.
		if (GetStringLeft(sResult, 4)!="DEL_")
		{
			// SendMessageToPC(GetFirstPC(), "DEBUGGING: 2da data: "+ IntToString(n) + " : " + sResult);
			CSLDataArray_PushString( oTool, sPage, sResult );
		}
		n++;
		sResult = Get2DAString(sFileName, sColumn, n);
	}
	// Assume right here that the 2da file is stagnant while the server is up.
	// May need to add a command to reset a 2da data file - ie delete this int.
	SetLocalInt(oTool, "DMFITool2da" + sPage, 1);
}

void DMFI_BuildEffectList(object oTool, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildEffectList Start", GetFirstPC() ); }
	//Purpose: Build a list of effects on oTarget onto oTool
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 6/23/6
	effect eEffect = GetFirstEffect(oTarget);
	int n=0;
	int nEffect;
	while (GetIsEffectValid(eEffect))
	{
		nEffect = GetEffectType(eEffect);
		CSLDataArray_SetString( oTool, "TARGET_EFFECT", n, CSLGetEffectTypeName(nEffect) );
		CSLDataArray_SetInt(oTool, "TARGET_EFFECT", n, nEffect );
		n++;
		eEffect = GetNextEffect(oTarget);
	}
	
	if (n==0)
	{
		CSLDataArray_PushString( oTool, "TARGET_EFFECT", "No valid effects found." );
	}
} // DMFI_BuildEffectList()

void DMFI_BuildEffectsPossList(object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildEffectsPossList Start", GetFirstPC() ); }
	//Purpose: Build a complete list of possible effects that can be applied.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 6/25/6
	string sEffect;
	int n=1;

	sEffect = CSLGetEffectTypeName(n);

	while (sEffect!="")
	{
		CSLDataArray_PushString( oTool, "LIST_EFFECT", sEffect );
		n++;
		sEffect = CSLGetEffectTypeName(n);
	}
}





void DMFI_BuildPlaceableSoundList(object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildPlaceableSoundList Start", GetFirstPC() ); }
	//Purpose: Build a list of sounds that we can play
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 10/15/6
	
	int n = 1;
	string sSound;
		
	for (n=0; n<21; n++)
	{
		sSound = DMFI_GetSoundString(n, "city");
		CSLDataArray_PushString( oTool, "LIST_SOUND_CITY", sSound );
		CSLDataArray_PushString( oTool, "DISPLAY" + "LIST_SOUND_CITY", GetLocalString(GetModule(), DMFI_TEMP) );
	}
	n=0;
	for (n=0; n<38; n++)
	{
		sSound = DMFI_GetSoundString(n, "nature");
		CSLDataArray_PushString( oTool, "LIST_SOUND_NATURE", sSound );
		CSLDataArray_PushString( oTool, "DISPLAY" + "LIST_SOUND_NATURE", GetLocalString(GetModule(), DMFI_TEMP) );
	}
	n=0;
	for (n=0; n<30; n++)
	{
		sSound = DMFI_GetSoundString(n, "people");
		CSLDataArray_PushString( oTool, "LIST_SOUND_PEOPLE", sSound );
		CSLDataArray_PushString( oTool, "DISPLAY" + "LIST_SOUND_PEOPLE", GetLocalString(GetModule(), DMFI_TEMP) );
		
	}	
	n=0;
	for (n=0; n<20; n++)
	{
		sSound = DMFI_GetSoundString(n, "magical");
		CSLDataArray_PushString( oTool, "LIST_SOUND_MAGIC", sSound );
		CSLDataArray_PushString( oTool, "DISPLAY" + "LIST_SOUND_MAGIC", GetLocalString(GetModule(), DMFI_TEMP) );
	}	
}

void DMFI_BuildRecentVFXList(object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildRecentVFXList Start", GetFirstPC() ); }
	//Purpose: Build a list of recent VFX data
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/18/6
	int n=0;
	int nTest, nCurrent, nLength;
	string sVFXLabel;
	while (n<30)
	{
		nTest = GetLocalInt(oTool, DMFI_VFX_RECENT + IntToString(n));
		if (nTest==0) break;
		
		sVFXLabel = Get2DAString("visualeffects", "Label", nTest);
		nCurrent = CSLDataArray_PushString( oTool, "LIST_VFX_RECENT", sVFXLabel );
		CSLDataArray_SetInt( oTool, "LIST_VFX_RECENT", nCurrent, nTest);
		
		n++;
	}
			
	if (n==0)
	{
		CSLDataArray_PushString( oTool, "LIST_VFX_RECENT", "No Valid Objects Found." );
	}
}			

void DMFI_SortVFXList(string sResult, int n, object oTool)
{
	
	//Purpose: Sorts VFX data into 4 separate pages.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/11/6
	int nCurrent;
	int nLength;
	
	
	// skip over blank rows, we don't want to store junk that is not needed or being used, will deal with a lot of blank garbage rows
	if ( sResult == "" ) { return; } // just don't try
	string sResultLower = GetStringLowerCase(sResult);
	if ( sResultLower == "void" ) { return; } // just don't try
	if ( sResultLower == "padding" ) { return; } // just don't try
	if (GetStringLeft(sResultLower, 4) == "del_" ) { return; } // just don't try
	if (GetStringLeft(sResultLower, 7) == "hidden_" ) { return; } // just don't try
	if (GetStringLeft(sResultLower, 4) == "hid_" ) { return; } // just don't try
	if (GetStringLeft(sResultLower, 8) == "padding_" ) { return; } // just don't try
	if (GetStringRight(sResultLower, 8) == "_removed" ) { return; } // just don't try
	if (GetStringRight(sResultLower, 7) == "_remove" ) { return; } // just don't try
	
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_SortVFXList Start", GetFirstPC() ); }
	
	if (FindSubString(sResult, "_SPELL_")!=-1)
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-14);
		nCurrent = CSLDataArray_PushString( oTool, "LIST_VFX_SPELL", sResult );
		CSLDataArray_SetInt( oTool, "LIST_VFX_SPELL", nCurrent, n );
	}
	else if (FindSubString(sResult, "_DUR_")!=-1)
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-8);
		nCurrent = CSLDataArray_PushString(oTool, "LIST_VFX_DUR", sResult );
		CSLDataArray_SetInt( oTool, "LIST_VFX_DUR", nCurrent, n);
	}
	else if ((FindSubString(sResult, "_IMP_")!=-1) || (FindSubString(sResult, "_INVOCATION_")!=-1))
	{
		if (FindSubString(sResult, "VFX_INVOCATION")!=-1)
		{
			sResult = GetStringRight(sResult, GetStringLength(sResult)-17);
		}
		else
		{
			nLength = GetStringLength(sResult);
			sResult = GetStringRight(sResult, nLength-8);
		}		
		nCurrent = CSLDataArray_PushString( oTool, "LIST_VFX_IMP", sResult );
		CSLDataArray_SetInt( oTool, "LIST_VFX_IMP", nCurrent, n );
	}	
	else
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-8);
		nCurrent = CSLDataArray_PushString( oTool, "LIST_VFX_MISC", sResult );
		CSLDataArray_SetInt(oTool, "LIST_VFX_MISC", nCurrent, n );
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_SortVFXList End", GetFirstPC() ); }
}


void DMFI_BuildVFXList(object oTool, int iLastRowProcessed = 0 )
{
	// redo this so it is no longer needed, it's almost replaced after the other ui is built that can deal with it	
	string s2daName = "visualeffects";
	int iMaxRows = GetNum2DARows( s2daName );
	if ( iMaxRows == 0 ) { return; }
	int iMaxRowsToProcess = 200;
	
	string sResult;
	int iRow = 0;
	if ( iMaxRows > iLastRowProcessed )
	{
		int iStartingRow = iLastRowProcessed+1;
		int iEndingRow = CSLGetMin( iStartingRow + iMaxRowsToProcess, iMaxRows ); // make sure it's limited to real rows
		
		for (iRow = iStartingRow; iRow <= iEndingRow; iRow++) 
		{
			sResult = Get2DAString( s2daName, "Label", iRow);
			DMFI_SortVFXList(sResult, iRow, oTool);
		}
		iLastRowProcessed = iRow; // will that work
		
		if ( iMaxRows > iLastRowProcessed )
		{
			DelayCommand( CSLRandomBetweenFloat( 0.25f, 2.0f ), DMFI_BuildVFXList( oTool, iLastRowProcessed ) );
			return;
		}
	}
}








void DMFI_SetItemPrompt(object oTool, object oItem)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_SetItemPrompt Start", GetFirstPC() ); }
	//Purpose: Sets Item Data for Prompt
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/26/6
	string sItemProps;
	
	if (GetItemCursedFlag(oItem))
	{
		sItemProps = sItemProps + "Cursed" + " ";
	}
	if (GetPlotFlag(oItem))
	{
		sItemProps = sItemProps + "Plot" + " ";
	}
	if (GetStolenFlag(oItem))
	{
		sItemProps = sItemProps + "Stolen";
	}			
	SetLocalString(oTool, "ItemProps", sItemProps);
}	





void DMFI_ShowDMListUI(object oPC, string sScreen=SCREEN_DMFI_DMLIST)
{
	//SendMessageToPC( oPC, "DMFI_ShowDMListUI Start" );
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_ShowDMListUI Start", oPC ); }
	//Purpose: Shows the DM list - builds the 30 entries and handles page updates.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/27/6
	int bUseCSLTables = FALSE;
	
	string sDMListTitle;
	string sPage, sTest, sTitle;
	int nPage, n, nCurrent, nModal;
	object oTool = CSLDMFI_GetTool(oPC);
	
	if (sScreen==SCREEN_DMFI_CHOOSE)
	{
		nModal=TRUE;
	}
	else
	{
		nModal=FALSE;
	}
			
	DisplayGuiScreen(oPC, sScreen, nModal, "dmfidmlist.xml");
	sPage = GetLocalString(oPC, DMFI_UI_PAGE);
	sTitle = GetLocalString(oPC, DMFI_UI_LIST_TITLE);
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sTitle);
	
	//if ( sTitle == CV_PROMPT_APPEARANCE ) // quick hack to get it using my system for appearance values
	//{
	//	bUseCSLTables = TRUE;
	//}
	
	nPage = GetLocalInt(oPC, sPage + DMFI_CURRENT);
	
	//SendMessageToPC( oPC, "DMFI_ShowDMListUI sPage="+sPage+" sTitle="+sTitle+" nPage="+IntToString(nPage) );
		
	
	// this is the old system that needs the dmtool
	n = 0;
	while (n<31)
	{
		nCurrent = (nPage*30) + n;
		//sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		sTest = CSLDataArray_GetString(oTool, sPage, nCurrent);
		
		//SendMessageToPC( oPC, "DMFI_ShowDMListUI sPage="+sPage+" sTest="+sTest+" nCurrent="+IntToString(nCurrent) );
		
		if (sTest!="")
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, sTest);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
		}	
		n++;
	}
	
		
	//next and previous buttons
	//sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
	sTest = CSLDataArray_GetString(oTool, sPage, nCurrent);
	
	if ((sTest=="")	|| (sScreen!=SCREEN_DMFI_DMLIST))
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);	
	}		
	if ((nPage==0) || (sScreen!=SCREEN_DMFI_DMLIST))
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);	
	}
	//SendMessageToPC( oPC, "DMFI_ShowDMListUI End" );
}

/*
void DMFI_ShowDMListUIOld(object oPC, string sScreen=SCREEN_DMFI_DMLIST)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_ShowDMListUI Start", oPC ); }
	//Purpose: Shows the DM list - builds the 30 entries and handles page updates.
//Original Scripter: Demetrious
//Last Modified By: Demetrious 12/27/6
	int bUseCSLTables = FALSE;
	
	string sDMListTitle;
	string sPage, sTest, sTitle;
	int nPage, n, nCurrent, nModal;
	object oTool = CSLDMFI_GetTool(oPC);

	if (sScreen==SCREEN_DMFI_CHOOSE)
	{
		nModal=TRUE;
	}
	else
	{
		nModal=FALSE;
	}
	
	
	
			
	DisplayGuiScreen(oPC, sScreen, nModal, "dmfidmlist.xml");
	sPage = GetLocalString(oPC, DMFI_UI_PAGE);
	sTitle = GetLocalString(oPC, DMFI_UI_LIST_TITLE);
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sTitle);
	
	if ( sTitle == CV_PROMPT_APPEARANCE ) // quick hack to get it using my system for appearance values
	{
		bUseCSLTables = TRUE;
	}
	
	nPage = GetLocalInt(oPC, sPage + DMFI_CURRENT);
	
	
	
	// this is the old system that needs the dmtool
	n = 0;
	while (n<31)
	{
		nCurrent = (nPage*30) + n;
		sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		
		if (sTest!="")
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, sTest);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
		}	
		n++;
	}
	
		
	//next and previous buttons
	sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
	
	if ((sTest=="")	|| (sScreen!=SCREEN_DMFI_DMLIST))
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
	else
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);	
			
	if ((nPage==0) || (sScreen!=SCREEN_DMFI_DMLIST))
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
	else
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);	
}
*/


void DMFI_ToggleItemPrefs(string sCommand, object oPC, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_ToggleItemPrefs Start", oPC ); }
	//Purpose: Toggles the custom token for the item target page
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/26/6
	int nTest;
	string sItemProps, sText;
	object oRef = GetLocalObject(oTarget, DMFI_INVENTORY_TARGET);
	
	if (FindSubString(sCommand, "curse")!=-1)
	{
		nTest = GetItemCursedFlag(oTarget);		
		SetItemCursedFlag(oTarget, !nTest);
		SetItemCursedFlag(oRef, !nTest);
	}	
	else if (FindSubString(sCommand, "plot")!=-1)
	{
		nTest = GetPlotFlag(oTarget);		
		SetPlotFlag(oTarget, !nTest);
		SetPlotFlag(oRef, !nTest);
	}
	else if (FindSubString(sCommand, "stolen")!=-1)
	{
		nTest = GetStolenFlag(oTarget);		
		SetStolenFlag(oTarget, !nTest);
		SetStolenFlag(oRef, !nTest);
	}
	
	if (GetItemCursedFlag(oTarget)==TRUE)
	{
		sText="Cursed";
	}
	else
	{
		sText="Not Cursed";
	}
	
	CSLMessage_SendText(oPC, "Item Cursed State: " + sText, TRUE, COLOR_GREEN);
	
	if (GetPlotFlag(oTarget)==TRUE)
	{
		sText="Plot";
	}
	else
	{
		sText="Not Plot";
	}
	
	CSLMessage_SendText(oPC, "Item Plot State: " + sText, TRUE, COLOR_GREEN);	
	
	if (GetStolenFlag(oTarget)==TRUE)
	{
		sText="Stolen";
	}
	else
	{
		sText="Not Stolen";
	}
	CSLMessage_SendText(oPC, "Item Stolen State: " + sText, TRUE, COLOR_GREEN);
}

string DMFI_TogglePreferences(object oTool, string sCommand)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TogglePreferences Start", GetFirstPC() ); }
	//Purpose: Toggles a custom token string for the DMFI conversation
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/28/6
	string sTest;
	string sMessage;
	object oPC = GetItemPossessor(oTool);
	
	if (sCommand == "detail")
	{
		sTest = GetLocalString(oTool, "DMFIDicebagDetail");
		if (sTest=="high")
		{
			sTest = "low";
			sMessage = "DMFI Dicebag Detail set to LOW.  Pass / Fail Only";
		}
		else if (sTest=="med")
		{
			sTest = "high";
			sMessage = "DMFI Dicebag Detail set to HIGH.  Shows ROLL vs. DC";
		}
		else if (sTest=="low")
		{
			sTest = "med";
			sMessage = "DMFI Dicebag Detail set to MED.  Shows ROLL and RESULT only";
		}
		SetLocalString(oTool, "DMFIDicebagDetail", sTest);
		//CSLMessage_SendText(oPC, sMessage, TRUE, COLOR_GREEN);
	}
	else if (sCommand == "report")
	{
		sTest = GetLocalString(oTool, "DMFIDicebagReport");
		if (sTest=="pc")
		{
			sTest = "party";
			sMessage = "DMFI Dicebag Reporting set to DM and entire PC PARTY.";
		}
		else if (sTest=="party")
		{
			sTest = "dm";
			sMessage = "DMFI Dicebag Reporting set to DM ONLY.";
		}
		else if (sTest=="dm")
		{
			sTest = "pc";
			sMessage = "DMFI Dicebag Reporting set to DM and attempting PC ONLY.";
		}
		SetLocalString(oTool, "DMFIDicebagReport", sTest);
		//CSLMessage_SendText(oPC, sMessage, TRUE, COLOR_GREEN);
	}
	else if (sCommand == "roll")
	{
		sTest = GetLocalString(oTool, "DMFIDicebagRoll");
		if (sTest=="pc")
		{
			sTest = "party";
			sMessage = "DMFI Dicebag set to roll dice for every individual party member.";
		}
		else if (sTest=="party")
		{
			sTest = "best";
			sMessage = "DMFI Dicebag set to roll a single check for the PC in the party with the best modifier.";
		}
		else if (sTest=="best")
		{
			sTest = "pc";
			sMessage = "DMFI Dicebag set to roll dice for targetted PC.";
		}
		SetLocalString(oTool, "DMFIDicebagRoll", sTest);
		//CSLMessage_SendText(oPC, sMessage, TRUE, COLOR_GREEN);
	}
	else if (sCommand=="musictime")
	{
		sTest = GetLocalString(oTool, DMFI_MUSIC_TIME);
		if (sTest=="day")
			sTest="night";
		else if (sTest=="night")
			sTest="both";
		else if (sTest=="both")
			sTest="battle";
		else if (sTest=="battle")
			sTest="day";
		SetLocalString(oTool, DMFI_MUSIC_TIME, sTest);
	}
	else if (sCommand=="ambdaynight")
	{
		sTest = GetLocalString(oTool, DMFI_AMB_NIGHT);
		if (sTest=="day")
			sTest="night";
		else
			sTest="day";
		SetLocalString(oTool, DMFI_AMB_NIGHT, sTest);
	}	
	return sTest;
}

object DMFI_UITarget(object oPC, object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_UITarget Start", oPC ); }
	//Purpose: Handles setting up target and speaker.  It returns the possessed creature.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/27/6
	
	object oSpeaker, oRightClick;
	object oPossess = GetControlledCharacter(oPC);
		
	if (oPossess==OBJECT_INVALID)
		oSpeaker = oPC;
	else
		oSpeaker = oPossess;
	
	oRightClick = GetPlayerCurrentTarget(oSpeaker);
	
	if (CSLGetIsDM(oPC))
	{
		if (oRightClick==OBJECT_INVALID)
			oRightClick=oSpeaker;
	}		
	
	SetLocalObject(oTool, DMFI_TARGET, oRightClick);
	SetLocalObject(oTool, DMFI_SPEAKER, oSpeaker);	
	/*	
	//CSLMessage_SendText(oPossess, "DEBUGGING UI PC: " + GetName(oPC));
	//CSLMessage_SendText(oPossess, "DEBUGGING UI Controlled: " + GetName(oPossess));
	//CSLMessage_SendText(oPossess, "DEBUGGING UI Tool: " + GetName(oTool));
	//CSLMessage_SendText(oSpeaker, "DEBUGGING: UI Target: " + GetName(oRightClick));
	*/
	return oPossess;
}



void DMFI_UpdateNumberToken(object oTool, string sCommand, string sNewValue)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_UpdateNumberToken Start", GetFirstPC() ); }
	//Purpose: Updates a custom token holding a number value for the DMFI conversation
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 11/10/6
	object oPC = GetItemPossessor(oTool);

	if (sCommand == "dc")
	{
		SetLocalString(oTool, "DMFIDicebagDC", sNewValue);
	}
	else if (sCommand == "vol")
	{
		SetLocalString(oTool, DMFI_AMBIENT_VOLUME, sNewValue);
		
	}		
	else if (sCommand == "delay")
	{
		SetLocalString(oTool, DMFI_SOUND_DELAY, sNewValue);
	}	
	else if (sCommand == "dur")
	{
		SetLocalString(oTool, DMFI_VFX_DURATION, sNewValue);
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_UpdateNumberToken End", GetFirstPC() ); }
}













void DMFI_DefineStructure(object oPC, string sOriginal)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_DefineStructure Start", oPC ); }
	//Purpose: Defines sTool, sCommand, sParam1, sParam2 from sOriginal
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 7/3/6
	string sTool;
	string sRemains;
	string sCommand;
	string sParam1;
	string sParam2;
	
	sOriginal = GetStringLowerCase(sOriginal);
	
	sTool=CSLStringBefore(sOriginal," ");
	sRemains=CSLRemoveParsed(sOriginal, sTool, " ");
	sCommand=CSLStringBefore(sRemains, " ");
	sRemains=CSLRemoveParsed(sRemains, sCommand, " ");
	sParam1=CSLStringBefore(sRemains, " ");
	sParam2=CSLRemoveParsed(sRemains, sParam1, " ");
	
	SetLocalString(oPC, "DMFIsTool", sTool);
	SetLocalString(oPC, "DMFIsCommand", sCommand);
	SetLocalString(oPC, "DMFIsParam1", sParam1);
	SetLocalString(oPC, "DMFIsParam2", sParam2);
}



/*
void DMFI_Follow(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Follow Start", oPC ); }
	//Purpose: Forces oPC to follow oFollow
	// Original scripter: Demetrious
	// Last Modified by:  Demetrious 1/19/7
	object oTool = CSLDMFI_GetTool(oPC);
	object oFollow = GetLocalObject(oTool, DMFI_FOLLOW);

	if (oFollow!=OBJECT_INVALID)
	{
		if (GetArea(oPC)!=GetArea(oFollow))
		{
			AssignCommand(oPC,ClearAllActions(TRUE));
			AssignCommand(oPC,JumpToObject(oFollow));
		}
		else if (GetDistanceBetween(oPC, oFollow)>12.0)
		{
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionForceMoveToObject(oFollow, TRUE, 1.5));
		}		
		else if (GetDistanceBetween(oPC, oFollow)>3.0)
		{ // use Force Follow to smooth out camera
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionForceMoveToObject(oFollow, FALSE, 1.5));
		}
		DelayCommand(3.0, DMFI_Follow(oPC));
	}
}
*/




/*
this is not used at all
void DMFI_NPCFollow(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_NPCFollow Start", oPC ); }
	//Purpose: Forces oNPCFollow to follow oNPCFollowTarget which is stored on
	// oPC's DMFI Tool.
	// Original scripter: Demetrious
	// Last Modified by:  Demetrious 8/13/6
	object oTool = CSLDMFI_GetTool(oPC);

	object oNPCFollow = GetLocalObject(oTool, "DMFIFollowNPC");
	object oNPCFollowTarget = GetLocalObject(oTool, "DMFIFollowTarget");

	if (oNPCFollow!=OBJECT_INVALID)
	{
		if (GetDistanceBetween(oNPCFollow, oNPCFollowTarget)>10.0)
		{
			AssignCommand(oNPCFollow, ClearAllActions(TRUE));
			AssignCommand(oNPCFollow, ActionForceFollowObject(oNPCFollowTarget));
		}
		else if (GetArea(oNPCFollow)!=GetArea(oNPCFollowTarget))
		{
			AssignCommand(oNPCFollow,ClearAllActions(TRUE));
			AssignCommand(oNPCFollow,JumpToObject(oNPCFollowTarget));
		}
		DelayCommand(3.0, DMFI_NPCFollow(oPC));
	}
}
*/













// FILE: dmfi_inc_emotes
// Runs code for DMFI Emotes.  It will return a pass regardless right now.
/* no longer using
int DMFI_RunEmotes(object oTool, object oSpeaker, string sOriginal)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RunEmotes Start", GetFirstPC() ); }
	
	int nAnim=-1;
	string sSkill;
	int nChat = -1;
	object oHand;

	string sHeard = GetStringLowerCase(sOriginal);
	
	if (FindSubString(sHeard, EMT_ABL_STRENGTH) != -1)	{ sSkill = EMT_ABL_STRENGTH;}
	else if (FindSubString(sHeard, EMT_ABL_DEXTERITY) != -1)	{ sSkill = EMT_ABL_DEXTERITY;}
	else if (FindSubString(sHeard, EMT_ABL_CONSTITUTION) != -1)	{ sSkill = EMT_ABL_CONSTITUTION;}
	else if (FindSubString(sHeard, EMT_ABL_INTELLIGENCE) != -1)	{ sSkill = EMT_ABL_INTELLIGENCE;}
	else if (FindSubString(sHeard, EMT_ABL_WISDOM) != -1)		{ sSkill = EMT_ABL_WISDOM;}
	else if (FindSubString(sHeard, EMT_ABL_CHARISMA) != -1)	{ sSkill = EMT_ABL_CHARISMA;}

	else if (FindSubString(sHeard, EMT_SAVE_FORTITUDE) != -1)	{ sSkill = EMT_SAVE_FORTITUDE;}
	else if (FindSubString(sHeard, EMT_SAVE_REFLEX) != -1)		{ sSkill = EMT_SAVE_REFLEX;}
	else if (FindSubString(sHeard, EMT_SAVE_WILL) != -1)		{ sSkill = EMT_SAVE_WILL;}

	else if (FindSubString(sHeard, EMT_SKL_APPRAISE) != -1)	{ sSkill = EMT_SKL_APPRAISE ;}
	else if (FindSubString(sHeard, EMT_SKL_BLUFF) != -1)		{ sSkill = EMT_SKL_BLUFF;}
	else if (FindSubString(sHeard, EMT_SKL_CONCENTRATION) != -1)  { sSkill = EMT_SKL_CONCENTRATION;}
	else if (FindSubString(sHeard, EMT_SKL_CRAFT_ARMOR) != -1)	{ sSkill = EMT_SKL_CRAFT_ARMOR ;}
	else if (FindSubString(sHeard, EMT_SKL_CRAFT_TRAP) != -1)	{ sSkill = EMT_SKL_CRAFT_TRAP;}
	else if (FindSubString(sHeard, EMT_SKL_CRAFT_WEAPON) != -1)	{ sSkill = EMT_SKL_CRAFT_WEAPON;}
	else if (FindSubString(sHeard, EMT_SKL_DISABLE_TRAP) != -1)	{ sSkill = EMT_SKL_DISABLE_TRAP;}
	else if (FindSubString(sHeard, EMT_SKL_DISCIPLINE) != -1)	{ sSkill = EMT_SKL_DISCIPLINE;}
	else if (FindSubString(sHeard, EMT_SKL_HEAL) != -1)		{ sSkill = EMT_SKL_HEAL;}
	else if (FindSubString(sHeard, EMT_SKL_HIDE) != -1)		{ sSkill = EMT_SKL_HIDE;}
	else if (FindSubString(sHeard, EMT_SKL_INTIMIDATE) != -1)	{ sSkill = EMT_SKL_INTIMIDATE;}
	else if (FindSubString(sHeard, EMT_SKL_LISTEN) != -1)		{ sSkill = EMT_SKL_LISTEN;}
	else if (FindSubString(sHeard, EMT_SKL_LORE) != -1)		{ sSkill = EMT_SKL_LORE;}
	else if (FindSubString(sHeard, EMT_SKL_MOVE_SILENTLY) != -1)  { sSkill = EMT_SKL_MOVE_SILENTLY;}
	else if (FindSubString(sHeard, EMT_SKL_OPEN_LOCK) != -1)	{ sSkill = EMT_SKL_OPEN_LOCK;}
	else if (FindSubString(sHeard, EMT_SKL_PARRY) != -1)		{ sSkill = EMT_SKL_PARRY;}
	else if (FindSubString(sHeard, EMT_SKL_PERFORM) != -1)		{ sSkill = EMT_SKL_PERFORM;}
	else if (FindSubString(sHeard, EMT_SKL_SEARCH) != -1)		{ sSkill = EMT_SKL_SEARCH;}
	else if (FindSubString(sHeard, EMT_SKL_SET_TRAP) != -1)	{ sSkill = EMT_SKL_SET_TRAP;}
	else if (FindSubString(sHeard, EMT_SKL_SPELLCRAFT) != -1)	{ sSkill = EMT_SKL_SPELLCRAFT;}
	else if (FindSubString(sHeard, EMT_SKL_SPOT) != -1)		{ sSkill = EMT_SKL_SPOT;}
	else if (FindSubString(sHeard, EMT_SKL_TAUNT) != -1)		{ sSkill = EMT_SKL_TAUNT;}
	else if (FindSubString(sHeard, EMT_SKL_TUMBLE) != -1)		{ sSkill = EMT_SKL_TUMBLE;}
	else if (FindSubString(sHeard, EMT_SKL_USE_MAGIC_DEVICE) != -1) { sSkill = EMT_SKL_USE_MAGIC_DEVICE;}
	
	else if (FindSubString(sHeard, EMT_SKL_DIPLOMACY) != -1)	{ sSkill = EMT_SKL_DIPLOMACY;}
	else if (FindSubString(sHeard, EMT_SKL_SURVIVAL) != -1)	{ sSkill = EMT_SKL_SURVIVAL;}
	else if (FindSubString(sHeard, EMT_SKL_SLEIGHT_OF_HAND) != -1){ sSkill = EMT_SKL_SLEIGHT_OF_HAND;}
	else if (FindSubString(sHeard, EMT_SKL_CRAFT_ALCHEMY) != -1)  { sSkill = EMT_SKL_CRAFT_ALCHEMY;}
	
	if (sSkill!="")  DMFI_RollCheck(oSpeaker, sSkill, CSLGetIsDM(oSpeaker), oSpeaker, oTool);

	//*Animation Emotes*
	else if (FindSubString(sHeard, EMT_BOX)!=-1)
	{
		if ((FindSubString(sHeard, EMT_CARRY)!=-1) || (FindSubString(sHeard, EMT_MOVE)!=-1) ||(FindSubString(sHeard, EMT_LOAD)!=-1))
		{
			nAnim = ANIMATION_LOOPING_BOXCARRY;
		}
		else if ((FindSubString(sHeard, EMT_HURRY)!=-1) || (FindSubString(sHeard, EMT_HURRI)!=-1))
		{
			nAnim = ANIMATION_LOOPING_BOXHURRIED;
		}
		else
		{
			nAnim = ANIMATION_LOOPING_BOXIDLE;
		}
	}	
	else if (FindSubString(sHeard, EMT_GUITAR)!=-1)
	{
		if ((FindSubString(sHeard, EMT_PLAY)!=-1) || (FindSubString(sHeard, EMT_SING)!=-1) || (FindSubString(sHeard, EMT_SONG)!=-1))
			nAnim = ANIMATION_LOOPING_GUITARPLAY;
		else if ((FindSubString(sHeard, EMT_FIDGET)!=-1) || (FindSubString(sHeard, EMT_MESS)!=-1) || (FindSubString(sHeard, EMT_TINKER)!=-1))
			nAnim = ANIMATION_FIREFORGET_GUITARIDLEFIDGET;
		else
			nAnim = ANIMATION_LOOPING_GUITARIDLE;
	}
	else if (FindSubString(sHeard, EMT_FLUTE)!=-1)
	{
		if ((FindSubString(sHeard, EMT_PLAY)!=-1) || (FindSubString(sHeard, EMT_SING)!=-1) || (FindSubString(sHeard, EMT_SONG)!=-1))
			nAnim = ANIMATION_LOOPING_FLUTEPLAY;
		else if ((FindSubString(sHeard, EMT_FIDGET)!=-1) || (FindSubString(sHeard, EMT_MESS)!=-1) || (FindSubString(sHeard, EMT_TINKER)!=-1))
			nAnim = ANIMATION_FIREFORGET_FLUTEIDLEFIDGET;
		else
			nAnim = ANIMATION_LOOPING_FLUTEIDLE;
	}
	else if (FindSubString(sHeard, EMT_DRUM)!=-1)
	{
		if ((FindSubString(sHeard, EMT_PLAY)!=-1) || (FindSubString(sHeard, EMT_SING)!=-1) || (FindSubString(sHeard, EMT_SONG)!=-1))
			nAnim = ANIMATION_LOOPING_DRUMPLAY;
		else if ((FindSubString(sHeard, EMT_FIDGET)!=-1) || (FindSubString(sHeard, EMT_MESS)!=-1) || (FindSubString(sHeard, EMT_TINKER)!=-1))
			nAnim = ANIMATION_FIREFORGET_DRUMIDLEFIDGET;
		else
			nAnim = ANIMATION_LOOPING_DRUMIDLE;
	}
	else if (FindSubString(sHeard, EMT_KNEEL)!=-1)
	{
		if ((FindSubString(sHeard, EMT_FIDGET)!=-1) ||(FindSubString(sHeard, EMT_MESS)!=-1)||(FindSubString(sHeard, EMT_TINKER)!=-1))
			nAnim = ANIMATION_FIREFORGET_KNEELFIDGET;
		else if ((FindSubString(sHeard, EMT_TALK)!=-1)|| (FindSubString(sHeard, EMT_SPEAK)!=-1)|| (FindSubString(sHeard, EMT_TELLS)!=-1))
			nAnim = ANIMATION_FIREFORGET_KNEELTALK;
		else if ((FindSubString(sHeard, EMT_INJURE)!=-1)|| (FindSubString(sHeard, EMT_HURT)!=-1))
			nAnim = ANIMATION_FIREFORGET_KNEELDAMAGE;
		else if ((FindSubString(sHeard, EMT_DIE)!=-1)|| (FindSubString(sHeard, EMT_DEATH)!=-1))
			nAnim = ANIMATION_FIREFORGET_KNEELDEATH;
		else
			nAnim = ANIMATION_LOOPING_KNEELIDLE;
	}
	else if (FindSubString(sHeard, EMT_LOOK)!=-1)
	{
		if (FindSubString(sHeard, EMT_UP)!=-1)
			nAnim = ANIMATION_LOOPING_LOOKUP;
		else if (FindSubString(sHeard, EMT_DOWN)!=-1)
			nAnim = ANIMATION_LOOPING_LOOKDOWN;
		else if (FindSubString(sHeard, EMT_LEFT)!=-1)
			nAnim = ANIMATION_LOOPING_LOOKLEFT;
		else if (FindSubString(sHeard, EMT_RIGHT)!=-1)
			nAnim = ANIMATION_LOOPING_LOOKRIGHT;
		else if (FindSubString(sHeard, EMT_FAR)!=-1)
			nAnim = ANIMATION_LOOPING_LOOK_FAR;	
	}
	else if (FindSubString(sHeard, EMT_LAY)!=-1)
	{
		if ((FindSubString(sHeard, EMT_DOWN)!=-1) || (FindSubString(sHeard, EMT_BACK)!=-1))
			nAnim = ANIMATION_FIREFORGET_LAYDOWN;
	}
	else if (FindSubString(sHeard, EMT_FALL)!= -1)
	{
		if (FindSubString(sHeard, EMT_BACK)!= -1)
			nAnim = ANIMATION_LOOPING_DEAD_BACK;
		else if (FindSubString(sHeard, EMT_FORWARD)!=-1)
			nAnim =	ANIMATION_LOOPING_DEAD_FRONT;
	}		
			
	else if (FindSubString(sHeard, EMT_BOW) != -1 || FindSubString(sHeard, EMT_CURTSEY) != -1)
		nAnim = ANIMATION_FIREFORGET_BOW;
	else if (FindSubString(sHeard, EMT_DRINK) != -1 || FindSubString(sHeard, EMT_SIP) != -1)
		nAnim = ANIMATION_FIREFORGET_DRINK;
	else if (FindSubString(sHeard, EMT_YAWN)!= -1 ||  FindSubString(sHeard, EMT_STRETCH) != -1 || FindSubString(sHeard, EMT_BORED) != -1 || FindSubString(sHeard, EMT_LETS_GO) !=-1)
	{
		nAnim = ANIMATION_FIREFORGET_PAUSE_BORED;
		nChat = VOICE_CHAT_BORED;
	}	
	else if (FindSubString(sHeard, EMT_SCRATCH)!= -1)
		nAnim = ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;
	else if (FindSubString(sHeard, EMT_READ)!= -1 || FindSubString(sHeard, EMT_BOOK)!=-1 || FindSubString(sHeard, EMT_PAPER)!=-1)
		nAnim = ANIMATION_FIREFORGET_READ;
	else if (FindSubString(sHeard, EMT_SALUTE)!= -1)
		nAnim = ANIMATION_FIREFORGET_SALUTE;
	else if (FindSubString(sHeard, EMT_STEAL)!= -1 || FindSubString(sHeard, EMT_SWIPE) != -1)
		nAnim = ANIMATION_FIREFORGET_STEAL;
	else if (FindSubString(sHeard, EMT_MOCK) != -1)
	{
		nAnim = ANIMATION_FIREFORGET_TAUNT;
		nChat = VOICE_CHAT_TAUNT;
	}	
	else if ((FindSubString(sHeard, EMT_CHEER)!= -1) || (FindSubString(sHeard, EMT_HOORAY)!= -1) || (FindSubString(sHeard, EMT_CELEBRATE)!= -1))
	{
		nAnim = ANIMATION_FIREFORGET_VICTORY1;
		nChat = VOICE_CHAT_CHEER;
	}	
	else if (FindSubString(sHeard, EMT_FLOP)!= -1)
		nAnim = ANIMATION_LOOPING_DEAD_FRONT;
	else if (FindSubString(sHeard, EMT_BEND)!= -1 || FindSubString(sHeard, EMT_STOOP)!= -1)
		nAnim = ANIMATION_LOOPING_GET_LOW;
	else if (FindSubString(sHeard, EMT_FIDDLE)!= -1)
		nAnim = ANIMATION_LOOPING_GET_MID;
	else if (FindSubString(sHeard, EMT_NOD)!= -1 || FindSubString(sHeard, EMT_AGREE)!= -1)
		nAnim = ANIMATION_LOOPING_LISTEN;
	else if (FindSubString(sHeard, EMT_PEER)!= -1 || FindSubString(sHeard, EMT_SCAN)!= -1)
		nAnim = ANIMATION_LOOPING_LOOK_FAR;
	else if (FindSubString(sHeard, EMT_PRAY)!= -1 || FindSubString(sHeard, EMT_MEDITATE)!= -1)
		nAnim = ANIMATION_LOOPING_MEDITATE;
	else if (FindSubString(sHeard, EMT_DRUNK)!= -1 || FindSubString(sHeard, EMT_WOOZY)!= -1 || FindSubString(sHeard, EMT_SWAY)!= -1)
		nAnim = ANIMATION_LOOPING_PAUSE_DRUNK;
	else if (FindSubString(sHeard, EMT_TIRED)!= -1 || FindSubString(sHeard, EMT_FATIGUE)!= -1 || FindSubString(sHeard, EMT_EXHAUSTED)!= -1 || FindSubString(sHeard, EMT_REST)!=-1)
	{
		nAnim = ANIMATION_LOOPING_PAUSE_TIRED;
		nChat = VOICE_CHAT_REST;
	}	
	else if (FindSubString(sHeard, EMT_DEMAND)!= -1 || FindSubString(sHeard, EMT_THREATEN)!= -1)
	{
		nAnim = ANIMATION_LOOPING_TALK_FORCEFUL;
		nChat = VOICE_CHAT_THREATEN;
	}
	else if (FindSubString(sHeard, EMT_LAUGH)!= -1 || FindSubString(sHeard, EMT_HAHA)!= -1 || FindSubString(sHeard, EMT_LOL)!= -1)
	{
		nAnim = ANIMATION_LOOPING_TALK_LAUGHING;
		nChat = VOICE_CHAT_LAUGH;
	}	
	else if (FindSubString(sHeard, EMT_BEG)!= -1 || FindSubString(sHeard, EMT_PLEAD)!= -1)
		nAnim = ANIMATION_LOOPING_TALK_PLEADING;
	else if (FindSubString(sHeard, EMT_WORSHIP)!= -1)
		nAnim = ANIMATION_LOOPING_MEDITATE;
	else if (FindSubString(sHeard, EMT_TALK)!= -1 || FindSubString(sHeard, EMT_CHATS)!= -1 || FindSubString(sHeard, EMT_SPEAK)!=-1 || FindSubString(sHeard, EMT_STORY)!=-1)
		nAnim = ANIMATION_LOOPING_TALK_NORMAL;
	else if (FindSubString(sHeard, EMT_DUCK)!= -1)
		nAnim = ANIMATION_FIREFORGET_DODGE_DUCK;
	else if (FindSubString(sHeard, EMT_DODGE)!= -1)
		nAnim = ANIMATION_FIREFORGET_DODGE_SIDE;
	else if (FindSubString(sHeard, EMT_CANTRIP)!= -1)
		nAnim = ANIMATION_LOOPING_CONJURE1;
	else if (FindSubString(sHeard, EMT_CAST)!= -1)
		nAnim = ANIMATION_LOOPING_CONJURE2;
	else if (FindSubString(sHeard, EMT_COLLAPSE)!=-1  || FindSubString(sHeard, EMT_TRIPS)!=-1)
		nAnim = ANIMATION_LOOPING_DEAD_FRONT;
	else if (FindSubString(sHeard, EMT_SPASM)!= -1)
		nAnim = ANIMATION_LOOPING_SPASM;
	else if (FindSubString(sHeard, EMT_STAND)!=-1)
		nAnim = ANIMATION_FIREFORGET_STANDUP;
	else if (FindSubString(sHeard, EMT_GREET)!= -1 || FindSubString(sHeard, EMT_WAVE) != -1 || FindSubString(sHeard, EMT_HELLO)!= -1 || FindSubString(sHeard, EMT_HI) != -1)
	{
		nAnim = ANIMATION_FIREFORGET_GREETING;
		nChat = VOICE_CHAT_HELLO;
	}	
	else if (FindSubString(sHeard, EMT_PRONE)!=-1)
		nAnim = ANIMATION_LOOPING_PRONE;
	else if (FindSubString(sHeard, EMT_DANCE)!=-1)
		nAnim = ANIMATION_LOOPING_DANCE01;
	else if (FindSubString(sHeard, EMT_BOOGIE)!=-1)
		nAnim = ANIMATION_LOOPING_DANCE02;
	else if (FindSubString(sHeard, EMT_FROLIC)!=-1)
		nAnim = ANIMATION_LOOPING_DANCE03;
	else if (FindSubString(sHeard, EMT_COOK)!=-1)
		nAnim = ANIMATION_LOOPING_COOK01;
	else if (FindSubString(sHeard, EMT_MEAL)!=-1)
		nAnim = ANIMATION_LOOPING_COOK02;
	else if (FindSubString(sHeard, EMT_CRAFT)!=-1)
		nAnim = ANIMATION_LOOPING_CRAFT01;
	else if (FindSubString(sHeard, EMT_FORGE)!=-1)
		nAnim = ANIMATION_LOOPING_FORGE01;
	else if (FindSubString(sHeard, EMT_SHOVEL)!=-1)
		nAnim = ANIMATION_LOOPING_SHOVELING;
	else if (FindSubString(sHeard, EMT_INJURE)!= -1 || FindSubString(sHeard, EMT_LIMP) != -1 || FindSubString(sHeard, EMT_HURT)!= -1)
		nAnim = ANIMATION_LOOPING_INJURED;
	else if (FindSubString(sHeard, EMT_COLLAPSE)!=-1)
		nAnim = ANIMATION_FIREFORGET_COLLAPSE;
	else if (FindSubString(sHeard, EMT_ACTIVATE)!=-1)
		nAnim = ANIMATION_FIREFORGET_ACTIVATE;
	else if (FindSubString(sHeard, EMT_USE)!=-1)
		nAnim = ANIMATION_FIREFORGET_USEITEM;
	else if (FindSubString(sHeard, EMT_BARD)!=-1)
		nAnim = ANIMATION_FIREFORGET_BARDSONG;
	else if (FindSubString(sHeard, EMT_WILDSHAPE)!=-1)
		nAnim = ANIMATION_FIREFORGET_WILDSHAPE;
	else if (FindSubString(sHeard, EMT_SEARCH)!=-1)
		nAnim = ANIMATION_FIREFORGET_SEARCH;
	else if (FindSubString(sHeard, EMT_INTIMIDATE)!=-1)
		nAnim = ANIMATION_FIREFORGET_INTIMIDATE;
	else if ((FindSubString(sHeard, EMT_CHUCKLE)!=-1) || (FindSubString(sHeard, EMT_GIGGLE)!= -1))
		nAnim = ANIMATION_FIREFORGET_CHUCKLE;
			
		if (FindSubString(sHeard, EMT_ATTACK)!=-1)	nChat = VOICE_CHAT_ATTACK;
		else if (FindSubString(sHeard, EMT_BATTLECRY)!=-1)	
		{
			int n = d3();
			if (n==1)
				nChat = VOICE_CHAT_BATTLECRY1;
			else if (n==2)
				nChat = VOICE_CHAT_BATTLECRY2;
			else
				nChat = VOICE_CHAT_BATTLECRY3;
		}
		else if (FindSubString(sHeard, EMT_PAIN)!=-1)	
		{
			int n = d3();
			if (n==1)
			{
				nChat = VOICE_CHAT_PAIN1;
			}
			else if (n==2)
			{
				nChat = VOICE_CHAT_PAIN2;
			}
			else
			{
				nChat = VOICE_CHAT_PAIN3;
			}
		}
		else if ((FindSubString(sHeard, EMT_HEAL)!=-1) && (FindSubString(sHeard, EMT_ME)!=-1))	nChat = VOICE_CHAT_HEALME;
		else if (FindSubString(sHeard, EMT_HELP)!=-1)	nChat = VOICE_CHAT_HELP;						
		else if (FindSubString(sHeard, EMT_ENEMIES)!=-1)	nChat = VOICE_CHAT_ENEMIES;
		else if (FindSubString(sHeard, EMT_FLEE)!=-1)	nChat = VOICE_CHAT_FLEE;
		else if (FindSubString(sHeard, EMT_GUARDME)!=-1)	nChat = VOICE_CHAT_GUARDME;	
		else if (FindSubString(sHeard, EMT_HOLD)!=-1)	nChat = VOICE_CHAT_HOLD;		
		else if ((FindSubString(sHeard, EMT_NEAR)!=-1) && (FindSubString(sHeard, EMT_DEATH)!=-1))	nChat = VOICE_CHAT_NEARDEATH;	
		else if (FindSubString(sHeard, EMT_POISONED)!=-1)	nChat = VOICE_CHAT_POISONED;	
		else if (FindSubString(sHeard, EMT_SPELL_FAIL)!=-1)	nChat = VOICE_CHAT_SPELLFAILED;
		else if (FindSubString(sHeard, EMT_WEAPON_SUCKS)!=-1)	nChat = VOICE_CHAT_WEAPONSUCKS;
		else if (FindSubString(sHeard, EMT_FOLLOW_ME)!=-1)	nChat = VOICE_CHAT_FOLLOWME;
		else if ((FindSubString(sHeard, EMT_LOOK)!=-1) && (FindSubString(sHeard, EMT_HERE)!=-1))	nChat = VOICE_CHAT_LOOKHERE;			
		else if (FindSubString(sHeard, EMT_GROUP)!=-1)	nChat = VOICE_CHAT_GROUP;
		else if (FindSubString(sHeard, EMT_MOVE_OVER)!=-1)	nChat = VOICE_CHAT_MOVEOVER;						
		else if (FindSubString(sHeard, EMT_CANDO)!=-1)	nChat = VOICE_CHAT_CANDO;
		else if (FindSubString(sHeard, EMT_CANTDO)!=-1)	nChat = VOICE_CHAT_CANTDO;
		else if (FindSubString(sHeard, EMT_TASKCOMPLETE)!=-1)	nChat = VOICE_CHAT_TASKCOMPLETE;	
		else if (FindSubString(sHeard, EMT_ENCUMBERED)!=-1)	nChat = VOICE_CHAT_ENCUMBERED;		
		else if (FindSubString(sHeard, EMT_SELECTED)!=-1)	nChat = VOICE_CHAT_SELECTED;	
		else if (FindSubString(sHeard, EMT_NO)!=-1)	nChat = VOICE_CHAT_NO;	
		else if (FindSubString(sHeard, EMT_STOP)!=-1)	nChat = VOICE_CHAT_STOP;
		else if (FindSubString(sHeard, EMT_GOODBYE)!=-1)	nChat = VOICE_CHAT_GOODBYE;
		else if (FindSubString(sHeard, EMT_THANKS)!=-1)	nChat = VOICE_CHAT_THANKS;
		else if (FindSubString(sHeard, EMT_CUSS)!=-1)	nChat = VOICE_CHAT_CUSS;	
		else if (FindSubString(sHeard, EMT_TALKTOME)!=-1)	nChat = VOICE_CHAT_TALKTOME;
		else if (FindSubString(sHeard, EMT_GOODIDEA)!=-1)	nChat = VOICE_CHAT_GOODIDEA;
		else if (FindSubString(sHeard, EMT_BADIDEA)!=-1)	nChat = VOICE_CHAT_BADIDEA;	
		else if (FindSubString(sHeard, EMT_PICK_LOCK)!=-1)	nChat = VOICE_CHAT_PICKLOCK;	
		else if (FindSubString(sHeard, EMT_CHECK_AREA)!=-1)	nChat = VOICE_CHAT_SEARCH;
		else if (FindSubString(sHeard, EMT_YES)!=-1)	nChat = VOICE_CHAT_YES;	
		else if (FindSubString(sHeard, EMT_PICK_LOCK)!=-1)	nChat = VOICE_CHAT_PICKLOCK;	
		else if (FindSubString(sHeard, EMT_COVER)!=-1)	nChat = VOICE_CHAT_HIDE;	

	if (nAnim!=-1)
	{
		AssignCommand(oSpeaker, ClearAllActions());
	}

	if (nAnim >99)
	{
		AssignCommand(oSpeaker, ActionPlayAnimation(nAnim, 0.1));
	}
	else
	{
		AssignCommand(oSpeaker, ActionPlayAnimation(nAnim, 0.1, 300.));
	}
		
	if (nChat!=-1)
	{
		DelayCommand(0.2, AssignCommand(oSpeaker, PlayVoiceChat(nChat)));
	}
	
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RunEmotes End", GetFirstPC() ); }
	return TRUE;
}
*/





void DMFI_RenameObject(object oPC, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RenameObject Start", oPC ); }
	
	object oItemHolder;
	string sFirstName;
	string sLastName;	
	
	if ((!DMFI_PLAYER_NAME_CHANGING) && (GetIsPC(oTarget)))
	{
		SendMessageToPC(oPC, "PC name changing is disabled.");
		return;
	}	
		
	if (!CSLGetIsDM(oPC))		
	{			
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if ((oTarget==oPC) || (GetMaster(oTarget)==oPC))
			{
				sFirstName = GetName(oTarget);
				sLastName ="";
				DisplayGuiScreen(oPC, SCREEN_DMFI_CHGNAME, FALSE, "dmfichgname.xml");
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtFirstName", -1, sFirstName);
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtLastName", -1, sLastName);
			}
			else
			{
				SendMessageToPC(oPC, "You can only rename yourself, your associates, or possessed inventory items.");
			}
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)	
		{
			oItemHolder = GetItemPossessor(oTarget);
			if ((oItemHolder==oPC) || (GetMaster(oItemHolder)==oPC))
			{
				sFirstName = GetName(oTarget);
				DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE, "dmfichgitem.xml");
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
			}
			else
			{
				SendMessageToPC(oPC, "You can only rename yourself, your associates, or possessed inventory items.");
			}
		}
	}
	else
	{		
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			sFirstName = GetName(oTarget);
			sLastName = "";
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGNAME, FALSE, "dmfichgname.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtFirstName", -1, sFirstName);
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtLastName", -1, sLastName);
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)	
		{
			sFirstName = GetName(oTarget);
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE , "dmfichgitem.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE)
		{
			sFirstName = GetName(oTarget);
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE, "dmfichgitem.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
		}	
	}		
}
