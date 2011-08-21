//::///////////////////////////////////////////////
//:: Bloodstorm - On Exit
//:: sg_s0_bldstmb.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation [Fear]
	Level: Sor/Wiz 3
	Components: V,S,M
	Casting Time: 1 Full Round
	Range: Medium (100 ft + 10 ft/level
	Area: Column 25 ft wide and 40 ft high
	Duration: 1 round/level
	Saving Throw: See Text
	Spell Resistance: Yes

	Bloodstorm summons a whirlwind of blood that
	envelops the entire area of effect and has
	several effects on those caught within it.
	First, those in the area of effect must make
	Reflex saving throws or be blinded by the
	swirling blood while they remain in the
	whirlwind and for 2d6 rounds thereafter.
	Second, all combatants withing the bloodstorm
	fight at -4 to their attack rolls, and ranged
	attacks that pass through the whirlwind also
	suffer this attack penalty (can't do). Third,
	the blood is slightly acidic and causes 1d4
	points of damage per round. Finally, victims
	must make a Will save or become frightened if
	8HD or above and panicked if less than 8HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 15, 2003
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
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_BLOODSTORM );
}