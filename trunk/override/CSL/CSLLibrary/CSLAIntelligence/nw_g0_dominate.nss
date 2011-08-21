//::///////////////////////////////////////////////
//:: Dominate Heartbeat
//:: NW_G0_Dominate
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the heartbeat that runs on a target
    who is dominated by an NPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

//#include "ginc_group"

#include "_SCInclude_AI"
#include "_SCInclude_Group"

void main()
{
    // TK removed SCSendForHelp
//    SCSendForHelp();
    SCInitializeCreatureInformation(OBJECT_SELF);
	object oCharacter = OBJECT_SELF; 
	
    //Allow commands to be given to the target
    SetCommandable(TRUE);
    //ClearAllActions();

    int bValid, nCnt = 1;
    float fDistance;
    //Get the nearest creature to the creature
    object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE,oCharacter);
    while (bValid == FALSE && fDistance < 20.0)
    {
        fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
        if(GetIsEnemy(oTarget,oCharacter))
        {
            bValid = TRUE;
            //Attack if they are enemy of the target's new faction
            ActionAttack(oTarget);
        }
        else
        {
            //If not an enemy iterate and find the next target
            nCnt++;
            oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCharacter, nCnt);
        }
    }
    //Disable the ability to give commands
    SetCommandable(FALSE);
    // BMA-OEI 7/04/06 - Check if in group and using group campaign flag
    if ( GetGlobalInt(CAMPAIGN_SWITCH_FORCE_KILL_DOMINATED_GROUP) == TRUE )
    {
        string sGroupName = SCGetGroupName( oCharacter );
        if ( sGroupName != "" )
        {
            if ( SCGetIsGroupDominated(sGroupName) == TRUE )
            {
                CSLRemoveEffectByType( oCharacter, EFFECT_TYPE_DOMINATED );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath(), oCharacter );
            }
        }
    }
}