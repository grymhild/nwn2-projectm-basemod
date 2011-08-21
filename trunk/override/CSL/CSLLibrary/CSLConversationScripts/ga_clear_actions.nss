// ga_clear_actions(string sTarget, int bClearCombatState )
/*
   This script clears the action queue of the target creature.

   Parameters:
     string sTarget - target who will Clear Actions.  Default is OWNER.
	 int bClearCombatState - 1 =Stop combat along with all other actions
*/
// ChazM 7/17/07

#include "_CSLCore_Messages"

void main(string sTarget, int bClearCombatState )
{
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);
	AssignCommand(oTarget, ClearAllActions(bClearCombatState));
}