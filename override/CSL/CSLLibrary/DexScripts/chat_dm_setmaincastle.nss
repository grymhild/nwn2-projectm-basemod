//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_faction"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	string sFAID = DEXBattle_getFactionFAID( sParameters );
	
	int iFAID = StringToInt( sFAID );
	
	if ( CSLTrim(GetStringLowerCase( sParameters )) == "none" )
	{
		SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", "" );
	}
	else if ( iFAID > 0 )
	{
		//CSLAssignTester(  oTarget, TRUE );
		SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", sFAID );
		// SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NW_FACTION", sFAID );
		SendMessageToPC(oDM, sParameters + " has taken over the Main Castle" );
	}
	else
	{
		//SetLocalString( GetModule(), "SC_BATTLE_CASTLE_NE_FACTION", sFAID );	
		SendMessageToPC(oDM, "Faction is not valid, try fallen, tb, pkr, order, triad, none" );
	}

}