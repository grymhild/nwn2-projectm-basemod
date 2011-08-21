//::///////////////////////////////////////////////
//:: Protective Aura
//:: NW_S2_ProtAuraB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Grants a bonus to saves and AC to allies within
	the spell radius.

	Used by both VFX_PER_PROTECTIVE_AURA and
	VFX_PER_PROTECTIVE_AURA_II.

	On Exit script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/17/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	if ( GetExitingObject() != GetAreaOfEffectCreator() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELLABILITY_PROTECTIVE_AURA );
	}
}