//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
/*
	This code assumes a player does not have a really complicated builds, and will focus on the first class they took which can actually use the given spell which makes they syntax very easy.
*/
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	/*
	int iClass = 255 ;
	string sClass = GetStringLowerCase(CSLNth_GetNthElement( sParameters, 1, " "));
	string sLevel = CSLNth_GetNthElement( sParameters, 2, " ");
	
	if ( sClass == "help" )
	{
		
		SendMessageToPC( oDM,"Usage: listfeat");
		SendMessageToPC( oDM,"Will show all feats the current target has, targeted via tell or by the currently selected target");
		return;
	}
	*/
	
	/*
	if ( sClass == "" )
	{
		SCCacheStats( oTarget );
		iClass = GetLocalInt(oTarget, "SC_iBestCasterClass" );
		sClass = CSLGetClassesDataName( iClass );
	}
	else if ( sClass == "wizard" ) { iClass = CLASS_TYPE_WIZARD; }
	else if ( sClass == "sorcerer" ) { iClass = CLASS_TYPE_SORCERER; }
	else if ( sClass == "sorceror" ) { iClass = CLASS_TYPE_SORCERER; }
	else if ( sClass == "cleric" ) { iClass = CLASS_TYPE_CLERIC; }
	else if ( sClass == "favoredsoul" ) { iClass = CLASS_TYPE_FAVORED_SOUL; }
	else if ( sClass == "druid" ) { iClass = CLASS_TYPE_DRUID; }
	else if ( sClass == "spiritshaman" ) { iClass = CLASS_TYPE_SPIRIT_SHAMAN; }
	else if ( sClass == "paladin" ) { iClass = CLASS_TYPE_PALADIN; }
	else if ( sClass == "ranger" ) { iClass = CLASS_TYPE_RANGER; }
	else if ( sClass == "warlock" ) { iClass = CLASS_TYPE_WARLOCK; }
	*/
	
	CSLGetFeatDataObject( );
	
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		SendMessageToPC( oDM, "The feats dataobject is not installed" );
		return;
	}
	
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		SendMessageToPC( oDM, "The feats dataobject is not installed" );
		return;
	}
	
	if ( !GetLocalInt(oFeatTable, "DATATABLE_FULLYSORTED" ) )
	{
		SendMessageToPC( oDM, "The feats dataobject is not fully loaded, please wait while it loads and sorts" );
		return;
	}
	
	if ( !GetIsObjectValid(oTarget) )
	{
		SendMessageToPC( oDM, "Please select a valid target ( hint click on them or right click on their portrait )" );
		return;
	}
	
	
	SendMessageToPC( oDM, "<b>Feats for "+GetName(oTarget)+"</b>");
	//SendMessageToPC( oDM, "iStartingLevel="+IntToString( iStartingLevel )+" iEndingLevel="+IntToString( iEndingLevel )+" iStartRow="+IntToString( iStartRow )+" iEndRow="+IntToString( iEndRow ) );
	DelayCommand( 0.1f, CSLListFeatsOnTarget( oDM, oTarget ) );
}