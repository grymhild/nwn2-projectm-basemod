/** @file
* @brief Include file for DM Appearance and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




#include "_CSLCore_Strings"
#include "_CSLCore_Math"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_UI"
#include "_CSLCore_Appearance"
#include "_CSLCore_Position"




// ANIMATIONMODES_LIST



void CSLDMAppear_AnimationModes( object oTarget, object oPC = OBJECT_SELF, string sScreenName = SCREEN_DMAPPEAR )
{
	ClearListBox(oPC,sScreenName,"ANIMATIONMODES_LIST");
	string sRow, sRowName,sFields,sTextures,sVariables,sHide;
	int iAnimationOverride = CSLGetAnimateOverride( oTarget );
	// do the default resetting row now
	sRow = "-1";
	sRowName = "None";
	sHide = "";
	if ( iAnimationOverride == -1 )
	{
		sTextures = "ANIMATIONMODE_SET=b_minus_normal.tga";
	}
	else
	{
		sTextures = "ANIMATIONMODE_SET=b_plus_normal.tga";
	}
	sFields = "EFFECTLISTBOX_TEXT="+sRowName;
	sVariables = "5=None;6="+sRow;
	AddListBoxRow(oPC,sScreenName,"ANIMATIONMODES_LIST",sRowName,sFields, sTextures,sVariables,sHide);
	
	object oTable = CSLDataObjectGet( "anim_modes" );
	if ( !GetIsObjectValid( oTable )  )
	{
		return; // SendMessageToPC( oPC, "Table is invalid");
	}
	
	
	
	int nCurrent = 0;
	int iTotalItems = CSLDataTableCount( oTable );
	int iRow;
	
	while (nCurrent<iTotalItems)
	{
		iRow = CSLDataTableGetRowByIndex( oTable, nCurrent );
		
		sRow = IntToString(iRow);
		sRowName = CSLDataTableGetStringFromNameColumn( oTable, iRow );
		sHide = "";
		if ( iAnimationOverride == iRow )
		{
			sTextures = "ANIMATIONMODE_SET=b_minus_normal.tga";
		}
		else
		{
			sTextures = "ANIMATIONMODE_SET=b_plus_normal.tga";
		}
		
		sFields = "EFFECTLISTBOX_TEXT="+sRowName;
		sVariables = "5="+sRowName+";6="+sRow;
		AddListBoxRow(oPC,sScreenName,"ANIMATIONMODES_LIST",sRowName,sFields, sTextures,sVariables,sHide);
			
		nCurrent++;
	}
		
}

// adapted from DMFI_ShowDMListUI
// object oPC, int iPageNumber = CSL_PAGE_FIRST, string sSubCategory = "", string sTableName = "", string sPageTitle = "", string sScreen=SCREEN_DM_CSLTABLELIST
void CSLDMAppear_Build(object oPC, object oTarget = OBJECT_INVALID, int iPageNumber = CSL_PAGE_FIRST, string sCategory = "", string sPageTitle = "", string sScreen=SCREEN_DMAPPEAR)
{
	//Purpose: Shows the DM list - builds the 30 entries and handles page updates.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/27/6
	// Refactored completely by Pain, 12/26/09
	
	//SendMessageToPC( oPC, "CSLDMAppear_Build");
	
	int n, nCurrent, nModal;
	
	string sTableName = "Appearance";
	
		
	object oTable = CSLDataObjectGet( sTableName );
	if ( !GetIsObjectValid( oTable )  )
	{
		return; // SendMessageToPC( oPC, "Table is invalid");
	}
	
	int iItemsPerPage = 30;
	
	
	SetLocalGUIVariable(oPC, sScreen, 900, sCategory);
		
	
	sCategory = GetStringUpperCase( sCategory );
	int iStartRow = -1;
	int iTotalItems = -1;
	int iTotalPages = 0;
	
	if ( sCategory == "" || sCategory == "*"  || sCategory == "#" )
	{
		iStartRow = 0;
		iTotalItems = CSLDataTableCount( oTable );
	}
	else
	{
		iStartRow = GetLocalInt(oTable, "DATATABLE_SORTSTART_"+sCategory );
		iTotalItems = GetLocalInt(oTable, "DATATABLE_SORTQUANTITY_"+sCategory );
	}
	
	iTotalPages = (iTotalItems/iItemsPerPage)-CSLGetIsDivisible(iTotalItems, iItemsPerPage);
	
	//SendMessageToPC(oPC, "CSLDMAppear_Build "+sCategory+"  iTotalPages="+IntToString(iTotalPages) );
	
	if ( iPageNumber < 0 ) // need to use a variable page number
	{
		if ( iPageNumber == CSL_PAGE_CURRENT )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER");
		}
		else if ( iPageNumber == CSL_PAGE_FIRST )
		{
			iPageNumber = 0;
		}
		else if ( iPageNumber == CSL_PAGE_PREVIOUS )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER")-1;
		}
		else if ( iPageNumber == CSL_PAGE_NEXT )
		{
			iPageNumber = GetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER")+1;
		}
		else if ( iPageNumber == CSL_PAGE_LAST )
		{
			iPageNumber = iTotalPages;
		}
		
		SetLocalInt(oPC, "CSL_CSLTABLE_PAGENUMBER", iPageNumber);
	}
	// @todo this logic is not correct in how it figures total pages
	string sPageLocation;
	if ( iTotalItems > 0 )
	{
		sPageLocation = " - Page "+IntToString(iPageNumber+1)+" of "+IntToString(iTotalPages+1)+" pages";
	}
	else
	{
		sPageLocation = " Nothing Found";
	}
	//if (sScreen==SCREEN_DMFI_CHOOSE)
	//{
	//	nModal=TRUE;
	//}
	//else
	//{
	nModal=FALSE;
	//}
			    
	DisplayGuiScreen(oPC, SCREEN_DMAPPEAR, FALSE, XML_DMAPPEAR);
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sPageTitle+sPageLocation);
	
	if ( GetLocalInt(oTable, "DATATABLE_FULLYSORTED" ) )
	{
		SetGUIObjectHidden( oPC, sScreen, "FILTER_PANE", FALSE ); // true hides, false shows
		//SendMessageToPC( GetFirstPC(), "hiding");
	}
	else
	{
		SetGUIObjectHidden( oPC, sScreen, "FILTER_PANE", TRUE ); // true hides, false shows
		//SendMessageToPC( GetFirstPC(), "showing");
	}
	
	int iRealCurrent;
	string sString;
	int iRow; // this is the 2da row id, which starts a 0 but often skips sets of rows
	n = 0; // this is the physical row number
	while (n<31)
	{
		nCurrent = (iPageNumber*30) + iStartRow + n;
		iRealCurrent = (iPageNumber*30) + n;
		if ( iRealCurrent < iTotalItems )
		{
			iRow = CSLDataTableGetRowByIndex( oTable, nCurrent );
			sString = CSLDataTableGetStringFromNameColumn( oTable, iRow );
			
		}
		else
		{
			nCurrent = -1;
			sString = "";
			iRow = -1;
		}
		//sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		
		//CSLDataTableGetStringByRow( oTable, sField, iRow );
		
		// SendMessageToPC( oPC, "Page Number= "+IntToString( iPageNumber )+" n = "+IntToString(n)+"Item "+IntToString( nCurrent )+" is on 2da row "+IntToString(iRow)+" and string is "+sString );
		if ( sString != "" )
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, sString);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
			SetLocalGUIVariable(oPC, sScreen, n+1+100, sTableName+"_"+IntToString( iRow ) ); // will store the actual row number as it goes
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
			SetLocalGUIVariable(oPC, sScreen, n+1+100, "" );
		}	
		n++;
	}

	// show the last, prev, next and first buttons as appropriate
	if (( iTotalPages <= iPageNumber )	) // || (sScreen!=SCREEN_DMFI_DMLIST)
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
		SetGUIObjectHidden(oPC, sScreen, "btn-last", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);
		SetGUIObjectHidden(oPC, sScreen, "btn-last", FALSE);	
	}
			
	if ((iPageNumber==0) ) // || (sScreen!=SCREEN_DMFI_DMLIST)
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
		SetGUIObjectHidden(oPC, sScreen, "btn-first", TRUE);
	}
	else
	{
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);
		SetGUIObjectHidden(oPC, sScreen, "btn-first", FALSE);
	}
	
	CSLDMAppear_AnimationModes( oTarget, oPC, sScreen);
}


//SetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY", "" );
//CSLTableShowListUI(oPC, CSL_PAGE_FIRST, "", "Appearance", "Change Appearance" );


void CSLDMAppear_Display( object oPC = OBJECT_SELF, object oTargetToDisplay = OBJECT_INVALID )
{
	//if ( !GetIsObjectValid( oTargetToDisplay) )
	//{
	//	CloseGUIScreen( oPC,sScreenName );
	//	return;
	//}
	
	//SendMessageToPC( oPC, "CSLDMAppear_Display "+GetName(oTargetToDisplay) );
	
	DisplayGuiScreen(oPC, SCREEN_DMAPPEAR, FALSE, XML_DMAPPEAR);
	
	if ( oTargetToDisplay == OBJECT_INVALID )
	{
		SetLocalGUIVariable(oPC,SCREEN_DMAPPEAR,999,"targeted");
		//SendMessageToPC( oPC, "Target");
	}
	else
	{
		SetLocalGUIVariable(oPC,SCREEN_DMAPPEAR,999,IntToString(ObjectToInt(oTargetToDisplay)));
		//SendMessageToPC( oPC, "Not Targeting "+GetName(oTargetToDisplay) );
	}
	
	
	DelayCommand( 0.25f, CSLDMAppear_Build( oPC, oTargetToDisplay ) );
}