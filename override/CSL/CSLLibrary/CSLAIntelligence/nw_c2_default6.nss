//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
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
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default6 Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC() ); }
    
    giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
    object oCharacter = OBJECT_SELF;
    int iCurrentDamage = GetTotalDamageDealt();
    int iFocused = SCGetIsFocused(oCharacter);
	
	// I've been damaged so no longer partially focused
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
        // We're supposed to run away, do nothing
    }
    else if (SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS))
    {
        // don't do anything?
    }
    else
    {
        object oDamager = GetLastDamager();
        if (!GetIsObjectValid(oDamager))
        {
        // don't do anything, we don't have a valid damager
        }
        else if ( GetObjectType( oDamager ) == OBJECT_TYPE_AREA_OF_EFFECT )
        {
        	int iAOEDamageTimes = CSLIncrementLocalInt_Timed( oCharacter, "CSL_AOEDAMAGED", 19.0f, 1);
        	if ( iAOEDamageTimes > 2 || iCurrentDamage > GetMaxHitPoints(oCharacter)/6  ) // adjust this to make sense
        	{ 
				int nAttempts = CSLIncrementLocalInt_Timed( oCharacter, "CSL_MOVE_AWAY_ATTEMPTS", 6.0f, 1);
				if ( nAttempts < 1 )
				{
					ClearAllActions();
					ActionMoveAwayFromObject(oDamager, TRUE, 10.0);
					if ( !CSLGetCombatCondition(CSL_COMBAT_FLAG_RANGED,oCharacter) )
					{
						CSLSetCombatCondition( CSL_COMBAT_FLAG_RANGED, TRUE, oCharacter );
						DelayCommand( 60.0f, CSLSetCombatCondition( CSL_COMBAT_FLAG_RANGED, FALSE, oCharacter ));
					}
				}
			}
        	// don't do anything, we don't have a valid damager
        }
        else if (!SCGetIsFighting(oCharacter))
        {
            if ((GetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_WAIT) &&
                (SCGetPercentageHPLoss(oCharacter) < 30))
            {
                // force heal
                SCHenchDetermineCombatRound(oCharacter, TRUE);
            }
            else if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
				//    Jug_Debug(GetName(oCharacter) + " responding to damage");
                if (SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
                {
                    SCHenchDetermineSpecialBehavior(oDamager);
                }
                else
                {
                    // from hall of advanced training
                    if(!GetObjectSeen(oDamager) && GetArea(oCharacter) == GetArea(oDamager))
                    {
						// We don't see our attacker, go find them
						ActionMoveToLocation(GetLocation(oDamager), TRUE);
						ActionDoCommand(SCHenchDetermineCombatRound());
					}
					else
					{
						SCHenchDetermineCombatRound();
					}
                    
                    
                    //SCHenchDetermineCombatRound(oDamager);
                }
            }
        }
        else
        {
            // We are fighting already -- consider switching if we've been
            // attacked by a more powerful enemy
            object oTarget = GetAttackTarget();
            if (!GetIsObjectValid(oTarget))
            {
                oTarget = GetAttemptedAttackTarget();
            }
            if (!GetIsObjectValid(oTarget))
            {
                oTarget = GetAttemptedSpellTarget();
			}
            // If our target isn't valid
            // or our damager has just dealt us 25% or more
            //    of our hp in damager
            // or our damager is more than 2HD more powerful than our target
            // switch to attack the damager.
            if (!GetIsObjectValid(oTarget) || ( oTarget != oDamager &&  (  GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4) || (GetHitDice(oDamager) - 2) > GetHitDice(oTarget) ) ) )
            {
                // Switch targets
                SCHenchDetermineCombatRound(oDamager);
            }
        }
    }
    // need to review this, feature from hall of advanced training 3.3 by mithrates
    if ( GetLocalInt(oCharacter, "SecondSpell") && !GetLocalInt(oCharacter, "Interrupted") )
	{
		if ( GetIsSkillSuccessful(oCharacter, SKILL_CONCENTRATION, GetTotalDamageDealt()+GetLocalInt(oCharacter, "SpellTwoLevel") ) )
		{
			SetLocalInt(oCharacter, "Interrupted",1);
		}
	}
	// need to review this
	//ExecuteScript("update_conditions", OBJECT_SELF);
    if(SCGetSpawnInCondition(CSL_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_DAMAGED));
    }
    
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_default6 End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}