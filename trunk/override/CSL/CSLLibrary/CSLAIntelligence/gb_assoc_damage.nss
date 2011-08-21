//::///////////////////////////////////////////////
//:: Associate: On Damaged
//:: gb_assoc_damage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
    if(!CSLGetAssociateState(CSL_ASC_IS_BUSY))
    {
        // Auldar: Make a check for taunting before running Ondamaged.
        if(!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && (GetCurrentAction() != ACTION_FOLLOW)
            && (GetCurrentAction() != ACTION_TAUNT))
        {
            if ((GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_WAIT) &&
                (SCGetPercentageHPLoss(OBJECT_SELF) < 30))
            {
                // force heal
                SCHenchDetermineCombatRound(OBJECT_INVALID, TRUE);
            }
            else
            {
                // Auldar: Use combat checks from OnPerceive.
                if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
                   !GetIsObjectValid(GetAttackTarget()) &&
                   !GetIsObjectValid(GetAttemptedSpellTarget()))
                {
                    if(GetIsObjectValid(GetLastHostileActor()))
                    {
						SCHenchDetermineCombatRound(GetLastDamager());
                    }
                }
            }
        }
    }
    if(SCGetSpawnInCondition(CSL_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}