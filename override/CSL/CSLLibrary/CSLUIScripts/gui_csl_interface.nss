/*
This is the main UI interface handler that manages which controls are visible at any time. Common hooks in the UI
are routed thru this, as are various features and changes in default elements.

Make sure this compiles, it's pretty obvious since it updates the players stats in the top left corner as it's primary duty ( make sure that is first if as it gets called the most
*/
//#include "_CSLCore_Player"
#include "_SCInclude_DMFI"
#include "_SCInclude_Chat"
#include "_SCInclude_TomeBattle"
#include "_SCInclude_summon"

#include "_HkSpell"

// param1 and param2 are just for examine, to see what they do

void main(string sInput = "Null", string sPlayerID ="Null", string sParam1="", string sParam2="" )
{
	//Trim the value string.
	//sValue = GetStringRight(sValue, GetStringLength(sValue) - 17);
	
	object oChar = OBJECT_SELF;
	
	if ( sInput == "showstats" )
	{
		// move this to it's own function would be a good idea, soas to keep code in a single spot, should update on switching characters, 
		// might be a good way of sensing a missed change
		string sTopLine;
		
		oChar = GetControlledCharacter(oChar); // make sure we have controlled character
		
		object oLastTarget = IntToObject(StringToInt(sPlayerID));
		if ( oChar != oLastTarget )
		{
			// this is a definite character switch, so make sure we run the proper event to handle it
			DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oChar ) );
			SetLocalGUIVariable(oChar,"SCREEN_PLAYERMENU",999,IntToString(ObjectToInt(oChar))); 
		}
		CSLUpdateStatsUIDisplay( oChar );
		
	}
	else if ( sInput=="clearallactions" ) // player clicked on the action queue
	{
		if ( CSLGetPreferenceSwitch( "EnableTomeOfBattle", FALSE) ) // possible to add option for clearing all actions for all players
		{
			AssignCommand(oChar, ClearAllActions());
			AssignCommand(oChar, TOBClearStrikes());
		}
	}
	else if ( sInput=="examine" ) // clicking portrait in partybar.XML normally does not do anything
	{
		// these are just for giggles, prolly don't need them
		//string sExamineName = sParam1;
		//string sExamineDesc = sParam2;
		
		//object oTarget = GetPlayerCreatureExamineTarget( oChar );
		
		//SetLocalString( oTarget, "CSL_EXAMINE_NAME", sExamineName);
		//SetLocalString( oTarget, "CSL_EXAMINE_DESC", sExamineDesc);
		
		
		DelayCommand(0.0f, ExecuteScript("_mod_onexamine", oChar ) );
		
		
		
		//SendMessageToPC( oChar, "Examine Target:"+GetName( oTarget )+" \n Name:"+sExamineName+" \n Desc:"+sExamineDesc);
		
		//if ( GetBaseItemType(oTarget) == BASE_ITEM_BOOK || GetBaseItemType(oTarget) == BASE_ITEM_SPELLSCROLL || GetBaseItemType(oTarget) == BASE_ITEM_BLANK_SCROLL || GetBaseItemType(oTarget) == BASE_ITEM_ENCHANTED_SCROLL )
		//{
			// so lets close the examine interface, and show the book interface instead
			
			// i'd like to set up a on-examine event as well instead, which might be pretty easy to accomodate
		//}
		
	}
	else if ( sInput == "InitUnsummon" ) // can't seem to get this to work, but this is the basic idea
	{
		object oTarget = GetPlayerCurrentTarget(oChar);
		if ( oChar == GetLocalObject(oTarget , "MASTER") )
		{
			SetGUIObjectHidden( oChar, SCREEN_CONTEXTMENU, "node-cslunsummon", FALSE ); // true hides, false shows
		}
		else
		{
			SetGUIObjectHidden( oChar, SCREEN_CONTEXTMENU, "node-cslunsummon", TRUE ); // true hides, false shows
		}
	}
	else if ( sInput == "Unsummon" ) // triggered from context menu
	{
		object oTarget = GetPlayerCurrentTarget(oChar);
		SCSummonRemove( oTarget );
	}
	else if ( sInput == "RemoveAtWillEffects" ) // triggered from context menu
	{
		object oTarget = GetPlayerCurrentTarget(oChar);
		CSLRemoveAtWillEffectsByCreator( oTarget, oChar, TRUE );
	}
	else if ( sInput=="portraitleftclick" ) // normally possess click in partybar.XML via left click
	{
		// this is a possible character switch, so make sure we run the proper event to handle it
		DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oChar ) );
	}
	else if ( sInput=="portraitrightclick" ) // normally target companion in partybar.XML
	{
		//
	}
	else if ( sInput=="portraitleftdoubleclick" ) // clicking portrait in partybar.XML normally UIButton_Input_CameraCompanion
	{
		//
	}
	else if ( sInput=="portraitrightdoubleclick" ) // clicking portrait in partybar.XML normally does not do anything
	{
		//
	}
	else if ( sInput=="dmpossess" ) // clicking portrait in partybar.XML normally does not do anything
	{
		DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oChar ) );
	}
	else if ( sInput=="dmunpossess" ) // clicking portrait in partybar.XML normally does not do anything
	{
		DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oChar ) );
	}
	else if ( sInput=="dmimpersonate" ) // clicking portrait in partybar.XML normally does not do anything
	{
		DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oChar ) );
	}
	else if ( sInput == "showextension" )
	{
		string sExtenderDesc;
		if ( GetLocalInt(oChar,"SCLIENTEXTENDER" ) )
		{
			sExtenderDesc = "Client Extension Is Installed Ver: "+GetLocalString(oChar,"SCLIENTEXTENDERVERSION");
		}
		else
		{
			sExtenderDesc = "You need to install the client extension";
		}
		//SendMessageToPC( oChar, "testing");
		


		string sAboutUsURL = GetLocalString( GetModule(), "CSL_URLABOUTUS" );//"http://nwcitadel.forgottenrealmsweave.org/showthread.php?t=1811&id=37";
		string sForumURL = GetLocalString( GetModule(), "CSL_URLFORUMS" );// "http://nwcitadel.forgottenrealmsweave.org/showthread.php?t=1811&";
		string sVaultPageURL = GetLocalString( GetModule(), "CSL_URLVAULTPAGE" );// "http://nwvault.ign.com/View.php?view=nwn2scripts.detail&id=37";
		SetGUIObjectText( oChar, "SCREEN_MENU_OPTIONS", "OPTIONS_EXTENDER", -1, sExtenderDesc );
		
		if ( sAboutUsURL != "" )
		{
			//Aboutus
			SetGUIObjectHidden(oChar, "SCREEN_MENU_OPTIONS", "BUTTON_MODULE_ABOUT", FALSE);
			SetLocalGUIVariable( oChar, "SCREEN_MENU_OPTIONS", 701, sAboutUsURL );	
		}
		if ( sForumURL != "" )
		{
			//forums
			SetGUIObjectHidden(oChar, "SCREEN_MENU_OPTIONS", "BUTTON_MODULE_FORUMS", FALSE);
			SetLocalGUIVariable( oChar, "SCREEN_MENU_OPTIONS", 700, sForumURL );	
		}
		if ( sVaultPageURL != "" )
		{
			//vault page
			SetGUIObjectHidden(oChar, "SCREEN_MENU_OPTIONS", "BUTTON_MODULE_VAULT", FALSE);
			SetLocalGUIVariable( oChar, "SCREEN_MENU_OPTIONS", 702,  sVaultPageURL );	
		}
	
	}
	else if ( sInput=="hideall" )
	{
		CloseGUIScreen(oChar,"SCREEN_HOTBAR");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_2");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V1");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V2");
		CloseGUIScreen(oChar,"SCREEN_MODEBAR");

		CloseGUIScreen(oChar,"SCREEN_CHATSELECT");
		//
		//CloseGUIScreen(oChar,"SCREEN_PARTYCHAT");
		if ( GetIsSinglePlayer() )
		{
			CloseGUIScreen(oChar,"SCREEN_MESSAGE_1");
		}
		else
		{
			CloseGUIScreen(oChar,"SCREEN_MESSAGEMP_1");
			CloseGUIScreen(oChar,"SCREEN_MESSAGEMP_2");
		}
		SetGUIObjectHidden( oChar, "SCREEN_PLAYERMENU", "PM_BUTTON_MENU", TRUE );
		SetGUIObjectHidden( oChar, "SCREEN_DMCTOOLBAR2", "DMC_MENU_PANE", TRUE );
	}
	else if ( sInput=="hidechat" )
	{
		CloseGUIScreen(oChar,"SCREEN_CHATSELECT");
		//CloseGUIScreen(oChar,"SCREEN_MESSAGE_1");
		//CloseGUIScreen(oChar,"SCREEN_PARTYCHAT");
		
		if ( GetIsSinglePlayer() )
		{
			CloseGUIScreen(oChar,"SCREEN_MESSAGE_1");
		}
		else
		{
			CloseGUIScreen(oChar,"SCREEN_MESSAGEMP_1");
			CloseGUIScreen(oChar,"SCREEN_MESSAGEMP_2");
		}
	}
	else if ( sInput=="hidetools" )
	{
		CloseGUIScreen(oChar,"SCREEN_HOTBAR");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_2");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V1");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V2");
		CloseGUIScreen(oChar,"SCREEN_MODEBAR");
		CloseGUIScreen(oChar, SCREEN_DMFI_TRGTOOL);
		CloseGUIScreen(oChar, SCREEN_DMFI_TRGTOOL);


		SetGUIObjectHidden( oChar, "SCREEN_PLAYERMENU", "PM_BUTTON_MENU", TRUE );
		SetGUIObjectHidden( oChar, "SCREEN_DMCTOOLBAR2", "DMC_MENU_PANE", TRUE );
	}
	else if ( sInput=="showall" )
	{
		
		DisplayGuiScreen(oChar,"SCREEN_HOTBAR", FALSE, "hotbar.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_2", FALSE, "hotbar_2.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V1", FALSE, "hotbar_v1.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V2", FALSE, "hotbar_v2.xml");
		DisplayGuiScreen(oChar,"SCREEN_MODEBAR", FALSE, "modebar.xml");

		DisplayGuiScreen(oChar,"SCREEN_CHATSELECT", FALSE, "chatselect.xml");
		
		DisplayGuiScreen(oChar,"SCREEN_PARTYCHAT", FALSE, "partychat.xml");

		
		
		
		if ( GetIsSinglePlayer() )
		{
			DisplayGuiScreen(oChar,"SCREEN_MESSAGE_1", FALSE, "defaultchat.xml");
		}
		else
		{
			DisplayGuiScreen(oChar,"SCREEN_MESSAGEMP_1", FALSE, "defaultmpchat1.xml");
			DisplayGuiScreen(oChar,"SCREEN_MESSAGEMP_2", FALSE, "defaultmpchat2.xml");
		}
		SetGUIObjectHidden( oChar, "SCREEN_PLAYERMENU", "PM_BUTTON_MENU", FALSE );
		SetGUIObjectHidden( oChar, "SCREEN_DMCTOOLBAR2", "DMC_MENU_PANE", FALSE );

	}
	else if ( sInput=="showchat" )
	{
		DisplayGuiScreen(oChar,"SCREEN_CHATSELECT", FALSE, "chatselect.xml");
		if ( GetIsSinglePlayer() )
		{
			DisplayGuiScreen(oChar,"SCREEN_MESSAGE_1", FALSE, "defaultchat.xml");
		}
		else
		{
			DisplayGuiScreen(oChar,"SCREEN_MESSAGEMP_1", FALSE, "defaultmpchat1.xml");
			DisplayGuiScreen(oChar,"SCREEN_MESSAGEMP_2", FALSE, "defaultmpchat2.xml");
		}
	}
	else if ( sInput=="showtools" )
	{
		
		DisplayGuiScreen(oChar,"SCREEN_HOTBAR", FALSE, "hotbar.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_2", FALSE, "hotbar_2.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V1", FALSE, "hotbar_v1.xml");
		//DisplayGuiScreen(oChar,"SCREEN_HOTBAR_V2", FALSE, "hotbar_v2.xml");
		DisplayGuiScreen(oChar,"SCREEN_MODEBAR", FALSE, "modebar.xml");

		SetGUIObjectHidden( oChar, "SCREEN_PLAYERMENU", "PM_BUTTON_MENU", FALSE );
		SetGUIObjectHidden( oChar, "SCREEN_DMCTOOLBAR2", "DMC_MENU_PANE", FALSE );
	}
	else if ( sInput=="voicethrowon" )
	{
		SCVoiceThrowing( oChar, TRUE );
	}
	else if ( sInput=="voicethrowoff" )
	{
		SCVoiceThrowing( oChar, FALSE );
	}
	
	else if ( sInput=="followon" )
	{
		// need to restrict who can follow to only those in the same party and the like
		// isvalidfollowtarget function perhaps
		object oTarget = GetPlayerCurrentTarget(oChar);
		if ( CSLAutoFollowIsValid( oChar, oTarget ) )
		{
			CSLAutoFollowOn( oChar, oTarget);
		}
		else
		{
			SendMessageToPC(oChar,"Please select a valid target to follow");
		}
	}
	else if ( sInput=="followoff" )
	{
		//SCVoiceThrowing( oChar, TRUE );
		CSLAutoFollowOff( oChar );
	}
	
	
	else if ( sInput=="autobuff" )
	{
		if ( CSLGetIsInTown(oChar) )
		{
			// fast buffing in town
			HkAutoBuff( oChar, oChar, TRUE, 10, FALSE, FALSE );
		}
		else
		{
			HkAutoBuff( oChar, oChar, FALSE, 10, FALSE, FALSE );
		}
	}
}