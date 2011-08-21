// ga_reequip_all_items
/*
	re-equips all "remembered" items.
*/
// ChazM 6/27/06
#include "_CSLCore_Messages"
#include "_CSLCore_Items"

void main(string sTarget)
{
	object oOwner = CSLGetTarget(sTarget);
	CSLRestoreEquippedItems(oOwner, TRUE);
}