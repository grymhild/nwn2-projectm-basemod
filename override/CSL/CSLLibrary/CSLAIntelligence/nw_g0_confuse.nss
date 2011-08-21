//::///////////////////////////////////////////////
//:: Confusion Heartbeat Support Script
//:: NW_G0_Confuse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This heartbeat script runs on any creature
    that has been hit with the confusion effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
    // TK removed SCSendForHelp
//    SCSendForHelp();
	SCInitializeCreatureInformation(OBJECT_SELF);

    //Make sure the creature is commandable for the round
    SetCommandable(TRUE);
    //Clear all previous actions.
    ClearAllActions(TRUE);
    int nRandom = d10();
    //Roll a random int to determine this rounds effects
    if(nRandom  == 1)
    {
        ActionRandomWalk();
    }
    else if (nRandom >= 2 && nRandom  <= 5)
    {
        ClearAllActions(TRUE);
    }
    else if(nRandom >= 6 && nRandom <= 10)
    {
        //ActionAttack(GetNearestObject(OBJECT_TYPE_CREATURE));
        
        object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
		ActionAttack(oTarget); 
    }
    SetCommandable(FALSE);
}