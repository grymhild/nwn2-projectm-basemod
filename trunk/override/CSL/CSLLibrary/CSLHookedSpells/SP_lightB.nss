//::///////////////////////////////////////////////
//:: Light (Exit)
//:: NW_S0_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Light
	Evocation [Light]
	Level:	Brd 0, Clr 0, Drd 0, Sor/Wiz 0
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to glow like a torch, shedding bright light
	in a 20-foot radius (and dim light for an additional 20 feet) from the
	point you touch. The effect is immobile, but it can be cast on a
	movable object. Light taken into an area of magical darkness does not
	function.
	
	A light spell (one with the light descriptor) counters and dispels a
	darkness spell (one with the darkness descriptor) of an equal or lower
	level.
	
	Arcane Material Component A firefly or a piece of phosphorescent moss.
	
	
	Applies a light source to the target for
	1 hour per level

	XP2
	If cast on an item, item will get temporary
	property "light" for the duration of the spell
	Brightness on an item is lower than on the
	continual light version.

*/


#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), -SPELL_LIGHT );
}