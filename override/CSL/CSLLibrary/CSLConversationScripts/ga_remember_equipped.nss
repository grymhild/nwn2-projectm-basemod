// ga_remember_equipped
/*
	This script marks the equipped items so that they can later be restored.
	
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

	CSLRememberEquippedItems(oCreature);
}