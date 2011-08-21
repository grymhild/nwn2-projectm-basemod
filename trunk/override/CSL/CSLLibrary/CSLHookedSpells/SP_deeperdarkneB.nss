//::///////////////////////////////////////////////
//:: Deeper Darkness (OnExit)
//:: sg_s0_deepdarkB.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation [Darkness]
	Level: Clr 3
	Components: V,S
	Casting Time: 1 action
	Range: Touch
	Target: Object touched
	Duration: 1 day (24 hours)/level
	Saving Throw: None
	Spell Resistance: No

	The spell causes the object touched to shed absolute
	darkness in a 60 foot radius. Even creatures who can
	normally see in the dark cannot see through this
	magical darkness.

	Deeper Darkness counters or dispels any light spell of
	equal or lower level, including Daylight or Light.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 4, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_DEEPER_DARKNESS );
}
