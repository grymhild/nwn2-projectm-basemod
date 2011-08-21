//::///////////////////////////////////////////////
//:: Minor Malison (OnExit)
//:: sg_s0_minmalisB.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Enchantment
	Level: Sor/Wiz 3
	Components: V
	Casting Time: 1 action
	Range: Short
	Area: 30 ft radius emanation
	Duration: 2 rounds/level
	Saving Throw: None
	Spell Resistance: Yes

	This spell allows the caster to adversely affect
	all the saving throws of his enemies. Opponents
	under the influence of this spell receive a -1
	penalty to all saving throws.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 5, 2004
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
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_MINOR_MALISON );
}