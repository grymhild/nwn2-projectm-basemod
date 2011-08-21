// ga_adjust_int(string sTarget, string sVarName, string sAction, int nAdjustBy)
/*
    Increments the local int value by one on sTarget

    Parameters:
        string sTarget  = tag of target creature, if blank use PC
        string sVarName = name of variable
        string sAction  = action to take. "+" to add, "-" to subtract, "*" to multiply, "/" to divide
        int    nAdjustBy  = value to add/subtract/multiple/divide
        int    bPersistent = 1 to save the value of the int permanently for this PC.
*/

#include "_CSLCore_Messages"
//#include "ginc_var_ops"
#include "_CSLCore_Math"
#include "_CSLCore_Nwnx"
//#include "ginc_param_const"
//#include "ginc_debug"
//#include "inc_pw_plot"

void main(string sTarget, string sVarName, string sAction, int nAdjustBy, int bPersistent)
{
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OBJECT_SELF);

    if (!GetIsObjectValid(oTarget) == TRUE)
    {
        //ErrorMessage("ga_adjust_int: " + sTarget + " not found!");
        return;
    }

    int value;
    if (bPersistent) {
        value = CSLGetPersistentInt(oTarget, sVarName);
    } else {
        value = GetLocalInt(oTarget, sVarName);
    }
    if (sAction == "+") {
        value = value + nAdjustBy;
    } else if (sAction == "-") {
        value = value - nAdjustBy;
    } else if (sAction == "*") {
        value = value * nAdjustBy;

    } else if (sAction == "/") {
        if (nAdjustBy == 0) {
            //ErrorMessage("ga_adjust_int: " + sTarget + " divide by zero!");
        } else {
            value = value / nAdjustBy;
        }
    }
    if (bPersistent) {
        CSLSetPersistentInt(oTarget, sVarName, value);
    } else {
        SetLocalInt(oTarget, sVarName, value);
    }
}