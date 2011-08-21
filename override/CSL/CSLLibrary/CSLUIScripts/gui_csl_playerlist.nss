#include "_SCInclude_Playerlist"
#include "_SCInclude_CharEdit"

void main( string sInput, string sPlayerID = "",  string sStatusMessage = "")
{
	string sScreenName = "SCREEN_CHATSELECT";
	string sListBox = "RosterMemberList";
	object oPC = OBJECT_SELF;
	
	//SendMessageToPC( GetFirstPC(), "Running "+sInput +" "+sPlayerID );
	
	// object oTarget = IntToObject(StringToInt(sPlayerID));
	
	// basic interface issues up front
	if ( sInput=="update" )
	{
		CSLPlayerList_Update( oPC, sScreenName, sListBox );
		return;
	}
	else if ( sInput=="setup")
	{
		CSLPlayerList_Build( oPC, sScreenName, sListBox );
		return;
	}
	else if ( sInput=="iconselect") // left click on icon
	{
		SetGUIObjectHidden( oPC, sScreenName, "CSL_INFOBOX", FALSE );
		return;
	}
	else if ( sInput=="select") // right click on row
	{
		SetGUIObjectHidden( oPC, sScreenName, "CSL_INFOBOX", FALSE );
		CSLBuildPlayerListInfoPane(  oPC, IntToObject(StringToInt(sPlayerID)), sScreenName );
		return;
	}
	else if ( sInput=="chatselect") // left click on row, 
	{
		CSLBuildPlayerListInfoPane(  oPC, StringToObject(sPlayerID), sScreenName );
		return;
	}
	else if ( sInput=="hideinfopane")
	{
		SetGUIObjectHidden( oPC, sScreenName, "CSL_INFOBOX", TRUE );
		return;
	}
	
	if ( sInput=="Button1")
	{
		sInput = GetLocalString( oPC, "CSL_PLAYERLIST_BUTTON1" );
	}
	else if ( sInput=="Button2" )
	{
		sInput = GetLocalString( oPC, "CSL_PLAYERLIST_BUTTON2" );
	}
	else if ( sInput=="Button3")
	{
		sInput = GetLocalString( oPC, "CSL_PLAYERLIST_BUTTON3" );
	}
	else if ( sInput=="Button4")
	{
		sInput = GetLocalString( oPC, "CSL_PLAYERLIST_BUTTON4" );
	}
	
	
	if ( sInput=="Invite")
	{
	
	}
	else if ( sInput=="Like")
	{
		CSLSetAsEnemy( IntToObject(StringToInt(sPlayerID)), oPC, FALSE );
	}
	else if ( sInput=="Dislike")
	{
		CSLSetAsEnemy( IntToObject(StringToInt(sPlayerID)), oPC, TRUE );
	}
	else if ( sInput=="Boot")
	{
	
	}
	else if ( sInput=="TransferLeader")
	{
	
	}
	else if ( sInput=="dmtarget")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
		// GetPlayerCurrentTarget
		}
		return;
	}
	else if ( sInput=="dminspect")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			object oTarget = IntToObject(StringToInt(sPlayerID));
			if ( GetIsObjectValid(oTarget) )
			{
				//CSLInfoBox( oPC, "Info", GetName(oTarget)+" Information", CSLGetObjectInfo(oTarget) );
				SCCharEdit_Display( oTarget, oPC );
			}
		}
		return;
	
	}
	else if ( sInput=="dmheal")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			CSLDMHeal( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="dmkill")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			CSLDMKill( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="dmvarmanager")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			//CSLDMKill( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="dmpcinventory")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			//CSLDMKill( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="port_here")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			CSLDMPortHere( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="port_there")
	{
		if ( CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			CSLDMPortThere( IntToObject(StringToInt(sPlayerID)), oPC );
		}
		return;
	}
	else if ( sInput=="accept_invite")
	{
	
	}
	else if ( sInput=="reject_invite")
	{
	
	}
	else if ( sInput=="ignore_invites")
	{
	
	}
	// Custom Buttons
	// LFP
	else if ( sInput=="Look For Party")
	{
		CSLPlayerList_SetLookingForParty( oPC, TRUE, 4 );
	}
	else if ( sInput=="End LFG")
	{
		CSLPlayerList_SetLookingForParty( oPC, FALSE, 4 );
	}
	// AFK
	else if ( sInput=="Go AFK")
	{
		CSLPlayerList_SetAFK( oPC, TRUE, 3 );
	}
	else if ( sInput=="End AFK")
	{
		CSLPlayerList_SetAFK( oPC, FALSE, 3 );
	}
	// Faction
	else if ( sInput=="Faction")
	{
		CSLPlayerList_SetFaction( oPC, TRUE, 2 );
		return;
	}
	else if ( sInput=="Hide Faction")
	{
		CSLPlayerList_SetFaction( oPC, FALSE, 2 );
		return;
	}
	else if ( sInput=="Custom")
	{
		DisplayGuiScreen(oPC,"SCREEN_ENTERSTATUS", FALSE, "chatselect_setstatus.xml");
		SetLocalGUIVariable( oPC, "SCREEN_ENTERSTATUS", 1, IntToString(ObjectToInt( oPC )) );
		SetGUIObjectText( oPC, "SCREEN_ENTERSTATUS", "INPUT_BOX", -1, GetLocalString( oPC, "CSL_PLAYERLIST_STATUS") );
		//CSLPlayerList_SetAFK( oPC, FALSE, 1 );
	}
	else if ( sInput=="SetStatus")
	{
		CSLPlayerList_ResetButtons( oPC, 1 );
		SetLocalString( oPC, "CSL_PLAYERLIST_STATUS", sStatusMessage );
		DelayCommand( 0.25f, CSLUIBroadCastPlayerListBoxRow( CSL_LISTBOXROW_MODIFY, oPC, "SCREEN_CHATSELECT", "RosterMemberList" ) );
		//CSLPlayerList_SetAFK( oPC, FALSE, 1 );  sStatusMessage
	}
}