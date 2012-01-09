//::///////////////////////////////////////////////
//:: Magic Cirle Against Law
//:: NW_S0_CircGoodB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Add basic protection from good effects to
	entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_MAGIC_CIRCLE_AGAINST_LAW );
}