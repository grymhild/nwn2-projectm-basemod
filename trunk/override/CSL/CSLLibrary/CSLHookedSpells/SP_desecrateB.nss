//::///////////////////////////////////////////////
//:: Desecrate (OnExit)
//:: sg_s0_desecrateB.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Clr 2, Evil 2
	Components: V, S
	Casting Time: 1 action
	Range: Close
	Area: 20-ft. radius emanation
	Duration: 2 hours/level
	Saving Throw: None
	Spell Resistance: No

	This spell imbues an area with negative energy.
	All Charisma checks made to turn undead within
	this area suffer a -3 profane penalty. Undead entering
	this area gain a +1 sacred bonus on attack rolls, damage rolls,
	and saves. Undead created within or
	summoned into a consecrated area gain +1 hit
	point per HD.

	Desecrate counters and dispels Consecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 30, 2004
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
	CSLEnviroExit( GetExitingObject(), CSL_ENVIRO_PROFANE, GetAreaOfEffectCreator() );
	/*
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_DESECRATE );
	*/
}