//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
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
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default5 Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC() ); }
    
    giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
    
    object oCharacter = OBJECT_SELF;
    
    //The_Puppeteer 11-28-10  Checks to see if creatures flee.  Variables are described in sod_ai_i
	//**********************************************************************************************
	int iAIMasterFlag = CSLGetAIMasterFlag( oCharacter );
	if ( iAIMasterFlag & CSL_FLAG_FLEE )
	{
		if (! GetLocalInt(oCharacter, "flee_attacked") )
		{
			SetLocalInt(oCharacter, "flee_attacked", TRUE);
		}
		return;
	}
	else if ( iAIMasterFlag & CSL_FLAG_BUSYMOVING ) // this is an override which makes the creature ignore things since they are working under a very strong orders to go somewhere
	{
		return;
	}
	//End of The_Puppeteer's additions
	//*************************************************************************************************

    int iFocused = SCGetIsFocused(oCharacter);

	// I've been attacked so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
	{
		SetLocalInt(oCharacter, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}
    if (iFocused == FOCUSED_FULL)
	{
        // remain focused
    }
	else if(SCGetFleeToExit())
    {
        SCActivateFleeToExit();
    }
    else if (SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS))
    {
        // We give an attacker one warning before we attack
        // This is not fully implemented yet
        SCSetSpawnInCondition(CSL_FLAG_SET_WARNINGS, FALSE);

        //Put a check in to see if this attacker was the last attacker
        //Possibly change the GetNPCWarning function to make the check
    }
    else if(!SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS))
    {
        object oAttacker = GetLastAttacker();

        if (!GetIsObjectValid(oAttacker))
        {
            // Don't do anything, invalid attacker

        }
        else if (!SCGetIsFighting(oCharacter))
        {
            if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
            {
                if(GetArea(GetLastAttacker()) == GetArea(oCharacter))
                {
					SCCheckRemoveStealth();
                }
                SCSetSummonHelpIfAttacked();
				if (SCGetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
				{
                	SCHenchDetermineSpecialBehavior(GetLastAttacker());
				}
            }
            else if(GetArea(GetLastAttacker()) == GetArea(oCharacter))
            {
				SCCheckRemoveStealth();
                SCSetSummonHelpIfAttacked();
				if (SCGetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
				{
                	SCHenchDetermineCombatRound(GetLastAttacker());
				}
            }
        }
    }
    if(SCGetSpawnInCondition(CSL_FLAG_ATTACK_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_ATTACKED));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default5 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}