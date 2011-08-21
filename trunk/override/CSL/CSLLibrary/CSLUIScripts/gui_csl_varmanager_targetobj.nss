////////////////////////////////////////////////////////////////////////////////
// Wand System  gui_dminventory_showpvm.nss
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMInven"

void main (int iTarget)
{
	object oPC = OBJECT_SELF;
	if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	object oTarget = IntToObject(iTarget);
	
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_INPUT", -1, IntToString(iTarget));
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, GetName(oTarget));
}