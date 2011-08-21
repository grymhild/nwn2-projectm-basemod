////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_skills - DM Friendly Initiative - GUI script for SKILL UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMFI"
#include "_SCInclude_DMFIComm"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oPossess;
	object oTool = CSLDMFI_GetTool(oPC);
	string sCommand;
	string sValue;
	string sNum;
	int n;
	int nNum;
	
	sNum = GetStringRight(sInput, (GetStringLength(sInput)-4));
	nNum = StringToInt(sNum);	

	CloseGUIScreen(oPC, SCREEN_DMFI_SKILLS);
	
	//sValue = GetLocalString(oTool, LIST_PREFIX + "LIST SKILL" + "." + IntToString(nNum-1));
	sValue = CSLDataArray_GetString(oTool, "LIST SKILL", nNum-1);
	sValue = GetStringLowerCase(sValue);
			
	sCommand = "roll " + sValue;
	//CSLMessage_SendText(oPC, "DEBUGGING: sCommand skill: " + sCommand);
	DMFI_UITarget(oPC, oTool);	
	DMFI_DefineStructure(oPC, sCommand);
	DMFI_RunCommandCode(oTool, oPC, sCommand);
}				