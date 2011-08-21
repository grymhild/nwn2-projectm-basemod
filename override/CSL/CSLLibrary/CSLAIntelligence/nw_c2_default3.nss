//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
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
	if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default3 Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
   	SCHenchResetCombatRound();
	
	
	
	
	
	object oCharacter = OBJECT_SELF;
	
	
	//The_Puppeteer 11-28-10  Checks to see if creatures flee.  Variables are described in sod_ai_i
	//**********************************************************************************************
	int iAIMasterFlag = CSLGetAIMasterFlag( oCharacter );
	if ( iAIMasterFlag & CSL_FLAG_FLEE )
	{
		if ( GetLocalInt(oCharacter, "flee_spooked") )
		{
			// SpeakString("Let's stop fighting!");  //Debugging lines  The_Puppeteer
			return;
		}
	}
	else if ( iAIMasterFlag & CSL_FLAG_BUSYMOVING ) // this is an override which makes the creature ignore things since they are working under a very strong orders to go somewhere
	{
		return;
	}
	//End of The_Puppeteer's additions
	//************************************************************************************************

	
	
    int iFocused = SCGetIsFocused(oCharacter);
 
    if (iFocused <= FOCUSED_STANDARD)
    {
		if (!SCHenchCheckEventClearAllActions(TRUE))
		{
		    if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
		    {
		        SCHenchDetermineSpecialBehavior();
		    }
		    else if(!SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS))
		    {
		        SCHenchDetermineCombatRound();
		    }
		}
	}
    if(SCGetSpawnInCondition(CSL_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default3 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}