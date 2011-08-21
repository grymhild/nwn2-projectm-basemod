//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: gb_assoc_combat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()));

   	SCHenchResetCombatRound();	

	if (!CSLGetAssociateState(CSL_ASC_MODE_PUPPET) && !SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS) && !SCHenchCheckEventClearAllActions(TRUE))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " end combat round combat round");
        SCHenchDetermineCombatRound();
    }
    if(SCGetSpawnInCondition(CSL_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }

    // Check if concentration is required to maintain this creature
    CSLDoBreakConcentrationCheck();
}