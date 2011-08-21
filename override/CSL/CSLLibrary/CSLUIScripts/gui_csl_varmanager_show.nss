////////////////////////////////////////////////////////////////////////////////
// Wand System  gui_dminventory_showpvm.nss
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMInven"

void main(int iTarget)
{
	object oPC = OBJECT_SELF;
	object oTarget = IntToObject(iTarget);
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	
	CSLDMVariable_Display( oTarget, oPC );
	
	/*
	CSLDMVariable_SetLvmTarget(oPC, oTarget);
	DisplayGuiScreen(oPC, WAND_GUI_LV_MANAGER, FALSE, WAND_GUI_LV_MANAGER);
	CSLDMVariable_InitTargetVarRepository (oPC, oTarget);
	*/
}