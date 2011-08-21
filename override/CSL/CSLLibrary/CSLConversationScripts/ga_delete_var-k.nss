
// ga_delete_var(string sTarget, string sVarName, int nType)
/*
    Deletes the specified local variable from the target

    Parameters:
        string sTarget  = tag of target creature, if blank use PC
        string sVarName = name of variable to delete
           int nType    = 0 for int, 1 for string
           int bPersistent = 1 if this is a persistent/permanent variable
*/

#include "_CSLCore_Messages"

void main(string sTarget, string sVarName, int nType)
{
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_PC);
    if (GetIsObjectValid(oTarget) == TRUE)
    {
        if (nType == 0)
        {
       		DeleteLocalInt(oTarget, sVarName);
        }
        else if (nType == 1)
        {
        	DeleteLocalString(oTarget, sVarName);
        }
        else              
        {
        	//ErrorMessage("ga_delete_var: " + sTarget + " invalid type.");
        }
    }
    else
    {
        //ErrorMessage("ga_delete_var: " + sTarget + " not found!");
    }
}
