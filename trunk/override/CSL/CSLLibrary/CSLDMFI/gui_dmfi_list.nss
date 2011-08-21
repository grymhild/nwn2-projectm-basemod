////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_list - DM Friendly Initiative - GUI script for LIST UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// This UI serves 4 purposes within the player client:
//	*Abilities
//	*Languages
//	*Dice Number
//	**Dice Selection (Recursive)

#include "_SCInclude_DMFI"
#include "_SCInclude_DMFIComm"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oTool = CSLDMFI_GetTool(oPC);
	object oPossess;
	string sCommand;
	string sValue;
	string sText;
	int n;
	
	int nNum = StringToInt(GetStringRight(sInput, 1));
	int nPrior = GetLocalInt(oPC, DMFI_LIST_PRIOR);
	
	if (nPrior == DMFI_LIST_NUMBER)
	{
		SetLocalString(oPC, DMFI_LAST_COMMAND, "roll " + IntToString(nNum));		
		SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_TYPE);
		
		SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, "Choose which type of dice:");
		n=0;
		while (n<10)
		{
			//sText = GetLocalString(oTool, LIST_PREFIX + "LIST_DICE" + "." + IntToString(n));
			sText = CSLDataArray_GetString(oTool, "LIST_DICE", n);
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST+IntToString(n+1), -1, sText);
			n++;
		}		
		SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_TYPE);
	}
	else
	{	
		CloseGUIScreen(oPC, SCREEN_DMFI_LIST);
		
		if (nPrior == DMFI_LIST_TYPE)
		{
			sCommand = GetLocalString(oPC, DMFI_LAST_COMMAND);
			//sCommand = sCommand + GetLocalString(oTool, LIST_PREFIX + "LIST_DICE" + "." + IntToString(nNum-1));
			sCommand = sCommand + CSLDataArray_GetString(oTool,  "LIST_DICE", nNum-1);
		}
		else if (nPrior == DMFI_LIST_ABILITY)
		{
			//sValue = GetLocalString(oTool, LIST_PREFIX + "LIST_ABILITY" + "." + IntToString(nNum-1));
			sValue = CSLDataArray_GetString(oTool,  "LIST_ABILITY", nNum-1);
			sValue = GetStringLowerCase(sValue);
				
			sCommand = "roll " + sValue;
		}
		else if (nPrior == DMFI_LIST_LANG)
		{
			//sValue = GetLocalString(oTool, LIST_PREFIX + "LIST_LANGUAGE" + "." + IntToString(nNum-1));
			sValue = CSLDataArray_GetString(oTool, "LIST_LANGUAGE", nNum-1);
			sValue = GetStringLowerCase(sValue);
				
			sCommand = "language " + sValue;
		}
		DMFI_UITarget(oPC, oTool);		
		DMFI_DefineStructure(oPC, sCommand);
		DMFI_RunCommandCode(oTool, oPC, sCommand);	
	}		
}				