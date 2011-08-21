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
	
	int iClass = 255 ;
	string sClass = GetStringLowerCase(CSLNth_GetNthElement( sParameters, 1, " "));
	string sLevel = CSLNth_GetNthElement( sParameters, 2, " ");
	
	if ( sClass == "help" )
	{
		
		SendMessageToPC( oDM,"Usage: listspell [class] [levels]");
		SendMessageToPC( oDM,"Example: listspell wizard 3-6");
		SendMessageToPC( oDM,"     shows wizard spells from levels 3 to 6");
		SendMessageToPC( oDM,"Example: listspell bard 5");
		SendMessageToPC( oDM,"     shows bard spells at level 5");
		SendMessageToPC( oDM,"levels can be 1 to 10");
		SendMessageToPC( oDM,"classes: wizard, sorcerer, cleric, favoredsoul, druid, spiritshaman, paladin, ranger, warlock");
		SendMessageToPC( oDM,"No parameters will show all spells the current target can use out of their first class that can cast spells spell book");
		return;
	}
	
	
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
	
	object oCurrentSpellBook = CSLGetSpellBookByClass( iClass );
	
	if ( !GetIsObjectValid( oCurrentSpellBook ) )
	{
		SendMessageToPC( oDM, "No Valid Spell Book Available" );
		return;
	}
	
	int iStartRow = 0;
	int iEndRow = CSLDataTableCount( oCurrentSpellBook )-2;
	int iStartingLevel = 0;
	int iEndingLevel = 10;
	if ( GetLocalInt(oCurrentSpellBook, "DATATABLE_FULLYSORTED" ) )
	{
		if ( sLevel == "" && GetIsObjectValid(oTarget) )
		{
			iStartingLevel = 0;
			
			SCCacheStats( oTarget );
			int iMaxLevel = GetLocalInt(oTarget, "SC_iBestCasterMaxSpellLevel" );
			if ( iMaxLevel > 0 )
			{
				iEndingLevel = iMaxLevel;
			}
			
		}
		else if ( sLevel == "" )
		{
			iStartingLevel = 0;
			iEndingLevel = 10;
		}
		else if ( FindSubString( sLevel, "-" ) > -1 )
		{
			string sStartLevel = CSLNth_GetNthElement( sLevel, 1, "-");
			string sEndLevel = CSLNth_GetNthElement( sLevel, 1, "-");
			
			if ( sStartLevel != "" && sEndLevel != "" )
			{
				iStartingLevel = StringToInt(sStartLevel);
				iEndingLevel = StringToInt(sEndLevel);
			}
			else if ( sStartLevel != "" )
			{
				iStartingLevel = StringToInt(sStartLevel);
				iEndingLevel = StringToInt(sStartLevel);
			}
			else if ( sEndLevel != "" )
			{
				iStartingLevel = StringToInt(sEndLevel);
				iEndingLevel = StringToInt(sEndLevel);
			}
			
		}
		else if ( CSLGetIsNumber(sLevel) )
		{
			iStartingLevel = StringToInt(sLevel);
			iEndingLevel = StringToInt(sLevel);
		}
		
		if ( iStartingLevel < 0 )
		{
			iStartingLevel = 0;
		}
		
		if ( iEndingLevel > 10 ) // 10 is epic
		{
			iEndingLevel = 10;
		}
		
		
		if ( iEndingLevel < iStartingLevel )
		{
			iEndingLevel = iStartingLevel;
		}
		
		if ( iStartingLevel != 0 && iEndingLevel != 10 )
		{
			// We only need to get the range to use IF they are not using the entire range, the variables are initialized with the entire spell list from 0 to the count in the table.
			
			// this logic assumes that a random spell level will have no spells in it, like for epic spells,warlock only go up to level 4, and some classes don't have level 0 spells like warlock again
			// so what i am doing is if it comes back with -1
			
			// go up first till you find a level with actual spells
			int iTempStartRow = GetLocalInt(oCurrentSpellBook, "DATATABLE_SORTSTART_"+IntToString(iStartingLevel) );
			while ( iTempStartRow == -1 && iStartingLevel < iEndingLevel && iStartingLevel < 10 ) // note i have this set to 9 and not 10 because i know it's going to ++ it again and put it at 10 when it's 9
			{
				iStartingLevel++;
				iTempStartRow = GetLocalInt(oCurrentSpellBook, "DATATABLE_SORTSTART_"+IntToString(iStartingLevel) );
			}
			
			// now descend until you find a level with working spells
			int iTempEndRow = GetLocalInt(oCurrentSpellBook, "DATATABLE_SORTSTART_"+IntToString(iEndingLevel) );
			while ( iTempEndRow == -1 && iEndingLevel > iStartingLevel && iEndingLevel > 0 ) // note i have this set to be 1 and not zero since i know that it's going to -- it again to put it at zero when it's 1
			{
				iEndingLevel--;
				iTempEndRow = GetLocalInt(oCurrentSpellBook, "DATATABLE_SORTSTART_"+IntToString(iEndingLevel) );
			}
			
			if ( iTempStartRow != -1 && iTempEndRow != -1 )
			{
				iTempEndRow += GetLocalInt(oCurrentSpellBook, "DATATABLE_SORTQUANTITY_"+IntToString(iEndingLevel) )-1;
				
				iStartRow = iTempStartRow;
				iEndRow = iTempEndRow;
			}
		}
	}
	
	
	SendMessageToPC( oDM, "<b>"+CSLStringToProper(sClass)+" Spellbook</b>");
	//SendMessageToPC( oDM, "iStartingLevel="+IntToString( iStartingLevel )+" iEndingLevel="+IntToString( iEndingLevel )+" iStartRow="+IntToString( iStartRow )+" iEndRow="+IntToString( iEndRow ) );
	DelayCommand( 0.1f, CSLListClassSpellBook( oCurrentSpellBook, oDM, oTarget, iStartRow, iEndRow ) );
}