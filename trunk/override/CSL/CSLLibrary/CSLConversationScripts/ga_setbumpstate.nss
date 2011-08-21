// ga_setbumpstate

// Set the bumpable flag for sTarget.

// nBumpState is defined as follows in nwscript.nss:
// int BUMPSTATE_DEFAULT = 0;
// int BUMPSTATE_BUMPABLE = 1;
// int BUMPSTATE_UNBUMPABLE = 2;


// EPF 8.2.06

#include "_CSLCore_Messages"

void main(string sTarget, int nBumpState)
{
	object oTarget = CSLGetTarget(sTarget);
	
	SetBumpState(oTarget, nBumpState);
}