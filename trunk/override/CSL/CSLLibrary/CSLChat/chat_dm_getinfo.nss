//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
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
	
	
	

	
	
	CSLInfoBox( oDM, "Info", GetName(oTarget)+" Information", CSLGetObjectInfo(oTarget, sItemType ) );

}