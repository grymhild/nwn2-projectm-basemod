//::///////////////////////////////////////////////
//:: Silence: On Exit
//:: NW_S0_SilenceB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target is surrounded by a zone of silence
	that allows them to move without sound.  Spell
	casters caught in this area will be unable to cast
	spells.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_SILENCE, SPELL_SILENCE_AOE, SPELL_SILENCE_FRIEND, SPELL_SILENCE_HOSTILE );
}