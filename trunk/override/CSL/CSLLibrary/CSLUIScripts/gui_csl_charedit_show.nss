////////////////////////////////////////////////////////////////////////////////
// Wand System  gui_dminventory_showpvm.nss
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_CharEdit"

void main(int iTarget )
{
	object oDM = OBJECT_SELF;
	object oTarget = IntToObject(iTarget);
	
	//SendMessageToPC( GetFirstPC(), "Opening "+WAND_GUI_PC_INVENTORY );
	
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oDM, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	
	SCCharEdit_Display( oTarget, oDM );
	//SCCharEdit_SetPimTarget(oPC, oTarget);
	//DisplayGuiScreen(oPC, SCREEN_CHARACTEREDIT, FALSE, XML_CHARACTEREDIT);
	//SCCharEdit_DisplayInventory (oPC, oTarget);
}