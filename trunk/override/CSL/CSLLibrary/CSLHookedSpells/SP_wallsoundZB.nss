//::///////////////////////////////////////////////
//:: Wall of Sound: On Exit(within 30 ft - can't communicate or talk)
//:: SG_S0_WallSndF.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Brd 3
	Components: V, S
	Casting Time: 1 action
	Range: Short
	Duration: 1 round/level
	Area of Effect: Special
	Saving Throw: See text
	Spell Resistance: No

	The wall of sound spell brings forth an immobile, shimmering curtain of violently
	disturbed air. The wall is 10 meters wide x 2 meters thick. One side of the wall (away from the caster),
	produces a voluminous roar that completely disrupts all communication, command words, verbal spell components, and
	any other form of organized sound within 30 feet. In addition, those within 10 feet are
	deafened for 1d4 turns if they fail a fortitude save.
	On the other side of the wall, a loud roar can be heard, but communication is possible
	by shouting, and verbal components and command words function normally.
	Anyone passing through the wall suffers 1d8 points of damage and is permanently
	deafened unless he makes a successful Fortitude save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 5, 2004
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_WALL_OF_SOUND, EFFECT_TYPE_SILENCE );
}