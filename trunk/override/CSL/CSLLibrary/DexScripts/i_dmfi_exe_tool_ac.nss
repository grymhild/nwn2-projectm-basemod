////////////////////////////////////////////////////////////////////////////////
// dmfi_exe_tool - DM Friendly Initiative - Script for DMFI Tool Activation
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/5/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "_SCInclude_DMFI"

void main()
{
    object oPC;
    object oTarget;
    object oTool;
    string sResRef;

    oPC = GetItemActivator();
    oTarget = GetItemActivatedTarget();
    oTool = GetItemActivated();
    sResRef = GetResRef(oTool);
	
	if ((!CSLGetIsDM(oPC)) && (sResRef==DMFI_TOOL_RESREF))
	{  // Make sure Players can't use a DM Tool
		SetPlotFlag(oTool, FALSE);
		DestroyObject(oTool);
		return;
	}		
	   
	SetLocalObject(oTool, DMFI_TARGET, oTarget);
	DMFI_RenameObject(oPC, oTarget);
}