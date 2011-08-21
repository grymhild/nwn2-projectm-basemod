//::///////////////////////////////////////////////
//:: Default On Perceive
//:: NW_C2_DEFAULT2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the perceived target is an
    enemy and if so fires the Determine Combat
    Round function
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
	object oPerceiver = OBJECT_SELF;
	object oLastPerceived = GetLastPerceived();
	
	object oCharacter = OBJECT_SELF;
	
	if ( GetIsEnemy(oLastPerceived,oCharacter) )
	{
		DelayCommand( 6.0f, CSLDecrementLocalInt_Void(oPerceiver, "CSL_PERC_HOSTILE", 1, TRUE ) );
		int iTotalPerceptions = CSLIncrementLocalInt(oPerceiver, "CSL_PERC_HOSTILE", 1);
		if ( iTotalPerceptions > 3 ) // this throttles perceptions
		{
			return;
		}
	}
	else
	{
		DelayCommand( 6.0f, CSLDecrementLocalInt_Void(oPerceiver, "CSL_PERC_FRIENDLY", 1, TRUE ) );
		int iTotalPerceptions = CSLIncrementLocalInt(oPerceiver, "CSL_PERC_FRIENDLY", 1);
		if ( iTotalPerceptions > 1 )
		{
			return;
		}
	}
	
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
	
    
	// * if not running normal or better Ai then exit for performance reasons
	// * if not running normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

        // script hidden object shouldn't react (for cases where AI not turned off)
    if (GetScriptHidden(oPerceiver)) 
    {
    	return;
    }
    
    //The_Puppeteer 11-28-10  Checks to see if creatures flee.  Variables are described in sod_ai_i
	//*************************************************************************************************
	int iAIMasterFlag = CSLGetAIMasterFlag( oPerceiver );
	if ( iAIMasterFlag & CSL_FLAG_BUSYMOVING ) // this is an override which makes the creature ignore things since they are working under a very strong orders to go somewhere
	{
		return;
	}
	else if ( iAIMasterFlag & CSL_FLAG_FLEE )
	{
		if ( !GetLocalInt(oPerceiver, "flee_spooked") )
		{
			// SpeakString("I'm a coward!");  //Debugging lines  The_Puppeteer
			SOD_FleeAllHostiles(oPerceiver);
		}
		return;
	}
	else if( iAIMasterFlag & CSL_FLAG_ESCAPE_RETURN )
    {
        return;
    }
    
	//End of The_Puppeteer's modifications
	//*****************************************************************************************************
	
	
	if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default2 Start "+GetName(oCharacter) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
	
	
    int iFocused = SCGetIsFocused(oCharacter);

    
    int bSeen = GetLastPerceptionSeen();
    if (iFocused <= FOCUSED_STANDARD)
    {
        //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
        //to say something while he is already engaged in combat.
        if(SCGetSpawnInCondition(CSL_FLAG_SPECIAL_COMBAT_CONVERSATION) && GetIsPC(oLastPerceived) && bSeen)
        {
            SpeakOneLinerConversation();
        }

        //If the last perception event was hearing based or if someone vanished then go to search mode
        if (GetLastPerceptionVanished() || GetLastPerceptionInaudible())
        {
//			Jug_Debug(GetName(oPerceiver) + " lost perceived " + GetName(oLastPerceived) + " by "  + (GetLastPerceptionVanished() ? "vanishing" : "inaudable") + ", seen " + IntToString(GetObjectSeen(oLastPerceived)) + " heard " + IntToString(GetObjectHeard(oLastPerceived)));
            if (!GetObjectSeen(oLastPerceived) && !GetObjectHeard(oLastPerceived) &&
                !GetIsDead(oLastPerceived, TRUE) && GetArea(oLastPerceived) == GetArea(oPerceiver) &&
                GetIsEnemy(oLastPerceived,oCharacter) && (!HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER || SCGetIsPCGroup(oLastPerceived)))
            {
//				Jug_Debug(GetName(oPerceiver) + " move to last heard or seen");
                if ((GetLastPerceptionVanished() || GetLocalInt(oPerceiver, "tkCombatRoundCount") ||
					!SCHenchEnemyOnOtherSideOfDoor(oLastPerceived)) && !SCGetIsDisabled(oPerceiver))
                {
//					Jug_Debug(GetName(oPerceiver) + " setting enemy location");
                    SCSetEnemyLocation(oLastPerceived);
                }
                // add check if target - prevents creature from following the target
                // due to ActionAttack without actually perceiving them
                if (GetLocalObject(oPerceiver, "LastTarget") == oLastPerceived)
                {
//					Jug_Debug(GetName(oPerceiver) + " calling det combat round, doing clearallactions");
                    ClearAllActions();
                    DeleteLocalObject(oPerceiver, "LastTarget");
                    SCHenchDetermineCombatRound(oLastPerceived, TRUE);
                }
            }
        }
        //Do not bother checking the last target seen if already fighting
        else if (bSeen && !GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
        {
//			Jug_Debug(GetName(oPerceiver) + " checking perceived " + GetName(oLastPerceived) + " " + IntToString(GetObjectSeen(oLastPerceived)));
            // note : hearing is disabled and is only done in heartbeat. Calling GetIsEnemy with hearing causes
            // a noticeable lag to machine
            if (SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
            {
                SCHenchDetermineSpecialBehavior();
            }
            else if (GetIsEnemy(oLastPerceived,oCharacter) && !GetIsDead(oLastPerceived, TRUE))
            {
                if(!CSLGetHasEffectType(oPerceiver,EFFECT_TYPE_SLEEP))
                {
//					Jug_Debug(GetName(oPerceiver) + " starting combat round in percep");
                    SetFacingPoint(GetPosition(oLastPerceived));
                    SCHenchDetermineCombatRound(oLastPerceived);
                }
            }
            //Linked up to the special conversation check to initiate a special one-off conversation
            //to get the PCs attention
            else if (bSeen && SCGetSpawnInCondition(CSL_FLAG_SPECIAL_CONVERSATION) && GetIsPC(oLastPerceived))
            {
                ActionStartConversation(oPerceiver);
            }
            // activate ambient animations or walk waypoints if appropriate
            if (!IsInConversation(oPerceiver))
            {
                if (GetIsPC(oLastPerceived) &&
                   (SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS)
                    || SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS_AVIAN)
                    || SCGetSpawnInCondition(CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS)
                    || GetIsEncounterCreature()))
                {
                    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE);
                }
            }
        }
        else if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL) && bSeen)
        {
            SCHenchDetermineSpecialBehavior();
        }
/*		else if (GetLastPerceptionHeard())
		{
			// heard me
			Jug_Debug(GetName(oPerceiver) + " checking perceived heard " + GetName(oLastPerceived) + " " + IntToString(GetObjectHeard(oLastPerceived)));
		} */
    }
    if(SCGetSpawnInCondition(CSL_FLAG_PERCIEVE_EVENT) && bSeen)
    {
        SignalEvent(oPerceiver, EventUserDefined(EVENT_PERCEIVE));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default2 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}