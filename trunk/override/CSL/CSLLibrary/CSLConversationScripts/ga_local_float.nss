// ga_local_float(string sVariable, string sChange, string sTarget
/*
   This script changes a local float variable's value
   
   Parameters:
     string sVariable   = Name of variable to change
     string sChange     = VALUE	  (EFFECT)
	 					  "5.1"   (Set to 5.1)
						  "=-2.3" (Set to -2.3)
						  "+3.0"  (Add 3.0)
						  "+"     (Add 1.0)
						  "++"    (Add 1.0)
						  "-4.9"  (Subtract 4.9)
						  "-"     (Subtract 1.0)
						  "--"    (Subtract 1.0)
     string sTarget	= Target tag or identifier. If blank then use OBJECT_SELF
*/
// FAB 10/7
// BMA 4/15/05 added set operator, "=n"
// BMA 4/27/05 added CSLGetTarget()
// BMA 7/19/05 added object invalid printstring

#include "_CSLCore_Messages"

void main(string sVariable, string sChange, string sTarget, int iDeleteAfterMinutes)
{
    float fChange;

    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OBJECT_SELF);
	//if (GetIsObjectValid(oTarget) == FALSE) PrintString("ga_local_string: " + sTarget + " is invalid");

    if (GetStringLeft(sChange, 1) == "=")
    {
		sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
		fChange = StringToFloat(sChange);	
    }
    else if (GetStringLeft(sChange, 1) == "+")
    {
        // If sChange is just "+" then default to increment by 1
        if (GetStringLength(sChange) == 1)
        {
            fChange = GetLocalFloat(oTarget, sVariable) + 1.0;
        }
        else    // This means there's more than just "+"
        {
            if (GetSubString(sChange, 1, 1) == "+")     // "++" condition
            {
                fChange = GetLocalFloat(oTarget, sVariable) + 1.0;
            }
            else
            {
                sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
                fChange = GetLocalFloat(oTarget, sVariable) + StringToFloat(sChange);
            }
        }
    }
    else if (GetStringLeft(sChange, 1) == "-")
    {
        // If sChange is just "-" then default to increment by 1
        if (GetStringLength(sChange) == 1)
        {
            fChange = GetLocalFloat(oTarget, sVariable) - 1.0;
        }
        else    // This means there's more than just "-"
        {
            if (GetSubString(sChange, 1, 1) == "-")     // "--" condition
            {
                fChange = GetLocalFloat(oTarget, sVariable) - 1.0;
            }
            else
            {
                sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
                fChange = GetLocalFloat(oTarget, sVariable) - StringToFloat(sChange);
            }
        }
    }
    else
    {
        fChange = StringToFloat(sChange);
        if (sChange == "") fChange = GetLocalFloat(oTarget, sVariable) + 1.0;
    }

    // Debug Message - comment or take care of in final
    SetLocalFloat(oTarget, sVariable, fChange);
    
    if( iDeleteAfterMinutes != 0 )
	{
		DelayCommand( IntToFloat(iDeleteAfterMinutes*60), DeleteLocalFloat(oTarget, sVariable));
	}
}