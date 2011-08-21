// ga_jump(string sDestination, string sTarget, float fDelay)
/*
   Jump an object to a waypoint or another object.

   Parameters:
     string sDestination = Tag of waypoint or object to jump to.
     string sTarget      = Tag of object to jump. Default is OWNER
     float fDelay        = Delay before JumpToObject()
*/
// TDE 3/9/05
// ChazM 3/11/05
// BMA 7/13/05 changed Delay/Assign to Assign/Delay
// BMA-OEI 1/11/06 removed default param

#include "_CSLCore_Messages"
	
void main(string sDestination, string sTarget, float fDelay)
{
	object oDestination = CSLGetTarget(sDestination);
	object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);

	AssignCommand(oTarget, DelayCommand(fDelay, JumpToObject(oDestination)));
}