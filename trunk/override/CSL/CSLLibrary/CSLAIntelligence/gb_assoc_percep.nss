//::///////////////////////////////////////////////
//:: Associate: On Perceive
//:: gb_assoc_percep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
    
    object oHenchman = OBJECT_SELF;
    if(SCGetSpawnInCondition(CSL_FLAG_SPECIAL_COMBAT_CONVERSATION))
    {
        ActionStartConversation(oHenchman);
    }
    object oLastPerceived = GetLastPerceived();

//    if (GetIsEnemy(oLastPerceived))
//    {
//        Jug_Debug(GetName(oHenchman) + " perceived " + GetName(oLastPerceived) + " seen " + IntToString(GetLastPerceptionSeen()) + " heard " + IntToString(GetLastPerceptionHeard()) + " van " + IntToString(GetLastPerceptionVanished()) + " ina " + IntToString(GetLastPerceptionInaudible()) + " action " + IntToString(GetCurrentAction()));
//    }
        // TODO HotU added check for stealth
	if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
    {
        //If the last perception event was hearing based or if someone vanished then go to search mode
        if (GetLastPerceptionVanished() || GetLastPerceptionInaudible())
        {
            if (!GetObjectSeen(oLastPerceived) && !GetObjectHeard(oLastPerceived) &&
                !GetIsDead(oLastPerceived, TRUE) && GetArea(oLastPerceived) == GetArea(oHenchman) &&
                GetIsEnemy(oLastPerceived,oHenchman) && !SCHenchEnemyOnOtherSideOfDoor(oLastPerceived))
            {
                // add check if target - prevents creature from following the target
                // due to ActionAttack without actually perceiving them
                if (GetLocalObject(oHenchman, "LastTarget") == oLastPerceived)
                {
//      Jug_Debug(GetName(oHenchman) + " perceive lost determine combat round");
                    ClearAllActions();
                    DeleteLocalObject(oHenchman, "LastTarget");
                    SCHenchDetermineCombatRound(oLastPerceived, TRUE);
                }
            }
        }
        else if (GetLastPerceptionSeen())
        {
            //Do not bother checking the last target seen if already fighting
                // PAUS: No, actually please do check
                // Auldar: Use these more accurate checks for being in combat. ie uncomment them.
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                //Check if the last perceived creature was actually seen
                if(GetIsEnemy(oLastPerceived,oHenchman))
                {
                    if (!GetIsDead(oLastPerceived, TRUE))
                    {
//                     Jug_Debug(GetName(oHenchman) + " perceived " + GetName(oLastPerceived) + " seen " + IntToString(GetLastPerceptionSeen()) + " heard " + IntToString(GetLastPerceptionHeard()) + " van " + IntToString(GetLastPerceptionVanished()) + " ina " + IntToString(GetLastPerceptionInaudible()) + " action " + IntToString(GetCurrentAction()));
						SetFacingPoint(GetPosition(oLastPerceived));
						SCHenchDetermineCombatRound(oLastPerceived);
                    }
                }
                //Linked up to the special conversation check to initiate a special one-off conversation
                //to get the PCs attention
                else if (SCGetSpawnInCondition(CSL_FLAG_SPECIAL_CONVERSATION) && GetIsPC(oLastPerceived))
                {
                    ActionStartConversation(oHenchman);
                }
            }
        }
    }
    if (SCGetSpawnInCondition(CSL_FLAG_PERCIEVE_EVENT))
    {
        SignalEvent(oHenchman, EventUserDefined(EVENT_PERCEIVE));
    }
}