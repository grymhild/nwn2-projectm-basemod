//::///////////////////////////////////////////////
//:: Default On Blocked
//:: NW_C2_DEFAULTE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This will cause blocked creatures to open
    or smash down doors depending on int and
    str.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"
#include "_SCInclude_Doors"

void main()
{
   if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_defaulte Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
    object oDoor = GetBlockingDoor();
	
	
//    Jug_Debug("******" + GetName(OBJECT_SELF) + " is blocked by " + GetName(oDoor));
	
    if (GetObjectType(oDoor) == OBJECT_TYPE_CREATURE)
    {
        // * Increment number of times blocked
        /*SetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED", GetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED") + 1);
        if (GetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED") > 3)
        {
            SpeakString("Blocked by creature");
            SetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED",0);
            ClearAllActions();
            object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
            if (GetIsObjectValid(oEnemy) == TRUE)
            {
                ActionEquipMostDamagingRanged(oEnemy);
                ActionAttack(oEnemy);
            }
            return;
        }   */
        return;
    }
    
    giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
    
	// SCHandleBlockedDoor( GetBlockingDoor(), OBJECT_SELF );
    if (GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) < 5)
    {
        return; // too stupid to follow (out of sight, out of mind)
        // TODO add wisdom check?
    }

    int iAggPursue = GetLocalInt(OBJECT_SELF, "tkCombatRoundCount") || !GetLocalInt(OBJECT_SELF, "MonsterWander");
    if (!iAggPursue)
    {
        if (GetPlotFlag(oDoor))
        {
            return;
        }
        if (GetIsTrapped(oDoor))
        {
            return;
        }
    }
	
	int nInt = GetAbilityScore( OBJECT_SELF, ABILITY_INTELLIGENCE );
    int nStr = GetAbilityScore( OBJECT_SELF, ABILITY_STRENGTH );
    
    int nSel;
    if (iAggPursue)
    {
        nSel = 0xffff;
    }
    else
    {
        nSel = SCGetHenchOption(HENCH_OPTION_UNLOCK | HENCH_OPTION_OPEN);
    }
    
    
    if ( (HENCH_OPTION_UNLOCK & nSel) && SCIsArcaneLocked( oDoor ) )
	{
		if ( !SCAttemptKnockSpell( oDoor ) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && nStr >= 12 )
		{
			DoDoorAction(oDoor, DOOR_ACTION_BASH);
		}
	
    }
    else if((HENCH_OPTION_OPEN & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) &&  nInt >= 7 &&  SCGetCreatureUseItems(OBJECT_SELF))
    {
//	    Jug_Debug("******" + GetName(OBJECT_SELF) + " doing open" + GetName(oDoor) + " combat round + " + IntToString(GetLocalInt(OBJECT_SELF, "tkCombatRoundCount")));
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
        if (!iAggPursue)
        {
            SetLocalInt(OBJECT_SELF,"OpenedDoor", TRUE);
        }
    }
    else if ((HENCH_OPTION_UNLOCK & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_UNLOCK))
    {
        DoDoorAction(oDoor, DOOR_ACTION_UNLOCK);
    }
    else if ((HENCH_OPTION_UNLOCK & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH))
    {
//	    Jug_Debug("******" + GetName(OBJECT_SELF) + " bash open" + GetName(oDoor) + " combat round + " + IntToString(GetLocalInt(OBJECT_SELF, "tkCombatRoundCount")));
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
		// don't give up, keep at it
		SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oDoor);
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_defaulte End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}