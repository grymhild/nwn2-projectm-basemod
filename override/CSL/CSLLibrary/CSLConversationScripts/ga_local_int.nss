// ga_local_int(string sVariable, string sChange, string sTarget)
/*
   This script changes a local int variable's value
   
   Parameters:
     string sVariable   = Name of variable to change
     string sChange     = VALUE	  (EFFECT)
	 					  "5"     (Set to 5)
						  "=-2"   (Set to -2)
						  "+3"    (Add 3)
						  "+"     (Add 1)
						  "++"    (Add 1)
						  "-4"    (Subtract 4)
						  "-"     (Subtract 1)
						  "--"    (Subtract 1)
     string sTarget	= Target tag or identifier. If blank then use OBJECT_SELF
*/
// FAB 10/7
// BMA 4/15/05 added set operator, "=n"
// BMA 4/27/05 added CSLGetTarget()
// ChazM 5/4/05 moved CalcNewIntValue() to "ginc_var_ops"
// BMA 7/19/05 added object invalid printstring

// btm added support for 3d6 type random strings
// btm added support for deleting the var after x amount of minutes - note this has some possible side effects

#include "_CSLCore_Messages"
//#include "ginc_var_ops"
#include "_CSLCore_Math"

void main(string sVariable, string sChange, string sTarget, int iDeleteAfterMinutes)
{
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OBJECT_SELF);
	
	if (!GetIsObjectValid(oTarget) == TRUE)
    {
        //ErrorMessage("ga_adjust_int: " + sTarget + " not found!");
        return;
    }
    
	int nOldValue = GetLocalInt(oTarget, sVariable);
	int nNewValue = CSLModifyIntWithRollString(nOldValue, sChange);

	SetLocalInt(oTarget, sVariable, nNewValue);
	
	if( iDeleteAfterMinutes != 0 )
	{
		DelayCommand( IntToFloat(iDeleteAfterMinutes*60), DeleteLocalInt(oTarget, sVariable));
	}
    //PrintString(sTarget + "'s variable " + sVariable + " is now set to " + IntToString(nNewValue) );
}