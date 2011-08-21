//::///////////////////////////////////////////////
//:: Blacklight: On Exit
//:: SG_S0_BlklightB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a globe of darkness around those in the area
	of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
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
	//object oTarget = GetExitingObject();
	//object oCreator = GetAreaOfEffectCreator();

	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nSpellId );
	//if ( GetExitingObject() != GetAreaOfEffectCreator() )
	//{ 
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_BLACKLIGHT );
	//}
}
