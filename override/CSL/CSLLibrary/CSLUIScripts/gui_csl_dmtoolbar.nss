////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmui - DM Friendly Initiative - GUI script for top level DM UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/19/6  qk: 10/07/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script handles the TOP LEVEL DM UI.  It performs a pretty straightforward initialization
// of the text boxes for the TOOL LEVEL UIs.  A flag is set so that we can run all the UI code
// from one single script for all "tool level" UIs. 

// This version is set up to handle the actual DM Client interfaces as well as one integrated package.

// TRANSLATION NOTE:  TEXT HERE REQUIRES TRANSLATION
#include "_SCInclude_DMFI"
#include "_SCInclude_Playerlist"
#include "_SCInclude_DMInven"
#include "_SCInclude_CharEdit"
//#include "_SCInclude_Chat"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oRename, oTest;
	object oTool = CSLDMFI_GetTool(oPC);
	string sTest;
	
	// CLOSE ALL OTHER UIs Just in case		
	CloseGUIScreen(oPC, SCREEN_DMFI_VFXTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_SNDTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_AMBTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_MUSICTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_DICETOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_DMLIST);
	//CloseGUIScreen(oPC, SCREEN_DMFI_TRGTOOL);
	//CloseGUIScreen(oPC, SCREEN_DMC_CREATOR);
	//CloseGUIScreen(oPC, SCREEN_DMC_CHOOSER);
	CSLDMFI_ClearUIData(oPC);
	//SendMessageToPC(oPC, "<color=indianred>" + sInput  +"</color>");
	// use the chat commands permission system, perhaps centralize this soas to protect all gui scripts and make chat alternatives when gui codes go down
	
	if ( !CSLGetIsDM( oPC ) )
	{
			//SendMessageToPC(oPC, "<color=indianred>" + "Not DM"  +"</color>");
			return;
	}
	
	if (sInput=="targeting" )
	{
		DisplayGuiScreen(oPC,SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
	}
	else if (sInput=="chattoggle" )
	{
		if ( CSLGetPreferenceSwitch( "HideDMInChat", FALSE) && CSLGetPreferenceSwitch( "HideDMInChatOnDMHidden", FALSE) )
		{
			CSLPlayerList_HiddenToggle( oPC );
		}
	}
	else if (sInput=="chattogglealways" )
	{
		CSLPlayerList_HiddenToggle( oPC );
	}
	else if (sInput=="chatshown" )
	{
		SendMessageToPC( oPC, "You are now shown on chat");
		CSLPlayerList_SetHidden( oPC, FALSE  );
	}
	else if (sInput=="chathidden" )
	{
		SendMessageToPC( oPC, "You are now hidden in chat");
		CSLPlayerList_SetHidden( oPC, TRUE  );
	}
	else if (sInput=="visible" )
	{
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCINVISIBILITY_TOGGLE_BUTTON", FALSE );
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCVISIBILITY_TOGGLE_BUTTON", TRUE );
		SendMessageToPC( oPC, "You are now visible");
		DoDMUninvis( oPC );
	}
	else if (sInput=="invisible" )
	{
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCINVISIBILITY_TOGGLE_BUTTON", TRUE );
		SetGUIObjectHidden( oPC, "SCREEN_DMCTOOLBAR2", "PCVISIBILITY_TOGGLE_BUTTON", FALSE );
		SendMessageToPC( oPC, "You are now invisible");
		DoDMInvis( oPC );
	}
	else if (sInput=="heal" || sInput=="healall" )
	{
		object oTarget = GetPlayerCurrentTarget( oPC );
		if ( !GetIsObjectValid( oTarget ) )
		{
			return;
		}
		ApplyEffectToObject(0, EffectResurrection(), oTarget);
		CloseGUIScreen( oTarget, GUI_DEATH );
		CloseGUIScreen(oTarget, GUI_DEATH_HIDDEN);
		CSLEnviroRemoveEffects( oTarget );
		ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oTarget)- GetCurrentHitPoints(oTarget)), oTarget);
		SendMessageToPC(oPC, "<color=indianred>" + GetName(oTarget) +" is now resurrected."+"</color>");
		if (sInput=="healall")
		{
			location lTarget = GetLocation( oTarget );
			object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			while ( GetIsObjectValid(oAlly) )
			{
				if ( GetIsOwnedByPlayer( oAlly ) || GetIsPC( oAlly ) )
				{
					ApplyEffectToObject(0, EffectResurrection(), oAlly);
					CloseGUIScreen( oAlly, GUI_DEATH );
					CloseGUIScreen(oAlly, GUI_DEATH_HIDDEN);
					ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oAlly)- GetCurrentHitPoints(oAlly)), oAlly);
					SendMessageToPC(oPC, "<color=indianred>" + GetName(oAlly) +" is now resurrected."+"</color>");
				}
				oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
		}
		//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		//DisplayGuiScreen(oPC, SCREEN_XXXXXX, FALSE, "xxx.xml");
	}
	else if (sInput=="kill" || sInput=="killall" )
	{
		//SendMessageToPC(oPC, "<color=indianred>" + "in killing"  +"</color>");
		object oTarget = GetPlayerCurrentTarget( oPC );
		if ( !GetIsObjectValid( oTarget ) )
		{
			//SendMessageToPC(oPC, "<color=indianred>" + "not valid"  +"</color>");
			return;
		}
		//if (CSLVerifyDMKey(oTarget))
		//{
		//	//SendMessageToPC(oPC, "<color=indianred>" + "dm"  +"</color>");
		//}
		
		//if (CSLVerifyAdminKey(oTarget))
		//{
		//	SendMessageToPC(oPC, "<color=indianred>" + "admin"  +"</color>");
		//}
		
		if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)))//this command may not be used on dms or admins
		{
			//SendMessageToPC(oPC, "<color=indianred>" + "verfied non DM"  +"</color>");
			SetPlotFlag(oTarget, FALSE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oTarget))), oTarget);
			
			SendMessageToPC(oPC, "<color=indianred>" + GetName(oTarget)+" is now dead."+"</color>");
		}
		
		
		if ( sInput=="killall" )
		{
			location lTarget = GetLocation( oTarget );
			object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			while ( GetIsObjectValid(oAlly) )
			{
				if ( !GetIsOwnedByPlayer( oAlly ) && !GetIsPC( oAlly ) )
				{
					SetPlotFlag(oAlly, FALSE);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oAlly);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oAlly))), oAlly);
					SendMessageToPC(oPC, "<color=indianred>" + GetName(oAlly)+" is now dead."+"</color>");
				}
				oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
		
		}
	}
	else if (sInput=="creator")
	{
		//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMC_CREATOR, FALSE, "dmccreator.xml");
	}
	else if (sInput=="chooser")
	{
		//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMC_CHOOSER, FALSE, "dmcchooser.xml");
	}
	else if (sInput=="caster")
	{
		//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMC_CASTER, FALSE, "dmccaster.xml");
	}
	else if (sInput=="pccaster")
	{
		//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_SPELLS_QUICK, FALSE, "quickspell.xml");
	}
	else if (sInput=="vfx")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_VFXTOOL, FALSE, "dmfivfxtool.xml");
		
		SetLocalString(oPC, "DMFI_UI_USE", "VFXTOOL");
				
		sTest = GetLocalString(oTool, DMFI_VFX_DURATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "update_dur", -1, sTest);
						
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub1", -1, CV_VF_SPELLS);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub2", -1, CV_VF_INVOCATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub3", -1, CV_VF_DURATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub4", -1, CV_VF_MISC);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub5", -1, CV_VF_RECENT);
	}	

	else if (sInput=="ambient")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "ListTitle", -1, CV_AMBIENT + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_AMBTOOL, FALSE, "dmfiambtool.xml");
		
		sTest = GetLocalString(oTool, DMFI_AMB_NIGHT);
		sTest = CSLStringToProper(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "toggle_ambdaynight", -1, sTest);
		
		sTest = GetLocalString(oTool, DMFI_AMBIENT_VOLUME);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "update_vol", -1, sTest);	
				
		SetLocalString(oPC, "DMFI_UI_USE", "AMBTOOL");
		
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub1", -1,CV_AM_CAVE);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub2", -1,CV_AM_MAGIC);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub3", -1,CV_AM_PEOPLE);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub4", -1,CV_AM_MISC);
		SetGUIObjectHidden(oPC, SCREEN_DMFI_AMBTOOL, "sub5", TRUE);
	}	
	else if (sInput=="sounds")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "ListTitle", -1, CV_SOUND + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_SNDTOOL, FALSE, "dmfisndtool.xml");
		
		sTest = GetLocalString(oTool, DMFI_SOUND_DELAY);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "update_delay", -1, sTest);	
				
		SetLocalString(oPC, "DMFI_UI_USE", "SNDTOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub1", -1, CV_SD_CITY);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub2", -1, CV_SD_MAGIC);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub3", -1, CV_SD_NATURE);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub4", -1, CV_SD_PEOPLE);	
		SetGUIObjectHidden(oPC, SCREEN_DMFI_SNDTOOL, "sub5", TRUE);
	}	
	
	else if (sInput=="music")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "ListTitle", -1, CV_MUSIC + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_MUSICTOOL, FALSE, "dmfimusictool.xml");
		
		sTest = GetLocalString(oTool, DMFI_MUSIC_TIME);
		sTest = CSLStringToProper(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "toggle_musictime", -1, sTest);
				
		SetLocalString(oPC, "DMFI_UI_USE", "MUSICTOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub1", -1, CV_MC_NWN2);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub2", -1, CV_MC_NWN1);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub3", -1, CV_MC_XP);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub4", -1, CV_MC_BATTLE);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub5", -1, CV_MC_MOTB);
		//SetGUIObjectHidden(oPC, SCREEN_DMFI_MUSICTOOL, "sub5", TRUE);
	}
	else if (sInput=="dice")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "ListTitle", -1, CV_DICE + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_DICETOOL, FALSE, "dmfidicetool.xml");
		
		sTest = GetLocalString(oTool, "DMFIDicebagDC");
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "update_dc", -1, sTest);
		
		sTest = GetLocalString(oTool, "DMFIDicebagDetail");
		sTest = CSLStringToProper(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_detail", -1, sTest);	
			
		sTest = GetLocalString(oTool, "DMFIDicebagReport");
		sTest = CSLStringToProper(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_report", -1, sTest);
		
		sTest = GetLocalString(oTool, "DMFIDicebagRoll");
		sTest = CSLStringToProper(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_roll", -1, sTest);	
			
		SetLocalString(oPC, "DMFI_UI_USE", "DICETOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub1", -1, CV_DI_ABIL);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub2", -1, CV_DI_SKILL);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub3", -1, CV_DI_DICE);	
	}
	else if (sInput=="inventory")
	{
	
	}
	else if (sInput=="variables")
	{
	
	}
	// Follow On runs straight via here.	
	else
	{
		SetLocalString(oPC, DMFI_LAST_UI_COM, "language ");
		SetLocalString(oPC, DMFI_UI_PAGE, "LIST_DMLANGUAGE");
		SetLocalString(oPC, DMFI_UI_LIST_TITLE, "Please select a language:");
		DMFI_ShowDMListUI(oPC);
	}
}			