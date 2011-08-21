////////////////////////////////////////////////////////////////////////////////
// Wand System  gui_dminventory_showpvm.nss
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMInven"

void main (int iTarget, float fX, float fY, float fZ)
{
	object oPC = OBJECT_SELF;
	vector vPosition;
	float fFacing;
	object oArea;
	object oTarget = IntToObject(iTarget);
	
	if (GetIsObjectValid(oTarget))
	{
		vPosition = GetPosition(oTarget);
		oArea = GetArea(oTarget);
		fFacing = GetFacing(oTarget);
	}
	else
	{
		vPosition = Vector(fX, fY, fZ);
		oArea = GetArea(oPC);
		fFacing = 0.0;
	}
	
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, CSLDMVariable_GetAreaShortDesc(oArea));
	SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 106, IntToString(ObjectToInt(oArea)));
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_X", -1, CSLFormatFloat(vPosition.x));
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Y", -1, CSLFormatFloat(vPosition.y));
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Z", -1, CSLFormatFloat(vPosition.z));
	SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "AREA_LIST", "Area_" + IntToString(ObjectToInt(oArea)));
	SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_ORIENT", -1, CSLFormatFloat(fFacing));
	
}