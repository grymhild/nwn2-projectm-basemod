//::///////////////////////////////////////////////
//:: Web: On Exit
//:: NW_S0_WebB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a mass of sticky webs that cling to
	and entangle targets who fail a Reflex Save
	Those caught can make a new save every
	round.  Movement in the web is 1/5 normal.
	The higher the creatures Strength the faster
	they move within the web.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_GREATER_SHADOW_CONJURATION_WEB, SPELL_WEB );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
}