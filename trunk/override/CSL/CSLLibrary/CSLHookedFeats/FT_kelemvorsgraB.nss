//::///////////////////////////////////////////////
//:: Kelemvor's Grace
//:: NW_S2_KelemGraceA.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Doomguide ability.  Grants +4 bonus on saves
	vs. death effects to all allies within 10'.  The
	doomguide herself gains an immunity to death that's
	implemented in the code.

	OnExit() Script
	*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/28/2008
//:://////////////////////////////////////////////
#include "_HkSpell"


void main()
{	
	if ( GetAreaOfEffectCreator() != GetExitingObject() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELLABILITY_KELEMVORS_GRACE );
	}
}