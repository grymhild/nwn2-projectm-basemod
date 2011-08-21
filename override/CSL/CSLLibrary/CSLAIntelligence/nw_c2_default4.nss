//::///////////////////////////////////////////////
//:: SCSetListeningPatterns
//:: NW_C2_DEFAULT4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"

void main()
{
    if (DEBUGGING >= 10) { CSLDebug( "nw_c2_default4 Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
    
    object oCharacter = OBJECT_SELF;
    // * if petrified, jump out
    if( CSLGetHasEffectType(oCharacter,EFFECT_TYPE_PETRIFY) )
    {
        return;
    }

    // * If dead, exit directly.
    if (GetIsDead(oCharacter))
    {
        return;
    }
	
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
	
    // notify walkwaypoints that we've been stopped and need to restart.
    SetLocalInt(oCharacter, VAR_KICKSTART_REPEAT_COUNT, 100);

    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oIntruder;
    int iFocused = SCGetIsFocused(oCharacter);

    if (nMatch == -1 && GetCommandable(oCharacter))
    {
        if (GetCommandable(oCharacter))
        {
            ClearAllActions();
			// hack to detect SoZ
			if (GetStringLength(GetGlobalString("co_beluethHangOut")) > 1)
			{
            	BeginConversation("", OBJECT_INVALID, TRUE);
			}
			else
			{
            	BeginConversation();
			}
        }
        else
        // * July 31 2004
        // * If only charmed then allow conversation
        // * so you can have a better chance of convincing
        // * people of lowering prices
        if( CSLGetHasEffectType(oCharacter,EFFECT_TYPE_CHARMED) )
        {
            ClearAllActions();
			// hack to detect SoZ
			if (GetStringLength(GetGlobalString("co_beluethHangOut")) > 1)
			{
            	BeginConversation("", OBJECT_INVALID, TRUE);
			}
			else
			{
            	BeginConversation();
			}
        }

    }
    else if(nMatch != -1 && GetIsObjectValid(oShouter) && !GetIsPC(oShouter) &&
		GetIsFriend(oShouter) && (iFocused <= FOCUSED_STANDARD) &&
		SCGetIsValidRetaliationTarget(oIntruder))
    {
        if(nMatch == 4)
        {
            oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
        }
        else if (nMatch == 5 || nMatch == 1)
        {
            oIntruder = GetLocalObject(oShouter, "LastTarget");
            if(!GetIsObjectValid(oIntruder))
            {
                oIntruder = GetLastHostileActor(oShouter);
                if(!GetIsObjectValid(oIntruder))
                {
                    oIntruder = GetAttemptedAttackTarget();
                    if(!GetIsObjectValid(oIntruder))
                    {
                        oIntruder = GetAttemptedSpellTarget();
                        if(!GetIsObjectValid(oIntruder))
                        {
                            oIntruder = OBJECT_INVALID;
                        }
                    }
                }
            }
        }
//		Jug_Debug(GetName(oCharacter) + " respond to shout " + GetName(oShouter) + " match " + IntToString(nMatch) + " intruder " + GetName(oIntruder));
		if (GetObjectSeen(oShouter) || LineOfSightObject(oShouter, oCharacter) ||
			((GetDistanceToObject(oShouter) < 10.0) && !SCHenchEnemyOnOtherSideOfDoor(oShouter)))
		{
//			Jug_Debug(GetName(oCharacter) + " really respond to shout");
        	SCHenchMonRespondToShout(oShouter, nMatch, oIntruder);
		}
    }

    if(SCGetSpawnInCondition(CSL_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_DIALOGUE));
    }
    if (DEBUGGING >= 10) { CSLDebug( "nw_c2_default4 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }

}