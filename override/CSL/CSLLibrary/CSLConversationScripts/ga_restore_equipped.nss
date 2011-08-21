// ga_restore_equipped
/*
	This script restores the equipped items that were previously marked with ga_remember_equipped.
	
	Parameters:
		string sCreature = Tag of object giving items.  Default is PC. (Must be creature)
*/
// ChazM 3/15/06


#include "_CSLCore_Items"
#include "_CSLCore_Messages"
	
void main(string sCreature)
{
	object oCreature = CSLGetTarget(sCreature, CSLTARGET_PC);
	
	//PrettyDebug ("sCreature = " + GetName(oCreature));

	CSLRestoreEquippedItems(oCreature);
}