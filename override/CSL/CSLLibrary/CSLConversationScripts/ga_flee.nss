/* 
   This script sets Target's to flee.
*/

#include "_CSLCore_Messages"
#include "_SCInclude_AI"

void main( string sTarget )
{
	object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);

	//PrintString("ga_local_string: Object '" + GetName(oTarget) + "' variable '" + sVariable + "' set to '" + sValue + "'");
	SCSetSpawnInCondition(CSL_FLAG_FLEE, TRUE, oTarget);	

}