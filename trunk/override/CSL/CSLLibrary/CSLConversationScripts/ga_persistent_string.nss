// ga_local_string(string sVariable, string sValue, string sTarget)
/* 
   This script changes a Target's local string variable's value.

   Parameters:
     string sVariable  = The name of the variable.
     string sValue     = The new value for the variable.
     string sTarget    = The target's tag or identifier, if blank use OWNER
*/
// FAB 10/4
// BMA 4/27/05 - added CSLGetTarget()
// BMA 7/19/05 added object invalid printstring
// BMA-OEI 7/28/05 - added debug printstring

#include "_CSLCore_Messages"
#include "_CSLCore_Nwnx"

void main(string sVariable, string sValue, string sTarget, int iDeleteAfterMinutes )
{
	object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);

	//PrintString("ga_local_string: Object '" + GetName(oTarget) + "' variable '" + sVariable + "' set to '" + sValue + "'");
	CSLSetPersistentString(oTarget, sVariable, sValue);		
	
	if( iDeleteAfterMinutes != 0 )
	{
		DelayCommand( IntToFloat(iDeleteAfterMinutes*60), CSLDeletePersistentVariable(oTarget, sVariable));
	}
}