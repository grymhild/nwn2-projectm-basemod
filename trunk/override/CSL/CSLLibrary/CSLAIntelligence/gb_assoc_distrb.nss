//::///////////////////////////////////////////////
//:: Henchmen: On Disturbed
//:: gb_assoc_distrb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determine Combat Round on disturbed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//::///////////////////////////////////////////

// * Make me hostile the faction of my last attacker (TEMP)
//  AdjustReputation(OBJECT_SELF,GetFaction(GetLastAttacker()),-100);
// * Determined Combat Round

#include "_SCInclude_AI"


void main()
{
    object oTarget = GetLastDisturbed();

    if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        if (GetIsObjectValid(oTarget))
        {
 //     Jug_Debug(GetName(OBJECT_SELF) + " disturbed combat round");
            SCHenchDetermineCombatRound(oTarget);
        }
    }
    if(SCGetSpawnInCondition(CSL_FLAG_DISTURBED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DISTURBED));
    }
}