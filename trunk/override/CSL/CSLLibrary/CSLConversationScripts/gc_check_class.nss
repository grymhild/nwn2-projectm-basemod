// gc_check_class(int nClass)
/*
    This script checks to see if the player (PC_Speaker) has any levels of a certain class
        nClass  = The integer of which class to check for (list boxes will be done later)
*/
// FAB 10/11
// BMA-OEI 8/23/05 added warlock check

int StartingConditional(int nClass)
{

    object oPC = GetPCSpeaker();
    int nNewClass;

    switch ( nClass )
    {
        case 0:     // BARBARIAN
            nNewClass = CLASS_TYPE_BARBARIAN;
            break;
        case 1:     // BARD
            nNewClass = CLASS_TYPE_BARD;
            break;
        case 2:     // CLERIC
            nNewClass = CLASS_TYPE_CLERIC;
            break;
        case 3:     // DRUID
            nNewClass = CLASS_TYPE_DRUID;
            break;
        case 4:     // FIGHTER
            nNewClass = CLASS_TYPE_FIGHTER;
            break;
        case 5:     // MONK
            nNewClass = CLASS_TYPE_MONK;
            break;
        case 6:     // PALADIN
            nNewClass = CLASS_TYPE_PALADIN;
            break;
        case 7:     // RANGER
            nNewClass = CLASS_TYPE_RANGER;
            break;
        case 8:     // ROGUE
            nNewClass = CLASS_TYPE_ROGUE;
            break;
        case 9:     // SORCERER
            nNewClass = CLASS_TYPE_SORCERER;
            break;
        case 10:	// WIZARD
            nNewClass = CLASS_TYPE_WIZARD;
            break;
        case 11:    // WARLOCK
            nNewClass = CLASS_TYPE_WARLOCK;
            break;
    }

    if (GetLevelByClass(nNewClass,oPC) != 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
