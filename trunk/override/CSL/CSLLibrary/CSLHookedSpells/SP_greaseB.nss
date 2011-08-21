//::///////////////////////////////////////////////
//:: Grease: On Exit
//:: NW_S0_GreaseB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the zone of grease must make
	a reflex save or fall down.  Those that make
	their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_GREASE, EFFECT_TYPE_MOVEMENT_SPEED_DECREASE );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
	
}