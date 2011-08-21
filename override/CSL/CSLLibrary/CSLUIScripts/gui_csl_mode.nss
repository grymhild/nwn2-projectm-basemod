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
#include "_SCInclude_Mode"

//#include "_SCInclude_DMFI"
//#include "_SCInclude_DMFIComm"




// * sInput is the relevant command or button hit
// * sCommand is the stored variable               sCommand
void main(string sInput, string sPlayerID = "", string sCommand = "", string sParameter= "" )
{
	
	if ( !CSLCheckPermissions( OBJECT_SELF, CSL_PERM_DMONLY ) )
	{
		CloseGUIScreen(OBJECT_SELF, SCREEN_DM_CSLTABLELIST);
		return;
	}
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	//SendMessageToPC(oPC,"dmappear sInput="+sInput+" sPlayerID="+sPlayerID+" sCommand="+sCommand+" sParameter="+sParameter );
	
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
	

	//string sNum, sPage, sValue, sTest, sScreen;
	//int nPage, nCurrent, n;
	
	//string sCategory = GetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY" );

	//SendMessageToPC(oPC,"dmappear"+sPageTitle);
	
	if ( sInput=="XXX")
	{
		//SetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY", sCommand );
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
	}
	else if (sInput=="XXX")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_NEXT, sCommand, sPageTitle );
		//return;
	}	
	else if (sInput=="XXXX")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_PREVIOUS, sCommand, sPageTitle );
		//return;
	}
	else if (sInput=="XXXXX")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_LAST, sCommand, sPageTitle );
		//return;
	}
	else if (sInput=="XXXXX")
	{
		//CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
		//return;
	}

}				