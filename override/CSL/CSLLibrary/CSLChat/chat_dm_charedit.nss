//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_CharEdit"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oDM, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	SCCharEdit_Display( oTarget, oDM );
	
	return;	
	/*
	//int iShowLocation = TRUE;
	string sItemType = "";
	
	// Use alternative targets
	if ( GetStringLowerCase(sParameters) == "area")
	{
		if ( GetIsObjectValid(oTarget) )
		{
			oTarget = GetArea( oTarget);
		}
		else
		{
			oTarget = GetArea( oDM );
		}
		int iShowLocation = FALSE;
		sItemType = "Area";
	
	}
	else if ( GetStringLowerCase(sParameters) == "module")
	{
		oTarget = GetModule();
		int iShowLocation = FALSE;
		sItemType = "Module";
	}
	else if ( GetStringLowerCase(sParameters) == "help")
	{
		SendMessageToPC(oDM, "Use DM_GetInfo with a selected target, or you can use the parameters: area, module, tag, or help.\nTag should be followed by the objects tag, and a second parameter for the index ( DM_GetInfo tag yourtaghere 2 will get 3rd object with tag of yourtaghere )" );
	}
	else if ( GetStringLowerCase(GetStringLeft(sParameters, 3)) == "tag")
	{
		sParameters = CSLNth_Shift(sParameters, " ");
		///string sVar = CSLNth_GetLast();  this would just get tag so ignore it
		sParameters = CSLNth_Shift(sParameters, " ");
		string sTag = CSLNth_GetLast();
		sParameters = CSLNth_Shift(sParameters, " ");
		int iIndex = StringToInt( CSLNth_GetLast() );
		
		oTarget = GetObjectByTag(sParameters, iIndex );
	}
	*/
	
	
	//SetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY", "" );
	//CSLTableShowListUI(oPC, CSL_PAGE_FIRST, "", "Appearance", "Change Appearance" );


	
	//CSLInfoBox( oDM, "Info", GetName(oTarget)+" Information", CSLGetObjectInfo(oTarget, sItemType ) );

}