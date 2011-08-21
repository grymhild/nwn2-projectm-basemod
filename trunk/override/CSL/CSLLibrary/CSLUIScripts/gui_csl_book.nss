////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmlist - DM Friendly Initiative - GUI script for the DM 30 Entry List
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// NOTE: Two UIs actually run through this script.
// One is the 30 DM LIST UI and the second is the PLAYER CHOOSE LANGUAGE UI.
// Saves us one script in the package.
#include "_SCInclude_Language"
#include "_CSLCore_Player"

//#include "_SCInclude_DMFIComm"

// XML_BOOK
// SCREEN_BOOK



// * sInput is the relevant command or button hit
// * sCommand is the stored variable               sCommand
void main(string sInput, string sPlayerID = "", string sBookID = "", string sCommand = "", string sParameter= "" )
{
	
	//if ( !CSLCheckPermissions( OBJECT_SELF, CSL_PERM_DMONLY ) )
	//{
	//	CloseGUIScreen(OBJECT_SELF, SCREEN_BOOK );
	//	return;
	//}
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	//SendMessageToPC(oPC,"gui_csl_book sInput="+sInput+" sPlayerID="+sPlayerID+" sCommand="+sCommand+" sParameter="+sParameter );
	
	sInput = GetStringLowerCase( sInput );
	string sPageTitle;
	object oTarget;
	if ( sPlayerID == "targeted" )
	{
		oTarget = GetPlayerCurrentTarget( OBJECT_SELF );
		//if ( !GetIsObjectValid( oTarget )  )
		//{		
		//	oTarget == OBJECT_SELF;
		//}
		
		sPageTitle = "Current Target";
	}
	else
	{
		oTarget = IntToObject(StringToInt(sPlayerID));
		sPageTitle = "Target: "+GetName(oTarget);
	}
	
	object oBook = IntToObject(StringToInt(sBookID));
	

	//string sNum, sPage, sValue, sTest, sScreen;
	//int nPage, nCurrent, n;
	
	//string sCategory = GetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY" );

	//SendMessageToPC(oPC,"dmappear"+sPageTitle);
	
	if ( sInput=="fontsinstalled")
	{
		SetLocalInt( oPC, "CSL_LANGUAGEFONTS_INSTALLED", TRUE );
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
	}
	else if (sInput=="next")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_NEXT, sCommand, sPageTitle );
		//return;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" )+1;
		int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS");
		if ( iSpreadNumber >= iTotalSpreads )
		{
			iSpreadNumber = iTotalSpreads-1;
		}
		SCBook_DisplaySpread( iSpreadNumber, oBook, oTarget );
	}	
	else if (sInput=="previous")
	{
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" )-1;
		if ( iSpreadNumber < 0 )
		{
			iSpreadNumber = 0;
		}
		SCBook_DisplaySpread( iSpreadNumber, oBook, oTarget );
	}
	else if (sInput=="last")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_LAST, sCommand, sPageTitle );
		//return;
		int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS")-1;
		SCBook_DisplaySpread( iTotalSpreads, oBook, oTarget );
	}
	else if (sInput=="first")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
		//return;
		SCBook_DisplaySpread( 0, oBook, oTarget );
	}
	else if (sInput=="remove")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_LAST, sCommand, sPageTitle );
		//return;
		//int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS")-1;
		//SCBook_DisplaySpread( iTotalSpreads, oBook, oTarget );
		// activate any on removal scripts here
		DeleteLocalObject(oTarget, "CSLBOOK_VIEWING");
		CSLPlayCustomAnimation_Void(oTarget, "%", FALSE); // clears the current animation
	}
	else if (sInput=="update")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_LAST, sCommand, sPageTitle );
		//return;
		//int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS")-1;
		//SCBook_DisplaySpread( iTotalSpreads, oBook, oTarget );
		// activate any on removal scripts here
		//DeleteLocalObject(oTarget, "CSLBOOK_VIEWING");
		//CSLNWN2Emote(oPC, "read");
		
		CSLPlayCustomAnimation_Void(oTarget, "read", TRUE); // makes them look like they are reading
	}
	else if (sInput=="spellleft")
	{
		string sSpell;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		int iPageType = CSLBOOK_PAGETYPE_LEFT;
		sSpell = GetLocalString(oBook, "LEFTPAGE_SPELL" );
		if ( sSpell != "" )
		{
			int iSpell = StringToInt(sSpell);
			AssignCommand(oTarget, ActionCastSpellAtObject(iSpell, GetPlayerCurrentTarget( oTarget ), METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE ) );
			
			CSLBookTearPage( oBook, iSpreadNumber, iPageType, TRUE ); // casting spells will tear a page, making it no longer usable
		}
	}
	else if (sInput=="spellright")
	{
		string sSpell;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		int iPageType = CSLBOOK_PAGETYPE_RIGHT;
		sSpell = GetLocalString(oBook, "RIGHTPAGE_SPELL" );
		if ( sSpell != "" )
		{
			int iSpell = StringToInt(sSpell);
			AssignCommand(oTarget, ActionCastSpellAtObject(iSpell, GetPlayerCurrentTarget( oTarget ), METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE ) );
			
			CSLBookTearPage( oBook, iSpreadNumber, iPageType, TRUE ); // casting spells will tear a page, making it no longer usable
		}
		
	}
	else if (sInput=="secretleft")
	{
		SCBook_DisplaySpread( GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" ), oBook, oTarget );
	}
	else if (sInput=="secretright")
	{
		SCBook_DisplaySpread( GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" ), oBook, oTarget );
	}
	else if (sInput=="pictureleft")
	{
		int iPageType = CSLBOOK_PAGETYPE_LEFT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		SCBook_DisplayPicture( iSpreadNumber, iPageType, oBook, oTarget );
	}
	else if (sInput=="pictureright")
	{
		int iPageType = CSLBOOK_PAGETYPE_RIGHT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		SCBook_DisplayPicture( iSpreadNumber, iPageType, oBook, oTarget );
	}
	else if (sInput=="editleft")
	{
		int iPageType = CSLBOOK_PAGETYPE_LEFT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		SCBook_DisplayEditor( iSpreadNumber, iPageType, oBook, oTarget );

	}
	else if (sInput=="editright")
	{
		int iPageType = CSLBOOK_PAGETYPE_RIGHT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		SCBook_DisplayEditor( iSpreadNumber, iPageType, oBook, oTarget );
	}
	else if (sInput=="tearleft")
	{
		int iPageType = CSLBOOK_PAGETYPE_LEFT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		CSLBookTearPage( oBook, iSpreadNumber,  iPageType, TRUE );
	}
	else if (sInput=="tearright")
	{
		int iPageType = CSLBOOK_PAGETYPE_RIGHT;
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" );
		CSLBookTearPage( oBook, iSpreadNumber,  iPageType, TRUE );
	}
}				