//::///////////////////////////////////////////////
//:: Dirge: On Exit
//:: x0_s0_dirgeET.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    MARCH 2003
    Remove the negative effects of the dirge.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: Update Pass By:

#include "_HkSpell"
#include "_SCInclude_Songs"

void main()
{
	if(GetHasSpellEffect(SPELL_DIRGE, GetExitingObject()))
    {
		DeleteLocalInt(GetExitingObject(), "X0_L_LASTPENALTY");
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_DIRGE );
	}
}


