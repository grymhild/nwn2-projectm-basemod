/*
    sets a local int on sTarget

    Parameters:
        string sTarget  = tag of target creature, if blank use PC
        string sVarName = name of variable
        int    nValue   = value to save
        int    bPersistent  to save the value of the int permanently for this target.
*/
#include "_CSLCore_Messages"
//#include "ginc_var_ops"
#include "_CSLCore_Math"

#include "_CSLCore_Nwnx"


void main(string sTarget, string sVarName, float fValue, int bPersistent)
{
	object oTarget = CSLGetTarget(sTarget, CSLTARGET_PC);
	
	if (! GetIsObjectValid(oTarget) )
	{
		return;
	}
	
	if (bPersistent)
	{
		CSLSetPersistentFloat(oTarget, sVarName, fValue);
	}
	else
	{
		SetLocalFloat(oTarget, sVarName, fValue);
	}
}