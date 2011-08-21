////////////////////////////////////////////////////////////////////////////////
// Wand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMInven"

void main( string sCommand = "", string sParam1 = "", string sParam2 = "", string sParam3 = "", string sParam4 = "", string sParam5 = "", string sParam6 = "", string sParam7 = "")
{
	object oPC = OBJECT_SELF;
	
	sCommand = GetStringLowerCase( sCommand );

	//SendMessageToPC( oPC, "Running gui_dm_varmanager "+sCommand+", "+sParam1+", "+sParam2+", "+sParam3+", "+sParam4+", "+sParam5+", "+sParam6+", "+sParam7 );
	
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
		//SendMessageToPC( oPC, "gui_dm_varmanager not a dm");
		return;
	}
	
	
	
	if ( sCommand == "init" )
	{			
		//SendMessageToPC( oPC, "Running gui_dm_varmanager init lvm ");
		///***********************************///
		//gui_wand_lvm_init.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,init)
		//void main ()
		CSLDMVariable_InitAreaList(oPC);
		
		//Misc
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "TITLE_TEXT", -1, WAND_UI_LV_TITLE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "LOC_X", -1, WAND_UI_LV_X);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "LOC_Y", -1, WAND_UI_LV_Y);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "LOC_Z", -1, WAND_UI_LV_Z);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "LOC_AREA", -1, WAND_UI_LV_AREA);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "LOC_ORIENT", -1, WAND_UI_LV_ORIENT);
		
		// Buttons
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "NEW_INT_BUTTON", -1, WAND_UI_LV_NEW);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "NEW_FLOAT_BUTTON", -1, WAND_UI_LV_NEW);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "NEW_STR_BUTTON", -1, WAND_UI_LV_NEW);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "NEW_LOC_BUTTON", -1, WAND_UI_LV_NEW);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "NEW_OBJ_BUTTON", -1, WAND_UI_LV_NEW);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "ACCEPT_INT", -1, WAND_UI_LV_ACCEPT);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "DELETE_INT", -1, WAND_UI_LV_DELETE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "CANCEL_INT", -1, WAND_UI_LV_CANCEL);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "ACCEPT_FLOAT", -1, WAND_UI_LV_ACCEPT);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", -1, WAND_UI_LV_DELETE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "CANCEL_FLOAT", -1, WAND_UI_LV_CANCEL);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "ACCEPT_STR", -1, WAND_UI_LV_ACCEPT);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "DELETE_STR", -1, WAND_UI_LV_DELETE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "CANCEL_STR", -1, WAND_UI_LV_CANCEL);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "ACCEPT_LOC", -1, WAND_UI_LV_ACCEPT);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "DELETE_LOC", -1, WAND_UI_LV_DELETE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "CANCEL_LOC", -1, WAND_UI_LV_CANCEL);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "ACCEPT_OBJ", -1, WAND_UI_LV_ACCEPT);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "DELETE_OBJ", -1, WAND_UI_LV_DELETE);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "CANCEL_OBJ", -1, WAND_UI_LV_CANCEL);
		
		// Tooltips
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1000, WAND_UI_LV_TT_OBJ_ID);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1001, WAND_UI_LV_TT_NEW_VAR);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1002, WAND_UI_LV_TT_SAVE);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1003, WAND_UI_LV_TT_DELETE);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1004, WAND_UI_LV_TT_CANCEL);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1005, WAND_UI_LV_TT_INTEGER);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1006, WAND_UI_LV_TT_FLOAT);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1007, WAND_UI_LV_TT_STRING);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1008, WAND_UI_LV_TT_LOCATION);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1009, WAND_UI_LV_TT_OBJECT);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1010, WAND_UI_LV_TT_CLICK);
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1011, WAND_UI_LV_TT_OBJ_NAME);
		return;
	}
	else if ( sCommand == "close" )
	{
		//gui_wand_lvm_close.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,close)
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}

		CSLDMVariable_SetLvmTarget(oPC, OBJECT_INVALID);
	}
	else if ( sCommand == "deletefloat" )
	{
		//gui_wand_lvm_del_float.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,deletefloat)
		//void main(int iVarIndex)
		int iVarIndex = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}

		object oTarget = CSLDMVariable_GetLvmTarget(oPC);

		// Consistency check
		if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}

		string sVarName = GetVariableName(oTarget, iVarIndex);

		DeleteLocalFloat(oTarget, sVarName);

		CSLDMVariable_ResetTargetVarRepository (oPC);
		CSLDMVariable_InitTargetVarRepository(oPC, oTarget);
		return;
	}
	else if ( sCommand == "deleteinteger" )
	{
		//gui_wand_lvm_del_int.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,deleteinteger)
		//void main(int iVarIndex)
		int iVarIndex = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}

		object oTarget = CSLDMVariable_GetLvmTarget(oPC);

		// Consistency check
		if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}

		string sVarName = GetVariableName(oTarget, iVarIndex);

		DeleteLocalInt(oTarget, sVarName);

		CSLDMVariable_ResetTargetVarRepository (oPC);
		CSLDMVariable_InitTargetVarRepository(oPC, oTarget);
		return;
	}
	else if ( sCommand == "deletelocation" )
	{

		///***********************************///
		//gui_wand_lvm_del_loc.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,deletelocation)
		//void main(int iVarIndex)
		int iVarIndex = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// Consistency check
		if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		string sVarName = GetVariableName(oTarget, iVarIndex);
		
		DeleteLocalLocation(oTarget, sVarName);
		
		CSLDMVariable_ResetTargetVarRepository (oPC);
		CSLDMVariable_InitTargetVarRepository(oPC, oTarget);
		return;
		
	}
	else if ( sCommand == "deleteobject" )
	{			
		///***********************************///
		//gui_wand_lvm_del_obj.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,deleteobject)
		//void main(int iVarIndex)
		int iVarIndex = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// Consistency check
		if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		string sVarName = GetVariableName(oTarget, iVarIndex);
		
		DeleteLocalObject(oTarget, sVarName);
		
		CSLDMVariable_ResetTargetVarRepository (oPC);
		CSLDMVariable_InitTargetVarRepository(oPC, oTarget);
		return;
		
	}
	else if ( sCommand == "deletestring" )
	{			
		///***********************************///
		//gui_wand_lvm_del_str.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,deletestring)
		//void main(int iVarIndex)
		int iVarIndex = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// Consistency check
		if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		string sVarName = GetVariableName(oTarget, iVarIndex);
		
		DeleteLocalString(oTarget, sVarName);
		
		CSLDMVariable_ResetTargetVarRepository (oPC);
		CSLDMVariable_InitTargetVarRepository(oPC, oTarget);
		return;
	}
	else if ( sCommand == "dofloat" )
	{			
		///***********************************///
		//gui_wand_lvm_do_float.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,dofloat)
		//void main(int iVarIndex, string sVarName, float fVarValue)
		int iVarIndex = StringToInt( sParam1 );
		string sVarName = sParam2;
		float fVarValue = StringToFloat( sParam3 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// New var
		if (iVarIndex < 0)
		{
		
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_FLOAT);
		
			// Let's check if we already have a local var with the same name and type
			if (iVarIndex != VARIABLE_INVALID_INDEX)
			{
				DisplayMessageBox(oPC, -1, "The variable is already present!");
				return;
			}
		
			SetLocalFloat(oTarget, sVarName, fVarValue);
		
			// We retrieve the new var index
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_FLOAT);
		
			CSLDMVariable_AddVar(oPC, oTarget, iVarIndex);
		}
		else // Changed var
		{
			sVarName = GetVariableName(oTarget, iVarIndex);
		
			SetLocalFloat(oTarget, sVarName, fVarValue);
			CSLDMVariable_ModifyVar(oPC, oTarget, iVarIndex);
		}
		return;
	}
	else if ( sCommand == "dointeger" )
	{			
		///***********************************///
		//gui_wand_lvm_do_int.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,dointeger)
		//void main(int iVarIndex, string sVarName, int iVarValue)
		int iVarIndex = StringToInt( sParam1 );
		string sVarName = sParam2;
		int iVarValue = StringToInt( sParam3 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// New var
		if (iVarIndex < 0)
		{
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_INT);
		
			// Let's check if we already have a local var with the same name and type
			if (iVarIndex != VARIABLE_INVALID_INDEX)
			{
				DisplayMessageBox(oPC, -1, "The variable is already present!");
				return;
			}
		
			SetLocalInt(oTarget, sVarName, iVarValue);
		
			// We retrieve the new var index
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_INT);
		
			CSLDMVariable_AddVar(oPC, oTarget, iVarIndex);
		}
		else // Changed var
		{
			sVarName = GetVariableName(oTarget, iVarIndex);
		
			SetLocalInt(oTarget, sVarName, iVarValue);
			CSLDMVariable_ModifyVar(oPC, oTarget, iVarIndex);
		}
		return;
	}
	else if ( sCommand == "dolocation" )
	{			
		///***********************************///
		//gui_wand_lvm_do_loc.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,dolocation)
		//void main(int iVarIndex, string sVarName, float fVarValueX, float fVarValueY, float fVarValueZ, int iVarValueArea, float fVarValueOrientation)
		int iVarIndex = StringToInt( sParam1 );
		string sVarName = sParam2;
		float fVarValueX = StringToFloat( sParam3 );
		float fVarValueY = StringToFloat( sParam4 );
		float fVarValueZ = StringToFloat( sParam5 );
		int iVarValueArea = StringToInt( sParam6 );
		float fVarValueOrientation = StringToFloat( sParam7 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oArea = IntToObject(iVarValueArea);
		
		// Consistency check
		if (!GetIsObjectValid(oArea) && iVarValueArea >= 0)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		location lLocation = Location(oArea, Vector(fVarValueX, fVarValueY, fVarValueZ), fVarValueOrientation);
		
		// New var
		if (iVarIndex < 0)
		{
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_LOCATION);
		
			// Let's check if we already have a local var with the same name and type
			if (iVarIndex != VARIABLE_INVALID_INDEX)
			{
				DisplayMessageBox(oPC, -1, "The variable is already present!");
				return;
			}
		
			SetLocalLocation(oTarget, sVarName, lLocation);
		
			// We retrieve the new var index
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_LOCATION);
		
			CSLDMVariable_AddVar(oPC, oTarget, iVarIndex);
		}
		// Changed var
		else
		{
			sVarName = GetVariableName(oTarget, iVarIndex);
		
			SetLocalLocation(oTarget, sVarName, lLocation);
			CSLDMVariable_ModifyVar(oPC, oTarget, iVarIndex);
		}
		return;
		
	}
	else if ( sCommand == "doobject" )
	{			
		///***********************************///
		//gui_wand_lvm_do_obj.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,doobject)
		//void main(int iVarIndex, string sVarName, int iVarValue)
		int iVarIndex = StringToInt( sParam1 );
		string sVarName = sParam2;
		int iVarValue = StringToInt( sParam3 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oVarValue = IntToObject(iVarValue);
		
		// Consistency check
		if (!GetIsObjectValid(oVarValue) && iVarValue >= 0)
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// New var
		if (iVarIndex < 0)
		{
		
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_DWORD);
		
			// Let's check if we already have a local var with the same name and type
			if (iVarIndex != VARIABLE_INVALID_INDEX)
			{
				DisplayMessageBox(oPC, -1, "The variable is already present!");
				return;
			}
		
			SetLocalObject(oTarget, sVarName, oVarValue);
		
			// We retrieve the new var index
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_DWORD);
		
			CSLDMVariable_AddVar(oPC, oTarget, iVarIndex);
		}
		else // Changed var
		{
			sVarName = GetVariableName(oTarget, iVarIndex);
		
			SetLocalObject(oTarget, sVarName, oVarValue);
			CSLDMVariable_ModifyVar(oPC, oTarget, iVarIndex);
		}
		return;
	}
	else if ( sCommand == "dostring" )
	{
		///***********************************///
		//gui_wand_lvm_do_str.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,dostring)
		//void main(int iVarIndex, string sVarName, string sVarValue)
		int iVarIndex = StringToInt( sParam1 );
		string sVarName = sParam2;
		string sVarValue = sParam3;
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		// New var
		if (iVarIndex < 0)
		{
		
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_STRING);
		
			// Let's check if we already have a local var with the same name and type
			if (iVarIndex != VARIABLE_INVALID_INDEX)
			{
				DisplayMessageBox(oPC, -1, "The variable is already present!");
				return;
			}
		
			SetLocalString(oTarget, sVarName, sVarValue);
		
			// We retrieve the new var index
			iVarIndex = CSLGetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_STRING);
		
			CSLDMVariable_AddVar(oPC, oTarget, iVarIndex);
		}
		else // Changed var
		{
			sVarName = GetVariableName(oTarget, iVarIndex);
		
			SetLocalString(oTarget, sVarName, sVarValue);
			CSLDMVariable_ModifyVar(oPC, oTarget, iVarIndex);
		}
		return;
	}
	else if ( sCommand == "initarea" )
	{			
		///***********************************///
		//gui_wand_lvm_init_area.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initarea)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oArea = IntToObject(iVarId);
		string sVarValueName = (GetIsObjectValid(oArea)) ? CSLDMVariable_GetAreaShortDesc(oArea) : "OBJECT_INVALID";
		
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, sVarValueName);
	}
	else if ( sCommand == "initfloat" )
	{			
		///***********************************///
		//gui_wand_lvm_init_float.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initfloat)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		string sVarName = "";
		string sVarValue = "";
		if ( iVarId >= 0 )
		{
			sVarName = GetVariableName(oTarget, iVarId);
			sVarValue = FloatToString(GetVariableValueFloat(oTarget, iVarId) );
		}
		//string sVarName = GetVariableName(oTarget, iVarId);
		//string sVarValue = FloatToString(GetLocalFloat(oTarget, sVarName));
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_FLOAT_INPUT", -1, sVarValue);
		
		if (iVarId >= 0)
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", FALSE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", TRUE);
		}
		return;
	}
	else if ( sCommand == "initinteger" )
	{			
		///***********************************///
		//gui_wand_lvm_init_int.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initinteger)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		string sVarName = "";
		string sVarValue = "";
		if ( iVarId >= 0 )
		{
			sVarName = GetVariableName(oTarget, iVarId);
			sVarValue = IntToString(GetVariableValueInt(oTarget, iVarId) );
		}
		//string sVarName = GetVariableName(oTarget, iVarId);
		//string sVarValue = IntToString(GetLocalInt(oTarget, sVarName));
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_INT_INPUT", -1, sVarValue);
		
		if (iVarId >= 0)
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_INT", FALSE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_INT", TRUE);
		}
		return;
	}
	else if ( sCommand == "initlocation" )
	{			
		///***********************************///
		//gui_wand_lvm_init_loc.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initlocation)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		string sVarName = "";
		string sVarValueX = "0.0";
		string sVarValueY = "0.0";
		string sVarValueZ = "0.0";
		string sVarValueArea = "OBJECT_INVALID";
		string sVarValueOrientation = "0";
		string sAreaInt = "Area_Invalid";
		if ( iVarId >= 0 )
		{
			sVarName = GetVariableName(oTarget, iVarId);
			location lVarValue = GetVariableValueLocation(oTarget, iVarId);
			//string sVarName = GetVariableName(oTarget, iVarId);
			//location lVarValue = GetLocalLocation(oTarget, sVarName);
			vector vLocationVector = GetPositionFromLocation(lVarValue);
			sVarValueX = CSLFormatFloat(vLocationVector.x);
			sVarValueY = CSLFormatFloat(vLocationVector.y);
			sVarValueZ = CSLFormatFloat(vLocationVector.z);
			object oArea = GetAreaFromLocation(lVarValue);
			sAreaInt = "Area_"+IntToString(ObjectToInt(oArea));
			sVarValueArea = (GetIsObjectValid(oArea)) ? CSLDMVariable_GetAreaShortDesc(oArea) : "OBJECT_INVALID";
			sVarValueOrientation = (iVarId < 0) ? CSLFormatFloat(IntToFloat(0)) : CSLFormatFloat(GetFacingFromLocation(lVarValue));
		}
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
		
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_X", -1, sVarValueX);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Y", -1, sVarValueY);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Z", -1, sVarValueZ);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, sVarValueArea);
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "AREA_LIST", sAreaInt);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_ORIENT", -1, sVarValueOrientation);
		
		if (iVarId >= 0)
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", FALSE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", TRUE);
		}
		return;
	}
	else if ( sCommand == "initobject" )
	{			
		///***********************************///
		//gui_wand_lvm_init_obj.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initobject)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		string sVarName = "";
		object oVarValue = OBJECT_INVALID;
		if ( iVarId >= 0 )
		{
			sVarName = GetVariableName(oTarget, iVarId);
			oVarValue = GetVariableValueObject(oTarget, iVarId);
		}
		//string sVarName = GetVariableName(oTarget, iVarId);
		//object oVarValue = GetLocalObject(oTarget, sVarName);
		string sVarValue = (GetIsObjectValid(oVarValue)) ? IntToString(ObjectToInt(oVarValue)) : "-1";
		string sVarValueName = (GetIsObjectValid(oVarValue)) ? CSLDMVariable_GetObjectShortDesc(oVarValue) : "OBJECT_INVALID";
		
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_INPUT", -1, sVarValue);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, sVarValueName);
		
		
		if (iVarId >= 0)
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_OBJ", FALSE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_OBJ", TRUE);
		}
		return;
	}
	else if ( sCommand == "initstring" )
	{			
		///***********************************///
		//gui_wand_lvm_init_str.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,initstring)
		//void main(int iVarId)
		int iVarId = StringToInt( sParam1 );
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		//int GetVariableCount(object oObject);
		// int GetVariableType(object oTarget, int nPosition);
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		string sVarName = "";
		string sVarValue = "";
		if ( iVarId >= 0 )
		{
			sVarName = GetVariableName(oTarget, iVarId);
			sVarValue = GetVariableValueString(oTarget, iVarId);
		}
		
		//string sVarValue = GetLocalString(oTarget, sVarName);
		
		SetLocalGUIVariable(oPC, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_STR_INPUT", -1, sVarValue);
		
		if (iVarId >= 0)
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_STR", FALSE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, WAND_GUI_LV_MANAGER, "DELETE_STR", TRUE);
		}
		return;
	}
	else if ( sCommand == "newtab" )
	{			
		///***********************************///
		//gui_wand_lvm_new_tab.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,newtab)
		//void main()
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "VAR_INT_LIST", "HIDDEN_ROW");
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "VAR_FLOAT_LIST", "HIDDEN_ROW");
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "VAR_STR_LIST", "HIDDEN_ROW");
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "VAR_LOC_LIST", "HIDDEN_ROW");
		SetListBoxRowSelected(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_LIST", "HIDDEN_ROW");
		return;
	}
	else if ( sCommand == "objinputlostfocus" )
	{			
		///***********************************///
		//gui_wand_lvm_obj_input_lost_foc.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,objinputlostfocus)
		//void main(string sVarValue)
		string sVarValue = sParam1;
		
		object oVarValue = IntToObject(StringToInt(sVarValue));
		string sVarValueName;
		
		if (GetIsObjectValid(oVarValue))
		{
			sVarValueName = GetName(oVarValue);
		}
		else if (sVarValue == "-1")
		{
			sVarValueName =  WAND_LV_MANAGER_OBJ_INV_REF;
		}
		else
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, sVarValueName);
		return;
		
	}
	else if ( sCommand == "reload" )
	{			
		///***********************************///
		//gui_wand_lvm_reload.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,reload)
		//void main()
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		object oTarget = CSLDMVariable_GetLvmTarget(oPC);
		
		CSLDMVariable_ResetTargetVarRepository(oPC);
		CSLDMVariable_InitTargetVarRepository (oPC, oTarget);
		return;
		
	}
	else if ( sCommand == "show" )
	{			
		///***********************************///
		//gui_wand_lvm_show.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,show)
		//void main(int iTarget)
		int iTarget = StringToInt( sParam1 );
		
		object oTarget = IntToObject(iTarget);
		
		if ( !CSLCheckPermissions( oPC, CSL_PERM_DMONLY ) )
		{
			DisplayMessageBox(oPC, -1, "You don't have sufficient privileges to run this feature.");
			return;
		}
		
		CSLDMVariable_SetLvmTarget(oPC, oTarget);
		
		DisplayGuiScreen(oPC, WAND_GUI_LV_MANAGER, FALSE, WAND_GUI_LV_MANAGER);
		
		CSLDMVariable_InitTargetVarRepository (oPC, oTarget);
		return;
	}
	else if ( sCommand == "targetlocation" )
	{			
		///***********************************///
		//gui_wand_lvm_target_loc.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,targetlocation)
		//void main (int iTarget, float fX, float fY, float fZ)
		int iTarget = StringToInt( sParam1 );
		float fX = StringToFloat( sParam2 );
		float fY = StringToFloat( sParam3 );
		float fZ = StringToFloat( sParam4 );
		
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
		return;
	}
	else if ( sCommand == "targetobject" )
	{			
		///***********************************///
		//gui_wand_lvm_target_obj.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,lvm,targetobject)
		//void main (int iTarget)
		int iTarget = StringToInt( sParam1 );
		
		object oTarget = IntToObject(iTarget);
		
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_INPUT", -1, IntToString(iTarget));
		SetGUIObjectText(oPC, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, GetName(oTarget));
		return;
	}
	

}