/** @file
* @brief Include File for Chat System
*
* 
* 
*
* @ingroup scinclude
* @author FunkySwerve, Brian T. Meyer and others
*/


#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_Nwnx"
#include "_CSLCore_Player"

#include "_SCInclude_Language"

#include "_SCInclude_Chat_c"
#include "_CSLCore_UI"
#include "_CSLCore_Visuals"
#include "_SCInclude_Chat_c"

// lets see if we can compile without any DMFI yet
//#include "_SCInclude_DMFI"
//#include "_SCInclude_DMFIComm"


string CSLGetChatParameters()
{
	return GetLocalString( GetModule(), "chat_parameters" );
}

string CSLGetChatCommand()
{
	return GetLocalString( GetModule(), "chat_command" );
}

string CSLGetChatMessage()
{
	return GetLocalString( GetModule(), "chat_message" );
}

int CSLGetChatChannel()
{
	return GetLocalInt( GetModule(), "chat_channel" );
}

void CSLSetChatSuppress( int iSuppress )
{
	SetLocalInt( GetModule(), "chat_suppress", iSuppress );
}

int CSLGetChatSuppress()
{
	return GetLocalInt( GetModule(), "chat_suppress" );
}

// for use in chat scripts
object CSLGetChatSender()
{
	return GetLocalObject( GetModule(), "chat_sender" );
}


object CSLGetChatMessenger()
{
   return GetLocalObject(GetModule(), "FKY_CHT_MESSENGER");
}

void CSLSetChatMessenger( string sMessengerTag = "DM_GHOST" )
{
	SetLocalObject( GetModule(), "FKY_CHT_MESSENGER", GetObjectByTag( sMessengerTag ));
}

object CSLGetChatTarget()
{
	object oTarget = GetLocalObject( GetModule(), "chat_target" );
	
	if ( !GetIsObjectValid( oTarget ) && CSLGetChatChannel() != CHAT_MODE_TELL )
	{
		object oNewTarget = GetPlayerCurrentTarget( CSLGetChatSender() );
		return oNewTarget;
	}
	return oTarget;
}

int CSLGetIsChannelSuppressed(int nChannel)
{
   int nReturn;
   switch(nChannel)
   {
	   case CHAT_MODE_TALK: nReturn = DISABLE_TALK_CHANNEL; break;
	   case CHAT_MODE_SHOUT: nReturn = DISABLE_SHOUT_CHANNEL; break;
	   case CHAT_MODE_WHISPER: nReturn = DISABLE_WHISPER_CHANNEL; break;
	   case CHAT_MODE_TELL: nReturn = DISABLE_TELL_CHANNEL; break;
	   case CHAT_MODE_PARTY: nReturn = DISABLE_PARTY_CHANNEL; break;
	   case CHAT_MODE_SILENT_SHOUT: nReturn = DISABLE_DM_CHANNEL; break;
	   default: nReturn = FALSE; break;
   }
   return nReturn;
}

int CSLGetIsChannelDeadSuppressed(int nChannel)
{
   int nReturn;
   switch(nChannel)
   {
	   case CHAT_MODE_TALK: nReturn = DISABLE_DEAD_TALK; break;
	   case CHAT_MODE_SHOUT: nReturn = DISABLE_DEAD_SHOUT; break;
	   case CHAT_MODE_WHISPER: nReturn = DISABLE_DEAD_WHISPER; break;
	   case CHAT_MODE_TELL: nReturn = DISABLE_DEAD_TELL; break;
	   case CHAT_MODE_PARTY: nReturn = DISABLE_DEAD_PARTY; break;
	   case CHAT_MODE_SILENT_SHOUT: nReturn = DISABLE_DEAD_DM; break;
	   default: nReturn = FALSE; break;
   }
   return nReturn;
}

string CSLChannelNametoString(int nChannel)
{
	string sChannel;
	
	switch(nChannel)
	{
		case CHAT_MODE_TALK: sChannel = "Talk"; break;
		case CHAT_MODE_SHOUT: sChannel = "Shout"; break;
		case CHAT_MODE_WHISPER: sChannel = "Whisper"; break;
		case CHAT_MODE_TELL: sChannel = "Tell"; break;
		case CHAT_MODE_SERVER: sChannel = "Server"; break;
		case CHAT_MODE_PARTY: sChannel = "Party"; break;
		case CHAT_MODE_SILENT_SHOUT: sChannel = "DM"; break;
		default: sChannel = "Unknown"; break;
	}
	return sChannel;
}

int CSLGetIsShoutBanned( object oPC )
{
	return ( GetLocalInt( oPC, CHAT_PLAYERSHOUTBAN ) !=0 );
}

void CSLSetIsShoutBanned( object oPC, int bBanState = TRUE )
{
	SetLocalInt( oPC, CHAT_PLAYERSHOUTBAN, bBanState );
}




void CSLExecuteChatScript( string sCommandPrefix, object oSender, object oTarget, int nChannel, string sMessage )
{
	if ( sMessage == "" ||  sCommandPrefix == "" )
	{
		return;
	}
	
	string sParameters = CSLNth_Shift(sMessage, " ");
	string sCommand = CSLNth_GetLast();
	
	if ( sCommand == "" )
	{
		return;
	}
	SetLocalString( GetModule(), "chat_command", sCommand );
	SetLocalString( GetModule(), "chat_parameters", sParameters );
	SetLocalString( GetModule(), "chat_message", sMessage );
	SetLocalObject( GetModule(), "chat_sender", oSender );
	SetLocalObject( GetModule(), "chat_target", oTarget );
	SetLocalInt( GetModule(), "chat_channel", nChannel );
	
	//SendMessageToPC( oSender, "Running Chat command: "+"chat_"+sCommandPrefix+"_"+sCommand);
	ExecuteScript( "chat_"+sCommandPrefix+"_"+sCommand,oSender);
	
	DeleteLocalString( GetModule(), "chat_command" );
	DeleteLocalString( GetModule(), "chat_parameters" );
	DeleteLocalString( GetModule(), "chat_message" );
	DeleteLocalObject( GetModule(), "chat_sender" );
	DeleteLocalObject( GetModule(), "chat_target" );
	DeleteLocalInt( GetModule(), "chat_channel" );
}


void CSLLogMessageToDatabase( string sType, object oSender, object oTarget, int nChannel, string sMessage )
{
	sType = GetStringLeft(CSLChannelNametoString(nChannel), 1);
	
	if ( !GetIsObjectValid( oSender ) )
	{
		return;
	}
	
	if ( sType == "U" )
	{
		return;
	}
	
	string sTPLID = "0";
	if ( GetIsObjectValid( oTarget ) )
	{
		sTPLID = GetLocalString(oTarget, "PlayerID");//SDB_GetPLID(oTarget);
	}
	
	string sLogMessageTarget = "->" + CSLGetMyName(oTarget) + "(" + CSLGetMyPlayerName(oTarget) + ")";
	string sLogMessage = CSLGetMyName(oSender) + "(" + CSLGetMyPlayerName(oSender) + ")" + sLogMessageTarget + "[" + CSLChannelNametoString(nChannel) + "] " + sMessage + "\n";
      // Log
      //NWNXSetString("CHAT", "LOG", "", 0, sLogMessage);
      
      string sSQL = "insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +
      CSLDelimList( CSLInQs( GetLocalString(GetModule(), "SDB_SEID") ), CSLInQs( IntToString(StringToInt(GetLocalString(oSender, "PlayerID"))) ), CSLInQs(sType), CSLInQs(sLogMessage), CSLInQs( sTPLID) ) + ")";
      CSLNWNX_SQLExecDirect(sSQL);
      //SDB_LogMsg("DMCHAT", sLogMessage, oSender);
}

/**  
* Turns the voice throwing feature on and off
* @author
* @param 
* @see 
* @return 
*/
void SCVoiceThrowing( object oTarget, int bVoiceThrowingActive = TRUE )
{
	if ( bVoiceThrowingActive )
	{
		SetLocalInt(oTarget, "CHAT_THROWINGVOICE", TRUE);
		SendMessageToPC( oTarget, "Voice throwing enabled");
		SetGUIObjectHidden( oTarget, "SCREEN_GUI_CONTROL", "VoiceThrowingOn", TRUE ); // true hides
		SetGUIObjectHidden( oTarget, "SCREEN_GUI_CONTROL", "VoiceThrowingOff", FALSE ); // true hides
		
	}
	else
	{
		SetLocalInt(oTarget, "CHAT_THROWINGVOICE", FALSE);
		SendMessageToPC( oTarget, "Voice throwing disabled");
		SetGUIObjectHidden( oTarget, "SCREEN_GUI_CONTROL", "VoiceThrowingOn", FALSE ); // true hides
		SetGUIObjectHidden( oTarget, "SCREEN_GUI_CONTROL", "VoiceThrowingOff", TRUE ); // true hides
	}

}


void CSLSendMetaMessage(object oPlayer, string sChannelName, string sMessage)
{
   string sText = "<color=orange>" + CSLGetMyName(oPlayer) + "(" + CSLGetMyPlayerName(oPlayer) + "):"+"</color>"+"<color=orange>"+"["+"Meta"+"] " + sMessage + "</color>";
   string sDMText = sText + "<color=indianred>"+" ("+"Channel"+": " + sChannelName + ")"+"</color>";
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      if (GetLocalString(oPC, "FKY_CHT_META_GRP")==sChannelName)
      {
         //Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
         if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sText );
         else SendMessageToPC(oPC, sText);
      }
      if (DM_PLAYERS_HEAR_META)
      {
         if (CSLVerifyDMKey(oPC) && (!CSLGetIsDM(oPC)) && (GetLocalString(oPC, "FKY_CHT_META_GRP") != sChannelName) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREMETA")))
         {
            //Fixing
			//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
			//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sDMText );
            else SendMessageToPC(oPC, sDMText);
         }
      }
      if (DMS_HEAR_META)
      {
         if (CSLVerifyDMKey(oPC) && CSLGetIsDM(oPC) && (GetLocalString(oPC, "FKY_CHT_META_GRP") != sChannelName) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREMETA")))
         {
            //Fixing
			//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
			//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sDMText );
            else SendMessageToPC(oPC, sDMText);
         }
      }
      if (ADMIN_PLAYERS_HEAR_META)
      {
         if (CSLVerifyAdminKey(oPC) && (!CSLGetIsDM(oPC)) && (GetLocalString(oPC, "FKY_CHT_META_GRP") != sChannelName) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREMETA")))
         {
            //Fixing
			//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
			//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sDMText );
            else SendMessageToPC(oPC, sDMText);
         }
      }
      if (ADMIN_DMS_HEAR_META)
      {
         if (CSLVerifyAdminKey(oPC) && CSLGetIsDM(oPC) && (GetLocalString(oPC, "FKY_CHT_META_GRP") != sChannelName) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREMETA")))
         {
            //Fixing
			//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
			//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sDMText );
            else SendMessageToPC(oPC, sDMText);
         }
      }
      oPC = GetNextPC();
   }
}

void CSLHandleMetaMessage(string sMMText, object oMMPC)
{
   if (DISALLOW_METASPEECH_WHILE_DEAD && GetIsDead(oMMPC)) FloatingTextStringOnCreature("<color=indianred>"+"You may not use metachannels while dead!"+"</color>", oMMPC, FALSE);
   else
   {
      string sInvite = GetLocalString(oMMPC, "FKY_CHT_META_GRP");
      if (sInvite != "")
      {
         CSLSetChatSuppress( TRUE );
        
         sMMText = GetStringRight(sMMText, GetStringLength(sMMText) - 2);
         CSLSendMetaMessage(oMMPC, sInvite, sMMText);
      }
      else FloatingTextStringOnCreature("<color=indianred>"+"You must be in a metagroup to send messages on metachannels!"+"</color>", oMMPC, FALSE);
   }
}

void CSLHandleVentrilo(string sVText, object oVPC)
{
   CSLSetChatSuppress( TRUE );
   sVText = GetStringRight(sVText, GetStringLength(sVText) - 2);
   object oTarget = GetLocalObject(oVPC, "FKY_CHT_VENTRILO");
   if (GetIsObjectValid(oTarget)) AssignCommand(oTarget, SpeakString(sVText));
   else FloatingTextStringOnCreature("<color=indianred>"+"Invalid command! You must first select a taget with the DM Voice Thrower item!"+"</color>", oVPC, FALSE);
}





// not used?
void CSLListIgnored(object oPlayer)
{
   string sPlayername;
   string sMessage = "";
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      sPlayername = CSLGetMyPlayerName(oPC);
      if (GetLocalInt(oPlayer, "CHT_IGNORE" + sPlayername)==TRUE)
      {
         sMessage += "<color=indianred>"+"You are currently ignoring "+sPlayername+"."+"</color>"+"\n";
      }
      oPC = GetNextPC();
   }
   if (sMessage != "") SendMessageToPC(oPlayer, sMessage);
   else SendMessageToPC(oPlayer, "<color=indianred>"+"You are currently not ignoring anyone."+"</color>");
}





void CSLGetBanList(object oPlayer)
{
   string sString = "";
   string sList = "";
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      if ( CSLGetIsShoutBanned(oPC) )
      {
         sString = "<color=indianred>"+GetName(oPC)+" is banned from shout."+"</color>"+"\n";
         sList += sString;
      }
      if ( GetLocalInt(oPC, "FKY_CHT_BANDM") == TRUE )
      {
         sString = "<color=indianred>"+GetName(oPC)+" is banned from dm channel."+"</color>"+"\n";
         sList += sString;
      }
      oPC = GetNextPC();
   }
   if (sList != "") SendMessageToPC(oPlayer, sList);
   else SendMessageToPC(oPlayer, "<color=indianred>"+"There are no players playing who are banned from shout or dm channel."+"</color>");
}






// This looks useful, but has too many dependancies
/*
void PartyLevels(object oPC)
{
	//SendMessageToPC(oPC, "Start");
	string sText;
	int bIsADm = CSLGetIsDM(oPC);
	int bSelfDMorAdmin = (CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC));
	object oParty = bIsADm ? GetFirstPC() : GetFirstFactionMember(oPC, TRUE);
	while (GetIsObjectValid(oParty))
	{
		if (oParty!=oPC)
		{
			sText += "<color=pink>" + GetName(oParty) + "</color>";
			sText += " (" + GetName(GetArea(oParty)) + ") ";
			sText += "AC " + IntToString(GetAC(oParty));
			sText += " / HP " + IntToString(GetMaxHitPoints(oParty));
			sText += " / AB " + IntToString(GetTRUEBaseAttackBonus(oParty));
			sText += " <color=brown>" + CSLClassLevels(oParty, TRUE, bSelfDMorAdmin);
			sText += " " + CSLGetSubraceName(GetSubRace(oParty));
			sText += " " + IntToString(GetHitDice(oParty)) + "</color>\n";
		}
		oParty = bIsADm ? GetNextPC() : GetNextFactionMember(oPC, TRUE);
	}
	if (sText=="") 
	{
		sText = "You aren't partying.";
	}
	SendMessageToPC(oPC, sText);
}
*/

/*

// transfered
void ShowInfo(object oPlayer, object oGetInfoFrom) {
   //collect info
   int bSelfDMorAdmin = (CSLVerifyDMKey(oPlayer) || CSLVerifyAdminKey(oPlayer) || (oPlayer==oGetInfoFrom));

   string sName = CSLGetMyName(oGetInfoFrom);
   string sPlayername = CSLGetMyPlayerName(oGetInfoFrom); //GetPCPlayerName(oGetInfoFrom);
   string sKey = CSLGetMyPublicCDKey(oGetInfoFrom); //GetPCPublicCDKey(oGetInfoFrom);
   string sIP = CSLGetMyIPAddress(oGetInfoFrom); //GetPCIPAddress(oGetInfoFrom);
   string sFactionMembers = "";
   string sClasses = CSLClassLevels(oGetInfoFrom, FALSE, bSelfDMorAdmin);
   int nGold = GetGold(oGetInfoFrom);
   int nGoldTotal, iValue, nX;
   if (bSelfDMorAdmin) { // DON'T SUM UP INVENTORY IF NOT GONNA SEE IT
      object oLeader = GetFactionLeader(oGetInfoFrom);
      object oMember = GetFirstFactionMember(oGetInfoFrom);
      while (GetIsObjectValid(oMember)) {
        if (oMember==oLeader) sFactionMembers = "<color=white>"+GetName(oMember)+"</color>"+"<color=cornflowerblue>"+" ["+LFG1+IntToString(GetHitDice(oMember))+"] "+"</color>"+"<color=orange>"+LEADER+"</color>"+"\n"+sFactionMembers;
        else sFactionMembers = sFactionMembers+"<color=white>"+GetName(oMember)+"</color>"+"<color=cornflowerblue>"+" ["+LFG1+IntToString(GetHitDice(oMember))+"] "+"</color>"+"\n";
        oMember = GetNextFactionMember(oGetInfoFrom);
      }
      object oItem = GetFirstItemInInventory(oGetInfoFrom);
      while (GetIsObjectValid(oItem))
      {
         iValue = GetGoldPieceValue(oItem);
         nGoldTotal += iValue;
         oItem = GetNextItemInInventory(oGetInfoFrom);
      }
      for (nX = 0; nX < 14; nX++)
      {
         oItem = GetItemInSlot(nX, oGetInfoFrom);
         iValue = GetGoldPieceValue(oItem);
         nGoldTotal += iValue;
      }
      nGoldTotal += nGold;
   }
   int iLevel = GetHitDice(oGetInfoFrom);
   string sSubrace = CSLGetFullRaceName(oGetInfoFrom);
   string sFaction = SDB_GetFAID(oGetInfoFrom);
   sFaction = (sFaction!="0") ? SDB_FactionGetName(sFaction) : "None";
   if (sSubrace=="") sSubrace = NONE;
   int nXP = GetXP(oGetInfoFrom);
   int nNextXP = (( iLevel * ( iLevel + 1 )) / 2 * 1000 );
   int nXPForNextLevel = nNextXP - nXP;
   if (iLevel==30) nXPForNextLevel = 0;
   string sMessage = "<color=orange>"+NFOHEADER+"</color>"+"\n";
   sMessage += "<color=orange>"+NFO1+"</color>"+"<color=white>"+sName+"</color>"+"\n";
   sMessage += "<color=orange>"+NFO2+"</color>"+"<color=white>"+sPlayername+"</color>"+"\n";
   sMessage += "<color=orange>"+"Faction: "+"</color>"+"<color=white>"+sFaction+"</color>"+"\n";
   sMessage += "<color=orange>"+NFOHD+"</color>"+IntToString(iLevel)+"\n";
   sMessage += "<color=orange>"+"Max Class: "+"</color>"+sClasses+"\n";
   sMessage += "<color=orange>"+NFO11+"</color>"+"<color=slateblue>"+sSubrace+"</color>"+"\n";
   string sPKed = "  Killed: " + IntToString(GetLocalInt(oGetInfoFrom, SDB_PKED));
   string sPKer = "  Kills: " + IntToString(GetLocalInt(oGetInfoFrom, SDB_PKER));
   sMessage += "<color=orange>"+"PvP:"+"</color>"+"<color=palegreen>"+sPKer+"</color>" + "<color=indianred>"+sPKed+"</color>"+"\n";
   if (bSelfDMorAdmin) {
      sMessage += "<color=orange>"+NFO3+"</color>"+"<color=white>"+sKey+"</color>"+"\n";
      sMessage += "<color=orange>"+NFO4+"</color>"+"<color=white>"+sIP+"</color>"+"\n";
      sMessage += "<color=orange>"+NFO6+"</color>"+"<color=yellow>"+IntToString(nXP)+"</color>"+"\n";
      sMessage += "<color=orange>"+NFO7+"</color>"+"<color=indianred>"+IntToString(nXPForNextLevel)+"</color>"+"\n";
      if ( CSLGetIsDM(oPlayer) || CSLVerifyAdminKey(oPlayer) )
      {
      	sMessage += "<color=orange>"+NFO8+"</color>"+"<color=palegreen>"+GetName(GetArea(oGetInfoFrom))+"</color>"+"\n";
      }
      sMessage += "<color=orange>"+NFO9+"</color>"+sFactionMembers;
      sMessage += "<color=orange>"+NFO12+"</color>"+"<color=gold>"+IntToString(nGold)+"</color>"+"\n";
      sMessage += "<color=orange>"+"Net Worth: "+"</color>"+"<color=gold>"+IntToString(nGoldTotal)+"</color>"+"\n";
   }
   SendMessageToPC(oPlayer, sMessage);
}

*/




void CSLSendMetaNotice(string sChannelName, string sMessage)
{
   string sText = "<color=indianred>" + sMessage + "</color>";//red
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      if (GetLocalString(oPC, "FKY_CHT_META_GRP")==sChannelName)
      {
         //Fixing
		//SendChatMessage(oSender, oTarget, CHAT_MODE_SHOUT, string, FALSE );
		//SendChat(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID)
         if (SEND_CHANNELS_TO_CHAT_LOG) SendChatMessage(CSLGetChatMessenger(), oPC, CHAT_MODE_TELL, sText );
         else SendMessageToPC(oPC, sText);
      }
      oPC = GetNextPC();
   }
}



void CSLDisbandMetaChannel(object oPlayer)
{
   string sText = "<color=indianred>" + CSLGetMyName(oPlayer) +" has disbanded the metachannel."+"</color>";//red
   string sChannelName = CSLGetMyPlayerName(oPlayer);
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      if (GetLocalString(oPC, "FKY_CHT_META_GRP")==sChannelName)
      {
      SendMessageToPC(oPC, sText);//tell them
      DeleteLocalString(oPC, "FKY_CHT_META_GRP");//remove them
      }
      oPC = GetNextPC();
   }
}

void CSLListMetaMembers(object oPlayer)
{
   string sText = "<color=indianred>"+"The following people are members of your current metachannel:"+"</color>"+"\n";//red
   string sAdd;
   string sChannelName = GetLocalString(oPlayer, "FKY_CHT_META_GRP");
   if (sChannelName != "")
   {
      object oPC = GetFirstPC();
      while (GetIsObjectValid(oPC))
      {
         if (GetLocalString(oPC, "FKY_CHT_META_GRP")==sChannelName)
         {
            sAdd = "<color=indianred>" + CSLGetMyName(oPC) + "(" + CSLGetMyPlayerName(oPC) + ")"+"</color>"+"\n";
            sText += sAdd;
         }
         oPC = GetNextPC();
      }
      SendMessageToPC(oPlayer, sText);
   }
   else SendMessageToPC(oPlayer, "<color=indianred>"+"Invalid Command! You are not currently in a metachannel."+"</color>");
}


void CSLCheckIfNewChannel(string sChannel)
{
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
      if (CSLGetMyPlayerName(oPC)==sChannel)//if the channel is named after them
      {
         if (GetLocalString(oPC, "FKY_CHT_META_GRP")=="")//and they are not in it
         {
            SetLocalString(oPC, "FKY_CHT_META_GRP", sChannel);//then its a new channel, add them to the channel
         }
         break;
      }
      oPC = GetNextPC();
   }
}

void CSLShoutBlock(object oSBPC, int nSBChannel)
{
   if (nSBChannel==2)
   {
      CSLSetChatSuppress( TRUE ); //suppress emote speech no matter what, helps avoid circumvention of shout bans
      FloatingTextStringOnCreature("<color=indianred>"+"Invalid Emote!"+"</color>", oSBPC, FALSE);//no match
   }
}


void CSLDoSpamBan(object oSBPC, string sSBText)
{
   string sKey = CSLGetMyPublicCDKey(oSBPC);
   CSLSetChatSuppress( TRUE );
   CSLSetIsShoutBanned( oSBPC );
   //SDB_SetIsShoutBanned(oSBPC, TRUE, TRUE); // need to integrate with DB somehow sideways
   //capture the first message that got them busted so that that can't overwrite with something
   //benign to show the dms to get unbanned so they can try again
   if (GetLocalString(oSBPC, "FKY_CHT_BANREASON")=="") SetLocalString(oSBPC, "FKY_CHT_BANREASON", sSBText);
   // need to see about the above working
   SendMessageToPC(oSBPC, "<color=indianred>"+"You have been permanently banned from using the shout channel. If you feel this was a mistake, please contact a DM. You can still use the !lfg command up to 3 times per reset."+"</color>");//tell em
}

string CSLProcessChatsInMessage( string sIn, object oPC = OBJECT_SELF )
{
	int iPosition = FindSubString( sIn, CHAT_EMOTE_SYMBOL );
	int iWordCount = 0;
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLProcessChatsInMessage sIn="+sIn+" iPosition="+IntToString(iPosition)+"</color>");
	if ( iPosition == -1 ) // no more to find
	{ 
		return ""; // delimiter not present, must be a single element
	}
	
	// this is being added on top to the rest, see if it's going to make sense
	// thinking just deal with the message in bursts and add these around as i find emotes in the message
	string sEmoteStart = "<color="+CHAT_COLOR_EMOTE+"><i>*";
	string sEmoteEnd = "*</i></color>";
	string sMessageWithColor = "";
	string sPreviousNonEmoteVerbiage;
	
	int iLastPosition = 0;
	//string sProccessedIn =  sIn;
	string sFoundEmote, sFoundEmotes;
	int nLength;
	
	//sMessageWithColor += GetStringLeft( sIn, iPosition );
	
	while( iPosition > -1 )
	{	
		
		sPreviousNonEmoteVerbiage = GetSubString(sIn, iLastPosition, iPosition-iLastPosition );
		iWordCount += CSLGetWordCount( sPreviousNonEmoteVerbiage, 3 );
		sMessageWithColor += sPreviousNonEmoteVerbiage;
		
		sFoundEmote = CSLStringGetFirstWord(sIn, iPosition+1);
		sFoundEmotes = CSLNth_Push(sFoundEmotes, sFoundEmote );
		
		// add the emote
		sMessageWithColor += sEmoteStart+CSLTrim(sFoundEmote,"*")+sEmoteEnd;
		
		// find next asterisk
		//SendMessageToPC(GetFirstPC(),CSLColorText("Debug: CSLProcessChatsInMessage sFoundEmote="+sFoundEmote+" added to "+sFoundEmotes+" iPosition="+IntToString(iPosition)+" to create the following color string =",-1, CHAT_COLOR_DMWHISPER)+sMessageWithColor );
		iLastPosition = iPosition+GetStringLength(sFoundEmote)+1;
		iPosition = FindSubString( sIn, CHAT_EMOTE_SYMBOL, iLastPosition+1 );
	}
	sPreviousNonEmoteVerbiage = GetSubString(sIn, iLastPosition, GetStringLength(sIn)-iLastPosition);
	iWordCount += CSLGetWordCount( sPreviousNonEmoteVerbiage, 3 );
	sMessageWithColor += sPreviousNonEmoteVerbiage;
	
	SetLocalInt( oPC, "CSL_CURRENTWORDCOUNT", iWordCount);
	
	SetLocalString( oPC, "CSL_CURRENTCHATSTRING", sMessageWithColor );
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLProcessChatsInMessage Returning="+sFoundEmotes+" iPosition="+IntToString(iPosition)+"</color>");
		
	return sFoundEmotes;
}

void CSLRunEmoteList( object oSender, object oTarget, int nChannel, string sEmoteList )
{
		//SendMessageToPC( GetFirstPC(), "CSLRunEmoteList: "+sEmoteList);
		int iEmoteCount = CSLNth_GetCount( sEmoteList );
		string sEmote;
		int i;
		for ( i = 1; i <= iEmoteCount; i++)
		{
			sEmote = CSLNth_GetNthElement( sEmoteList, i );
			//SendMessageToPC( GetFirstPC(), "CSLRunEmoteList: sEmote="+sEmote);
			if ( sEmote != "" )
			{
				DelayCommand( 3.0f*(i-1), CSLExecuteChatScript( "emote", oSender, oTarget, nChannel, sEmote ) );
			}
		}

}
/*
void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TranslateToSpeakers Start", oSpeaker ); }
	//Purpose: Sends sTranslate to any nearby speakers of sLang
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/10/7
	int nTest;
	int n=1;
	if ( sLang=="common" || sLang=="") return;
	{
		//CSLMessage_SendText(oUI, GetName(oSpeaker) + " : " + sTranslate, FALSE, COLOR_BROWN);
		SendChatMessage(oSpeaker, OBJECT_INVALID, CHAT_MODE_TALK, CSLColorText(sTranslate, COLOR_BROWN), FALSE );
	}
			
	object oListener = GetFirstPC();
	while (GetIsObjectValid(oListener))
	{
		if (GetArea(oSpeaker)==GetArea(oListener))
		{
			if ((oListener!=oSpeaker) && GetDistanceBetween(oSpeaker, oListener)<20.0)
			{
				if (CSLLanguageLearned(oListener, sLang) || CSLGetIsDM(oListener) || GetIsDMPossessed(oListener))
				{ // Speaks language
					SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "Translated: " + CSLStringToProper(sLang) + " " + sTranslate, FALSE );
					//CSLMessage_SendText(oListener, " " + GetName(oSpeaker) + " " + "Translated: " + CSLStringToProper(sLang) + " " + sTranslate, FALSE, COLOR_GREY);
				}  // Speaks language
				else
				{	
					if ( CSLGetPreferenceSwitch("LanguageAllowLoreToDecipher", FALSE )  ==TRUE) //Qk: added as option
					{
						nTest = (d20() + GetSkillRank(SKILL_LORE, oListener));
						if (nTest>20)
						{
							SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, CSLColorText("Lore Check Passed: Language Translated.", COLOR_GREY), FALSE );	
							SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, CSLColorText(" " + "Translated: " + sLang + " " + sTranslate, COLOR_GREY), FALSE );
							
							//CSLMessage_SendText(oListener, "Lore Check Passed: Language Translated.", FALSE, COLOR_GREY);
							//CSLMessage_SendText(oListener, GetName(oSpeaker) + " " + "Translated: " + sLang + " " + sTranslate, FALSE, COLOR_GREY);
						}
					}
				}		
			}
		}
		oListener = GetNextPC();
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TranslateToSpeakers End", oSpeaker ); }
}
*/





int CSLHandleChat( object oSender, object oTarget, int nChannel, string sMessage )
{
	int iShowMessage=TRUE;
	int iOocText = FALSE;
	int iEmotes = FALSE;
	string sTranslate, sEmoteList;
	object oTool;
	int iWordCount = 0;
	
	CSLSetChatSuppress( FALSE );
	
	
	
	
	int bShoutLimitedToLocalArea = CSLGetPreferenceSwitch( "ChatShoutLimitToLocalArea", FALSE);
	float fShoutLimitRange = CSLGetPreferenceFloat( "ChatShoutLimitRange", 40.0f);
	
	// go ahead and figure out the speaker at this point, so we can have the proper language up front
	object oSpeaker = oSender;
	object oThrower = OBJECT_INVALID;
	if ( CHAT_VOICETHROWING_ENABLED && GetLocalInt( oSender, "CHAT_THROWINGVOICE" ) )
	{
		oThrower = GetPlayerCurrentTarget( oSender );
		//SendMessageToPC( oSender, "Master is "+GetName(GetMaster(oThrower))+"Thrower is "+GetName(oThrower)+" ObjectType: "+ IntToString(GetObjectType( oThrower ) ) );
		if ( GetIsObjectValid( oThrower ) && GetObjectType( oThrower ) == OBJECT_TYPE_CREATURE && oThrower != oSender && ( CSLGetIsDM( oSender ) || GetMaster(oThrower) == oSender ) )
		{
			oSpeaker = oThrower;
		}
		else
		{
			oThrower = OBJECT_INVALID; // not a valid creature so lets dispose of it
		}
		if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Throwing voice - thrower to oThrower="+GetName(oThrower), -1, CHAT_COLOR_DEBUG) ); }
	}
	
	string sLang = CSLLanguageGetValidLanguageForSpeaker( oSpeaker, GetLocalString(oSpeaker, DMFI_LANGUAGE_TOGGLE) );
	string sAccent = "";
	
	// turns off tranlation if it is prepended with ESCAPE_STRING
	if ( GetSubString(sMessage, 0, GetStringLength(ESCAPE_STRING) ) == ESCAPE_STRING )
    {
    	sMessage = GetSubString(sMessage, GetStringLength(ESCAPE_STRING), GetStringLength(sMessage)-GetStringLength(ESCAPE_STRING) );
    	sLang = "";
    	sAccent = "";
    }
	
	
	if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: sLang= "+sLang+" with "+GetName(oSpeaker), -1, CHAT_COLOR_DEBUG) ); }
	
	 /// this is a sanity cap, likely not needed at this point
    DelayCommand( 6.0f, CSLDecrementLocalInt_Void(oSender, "CSL_CHATS_SENT", 1, TRUE ) );
    int iChatsSent = CSLIncrementLocalInt(oSender, "CSL_CHATS_SENT", 1);
    if ( iChatsSent > 25 )
    {
        // cancel actions perhaps
        AssignCommand(oSender, ClearAllActions());
        return FALSE;
    }
    /// end of added command
    
    int iBroadcastViaSendMessage = FALSE;
    float fBroadcastRange = 20.0f;
    
    
    
    
    
	//////////////////////////////////Declarations//////////////////////////////////
	if (GetLocalInt(oSender, "CHATSKIP")) // TO ABORT RECURSION WHEN REISSUING PARTY CHAT, probably can deprecate now
	{ 
		DeleteLocalInt(oSender, "CHATSKIP");  
		return FALSE;
	}
	string sType = GetSubString(sMessage, 0, 1);
	
	//SendMessageToPC( oSender, "Mesage Type is "+sType );
	int bLogIt = TEXT_LOGGING_ENABLED;
	
	if ( CHAT_EMOTES_ENABLED && sType == CHAT_EMOTE_SYMBOL && FindSubString( sMessage, " " ) == -1 )
	{
		//if ( iShowMessage && CHAT_VOICETHROWING_ENABLED && GetLocalInt( oSender, "CHAT_THROWINGVOICE" ) )
		//{
		
		//object oThrower = GetPlayerCurrentTarget( oSender );
		//SendMessageToPC( oSender, "Master is "+GetName(GetMaster(oThrower))+"Thrower is "+GetName(oThrower)+" ObjectType: "+ IntToString(GetObjectType( oThrower ) ) );
		if ( GetIsObjectValid( oThrower )  ) // && GetObjectType( oThrower ) == OBJECT_TYPE_CREATURE && oThrower != oSender
		{
			//if ( CSLGetIsDM( oSender ) || GetMaster(oThrower) == oSender )
			//{
				//int iThrowerIsThrowing = GetLocalInt( oThrower, "CHAT_THROWINGVOICE" )
				//if ( iThrowerIsThrowing )
				//{
				//	SetLocalInt( oThrower, "CHAT_THROWINGVOICE", FALSE );
				//}
				
				CSLExecuteChatScript( "emote", oThrower, oTarget, nChannel, GetStringRight(sMessage, GetStringLength(sMessage) - 1) );
				
				iShowMessage = FALSE;
				
				//if ( iThrowerIsThrowing )
				//{
				//	SetLocalInt( oThrower, "CHAT_THROWINGVOICE", TRUE );
				//}
			//}
		}
		else if ( iShowMessage )
		{
			CSLExecuteChatScript( "emote", oSender, oTarget, nChannel, GetStringRight(sMessage, GetStringLength(sMessage) - 1) );
		}
		iShowMessage = FALSE;
		bLogIt = FALSE;
	}
	else if (sType == CHAT_COMMAND_SYMBOL)
	{
		CSLExecuteChatScript( "cmd", oSender, oTarget, nChannel, GetStringRight(sMessage, GetStringLength(sMessage) - 1) );
		iShowMessage = FALSE;
	}
	else if ( CSLGetIsDM( oSender ) && GetSubString(sMessage, 0, GetStringLength(CHAT_DMCOMMAND_SYMBOL) ) == CHAT_DMCOMMAND_SYMBOL )
	{
		CSLExecuteChatScript( "dm", oSender, oTarget, nChannel, GetStringRight(sMessage, GetStringLength(sMessage) - GetStringLength(CHAT_DMCOMMAND_SYMBOL) ) );
		iShowMessage = FALSE;
	}
	else if ( CHAT_DMRUNSCRIPT_ENABLED && CSLGetIsDM( oSender ) && GetSubString(sMessage, 0, GetStringLength(CHAT_RUNSCRIPT_SYMBOL) ) == CHAT_RUNSCRIPT_SYMBOL )
	{
		// this runs a raw script
		//CSLExecuteChatScript( "dm", oSender, oTarget, nChannel,  );
		object oScriptTarget;
		if ( nChannel == CHAT_MODE_TELL )
		{
			oScriptTarget == oTarget;
		}
		else
		{
			oScriptTarget = GetPlayerCurrentTarget( oSender );
		}
		
		if ( !GetIsObjectValid( oScriptTarget ) )
		{
			oScriptTarget == oSender;
		}
		
		DelayCommand( 0.0f, ExecuteScript( GetStringRight(sMessage, GetStringLength(sMessage) - GetStringLength( CHAT_RUNSCRIPT_SYMBOL ) ),oScriptTarget) );
		
		iShowMessage = FALSE;
	}
	else if (sType == CHAT_METACHANNEL_SYMBOL)
	{
		// meta channels
		sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 1);
		string sSort = GetStringLeft(sMessage, 2);
		if (ENABLE_METACHANNELS && sSort == "m ")
		{
			CSLHandleMetaMessage(sMessage, oSender);//must be a space after the /m
		}
		else if ((CSLVerifyDMKey(oSender) || CSLVerifyAdminKey(oSender)) && sSort == "v ")
		{
			CSLHandleVentrilo(sMessage, oSender);//must be a space after the /v
		}
		else
		{
			FloatingTextStringOnCreature("<color=indianred>"+"Invalid Channel Designation!"+"</color>", oSender, FALSE);
		}
	}
	else if ( nChannel == CHAT_MODE_TALK || nChannel == CHAT_MODE_WHISPER || ( nChannel == CHAT_MODE_SHOUT && bShoutLimitedToLocalArea ) )
	{
		if( CSLGetPreferenceSwitch("SilenceBlocksChat", FALSE ) )
		{
			if (CSLGetHasEffectType( OBJECT_SELF, EFFECT_TYPE_SILENCE ))
			{
				sMessage = "Mmmph";
			}
		}
		
		
		
		if (ENABLE_METALANGUAGE_CONVERSION)
		{
			if (GetStringLowerCase(sMessage)=="lol" )
			{
				//SpeakString(LOL);
				CSLEmoteDoLaugh(oSender);
				// iShowMessage = FALSE;
			}
		}
         
		if ( FindSubString(sMessage, CHAT_OOC_SYMBOL1) != -1 || FindSubString(sMessage, CHAT_OOC_SYMBOL2) != -1 || FindSubString(sMessage, CHAT_OOC_SYMBOL3) != -1 || FindSubString(sMessage, CHAT_OOC_SYMBOL4) != -1 || FindSubString(sMessage, "ooc") != -1 || FindSubString(sMessage, "OOC") != -1 )
		{
			iOocText = TRUE;
			sMessage = CSLColorText(sMessage, -1, CHAT_COLOR_OOC );
		}
		else if ( FindSubString(sMessage, CHAT_EMOTE_SYMBOL) != -1 )
	    {
			iEmotes = TRUE;
			
			sEmoteList = CSLProcessChatsInMessage( sMessage, oSender ); // note has code to count words 3 characters or longer, but skips the emotes
			if ( sEmoteList != "" )
			{
				sMessage = GetLocalString( oSender, "CSL_CURRENTCHATSTRING" );
			}
			iWordCount = GetLocalInt( oSender, "CSL_CURRENTWORDCOUNT" );
		}
		else
		{
			iWordCount = CSLGetWordCount( sMessage, 3 ); // counts words 3 characters or longer
		}
		
		
		if ( nChannel == CHAT_MODE_SHOUT )
		{
			iBroadcastViaSendMessage = TRUE;
			fBroadcastRange = fShoutLimitRange;
			sMessage = "<b>"+sMessage+"</b>";
			nChannel = CHAT_MODE_TALK;
		}
		
		/////
	}
	else if ( nChannel == CHAT_MODE_SHOUT )
	{
		string sLC = GetStringLowerCase(sMessage);
		
		if (CSLGetIsShoutBanned(oSender))
		{
			CSLSetChatSuppress( TRUE );
			SendMessageToPC(oSender, "<color=indianred>"+"You are banned from using the shout channel."+"</color>");//tell em
		}
		else if( CSLGetPreferenceSwitch("SilenceBlocksChat", FALSE ) && CSLGetHasEffectType( oSender, EFFECT_TYPE_SILENCE ) )
		{
			CSLSetChatSuppress( TRUE );
			SendMessageToPC(oSender, "Mmmph" );
		}
		else if (FindSubString(sLC, "lfp")!=-1 || FindSubString(sLC, "lfg")!=-1 || (FindSubString(sLC, "look")!=-1 && (FindSubString(sLC, "group")!=-1 || FindSubString(sLC, "party")!=-1)))
		{
			//LookingForPartyShout(); //
			//
			SendMessageToPC(OBJECT_SELF, "Use the <color=orange>!lfp</color> or <color=orange>!lfg</color> chat command to find a party. Type <color=orange>!listcommands</color> for the full list of chat commands available.");
		}
		else if ( CSLGetPreferenceSwitch( "ChatShoutsAnnounceArea", FALSE) && !CSLGetIsDM( oSender, FALSE ) ) // SHOUT CHANNEL, ADD LOCATION // if (!CSLVerifyDMKey(oSender) && !CSLVerifyAdminKey(oSender))
		{ 
			SendChatMessage(oSender, OBJECT_INVALID, CHAT_MODE_SHOUT, "["+GetName(GetArea(oSender))+"] "+CSLColorText(sMessage,-1, CHAT_COLOR_SHOUT ), FALSE );
			iShowMessage = FALSE;
         }
	}
	//else if ( nChannel == CHAT_MODE_WHISPER )
	//{
	//
	//}
	else if ( nChannel == CHAT_MODE_TELL )
	{
        if ( !GetIsObjectValid( oTarget ) )
        { 
			SendMessageToPC(oSender, "<color=indianred>" + "Target is no longer available"+"</color>");//tell em
			CSLSetChatSuppress( TRUE );
		}
		else if ( !GetIsLocationValid(GetLocation(oTarget) ) || GetLocalInt( oTarget, "TRANSITION") ) // 
        { 
			SendMessageToPC(oSender, "<color=indianred>" + "Target is in transition"+"</color>");//tell em
			// probably do a delay command to give them message when they show back up
			CSLSetChatSuppress( TRUE );
		}
		
		if (GetLocalInt(oTarget, "FKY_CHT_IGNORE" + CSLGetMyPlayerName(oSender) ))//check for ignore
         {
            CSLSetChatSuppress( TRUE );
            SendMessageToPC(oSender, "<color=indianred>" + GetName(oTarget)+" is ignoring your tells."+"</color>");//tell em
         }
         
        if( CSLGetPreferenceSwitch("SilenceBlocksChat", FALSE ) )
		{
			if (CSLGetHasEffectType( oSender, EFFECT_TYPE_SILENCE ))
			{
				CSLSetChatSuppress( TRUE );
				SendMessageToPC(oSender, "Mmmph" );
			}
		}
		
	}
	//else if ( nChannel == CHAT_MODE_SERVER )
	//{
	//
	//}
	//else if ( nChannel == CHAT_MODE_PARTY )
	//{
	//
	//}
	else if ( nChannel == CHAT_MODE_SILENT_SHOUT ) // DM_Channel
	{
		if (GetLocalInt(oSender, "FKY_CHT_BANDM"))//check for DM ban
		{
			CSLSetChatSuppress( TRUE );
			SendMessageToPC(oSender, "<color=indianred>"+"You are currently banned from using the DM channel. The ban will be lifted next reset."+"</color>");//tell em
		}
		if (DM_PLAYERS_HEAR_DM) CSLMessage_DMChannelForwardToDMs(oSender, sMessage );//check for dm players hearing dm
		if (ADMIN_PLAYERS_HEAR_DM) CSLMessage_DMChannelForwardToAdmins(oSender, sMessage );//check for admin players hearing dm
		
		// relay so can see things sent to dms
		if ( !GetIsDM(oSender) && !GetIsDMPossessed(oSender)  )
		{
			SendChatMessage(oSender, oSender, CHAT_MODE_TELL, CSLColorText( "[DM] "+sMessage, -1, CHAT_COLOR_TELLTODM ), FALSE );
		}
		//	SendMessageToPC( oSender, GetName(oSender)+": <color=green>[DM]"+sMessage+"</green>");
	}	//}
	//
	//else
	//{
	//	//string sLogMessageTarget = "->" + CSLGetMyName(oTarget) + "(" + CSLGetMyPlayerName(oTarget) + ")";
	//	CSLHandleOtherSpeech(oSender, oTarget, sMessage, nChannel, sLogMessageTarget);
	//}
	
	if (ENABLE_PERMANENT_CHANNEL_MUTING && CSLGetIsChannelSuppressed(nChannel) && (!CSLVerifyDMKey(oSender)) && (!CSLVerifyAdminKey(oSender)))
	{
		iShowMessage = FALSE;
	}
	else if (DISALLOW_SPEECH_WHILE_DEAD && CSLGetIsChannelDeadSuppressed(nChannel) && GetIsDead(oSender) && (!CSLVerifyDMKey(oSender)) && (!CSLVerifyAdminKey(oSender)))
	{
		iShowMessage = FALSE;
	}
	
	
	if ( CSLGetChatSuppress() == TRUE )
	{
		iShowMessage = FALSE;
	}
	

	if ( iShowMessage && sLang != "" && iOocText == FALSE && CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) && ( nChannel == CHAT_MODE_TALK || nChannel == CHAT_MODE_WHISPER ) )
	{
		//sLang = DMFI_NewLanguage(sLang);
		//sTranslate = sMessage; // save original
		
		// SendMessageToPC(oSender,"<color=SlateGray>Debug: Translating "+sLang+"</color>");
		if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Using Language "+sLang+" for message "+sMessage, -1, CHAT_COLOR_DEBUG) ); }
		sTranslate = CSLLanguageTranslate( sMessage, sLang );
		//sTranslate = DMFI_ProcessLanguage(sMessage, sLang, CSLDMFI_GetTool(oSender) );
	}
	
	// this is just used for debugging, so just remove later
	string sTargetName = GetName(oTarget);
	if ( DEBUGGING > 1 )
	{
		if ( nChannel == CHAT_MODE_SILENT_SHOUT )
		{
			sTargetName = "DM";
		}
		else if ( nChannel == CHAT_MODE_TELL )
		{
			sTargetName = GetName(oTarget);
		}
		else if ( nChannel == CHAT_MODE_TALK || nChannel == CHAT_MODE_WHISPER )
		{
			sTargetName = "To Those Nearby";
		}
	}
	
	if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: iShowMessage= "+IntToString(iShowMessage)+" with "+GetName(oThrower), -1, CHAT_COLOR_DEBUG) ); }
	// i already did the logic for IF the oSender is throwing their voice, so all i have to do is see if oThrower is a valid object
	if ( iShowMessage && GetIsObjectValid( oThrower ) )
	{
		int iThrowerIsThrowing = GetLocalInt( oThrower, "CHAT_THROWINGVOICE" );
		if ( iThrowerIsThrowing )
		{
			SetLocalInt( oThrower, "CHAT_THROWINGVOICE", FALSE );
		}
		//SendMessageToPC(oSender,"Throwers name is "+GetName(oThrower));
		if ( sTranslate != "" )
		{
			iShowMessage = FALSE;
			//AssignCommand(oThrower, SpeakString(sTranslate));
			if ( sTranslate == "<SIGNEMOTES>" )
			{
				CSLEmoteDoSigning(oThrower);
			}
			else
			{
				if ( iBroadcastViaSendMessage ) //  
				{
					iShowMessage = FALSE;
					
					///string sSentMessage = "<color=pink>"+GetName(oThrower)+":</color> "+sMessage;
					CSLChatBroadcastMessageAtLocation( sTranslate, GetLocation(oThrower), oThrower, fBroadcastRange );
	
					//SendChatMessage(oThrower, oTarget, nChannel, sMessage ); // this is likely broken for DM's, will have to look at it, but since relayed it might work
					
					if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Manually Broadcast Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG)  ) ; }
					if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
					bLogIt = FALSE;
				}
				else
				{
					//AssignCommand(oThrower, SpeakString(sTranslate));
					SendChatMessage(oThrower, OBJECT_INVALID, nChannel, sTranslate, FALSE ); // this is either talk or whisper channel
				}
			}
			bLogIt = FALSE;
			//SendChatMessage(oThrower, oTarget, CHAT_MODE_TALK, sTranslate, FALSE );
			
			// SPELL_COMPREHEND_LANGUAGES
			DelayCommand( 0.0f, CSLLanguageTranslateToListeners( oThrower, sTranslate, sMessage, sLang ) );
			//oSender = oThrower;
		}
		else // 
		{
			if ( sLang == "" || sLang == "common" )
			{
				
				sAccent = GetLocalString(oSpeaker, DMFI_ACCENT_TOGGLE);
				if ( sAccent != "" )
				{ 
					if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Using Accent "+sAccent+" for message "+sMessage, -1, CHAT_COLOR_DEBUG) ); }
					sMessage = CSLLanguageTranslate( sMessage, sAccent );
				}
			}
			
			if ( iBroadcastViaSendMessage ) //  
			{
				iShowMessage = FALSE;
				
				///string sSentMessage = "<color=pink>"+GetName(oThrower)+":</color> "+sMessage;
				CSLChatBroadcastMessageAtLocation( sMessage, GetLocation(oThrower), oThrower, fBroadcastRange );

				//SendChatMessage(oThrower, oTarget, nChannel, sMessage ); // this is likely broken for DM's, will have to look at it, but since relayed it might work
				
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Manually Broadcast Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG)  ) ; }
				if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
				bLogIt = FALSE;
			}
			else if ( nChannel == CHAT_MODE_TELL ) //  
			{
				iShowMessage = FALSE;
				SendChatMessage(oThrower, oTarget, nChannel, sMessage ); // this is likely broken for DM's, will have to look at it, but since relayed it might work
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Thrown Tell Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG)  ) ; }
				if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
				bLogIt = FALSE;
			}
			else if ( nChannel == CHAT_MODE_TALK )
			{
				iShowMessage = FALSE;
				//AssignCommand(oThrower, SpeakString(sMessage, TALKVOLUME_TALK ));
				SendChatMessage(oThrower, OBJECT_INVALID, CHAT_MODE_TALK, sMessage, FALSE );
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Thrown Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG) ); }
				if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
				bLogIt = FALSE;
			}
			else if ( nChannel == CHAT_MODE_WHISPER )
			{
				iShowMessage = FALSE;
				//AssignCommand(oThrower, SpeakString(sMessage, TALKVOLUME_WHISPER ));
				SendChatMessage(oThrower, OBJECT_INVALID, CHAT_MODE_WHISPER, sMessage, FALSE );
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Thrown Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG) ); }
				if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
				bLogIt = FALSE;
	
			}
			else if ( nChannel == CHAT_MODE_SHOUT )
			{
				iShowMessage = FALSE;
				//AssignCommand(oThrower, SpeakString(sMessage, TALKVOLUME_SHOUT ));
				SendChatMessage(oThrower, OBJECT_INVALID, CHAT_MODE_SHOUT, sMessage, FALSE );
				
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Sending Thrown Message "+sMessage+" From "+GetName(oThrower)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG) ); }
				if ( iEmotes ) { CSLRunEmoteList(oThrower, oTarget, nChannel, sEmoteList ); }
				bLogIt = FALSE;
			}
		}
		
		if ( iThrowerIsThrowing )
		{
			SetLocalInt( oThrower, "CHAT_THROWINGVOICE", TRUE );
		}
	}
		
	
	if ( iShowMessage )
	{
		// send the translated message
		iShowMessage = FALSE;
		if ( GetIsDM(oSender) && nChannel == CHAT_MODE_TELL )
		{
			iShowMessage = TRUE; // fixes bug where dm tells would not work, note that i basically have to avoid even using them to begin with
		}
		
		
		if ( sLang == "" || sLang == "common" && iOocText == FALSE )
		{
			sAccent = GetLocalString(oSender, DMFI_ACCENT_TOGGLE);
			if ( sAccent != "" )
			{ 
				if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug: Using Accent "+sAccent+" for message "+sMessage, -1, CHAT_COLOR_DEBUG) ); }
				sMessage = CSLLanguageTranslate( sMessage, sAccent );
			}
		}
	
		if ( GetIsDM(oSender) )
		{
			if ( nChannel == CHAT_MODE_TALK )
			{
				sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_DMTALK );
			}
			else if ( nChannel == CHAT_MODE_SHOUT )
			{
				sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_DMSHOUT );
			}
			else if ( nChannel == CHAT_MODE_WHISPER )
			{
				sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_DMWHISPER );
			}
		}
		else if ( nChannel == CHAT_MODE_WHISPER )
		{
			sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_WHISPER );
		}
		else if ( nChannel == CHAT_MODE_SILENT_SHOUT)
		{
			sMessage = CSLColorText( sMessage,-1, CHAT_COLOR_DMCHANNEL );
		}
		
		if ( sTranslate != "" )
		{
			if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug:Sending Translated Message "+sMessage+" From "+GetName(oSender)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG) ); }
			if ( iShowMessage == FALSE )
			{
				if ( sTranslate == "<SIGNEMOTES>" )
				{
					CSLEmoteDoSigning(oSender);
				}
				else
				{
					if ( iBroadcastViaSendMessage ) //  
					{
						iShowMessage = FALSE;
						DelayCommand( 0.0f, CSLChatBroadcastMessageAtLocation( sTranslate, GetLocation(oSender), oSender, fBroadcastRange ) );
					}
					else
					{
						iShowMessage = FALSE;
						SendChatMessage(oSender, oTarget, nChannel, sTranslate, FALSE );
					}
				}				
				DelayCommand( 0.0f, CSLLanguageTranslateToListeners( oSender, sTranslate, sMessage, sLang ) );
				
			}
			if ( iEmotes ) { CSLRunEmoteList(oSender, oTarget, nChannel, sEmoteList ); }
			
			
			//DMFI_TranslateToSpeakers(oTarget, sMessage, sLang, oSender);
		}
		else
		{
			if ( DEBUGGING > 2 ) { SendMessageToPC(oSender,CSLColorText( "Debug:Sending Message "+sMessage+" From "+GetName(oSender)+" to "+sTargetName,-1,CHAT_COLOR_DEBUG) ); }			
			if ( iShowMessage == FALSE )
			{
				if ( iBroadcastViaSendMessage ) //  
				{
					iShowMessage = FALSE;
					DelayCommand( 0.0f, CSLChatBroadcastMessageAtLocation( sMessage, GetLocation(oSender), oSender, fBroadcastRange ) );
				}
				else
				{
					SendChatMessage(oSender, oTarget, nChannel, sMessage, FALSE );
				}
			}
			if ( iEmotes ) { CSLRunEmoteList(oSender, oTarget, nChannel, sEmoteList ); }
		}
		
	
		
	}
	
	
	if ( iWordCount > 0 )
	{		
		int iTotalWords = CSLIncrementLocalInt( oSender, "CSL_CHATWORDCOUNT", iWordCount);
		int iUnRewardedXPWordCount = iTotalWords-GetLocalInt( oSender, "CSL_CHATWORDCOUNTWITHXP" );

		int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
		int iLastSpokeRound = GetLocalInt( oSender, "CSL_CHAT_LASTSPOKE_ROUND" );
		int iLastRewardedRound = GetLocalInt( oSender, "CSL_CHAT_LASTREWARDED_ROUND" );
		if ( iCurrentRound == 0 )
		{
			// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
			// attached to environment since that is doing other work this is combined with
			CSLEnviroGetControl();
		}
		
		
		// preferences to be stored in cslpreferences or on module, 0 turns it off
		int iRequiredWordCount = CSLGetPreferenceInteger( "ChatXPWordCountRequired", 0); // get preference for required new words, this being zero turns it off
		if ( iRequiredWordCount > 0 )
		{
			int iXPChance = CSLGetPreferenceInteger( "ChatXPPercentageChance", 100);
			if ( iXPChance > 0 )
			{
				
				int iRoundsBetweenXPInterval = CSLGetPreferenceInteger( "ChatXPRequiredRoundsInterval", 50); // get preference
				
				
				if (
					iUnRewardedXPWordCount > iRequiredWordCount && 
				
					( iLastRewardedRound == 0 || (iCurrentRound-iLastRewardedRound ) > iRoundsBetweenXPInterval )
				) // 50 is 50 rounds
				{
					
					if ( iXPChance == 100 || iXPChance >= d100()  )
					{
						int iChatXPMinimum = CSLGetPreferenceInteger( "ChatXPMinimumReward", 10); // get preference
						int iChatXPMaximum = CSLGetPreferenceInteger( "ChatXPMaximumReward", 15); // get preference
						int iXPReward = CSLRandomBetween(iChatXPMinimum-1, iChatXPMaximum+1 ); // not that it adjusts by one since it returns what is BETWEEN, not the actual numbers
						if ( iXPReward > 0 )
						{
							SendMessageToPC(oSender, "You've been awarded "+IntToString(iXPReward)+" experience for role playing.");
							GiveXPToCreature(oSender, iXPReward);	//Awards 10-100 exp
						}
					}
					SetLocalInt( oSender, "CSL_CHATWORDCOUNTWITHXP", iTotalWords );
					SetLocalInt( oSender, "CSL_CHAT_LASTREWARDED_ROUND", iCurrentRound );
				}
			}
		}
		SetLocalInt( oSender, "CSL_CHAT_LASTSPOKE_ROUND", iCurrentRound );
	}
	
	if (bLogIt ) // logs message to database
	{
		// requires NWNX, database and table to be installed to receive this
		CSLLogMessageToDatabase( sType, oSender, oTarget, nChannel, sMessage );
	}
	// SendMessageToPC(oSender,"done");
	return iShowMessage; //iShowMessage will always be false now;
}

/*
void testing ( string sInput )
{
	int nState;
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oTarget, oTool;
	string sLang = GetLocalString(OBJECT_SELF, DMFI_LANGUAGE_TOGGLE);
	string sLangTest = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	string sConvertUsing, sTest;
	
	//CSLMessage_SendText(oPC, "DEBUGGING: sLang from ObjectSelf: " + sLang + " : " +GetName(OBJECT_SELF));	
	

	oTarget = GetPlayerCurrentTarget(oPC);
	
	
	SendChatMessage(oPC, OBJECT_INVALID, CHAT_MODE_TALK, sInput, TRUE );

	// Shortcut to run scripts from the text entry box
	if (GetStringLeft(sInput, 1)==CHAT_RUNSCRIPT_SYMBOL)
	{
		if (CSLGetIsDM(OBJECT_SELF) || DMFI_PC_RUNSCRIPT_ALLOWED)
		{
			sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
			
			if (DMFI_RUNSCRIPT_PREFIX!="")
			{
				sTest = GetStringLeft(sInput, GetStringLength(DMFI_RUNSCRIPT_PREFIX));
				if (sTest!=DMFI_RUNSCRIPT_PREFIX)
					return;
			}
			SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
			ExecuteScript(sInput, OBJECT_SELF);
		}
		return;
	}	

	if (GetStringLeft(sInput, 1)==CHAT_COMMAND_SYMBOL)
	{
		// outside standards are bit different for simplicity for
		// the end user.
		SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
		SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
		SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
		SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
		nState = DMFI_RunCommandPlugins(OBJECT_SELF);
		
		if (!nState)
		{
			// Redefine so we can run internal code via our standard
			oPC = OBJECT_SELF;
			oTool = CSLDMFI_GetTool(oPC);
			sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
			sInput = CSLStringSwapChars(sInput, "_", " ");
				
			oPC = DMFI_UITarget(oPC, oTool);
			DMFI_DefineStructure(oPC, sInput);
			DMFI_RunCommandCode(oTool, oPC, sInput);
			
		}	
		DeleteLocalInt(GetModule(), "Override");
		return;
	}	

	if (CSLGetIsDM(oPC))
	{ // DMs = Throw voice anywhere valid
		if (!GetIsObjectValid(oTarget)) 
			oTarget=oPC;
	}
	else
	{ // PCs = Throw voice to Associate Only
		if ((GetMaster(oTarget)!=oPC) || (!GetIsObjectValid(oTarget)))	
			oTarget = oPC;
	}			
		
	if ((CSLGetIsDM(oPC)) && (GetIsPC(oTarget)) && (oTarget!=oPC))
	{  // Send Message code for DMs
		CSLMessage_SendText(oTarget, "DM Message: " + sInput, TRUE, COLOR_CYAN);
        CSLMessage_SendText(oPC, "DMFI Message Sent: " + GetName(oTarget), TRUE, COLOR_GREEN);
		return;
	}		
	
	
	// 2/3/7 :: EDIT THIS WAS oPC = OBJECT_SELF NOT TESTED!!!! - Have to confirm EVERYTHING 
	oTool = CSLDMFI_GetTool(OBJECT_SELF);

	if (CHAT_EMOTES_ENABLED)
	{
		if (FindSubString(sInput, CHAT_EMOTE_SYMBOL)!=-1)
	    {
	    	SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
			SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
			//nState = DMFI_RunEmotePlugins(OBJECT_SELF);
			
			if (!nState)
			{
				DMFI_UITarget(oPC, oTool);
				SetLocalString(oPC, "sDMFIHeard", sInput);
				DMFI_RunEmotes(oTool, oTarget, sInput);
				
			}
			DeleteLocalInt(GetModule(), "Override");	
		}
	}
	else
	{
		CSLMessage_SendText(oPC, "DMFI Emotes disabled for performance reasons on this server.", FALSE, COLOR_RED);
	}
	
	sLang = DMFI_NewLanguage(sLang);
	sTest = DMFI_ProcessLanguage(sInput, sLang, oTool);

	if (sInput!="")
	{
		AssignCommand(oTarget, SpeakString(sTest));

		// Handle translation and send the speech log to the correct possessed DM state.
		if (oPC!=OBJECT_SELF)
			DMFI_TranslateToSpeakers(oTarget, sInput, sLang, oPC);
		else 
			DMFI_TranslateToSpeakers(oTarget, sInput, sLang, OBJECT_SELF);

	}
}
*/