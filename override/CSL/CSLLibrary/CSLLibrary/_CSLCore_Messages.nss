/** @file
* @brief Messaging and communication, and debugging related functions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////

/*
if (DEBUGGING >= 6) { CSLDebug("Creating Banners for NW" ); }
SendMessageToPC( oCaster, sMsg);
SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
CSLPlayerMessageSplit( sMsg, oChar1, oChar2);
*/


/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
const int SCMESSAGE_NONE = 0;
const int SCMESSAGE_FIRSTPC = 1; // this is good for single player
const int SCMESSAGE_MEMORYLOG = 2;
const int SCMESSAGE_LOGFILE = 3;
const int SCMESSAGE_MAINTESTER = 4; // assumes PC is set when this is run
const int SCMESSAGE_SHOUTER = 5; // shouter is set when this is run
const int SCMESSAGE_BROADCAST = 6;
const int SCMESSAGE_AREA = 7;
const int SCMESSAGE_SOURCE = 8; //  does both caster and target only, or a speak string if none

const int COLOR_NONE = -1;

const int CSL_POST_COLOR_RED 			= 4294901760; 	// FFFF0000
const int CSL_POST_COLOR_GREEN 			= 4278255360; 	// FF00FF00
const int CSL_POST_COLOR_BLUE 			= 4278190335; 	// FF0000FF
const int CSL_POST_COLOR_WHITE 			= 4294967295; 	// FFFFFFFF
const int CSL_POST_COLOR_BLACK 			= 4278190080; 	// FF000000
const int CSL_POST_COLOR_OFFSET 		= 4278190080; 	// FF000000

const int CSL_LINE_SIZE				= 13;
const int CSL_PRETTY_LINE_WRAP		= 42;
const int CSL_PRETTY_X_OFFSET		= 13;
const int CSL_PRETTY_Y_OFFSET		= 13;
const float CSL_PRETTY_DURATION		= 13.0f;
string CSL_PRETTY_LINE_COUNT_VAR 	= "00_nPrettyLineCount";

//const string LIST_PREFIX = "pgList:";


//int DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );


const string CSLTARGET_KEY		 	= "$";
const string CSLTARGET_OBJECT_SELF	= "$OBJECT_SELF";	// OBJECT_SELF
const string CSLTARGET_OWNER 	 	= "$OWNER";			// OBJECT_SELF (conversation owner)
const string CSLTARGET_OWNED_CHAR	= "$OWNED_CHAR";	// GetOwnedCharacter
const string CSLTARGET_PC	 	 	= "$PC";			// PCSpeaker
const string CSLTARGET_PC_LEADER	= "$PC_LEADER"; 	// FactionLeader (of first PC)
const string CSLTARGET_PC_NEAREST	= "$PC_NEAREST";	// NearestPC (owned and alive)
const string CSLTARGET_PC_SPEAKER	= "$PC_SPEAKER";	// PCSpeaker

const string CSLTARGET_MODULE	 	= "$MODULE";
const string CSLTARGET_LAST_SPEAKER = "$LASTSPEAKER";

const string CSLPARAM_COMMONER	=  "$COMMONER";
const string CSLPARAM_DEFENDER	=  "$DEFENDER";
const string CSLPARAM_HOSTILE	=  "$HOSTILE";
const string CSLPARAM_MERCHANT	=  "$MERCHANT";


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
#include "_CSLCore_Config"
//#include "_SCInclude_Chat_c" // only needed for chat system integration 
#include "_CSLCore_Objects"
//#include "_SCUtilityConstants"
#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_ObjectArray"
//#include "_CSLCore_DMFIEnglish"


// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


// GetNearestPC()
/*	Find nearest player object from oTarget.

	Parameters:
		object oTarget      = Begin search from location of oTarget
		int bOwnedCharacter = If TRUE, find nearest PC, else, find nearest creature controlled by a player
		int bIsAlive        = If TRUE, ignore dead, else, ignore alive creatures
		int nNth			= Return nNth match (Default = first)

	Remark:
		CREATURE_TYPE_IS_ALIVE currently matches exclusive dead or alive (Dead xor Alive?).
*/



// Brent 5/16/01
// BMA-OEI 1/23/06
object CSLGetNearestPC(object oTarget=OBJECT_SELF, int bOwnedCharacter=TRUE, int bIsAlive=TRUE, int nNth=1)
{
	int nPCValue = PLAYER_CHAR_IS_CONTROLLED;
	int nIsAliveValue = CREATURE_ALIVE_FALSE;

	if (bOwnedCharacter == TRUE)
	{
		nPCValue = PLAYER_CHAR_IS_PC;
	}
	
	if ( bIsAlive == TRUE )
	{
		nIsAliveValue = CREATURE_ALIVE_TRUE;
	}
	
	return GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, nPCValue, oTarget, nNth, CREATURE_TYPE_IS_ALIVE, nIsAliveValue );
}


// type is as follows
/*
	int CREATURE_TYPE_RACIAL_TYPE     = 0;
int CREATURE_TYPE_PLAYER_CHAR     = 1;
int CREATURE_TYPE_CLASS           = 2;
int CREATURE_TYPE_REPUTATION      = 3;
int CREATURE_TYPE_IS_ALIVE        = 4;
int CREATURE_TYPE_HAS_SPELL_EFFECT = 5;
int CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT = 6;
int CREATURE_TYPE_PERCEPTION                = 7;
int CREATURE_TYPE_SCRIPTHIDDEN    = 8;//RWT-OEI 03/04/06
*/

/// object GetNearestCreature(int nFirstCriteriaType, int nFirstCriteriaValue, object oTarget=OBJECT_SELF, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1, int nThirdCriteriaValue=-1 );

/**
* Return Target by tag or special identifier
* Leave sTarget blank to use sDefault override
* @author
* @param 
* @see 
* @return 
*/
object CSLGetTarget(string sTarget, string sDefault=CSLTARGET_OWNER)
{
	object oTarget = OBJECT_INVALID;
	
	// If sTarget is blank, use sDefault
	if ("" == sTarget || "0" == sTarget) sTarget = sDefault;
	
	// Check if sTarget is a special identifier
	if ( GetStringLeft(sTarget, 1) == CSLTARGET_KEY )
	{
		string sIdentifier = sTarget;
		sIdentifier = GetStringUpperCase(sIdentifier);
		
		if (CSLTARGET_OWNER == sIdentifier) 			oTarget = OBJECT_SELF;
		else if (CSLTARGET_OBJECT_SELF == sIdentifier)	oTarget = OBJECT_SELF;
		else if (CSLTARGET_OWNED_CHAR == sIdentifier)	oTarget = GetOwnedCharacter(OBJECT_SELF);
		else if (CSLTARGET_PC == sIdentifier)			oTarget = GetPCSpeaker();
		else if (CSLTARGET_PC_LEADER == sIdentifier)	oTarget = GetFactionLeader(GetFirstPC());
		else if (CSLTARGET_PC_NEAREST == sIdentifier)	oTarget = CSLGetNearestPC();
		else if (CSLTARGET_PC_SPEAKER == sIdentifier)	oTarget = GetPCSpeaker();
		else if (CSLTARGET_MODULE == sIdentifier)		oTarget = GetModule();
		else if (CSLTARGET_LAST_SPEAKER == sIdentifier) oTarget = GetLastSpeaker();
		else
		{
			//PrettyError("GetTarget() -- " + sIdentifier + " not recognized as special identifier!");
		}
	}
	else
	{
		oTarget = GetNearestObjectByTag(sTarget);	// Search area
		

		//EPF 4/13/06 -- get nearest misses if the owner is the object we're looking for
		//	so check and see if the target is OBJECT_SELF.  I'm putting this after the GetNearest()
		// call since string compares are expensive, but before the GetObjectByTag() call, since
		// that's liable to return the wrong instance.  We can move this to before the GetNearest() call
		// if this becomes a problem.
		if(!GetIsObjectValid(oTarget))	
		{								
			if(sTarget == GetTag(OBJECT_SELF))
			{
				oTarget = OBJECT_SELF;
			}	
		}
		// If not found
		if (GetIsObjectValid(oTarget) == FALSE) 
		{	
			oTarget = GetObjectByTag(sTarget);		// Search module
		}
	}

	// If not found
	//if (GetIsObjectValid(oTarget) == FALSE)
	//{
	//	//PrettyDebug("GetTarget() -- Could not find target with tag: " + sTarget);
	//}
	
	return (oTarget);
}


// BMA 5/5/05 ginc_companions updated with GetCompInfluenceGlobVar()
// get the influence variable name of specified target
//string GetInfluenceVarName(string sTarget)
//{
//	string sVarName;
//    object oTarg = GetTarget(sTarget, CSLTARGET_OBJECT_SELF);
//	
//	if (GetIsObjectValid(oTarg))
//		sVarName = GetTag(oTarg);
//	else
//		sVarName = sTarget;
//		
//	sVarName = sVarName + "_Influence";		
//	return (sVarName);
//}





// return the duration type
// not case sensitive
// 	I = INSTANT
//  P = PERMANENT
//  T = TEMPORARY
int CSLGetDurationType(string sType)
{
    sType = GetStringUpperCase(sType);
    int iType = DURATION_TYPE_INSTANT;

    if (FindSubString(sType, "P"))
        iType = DURATION_TYPE_PERMANENT;

    if (FindSubString(sType, "T"))
        iType = DURATION_TYPE_TEMPORARY;

	return (iType);
}


// returns the standard faction or -1 if not found
int CSLGetStandardFaction(string sFactionName)
{
	int iFaction = -1;
	if ( GetStringLeft(sFactionName, 1) == CSLTARGET_KEY) 
	{	
		string sTargetFaction = GetStringUpperCase(sFactionName);
	
		if (sTargetFaction == CSLPARAM_COMMONER)
			iFaction = STANDARD_FACTION_COMMONER;
		else if (sTargetFaction == CSLPARAM_DEFENDER)
			iFaction = STANDARD_FACTION_DEFENDER;
		else if (sTargetFaction == CSLPARAM_HOSTILE)
			iFaction = STANDARD_FACTION_HOSTILE;
		else if (sTargetFaction == CSLPARAM_MERCHANT)
			iFaction = STANDARD_FACTION_MERCHANT;
		
	}
	return (iFaction);
}


// returns a sound object
object CSLGetSoundObjectByTag(string sTarget)
{
	object oTarget = CSLGetTarget(sTarget);

	if (GetIsObjectValid(oTarget) == FALSE)
	{
		//ErrorMessage("GetSoundObjetByTag: " + sTarget + " not found!");
	}
	else 
	{	
		int iType = GetObjectType(oTarget);
		if (iType != OBJECT_TYPE_ALL) // sound object don't have their own special type...
		{
			//ErrorMessage("GetSoundObjetByTag: " + sTarget + " is wrong type: " + IntToString(iType) + " - attempting to use anyway.");
		}
	}
	return oTarget;
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLAssignMainTester( object oChar )
{ // bState is TRUE or FALSE
	SetLocalObject( GetModule(), "TESTER", oChar );
	SetLocalInt( oChar, "DEBUGGER", TRUE );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
object CSLGetMainTester( )
{ // bState is TRUE or FALSE
	return GetLocalObject( GetModule(), "TESTER" );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSendMessageToMainTester(string sMsg)
{
	object oTester = GetLocalObject( GetModule(), "TESTER" );
	if ( GetIsObjectValid( oTester ) )
	{
		SendMessageToPC( oTester, sMsg);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLAssignMainShouter( object oChar )
{ 
	SetLocalObject( GetModule(), "SHOUTER", oChar );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
object CSLGetShouter( )
{
	return GetLocalObject( GetModule(), "SHOUTER" );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLShoutMsg(string sMsg)
{
	object oShouter = GetLocalObject( GetModule(), "SHOUTER" );
	if ( GetIsObjectValid( oShouter ) )
	{
		//SendMessageToPC( GetFirstPC(), "Sending Shout");	
		// AssignCommand(oShouter, SpeakString(sMsg, TALKVOLUME_SHOUT));
		SendChatMessage( oShouter, OBJECT_INVALID, CHAT_MODE_SHOUT, sMsg, FALSE);
	}
	else
	{
		object oPC = GetFirstPC();
		while ( GetIsObjectValid(oPC) )
		{
			SendMessageToPC( oPC, "<color=yellow><b>"+sMsg+"</b></color>");			
			oPC = GetNextPC();
		}
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Append a Message in CSLMyDebug Log, send out later ( idea by Nytir )
void CSLMemoryLog( string sMsg )
{
	CSLAppendLocalString( GetModule(), "SC_MEMORYLOG", sMsg);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Send out the CSLMyDebug Message stored in CSLMyDebug Log
string CSLMemoryLogFlush()
{
	string sLog = GetLocalString(GetModule(), "SC_MEMORYLOG");
	DeleteLocalString(GetModule(), "SC_MEMORYLOG");
	return sLog;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetAsTester( object oTester, int bState = TRUE )
{
	SetLocalInt( oTester, "DEBUGGER", bState );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetDebuggingLevel( int iDebugLevel)
{ // 1-9, 1 being normal messages, higher being more and more detail in debugging, boosted up to higher numbers

	SetLocalInt( GetModule(), "DEBUGLEVEL", CSLGetWithinRange( iDebugLevel, 0, 20) );
}


int CSLGetDebuggingLevel()
{ // 1-9, 1 being normal messages, higher being more and more detail in debugging

	return GetLocalInt( GetModule(), "DEBUGLEVEL" );
}


void CSLSetDebugMethod( string sDebugMethod )
{ // 1-9, 1 being normal messages, higher being more and more detail in debugging, boosted up to higher numbers
	sDebugMethod = GetStringUpperCase( sDebugMethod );
	int iDebugMethod = -1;
	
	if ( sDebugMethod == "FIRSTPC" ) { iDebugMethod = SCMESSAGE_FIRSTPC; }
	else if ( sDebugMethod == "MEMORY" ) { iDebugMethod = SCMESSAGE_MEMORYLOG; }
	else if ( sDebugMethod == "LOG" ) { iDebugMethod = SCMESSAGE_LOGFILE; }
	else if ( sDebugMethod == "MAINTESTER" ) { iDebugMethod = SCMESSAGE_MAINTESTER; }
	else if ( sDebugMethod == "SHOUTER" ) { iDebugMethod = SCMESSAGE_SHOUTER; } 
	else if ( sDebugMethod == "BROADCAST" ) { iDebugMethod = SCMESSAGE_BROADCAST; }
	else if ( sDebugMethod == "AREA" ) { iDebugMethod = SCMESSAGE_AREA; }
	else if ( sDebugMethod == "SOURCE" ) { iDebugMethod = SCMESSAGE_SOURCE; }
	else if ( sDebugMethod == "NONE" ) { iDebugMethod = SCMESSAGE_NONE; }
	
	if ( iDebugMethod != -1 )
	{
		SetLocalInt( GetModule(), "SC_DEBUGGING_METHOD", iDebugMethod );
	}
}


string CSLGetDebugMethod()
{ // 1-9, 1 being normal messages, higher being more and more detail in debugging

	int iDebugMethod = GetLocalInt( GetModule(), "SC_DEBUGGING_METHOD" );
	string sDebugMethod = "";
	
	if ( iDebugMethod == SCMESSAGE_FIRSTPC  ) { sDebugMethod = "FirstPC"; }
	else if ( iDebugMethod == SCMESSAGE_MEMORYLOG  ) { sDebugMethod = "Memory"; }
	else if ( iDebugMethod == SCMESSAGE_LOGFILE  ) { sDebugMethod = "Log"; }
	else if ( iDebugMethod == SCMESSAGE_MAINTESTER  ) { sDebugMethod = "MainTester"; }
	else if ( iDebugMethod == SCMESSAGE_SHOUTER  ) { sDebugMethod = "Shouter"; } 
	else if ( iDebugMethod == SCMESSAGE_BROADCAST  ) { sDebugMethod = "Broadcast"; }
	else if ( iDebugMethod == SCMESSAGE_AREA  ) { sDebugMethod = "Area"; }
	else if ( iDebugMethod == SCMESSAGE_SOURCE ) { sDebugMethod = "Source"; }
	return sDebugMethod;
}

void CSLSetDebugToTestersOnly( int bTesting = TRUE )
{
	if ( bTesting ) //forces it to be valide
	{
		SetLocalInt( GetModule(), "SC_DEBUGGING_TESTERSONLY", 1 );
	}
	else
	{
		DeleteLocalInt( GetModule(), "SC_DEBUGGING_TESTERSONLY" ); // just get rid of the vars overhead
	}
}

int CSLGetDebugToTestersOnly()
{
	if ( GetLocalInt( GetModule(), "SC_DEBUGGING_TESTERSONLY") )
	{
		return TRUE;
	}
	return FALSE;
}


//	int bLimitToThoseSetAsTesters = GetLocalInt( GetModule(), "SC_DEBUGGING_TESTERSONLY" );

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMsgBox(object oPC, string sMessage, string sOkString="Ok", string sCancelString="")
{
	SendMessageToPC(oPC, sMessage);
	DisplayMessageBox(oPC, 0, sMessage, "", "", (sCancelString==""), "SCREEN_MESSAGEBOX_DEFAULT", 0, sOkString, 0, sCancelString);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLInfoBox( object oChar, string sTitle, string sName, string sMessage )
{
	DisplayGuiScreen(oChar, "SCREEN_INFOBOX", FALSE, "CSLinfoscreen.xml");
	
	SetGUIObjectText( oChar, "SCREEN_INFOBOX", "INFOBOX_SCREEN_NAME", 1, sTitle );
	SetGUIObjectText( oChar, "SCREEN_INFOBOX", "INFOBOX_NAME_TEXT", 1, sName );
	SetGUIObjectText( oChar, "SCREEN_INFOBOX", "INFOBOX_DESCRIPTION_TEXT", 1, sMessage );	
}

// * These debugging tools are from Nytir, seem very nice.
// Get CSLMyDebug Mode
const string MDB  = "MYDEBUGMODE";
const string MDBL = "MYDEBUGLOG";




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// CSLGetMyDebugMode -> SCGetDebugMode
int CSLGetMyDebugMode()
{
	return GetLocalInt(GetModule(), MDB);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Set CSLMyDebug Mode
void CSLMyDebugMode(int iOn=TRUE)
{
	SetLocalInt(GetModule(), MDB, iOn);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Sends a CSLMyDebug Message
// sMsg : Message
// sSbj : subject of the message
void CSLMyDebug(string sMsg, string sSbj="Debug")
{
	if( !GetLocalInt(GetModule(), MDB) ){ return; }
	
	if( sSbj != "" )
	{
		SendMessageToPC(GetFirstPC(FALSE), "["+ sSbj +"] "+ sMsg);
	}
	else
	{
		SendMessageToPC(GetFirstPC(FALSE), sMsg);
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Print a seperator line
void CSLMyDebugSeperator()
{
	CSLMyDebug("----------------------------------------", "");
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// ******************************* FUNCTIONS ***********************************
// These are duplicate functions which need to be merged/cleaned up to fit with the larger system
void CSLMessage_SendText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bFaction=FALSE)
{   //Purpose: Send text to a pc or faction in color quickly
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 10/12/6
	object oFaction;
	if (nColor!=-1)	sText = CSLColorText(sText, nColor);
	
	if (bFloat)
		FloatingTextStringOnCreature(sText, oPC, bFaction, 3.0);
	else
	{
		if (bFaction)
		{
				oFaction = GetFirstFactionMember(oPC, TRUE);
				while (GetIsObjectValid(oFaction))
				{
					if ((GetDistanceBetween(oFaction, oPC)<30.0) && (GetArea(oFaction)==GetArea(oPC)))
						SendMessageToPC(oPC, sText);
					oFaction = GetNextFactionMember(oPC, TRUE);
				}
		}
		else 
		{
			SendMessageToPC(oPC, sText);
		}
	}	
}

// need to rework these
void CSLMessage_SendToParty(object oPC, string sTlkText, int bNotice)
{
	object oPartyMember = GetFirstFactionMember(oPC, TRUE); // PC's only
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
	    SendMessageToPC(oPartyMember, sTlkText);
		if(bNotice)
		{
			SetNoticeText(oPartyMember,sTlkText);
		}
		// GiveXPToCreature(oPartyMember, iXP);
		oPartyMember = GetNextFactionMember(oPC, TRUE); // PC's only
	}		
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendTalkText(object oPC, string sText, int nColor=-1, int nTalkVolume=TALKVOLUME_TALK)
{   //Purpose: Make oPC speak sText - Useful for seeing DMFI results of an NPC
	//NOTE: SPACE IS IN THIS ON PURPOSE FOR LISTENING BASED DMFI FUNCTIONS.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/23/6 - check valid state to stop crash.
	if (nColor!=-1) sText = CSLColorText(sText, nColor);
	if (GetIsObjectValid(oPC))
	{
		AssignCommand(oPC, SpeakString(" " + sText, nTalkVolume));
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendPartyText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bLocal=FALSE)
{   //Purpose: Function for sending text to an entire party or just a local party.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 10/19/6
	if (nColor!=-1) sText = CSLColorText(sText, nColor);
	object oTest = GetFirstFactionMember(oPC, TRUE);
	while (oTest!=OBJECT_INVALID)
	{
		if (bLocal)
		{// local test code
			if (GetDistanceBetween(oTest, oPC)<30.0 && (GetArea(oTest)==GetArea(oPC)))			
			{
				if (bFloat)
				{
					FloatingTextStringOnCreature(sText, oTest, FALSE);
				}
				else
				{
					SendMessageToPC(oTest, sText);
				}
			}		
		}// local test code
		else
		{
			if (bFloat)
			{
				FloatingTextStringOnCreature(sText, oTest, FALSE);
			}
			else
			{
				SendMessageToPC(oTest, sText);
			}
		}
		oTest = GetNextFactionMember(oPC, TRUE);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendDMText(object oDM, string sText, int bFloat=FALSE, int nColor=-1, int bAllDMs=0, object oListening=OBJECT_INVALID)
{   //Purpose: Function for sending text to DMs
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 5/30/6
	int n;
	int nNull;
	object oTest;
	if (nColor!=-1) sText = CSLColorText(sText, nColor);

	if (oListening==OBJECT_INVALID)
	{ // All or One only Code
		if (!bAllDMs)
		{ // message single DM
			if (bFloat)
			{
				FloatingTextStringOnCreature(sText, oDM, FALSE);
			}
			else
			{
				SendMessageToPC(oDM, sText);
			}
		} // message single DM
		else
		{
			if (bFloat)
			{
				oTest = GetFirstPC();
				while (oTest!=OBJECT_INVALID)
				{
					if (GetIsDM(oTest) || GetIsDMPossessed(oTest))
					{
						FloatingTextStringOnCreature(sText, oDM, FALSE);
					}
					oTest = GetNextPC();
				}
			}
			else
			{
				SendMessageToAllDMs(sText);
			}
		}
	} // All or One only Code

	else if (GetLocalInt(oListening, "DMFIListenOn")==1)
	{ // DM LISTENING CODE - Send the Text to any DM
		n=1;
		nNull = 0;
		oTest = GetLocalObject(oListening, "DMFIListen"+IntToString(n));
		while ((n<10) && (nNull<2))
		{ // max of 9 targets can be preset
				if (GetIsObjectValid(oTest) && (!GetObjectHeard(oListening, oTest)))
				{
					if (bFloat)
					{
						FloatingTextStringOnCreature(sText, oTest, FALSE);
					}
					else
					{
						SendMessageToPC(oTest, sText);
					}
				}
				else 
				{
					nNull++;
				}
				n++;
				oTest = GetLocalObject(oListening, "DMFIListen" + IntToString(n));
		} // max of 9 targets can be preset
	}
}

/**  
* not used, remove it???
* Description
* @author
* @param 
* @see 
* @return 
*/
/*
void CSLMessage_SendVarBasedText(object oPC, string sText, int bFloat= FALSE, int nColor=-1, string sVar="", int nValue=-1, int nLevel=0)
{	//Purpose: Function for sending variable based text
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 10/18/6
	object oTest;
	
	if (nColor!=-1) sText = CSLColorText(sText, nColor);
	
	if (nLevel==0)
	{ // PC Only message
		if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
		{
			if (bFloat)
			{
				FloatingTextStringOnCreature(sText, oPC, FALSE, 3.0);
			}
			else
			{
				SendMessageToPC(oPC, sText);
			}
		}			
	}
	else if (nLevel==1)
	{  // Check PC Party for variable state
		oTest = GetFirstFactionMember(oPC, TRUE);
	
		while (oTest!=OBJECT_INVALID)
		{
			if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
			{
				if (bFloat)
				{
					FloatingTextStringOnCreature(sText, oTest, FALSE, 3.0);
				}
				else
				{
					SendMessageToPC(oTest, sText);
				}
			}
			oTest = GetNextFactionMember(oPC, TRUE);		
		}
	}
	else if (nLevel==2)
	{ // Check every PC on server for variable state
		oTest = GetFirstPC();
		
		while (oTest!=OBJECT_INVALID)
		{ // cycle through all PCs
			if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
			{
				if (bFloat)
				{
					FloatingTextStringOnCreature(sText, oTest, FALSE, 3.0);
				}
				else
				{
					SendMessageToPC(oTest, sText);
				}
			}			
			oTest = GetNextFactionMember(oPC, TRUE);
		}
	}
}	
*/


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Use this to turn on debugging
void CSLSetDebugMessageTarget( int iDebugLevel, int iDebuggingMethod, object oTarget = OBJECT_INVALID )
{ // iDebugLevel = 1-9, 1 being normal messages, higher being more and more detail in debugging
	SetLocalInt( GetModule(), "SC_DEBUGGING_METHOD", iDebuggingMethod );
	
	if ( iDebuggingMethod == SCMESSAGE_MAINTESTER )
	{
		CSLAssignMainTester( oTarget );
	}
	
	if ( iDebuggingMethod == SCMESSAGE_MAINTESTER )
	{
		CSLAssignMainTester( GetFirstPC(FALSE) ); // assigns the first PC as a tester
	}
	
}







/**  
* This is used to make sure a message sent to a PC is logged, generally related to exploits
* @author
* @param 
* @see 
* @return 
*/
void CSLSendLoggedMessageToPC(object oPC, string sMsg)
{
	WriteTimestampedLogEntry("To " + GetName(oPC) + ": " + sMsg);
	SendMessageToPC(oPC, sMsg);
}










/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Broadcasts a message to all players on the server separately
// optional nMessageLevel if higher than one will require they have a var set to that or higher to see the message
// sAreaTag limits broadcast to only those in a given area
void CSLPlayerMessageBroadcast( string sMsg, int bDebuggersOnly = FALSE, int bIncludeDMs = FALSE, string sAreaTag = "" )
{
	object oPC = GetFirstPC();
	while ( oPC != OBJECT_INVALID )
	{
		if ( sAreaTag == "" ||  GetTag( GetArea( oPC ) ) == sAreaTag || ( bIncludeDMs == TRUE && CSLGetIsDM( oPC, TRUE ) ) )
		{
			if ( bDebuggersOnly == FALSE || GetLocalInt( oPC, "DEBUGGER" ) == TRUE )
			{
				SendMessageToPC( oPC, sMsg); 
			}
		}
		oPC = GetNextPC();
	}
}


void CSLPlayerMessageBroadcastByStrRef( int nStrRef, int bDebuggersOnly = FALSE, int bIncludeDMs = FALSE, string sAreaTag = "" )
{
	object oPC = GetFirstPC();
	while ( oPC != OBJECT_INVALID )
	{
		if ( sAreaTag == "" ||  GetTag( GetArea( oPC ) ) == sAreaTag || ( bIncludeDMs == TRUE && CSLGetIsDM( oPC, TRUE ) ) )
		{
			if ( bDebuggersOnly == FALSE || GetLocalInt( oPC, "DEBUGGER" )  )
			{
				SendMessageToPCByStrRef( oPC, nStrRef); 
			}
		}
		oPC = GetNextPC();
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// sends message to two players, only if those are not the same character
// optional nMessageLevel if higher than one will require they have a var set to that or higher to see the message
void CSLPlayerMessageSplit( string sMsg, object oChar1, object oChar2, int nMessageLevel = 0 )
{	
	if ( GetIsObjectValid( oChar1 ) && GetIsPC(oChar1) && ( nMessageLevel == 0 || GetLocalInt( oChar1, "DEBUGLEVEL" ) >= nMessageLevel ) )
	{
		SendMessageToPC( oChar1, sMsg);
	}
	
	if ( GetIsObjectValid( oChar1 ) && oChar1 != oChar2 && GetIsPC( oChar2 ) && ( nMessageLevel == 0 || GetLocalInt( oChar2, "DEBUGLEVEL" ) >= nMessageLevel ) )
	{
		SendMessageToPC( oChar2, sMsg);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
object CSLPrimaryActor(  )
{
	// this attempts to find the primary actor involved
	if ( GetIsSinglePlayer() )
	{
		return GetFirstPC( FALSE );
	}
	else if ( GetPCSpeaker() != OBJECT_INVALID )
	{
		return GetPCSpeaker();
	}
	else if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		return GetAreaOfEffectCreator();
	}
	else if ( GetIsPC( OBJECT_SELF ) )
	{
		return OBJECT_SELF;
	}
	
	return OBJECT_INVALID;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/

/* PRC Debug, integrate into CSLDebug
void CSLDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID)
{
    SendMessageToPC(GetLocalObject(GetModule(), "PRC_Debug_FirstPC"), "<c�j�>" + sString + "</c>");
    if(oAdditionalRecipient != OBJECT_INVALID)
        SendMessageToPC(oAdditionalRecipient, "<c�j�>" + sString + "</c>");
    WriteTimestampedLogEntry(sString);
}
*/ 

//int igDebugLoopCounter;
//int igLastDebugLoopCounter;

// * This is my debugging system, Debug level allows increasing and decreasing verbosity
// * options allow messages to be routed to the debugger or to those designated as a tester, or to a log
// * i'm assuming this will be modded to meet various peoples needs
// * Note that syntax is as follows
// * if (DEBUGGING) { CSLDebug("Debug Message" ) }
// * DebugLevel uses a setting on the tester soas to prevent them getting spammed, 5 are normal messages, 6-8 are inside loops and such
// * modes allow saving messages, putting them in a log, or logging them to the server, and possibly their own dialog
void CSLDebug(string sMsg, object oSource = OBJECT_SELF, object oTarget = OBJECT_INVALID, string sColor = "SlateGray" )
{
	int iTargetForMessages = GetLocalInt( GetModule(), "SC_DEBUGGING_METHOD" );
	int bLimitToThoseSetAsTesters = GetLocalInt( GetModule(), "SC_DEBUGGING_TESTERSONLY" );
	
	// pop it up a notch each pass
	
	/*
	if ( igDebugLoopCounter > 0 )
	{
		igDebugLoopCounter = igDebugLoopCounter+1;
		
		sMsg = "<color="+sColor+">"+sMsg+"</color>    <color=LightSlateGray><b>"+IntToString(igDebugLoopCounter)+"</b></color>";
		
		if ( igDebugLoopCounter > igLastDebugLoopCounter+1 )
		{
			sMsg += "  <color=LightSlateGray><b>Increased "+IntToString(igDebugLoopCounter-igLastDebugLoopCounter)+"</b></color>";
		}
		igLastDebugLoopCounter = igDebugLoopCounter;
	}
	else
	{
		*/
		sMsg = "<color="+sColor+">"+sMsg+"</color>";
	//  }
	
	if ( iTargetForMessages == SCMESSAGE_NONE )
	{
		if ( GetIsSinglePlayer() )
		{
			SetLocalInt( GetModule(), "SC_DEBUGGING_METHOD", SCMESSAGE_FIRSTPC );
		}
		else
		{
			SetLocalInt( GetModule(), "SC_DEBUGGING_METHOD", SCMESSAGE_SOURCE );
		}
	}
	object oPC;
	switch ( iTargetForMessages )
	{
		case SCMESSAGE_FIRSTPC:
			oPC = GetFirstPC(FALSE);
			if ( bLimitToThoseSetAsTesters == FALSE || GetLocalInt( oPC, "DEBUGGER" ) )
			{
				SendMessageToPC( oPC, sMsg);
			}
			break;
		case SCMESSAGE_SOURCE:
			if ( GetIsObjectValid( oSource ) && GetObjectType( oSource ) == OBJECT_TYPE_CREATURE )
			{
				if ( bLimitToThoseSetAsTesters == FALSE || GetLocalInt( oSource, "DEBUGGER" ) )
				{
					SendMessageToPC( oSource, sMsg);
				}
			}
			else
			{
				if ( bLimitToThoseSetAsTesters == FALSE )
				{
					SpeakString( sMsg );
				}
			}
			
			if ( GetIsObjectValid( oTarget ) && oTarget != oSource && GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE )
			{
				
				if ( bLimitToThoseSetAsTesters == FALSE || GetLocalInt( oTarget, "DEBUGGER" ) )
				{
					SendMessageToPC( oTarget, sMsg);
				}
			}
			break;
		case SCMESSAGE_BROADCAST: // can probably do this via shout as well
			CSLPlayerMessageBroadcast( sMsg, bLimitToThoseSetAsTesters );
			break;
		case SCMESSAGE_AREA: // sends to all PC's in a given area
			CSLPlayerMessageBroadcast( sMsg, bLimitToThoseSetAsTesters, FALSE, GetTag( GetArea( oSource ) ) );
			break;
		case SCMESSAGE_MAINTESTER: // sends to a set PC
			CSLSendMessageToMainTester( sMsg );
			break;
		case SCMESSAGE_MEMORYLOG: // will sit in memory, can be flushed via special command
			CSLMemoryLog( sMsg );
			break;
		case SCMESSAGE_LOGFILE: // will show up in server log
			WriteTimestampedLogEntry( sMsg );
			break;
		case SCMESSAGE_SHOUTER: // will show up in server log
			CSLShoutMsg(sMsg);
			break;
		default:
	}
}



/**  
* Forces a TMI
* @author
* @param 
* @see 
* @return 
*/
void CSLDie()
{
    int iTest = TRUE;
	while(iTest)
	{
		iTest = TRUE;
	}
}

/**  
* Logs message and does TMI if it fails test
* @author
* @param 
*/
void CSLAssert(int bAssertion, string sAssertion, string sMessage = "", string sFileName = "", string sFunction = "")
{
    if(bAssertion == FALSE)
    {
        //SpawnScriptDebugger();
        string sErr = "Assertion failed: " + sAssertion;

        if(sMessage != "" || sFileName != "" || sFunction != "")
        {
            sErr += "\n";

            if(sMessage != "")
                sErr += sMessage;

            if(sFileName != "" || sFunction != "")
            {
                if(sMessage != "")
                    sErr += "\n";

                sErr += "At " + sFileName;

                if(sFileName != "" && sFunction != "")
                    sErr += ": ";

                sErr += sFunction;
            }
        }

        CSLDebug(sErr);
        CSLDie();
    }
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendToPCDMs(string sMessage)
{
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{//check to see if they've chosen to ignore
		if (CSLVerifyDMKey(oPC) && (!CSLGetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
		{
		//Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage( GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sMessage );
			else { SendMessageToPC(oPC, sMessage); }
		}
		oPC = GetNextPC();
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendToPCAdmins(string sMessage)
{
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{//check to see if they've chosen to ignore
		if (CSLVerifyAdminKey(oPC) && (!CSLGetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
		{
		//Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sMessage );
			else { SendMessageToPC(oPC, sMessage); }
		}
		oPC = GetNextPC();
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendToDMDMs(string sMessage)
{
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{//check to see if they've chosen to ignore
		if (CSLVerifyDMKey(oPC) && CSLGetIsDM(oPC) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
		{
			//Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sMessage );
			else { SendMessageToPC(oPC, sMessage); }
		}
		oPC = GetNextPC();
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_SendToDMAdmins(string sMessage)
{
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{//check to see if they've chosen to ignore
		if (CSLVerifyAdminKey(oPC) && CSLGetIsDM(oPC) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
		{
			//Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sMessage );
			else { SendMessageToPC(oPC, sMessage); }
		}
		oPC = GetNextPC();
	}
}



/*
void CSLMessage( string sMsg, int nMsgType = 6, int nMsgDistribtion = 1, object oChar = OBJECT_SELF, object oTarget = OBJECT_INVALID )
{
	// lower this later
	//if (GetIsPC(oTarget) && oTarget!=oCaster) SendMessageToPC(oTarget, sSuccess);
	if ( sMsg == "" ) { return; }
	
	
	int nMsgTypesToShowPlayer = GetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_PLAYER" );
	if ( nMsgTypesToShowPlayer == 0 )
	{
		nMsgTypesToShowPlayer = 2;
	}
	int nMsgTypesToShowTester = GetLocalInt( GetModule(), "SC_MESSAGES_TO_SHOW_TESTER" );
	if ( nMsgTypesToShowTester == 0 )
	{
		nMsgTypesToShowTester = 2;
	}
	
	int iMessageSent = FALSE;
	int nMsgCasterIsTester = GetLocalInt( oChar, "SC_TESTER" );
	int nMsgTargetIsTester = GetLocalInt( oTarget, "SC_TESTER" );
	
	if ( ( nMsgDistribtion == 1 || nMsgDistribtion == 3 ) && GetIsObjectValid( oChar )  && GetIsPC( oChar ) )
	{
		if ( ( nMsgType <= nMsgTypesToShowPlayer ) || ( nMsgCasterIsTester == TRUE && nMsgType <= nMsgTypesToShowTester) )
		{
			SendMessageToPC( oChar, sMsg);
			iMessageSent = TRUE;
		}
	}
	
	if ( oTarget != oChar || iMessageSent != TRUE  )
	{
		if ( ( nMsgDistribtion == 2 || nMsgDistribtion == 3 ) &&GetIsObjectValid( oTarget ) && GetIsPC( oTarget ) )
		{
			if ( ( nMsgType <= nMsgTypesToShowPlayer ) || ( nMsgTargetIsTester == TRUE && nMsgType <= nMsgTypesToShowTester) )
			{
				SendMessageToPC( oTarget, sMsg);
			}
		}
	}
	
	if ( ( nMsgDistribtion == 4 )  )
	{
		if ( ( nMsgType <= nMsgTypesToShowPlayer )  )
		{
			SpeakString( sMsg );
		}
	}
	
}
*/






/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: CSLAutoDebugString
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Utility function: wraps send message to PC to
	automatically grab the first pc in the module
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 9, 2006
//:://////////////////////////////////////////////
void CSLAutoDebugString(string sDebugString)
{
	object oPC = GetFirstPC();
	
	if(DEBUGGING)
	{
		SendMessageToPC(oPC, sDebugString);
		PrintString(sDebugString);
	}
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_DMTellForwarding(object oPlayer, string sTarget, string sMessage, int nChannel)
{
	string sSend = "<color=orange>" + CSLGetMyName(oPlayer) + "(" + CSLGetMyPlayerName(oPlayer) + ")" + sTarget + "</color>"+"<color=palegreen>"+"["+"Tell"+"] " + sMessage + "</color>"+"\n";
	if ((nChannel==4) || (ENABLE_DM_TELL_ROUTING && (nChannel==20)))
	{
		if (DMS_HEAR_TELLS) CSLMessage_SendToDMDMs(sSend);
		if (DM_PLAYERS_HEAR_TELLS) CSLMessage_SendToPCDMs(sSend);
		if (ADMIN_DMS_HEAR_TELLS) CSLMessage_SendToDMAdmins(sSend);
		if (ADMIN_PLAYERS_HEAR_TELLS) CSLMessage_SendToPCAdmins(sSend);
	}
	else if ((nChannel==20) && DM_TELLS_ROUTED_ONLY_TO_ADMINS)
	{
		if (ADMIN_DMS_HEAR_TELLS) CSLMessage_SendToDMAdmins(sSend);
		if (ADMIN_PLAYERS_HEAR_TELLS) CSLMessage_SendToPCAdmins(sSend);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_DMChannelForwardToDMs(object oPlayer, string sMessage)
{
	string sSend = "<color=orange>" + CSLGetMyName(oPlayer) + "(" + CSLGetMyPlayerName(oPlayer) + ")" + ": "+"</color>"+"<color=slateblue>"+"["+"DM"+"] " + sMessage + "</color>"+"\n";
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{
		if (CSLVerifyDMKey(oPC) && (!CSLGetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREDM")))
		{
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage( GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sSend );
			else { SendMessageToPC(oPC, sSend); }
		}
		oPC = GetNextPC();
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLMessage_DMChannelForwardToAdmins(object oPlayer, string sMessage)
{
	string sSend = "<color=orange>" + CSLGetMyName(oPlayer) + "(" + CSLGetMyPlayerName(oPlayer) + ")" + ":"+"</color>"+"<color=slateblue>"+"[DM] " + sMessage + "</color>"+"\n";
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{
		if (CSLVerifyAdminKey(oPC) && (!CSLGetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREDM")))
		{
			//Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
			if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage( GetLocalObject(GetModule(), "FKY_CHT_MESSENGER"), oPC, CHAT_MODE_TELL, sSend );
			else { SendMessageToPC(oPC, sSend); }
		}
		oPC = GetNextPC();
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Shows a report to oPC
// sMsg : Content
// oPC  : PC to show to
// sScr : Call back script when ok is clicked
void CSLMessage_ShowReport(object oPC, string sMsg, string sScr=""){
	string sGUI = "SCREEN_MESSAGEBOX_REPORT";
	string sCls = "CloseButton";	
	CloseGUIScreen(oPC, sGUI);
	SetGUIObjectDisabled(oPC, sGUI, sCls, TRUE);
	DelayCommand(0.1f,
		DisplayMessageBox(
			oPC, // Display a message box for this PC
			-1,   // string ref to display
			sMsg, // Message to display
			sScr, // Callback for clicking the OK button
			sScr, // Callback for clicking the Cancel button
			FALSE,// display the Cancel button
			sGUI, // Display the tutorial message box
			-1,   // OK string ref
			"",   // OK string
			-1,   // Cancel string ref
			""    // Cancel string
		)
	);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Show report to every PC
// sMsg : Content
// sScr : Call back script when ok is clicked
// oPC  : if valid, only report to oPC's party members
void CSLMessageShowReportToAllPC(string sMsg, string sScr="", object oPC=OBJECT_INVALID){
	object oCPC = GetFirstPC(FALSE);
	while( GetIsObjectValid(oCPC) )
	{
		if( !GetIsObjectValid(oPC) || GetFactionEqual(oPC, oCPC) )
		{
			CSLMessage_ShowReport(oCPC, sMsg, sScr);
		}
		oCPC = GetNextPC(FALSE);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Send a message to every PC
// oPC : if valid, only message oPC's party members
void CSLMessageSendToAllPC(string sMsg, object oPC=OBJECT_INVALID){
	object oCPC = GetFirstPC(FALSE);
	while( GetIsObjectValid(oCPC) )
	{
		if( !GetIsObjectValid(oPC) || GetFactionEqual(oPC, oCPC) )
		{
			SendMessageToPC(oCPC, sMsg);
		}
		oCPC = GetNextPC(FALSE);
	}
}

// Post message with drop-shadow and print to log
void CSLMessage_Backdrop(object oTarget, string sMessage, int nX, int nY, float fDuration, int nColor=CSL_POST_COLOR_BLACK)
{
	DebugPostString(oTarget, sMessage, nX - 1, nY - 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX + 1, nY - 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX + 1, nY + 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX - 1, nY + 1, fDuration, nColor);
}



// Post message with drop-shadow and print to log
void CSLMessage_PrettyPostString(object oTarget, string sMessage, float fDuration, int nColor=CSL_POST_COLOR_WHITE)
{
	int nX = CSL_PRETTY_X_OFFSET;
	int nLineOffset = GetGlobalInt(CSL_PRETTY_LINE_COUNT_VAR);
	int nY = CSL_PRETTY_Y_OFFSET + (nLineOffset * CSL_LINE_SIZE);

	CSLMessage_Backdrop(oTarget, sMessage, nX, nY, fDuration, CSL_POST_COLOR_BLACK);
	DebugPostString(oTarget, sMessage, nX, nY, fDuration, nColor);
	PrintString(sMessage);

	nLineOffset = (nLineOffset + 1) % CSL_PRETTY_LINE_WRAP;
	SetGlobalInt(CSL_PRETTY_LINE_COUNT_VAR, nLineOffset);
}

// Pretty post message
void CSLMessage_PrettyMessage(string sMessage, float fDuration=CSL_PRETTY_DURATION, int nColor=CSL_POST_COLOR_WHITE)
{
	object oPC = GetFirstPC(FALSE);
	CSLMessage_PrettyPostString(oPC, sMessage, fDuration, nColor);
}




/*
// Send a server message (szMessage) to the oPlayer.
void SendMessageToPC(object oPlayer, string szMessage);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - nStrRefToDisplay: String ref (therefore text is translated)
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
void FloatingTextStrRefOnCreature(int nStrRefToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, float fDuration=5.0,
											int nStartColor=4294967295, int nEndColor=4294967295, float fSpeed=0.0, vector vDirection=[0.0,0.0,0.0]);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - sStringToDisplay: String
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
void FloatingTextStringOnCreature(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, float fDuration=5.0,
											int nStartColor=4294967295, int nEndColor=4294967295, float fSpeed=0.0, vector vDirection=[0.0,0.0,0.0]);





// Write sLogEntry as a timestamped entry into the log file
void WriteTimestampedLogEntry(string sLogEntry);

// Causes the object to instantly speak a translated string.
// (not an action, not blocked when uncommandable)
// - nStrRef: Reference of the string in the talk table
// - nTalkVolume: TALKVOLUME_*
void SpeakStringByStrRef(int nStrRef, int nTalkVolume=TALKVOLUME_TALK);

// Sets the given creature into cutscene mode.  This prevents the player from
// using the GUI and camera controls.
// - oCreature: creature in a cutscene
// - nInCutscene: TRUE to move them into cutscene, FALSE to remove cutscene mode
void SetCutsceneMode(object oCreature, int nInCutscene=TRUE);

// Gets the last player character to cancel from a cutscene.
object GetLastPCToCancelCutscene();

// Gets the length of the specified wavefile, in seconds
// Only works for sounds used for dialog.
float GetDialogSoundLength(int nStrRef);

// Fades the screen for the given creature/player from black to regular screen
// - oCreature: creature controlled by player that should fade from black
// fSpeed is a float representing how many seconds the fade should
// take place over 
void FadeFromBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM);

// Fades the screen for the given creature/player from regular screen to black
// - oCreature: creature controlled by player that should fade to black
// fSpeed is a float representing how many seconds the fade should
// take place over 
// RWT-OEI 08/09/05 - Added fFailsafe parameter. Indicates the number of seconds
// that should pass before the fade is removed unconditionally. If set to 0,
// then there will be no failsafe.
// RWT-OEI 01/20/06 - The new nColor parameter allows one to fade to colors other than
// black.
void FadeToBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM, float fFailsafe=5.0, int nColor=0);

// Removes any fading or black screen.
// - oCreature: creature controlled by player that should be cleared
void StopFade(object oCreature);

// Sets the screen to black.  Can be used in preparation for a fade-in (FadeFromBlack)
// Can be cleared by either doing a FadeFromBlack, or by calling StopFade.
// - oCreature: creature controlled by player that should see black screen
// RWT-OEI 01/20/06 - New nColor parameter forces the screen to different colors. 
void BlackScreen(object oCreature, int nColor=0);


// Send a server message (szMessage) to the oPlayer.
void SendMessageToPCByStrRef(object oPlayer, int nStrRef);

// Spawn in the Death GUI.
// The default (as defined by BioWare) can be spawned in by PopUpGUIPanel, but
// if you want to turn off the "Respawn" or "Wait for Help" buttons, this is the
// function to use.
// - oPC
// - bRespawnButtonEnabled: if this is TRUE, the "Respawn" button will be enabled
//   on the Death GUI.
// - bWaitForHelpButtonEnabled: if this is TRUE, the "Wait For Help" button will
//   be enabled on the Death GUI.
// - nHelpStringReference
// - sHelpString
void PopUpDeathGUIPanel(object oPC, int bRespawnButtonEnabled=TRUE, int bWaitForHelpButtonEnabled=TRUE, int nHelpStringReference=0, string sHelpString="");


//RWT-OEI 08/11/05
//Prints a debug string to the screen at the given location for the given duration in the given color.
//It gets displayed on the screen of the object passed in as oTarget
// output controlled by ini settings: nwn.ini - [Game Options]Debug Text & nwnplayer.ini - [Server Options]Scripts Print To Screen
void DebugPostString( object oTarget, string sMesg, int nX, int nY, float fDuration, int nColor=4294901760 );



//RWT-OEI 12/08/05
//This function allows the script to display a GUI on the player's client.
//The first parameter is the object ID owned by the player you wish to
//display the GUI on.
//The second parameter is the name of the GUI screen to display. Note
//that only screens located in the [GuiScreen] section of ingamegui.ini
//will be accessible.
//The 3rd parameter indicates if the displayed GUI should be modal when
//it pops up.
//RWT-OEI 01/16/07 - Added 4th parameter. This defines the resource
//that should be used for this screen if the screenName is not already
//found in the ingamegui.ini or pregamegui.ini.  If left blank, then no
//gui will be loaded if the ScreenName doesn't already exist. If the
//sScreenName is *already* in use, then the 4th parameter will be ignored. 
void DisplayGuiScreen( object oPlayer, string sScreenName, int bModal, string sFileName = "", int bOverrideOptions = FALSE);




//RWT-OEI 01/05/06
//This script function displays a message box popup on the client of the
//player passed in as the first parameter.
//////
// oPC           - The player object of the player to show this message box to
// nMessageStrRef- The STRREF for the Message Box message. 
// sMessage      - The text to display in the message box. Overrides anything 
//               - indicated by the nMessageStrRef
// sOkCB         - The callback script to call if the user clicks OK, defaults
//               - to none. The script name MUST start with 'gui'
// sCancelCB     - The callback script to call if the user clicks Cancel, defaults
//               - to none. The script name MUST start with 'gui'
// bShowCancel   - If TRUE, Cancel Button will appear on the message box.
// sScreenName   - The GUI SCREEN NAME to use in place of the default message box.
//               - The default is SCREEN_MESSAGEBOX_DEFAULT 
// nOkStrRef     - The STRREF to display in the OK button, defaults to OK
// sOkString     - The string to show in the OK button. Overrides anything that
//               - nOkStrRef indicates if it is not an empty string
// nCancelStrRef - The STRREF to dispaly in the Cancel button, defaults to Cancel.
// sCancelString - The string to display in the Cancel button. Overrides anything
//				- that nCancelStrRef indicates if it is anything besides empty string
void DisplayMessageBox( object oPC, int nMessageStrRef,
						string sMessage, string sOkCB="", 
								string sCancelCB="", int bShowCancel=FALSE, 
								string sScreenName="",
								int nOkStrRef=0, string sOkString="",
								int nCancelStrRef=0, string sCancelString="" );
								
								
//RWT-OEI 02/23/06
//This function will set a GUI object as hidden or visible on a GUI panel on
//the client.
//The panel must be located within the [ScriptGUI] section of the ingamegui.ini
//in order to let this script function have any effect on it.
//Also, the panel must be in memory. Which means the panel should probably not have
//any idle expiration times set in the <UIScene> tag that would cause the panel to
//unload
void SetGUIObjectHidden( object oPlayer, string sScreenName, string sUIObjectName, int bHidden );

//RWT-OEI 02/23/06
//This function will close a specific GUI panel on the client.
//The panel must be located within the [ScriptGUI] section of the ingamegui.ini
//in order to let this script close it.
void CloseGUIScreen( object oPlayer, string sScreenName );


//PEH-OEI 05/24/06
//This script function displays a text input box popup on the client of the
//player passed in as the first parameter.
//////
// oPC           - The player object of the player to show this message box to
// nMessageStrRef- The STRREF for the Message Box message. 
// sMessage      - The text to display in the message box. Overrides anything 
//               - indicated by the nMessageStrRef
// sOkCB         - The callback script to call if the user clicks OK, defaults
//               - to none. The script name MUST start with 'gui'
// sCancelCB     - The callback script to call if the user clicks Cancel, defaults
//               - to none. The script name MUST start with 'gui'
// bShowCancel   - If TRUE, Cancel Button will appear on the message box.
// sScreenName   - The GUI SCREEN NAME to use in place of the default message box.
//               - The default is SCREEN_STRINGINPUT_MESSAGEBOX 
// nOkStrRef     - The STRREF to display in the OK button, defaults to OK
// sOkString     - The string to show in the OK button. Overrides anything that
//               - nOkStrRef indicates if it is not an empty string
// nCancelStrRef - The STRREF to dispaly in the Cancel button, defaults to Cancel.
// sCancelString - The string to display in the Cancel button. Overrides anything
//				- that nCancelStrRef indicates if it is anything besides empty string
// sDefaultString- The text that gets copied into the input area,
//				- used as a default answer
void DisplayInputBox( object oPC, int nMessageStrRef,
						string sMessage, string sOkCB="", 
								string sCancelCB="", int bShowCancel=FALSE, 
								string sScreenName="",
								int nOkStrRef=0, string sOkString="",
								int nCancelStrRef=0, string sCancelString="",
								string sDefaultString="", string sUnusedString="" );
								


// Brock H. - OEI 11/07/06
// If oCreature is controlled by a player, this will be the 
// creature that the player currently has up in the 
// creature examine window. 
// then the return value will be OBJECT_INVALID
object GetPlayerCreatureExamineTarget( object oCreature );


//RWT-OEI 02/23/07
//This script function sets the position of a progress bar on a client's GUI.
//The progress can be a percentage between 0.0 and 1.0 (empty and full).
//In order for this script function to work, the UIScene that contains the
//progress bar must have a scriptloadable=true attribute in it.
void SetGUIProgressBarPosition( object oPlayer, string sScreenName, string sUIObjectName, float fPosition );

//RWT-OEI 02/23/07
//This script function sets the texture for a Icon, Button, or Frame.
//If the object is an icon, the texture is set as the icon's image.
//If the object is a frame, the texture is set as the frame's FILL texture
//If the object is a button that has a base frame, the texture is set
//as the BASE frame's FILL texture.
//If the object is a button that has no base frame, the texture is set
//as the UP state's FILL texture. 
//Texture names should include the extention (*.tga for example).
//The UIScene that contains the UIObject must have a scriptloadable=true
//attribute in it.
void SetGUITexture( object oPlayer, string sScreenName, string sUIObjectName, string sTexture );


//RWT-OEI 04/19/07
// This script function will turn off a player's GUI, except for
// the FADE screen. Floating text will still be rendered.
// oPlayer - object ID of the player to turn off the GUI for
// bHide   - If TRUE, turns off the player's GUI, of false, shows
//           the player's GUI.
// Note that if the player hits ESC, their GUI will come back up.
void SetPlayerGUIHidden( object oPlayer, int bHidden );

//RWT-OEI 04/30/07
// This sends a text string to the player that will appear
// on the player's screen inside their Notice Window GUI.
// A notice window can be any text field that has
// the UIText_OnUpdate_DisplayNoticeText() callback running
// on it.
// oPlayer - The player to send the notice message to.
// sMessage - The text to display. Cannot be an empty
//            string. 
void SetNoticeText( object oPlayer, string sText );


//RWT-OEI 03/06/08
//Sets the scroll bar ranges on a specified scrollbar on a specified
//screen. Passing -1 will cause that attribute to be left as-is rather
//than being changed. 
//In order to work, the screen that contains the scroll bar must have
//the ScriptLoadable=true attribute in the <UIScene> tag.
// oPlayer - Player who's GUI needs to be modified.
// sScreenName - GUI Name of the scene that contains the scroll bar
// sScrollBarName - Name of the scroll bar to change the parameters for
// nMinSize, nMaxSize - These control how many 'ticks' there are in the
//                      scroll bar. Leave -1 to not change.
// nMiiValue, nMaxValue - These control what the percentages of the
//                        scroll bar actually represent in terms of
//                        value. 
void SetScrollBarRanges( object oPlayer, string sScreenName, string sScrollBarName, int nMinSize, int nMaxSize, int nMiiValue, int nMaxValue ); 

//RWT-OEI 03/11/08
//Clear a listbox on the client's GUI.
// oPlayer - Player Object to send the clear message to.
// sScreenName - Name of the screen that contains the listbox.
// sListBox - Name of the listbox to clear
//As with other GUI modifying script functions, the GUI must be scriptloadable.
void ClearListBox( object oPlayer, string sScreenName, string sListBox );

//RWT-OEI 03/11/08
//Add a row to a listbox on a client's GUI
// oPlayer - Player Object to send the new row to
// sScreenName - Name of the screen that contains the listbox
// sListBox - Name of the listbox to add the row to
// sRowName - Name to give the new row
// sTextFields - List of text fields and text values to populate the row
// sTextures - List of texture objects and texture names to populate the row
// sVariables - List of variable indexes and variable values
// sHideUnHide - List of objects to hide or set unhidden 
//The syntax for the text fields, textures, variables, and hide/unhide list is:
//<name of UI Object>=<value>, except in the case of variables where it is <index>=<value>
//Multiple entries are seperated by ; marks. 
//And in order to affect the root level of the row itself, simply make an entry that starts with the = sign.
//For example, for setting text field contents, some options might be:
//	sTextFields = "textfield1=Row One Text1;textfield2=Row One Text2";//This will make it so the text field named 'textfield1'
//                will say 'Row One Text1' and the text field in that row named 'textfield2' will say 'Row One Text2'.
//  sTextFields = "=Row Text" will make the row itself (assuming it can display text) say 'Row Text'. 
void AddListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName, string sTextFields, string sTextures, string sVariables, string sHideUnhide );

//RWT-OEI 03/12/08
//Remove a row from a listbox by its name
// oPlayer - Player object to send the message to
// sScreenName - Name of the screen to find the listbox on
// sListBox - Name of the listbox to remove the row from
// sRowName - Name of the row to lookup and remove
void RemoveListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName ); 


//RWT-OEI 04/09/08
//Modify a row in a listbox on a client's GUI
// oPlayer - Player Object to send the new row to
// sScreenName - Name of the screen that contains the listbox
// sListBox - Name of the listbox to find the row in
// sRowName - Name of the row to modify
// sTextFields - List of text fields and text values to populate the row
// sTextures - List of texture objects and texture names to populate the row
// sVariables - List of variable indexes and variable values
// sHideUnHide - List of objects to hide or set unhidden 
//The syntax for the text fields, textures, variables, and hide/unhide list is:
//<name of UI Object>=<value>, except in the case of variables where it is <index>=<value>
//Multiple entries are seperated by ; marks. 
//And in order to affect the root level of the row itself, simply make an entry that starts with the = sign.
//For example, for setting text field contents, some options might be:
//	sTextFields = "textfield1=Row One Text1;textfield2=Row One Text2";//This will make it so the text field named 'textfield1'
//                will say 'Row One Text1' and the text field in that row named 'textfield2' will say 'Row One Text2'.
//  sTextFields = "=Row Text" will make the row itself (assuming it can display text) say 'Row Text'. 
void ModifyListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName, string sTextFields, string sTextures, string sVariables, string sHideUnhide );


//RWT-OEI 10/06/08
//Sets the scroll bar ranges on a specified scrollbar on a specified
//screen. Passing -1 will cause that attribute to be left as-is rather
//than being changed. 
//In order to work, the screen that contains the scroll bar must have
//the ScriptLoadable=true attribute in the <UIScene> tag.
// oPlayer - Player who's GUI needs to be modified.
// sScreenName - GUI Name of the scene that contains the scroll bar
// sScrollBarName - Name of the scroll bar to change the parameters for
// nMinSize, nMaxSize - These control how many 'ticks' there are in the
//                      scroll bar. Leave -1 to not change.
// nMiiValue, nMaxValue - These control what the percentages of the
//                        scroll bar actually represent in terms of
//                        value. 
void SetScrollBarValue( object oPlayer, string sScreenName, string sScrollBarName, int iValue );

this is in ginc_gui

// ginc_gui.nss
/// *
//	GUI/Screen campaign include
//* /
// BMA-OEI 4/06/06
// BMA-OEI 8/22/06 -- Renamed to ginc_gui, moved GUI_DEATH* to ginc_death
// BMA-OEI 9/28/06 -- Added GUI_PARTY_SELECT_CANCEL

const string GUI_LOAD_GAME			= "SCREEN_LOADGAME";
const string GUI_PARTY_SELECT 		= "SCREEN_PARTYSELECT";
const string GUI_PARTY_SELECT_CANCEL	= "REMOVE_PARTY";
const string GUI_PARTY_SELECT_CLOSE		= "CloseButton";


// Displays Load Game screen to oPC
void ShowLoadGame( object oPC );

// Displays Party Selection screen to oPC
// - bModal: T/F, Display window modally
// - sAcceptCallback: Callback script executed when party is accepted
// - bCloseButton: T/F, Enable close button
void CSLShowPartySelect( object oPC, int bModal=TRUE, string sAcceptCallback="", int bCloseButton=FALSE );

// Hides Party Selection screen for oPC
void CSLHidePartySelect( object oPC );


// Displays Load Game screen to oPC
void ShowLoadGame( object oPC )
{
	DisplayGuiScreen( oPC, GUI_LOAD_GAME, FALSE );
}



// Hides Party Selection screen for oPC
               

*/


// Displays Party Selection screen to oPC
// - bModal: T/F, Display window modally
// - sAcceptCallback: Callback script executed when party is accepted
// - bCloseButton: T/F, Enable close button
void CSLShowPartySelect( object oPC, int bModal=TRUE, string sAcceptCallback="", int bCloseButton=FALSE )
{
	SetGUIObjectDisabled( oPC, "SCREEN_PARTYSELECT", "REMOVE_PARTY", !bCloseButton );
	SetGUIObjectDisabled( oPC, "SCREEN_PARTYSELECT", "CloseButton", !bCloseButton );
	SetLocalGUIVariable( oPC, "SCREEN_PARTYSELECT", 0, sAcceptCallback );
	DisplayGuiScreen( oPC, "SCREEN_PARTYSELECT", TRUE );
}

void CSLHidePartySelect( object oPC )
{
	CloseGUIScreen( oPC, "SCREEN_PARTYSELECT" );
}       


void SendPopupAllPlayers(string sTexto)
{
	object oPlayer = GetFirstPC();
	while (GetIsObjectValid(oPlayer))
	{
		DisplayMessageBox(oPlayer,0,sTexto,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"Ok",0,"Cancel");	
		oPlayer = GetNextPC();
	}
}

void SendPopupParty(string sTexto, object oTarget)
{
	object oPlayer = GetFirstFactionMember(oTarget);
	while (GetIsObjectValid(oPlayer))
	{
		DisplayMessageBox(oPlayer,0,sTexto,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"Ok",0,"Cancel");	
		oPlayer = GetNextFactionMember(oTarget);
	}
}


void CSLChatBroadcastMessageAtLocation( string sMessage, location lLocation, object oSpeaker = OBJECT_INVALID, float fRadiusSize = 20.0f )
{
		string sNewMessage;
		if ( GetIsObjectValid( oSpeaker ) && GetName(oSpeaker) != "")
		{
			sNewMessage = "<color=pink>"+GetName(oSpeaker)+":</color> "+sMessage;
		}
		else
		{
			sNewMessage = sMessage;
		}
		
		
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadiusSize, lLocation, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oTarget))
		{
			if ( GetIsPC(oTarget) )
			{
				SendMessageToPC(oTarget, sNewMessage );
			}
			else
			{
				SendChatMessage(oSpeaker, oTarget, CHAT_MODE_TELL, sMessage );
			}
			GetNextObjectInShape(SHAPE_SPHERE, fRadiusSize, lLocation, TRUE, OBJECT_TYPE_CREATURE);
		}
				
}