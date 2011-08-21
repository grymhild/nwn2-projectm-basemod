/* Script for the Avatar object from the deck of many things,
 * which allows the user to polymorph into an avatar at will.
 */
#include "_HkSpell"
#include "_SCInclude_DeckOfMany"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE ;
	// Get the stored target
	object oTarget = OBJECT_SELF;
	if (!GetIsObjectValid(oTarget))
	{
		return;
	}
	// Don't reapply if we're already polymorphed
	if (CSLGetIsPolymorphed(oTarget))
	{
		return;
	}
	DoAvatarDeckCardTransform(oTarget);
}