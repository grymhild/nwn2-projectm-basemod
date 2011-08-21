//::///////////////////////////////////////////////
//:: Caustic Web - OnExit
//:: cmi_s0_causwebb
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Caustic Web
//:: Invocation Type: Greater;
//:: Spell Level Equivalent: 4
//:: Sticky strands cling to all creatures within the area of effect, entangling
//:: them. Creatures who make their save can move, but at a reduced rate
//:: dependent on their Strength. Entering the web causes 2d6 points of acid
//:: damage while those that remain within the area suffer 1d6 points of damage
//:: each round.
//:://////////////////////////////////////////////
//const int SPELL_I_CAUSTIC_MIRE = 2092;


#include "_HkSpell"

void main()
{	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_I_CAUSTIC_MIRE );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
}