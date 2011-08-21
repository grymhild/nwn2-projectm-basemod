// ga_disable_scripts
/*
	saves and clears the event handlers
*/
// ChazM 12/21/05
// 
#include "_CSLCore_Messages"
#include "_SCInclude_Events"
	
void main(string sTarget) 
{
	object oTarget = CSLGetTarget(sTarget);
	SCSaveEventHandlers(oTarget);
	SCClearEventHandlers(oTarget);
}		
	