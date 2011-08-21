//::///////////////////////////////////////////////
//:: Filter (OnExit)
//:: sg_s0_filterB.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Abjuration
	Level: Sor/Wiz 2
	Components: V, S
	Casting Time: 1 action
	Range: Touch
	Area: 10 ft sphere around creature touched
	Duration: 1 turn/level
	Saving Throw: None
	Spell Resistance: No

	This spell creates an invisible globe of protection
	that filters out all noxious elements from poisonous
	vapors created by spells (such as Stinking Cloud),
	making them immune to damage and any penalties from
	said effects. Effects from dragon's breath (such as
	a green dragon's chlorine gas) cause half-damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 1, 2004
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
	//if ( GetExitingObject() != GetAreaOfEffectCreator() )
	//{ 
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_FILTER );
	//}
}