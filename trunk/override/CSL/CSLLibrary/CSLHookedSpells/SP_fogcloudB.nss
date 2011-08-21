//::///////////////////////////////////////////////
//:: Fog Cloud - On Exit
//:: sg_s0_fogcloudb.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On:
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
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_FOG_CLOUD );
}