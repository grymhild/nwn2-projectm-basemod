//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Enforcer)
//:: cmi_s2_neteamworkb
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "cmi_includes"

void main()
{	
	if ( GetExitingObject() != GetAreaOfEffectCreator() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_SPELLABILITY_AURA_NE_TEAMWORK );
	}
}