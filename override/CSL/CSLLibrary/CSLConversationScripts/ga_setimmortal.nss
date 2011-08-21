// ga_setimmortal(string sTarget, int bImmortal)
/*
	SetImmortal on target creature to bImmortal.

	Parameters:
		string sTarget	= tag of target creature, if blank use OWNER
		int bImmortal	= 0 for FALSE, else for TRUE		
*/
// BMA-OEI 9/28/05

#include "_CSLCore_Messages"
//#include "ginc_debug"

void main(string sTarget, int bImmortal)
{
	object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);

	if (GetIsObjectValid(oTarget) == TRUE)
	{
		if (bImmortal != 0)
		{
			bImmortal = TRUE;
		}
		else
		{
			bImmortal = FALSE;
		}

		SetImmortal(oTarget, bImmortal);
	}
	//else
	//{
	//	ErrorMessage("ga_setimmortal: " + sTarget + " not found!");
	//}
}