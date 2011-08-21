//::///////////////////////////////////////////////
//:: Associate: Heartbeat
//:: gb_assoc_heart
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Move towards master or wait for him
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"

/*
@todo remove x2_inc_summscale
gb_assoc_heart.nss(58): Error: Undeclared identifier "SSMGetSummonFailedLevelUp"
gb_assoc_heart.nss(64): Error: Undeclared identifier "SSMScaleEpicShadowLord"
gb_assoc_heart.nss(68): Error: Undeclared identifier "SSMScaleEpicFiendishServant"
gb_assoc_heart.nss(72): Error: Undeclared identifier "SSMLevelUpCreature"
gb_assoc_heart.nss(81): Error: Undeclared identifier "SSMSetSummonLevelUpOK"
*/


#include "x2_inc_summscale"
//#include "x2_inc_spellhook"
#include "_SCInclude_Group"


void main()
{
//	Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()) + " PC " + IntToString(GetIsPC(OBJECT_SELF)));
//  Jug_Debug(GetName(OBJECT_SELF) + " faction leader " + GetName(GetFactionLeader(OBJECT_SELF)));
//  Jug_Debug(GetName(OBJECT_SELF) + " distance " + FloatToString(GetDistanceToObject(GetMaster())));

        // destroy self if pseudo summons and master not valid
 /*   if (GetLocalInt(OBJECT_SELF, sHenchPseudoSummon) && !GetIsObjectValid(GetMaster()))
    {
        DestroyObject(OBJECT_SELF, 0.1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
        return;
    } */
	
        // BMA-OEI 7/04/06 - Check if in group and using group campaign flag
    // May not be needed if we change nwn2_scriptsets.2da PCDominate entry to use nw_g0_dominate
    if (GetGlobalInt(CAMPAIGN_SWITCH_FORCE_KILL_DOMINATED_GROUP) == TRUE )
    {
        string sGroupName = SCGetGroupName( OBJECT_SELF );
        if ( sGroupName != "" )
        {
            if ( CSLGetHasEffectType(OBJECT_SELF, EFFECT_TYPE_DOMINATED) )
            {
                if ( SCGetIsGroupDominated(sGroupName)  )
                {
                    CSLRemoveEffectByType( OBJECT_SELF, EFFECT_TYPE_DOMINATED );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF );
                }
            }
        }
    }

    // GZ: Fallback for timing issue sometimes preventing epic summoned creatures from leveling up to their master's level.
    // There is a timing issue with the GetMaster() function not returning the fof a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // This code is only run at the first heartbeat
    int nLevel = SSMGetSummonFailedLevelUp(OBJECT_SELF);
    if (nLevel != 0)
    {
        int nRet;
        if (nLevel == -1) // special shadowlord treatment
        {
            SSMScaleEpicShadowLord(OBJECT_SELF);
        }
        else if  (nLevel == -2)
        {
            SSMScaleEpicFiendishServant(OBJECT_SELF);
        }
        else
        {
            nRet = SSMLevelUpCreature(OBJECT_SELF, nLevel, CLASS_TYPE_INVALID);
            if (nRet == FALSE)
            {
                WriteTimestampedLogEntry("WARNING - nw_ch_ac1:: could not level up " + GetTag(OBJECT_SELF) + "!");
            }
        }

        // regardless if the actual levelup worked, we give up here, because we do not
        // want to run through this script more than once.
        SSMSetSummonLevelUpOK(OBJECT_SELF);
    }

    // Check if concentration is required to maintain this creature
    CSLDoBreakConcentrationCheck();

    // * if I am dominated, ask for some help
    // TK removed SCSendForHelp
//    if (CSLGetHasEffectType(OBJECT_SELF,EFFECT_TYPE_DOMINATED) && !GetIsEncounterCreature(OBJECT_SELF) )
//    {
//        SCSendForHelp();
//    }

        // restore associate settings
    SCHenchGetDefSettings();

	// JWR-OEI Added per TTP bug 553
	if (GetScriptHidden(OBJECT_SELF))
	{
		// in case they are script hidden (like on overland map)
		// they'll stop buffing themselves.
		ClearAllActions();
		return;
	}
	if (CSLGetAssociateState(CSL_ASC_IS_BUSY))
    {
        return;
    }
    if (!SCGetIAmNotDoingAnything())
    {
        return;
    }
    object oRealMaster = CSLGetCurrentMaster();
    if (!GetIsObjectValid(oRealMaster))
    {
        return;
    }

    if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
    {
        if (SCHenchCheckHeartbeatCombat())
        {
            SCHenchResetCombatRound();
        }
		if (!SCGetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) && SCHenchGetIsEnemyPerceived(SCGetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING)))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " heartbeat determine combat round");
            SCHenchDetermineCombatRound();
            return;
        }
        if (GetLocalInt(OBJECT_SELF, HENCH_LAST_HEARD_OR_SEEN))
        {
//      Jug_Debug(GetName(OBJECT_SELF) + " moving to last seen and heard");
            // continue to move to target
			SCHenchDetermineCombatRound();
            return;
        }
    }
    SCHenchResetCombatRound();

	// do not interrupt player queued actions
    if (SCGetHasPlayerQueuedAction(OBJECT_SELF))
    {
        return;
    }

    if ((GetLocalObject(OBJECT_SELF,"NW_L_FORMERMASTER") != OBJECT_INVALID)
        && (GetLocalInt(OBJECT_SELF, "haveCheckedFM") != 1))
    {
        // Auldar: For a little OnHeartbeat efficiency, I'll set a localint so we don't
        // keep checking stealth mode etc. This will be cleared in NW_CH_JOIN, as will
        // the LocalObject for NW_L_FORMERMASTER.
        // A little quirk with this behavior - the ActionUseSkill's do not execute until the henchman rejoins
        // however if the player re-loads, or leaves the area and returns, the henchman will no longer be in stealth etc.
        // I couldn't find any way around that odd behavior, but this works for the most part.
        SetLocalInt(OBJECT_SELF, "haveCheckedFM", 1);
        CSLSetAssociateState(CSL_ASC_AGGRESSIVE_SEARCH, FALSE);
        SetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 0);
        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
        SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
    }

	SCHenchCheckOutOfCombatStealth(oRealMaster);

    SCCleanCombatVars();
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);

    if (GetLocalInt(OBJECT_SELF, "HenchCurHealCount"))
    {
//        Jug_Debug(GetName(OBJECT_SELF) + " HB checking heal count " + IntToString(GetLocalInt(OBJECT_SELF, "HenchCurHealCount")));
        ActionDoCommand(ActionWait(2.5));
        ActionDoCommand(ExecuteScript("hench_o0_heal", OBJECT_SELF));
        return;
    }

        //25% chance that..
    if ((d4() == 1) &&
        !CSLGetAssociateState(CSL_ASC_MODE_PUPPET) &&
        (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") != 10) &&
        !GetLocalInt(OBJECT_SELF, "DoNotAttack") &&
        // if we're not excluding the ability to use feats and abilities
        !CSLGetLocalIntBitState(OBJECT_SELF, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ABILITY))
    {
        //and if we have the summon familiar feat
        if (SCGetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS) && (GetHasFeat(FEAT_SUMMON_FAMILIAR, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_FAMILIAR, OBJECT_SELF)))
        {
            object oAssociate = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
            // with no current familiar stat
            if (!GetIsObjectValid(oAssociate))
            {
                // summon my familiar and decrement use
                SummonFamiliar();
                DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
            }
        }
        // or if we have the animal companion feat
        else if (SCGetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS) && (GetHasFeat(FEAT_ANIMAL_COMPANION, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_ANIMAL_COMPANION, OBJECT_SELF)))
        {
            object oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);
            // and no current companion
            if (!GetIsObjectValid(oAssociate))
            {
                //summon companion and decrement us
                SummonAnimalCompanion();
                DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
            }
        }
    }
    // TODO add auto cure????   if (NonCombatCureEffects())

    if (!SCGetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF) &&
        !CSLGetAssociateState(CSL_ASC_MODE_PUPPET) &&
        (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") != 10) &&
        !GetLocalInt(OBJECT_SELF, "DoNotAttack") &&
        (GetDistanceToObject(oRealMaster) <= 10.0) &&
		!GetIsOverlandMap(GetArea(OBJECT_SELF)))
    {
        if (GetLevelByClass(CLASS_TYPE_WARLOCK))
        {
            if (!(GetLocalInt(OBJECT_SELF, "N2_TALENT_EXCLUDE") & TALENT_EXCLUDE_SPELL))
            {
                if (SCTryCastWarlockBuffSpells(FALSE))
                {
                    return;
                }
            }
            else
            {
                gbFoundInfiniteBuffSpell = TRUE;
            }
        }
        if (GetLevelByClass(CLASS_TYPE_BARD) &&
            !(SCGetCreatureNegEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_SILENCE))
        {
            if (!(GetLocalInt(OBJECT_SELF, "N2_TALENT_EXCLUDE") & TALENT_EXCLUDE_ABILITY))
            {
                if (SCTryCastBardBuffSpells())
                {
                    return;
                }
            }
            else
            {
                gbFoundInfiniteBuffSpell = TRUE;
            }
        }

        if (!gbFoundInfiniteBuffSpell)
        {
            // didn't find anything, don't keep looking
            SCSetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, TRUE, OBJECT_SELF);
        }
    }

    if (SCHenchCheckArea())
    {
      return;
    }
       // Pausanias: Hench tends to get stuck on follow.
/*    if (GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW)
    {
        if (GetDistanceToObject(oRealMaster) >= 2.2 &&
            CSLGetAssociateState(CSL_ASC_DISTANCE_2_METERS)) return;
        if (GetDistanceToObject(oRealMaster) >= 4.2 &&
            CSLGetAssociateState(CSL_ASC_DISTANCE_4_METERS)) return;
        if (GetDistanceToObject(oRealMaster) >= 6.2 &&
            CSLGetAssociateState(CSL_ASC_DISTANCE_6_METERS)) return;
        ClearAllActions();
    } */

    SCClearWeaponStates();

    if (GetLocalInt(OBJECT_SELF, "HenchCombatEquip"))
    {
        DeleteLocalInt(OBJECT_SELF, "HenchCombatEquip");
        if (!SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
        {
            ClearAllActions();
            if (SCGetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS))
            {
                SCUnequipWeapons();
            }
            else
            {
				SCHenchEquipDefaultWeapons();
            }
            return;
        }
    }

    int bIsScouting = GetLocalInt(OBJECT_SELF, "Scouting");
    if (bIsScouting)
    {
        if (GetDistanceToObject(oRealMaster) < 6.0)
        {
			//	"Please get out of my way."
            SpeakStringByStrRef(230435);
        }
        object oScoutTarget = GetLocalObject(OBJECT_SELF, "ScoutTarget");
        if (GetDistanceBetween(oScoutTarget, oRealMaster) > HENCH_MAX_SCOUT_DISTANCE)
        {
            DeleteLocalInt(OBJECT_SELF, "Scouting");
            bIsScouting = FALSE;
        }
        else
        {
            if (SCCheckStealth() && !GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
            ActionMoveToObject(oScoutTarget, FALSE, 1.0);
        }
    }

    if(!bIsScouting && !CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) &&
		(!CSLGetAssociateState(CSL_ASC_MODE_PUPPET) || (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR) ||
		SCGetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)) &&
        (GetNumActions(OBJECT_SELF) == 0) && !SCGetIsFighting(OBJECT_SELF) &&
        (GetDistanceToObject(SCHenchGetFollowLeader()) > CSLGetFollowDistance()))
    {
        ClearAllActions();
        SCHenchFollowLeader();
    }

    if(SCGetSpawnInCondition(CSL_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}