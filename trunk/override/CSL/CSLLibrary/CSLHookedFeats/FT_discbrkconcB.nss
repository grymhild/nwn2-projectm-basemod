//::///////////////////////////////////////////////
//:: Dissonant Chord - Break Concentration
//:: cmi_s2_brkconcb
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: October 18, 2009
//:://////////////////////////////////////////////
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"



#include "_HkSpell"

void main()
{	
	if ( GetAreaOfEffectCreator() != GetExitingObject() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELLABILITY_DISCHORD_BREAK_CONC );
	}
}