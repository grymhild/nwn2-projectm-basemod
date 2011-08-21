/** @file
* @brief Include file for DM Inventory and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_Class"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Items"
#include "_CSLCore_Strings"
#include "_CSLCore_UI"
#include "_CSLCore_Player"


////////////////////////////////////////////////////////////////////////////////
// Wand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

const string WAND_NEW_VAR_NAME		= "<Variable Name>";
const string WAND_UI_LV_TITLE		= "Local Variables"; 
const string WAND_UI_LV_ACCEPT		= "OK";
const string WAND_UI_LV_CANCEL		= "Cancel";
const string WAND_UI_LV_DELETE		= "Delete";
const string WAND_UI_LV_NEW			= "New";
const string WAND_UI_LV_X			= "X:";
const string WAND_UI_LV_Y			= "Y:";
const string WAND_UI_LV_Z			= "Z:";
const string WAND_UI_LV_AREA		= "Area:";
const string WAND_UI_LV_ORIENT		= "Fac.:";
const string WAND_UI_LV_TT_OBJ_ID	= "Rapresents the numeric ID of the target object.\nInsert the value <i>-1</i> to reference <i>OBJECT_INVALID</i>";
const string WAND_UI_LV_TT_NEW_VAR	= "Create a new variable";
const string WAND_UI_LV_TT_SAVE		= "Save the modifications";
const string WAND_UI_LV_TT_DELETE	= "Delete the variable";
const string WAND_UI_LV_TT_CANCEL	= "Cancel";
const string WAND_UI_LV_TT_INTEGER	= "Integer";
const string WAND_UI_LV_TT_FLOAT	= "Float";
const string WAND_UI_LV_TT_STRING	= "String";
const string WAND_UI_LV_TT_LOCATION	= "Location";
const string WAND_UI_LV_TT_OBJECT	= "Object";
const string WAND_UI_LV_TT_CLICK	= "Click on the target object";
const string WAND_UI_LV_TT_OBJ_NAME	= "Object's name";

const string 	WAND_GUI_LV_MANAGER		 			= "dm_varmanager.xml";
const string	WAND_LV_MANAGER_OBJ_INV_REF 		= "OBJECT_INVALID";

const int 		WAND_MAX_VARIABLE_NAME_LENGTH		= 22;


/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_SetLvmTarget(object oSubject, object oTarget)
{
	if (GetIsObjectValid(oTarget))
	{
		SetLocalObject(oSubject, "WAND_LVM_TARGET", oTarget);
	}
	else
	{
		DeleteLocalObject(oSubject, "WAND_LVM_TARGET");	
	}
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
object CSLDMVariable_GetLvmTarget(object oSubject)
{

	return GetLocalObject(oSubject, "WAND_LVM_TARGET");	
}



/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string CSLDMVariable_GetAreaShortDesc(object oArea)
{
	return GetName(oArea);
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_InitAreaList (object oSubject)
{
	object oArea = GetFirstArea();
	string sText, sVariable, sAreaId;
	
	while (GetIsObjectValid(oArea))
	{
				
		sText = "VAR_LOC_AREA=" + CSLDMVariable_GetAreaShortDesc (oArea);		
		
		sAreaId = IntToString(ObjectToInt(oArea));
		sVariable = "0=" + sAreaId;
	
		AddListBoxRow(oSubject, WAND_GUI_LV_MANAGER, "AREA_LIST", "Area_" + sAreaId, sText, "", sVariable, "");

		oArea = GetNextArea();
	}
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_ResetTargetVarRepository(object oSubject)
{

	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_INT_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_FLOAT_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_STR_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_LIST");
}


/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string CSLDMVariable_GetObjectShortDesc (object oObject)
{
	string sShortDesc = GetName(oObject);
	
	if (sShortDesc == "")
	{
		sShortDesc = GetTag(oObject);
	}
	
	if (sShortDesc == "")
	{
		sShortDesc = GetResRef(oObject);
	}

	return sShortDesc;
}




/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_AddVar(object oUiOwner, object oTarget, int iIndex)
{
	string sListBox, sTexts, sVariables, sVarValue, sIndex;
	int iVarType = GetVariableType(oTarget, iIndex);
	string sVarName = GetVariableName(oTarget, iIndex);
		
	switch (iVarType)
	{
		case VARIABLE_TYPE_DWORD:
			sListBox = "VAR_OBJ_LIST";	
			sVarValue = (GetIsObjectValid(GetLocalObject(oTarget, sVarName))) ? CSLTruncate(CSLDMVariable_GetObjectShortDesc(GetLocalObject(oTarget, sVarName)), WAND_MAX_VARIABLE_NAME_LENGTH ) : "OBJECT_INVALID";
			break;
			
		case VARIABLE_TYPE_FLOAT:		
			sListBox = "VAR_FLOAT_LIST";	
			sVarValue = CSLFormatFloat(GetLocalFloat(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_INT:
			sListBox = "VAR_INT_LIST";	
			sVarValue = IntToString(GetLocalInt(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_LOCATION:
			sListBox = "VAR_LOC_LIST"; 
			sVarValue = CSLTruncate(CSLDMVariable_GetAreaShortDesc(GetAreaFromLocation(GetLocalLocation(oTarget, sVarName))), WAND_MAX_VARIABLE_NAME_LENGTH);
			break;

		case VARIABLE_TYPE_STRING:
			sListBox = "VAR_STR_LIST";	
			sVarValue = CSLTruncate(GetLocalString(oTarget, sVarName), WAND_MAX_VARIABLE_NAME_LENGTH);
			break;
			
		default:
			return;					
	}

	sTexts = "VAR_TEXT_BUTTON=" + CSLTruncate(sVarName, WAND_MAX_VARIABLE_NAME_LENGTH) + ";";		
	sTexts += "VAR_VALUE_BUTTON=" + sVarValue + ";";
	
	sIndex = IntToString(iIndex);
	sVariables = "0=" + sIndex;
						
	AddListBoxRow(oUiOwner, WAND_GUI_LV_MANAGER, sListBox, "Var_" + sIndex, sTexts, "", sVariables, "");

}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_ModifyVar(object oUiOwner, object oTarget, int iIndex) {

	string sListBox, sTexts, sVariables, sVarValue, sIndex;
	int iVarType = GetVariableType(oTarget, iIndex);
	string sVarName = GetVariableName(oTarget, iIndex);
		
	switch (iVarType)
	{
		case VARIABLE_TYPE_DWORD:
			sListBox = "VAR_OBJ_LIST";	
			sVarValue = (GetIsObjectValid(GetLocalObject(oTarget, sVarName))) ? CSLTruncate(CSLDMVariable_GetObjectShortDesc(GetLocalObject(oTarget, sVarName)),WAND_MAX_VARIABLE_NAME_LENGTH) : "OBJECT_INVALID";
			break;
			
		case VARIABLE_TYPE_FLOAT:		
			sListBox = "VAR_FLOAT_LIST";	
			sVarValue = CSLFormatFloat(GetLocalFloat(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_INT:
			sListBox = "VAR_INT_LIST";	
			sVarValue = IntToString(GetLocalInt(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_LOCATION:
			sListBox = "VAR_LOC_LIST"; 
			sVarValue = CSLTruncate(CSLDMVariable_GetAreaShortDesc(GetAreaFromLocation(GetLocalLocation(oTarget, sVarName))), WAND_MAX_VARIABLE_NAME_LENGTH);
			break;

		case VARIABLE_TYPE_STRING:
			sListBox = "VAR_STR_LIST";	
			sVarValue = CSLTruncate(GetLocalString(oTarget, sVarName), WAND_MAX_VARIABLE_NAME_LENGTH);
			break;
			
		default:
			return;					
	}

	sTexts = "VAR_TEXT_BUTTON=" + CSLTruncate(sVarName, WAND_MAX_VARIABLE_NAME_LENGTH) + ";";		
	sTexts += "VAR_VALUE_BUTTON=" + sVarValue + ";";
	
	sIndex = IntToString(iIndex);
	sVariables = "0=" + sIndex;
			
	ModifyListBoxRow(oUiOwner, WAND_GUI_LV_MANAGER, sListBox, "Var_" + sIndex, sTexts, "", sVariables, "");

}





/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void CSLDMVariable_InitTargetVarRepository(object oSubject, object oTarget) {
    
    int iIndex = 0;
	string sVarName = GetVariableName(oTarget, iIndex);
			
	while (GetVariableType(oTarget, iIndex) != -1)
	{

		CSLDMVariable_AddVar(oSubject, oTarget, iIndex);

        iIndex++;	
    }	
}


void CSLDMVariable_Display( object oTargetToDisplay, object oPCToShowVars = OBJECT_SELF )
{
	CSLDMVariable_SetLvmTarget(oPCToShowVars, oTargetToDisplay);
	DisplayGuiScreen(oPCToShowVars, WAND_GUI_LV_MANAGER, FALSE, WAND_GUI_LV_MANAGER);
	CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oTargetToDisplay);

}