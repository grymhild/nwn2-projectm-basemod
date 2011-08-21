//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist.nss
//:://////////////////////////////////////////////
/*
	All people within the AoE get 20% conceal.
*/
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_OBSCURING_MIST );
}

