/*
Derived skill check. 
Instead of a straight skill check we're going to check something based on a combination of two skills
Example, sense motive to catch a lie might be spot (catching facial ticks) + listen (hear stress in voice)
*/

/*
// gc_skill_dc(int nSkill, int nDC)
    Determine if PC Speaker's skill roll is successful.
    
    Parameters:
        int nSkill     = skill int to check
        int nDC        = difficulty class to beat
    
    Remarks:
        skill ints
        0    APPRAISE
        1    BLUFF
        2    CONCENTRATION
        3    CRAFT ALCHEMY
        4    CRAFT ARMOR
        5    CRAFT WEAPON
        6    DIPLOMACY
        7    DISABLE DEVICE
        8    DISCIPLINE
        9    HEAL
        10    HIDE
        11    INTIMIDATE
        12    LISTEN
        13    LORE
        14    MOVE SILENTLY
        15    OPEN LOCK
        16    PARRY
        17    PERFORM
        18    RIDE
        19    SEARCH
        20    CRAFT TRAP
        21    SLEIGHT OF HAND
        22    SPELL CRAFT
        23    SPOT
        24    SURVIVAL
        25    TAUNT
        26    TUMBLE
        27    USE MAGIC DEVICE
*/
// BMA-OEI 9/02/05

#include "_CSLCore_Messages"
#include "_CSLCore_Info"

//alter original bio script to take a second skill
int StartingConditional(int nSkill1, int nSkill2, int nDC)
{
    object oPC = GetPCSpeaker();
     
//combine the two skill values into one derived value    
    int nSkillVal1 = CSLGetSkillConstant(nSkill1);
    int nSkillVal2 = CSLGetSkillConstant(nSkill2);
    int nDerived = nSkillVal1 + nSkillVal2;

//check this like default, except used the derevied value.        
    if (GetIsSkillSuccessful(oPC, nDerived, nDC) == TRUE)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}