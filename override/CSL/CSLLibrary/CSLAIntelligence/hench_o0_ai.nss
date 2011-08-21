/*

    Companion and Monster AI

    This is the main AI script called by SCHenchDetermineCombatRound

*/

#include "_SCInclude_AI"
#include "_SCInclude_Summon"


// Threshold challenge rating for buff spells
const float PAUSANIAS_CHALLENGE_THRESHOLD = -1.0;
const float PAUSANIAS_FAMILIAR_THRESHOLD = -2.0;
const float PAUSANIAS_DISTANCE_THRESHOLD_NEAR = 3.5;
const float PAUSANIAS_DISTANCE_THRESHOLD_MED = 5.0;
const float PAUSANIAS_DISTANCE_THRESHOLD_FAR = 6.5;


int CheckLastAttacker(object oCurObject)
{
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai CheckLastAttacker start", GetFirstPC() ); }
	
	object oLastAttacker = GetLastAttacker(oCurObject);
	if (!GetIsObjectValid(oLastAttacker) || !GetFactionEqual(oLastAttacker))
	{
		return FALSE;
	}
	int assocType = GetAssociateType(oLastAttacker);
	return assocType != ASSOCIATE_TYPE_SUMMONED && assocType != ASSOCIATE_TYPE_DOMINATED;
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai CheckLastAttacker end", GetFirstPC() ); }
}

int giTotalScriptsRunning;

void main()
{
	//igDebugLoopCounter = 1;
	//igLastDebugLoopCounter = 1;
	
	object oCharacter = OBJECT_SELF;
	
	//DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "hench_o0_ai Start "+GetName(oCharacter) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
	
	////DEBUGGING// if (DEBUGGING == 8 && d20() > 18 ) { DEBUGGING = 10; } // this keeps it from always running if it's an 11
	////DEBUGGING// if (DEBUGGING == 9 && d20() > 19 ) { DEBUGGING = 10; } // this keeps it from always running if it's an 11
	//igDebugLoopCounter = 1;
	
	
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
	
	
	//	Jug_Debug(GetName(oCharacter) + " starting det combat action " + IntToString(GetCurrentAction()));
	/*  if (GetIsObjectValid(GetMaster()))
    {
        SpawnScriptDebugger();
    } */
	SCHenchInitiailizePersistentSpellInfo();
	
    object oIntruder = GetLocalObject(oCharacter, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    int bForce = GetLocalInt(oCharacter, HENCH_AI_SCRIPT_FORCE);
    SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_ALREADY_RUN);

    SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_UNKNOWN);

        // destroy self if pseudo summons and master not valid, not currently enabled
 /*   if (GetLocalInt(oCharacter, sHenchPseudoSummon) && !GetIsObjectValid(GetMaster()))
    {
        DestroyObject(oCharacter, 0.1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oCharacter));
        return;
    } */
    
    if ( GetIsInCombat(oCharacter) )
    {
    	gICheckCreatureInfoStaleTime = 5; // maximum cache time in seconds for effect information, was 3, bumped up to 5 so it's not quite as often, don't need more than once a round
    }
    else
    {
    	gICheckCreatureInfoStaleTime = 60;
    }
    
    SCInitializeCreatureInformation(oCharacter);

    //DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
    if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
    {
        return;
    }
    
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCGetHasPlayerQueuedAction", GetFirstPC() ); } //
    //DBR 9/12/06 - If there are player-queued action on me, return.
    if (SCGetHasPlayerQueuedAction(oCharacter))
    {
        return;
    }

    // prevent running script if PC controlled (delay commands cause call back)
    if (GetIsPC(oCharacter))
    {
        return;
    }

	//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCHenchCheckEventClearAllActions", GetFirstPC() ); } ////	Jug_Debug(GetName(oCharacter) + " starting det combat int = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));
    if (SCHenchCheckEventClearAllActions(FALSE))
    {
        return;
    }
    
    
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCHenchGetDefendee", GetFirstPC() ); } ////	Jug_Debug(GetName(oCharacter) + " starting det combat int  = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

    object oMaster = SCHenchGetDefendee();
	
	
	
	// this does round to round checks to see if a summoned monsters master is no longer protected
	// this allows heartbeat checks for summons inside the regular AI
	// this does round to round checks to see if a summoned monsters master is no longer protected
	if ( GetLocalInt( oCharacter, "SCSummon" ) )
	{
		SCSummonHeartbeatControl(oCharacter);
	}
	
	    // MODIFIED FEBRUARY 13 2003
    // The associate will not engage in battle if in Stand Ground mode unless
    // he takes damage
    if (CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND))
	{ 
		if (GetIsObjectValid(GetFactionLeader(oCharacter)))
		{
			if (!GetIsObjectValid(GetLastHostileActor()))
			{
        		return;
			}
		}
		else
		{
			CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
		}
	}
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running iAmMonster", GetFirstPC() ); } //
    int iAmMonster = !GetIsObjectValid(GetFactionLeader(oCharacter));
    int iHaveMaster = !iAmMonster && GetIsObjectValid(oMaster);
    int iAmHenchman,iAmFamiliar,iAmCompanion;
    if (iHaveMaster)
    {
        int nAssocType = GetAssociateType(oCharacter);
        iAmHenchman = (nAssocType == ASSOCIATE_TYPE_HENCHMAN) || GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter);		
        iAmFamiliar = nAssocType == ASSOCIATE_TYPE_FAMILIAR;
        iAmCompanion = nAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION;
    }

    if (!GetLocalInt(oCharacter, "HenchAutoIdentify"))
    {
        SetLocalInt(oCharacter, "HenchAutoIdentify", TRUE);
        if (iAmMonster || (GetAssociateType(oCharacter) != ASSOCIATE_TYPE_NONE))
        {
			// run initialization routines		
			ExecuteScript("hench_o0_initialize", oCharacter);
            SCHenchDetermineCombatRound(oIntruder, TRUE); // redo combat round
            return;
        }
    }

//	Jug_Debug(GetName(oCharacter) + " monster " + IntToString(iAmMonster) + " hench " + IntToString(iAmHenchman) + " master " + IntToString(iHaveMaster));

    if (!iAmMonster)
    {
        //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCHenchGetDefSettings", GetFirstPC() ); } //
        SCHenchGetDefSettings();
    }
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCInitializeBasicTargetInfo", GetFirstPC() ); } //
    SCInitializeBasicTargetInfo();

//	Jug_Debug(GetName(oCharacter) + " starting det combat 2 int = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

        // ----------------------------------------------------------------------------------------
    // 7/29/05 -- EPF, OEI
    // Due to the many, many plot-related cutscenes, we have decided to prevent anyone in the
    // PC faction from being attacked while they are in conversation.  Eventually, this should
    // probably include a check to see if the conversation itself is a plot cutscene, but for
    // now that flag is NYI.  Effectively, this is just a "pause" on combat until the
    // conversation ends.  Then the PC party is fair game.
    // 5/30/06 -- DBR, OEI
    // Flag is IN! SCGetIsInCutscene() now only checks for multiplayer flagged cutscenes.
    // ----------------------------------------------------------------------------------------
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCGetIsInCutscene", GetFirstPC() ); } //
    if (SCGetIsInCutscene(goClosestSeenOrHeardEnemy))
    {
//		//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running", GetFirstPC() ); } //Jug_Debug("SCAIDetermineCombatRound(): In cutscene.  Aborting function. " + GetName(goClosestSeenOrHeardEnemy));
        ClearAllActions(TRUE);
        ActionWait(3.f);
        ActionDoCommand(SCHenchDetermineCombatRound());
        return;
    }

    float fDistance = GetDistanceToObject(goClosestSeenOrHeardEnemy);

    if (iHaveMaster)
    {
            // BMA-OEI 9/13/06: Player Queued Target override
        object oPreferredTarget = SCGetPlayerQueuedTarget( oCharacter );
        if ( ( GetIsObjectValid( oPreferredTarget ) ) &&
             ( !GetIsDead( oPreferredTarget ) ) &&
             ( GetArea( oPreferredTarget ) == GetArea( oCharacter ) ) &&
             (GetObjectSeen(oPreferredTarget) || GetObjectHeard(oPreferredTarget)))
        {
            oIntruder = oPreferredTarget;
            bForce = TRUE;
        }

        if (iAmHenchman)
        {
            DeleteLocalInt(oCharacter, HENCH_AI_WEAPON);
        }
    }
	
	int iNegEffectsOnSelf = SCGetCreatureNegEffects(oCharacter);

    if (iNegEffectsOnSelf & HENCH_EFFECT_DISABLED)
    {
//		Jug_Debug(GetName(oCharacter) + " is disabled");
		int disablingEffects = iNegEffectsOnSelf & HENCH_EFFECT_DISABLED;
		if (iNegEffectsOnSelf == HENCH_EFFECT_TYPE_DAZED)
		{
        // TODO dazed can walk around - move away from enemies		
		}
        return;
    }
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running GetIsObjectValid oIntruder", GetFirstPC() ); } //
    if(!GetIsObjectValid(oIntruder) ||
        GetIsDead(oIntruder) ||
        GetLocalInt(oIntruder, "RunningAway") ||
        CSLGetAssociateState(CSL_ASC_MODE_DYING, oIntruder) ||
        GetPlotFlag(oIntruder) ||
        GetArea(oCharacter) != GetArea(oIntruder) ||
		(GetIsFriend(oIntruder) || GetFactionEqual(oIntruder)))
    {
//        Jug_Debug("@@@@@@@@@@@@@@" + GetName(oCharacter) + "removing unseen intruder to " + GetName(oIntruder));
        oIntruder = OBJECT_INVALID;
    }
    else if (!GetObjectSeen(oIntruder) && !GetObjectHeard(oIntruder))
    {
    // don't know where intruder is
//        Jug_Debug("@@@@@@@@@@@@@@" + GetName(oCharacter) + " setting unseen intruder to " + GetName(oIntruder));
        goNotHeardOrSeenEnemy = oIntruder;
        oIntruder = OBJECT_INVALID;
		bForce = FALSE;
    }
    else if (!bForce)
    {
        oIntruder = OBJECT_INVALID;
    }
	
    gbIAmStuck = GetLocalInt(oCharacter, HENCH_AI_BLOCKED);

    // Auldar: If we are still in Search mode when we start to attack the enemy, stop searching.
    if (GetIsObjectValid(goClosestSeenEnemy) && GetActionMode(oCharacter, ACTION_MODE_DETECT))
    {
        SetActionMode(oCharacter, ACTION_MODE_DETECT, FALSE);
    }

    if (iAmMonster)
    {
        // reset scout mode (no wandering enable pursue to open doors)
        DeleteLocalInt(oCharacter, "ScoutMode");
    }

    int iUseMagic = GetLocalInt(oCharacter, "X2_L_STOPCASTING") != 10;

    int iPosEffectsOnSelf = SCGetCreaturePosEffects(oCharacter);
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running gbAnyValidTarget", GetFirstPC() ); } //
    if (!gbAnyValidTarget && !GetIsObjectValid(goNotHeardOrSeenEnemy))
    {
//        Jug_Debug(GetName(oCharacter) + " checking heal count " + IntToString(GetLocalInt(oCharacter, "HenchCurHealCount")));
        if (GetLocalInt(oCharacter, "HenchCurHealCount"))
        {
            ActionDoCommand(ActionWait(2.5));
            ExecuteScript("hench_o0_heal", oCharacter);
            return;
        }
        if (SCHenchBashDoorCheck(iPosEffectsOnSelf & HENCH_EFFECT_TYPE_POLYMORPH))
        {
            return;
        }
    }
    if (GetLocalInt(oCharacter, "HenchCurHealCount"))
    {
        DeleteLocalInt(oCharacter, "HenchCurHealCount");
        DeleteLocalInt(oCharacter, "HenchHealType");
        DeleteLocalInt(oCharacter, "HenchHealState");
        DeleteLocalObject(oCharacter, "Henchman_Spell_Target");
    }

    // The following tweaks are implemented via Pausanias' dialog mods.
    // Herbivores should escape
   // special combat calls
    if (GetLevelByClass(CLASS_TYPE_COMMONER) > (GetHitDice(oCharacter) / 2))
    {
    // TODO later    HenchTalentHide(iEffectsOnSelf, gbMeleeAttackers);
        if (SCHenchTalentFlee(goClosestSeenOrHeardEnemy))
        {
            return;
        }
    }
    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_COWARDLY)
        && SCSpecialTacticsCowardly(goClosestSeenOrHeardEnemy))
    {
        return;
    }

    // NEXT: Do not attack if the master told you not to
    if (GetLocalInt(oCharacter, "DoNotAttack"))
    {
		if (iAmMonster)
		{
			DeleteLocalInt(oCharacter, "DoNotAttack");
		}
		else if (!SCGetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE))
		{
	        if ((d10() > 7) && gbAnyValidTarget && !GetLocalInt(oCharacter, "HenchShouldIAttackMessageGiven"))
	        {
	            if (iAmHenchman)
				{
					//	"Should I attack?"
	                SpeakStringByStrRef(230421);
				}
	            else if (iAmFamiliar)
				{
					//	"Let me know if I should attack."
	                SpeakStringByStrRef(230422);
				}
	            else if (iAmCompanion)
				{
					//	" is waiting for you to give the command to attack.]"
	                SpeakString("[" + GetName(oCharacter) + GetStringByStrRef(230423));
				}
	            else
				{
					//	" patiently awaits your command to attack.]"
	                SpeakString(GetStringByStrRef(230412) + GetName(oCharacter) + GetStringByStrRef(230424));
				}
				SetLocalInt(oCharacter, "HenchShouldIAttackMessageGiven", TRUE);
	        }
	        SCHenchFollowLeader();
	        return;
		}
    }

    if (!gbAnyValidTarget)
    {
        DeleteLocalObject(oCharacter, "LastTarget");

		//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCSetEnemyLocation", GetFirstPC() ); } ////		Jug_Debug(GetName(oCharacter) + " no valid target???");

        if (GetIsObjectValid(goNotHeardOrSeenEnemy))
        {
			//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCSetEnemyLocation", GetFirstPC() ); } ////			Jug_Debug(GetName(oCharacter) + " setting not heard or seen target");
           	SCSetEnemyLocation(goNotHeardOrSeenEnemy);
		}
		else if (GetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN))
		{		
			SCMoveToLastSeenOrHeard();
			return;		
		}
        else
        {
			//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCCleanCombatVars", GetFirstPC() ); } ////			Jug_Debug(GetName(oCharacter) + " clearing for exit");
            ClearAllActions(TRUE);
            SCCleanCombatVars();
            SCClearWeaponStates();
            if (iAmMonster)
            {
                SCHenchEquipDefaultWeapons();
                SCWalkWayPoints();
            }
            else
            {
                if (!SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
                {
                    if (SCGetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS))
                    {
                        SCUnequipWeapons();
                    }
                    else
                    {
                       SCHenchEquipDefaultWeapons();
                    }
                }
            }
              // nothing more to do
            if (iHaveMaster)
            {
				SCHenchCheckOutOfCombatStealth(CSLGetCurrentMaster());
                SCHenchFollowLeader();
            }
            DeleteLocalInt(oCharacter, "HenchCombatEquip");
            return;
        }
    }
    else
    {
        SCClearEnemyLocation();
    }
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running", GetFirstPC() ); } //
	
    SetLocalInt(oCharacter, "HenchCombatEquip", TRUE);

    // fail safe set of last target
    if (GetIsObjectValid(goClosestSeenOrHeardEnemy))
    {
		SetLocalObject(oCharacter, "LastTarget", goClosestSeenOrHeardEnemy);
    }

    int combatRoundCount = GetLocalInt(oCharacter, "tkCombatRoundCount");
    int combatRoundIncremented;

    int currentTimeSec = GetTimeSecond();
    if (combatRoundCount == 0)
    {
        combatRoundCount ++;
        SetLocalInt(oCharacter, "LastCombatTime", currentTimeSec);
        SetLocalInt(oCharacter, "tkCombatRoundCount", combatRoundCount);
        combatRoundIncremented = TRUE;
    }
    else
    {
        int lastCombatTime = GetLocalInt(oCharacter, "LastCombatTime");
        int lastCombatTimeDiff = currentTimeSec + 1 - lastCombatTime;
        if (lastCombatTimeDiff < 0)
        {
            lastCombatTimeDiff += 60;
        }
        if (lastCombatTimeDiff > 5)
        {
//          Jug_Debug(GetName(oCharacter) + " setting combat round count value " + IntToString(lastCombatTimeDiff));
            combatRoundCount ++;
            combatRoundIncremented = TRUE;
            SetLocalInt(oCharacter, "tkCombatRoundCount", combatRoundCount);
            SetLocalInt(oCharacter, "LastCombatTime", currentTimeSec);
        }
    }

        //Shout that I was attacked
    if (!(iAmHenchman || iAmFamiliar || iAmCompanion) &&
        (HENCH_MONSTER_SHOUT_FREQUENCY > 0) &&
        (combatRoundCount % HENCH_MONSTER_SHOUT_FREQUENCY == 1))
    {
//      Jug_Debug(GetName(oCharacter) + " shouting I was attacked");
        SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
    }

    // June 2/04: Fix for when henchmen is told to use stealth until next fight
    if (GetLocalInt(oCharacter, "X2_HENCH_STEALTH_MODE") == 2)
    {
        SetLocalInt(oCharacter, "X2_HENCH_STEALTH_MODE", 0);
    }
	
    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(oCharacter,"X2_SPECIAL_COMBAT_AI_SCRIPT");
    if (sSpecialAI != "")
    {
        if (GetCurrentAction() == ACTION_INVALID)
        {
            //  Jug_Debug(GetName(oCharacter) + " special AI " + sSpecialAI);
            SetLocalObject(oCharacter,"X2_NW_I0_GENERIC_INTRUDER", oIntruder);
            ExecuteScript(sSpecialAI, oCharacter);
            if (GetLocalInt(oCharacter,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK"))
            {
                //  Jug_Debug(GetName(oCharacter) + " exit special AI " + sSpecialAI);
                DeleteLocalInt(oCharacter,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK");
                return;
            }
        }
        else
        {
            return;
        }
    }

	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running HENCH_ASC_MELEE_DISTANCE_NEAR", GetFirstPC() ); } //    Jug_Debug(GetName(oCharacter) + " intruder " + GetName(oIntruder));
	
   // Get distance closer than which henchman will swap to melee.
    float fThresholdDistance;
    if (SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR))
    {
        fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_NEAR;
    }
	else if (SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED))
	{
		fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_MED;
	}
    else if (SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR))
    {
        fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_FAR;
    }
	else
	{
		// not set
		int rangeSet = GetLocalInt(oCharacter, "HenchRangedSet");
		if (!rangeSet)
		{
			object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			if (GetWeaponRanged(oRightWeapon))
			{
	        	rangeSet = 1;
			}
			else
			{
	        	rangeSet = 2;
			}
			SetLocalInt(oCharacter, "HenchRangedSet", rangeSet);		
		}		
		if (rangeSet == 1)
		{
        	fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_MED;
		}
		else
		{
        	fThresholdDistance = 10000.0;
		}			
	}
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCGetCreatureNegEffects", GetFirstPC() ); } //
	if (!bForce && GetIsObjectValid(oIntruder) &&  ((GetDistanceToObject(oIntruder) > (fThresholdDistance + 0.5)) || (SCGetCreatureNegEffects(oIntruder) & HENCH_EFFECT_DISABLED)))
	{	
		oIntruder = OBJECT_INVALID;
	}

    SCIntitializeHealingInfo(FALSE, oCharacter);
    SCHenchInitializeInvisibility(iPosEffectsOnSelf);
    SCInitializeTargetLists(oIntruder);

    int bAllowMeleeAttacks = !SCGetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS) || (SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON);
    if (gbAnyValidTarget && bAllowMeleeAttacks)
    {
        // multiplier because attacks are unlimited		
		if (!gbIAmStuck || (SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON))
		{
	        gfAttackTargetWeight = SCAIMeleeAttack(oIntruder, iPosEffectsOnSelf,  (iNegEffectsOnSelf & HENCH_EFFECT_IMMOBILE) && !(SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON),oCharacter) * 1.02;
		}
    }
//	gfAttackTargetWeight = 0.0;    // test code to not use melee attack
    gsAttackTargetInfo.spellID = -1;  // SPELL_ACID_FOG is zero
    gsBuffTargetInfo.spellID = -1;  // SPELL_ACID_FOG is zero

	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCHenchTalentStealth", GetFirstPC() ); } //	Jug_Debug(GetName(oCharacter) + " start check spells threshold " + FloatToString(gfAttackTargetWeight));

        // try to go invis if have sneak attack at beginning of combat (helps with sneaking)
    if (!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED") && !SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE) &&  ((iPosEffectsOnSelf & HENCH_EFFECT_TYPE_INVISIBILITY) || GetHasFeat(FEAT_SNEAK_ATTACK)))
    {
        SCHenchTalentStealth(iPosEffectsOnSelf & HENCH_EFFECT_TYPE_INVISIBILITY);
    }

    // Get challenge below which no defensive spells are cast
    // Signal to try to get some distance between self and the enemy.
    int bBackAway = SCGetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY);
	
        // if backaway or weak mage or sorcerer, try to back away when casting some spells
    if (!(iNegEffectsOnSelf & HENCH_EFFECT_IMMOBILE) &&
        (bBackAway || (iAmMonster && ((SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON)
        || SCGetIsLowBAB()) &&
        GetIsPlayableRacialType(oCharacter))) && SCCheckMoveAwayFromEnemies())
    {
//		Jug_Debug(GetName(oCharacter) + " move away enabled");
        gbEnableMoveAway = TRUE;
    }	
	    //This check is to see if the master is being attacked and in need of help
    if (CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER))
    {
//		Jug_Debug(GetName(oCharacter) + " checking defend master " + GetName(oMaster));
		float fGuardDistance;
		if (SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR))
		{
			fGuardDistance = 7.0;
		}
		else if (SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED))
		{
			fGuardDistance = 13.5;
		}
		else if (SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR))
		{
			fGuardDistance = 20.0;
		}
		else if (CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON))
		{
			fGuardDistance = 20.0;
		}
		else
		{
			fGuardDistance = 7.0;
		}
		
		object oLastMasterAttacker = GetLastHostileActor(oMaster);
		object oLastAttacker = GetLastHostileActor();

		// trim enemy lists based for guarding
	    object oCurObject =  GetLocalObject(oCharacter, "HenchLineOfSight");
		object oCurSeenObject = oCharacter;
		object oLastSeenOrHeardObject = oCharacter;
	    while (GetIsObjectValid(oCurObject))
	    {
			object oNext = GetLocalObject(oCurObject, "HenchLineOfSight");			
			if ((GetDistanceToObject(oCurObject) < 5.0) || (GetDistanceBetween(oCurObject, oMaster) < fGuardDistance) 
				|| (oLastMasterAttacker == oCurObject) || (oLastAttacker == oCurObject) || CheckLastAttacker(oCurObject))
			{
				if (oLastMasterAttacker == oCurObject)
				{
					oLastMasterAttacker = OBJECT_INVALID;
				}
				if (oLastAttacker == oCurObject)
				{
					oLastAttacker = OBJECT_INVALID;
				}
				// add to seen list
				if (GetObjectSeen(oCurObject))
				{
					SetLocalObject(oCurSeenObject, "HenchObjectSeen", oCurObject);
					oCurSeenObject = oCurObject;
				}
				oLastSeenOrHeardObject = oCurObject;
			}
			else
			{
				// remove current enemy from list
				SetLocalObject(oLastSeenOrHeardObject, "HenchLineOfSight", oNext);				
			}
	        oCurObject = oNext;
	    }
		DeleteLocalObject(oCurSeenObject, "HenchObjectSeen");
		goNotHeardOrSeenEnemy = OBJECT_INVALID;
		SCClearEnemyLocation();
		oCurObject = GetLocalObject(oCharacter, "HenchObjectSeen");
		while (GetIsObjectValid(oCurObject))
		{		
//			Jug_Debug(GetName(oCharacter) + " seen enemy left " + GetName(oCurObject));		
			oCurObject = GetLocalObject(oCurObject, "HenchObjectSeen");
		}
		if (GetIsObjectValid(oLastAttacker))
		{
//			Jug_Debug(GetName(oCharacter) + " add last attacker " + GetName(oLastAttacker));
			SCAddToTargetLists(oLastAttacker);
		}
		if (GetIsObjectValid(oLastMasterAttacker))
		{
//			Jug_Debug(GetName(oCharacter) + " add last master attacker " + GetName(oLastAttacker));
			SCAddToTargetLists(oLastMasterAttacker);
		}
		if (GetIsObjectValid(goNotHeardOrSeenEnemy))
		{
			SCSetEnemyLocation(goNotHeardOrSeenEnemy);
		}		
		if (!GetIsObjectValid(GetLocalObject(oCharacter, "HenchLineOfSight")))
		{		
			DeleteLocalObject(oCharacter, "LastTarget");		
			if (GetIsObjectValid(goClosestSeenOrHeardEnemy))
			{
				int bDoFollow;
				if (bBackAway || (iAmMonster && ((SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON)
			        || SCGetIsLowBAB()) && GetIsPlayableRacialType(oCharacter)))
				{					
//					Jug_Debug(GetName(oCharacter) + " try get behind");
					bDoFollow = !SCCheckMoveAwayFromEnemies()	|| !SCMoveAwayFromEnemies(goClosestSeenOrHeardEnemy, 9.0);								
				}
				else								
				{
//					Jug_Debug(GetName(oCharacter) + " try get ahead");
					bDoFollow = !SCMoveTowardsTarget(goClosestSeenOrHeardEnemy, oMaster, 4.0);								
				}
				if (bDoFollow)
				{
//					Jug_Debug(GetName(oCharacter) + " try follow 1");
					SCHenchFollowLeader();
				}
			}
			else
			{
//				Jug_Debug(GetName(oCharacter) + " try follow 2");
				SCHenchFollowLeader();
			}		
			return;
		}
    }

    float fThresholdChallenge;
    float fChallenge;
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running iAmMonster", GetFirstPC() ); } //
	
    if (iAmMonster || !iHaveMaster)
    {
    	// Monsters and non-associates do not care about the challenge rating for now.
        fThresholdChallenge = -100.;
        fChallenge = 10000.0;
		SCInitializeMonsterAllyDamage();				
    }
    else
    {
        //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running CSLGetAssociateState CSL_ASC_SCALED_CASTING", GetFirstPC() ); } //
        
        if (CSLGetAssociateState(CSL_ASC_SCALED_CASTING))
        {
            fThresholdChallenge = 1.0;
        }
        else if (CSLGetAssociateState(CSL_ASC_POWER_CASTING))
        {
            fThresholdChallenge = -1.0;
        }
        else if (CSLGetAssociateState(CSL_ASC_OVERKIll_CASTING))
        {
            fThresholdChallenge = -4.0;
        }
        else
        {
            if (SCGetIsLowBAB())
            {
                fThresholdChallenge = -3.;
            }
            else
            {
                fThresholdChallenge = PAUSANIAS_CHALLENGE_THRESHOLD;
            }
        }
        // Pausanias's Combined Challenge Rating (CCR)
        fChallenge = SCGetEnemyChallenge();
		SCInitializeAssociateAllyDamage();
    }
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running Scouting", GetFirstPC() ); } //
	
      // I am a familiar or animal companion, flee currently disabled
/*    if ((iAmFamiliar || iAmCompanion) && GetIsObjectValid(goClosestSeenOrHeardEnemy))
    {
        // Get challenge above which familiar or animal companion will run away
        float fAssociateChallenge;
        int bFightToTheDeath;
        if (iAmFamiliar)
        {
            fAssociateChallenge = GetLocalFloat(oMaster, sHenchFamiliarChallenge);
            if (fAssociateChallenge == 0.0)
                fAssociateChallenge = PAUSANIAS_FAMILIAR_THRESHOLD;
            bFightToTheDeath = GetLocalInt(oMaster, sHenchFamiliarToDeath);
        }
        else
        {
            // default to 0.0 challenge if not set
            fAssociateChallenge = GetLocalFloat(oMaster, sHenchAniCompChallenge);
            bFightToTheDeath = GetLocalInt(oMaster, sHenchAniCompToDeath);
        }
        // Run away from tough enemies
        if (!bFightToTheDeath && (fChallenge >= fAssociateChallenge || (iHP < 40)))
        {
            if (iAmFamiliar)
            {
                switch (d10())
                {
                    case 1: SpeakString(sHenchFamiliarFlee1); return;
                    case 2: SpeakString(sHenchFamiliarFlee2); break;
                    case 3: SpeakString(sHenchFamiliarFlee3); break;
                    case 4: SpeakString(sHenchFamiliarFlee4); break;
                }
            }
            else
            {
                if (d3() == 1)
                {
                    SpeakString(sHenchAniCompFlee);
                }
            }
            ClearAllActions();
            HenchTalentHide(iPosEffectsOnSelf, gbMeleeAttackers);
            ActionMoveAwayFromObject(goClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(goClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(goClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(goClosestSeenOrHeardEnemy,TRUE,40.);
            SetLocalInt(oCharacter, "RunningAway",TRUE);
            return;
        }
    } */

    // Pausanias: Combat has finally begun, so we are no longer scouting
    DeleteLocalInt(oCharacter, "Scouting");
    DeleteLocalInt(oCharacter, "RunningAway");

    int iHP = SCGetPercentageHPLoss(oCharacter);
    int iCheckHealing = iHP < 50;

    SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, iCheckHealing ? HENCH_HEAL_SELF_CANT : HENCH_HEAL_SELF_WAIT);

    if (iUseMagic)
    {
        if (fChallenge < fThresholdChallenge)
        {
            gbSpellInfoCastMask = HENCH_SPELL_INFO_UNLIMITED_FLAG | HENCH_SPELL_INFO_HEAL_OR_CURE;
            gbDisableNonUnlimitedOrHealOrCure = TRUE;
        }
        else
        {
            gbSpellInfoCastMask = 0xffffffff;   // turn on every bit to allow every spell
			gbDisableHighLevelSpells = fChallenge < (fThresholdChallenge + 3.0);
        }
		//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running enemySum", GetFirstPC() ); } ////      Jug_Debug(GetName(oCharacter) + (gbDisableNonUnlimitedOrHealOrCure ? " disable" : "enable") + " non unlimited, heal, or cure " + FloatToString(fChallenge));

        // do some adjustment of buff priority based on enemy threat
        float enemySum;
        float index;
        object oTest = GetLocalObject(oCharacter, "HenchLineOfSight");
        while (GetIsObjectValid(oTest) && (index < 6.0))
        {
            index += 1.0;
            enemySum += GetLocalFloat(oTest, "HenchThreatRating") / index;
            oTest = GetLocalObject(oTest, "HenchLineOfSight");
        }
        float friendSum;
        index = 0.0;
        oTest = oCharacter;
        while (GetIsObjectValid(oTest) && (index < 6.0))
        {
            index += 1.0;
            friendSum += GetLocalFloat(oTest, "HenchThreatRating") / index;
            oTest = GetLocalObject(oTest, "HenchAllyLineOfSight");
        }

        if (friendSum < 0.1)
        {
            gfBuffSelfWeight = 1.0;
        }
        else
        {
            gfBuffSelfWeight = enemySum / friendSum;
            if (gfBuffSelfWeight < 0.05)
            {
                gfBuffSelfWeight = 0.05;
            }
            else if (gfBuffSelfWeight > 1.5)
            {
                gfBuffSelfWeight = 1.5;
            }
        }

	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCGetIsLowBAB", GetFirstPC() ); } //   Jug_Debug(GetName(oCharacter) + " buff self weight " + FloatToString(gfBuffSelfWeight));

        // adjust attack and buff based on class type
			
		if (SCGetIsLowBAB())
		{
			gfAttackTargetWeight *= 0.8;  // reduce chance of melee attack
		}		
		int iPosition = 1;
		int nClassLevel = GetLevelByPosition(iPosition);
		
		float curBuffOthersWeight;
		float curAttackWeight;

		while ((nClassLevel > 0) && (iPosition <= 4))
		{
			// int nClass = SCHenchGetClassByPosition(iPosition, nClassLevel);
			int nClass = GetClassByPosition(iPosition, oCharacter);
			int nClassFlags = SCHenchGetClassFlags(nClass);
			switch (nClassFlags & HENCH_CLASS_BUFF_OTHERS_MASK)
			{
				case HENCH_CLASS_BUFF_OTHERS_FULL:
					curBuffOthersWeight += 0.8 * nClassLevel;
					break;
				case HENCH_CLASS_BUFF_OTHERS_HIGH:
					curBuffOthersWeight += 0.5 * nClassLevel;
					break;
				case HENCH_CLASS_BUFF_OTHERS_MEDIUM:
					curBuffOthersWeight += 0.4 * nClassLevel;
					break;
				default:
					curBuffOthersWeight += 0.3 * nClassLevel;
					break;
			}
			switch (nClassFlags & HENCH_CLASS_ATTACK_MASK)
			{
				case HENCH_CLASS_ATTACK_FULL:
					curAttackWeight += nClassLevel;
					break;
				case HENCH_CLASS_ATTACK_HIGH:
					curAttackWeight += 0.9 * nClassLevel;
					break;
				case HENCH_CLASS_ATTACK_MEDIUM:
					curAttackWeight += 0.75 * nClassLevel;
					break;
				default:
					curAttackWeight += 0.6 * nClassLevel;
					break;
			}
			nClassLevel = GetLevelByPosition(++iPosition);
		}			
		int hitDice = GetHitDice(oCharacter);			
//			Jug_Debug(GetName(oCharacter) + " attack weight " + FloatToString(curAttackWeight / hitDice) + " buff weight " + FloatToString(curBuffOthersWeight / hitDice));			
		if (hitDice > 0)
		{
			gfBuffOthersWeight = 0.5 * curBuffOthersWeight / hitDice;
			gfAttackWeight = curAttackWeight / hitDice;
		}
		else
		{
			gfBuffOthersWeight = 0.5 * gfBuffSelfWeight;
			gfAttackWeight = 1.0;
		}
		
		
        // TODO randomize?
        if (iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE)
        {
            // while invisible do maximum amount of buffing & summoning
            gfAttackWeight *= 0.01; // try to buff up before attacking again
//          Jug_Debug(GetName(oCharacter) + " i am invisible " + IntToHexString(iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE));
            // TODO max out healing?
        }
        gfAttackTargetWeight *= gfAttackWeight;

        SCInitializeItemSpells(iNegEffectsOnSelf, iPosEffectsOnSelf, oCharacter);
  //    Jug_Debug(GetName(oCharacter) + " start cast " + GetName(oIntruder));
    }

        // if backaway or weak mage or sorcerer, try to back away when casting some spells
    if (!(iNegEffectsOnSelf & HENCH_EFFECT_IMMOBILE) &&
        (bBackAway || (iAmMonster && ((SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON)
        || (gbAnySpellcastingClasses & HENCH_ARCANE_SPELLCASTING)) &&
        GetIsPlayableRacialType(oCharacter))) && SCCheckMoveAwayFromEnemies())
    {
//		Jug_Debug(GetName(oCharacter) + " move away enabled");
        gbEnableMoveAway = TRUE;
    }

    // NEXT priority: follow or return to master.
    if (iHaveMaster && !GetLocalInt(oCharacter, "RunningAway"))
    {
        DeleteLocalInt(oCharacter, "Scouting");
//		Jug_Debug(GetName(oCharacter) + " in follow test " + GetName(oMaster) + " distance " + FloatToString(GetDistanceToObject(oMaster)));
        if ((GetDistanceToObject(oMaster) > 15.0) && !GetObjectSeen(oMaster))
        {
//			Jug_Debug(GetName(oCharacter) + " return to master");
			ClearAllActions();
			SCHenchFollowLeader();
			return;
        }
    }

        // check for area effect spells damaging self
    if (SCCheckAOEForSelf(iNegEffectsOnSelf, iPosEffectsOnSelf)) {return;}

    /* TODO leave out for now
    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_AMBUSHER)
        && SCSpecialTacticsAmbusher(ogClosestSeenOrHeard))
    {
        return;
    }*/

    // complain if you need healing
    if ((iAmHenchman || iAmFamiliar) && (GetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_CANT))
    {
        if (iAmHenchman)
        {
            if (Random(100) > 80) SCVoiceHealMe();
        }
        else
        {
		//	"Help! I can't heal myself!"
            SpeakStringByStrRef(230434);
        }
    }

    if (SCHenchCheckSpellToCast(combatRoundCount))
    {
        return;
    }
	
    if (!bAllowMeleeAttacks)
    {
        if (gbEnableMoveAway)
        {
    		//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running gbEnableMoveAway move away for spell", GetFirstPC() ); }
            gbEnableMoveAway = FALSE;
            if (SCMoveAwayFromEnemies(goClosestSeenOrHeardEnemy, 9.0))
            {
                //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "hench_o0_ai running SCHenchStartCombatRoundAfterAction", GetFirstPC() ); }
                
                SCHenchStartCombatRoundAfterAction(OBJECT_INVALID);
                return;
            }
        }
        SCHenchFollowLeader();
    }
    else if (gbAnyValidTarget)
    {
//		Jug_Debug("+++++++++ " + GetName(oCharacter) + " doing melee attack");
		SCHenchCheckCastAuraSpell();
        //Attack if out of spells
        SCHenchTalentMeleeAttack(oIntruder, fThresholdDistance,
            iAmMonster ? 0 : (iAmHenchman ? 1 : 2), iPosEffectsOnSelf & HENCH_EFFECT_TYPE_POLYMORPH,
            (SCGetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON) && (GetIsObjectValid(goClosestSeenEnemy) || gbLineOfSightHeardEnemy) && gbIAmStuck);
    }
    else
    {
        // try and find enemy
        // henchmen using ranged weapons will not move to unheard and unseen enemies
        if (!bForce && !iAmMonster && (CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON) || bBackAway))
        {
//			Jug_Debug("+++++++++ " + GetName(oCharacter) + " move to master " + GetName(oMaster));
			SCHenchCheckCastAuraSpell();
			ActionForceFollowObject(oMaster);
            SCClearEnemyLocation();
            if ((GetDistanceToObject(oMaster) >= 5.0) && !GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
            {
                SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
                DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(OBJECT_INVALID));
            }
			ActionDoCommand(SCHenchMoveToMaster(oMaster));
        }
        else if (GetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN))
        {
//			Jug_Debug(GetName(oCharacter) + " moving to last target");
            int bDoingMove = SCMoveToLastSeenOrHeard();
			SCHenchCheckCastAuraSpell();
            if (bDoingMove && !GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
            {
                SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
                DelayCommand(3.0, SCHenchStartCombatRoundAfterDelay(OBJECT_INVALID));
        	}
		}
    }
    //DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "hench_o0_ai End "+GetName(oCharacter) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}