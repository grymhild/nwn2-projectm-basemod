/*
9-24-10
Intellect Devourer

Okay, these guys are pretty evil...so let's make them scary(I mean, walking brains! Wow, scary stuff)
I'm going to comment this thoroughly for individual mod makers so they can see how I'm doing this. Due to the nature of this creature, it might interfere
with many in-game systems. So, keep that in mind.

This script handles the "Body Thief" ability. Pasted here for posterity:

******************************************************************************************************************************************************************
Body Thief (Su)
When an intellect devourer overcomes a lone victim, it consumes the victim's brain and enters the skull. 
As a full-round action that provokes attacks of opportunity, the devourer can merge its form with that of a helpless or dead creature of Small size or larger. 
The devourer cannot merge its body with that of a creature immune to extra damage from critical hits.

When an intellect devourer completes its merging, it psionically consumes the brain of the victim (which kills it if it is not already dead). 
The devourer can exit the body at any time as a standard action, bursting the victim’s skull and resuming its normal form.

After consuming its victim’s brain, an intellect devourer can instead choose to animate the body for up to seven days as if it were the victim’s original brain. 
The devourer retains its hit points, saving throws, and mental ability scores, as well as its psi-like abilities. 
It assumes the physical qualities and ability scores of the victim, as if it had used polymorph to assume the victim’s form. 
As long as the intellect devourer occupies the body, it knows the languages spoken by the victim and very basic information about the victim’s identity and personality, but none of the victim’s specific memories or knowledge.

******************************************************************************************************************************************************************

So, how do we implement this? "nw_c2_default7"--the death script--has a call for a death script "DeathScript". We can check to see if the last killer of the 
creature in question was an intellect devourer(we can't check to see if a creature is dead, as individual modders might make some creatures stay as corpses 
while others don't). If the intellect devourer kills a target, then it "merges" with that target. There are some checks for this, yadyadyada, so check below for 
the specifics

There's a failsafe, too, to check if the creature died and an intllect devourer is nearby(they're opportunistic, let's say).

Oh, yeah, to be specific, this is the script that's called *if* a creature is killed by a devourer
The other script, "cw_spawnintellect", is for a possessed creature
*/
//#include "nw_i0_generic"

//#include "hench_i0_ai"

#include "_SCInclude_AI"
#include "_HkSpell"

//For the chance of making a devourer spawn while keeping the body around
void CW_DelayedSpawn( object oCharacter = OBJECT_SELF )
{
	if(GetIsDead(oCharacter) || GetLocalString(oCharacter, "DeathScript")!="cw_spawnintellect")
	{
		return;
	}
	ExecuteScript("cw_spawnintellect", oCharacter);
}



void CS_Death( object oCharacter = OBJECT_SELF )
{
	object oTarget=GetLocalObject(oCharacter, "CW_INSANE");
	
	if(GetIsObjectValid(oTarget))
	{
		effect e=GetFirstEffect(oTarget);
		
		while(GetIsEffectValid(e))
		{
			if(GetEffectType(e)==EFFECT_TYPE_INSANE)
			{
				RemoveEffect(oTarget, e);
				return;
			}
			e=GetNextEffect(oTarget);
		}
	}
}

//Handles spawning the intellect devourer //object oCharacter = OBJECT_SELF
void CW_SpawnIntellect(object oKiller, object oCharacter, int comp)
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_SpawnIntellect Start", GetFirstPC() ); }
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L"), GetLocation(oCharacter));
	SetLocalInt(oCharacter, "CW_NODEVOUR", 1);
	
	if(comp==FALSE)//Not a companion
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCharacter);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oCharacter)), oCharacter);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_PURPLE), oCharacter);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_PURPLE), oCharacter);//Makes a better effect
		ChangeFaction(oCharacter, oKiller);
		AssignCommand(oCharacter, SCHenchDetermineCombatRound(OBJECT_INVALID, FALSE, FALSE, oCharacter));
		DestroyObject(oKiller);
		SetScriptHidden(oKiller, TRUE);
		//SetLocalString(oCharacter, "CW_DeathScript", GetLocalString(oCharacter, "DeathScript"));
		if(GetLocalString(oCharacter, "CW_DeathScript")=="")
		SetLocalString(oCharacter, "CW_DeathScript", GetLocalString(oCharacter, "DeathScript"));
	
		SetLocalString(oCharacter, "DeathScript", "cw_spawnintellect");
		//To change things up, sometimes the devourer will burst out *and* keep the host alive(the above implies it can)
		//But, it doesn't always happen, so let's say 40% is a good chance for that
		//Change if you see fit
		if(d10()<=4)
		{
			DelayCommand(RoundsToSeconds(d3(2)), CW_DelayedSpawn(oCharacter));
		}
	}
	else
	{ 
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInsane(), oCharacter, 60.0f);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCharacter);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oCharacter)), oCharacter);
		SetLocalObject(oKiller, "CW_INSANE", oCharacter);
	}
	if (DEBUGGING >= 3) { CSLDebug(  "CW_SpawnIntellect End", GetFirstPC() ); }
}

/*
int CW_Helpless(object oTarget)
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Helpless Start", GetFirstPC() ); }
	
	effect e=GetFirstEffect(oTarget);
	
	while(GetIsEffectValid(e))
	{
		if(GetEffectType(e)==EFFECT_TYPE_STUNNED || GetEffectType(e)==EFFECT_TYPE_PARALYZE ||  GetEffectType(e)==EFFECT_TYPE_SLEEP)
		{
			if (DEBUGGING >= 3) { CSLDebug(  "CW_Helpless End", GetFirstPC() ); }
			return TRUE;
		}	
		effect e=GetNextEffect(oTarget);
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Helpless End", GetFirstPC() ); }
	return FALSE;
}
*/





void CS_AI( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CS_AI Start", GetFirstPC() ); }
	
	object oTarget=GetLocalObject(oCharacter, "CW_CORPSE");

	AssignCommand(oCharacter, ClearAllActions(TRUE));
	AssignCommand(oCharacter, ActionMoveToLocation(GetLocation(oTarget), TRUE));
	
	// //We don't have a corpse
	if(!GetIsObjectValid(oTarget) ||  GetLocalInt(oTarget, "CW_NODEVOUR")==1)//Or the corpse has been devoured
	{
		DeleteLocalString(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT");
		DeleteLocalObject(oCharacter, "CW_CORPSE");
		SCAIDetermineCombatRound( OBJECT_INVALID, 10, oCharacter );
		return;
	}
	
	if(GetDistanceBetween(oCharacter, oTarget)<=3.5f && GetLocalInt(oTarget, "CW_NODEVOUR")!=1)
	{
		if(GetIsPC(GetFactionLeader(oTarget)))
		{
			CW_SpawnIntellect(oCharacter, oTarget, TRUE);
		}
		else
		{
			CW_SpawnIntellect(oCharacter, oTarget, FALSE);
		}
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CS_AI End", GetFirstPC() ); }
}

void CS_IntellectRespawn()
{
	SetIsDestroyable(FALSE, TRUE, FALSE);
}

void CW_IntellectOnHitCast(object oSpellTarget, object oSpellOrigin)
{
	if( GetLocalString(oSpellTarget, "DeathScript")=="cw_spawnintellect" || GetTag(oSpellTarget)=="cw_intellectdevourer")
	{
		//Check to make sure two guys don't enter the same skull
		return;
	}
	
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectOnHitCast Start", GetFirstPC() ); }
	
	ExecuteScript("cw_intellectrespawn", oSpellTarget);
	
	//Now, check for racial types(construct, undead) and immunity to critical hits
	if(GetRacialType(oSpellTarget)==RACIAL_SUBTYPE_CONSTRUCT || GetRacialType(oSpellTarget)==RACIAL_SUBTYPE_UNDEAD || GetIsImmune(oSpellTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		return;
	} 

	//Also, modders can make sure intellect devourers can't do anything via the variable "CW_NODEVOUR"
	if(GetLocalInt(oSpellTarget, "CW_NODEVOUR")==1)
	{
		return;
	}
	
	/*GetIsPC(oCharacter) || */
	if( GetAssociateType(oSpellTarget)==ASSOCIATE_TYPE_FAMILIAR || GetAssociateType(oSpellTarget)==ASSOCIATE_TYPE_ANIMALCOMPANION || GetAssociateType(oSpellTarget)==ASSOCIATE_TYPE_SUMMONED || GetAssociateType(oSpellTarget)==ASSOCIATE_TYPE_HENCHMAN )//Self explanatory, really
	{
		return;
	}
	
	//Special check for onhit. If the target is "helpless", then we can transform here
	if( !GetIsDead(oSpellTarget) && CSLGetIsIncapacitated( oSpellTarget, FALSE,  FALSE, FALSE, TRUE, FALSE, TRUE) )
	{
		if(GetIsPC(GetFactionLeader(oSpellTarget)))
		{
			CW_SpawnIntellect(oSpellOrigin, oSpellTarget, TRUE);
		}
		else
		{
			CW_SpawnIntellect(oSpellOrigin, oSpellTarget, FALSE);
		}
		return;
	}
	
	//SendMessageToPC(GetFirstPC(), "RUNNING_X");
	if(GetLocalString(oSpellTarget, "CW_DeathScript")=="")
	{
		SetLocalString(oSpellTarget, "CW_DeathScript", GetLocalString(oSpellTarget, "DeathScript"));
		SetLocalString(oSpellTarget, "DeathScript", "cw_intellectdevourer");
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectOnHitCast End", GetFirstPC() ); }
}


void CS_IntellectSpawn( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectSpawn Start", GetFirstPC() ); }
	
	SetLocalString(oCharacter, "DeathScript", GetLocalString(oCharacter, "CW_DeathScript"));
	//DeleteLocalString(oCharacter, "DeathScript");
	SetLocalInt(oCharacter, "CW_NODEVOUR", 1);
	DeleteLocalInt(oCharacter, "CW_INTCORPSE");
	SetIsDestroyable(TRUE, FALSE, FALSE);
	//SendMessageToPC(GetFirstPC(), "RUNNING_D");
	object oTarget=CreateObject(OBJECT_TYPE_CREATURE, "cw_intellectdevourer", CalcSafeLocation(oCharacter, GetLocation(oCharacter), 5.0f, FALSE, FALSE));
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L"), GetLocation(oTarget));
	AssignCommand(oTarget, ClearAllActions(TRUE));
	
	object oEnemy=GetLastKiller();
	
	if(!GetIsObjectValid(oEnemy))
	oEnemy=CSLGetNearestEnemy( oCharacter );
	
	AssignCommand(oTarget, SCAIDetermineCombatRound(oEnemy,10, oCharacter));
	
	if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectSpawn End", GetFirstPC() ); }
}


//Checks to see how the intellect devourer should merge
void CS_IntellectDevourer(object oKiller, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectDevourer Start", GetFirstPC() ); }
	
	string devourer="cw_intellectdevourer";//change this tag *IF* your intellect devourer tag is different
	float intellect_reach=3.5f;//How far they can get onto a dead creature
	
	if(GetLocalString(oCharacter, "DeathScript")=="cw_spawnintellect" || GetTag(oCharacter)==devourer)//Check to make sure two guys don't enter the same skull
	{
		return;
	}
	
	//Now, check for racial types(construct, undead) and immunity to critical hits
	if(GetRacialType(oCharacter)==RACIAL_SUBTYPE_CONSTRUCT || GetRacialType(oCharacter)==RACIAL_SUBTYPE_UNDEAD || GetIsImmune(oCharacter, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		return;
	}
	
	//Also, modders can make sure intellect devourers can't do anything via the variable "CW_NODEVOUR"
	if(GetLocalInt(oCharacter, "CW_NODEVOUR")==1)
	{
		return;
	}
	
	/*GetIsPC(oCharacter) || */
	if( GetAssociateType(oCharacter)==ASSOCIATE_TYPE_FAMILIAR || GetAssociateType(oCharacter)==ASSOCIATE_TYPE_ANIMALCOMPANION || GetAssociateType(oCharacter)==ASSOCIATE_TYPE_SUMMONED || GetAssociateType(oCharacter)==ASSOCIATE_TYPE_HENCHMAN)//Self explanatory, really
	{
		return;
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectDevourer Devourer Killed", GetFirstPC() ); }
	
	//Did a devourer kill me?
	if(!GetScriptHidden(oKiller) && GetTag(oKiller)==devourer)
	{   
		if(GetIsPC(GetFactionLeader(oCharacter)))
		{
			CW_SpawnIntellect(oKiller, oCharacter, TRUE);
		}
		else
		{
			CW_SpawnIntellect(oKiller, oCharacter, FALSE);
		}
		if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectDevourer End", GetFirstPC() ); }
		return;
	}
	else if(!GetScriptHidden(oKiller) && !GetFactionEqual(oCharacter, GetNearestObjectByTag(devourer)))//Am I not a faction member of a devourer? Then, they might eat my brain(yikes!)
	{
		if(GetDistanceBetween(oCharacter, GetNearestObjectByTag(devourer))<=intellect_reach)
		{
			if(GetIsPC(GetFactionLeader(oCharacter)))
			{
				CW_SpawnIntellect(oKiller, oCharacter, TRUE);
			}
			else
			{
				CW_SpawnIntellect(oKiller, oCharacter, FALSE);
			}
			if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectDevourer End", GetFirstPC() ); }
			return;
		}
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CS_IntellectDevourer End", GetFirstPC() ); }
}

//Look for corpses
void CW_IntellectCorpse( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectCorpse Start", GetFirstPC() ); }
	location lNearCorpse = GetLocation(oCharacter);
	int total=0;
	object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, 25.0f, lNearCorpse, TRUE);
	while( GetIsObjectValid(oTarget) && total< 12)
	{
		if ( GetLocalInt(oTarget, "CW_NODEVOUR") !=1 )
		{
			if(GetIsDead(oTarget) && GetLocalInt(oTarget, "CW_INTCORPSE")==1  )
			{
				if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectCorpse Dead", GetFirstPC() ); }
				AssignCommand(oCharacter, ClearAllActions(TRUE));
				AssignCommand(oCharacter, ActionMoveToLocation(GetLocation(oTarget), TRUE));
				SetLocalString(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT", "cw_intellectai");
				SetLocalObject(oCharacter, "CW_CORPSE", oTarget);
				return;
			}
			else if( !GetFactionEqual(oTarget, oCharacter) && CSLGetIsIncapacitated( oTarget, FALSE,  FALSE, FALSE, TRUE, FALSE, TRUE)  )
			{
				if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectCorpse Stunned", GetFirstPC() ); }
				AssignCommand(oCharacter, ClearAllActions(TRUE));
				AssignCommand(oCharacter, ActionMoveToLocation(GetLocation(oTarget), TRUE));
				SetLocalString(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT", "cw_intellectai");
				SetLocalObject(oCharacter, "CW_CORPSE", oTarget);
				return;
			}
			else if(GetFactionEqual(oTarget, oCharacter) && GetAppearanceType(oTarget)!=GetAppearanceType(oCharacter) && GetLocalString(oTarget, "DeathScript")!="cw_spawnintellect")
			{
				if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectCorpse Ally", GetFirstPC() ); }
				SetLocalInt(oTarget, "CW_INTCORPSE", 1);
				ExecuteScript("cw_intellectrespawn", oTarget);
			}
		}
		
		total++;
		oTarget=GetNextObjectInShape(SHAPE_SPHERE, 25.0f, lNearCorpse, TRUE);
	}
	if (DEBUGGING >= 3) { CSLDebug(  "CW_IntellectCorpse End", GetFirstPC() ); }
}

void CW_FindCorpse( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_FindCorpse Start", GetFirstPC() ); }
	
	object oTarget=GetLocalObject(oCharacter, "CW_CORPSE");

	AssignCommand(oCharacter, ClearAllActions(TRUE));
	AssignCommand(oCharacter, ActionMoveToLocation(GetLocation(oTarget)));
	
	if(GetDistanceBetween(oCharacter, oTarget)<=3.5f)
	{
		if(GetIsPC(GetFactionLeader(oTarget)))
		{
			CW_SpawnIntellect(oCharacter, oTarget, TRUE);
		}
		else
		{
			CW_SpawnIntellect(oCharacter, oTarget, FALSE);
		}
	}
	if (DEBUGGING >= 3) { CSLDebug(  "CW_FindCorpse End", GetFirstPC() ); }
}


void CW_Heartbeat( object oCharacter = OBJECT_SELF )
{
	if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Start", GetFirstPC() ); }
	
	if(GetLocalInt(oCharacter, "CW_HBONCE")!=1)
	{
		SetLocalInt(oCharacter, "CW_HBONCE", 1);
		SetCustomHeartbeat(oCharacter, 3000);
	}	
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Corpse", GetFirstPC() ); }
	//We don't have a corpse
	if(!GetIsObjectValid(GetLocalObject(oCharacter, "CW_CORPSE")) || GetLocalInt(GetLocalObject(oCharacter, "CW_CORPSE"), "CW_NODEVOUR")==1)//Or the corpse has been devoured
	{
		DeleteLocalString(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT");
		DeleteLocalObject(oCharacter, "CW_CORPSE");
	}
	else//We do!
	{
		CW_FindCorpse();
		return;
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Spawn Condition", GetFirstPC() ); }
	if (SCGetSpawnInCondition(CSL_FLAG_FAST_BUFF_ENEMY, oCharacter))
	{
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCharacter, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
		if(GetIsObjectValid(oPC) && GetDistanceToObject(oPC) <= 40.0 )
		{
			if( !SCGetIsFighting(oCharacter) )
			{
				HkAutoBuff( oCharacter, oCharacter, TRUE, 99, TRUE, FALSE );
				
				SCSetSpawnInCondition(CSL_FLAG_FAST_BUFF_ENEMY, FALSE, oCharacter);
				// TODO evaluate continue with combat
				return;
			}
				
		}
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Check Heartbeat", GetFirstPC() ); }
	if (SCHenchCheckHeartbeatCombat(TRUE,oCharacter))
	{
		SCHenchResetCombatRound(oCharacter);
	}
	
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Sleeping", GetFirstPC() ); }
	if(CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SLEEP))
	{
		if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Sleeping at night", GetFirstPC() ); }
		if(SCGetSpawnInCondition(CSL_FLAG_SLEEPING_AT_NIGHT, oCharacter))
		{
			effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
			if(d10() > 6)
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCharacter);
			}
		}
	}
	// If we have the 'constant' waypoints flag set, walk to the next  waypoint.
	else if (!GetIsObjectValid(SCGetNearestSeenOrHeardEnemyNotDead(HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER,oCharacter)))
	{
		if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat Not Sleeping", GetFirstPC() ); }
		SCCleanCombatVars(oCharacter);
		if (SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
		{
			SCHenchDetermineSpecialBehavior(OBJECT_INVALID,oCharacter);
		}
		else if (GetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN))
		{
			// continue to move to target
			SCMoveToLastSeenOrHeard(TRUE,oCharacter);
		}
		else
		{
			SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, FALSE);
			if (SCDoStealthAndWander(oCharacter))
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
					if(SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS, oCharacter) || SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS_AVIAN, oCharacter))
					{
						SCPlayMobileAmbientAnimations(oCharacter);
					}
					else if(SCGetSpawnInCondition(CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS,oCharacter))
					{
						SCPlayImmobileAmbientAnimations(oCharacter);
					}
				}
			}
		}
	}
	else if (SCGetUseHeartbeatDetect(oCharacter))
	{
		if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat SCHenchDetermineCombatRound starting", GetFirstPC() ); }
		SCHenchDetermineCombatRound(OBJECT_INVALID,FALSE,FALSE,oCharacter);
		if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat SCHenchDetermineCombatRound ending", GetFirstPC() ); }
	}
	
	if(SCGetSpawnInCondition(CSL_FLAG_HEARTBEAT_EVENT,oCharacter))
	{
		SignalEvent(oCharacter, EventUserDefined(EVENT_HEARTBEAT));
	}
	
	CW_IntellectCorpse(oCharacter);
	//DEBUGGING// 
	if (DEBUGGING >= 3) { CSLDebug(  "CW_Heartbeat End", GetFirstPC() ); }
}
//void main(){}