/** @file
* @brief Include File for Player List, Chat Select and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_Class"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Items"
#include "_CSLCore_Strings"
#include "_CSLCore_UI"
#include "_CSLCore_Appearance"


void CSLBuildPlayerListRow( int iAction, object oPlayer, object oCurrentPC, string sMyFaction, string sScreenName, string sListBox )
{
	//SendMessageToPC( GetFirstPC(), "Running CSLBuildPlayerListRow" );
	string sName = GetName(oCurrentPC);
	string sRowName = GetName(oCurrentPC); // must have unique names
	
	if ( iAction == CSL_LISTBOXROW_REMOVE )
	{
		//SendMessageToPC( GetFirstPC(), "Remove" );
		RemoveListBoxRow( oPlayer, sScreenName, sListBox, sRowName );
		return;
	}

	
	int iVisible = TRUE;
	int iIncognito = FALSE;
	//GetIsDM( oCurrentPC );
	//!GetIsDM( oPlayer ) &&
	if ( GetLocalInt(oCurrentPC,"CSL_PLAYERLIST_HIDDEN" ) == TRUE  )
	{
		iIncognito = TRUE;
		if ( !CSLGetIsDM(oPlayer) )
		{
			RemoveListBoxRow( oPlayer, sScreenName, sListBox, sRowName );
			return;
		}
	}
	
	
	
	string sIcon;
	string sStatus;
	string sTextures;
	string sFields;
	string sVariables;
	string sHide = "";
	
	string sCurrentFaction = GetLocalString( oCurrentPC, "CSL_FACTIONNAME");
	
	sStatus = GetLocalString( oCurrentPC, "CSL_PLAYERLIST_STATUS");
	
	string sTitle = GetLocalString( oCurrentPC, "CSL_PLAYERLIST_TITLE");
	if ( sTitle != "" )
	{
		sName = sTitle+" "+sName;
	}

	if ( iIncognito == TRUE )
	{
		sIcon = "temp0.tga";
	}
	else if ( GetIsDM( oCurrentPC )  )
	{
		sIcon = "ip_reput_dm.tga";
	}
	else if ( sMyFaction == sCurrentFaction && sMyFaction != "None" )
	{
		sIcon = "ip_reput_ally.tga";
	}
	else
	{
		if(GetFactionEqual(oCurrentPC, oPlayer) ) // same faction, must be leader
		{
			if ( oCurrentPC == GetFactionLeader(oPlayer) )
			{
				sIcon = "ip_reput_partylead.tga";
			}
			else
			{
				sIcon = "ip_reput_party.tga";
			}
		}
		else if(GetIsReactionTypeFriendly(oCurrentPC,oPlayer))
		{
			sIcon = "ip_reput_nice.tga";
		}
		else if( GetIsEnemy(oCurrentPC,oPlayer) || GetIsReactionTypeHostile(oCurrentPC, oPlayer) )
		{
			sIcon = "ip_reput_enemy.tga";
		}
		else
		{
			sIcon = "ip_reput_unknown.tga";
		}
	}
	
	sTextures = "CSL_REPUTATION="+sIcon;
	sFields = "CSL_NAME="+sName+";"+"CSL_STATUS="+sStatus;
	sVariables = "1="+IntToString(ObjectToInt(oCurrentPC));
	/*
	if ( iVisible )
	{
		sHide = "=unhide;PrototypeButton=unhide;CSL_REPUTATION=unhide;CSL_NAME=unhide;CSL_STATUS=unhide;";
	}
	else
	{
		sHide = "=hide;PrototypeButton=hide;CSL_REPUTATION=hide;CSL_NAME=hide;CSL_STATUS=hide;";
	}
	*/
	if ( iAction == CSL_LISTBOXROW_ADD )
	{			
		//SendMessageToPC( GetFirstPC(), "AddListBoxRow(oPlayer,sScreenName,sListBox,sRowName,sFields,sTextures,sVariables,"+sHide+");" );
		AddListBoxRow(oPlayer,sScreenName,sListBox,sRowName,sFields,sTextures,sVariables,sHide);		
	}
	else
	{
		//SendMessageToPC( GetFirstPC(), "ModifyListBoxRow( oPlayer,"+sScreenName+","+sListBox+","+sRowName+","+sFields+","+sTextures+","+sVariables+", "+sHide+");" );
		ModifyListBoxRow( oPlayer,sScreenName,sListBox,sRowName,sFields,sTextures,sVariables,sHide);
	}			
}

void CSLBuildPlayerListInfoPane( object oPlayer, object oCurrentPC, string sScreenName )
{
	int bIsDm = CSLGetIsDM(oPlayer);
	//int bIsTargetDm = GetIsDM(oCurrentPC);
	
	string sDescription = "";
	
	
	ExecuteScript("_mod_onplayerlistview", oCurrentPC);
	if ( bIsDm )
	{
		sDescription = GetLocalString( oCurrentPC, "CSL_PLAYERLIST_DMDESCRIPTION");
	}
	else
	{
		sDescription = GetLocalString( oCurrentPC, "CSL_PLAYERLIST_DESCRIPTION");
	}
	
	SetGUIObjectText( oPlayer, sScreenName, "CSL_CHARREFERENCE", -1,IntToString(ObjectToInt(oCurrentPC))   );
	SetLocalGUIVariable(oPlayer,sScreenName,1,IntToString(ObjectToInt(oCurrentPC))); 
	
	
	SetGUIObjectText( oPlayer, sScreenName, "CHARACTER_DESCRIPTION", -1, sDescription );
	
	CSLSetGuiObjectButton( oPlayer, sScreenName, "CSL_BUTTON1", GetLocalString( oPlayer, "CSL_PLAYERLIST_BUTTON1") );
	CSLSetGuiObjectButton( oPlayer, sScreenName, "CSL_BUTTON2", GetLocalString( oPlayer, "CSL_PLAYERLIST_BUTTON2") );
	CSLSetGuiObjectButton( oPlayer, sScreenName, "CSL_BUTTON3", GetLocalString( oPlayer, "CSL_PLAYERLIST_BUTTON3") );
	CSLSetGuiObjectButton( oPlayer, sScreenName, "CSL_BUTTON4", GetLocalString( oPlayer, "CSL_PLAYERLIST_BUTTON4") );
	
	// Dm Commands
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_DMTARGET", !bIsDm ); // true hides
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_DMINSPECT", !bIsDm ); // true hides
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_DMHEAL", !bIsDm ); // true hides
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_DMKILL", !bIsDm ); // true hides
	
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_PORT_HERE", !bIsDm ); // true hides
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_PORT_THERE", !bIsDm ); // true hides
	
	// * character commands
	//CSL_INVITE
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_LIKE", FALSE ); // true hides, false shows
	SetGUIObjectHidden( oPlayer, sScreenName, "CSL_DISLIKE", FALSE ); // true hides, false shows
	//CSL_BOOT
	//CSL_TRANSFERLEADER
	//CSL_ACCEPTINVITE
	//CSL_REJECTINVITE
	//CSL_IGNOREINVITES

}





// * buttons are between 1 to 4
void CSLPlaylistSetButton( object oPlayer, int iButtonNumber, string sButtonLabel )
{
	
	if ( iButtonNumber > 0 && iButtonNumber < 5 )
	{
		CSLSetGuiObjectButton( oPlayer, SCREEN_CHATSELECT, "CSL_BUTTON"+IntToString(iButtonNumber), sButtonLabel );
		//SetGUIObjectText( oPlayer, "SCREEN_CHATSELECT", "CSL_BUTTON"+IntToString(iButtonNumber), -1, sButtonLabel );
		SetLocalString( oPlayer, "CSL_PLAYERLIST_BUTTON"+IntToString(iButtonNumber), sButtonLabel );
	}

}

// these are the defaults
void CSLPlayerList_ResetButtons( object oPC = OBJECT_SELF, int iButtonToIgnore = -1 )
{
	/* set up the default client entries here */
	if ( iButtonToIgnore != 1)
	{
		CSLPlaylistSetButton( oPC, 1, "Custom" );
	}
	if ( iButtonToIgnore != 2)
	{
		CSLPlaylistSetButton( oPC, 2, "Faction" );
	}
	if ( iButtonToIgnore != 3)
	{
		CSLPlaylistSetButton( oPC, 3, "Go AFK" );
	}
	if ( iButtonToIgnore != 4)
	{
		CSLPlaylistSetButton( oPC, 4, "Look For Party" );
	}
}

// Rebuilds the complete player list
void CSLPlayerList_Build( object oPlayer, string sScreenName, string sListBox )
{
	ClearListBox(oPlayer,sScreenName,sListBox); // rebuilds entire player list for the player
	string sFaction = GetLocalString( oPlayer, "CSL_FACTIONNAME");
	
	// iterate the list of players
	object oPlayerObject = CSLDataObjectGet( "PlayerList", TRUE );
	
	string sCurrentPC;
	object oCurrentPC;
	int count = GetVariableCount( oPlayerObject );
	int x;
	
	for (x = count-1; x >= 0; x--) 
	{
		sCurrentPC = GetVariableName(oPlayerObject, x);
		oCurrentPC = GetVariableValueObject(oPlayerObject, x );
		
		if ( GetIsObjectValid( oCurrentPC ) )
		{
			CSLBuildPlayerListRow( CSL_LISTBOXROW_ADD, oPlayer, oCurrentPC, sFaction, sScreenName, sListBox );	
		}
		else
		{
			// it's already cleared so we don't have to do it for this character, but we need to globally clear it for the rest
			DelayCommand( 0.5f, CSLUIBroadCastRemoveListBoxRow( "SCREEN_CHATSELECT", "RosterMemberList", GetName( oCurrentPC ) ) );
			DeleteLocalObject( oPlayerObject, sCurrentPC );
		}
	}
}


void CSLPlayerList_Update( object oPlayer, string sScreenName, string sListBox )
{
	string sFaction = GetLocalString( oPlayer, "CSL_FACTIONNAME");
	
	// iterate the list of players
	object oPlayerObject = CSLDataObjectGet( "PlayerList", TRUE );
	
	string sCurrentPC;
	object oCurrentPC;
	int count = GetVariableCount( oPlayerObject );
	int x;
	for (x = count-1; x >= 0; x--) 
	{
		sCurrentPC = GetVariableName(oPlayerObject, x);
		oCurrentPC = GetVariableValueObject(oPlayerObject, x );
		
		if ( GetIsObjectValid( oCurrentPC ) )
		{
			CSLBuildPlayerListRow( CSL_LISTBOXROW_MODIFY, oPlayer, oCurrentPC, sFaction, sScreenName, sListBox );	
		}
		else
		{
			CSLBuildPlayerListRow( CSL_LISTBOXROW_REMOVE, oPlayer, oCurrentPC, sFaction, sScreenName, sListBox );
			DelayCommand( 0.5f, CSLUIBroadCastRemoveListBoxRow( "SCREEN_CHATSELECT", "RosterMemberList", GetName( oCurrentPC ) ) );
			DeleteLocalObject( oPlayerObject, sCurrentPC );
		}
	}
}

void CSLUIBroadCastPlayerListBoxRow( int iAction, object oCurrentPC, string sScreenName, string sListBox )
{
	object oTargetPC = GetFirstPC();
	while (GetIsObjectValid(oTargetPC))
	{
		string sFaction = GetLocalString( oTargetPC, "CSL_FACTIONNAME");
		
		CSLBuildPlayerListRow( iAction, oTargetPC, oCurrentPC, sFaction, sScreenName, sListBox );
		oTargetPC = GetNextPC();
	}
}

void CSLPlayerList_SetFaction( object oPC = OBJECT_SELF, int bActive = TRUE, int iButtonRow = 2  )
{
	if ( bActive )
	{
		
		CSLPlayerList_ResetButtons( oPC, iButtonRow );
		CSLPlaylistSetButton( oPC, iButtonRow, "Hide Faction" );
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", GetLocalString( oPC, "CSL_FACTIONNAME") );
		DelayCommand( 0.45f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
	}
	else
	{
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "-");
		CSLPlaylistSetButton( oPC, iButtonRow, "Faction" );
		DelayCommand( 0.45f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );

	}
}

void CSLPlayerList_SetHidden( object oPC = OBJECT_SELF, int bActive = TRUE, int iButtonRow = -1  ) // only for dm's so share the setting with factions - dms are not in a faction generally
{
	if ( bActive )
	{
		SetLocalInt(oPC,"CSL_PLAYERLIST_HIDDEN", TRUE );
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "-");
		CSLPlayerList_ResetButtons( oPC, iButtonRow );
		CSLPlaylistSetButton( oPC, iButtonRow, "Go Visible" );
		//DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
		DelayCommand( 0.50f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_REMOVE, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
		DelayCommand( 1.00f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_ADD, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );

		
		
	}
	else
	{
		DeleteLocalInt(oPC,"CSL_PLAYERLIST_HIDDEN" );
		CSLPlaylistSetButton( oPC, iButtonRow, "Go Invisible" );
		DelayCommand( 0.50f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_REMOVE, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
		DelayCommand( 1.00f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_ADD, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );

	}
}

void CSLPlayerList_HiddenToggle( object oPC = OBJECT_SELF, int iButtonRow = -1  )
{
	if ( GetLocalInt(oPC,"CSL_PLAYERLIST_HIDDEN" ) )
	{
		CSLPlayerList_SetHidden( oPC, FALSE, iButtonRow  );
	}
	else
	{
		CSLPlayerList_SetHidden( oPC, TRUE, iButtonRow );
	}
}

const int SPELLPC_AFK = -999;
const string SPELLPC_AFKEFFECT = "fx_hss_afk_01";

void CSLPlayerList_SetAFK( object oPC = OBJECT_SELF, int bActive = TRUE, int iButtonRow = 3  )
{
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLPC_AFK );
	if ( bActive )
	{
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "AFK");
		CSLPlayerList_ResetButtons( oPC, iButtonRow );
		CSLPlaylistSetButton( oPC, iButtonRow, "End AFK" );
		
		// 1 = "AFK", 2 = arrow pointing up, 3 = "silhouette" model with sparklies, 4 = just sparklies, 5 = alpha model with sparklies, 6 = "silhouette" model without sparklies. 
		int iAFKEffectVisual = CSLGetPreferenceInteger( "PCToolsAFKVisual", 0);
		if ( iAFKEffectVisual > 0 )
		{
			effect eAFK = SupernaturalEffect(SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_hss_afk_0"+IntToString(CSLGetWithinRange(iAFKEffectVisual,1,6))), -999));	
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAFK, oPC);
		}
		
		DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
	}
	else
	{
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "-");
		CSLPlaylistSetButton( oPC, iButtonRow, "Go AFK" );
		DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
	}
}


void CSLPlayerList_SetLookingForParty( object oPC = OBJECT_SELF, int bActive = TRUE, int iButtonRow = 4  )
{
	if ( bActive )
	{
		string sClasses = CSLClassLevels(oPC, TRUE, FALSE);
		string sSubrace = CSLGetSubraceName(GetSubRace(oPC));
		int iLevel = GetHitDice(oPC);
		string sLFG = "Level " + IntToString(iLevel) + " looking for Party <color=brown>(" + sSubrace + " : " + sClasses + ")</color>";
		//SpeakString(sLFG, TALKVOLUME_SHOUT);
		SendChatMessage(oPC, OBJECT_INVALID, CHAT_MODE_SHOUT, sLFG, FALSE );
		//CSLPlaylistSetButton( oPC, iButtonRow, "End LFG" );
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "LFG");
		CSLPlayerList_ResetButtons( oPC, iButtonRow );
		CSLPlaylistSetButton( oPC, iButtonRow, "End LFG" );
		DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
	}
	else
	{
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", "-");
		CSLPlaylistSetButton( oPC, iButtonRow, "Look For Party" );
		DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );

	}
}




void CSLPlayerList_ClientEnter( object oPC = OBJECT_SELF )
{
	object oPlayerObject = CSLDataObjectGet( "PlayerList", TRUE );
	SetLocalObject( oPlayerObject, ObjectToString( oPC ), oPC );
	
	/* set up the default client entries here */
	CSLPlayerList_ResetButtons( oPC, 2 );
	CSLPlayerList_SetFaction( oPC, TRUE, 2  );
	
	DelayCommand( 2.5f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_ADD, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
}


void CSLPlayerList_ClientExit( object oPC = OBJECT_SELF )
{
	object oPlayerObject = CSLDataObjectGet( "PlayerList", TRUE );
	CSLUIBroadCastRemoveListBoxRow( "SCREEN_CHATSELECT", "RosterMemberList", GetName( oPC ) );
	DeleteLocalObject( oPlayerObject, ObjectToString( oPC ) );
}