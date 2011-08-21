//::///////////////////////////////////////////////
//:: Vine Mine, Entangle B: On Exit
//:: X2_S0_VineMEntB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the entangle effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_VINE_MINE_ENTANGLE, EFFECT_TYPE_ENTANGLE );
}

