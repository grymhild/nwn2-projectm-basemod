//::///////////////////////////////////////////////
//:: Vine Mind, Hamper Movement: On Exit
//:: X2_S0_VineMHmpB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of Vine Mind, Hamper
    Movement have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_VINE_MINE_HAMPER_MOVEMENT, EFFECT_TYPE_MOVEMENT_SPEED_DECREASE );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
}