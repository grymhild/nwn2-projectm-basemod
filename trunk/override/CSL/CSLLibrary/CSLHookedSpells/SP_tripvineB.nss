//::///////////////////////////////////////////////
//:: Trip Vine - OnExit
//:: cmi_s0_tripvineb
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Trip Vine
//:: Transmutation
//:: Level: Druid 2, Ranger 2
//:: Components: VS
//:: Range: Medium
//:: Area: 20-ft.-radius
//:: Duration: 3 minutes
//:: Saving Throw: Reflex negates
//:: Spell Resistance: No
//:: Trip vine causes plants within the area to grow together to form a tangle.
//:: Any creature entering or within the affected area must succeed on a Reflex
//:: save or be knocked down.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_TRIP_VINE );
}