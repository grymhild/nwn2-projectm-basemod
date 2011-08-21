//::///////////////////////////////////////////////
//:: Default: On Disturbed
//:: NW_C2_DEFAULT8
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
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
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default8 Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
   
   object oCharacter = OBJECT_SELF; 
    giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
    
    object oTarget = GetLastDisturbed();

    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        if(GetIsObjectValid(oTarget))
        {
			if (GetIsEnemy(oTarget,oCharacter) || SCGetHenchOption(HENCH_OPTION_ENABLE_INVENTORY_DISTRURBED))
			{
				SCHenchDetermineCombatRound(oTarget);
			}
        }
    }
    if(SCGetSpawnInCondition(CSL_FLAG_DISTURBED_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_DISTURBED));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default8 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}