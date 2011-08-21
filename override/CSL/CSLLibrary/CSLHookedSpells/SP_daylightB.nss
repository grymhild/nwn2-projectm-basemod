//::///////////////////////////////////////////////
//:: Daylight (Exit)
//:: SP_daylightA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*

	Daylight
	Evocation [Light]
	Level:	Brd 3, Clr 3, Drd 3, Pal 3, Sor/Wiz 3
	Components:	V, S
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	
	The object touched sheds light as bright as full daylight in a 60-foot
	radius, and dim light for an additional 60 feet beyond that. Creatures
	that take penalties in bright light also take them while within the
	radius of this magical light. Despite its name, this spell is not the
	equivalent of daylight for the purposes of creatures that are damaged
	or destroyed by bright light.
	
	If daylight is cast on a small object that is then placed inside or
	under a light-proof covering, the spell’s effects are blocked until the
	covering is removed.
	
	Daylight brought into an area of magical darkness (or vice versa) is
	temporarily negated, so that the otherwise prevailing light conditions
	exist in the overlapping areas of effect.
	
	Daylight counters or dispels any darkness spell of equal or lower
	level, such as darkness.
*/


#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC );
}