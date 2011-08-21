//::///////////////////////////////////////////////
//:: Creeping Doom: On Exit
//:: NW_S0_CrpDoomB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures within the AoE take 2d6 acid damage
	per round and upon entering if they fail a Fort Save
	their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_CREEPING_DOOM, EFFECT_TYPE_MOVEMENT_SPEED_DECREASE );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
}