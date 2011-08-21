//::///////////////////////////////////////////////
//:: Aura of Courage
//:: NW_S2_CourageAB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Paladin ability.  Grants +4 morale bonus on saves
	vs. fear effects to all allies within 10'.  The
	paladin herself gains an immunity to fear that's
	implemented in the code.

	On Exit script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
#include "_HkSpell"
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	if ( GetExitingObject() != GetAreaOfEffectCreator() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELLABILITY_AURA_OF_COURAGE );
	}
}