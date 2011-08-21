// ga_enable_scripts
/*
	restores the saved event handlers
*/
// ChazM 12/21/05
// 
#include "_CSLCore_Messages"
#include "_SCInclude_Events"
	
void main(string sTarget) 
{
	object oTarget = CSLGetTarget(sTarget);
	SCRestoreEventHandlers(oTarget);
	SCDeleteSavedEventHandlers(oTarget);
}		
	