//::///////////////////////////////////////////////
//:: Associate On Attacked
//:: gb_assoc_attack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"

void main()
{
    if(!CSLGetAssociateState(CSL_ASC_IS_BUSY))
    {
        SetCommandable(TRUE);
        // Auldar: Don't want anything to interrupt a Taunt attempt.
		if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
        {
			SCCheckRemoveStealth();
            // Auldar: Use checks from OnPerceive so we don't run DCR if we have a target.
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(GetIsObjectValid(GetLastAttacker()))
                {
// 		Jug_Debug(GetName(OBJECT_SELF) + " on attacked combat round");
					SCHenchDetermineCombatRound(GetLastAttacker());
                }
            }
            if(SCGetSpawnInCondition(EVENT_ATTACKED))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
            }
        }
    }
}