//::///////////////////////////////////////////////
//:: Default On Heartbeat
//:: NW_C2_DEFAULT1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "_SCInclude_AI"
#include "_HkSpell"

void main()
{
	object oCharacter = OBJECT_SELF;
	
	if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default1 Start "+GetName(oCharacter) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
	
	//The_Puppeteer 11-28-10  Checks to see if creatures flee.  Variables are described in sod_ai_i
	//**********************************************************************************************	
	//	SpeakString("Heartbeat!");  //Debugging lines  The_Puppeteer
	int iAIMasterFlag = CSLGetAIMasterFlag( oCharacter );
	if ( iAIMasterFlag & CSL_FLAG_BUSYMOVING ) // this is an override which makes the creature ignore things since they are working under a very strong orders to go somewhere
	{
		return;
	}
	else if ( iAIMasterFlag & CSL_FLAG_FLEE )
	{
		if ( GetLocalInt(oCharacter, "flee_spooked"))
		{
			// SpeakString("Have a heart and don't spook me!");  //Debugging lines  The_Puppeteer
			return;
		}
	}
	//End of The_Puppeteer's additions
	//*****************************************************************************************

	
	
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
	
	//  Jug_Debug(GetName(oCharacter) + " faction leader " + GetName(GetFactionLeader(oCharacter)));
	// * if not running normal or better AI then exit for performance reasons
	if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	//    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC, oCharacter, 1, CREATURE_TYPE_PERCEPTION,  PERCEPTION_HEARD)))
	//    {
	//      Jug_Debug("*****" + GetName(oCharacter) + " heartbeat action " + IntToString(GetCurrentAction()));
	//    }

    if (SCGetSpawnInCondition(CSL_FLAG_FAST_BUFF_ENEMY))
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCharacter, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
		if(GetIsObjectValid(oPC) && GetDistanceToObject(oPC) <= 40.0 )
		{
			if( !SCGetIsFighting(oCharacter) )
			{
        
				HkAutoBuff( oCharacter, oCharacter, TRUE, 99, TRUE, FALSE );
				
					SCSetSpawnInCondition(CSL_FLAG_FAST_BUFF_ENEMY, FALSE);
					// TODO evaluate continue with combat
					return;
				
			
			}
        
        }
    }

	if (SCHenchCheckHeartbeatCombat())
	{
	    SCHenchResetCombatRound();
	}
    if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SLEEP))
    {
        if(SCGetSpawnInCondition(CSL_FLAG_SLEEPING_AT_NIGHT))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCharacter);
            }
        }
    }
    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if (SCGetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) || !GetIsObjectValid(SCGetNearestSeenOrHeardEnemyNotDead(SCGetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING))))
    {
        if (GetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN))
        {
            // continue to move to target
	        if (SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
	        {
	            SCHenchDetermineSpecialBehavior();
	        }
			else
			{
	        	SCHenchDetermineCombatRound();
			}
        }
        else
        {
			if (!GetIsObjectValid(SCGetNearestSeenOrHeardEnemyNotDead(FALSE)))
			{
	        	SCCleanCombatVars();
	            SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, FALSE);
	            if (SCDoStealthAndWander())
	            {
	                // nothing to do here
	            }
	            // sometimes waypoints are not initialized
	            else if (SCGetWalkCondition(NW_WALK_FLAG_CONSTANT))
	            {
	                SCWalkWayPoints();
	            }
	            else
	            {
	                if(!IsInConversation(oCharacter))
	                {
	                    if(SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS) || SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS_AVIAN))
	                    {
	                        SCPlayMobileAmbientAnimations();
	                    }
	                    else if(SCGetSpawnInCondition(CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
	                    {
	                        SCPlayImmobileAmbientAnimations();
	                    }
	                }
	            }
			}
        }
    }
    else if (SCGetUseHeartbeatDetect())
    {
//		Jug_Debug(GetName(oCharacter) + " starting combat round in heartbeat");
//		Jug_Debug("*****" + GetName(oCharacter) + " heartbeat action " + IntToString(GetCurrentAction()));
        if (SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
        {
            SCHenchDetermineSpecialBehavior();
        }
		else
		{
        	SCHenchDetermineCombatRound();
		}
    }
	else
	{
		SCCleanCombatVars();
	}
    if (SCGetSpawnInCondition(CSL_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_HEARTBEAT));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default1 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}