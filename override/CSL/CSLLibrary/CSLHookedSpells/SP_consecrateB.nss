//::///////////////////////////////////////////////
//:: Consecrate (OnExit)
//:: sg_s0_consecratB.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Clr 2
	Components: V, S
	Casting Time: 1 action
	Range: Close
	Area: 20-ft. radius emanation
	Duration: 2 hours/level
	Saving Throw: None
	Spell Resistance: No

	This spell blesses an area with positive energy.
	All Charisma checks made to turn undead within
	this area gain a +3 sacred bonus. Undead entering
	this area suffer minor disruption, giving them a
	-1 sacred penalty on attack rolls, damage rolls,
	and saves. Undead cannot be created within or
	summoned into a consecrated area.

	Consecrate counters and dispels Desecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 29, 2004
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	CSLEnviroExit( GetExitingObject(), CSL_ENVIRO_HOLY, GetAreaOfEffectCreator()  );
	/*
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_CONSECRATE );
	*/
}