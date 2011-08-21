/*
    Increments the local int value by one on sTarget

    Parameters:
        string sTarget  = tag of target creature, if blank use PC
        string sVarName = name of variable
        string sAction  = action to take. "+" to add, "-" to subtract, "*" to multiply, "/" to divide
        int    nAdjustBy  = value to add/subtract/multiple/divide
        int    bPersistent = use a persistently stored variable on the target
*/

#include "_CSLCore_Messages"
#include "_CSLCore_Nwnx"

void main(string sTarget, string sVarName, string sAction, float fAdjustBy, int bPersistent)
{
   object oTarget = CSLGetTarget(sTarget, CSLTARGET_PC);

    if (!GetIsObjectValid(oTarget) == TRUE)
    {
        if (DEBUGGING >= 4) { CSLDebug("ga_adjust_float: " + sTarget + " not found!"); }
        return;
    }

    float value;
    if (bPersistent)
    {
        value = CSLGetPersistentFloat(oTarget, sVarName);
    }
    else
    {
        value = GetLocalFloat(oTarget, sVarName);
    }
    if (sAction == "+")
    {
        value = value + fAdjustBy;
    }
    else if (sAction == "-")
    {
        value = value - fAdjustBy;
    }
    else if (sAction == "*")
    {
        value = value * fAdjustBy;
    }
    else if (sAction == "/")
    {
        if (fAdjustBy == 0.0)
        {
            if (DEBUGGING >= 4) { CSLDebug("ga_adjust_float: " + sVarName + " divide by zero!"); }
        }
        else
        {
            value = value / fAdjustBy;
        }
    }
    if (bPersistent)
    {
        CSLSetPersistentFloat(oTarget, sVarName, value);
    }
    else
    {
        SetLocalFloat(oTarget, sVarName, value);

    }
}
