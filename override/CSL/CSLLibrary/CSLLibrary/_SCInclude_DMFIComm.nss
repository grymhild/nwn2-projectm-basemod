/** @file
* @brief Include File for DMFI Commands User Interface
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_command - DM Friendly Initiative - Code for .Commands
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious          2/2/7	Qk 10/07/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMFI"
//#include "dmfi_inc_inc_com"
//#include "dmfi_inc_initial"
//#include "dmfi_inc_langexe"
//#include "dmfi_inc_lang"

int DMFI_RunCommandCode(object oTool, object oPC, string sOriginal)
{
// ***************************** COMMAND CODE **********************************
  int nTest;
  int nLength;
  int nNum;
  int n;
  int nLastVFX;
  int nItemProp;
  int nEffect;
  int bNumber;
  int nMusic;
  int nAbility = -1;
  int nWeather;

  string sHeard;
  string sTest;
  string sTool;
  string sCommandParam1Param2;
  string sCommand;
  string sParam1;
  string sParam2;
  string sRemains;
  string sLang;
  string sSkill;
  string sDice;
  string sVFXLabel;
  string sName;
  string sMessage;
  string sRef;
  string sPage;
  string sName1;
  string sName2;
  string sName3;
  string sName4;
  string sUParam1;
  string sSound;
  string sSoundName;
  string sConvertUsing;
  string sUTool;
  string sUCommand;
  string sLabel;
  string sDelay;
  string sLoc;

  object oSpeaker;
  object oTarget;
  object oItemTarget;
  object oTest;
  object oFollowTarget;
  object oName1;
  object oName2;
  object oName3;
  object oName4;
  object oEffectTarget;
  object oArea;
  object oStorage;
  object oSound;
  object oPossess;
  object oTargetTool;
  object oRef;

  float fNum;
  float fTime;
  location lTargetLoc;
  effect eEffect;
  effect eVFX;
  vector vTarget;
  itemproperty ipProp;

  sHeard = GetStringLowerCase(sOriginal);
  oTarget = GetLocalObject(oTool, DMFI_TARGET);
  lTargetLoc = GetLocalLocation(oTool, DMFI_TARGET_LOC);
  //oItemTarget = GetLocalObject(oTool, DMFI_ITEM_TARGET);
  oItemTarget = oTarget;
  oSpeaker = GetLocalObject(oTool, DMFI_SPEAKER);
    
  sTool = GetLocalString(oPC, "DMFIsTool");
  sCommand = GetLocalString(oPC, "DMFIsCommand");
  sParam1 = GetLocalString(oPC, "DMFIsParam1");
  sParam2 = GetLocalString(oPC, "DMFIsParam2");

//***************************************************************************
// Format Note: .set target right here
//
//              sTool = .set
//              sCommand = target
//              sParam1 = right
//              sParam2 = here


// *****************************************************************************
// PLAYER CAPABLE COMMANDS
// *****************************************************************************
    
	if (sTool=="ui")
	{
		if (!CSLGetIsDM(oPC))
		{  // PC side
			if (GetLocalInt(oPC, DMFI_PC_UI_STATE))
			{
				CloseGUIScreen(oPC, SCREEN_DMFI_PLAYER);
				DeleteLocalInt(oPC, DMFI_PC_UI_STATE);
			}	
			else
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_PLAYER, FALSE, "dmfiplayerui.xml");
				SetLocalInt(oPC, DMFI_PC_UI_STATE, TRUE);
			}
		}
		else
		{ // DM Side
			if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==1)
			{
				CloseGUIScreen(oPC, SCREEN_DMFI_DM);
				CloseGUIScreen(oPC, SCREEN_DMFI_BATTLE);
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 2);
			}	
			else if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==0)
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
				//DisplayGuiScreen(oPC, SCREEN_DMFI_BATTLE, FALSE, "dmfibattle.xml");
				DisplayGuiScreen(oPC, SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 1);
			}
			else if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==2)
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
				CloseGUIScreen(oPC, SCREEN_DMFI_TRGTOOL);	
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 3);
			}
			else
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
				CloseGUIScreen(oPC, SCREEN_DMFI_DM);
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 0);
			}	
							
		}
	}		
	/*	
	else if (sHeard== "follow on")
    {
	  
	  if (DMFI_FOLLOWOFF)
	  {
        if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (oTarget!=oPC))
        {
            SetLocalObject(oTool, DMFI_FOLLOW, oTarget);
            DMFI_Follow(oPC);
            CSLMessage_SendText(oPC, "DMFI Set to Follow: " + GetName(oTarget), TRUE, COLOR_GREEN);
			//DisplayGuiScreen(oPC, SCREEN_DMFI_FOLLOWOFF, FALSE, "dmfifollowoff.xml");
			
			SetGUIObjectHidden( oPC, "SCREEN_HOTBAR", "followOn-btn", TRUE ); // hides
			SetGUIObjectHidden( oPC, "SCREEN_HOTBAR", "followOff-btn", FALSE ); // shows
			
        }
        else
        {
		    CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", TRUE, COLOR_RED);
		}
	  }	
	  else
	  {
	    if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (oTarget!=oPC))
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionForceMoveToObject(oTarget, TRUE, 1.5));
			CSLMessage_SendText(oPC, "DMFI Set to Follow: " + GetName(oTarget), TRUE, COLOR_GREEN);
			
		}
		else 
			CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", TRUE, COLOR_RED);
	  }	
    }
    else if (sHeard== "follow off")
    {
        DeleteLocalObject(oTool, DMFI_FOLLOW);
        AssignCommand(oPC, ClearAllActions(TRUE));
		//CloseGUIScreen(oPC, SCREEN_DMFI_FOLLOWOFF);
        CSLMessage_SendText(oPC, "DMFI Follow Turned Off.", TRUE, COLOR_GREEN);
        
        SetGUIObjectHidden( oPC, "SCREEN_HOTBAR", "followOn-btn", FALSE ); // shows
		SetGUIObjectHidden( oPC, "SCREEN_HOTBAR", "followOff-btn", TRUE ); // hides
			
    }
    */
    else if (sTool=="language")
    {
        if (sCommand=="off")
        {
			// DMFI_LanguageOff(oPC);
		}	
        else
        {
            if ( (!CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) ) && (!CSLGetIsDM(oPC)))
			{
				CSLMessage_SendText(oPC, "DMFI  PC Languages disabled for performance reasons on this server.", TRUE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}	
		
			bNumber = CSLGetIsNumber(sCommand);
            if (bNumber)
                sCommand = GetLocalString(oTool, "Language" + sCommand);
			
            //sConvertUsing = DMFI_NewLanguage(sCommand);
            nTest = CSLLanguageLearned(oPC, sCommand);
				
            if (CSLGetIsDM(oPC) || nTest)
            { // valid language and can speak it.
				SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sCommand);				
				SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "Language", -1, CSLStringToProper(sCommand) + ":");
				DisplayGuiScreen(oPC, SCREEN_DMFI_TEXT, FALSE, "cslchatinput.xml");
			} // valid language and can speak it.
        }
    }
    else if (sTool== "roll")
    { //.roll
        sSkill = DMFI_FindPartialSkill(sCommand);
		//CSLMessage_SendText(oPC, "DEBUGGING: sTool / sSkill: " + sTool + " :: " + sCommand);
		if (CSLGetIsDM(oPC))
		{//DM Code
			if (oSpeaker!=oPC)
				oTest = oSpeaker;
			else 
				oTest = oTarget;
			if (!GetIsObjectValid(oTest))
			{
				oTest=oPC;
				CSLMessage_SendText(oPC, "Invalid Target: Target temporarily set to self.");
			}			
			if (sSkill!="")
			{
				SetLocalString(oTool, "DMFILastRoll", sSkill);			
				SetLocalObject(oTool, "DMFILastRoller", oTest);
                DMFI_RollCheck(oTest, sSkill, TRUE, oPC, oTool);
			}
			else
				DMFI_RollBones(oPC, oTest, sCommand);	
		}
		else
		{// PC Code
			if (sSkill!="")
			{
				SetLocalString(oTool, "DMFILastRoll", sSkill);	
				SetLocalObject(oTool, "DMFILastRoller", oSpeaker);
                DMFI_RollCheck(oSpeaker, sSkill, FALSE, OBJECT_INVALID, oTool);
				
			}
			else
				DMFI_RollBones(oSpeaker, oTarget, sCommand);
		}			
	}//close .roll	
   
    else if (sTool=="rename")
    {// Set Original Case Sensitive Name
       	DMFI_RenameObject(oPC, oTarget);
	}// Set Original Case Sensitive Name
	
	else if (sTool=="grant")
    {
        if (!CSLGetIsDM(oPC))
		{
			n = GetLocalInt(oPC, "DMFIChoose");
			if (n>0)
			{
				SetLocalInt(oPC, "DMFIChoose", n-1);
				CSLLanguageGive(oPC, sCommand, TRUE);
				
				if (n>1)	
					SetGUIObjectText(oPC, SCREEN_DMFI_CHOOSE, "DMListTitle", -1, CV_PROMPT_CHOOSE + IntToString(n-1));
				else
					CloseGUIScreen(oPC, SCREEN_DMFI_CHOOSE);	
			}	
			else
				CSLMessage_SendText(oPC, "DMFI ERROR", FALSE, COLOR_RED);
		}		
		else
		{
			if (!GetIsPC(oTarget))
			{
				CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		
		    CSLLanguageGive(oTarget, sCommand,TRUE);
	        CSLMessage_SendText(oPC, "DMFI Langugage Granted: " + CSLStringToProper(sCommand) + " " + "DMFI Target: " + GetName(oTarget), TRUE, COLOR_GREEN);
	    }	
    }
	
	

// *****************************************************************************
// DM ONLY CODE BEGINS
// *****************************************************************************

  else
  {
    if (!CSLGetIsDM(oPC)) return TRUE;
	
	if (sTool=="voice")
	{
		sTest = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
		if (sTest=="") sTest = "common";
		SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "Language", -1, CSLStringToProper(sTest) + ":");
		DisplayGuiScreen(oPC, SCREEN_DMFI_TEXT, FALSE, "cslchatinput.xml");
	}
	
    else if (sTool ==  "initialize")
    {
        if (FindSubString(sHeard, "language")!=-1)
        {
			// NOTE:  Only place in the code right now where we transfer
			// the targets tool.
			CloseGUIScreen(oTarget, SCREEN_DMFI_TEXT);
			oTargetTool=CSLDMFI_GetTool(oTarget);
			//DeleteLocalInt(oTargetTool, "Language"+"MAX");
			//CSLMessage_SendText(oTarget, "DMFI Languages Reset by Server.", TRUE, COLOR_GREY);
			//CSLMessage_SendText(oPC, "Target Languages Reset.", TRUE, COLOR_GREY); 
			//DelayCommand(2.0, DMFI_InitializeLanguage(oTarget, oTargetTool, oPC));
        }	
	    //else if (sCommand == "plugins")
        	//DMFI_InitializePlugins(oPC);
        else if (sCommand == "server")
        {
           //    DMFI_InitializeTool(oPC, oTool);
        }
    }
    else if ((sTool=="list") && (sCommand=="language"))
    {
		if (!GetIsPC(oTarget))
			{
				CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		 
	  	CSLLanguagesListLearnedToMessage(oPC, oTarget);
	}
    else if (sTool=="copy")
    {
        if (sCommand=="pc")
        {
            SetLocalObject(oTool, DMFI_STORE + IntToString(1), oTarget);
            CSLMessage_SendText(oPC, "DMFI Target saved for later use.", TRUE, COLOR_GREEN);
        }
        else if (sCommand=="party")
        {
            if (!GetIsPC(oTarget))
			{
				CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		
			n=0;
            oName1 = GetFirstFactionMember(oTarget, TRUE);
            while (oName1!=OBJECT_INVALID)
            {
                n++;
                SetLocalObject(oTool, DMFI_STORE + IntToString(n), oName1);
                oName1 = GetNextFactionMember(oTarget, TRUE);
            }
            CSLMessage_SendText(oPC, "DMFI Target's PARTY saved for later use.", TRUE, COLOR_GREEN);
        }
        else
            CSLMessage_SendText(oPC, "'pc' or 'party' parameter required.", FALSE, COLOR_RED);
    }
    else if (sTool=="paste")
    {
       	n=1;
        oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n));
        if (GetIsObjectValid(oTest))
		{
			while (oTest!=OBJECT_INVALID)
	        {
	           // oName1 = CopyObject(oTest, GetLocation(oPC));
	           // n++;
	           // oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n));
			   // Qk: Fix for NWN2 v1.10 thx to Dragonsbane
               string sTag = "some_random_tag_" + IntToString(Random(65536)); 
          	   CopyObject(oTest, GetLocation(oPC), OBJECT_INVALID, sTag); 
               oName1 = GetNearestObjectByTag(sTag, oPC); 
               // End Update  
               n++; 
               oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n)); 
	        }
	        CSLMessage_SendText(oPC, "Any valid DMFI Stored PCs recalled.", TRUE, COLOR_GREEN);
		}
		else
			CSLMessage_SendText(oPC, "Clipboard Empty - No copied creatures", FALSE, COLOR_RED);	
    }
    else if (sTool=="boot")
    {
        if ((!GetIsPC(oTarget)) || (CSLGetIsDM(oTarget)))
		{
			CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
			return DMFI_STATE_ERROR;
		}
		
		BootPC(oTarget);
        CSLMessage_SendText(oPC, "DMFI Removed Player from Server: " + GetName(oTarget), TRUE, COLOR_RED);
        WriteTimestampedLogEntry("DMFI Action Alert: " + GetName(oPC) + "DMFI Removed Player from Server: " + GetName(oTarget));
    }
    else if (sHeard== "reload")
    {
        StartNewModule(MOD_NAME);
        return TRUE;
    }
    
// REPEAT COMMANDS
    else if (sTool== "repeat")
    {
       if (sCommand=="roll")
       {
            sSkill = GetLocalString(oTool, "DMFILastRoll");
            oTest = GetLocalObject(oTool, "DMFILastRoller");

            if (!CSLGetIsDM(oPC))
                DMFI_RollCheck(oTest, sSkill);
            else
                DMFI_RollCheck(oTarget, sSkill, TRUE, oPC, oTool);  // editted to use target
       }
       else if (sCommand=="vfx")
       {
       		if (CSLGetIsNumber(sParam1) && (StringToInt(sParam1)<11))
			{
				nLastVFX = GetLocalInt(oTool, DMFI_VFX_RECENT + sParam1);
				sVFXLabel = Get2DAString("visualeffects", "Label", nLastVFX);
				DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, IntToString(nLastVFX));
				CSLMessage_SendText(oPC, "DMFI Visual Effect: Ref: " + IntToString(nLastVFX) + " Label: " + sVFXLabel, TRUE, COLOR_GREEN);
			}	   
	        else
			{
				nLastVFX = GetLocalInt(oTool, DMFI_VFX_LAST);
	            sVFXLabel = Get2DAString("visualeffects", "Label", nLastVFX);
	            DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, IntToString(nLastVFX));
				CSLMessage_SendText(oPC, "DMFI Visual Effect: Ref: " + IntToString(nLastVFX) + " Label: " + sVFXLabel, TRUE, COLOR_GREEN);
			}
       }
	   else if (sCommand=="sound")
	   {
	   		sCommand = GetLocalString(oTool, DMFI_SOUND_LAST);
			sParam1 = GetLocalString(oTool, DMFI_SOUND_LAST_PRM);		
	   		DMFI_CreateSound(oTool, oPC, oTarget, oSpeaker, lTargetLoc, sCommand, sParam1);
	   }	

    }
// REPORT COMMANDS
    else if (sTool=="report")
    {
        if ((sCommand=="gold") || (sCommand=="networth") || (sCommand=="xp"))
            DMFI_Report(oPC, oTool, sCommand);
        else if (sCommand=="information")
        {
            if (GetIsPC(oTarget))
            {
                CSLMessage_SendText(oPC, "DMFI Target: " + GetName(oTarget));
                CSLMessage_SendText(oPC, "PC Name: " + GetPCPlayerName(oTarget));
                CSLMessage_SendText(oPC, "PC CD Key: " + GetPCPublicCDKey(oTarget));
                CSLMessage_SendText(oPC, "PC IP Address: " + GetPCIPAddress(oTarget));
                PrintString("DMFI Target: " + GetName(oTarget) +
                            "PC Name: " + GetPCPlayerName(oTarget) +
                            "PC CD Key: " + GetPCPublicCDKey(oTarget) +
                            "PC IP Address: " + GetPCIPAddress(oTarget));

            }
            else
                CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
        }
        else
            CSLMessage_SendText(oPC, "'gold' 'networth' 'xp' or 'information' parameter required.", FALSE, COLOR_RED);

    }
// INVENTORY COMMANDS
    else if (sTool== "inventory")
    {
        if (sCommand=="identify")
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
                DMFI_IdentifyInventory(oTarget, oPC);

            else
                CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
        }
        else if (sCommand=="strip")
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
                DMFI_StripInventory(oTarget, oPC);

            else
                CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
        }
        else if (sCommand=="uber")
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
            {
                bNumber = CSLGetIsNumber(sParam1);
                if (bNumber)
                    DMFI_RemoveUber(oPC, oTarget, sParam1);
				else
					DMFI_RemoveUber(oPC, oTarget, IntToString(GetHitDice(oTarget)));	
            }
            else
                CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
        }
		else if (sCommand=="manage")
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
			   {
			    if (oTarget != oPC) //QK: Manage inventory to yourself caused an infinite loop
                	DMFI_ManageInventory(oTarget, oPC);
				else
					CSLMessage_SendText(oPC,"You cannot manage the inventory to yourself", FALSE, COLOR_RED);
				}
            else
                CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
		}		

    }

// ********************* REMOVE EFFECTS / ITEM PROPERTIES **********************

    else if (sTool == "remove")
    {
        if (sCommand == "itemprop")
        {
            if (GetObjectType(oItemTarget)==OBJECT_TYPE_ITEM)
            {
                sPage = "TARGET_ITEMPROP";
                nItemProp = CSLDataArray_GetInt( oTool, sPage, StringToInt(sParam2));
                ipProp = GetFirstItemProperty(oTarget);
                while (GetIsItemPropertyValid(ipProp))
                {
                    nTest = GetItemPropertyType(ipProp);
                    if (nTest==nItemProp)
                    {
                        RemoveItemProperty(oTarget, ipProp);
                        CSLMessage_SendText(oPC, "Item Property Removed from target.", TRUE, COLOR_GREEN);
                        break;
                    }
                    ipProp = GetNextItemProperty(oTarget);
                }
            }
            else
            {
                CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "DMFI Target must be an item for this parameter.", FALSE, COLOR_BLUE);
                return DMFI_STATE_ERROR;
            }
        }
        else if (sCommand == "effect")
        {
            oEffectTarget = oTarget;
            if (oEffectTarget!=OBJECT_INVALID)
            {
                sPage = "TARGET_EFFECT";
                nEffect = CSLDataArray_GetInt( oTool, sPage, StringToInt(sParam1) );
                eEffect = GetFirstEffect(oEffectTarget);
                while (GetIsEffectValid(eEffect))
                {
                    nTest = GetEffectType(eEffect);
                    if (nTest==nEffect)
                    {
                        RemoveEffect(oTarget, eEffect);
                        CSLMessage_SendText(oPC, "Effect Removed from target.", TRUE, COLOR_GREEN);
                        break;
                    }
                    eEffect = GetNextEffect(oTarget);
                }
            }
        }
        else if (sCommand=="language")
        {
            if (!GetIsPC(oTarget))
			{
				CSLMessage_SendText(oPC, "DMFI Target must be a PC for this action.", FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}
			CSLLanguageRemove(oTarget, sParam1, TRUE);
            CSLMessage_SendText(oPC, "DMFI Language Removed: " + sCommand + " " + "DMFI Target: " + GetName(oTarget), TRUE, COLOR_GREEN);
        }
    }

// SET COMMANDS
    else if (sTool== "set")
    {

// SET DICEBAG PREFERENCES
        if (sCommand=="dc")
        {// SET DC for Dicebag
            bNumber = CSLGetIsNumber(sParam1);
            if (bNumber)
            {
                DMFI_UpdateNumberToken(oTool, "dc", sParam1);
            }
            else
            {
                SetLocalString( oPC, DLG_PAGE_ID, "LIST_50");
                CSLStartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return DMFI_STATE_ERROR;
            }
        }// SET DC for Dicebag
// SET MUSIC
        else if (FindSubString(sHeard, "music")!=-1)
        {
            bNumber = CSLGetIsNumber(sParam2);
            if (bNumber)
            {// sParam is an INT
                DMFI_InitializeAreaMusic(oPC);
                oArea = GetArea(oPC);

                sSound = Get2DAString("ambientmusic", "Description", StringToInt(sParam2));
                sSoundName = GetStringByStrRef(StringToInt(sSound));

                if (FindSubString(sHeard, "day")!=-1)
                {
                    MusicBackgroundChangeDay(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    CSLMessage_SendText(oPC, "DMFI Music:  Day music set to: " + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, "night")!=-1)
                {
                   	MusicBackgroundChangeNight(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    CSLMessage_SendText(oPC, "DMFI Music:  Night music set to: " + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, "both")!=-1)
                {
                   	MusicBackgroundChangeDay(oArea, StringToInt(sParam2));
                    MusicBackgroundChangeNight(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    CSLMessage_SendText(oPC, "DMFI Music:  Both day and night music set to: " + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, "battle")!=-1)
                {
                    MusicBattleChange(oArea, StringToInt(sParam2));
					CSLMessage_SendText(oPC, "DMFI Music:  Battle music set to: " + sSoundName, TRUE, COLOR_GREEN);
                }
            }// sParam2 is an INT
            else if (sParam2=="")
            {// No valid sParam2
                if ((sParam1!="day") && (sParam1!="night") && (sParam1!="both") &&(sParam1!="battle"))
                {
                    CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "'day' 'night' 'both' or 'battle' parameter required.", FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
                SetLocalString( oPC, DLG_PAGE_ID, "MUSIC_CATEGORY");
                CSLStartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return TRUE;
            }
            
        }// CONFIGURE MUSIC SETTINGS
// SET AMBIENT
        else if (FindSubString(sHeard, "ambient")!=-1)
        {
            bNumber = CSLGetIsNumber(sParam2);
            if (bNumber)
            { // int valid
            	if (FindSubString(sHeard, "vol")!=-1)
				{
					if (StringToInt(sParam2)>100)
						sParam2="100";
					AmbientSoundSetDayVolume(GetArea(oPC), StringToInt(sParam2));
					AmbientSoundSetNightVolume(GetArea(oPC), StringToInt(sParam2));
					SetLocalString(oTool, DMFI_AMBIENT_VOLUME, sParam2);
					CSLMessage_SendText(oPC, "DMFI Ambient Volume set to: " + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "ambvol", -1, sParam2);
				}
				else
				{			
				    oArea = GetArea(oPC);
	                sSound = Get2DAString("ambientsound", "Description", StringToInt(sParam2));
	                sSoundName = GetStringByStrRef(StringToInt(sSound));
	                if (FindSubString(sHeard, "day")!=-1)
	                {
	                    AmbientSoundStop(oArea);
	                    AmbientSoundChangeDay(oArea, StringToInt(sParam2));
						nNum = StringToInt(GetLocalString(oTool, DMFI_AMBIENT_VOLUME));
						AmbientSoundSetDayVolume(oArea, nNum);
	                    DelayCommand(2.0, AmbientSoundPlay(oArea));
	                    CSLMessage_SendText(oPC, "DMFI Ambient Sound (volume applied): Day set to: " + sSoundName, TRUE, COLOR_GREEN);
	                }
	                else if (FindSubString(sHeard, "night")!=-1)
	                {
	                    AmbientSoundStop(oArea);
	                    AmbientSoundChangeNight(oArea, StringToInt(sParam2));
						nNum = StringToInt(GetLocalString(oTool, DMFI_AMBIENT_VOLUME));
						AmbientSoundSetNightVolume(oArea, nNum);
	                    DelayCommand(2.0, AmbientSoundPlay(oArea));
	                    CSLMessage_SendText(oPC, "DMFI Ambient Sound (volume applied): Night set to: " + sSoundName, TRUE, COLOR_GREEN);
	                }
				}	
            } // int valid
            else if (sParam2=="")
            {
                if ((sParam1!="day") && (sParam1!="night"))
                { // return if sParam1 not valid
                    CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "'day' or 'night' parameter required.", FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                } // return if sParam1 not valid
                SetLocalString( oPC, DLG_PAGE_ID, "AMBIENT_CATEGORY");
                CSLStartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return TRUE;
            }
        }
// SET SOUND
        else if (FindSubString(sHeard, "sound")!=-1)
        {
            if (FindSubString(sHeard, "delay")!=-1)
            { // DELAY
                if (CSLGetIsNumber(sParam2))
                {// valid command            
                    SetLocalString(oTool, DMFI_SOUND_DELAY, sParam2);
                    CSLMessage_SendText(oPC, "DMFI Placeable Sound Delay set to: " + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sounddelay", -1, sParam2);
                }
                else
                {
                    CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "Int Parameter required.", FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
            } // DELAY
           
        }
// SET VFX
        else if (FindSubString(sHeard, "vfx")!=-1)
        {
            if (FindSubString(sHeard, "dur")!=-1)
            { // DURATION
                if (CSLGetIsNumber(sParam2))
                {// valid command            {
                    SetLocalString(oTool, DMFI_VFX_DURATION, sParam2);
                    CSLMessage_SendText(oPC, "DMFI VFX Duration set to: " + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "changedur", -1, sParam2);
					//CloseGUIScreen(oPC, SCREEN_DMFI_DMLIST);
                }
                else
                {
                    CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "Int Parameter required.", FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
            } // DURATION
        }
    	else if (sCommand=="description")
		{ // SetDescription not functioning properly
			SetDescription(oTarget, sParam1 + " " + sParam2);
			CSLMessage_SendText(oPC, "New Description: " + sParam1 + " " + sParam2, TRUE, COLOR_GREEN);
			//CSLMessage_SendText(oPC, "DEBUGGING: Description: " + GetDescription(oTarget));
		}	
	}//CLOSE .set
	
// TOGGLE PREFERENCES

    else if (sTool== "toggle")
    {
       DMFI_TogglePreferences(oTool, sCommand);
    }

// TIME
    else if (sTool== "time")
    {
            bNumber = CSLGetIsNumber(sCommand);
            if (bNumber)
            {
                nNum = GetTimeHour() + (StringToInt(sCommand) - GetTimeHour());
                SetTime(nNum, 0 , 0 , 0);
                if (nNum<0) nNum = nNum + 24;
                CSLMessage_SendText(oPC, "Time set to hour: " + IntToString(nNum), TRUE, COLOR_GREEN);
            }
            else
            {
                SetLocalString( oPC, DLG_PAGE_ID, "LIST_50");
                CSLStartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return TRUE;
            }
    }

// WEATHER COMMANDS
  else if (sTool== "weather")
    {
			object oArea = GetArea(oPC);
            SetWeather(GetArea(oPC), WEATHER_TYPE_RAIN,-1);
            CSLMessage_SendText(oPC, "Weather set to Clear", FALSE, COLOR_GREEN);
			SetLocalInt(oArea,"DMFI_WEATHER",-1);
    }
  else if (sTool == "rain")
  	{
		object oArea = GetArea(oPC);
		nWeather = GetLocalInt(oArea,"DMFI_WEATHER");
		if (nWeather<0) nWeather=0;
		nWeather=nWeather+1;
		if (nWeather>5) nWeather=5;
		    SetWeather(oArea, WEATHER_TYPE_RAIN,nWeather);
            CSLMessage_SendText(oPC, "Weather set to Rain", FALSE, COLOR_GREEN);
			SetLocalInt(oArea,"DMFI_WEATHER",nWeather);
		
	}
	
   else if (sTool == "norain")
  	{ 
		object oArea = GetArea(oPC);
		nWeather = GetLocalInt(oArea,"DMFI_WEATHER");
		nWeather=nWeather-1;
    	if (nWeather<0) nWeather=0;
		    SetWeather(oArea, WEATHER_TYPE_RAIN,nWeather);
            CSLMessage_SendText(oPC, "Weather set to Clear", FALSE, COLOR_GREEN);
		    SetLocalInt(oArea,"DMFI_WEATHER",nWeather);
	}

// MUSIC COMMANDS
    else if (sTool== "music")
    {
        if (FindSubString(sHeard, "play")!=-1)
        {
            //MusicBattleStop(GetArea(oPC));
			MusicBackgroundSetDelay(GetArea(oPC), 999999);
			MusicBackgroundPlay(GetArea(oPC));
            CSLMessage_SendText(oPC, "Background Music Started.", TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, "battle")!=-1)
        {
            MusicBackgroundStop(GetArea(oPC));
			MusicBattlePlay(GetArea(oPC));
            CSLMessage_SendText(oPC, "Battle Music started.", TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, "stop")!=-1)
        {
            object oMyArea = GetArea(oPC);
						
			MusicBackgroundStop(oMyArea);
            MusicBattleStop(oMyArea);
			CSLMessage_SendText(oPC, "Music Stopped.", TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, "restore")!=-1)
        {
            oArea = GetArea(oPC);

            MusicBackgroundStop(oArea);
            MusicBattleStop(oArea);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_BATTLE);
            MusicBattleChange(oArea, nMusic);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_DAY);
            MusicBackgroundChangeDay(oArea, nMusic);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_NIGHT);
            MusicBackgroundChangeNight(oArea, nMusic);

            MusicBattleStop(oArea);
            MusicBackgroundStop(oArea);
            CSLMessage_SendText(oPC, "Music Restored to Default Settings", TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, "default")!=-1)
        {
            DeleteLocalInt(GetArea(oPC), DMFI_MUSIC_INITIALIZED);
            DMFI_InitializeAreaMusic(oPC);
            CSLMessage_SendText(oPC, "Current Music Set to Default Settings", TRUE, COLOR_GREEN);
        }
        else  CSLMessage_SendText(oPC, "PARAMETER MISSING or MISTYPED: " + "'play' 'battle' or 'stop' parameter required.", FALSE, COLOR_BLUE);
    }
// AMBIENT COMMANDS
    else if (sTool== "ambient")
    {
        if (FindSubString(sHeard, "play")!=-1)
        {
            sTest = GetLocalString(oTool, DMFI_AMBIENT_VOLUME);
			AmbientSoundSetDayVolume(GetArea(oPC), StringToInt(sTest));
			AmbientSoundSetNightVolume(GetArea(oPC), StringToInt(sTest));
			AmbientSoundSetDayVolume(GetArea(oPC),100);
			AmbientSoundSetNightVolume(GetArea(oPC), 100);
			
			//AmbientSoundPlay(GetArea(oPC));
            CSLMessage_SendText(oPC, "Ambient Sounds started.", TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, "stop")!=-1)
        {
            //AmbientSoundStop(GetArea(oPC));
			AmbientSoundSetDayVolume(GetArea(oPC), 0);
			AmbientSoundSetNightVolume(GetArea(oPC), 0);
            CSLMessage_SendText(oPC, "Ambient Sounds stopped.", TRUE, COLOR_GREEN);
        }
    }

// VFX COMMANDS
     else if (sTool== "vfx")
     {
        bNumber = CSLGetIsNumber(sCommand);
        if (bNumber)
        {
            sVFXLabel = Get2DAString("visualeffects", "Label", StringToInt(sCommand));
            DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, sCommand);

            CSLMessage_SendText(oPC, "DMFI Visual Effect: Ref: " + sCommand + " Label: " + sVFXLabel, TRUE, COLOR_GREEN);
            SetLocalInt(oTool, DMFI_VFX_LAST, StringToInt(sCommand));
			
			// Build list of recently used vfxs
			nNum = GetLocalInt(oTool, DMFI_VFX_RECENT);
			SetLocalInt(oTool, DMFI_VFX_RECENT + IntToString(nNum), StringToInt(sCommand));
			nNum++;
			if (nNum>29) nNum = 1;
			SetLocalInt(oTool, DMFI_VFX_RECENT, nNum);
		}
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,"VFX");
            CSLStartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return TRUE;
        }
     }

// EFFECT ADDING COMMANDS
    else if (sTool== "effect")
    {
        if (FindSubString(sCommand, "str"))
            nAbility = ABILITY_STRENGTH;
        else if (FindSubString(sCommand, "dex"))
            nAbility = ABILITY_DEXTERITY;
        else if (FindSubString(sCommand, "cons"))
            nAbility = ABILITY_CONSTITUTION;
        else if (FindSubString(sCommand, "inte"))
            nAbility = ABILITY_INTELLIGENCE;
        else if (FindSubString(sCommand, "wis"))
            nAbility = ABILITY_WISDOM;
        else if (FindSubString(sCommand, "cha"))
            nAbility = ABILITY_CHARISMA;
        if (nAbility!=-1)
        {
            if (StringToInt(sParam1)<0)
                eEffect = EffectAbilityDecrease(nAbility, StringToInt(sParam1));
            else
                eEffect = EffectAbilityIncrease(nAbility, StringToInt(sParam1));
            if (GetIsEffectValid(eEffect))
            {
                bNumber = CSLGetIsNumber(sParam1);
                if (bNumber)
                    fTime = StringToFloat(sParam1);
                else
                    fTime = 30.0;

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
                CSLMessage_SendText(oPC, "DMFI Effect Applied: " + sCommand, TRUE, COLOR_GREEN);
            }
            else
                CSLMessage_SendText(oPC, "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.", FALSE, COLOR_RED);
        }
        else if (sCommand!="")
        {
            if (FindSubString(sCommand, "ac"))
            {// AC EFFECT code block
                if (StringToInt(sParam1)<0)
                    eEffect = EffectACDecrease(StringToInt(sParam1));
                else
                    eEffect = EffectACIncrease(StringToInt(sParam1));
                if (GetIsEffectValid(eEffect))
                {
                    bNumber = CSLGetIsNumber(sParam1);
                    if (bNumber)
                        fTime = StringToFloat(sParam1);
                    else
                        fTime = 30.0;
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
                    CSLMessage_SendText(oPC, "DMFI Effect Applied: " + sCommand, TRUE, COLOR_GREEN);
                }
                else
                    CSLMessage_SendText(oPC, "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.", FALSE, COLOR_RED);
            }// AC EFFECT code block
            else
                DMFI_CreateEffect(sCommand, sParam1, oPC, oTarget);
        }
    }
    else if (sTool== "disease")
    {
        bNumber = CSLGetIsNumber(sCommand);
        if (bNumber)
        {
            sLabel = Get2DAString("disease", "Label", StringToInt(sCommand));
            eEffect = SupernaturalEffect(EffectDisease(StringToInt(sCommand)));
            if (GetIsEffectValid(eEffect))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
                CSLMessage_SendText(oPC, "DMFI Effect Applied: " + sLabel, TRUE, COLOR_GREEN);
            }
            else
                CSLMessage_SendText(oPC, "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.", FALSE, COLOR_RED);
        }
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,"LIST_DISEASE");
            CSLStartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return TRUE;
        }
    }
    else if (sTool== "poison")
    {
        bNumber = CSLGetIsNumber(sCommand);
        if (bNumber)
        {
            sLabel = Get2DAString("poison", "Label", StringToInt(sCommand));
            eEffect = EffectPoison(StringToInt(sCommand));
            if (GetIsEffectValid(eEffect))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
                CSLMessage_SendText(oPC, "DMFI Effect Applied: " + sLabel, TRUE, COLOR_GREEN);
            }
            else
                CSLMessage_SendText(oPC, "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.", FALSE, COLOR_RED);
        }
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,"LIST_DISEASE");
            CSLStartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return TRUE;
        }
    }

// SOUND COMMANDS
	else if (sTool== "sound")
    {
        bNumber = CSLGetIsNumber(sParam1);
        if (bNumber)
        {
            DMFI_CreateSound(oTool, oPC, oTarget, oSpeaker, lTargetLoc, sCommand, sParam1);
		    SetLocalString(oTool, DMFI_SOUND_LAST, sCommand);
			SetLocalString(oTool, DMFI_SOUND_LAST_PRM, sParam1);
        }
        else
        {
            SetLocalString( oPC, DLG_PAGE_ID, "LIST_SOUND");
            CSLStartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return TRUE;
        }
     }

// MISC COMMANDS	 
	else if (sTool=="freeze")
	{
		if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (!CSLGetIsDM(oTarget)))
		{	
			eEffect = EffectCutsceneImmobilize();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			eEffect = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			CSLMessage_SendText(oTarget, "Your character is DM frozen for 60 seconds.", TRUE, COLOR_RED);
			CSLMessage_SendText(oPC, "DMFI Target is frozen for 60 seconds.", TRUE, COLOR_GREEN);
		}
		else
			CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
	}
	else if (sTool=="scale")
	{
		if (GetIsPC(oTarget))
		{
			CSLMessage_SendText(oPC, "Target must NOT be a PC for this function.", FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		if (CSLGetIsNumber(sCommand))
		{
			fNum = StringToFloat(sCommand);
			fNum = fNum/100.0;
			eEffect = EffectSetScale(fNum);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
			CSLMessage_SendText(oPC, "DMFI Target Scale Percent: " + sCommand, TRUE, COLOR_GREEN);
		}				 
	 }
	 else if (sTool=="item")
	 {
	  	if (GetIsObjectValid(oItemTarget))
		{
			if (sCommand=="toggle")
			{
				DMFI_ToggleItemPrefs(sHeard, oPC, oTarget);
				oRef = GetLocalObject(oTarget, DMFI_INVENTORY_TARGET);
				if (GetIsObjectValid(oRef) && DMFI_UPDATE_INVENTORY)
				{
					oTarget = GetItemPossessor(oRef);
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
				}	
			}
			else if (sCommand=="identify")
			{
				oRef = GetLocalObject(oItemTarget, DMFI_INVENTORY_TARGET);
				sTest = GetName(oItemTarget);
				SetIdentified(oItemTarget, TRUE);
				SetIdentified(oRef, TRUE);
				CSLMessage_SendText(oPC, "Item Identified (note: name will not refresh until moved): " + sTest, TRUE, COLOR_GREEN);	
				
				if (GetIsObjectValid(oRef) && DMFI_UPDATE_INVENTORY)
				{
					oTarget = GetItemPossessor(oRef);
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
				}	
				
			}
			else if (sCommand=="take")
			{
				if (GetItemPossessor(oItemTarget)!=oPC)
				{
					CSLMessage_SendText(oPC, "Item must be in your inventory for this inventory action.", FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}			
				oRef = GetLocalObject(oItemTarget, DMFI_INVENTORY_TARGET);
				oTarget = GetItemPossessor(oRef);
				
				if ((!GetIsObjectValid(oRef)) || (!GetIsObjectValid(oTarget)))
				{
					CSLMessage_SendText(oPC, "Inventory Manage Target Invalid", FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				sTest = GetName(oItemTarget);
				CopyItem(oItemTarget, oPC, TRUE);
				SetPlotFlag(oItemTarget, FALSE);
				DestroyObject(oItemTarget);
				SetPlotFlag(oRef, FALSE);
				DestroyObject(oRef);
				
				if (DMFI_UPDATE_INVENTORY)
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
					
				CSLMessage_SendText(oPC, "Item Taken from Target: " + sTest, TRUE, COLOR_GREEN);
    		}
			else if (sCommand=="give")
			{
				oTarget = GetLocalObject(oPC, DMFI_INVENTORY_TARGET);
				if (GetItemPossessor(oItemTarget)!=oPC)
				{
					CSLMessage_SendText(oPC, "Item must be in your inventory for this inventory action.", FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				if (!GetIsObjectValid(oTarget))
				{
					CSLMessage_SendText(oPC, "Inventory Manage Target Invalid", FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				if (!GetHasInventory(oItemTarget))				
					CopyItem(oItemTarget, oTarget, TRUE);
				else
				{
					oTest =	GetFirstItemInInventory(oItemTarget);
					if (!GetIsObjectValid(oTest))
					{
						CSLMessage_SendText(oPC, "Error: Can only give contents of containers.  Empty containters NOT valid target.", FALSE, COLOR_RED);
						return DMFI_STATE_ERROR;
					}
					
					while (GetIsObjectValid(oTest))
					{
						CopyItem(oTest, oTarget, TRUE);	
						oTest = GetNextItemInInventory(oItemTarget);
					}	
				}
				if (DMFI_UPDATE_INVENTORY)
					DMFI_ManageInventory(oTarget, oPC);
					
				CSLMessage_SendText(oPC, "Item or Items Given: " + GetName(oItemTarget), TRUE, COLOR_GREEN);
			}	
		}	
	}	  
	else if (sTool=="faction")
	{
		if (GetIsPC(oTarget))
		{
			CSLMessage_SendText(oPC, "Target must NOT be a PC for this function.", FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		
		if (sCommand=="hostile")
			nTest = 0;
		else if (sCommand=="commoner")
			nTest = 1;
		else if (sCommand=="defender")
			nTest = 3;
		else if (sCommand=="merchant")
			nTest = 2;
		else 
		{
			CSLMessage_SendText(oPC, "Default Faction Required as Parameter.", FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		AssignCommand(oTarget, ClearAllActions(TRUE));
		ChangeToStandardFaction(oTarget, nTest);
		
		oTest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oTarget, 1);
		if (GetIsObjectValid(oTest))
			DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
	
		CSLMessage_SendText(oPC, "Target set to faction: " + sCommand, TRUE, COLOR_GREEN);
	}
	else if (sTool=="battle")
	{
		if (sCommand=="on")
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
				oTest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1);
				if (GetIsObjectValid(oTest))
					DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			CSLMessage_SendText(oPC, "START BATTLE: All NPCs set to HOSTILE", TRUE, COLOR_GREEN);
		}
		else 
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER);
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			CSLMessage_SendText(oPC, "STOP BATTLE:  All NPCs set to Commoner", TRUE, COLOR_GREEN);
		}	
	}	
	else if (sTool=="facing")
	{
		fNum = GetFacing(oPC);
		AssignCommand(oTarget, SetFacing(fNum));
	}
	else if (sTool=="appearance")
	{
		if (sCommand=="-1")
		{
			SetCreatureAppearanceType(oTarget, GetLocalInt(oTarget, "DMFIDefApp"));
		}
		else			
		{
			if (GetLocalInt(oTarget, "DMFIDefApp")==0)
			{
				SetLocalInt(oTarget, "DMFIDefApp", GetAppearanceType(oTarget));
			}
			SetCreatureAppearanceType(oTarget, StringToInt(sCommand));
			eVFX = EffectVisualEffect(896, FALSE);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oTarget));
		}
		CSLMessage_SendText(oPC, "DMFI Appearance: " + sCommand);
	}				  						
//Qk Addons 10/07
	else if (sTool=="placeableplot")
	{
		if (GetObjectType(oTarget)!= OBJECT_TYPE_PLACEABLE)
		{
			CSLMessage_SendText(oPC, "Requires valid associate target.", FALSE, COLOR_RED);
			return DMFI_STATE_ERROR;
		}
		int bPlot = GetPlotFlag(oTarget);
		if (bPlot ==TRUE)
		{
			SetPlotFlag(oTarget,FALSE);
			CSLMessage_SendText(oPC, "Plot"+": False",FALSE,COLOR_GREEN);
		}
		else
		{
			SetPlotFlag(oTarget,TRUE);
			CSLMessage_SendText(oPC, "Plot"+": TRUE",FALSE,COLOR_GREEN);
		}
		
	}


// ALL .COMMAND CODE HAS RUN - IF NOTHING THEN GIVE ERROR MSG
  else CSLMessage_SendText(oPC, "DMFI Command Not Found:  Mistyped or command not known.", FALSE, COLOR_RED);
  }

  return TRUE;         // Do not process emotes or languages
}// .COMMANDS
//void main(){}