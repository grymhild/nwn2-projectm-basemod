// gc_check_classpr
/*
    This script checks to see if the player (PC_Speaker) has any levels of a certain prestige class
        nClass  = The integer of which class to check for (list boxes will be done later)
*/
// FAB 10/11

int StartingConditional(int nClass)
{

    object oPC = GetPCSpeaker();
    int nPrestigeClass;

    switch ( nClass )
    {
        case 0:     // ARCANE_ARCHER
            nPrestigeClass = CLASS_TYPE_ARCANE_ARCHER;
            break;
        case 1:     // ARCANE_TRICKSTER
            //nPrestigeClass = CLASS_TYPE_ARCANE_TRICKSTER;
            break;
        case 2:     // ASSASSIN
            nPrestigeClass = CLASS_TYPE_ASSASSIN;
            break;
        case 3:     // BLACKGUARD
            nPrestigeClass = CLASS_TYPE_BLACKGUARD;
            break;
        case 4:     // CAVALIER
            //nPrestigeClass = CLASS_TYPE_CAVALIER;
            break;
        case 5:     // CONTEMPLATIVE
            //nPrestigeClass = CLASS_TYPE_CONTEMPLATIVE;
            break;
        case 6:     // DIVINECHAMPION
            nPrestigeClass = CLASS_TYPE_DIVINECHAMPION;
            break;
        case 7:     // DRAGONDISCIPLE
            nPrestigeClass = CLASS_TYPE_DRAGONDISCIPLE;
            break;
        case 8:     // DWARVENDEFENDER
            nPrestigeClass = CLASS_TYPE_DWARVENDEFENDER;
            break;
        case 9:     // FRENZIED_BERSERKER
            //nPrestigeClass = CLASS_TYPE_FRENZIED_BERSERKER;
            break;
        case 10:     // HARPER
            nPrestigeClass = CLASS_TYPE_HARPER;
            break;
        case 11:     // MYSTIC_THEURGE
            //nPrestigeClass = CLASS_TYPE_MYSTIC_THEURGE;
            break;
        case 12:     // PALEMASTER
            nPrestigeClass = CLASS_TYPE_PALEMASTER;
            break;
        case 13:     // SACRED_FIST
            //nPrestigeClass = CLASS_TYPE_SACRED_FIST;
            break;
        case 14:     // SHADOW_THIEF
            //nPrestigeClass = CLASS_TYPE_SHADOW_THIEF;
            break;
        case 15:     // SHADOWDANCER
            nPrestigeClass = CLASS_TYPE_SHADOWDANCER;
            break;
        case 16:     // SHIFTER
            nPrestigeClass = CLASS_TYPE_SHIFTER;
            break;
        case 17:     // WEAPON_MASTER
            nPrestigeClass = CLASS_TYPE_WEAPON_MASTER;
            break;
    }

    if ( GetLevelByClass(nPrestigeClass,oPC) != 0 ) return TRUE;

    return FALSE;

}
