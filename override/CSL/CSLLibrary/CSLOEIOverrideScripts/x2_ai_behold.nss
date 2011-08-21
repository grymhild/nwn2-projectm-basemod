//::///////////////////////////////////////////////
//:: Custom Beholder AI
//:: x2_ai_behold
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This is the Hordes of the Underdark campaign
	Mini AI run on the beholders.

	It does not use any spells assigned to the
	beholder, if you want to make a custom beholder
	you need to deactivate this AI by removing the
	approriate variable from your beholder creature
	in the toolset

	Short overview:

	Beholder will always use its eyes, unless

	a) If threatened in melee, it will try to move away or float away
		to the nearest waypoint tagged X2_WP_BEHOLDER_TUNNEL

	b) If threatened in melee and below 1/5 hp it will always try to float

	b) If affected by antimagic itself, it melee attack

	c) If target is affected by petrification, it will melee attack

	Logic for eye ray usage are in the appropriate spellscripts


	setting X2_BEHOLDER_AI_NOJUMP to 1 will prevent the beholders from
	jumping, even if there are jump points nearby




*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-21
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Monster"
//#include "_SCInclude_AI"
#include "_SCInclude_AI_Advanced"

#include "x2_inc_switches"


void BehClearFleeState()
{
	DeleteLocalInt(OBJECT_SELF,"X2_BEHOLDER_AI_FLEEING");
}

void BehClearState()
{
		ClearAllActions();
}

int TryToLevitateAway(object oTargetFrom, int bCloseIn = FALSE)
{
	if (GetLocalInt(OBJECT_SELF,"X2_BEHOLDER_AI_NOJUMP"))
	{
	return TRUE;
	}

	object oExit;

	if (bCloseIn)
	{
	oExit   = GetNearestObjectByTag("X2_WP_BEHOLDER_TUNNEL",oTargetFrom);
	}
	else
	{
	oExit   = GetNearestObjectByTag("X2_WP_BEHOLDER_TUNNEL");
	}

	if (!GetIsObjectValid(oExit))
	{
	return FALSE;
	}
	float fDist = GetDistanceBetween(oExit,oTargetFrom);
	int bJump;

	if (bCloseIn)
	{
	if ((fDist >= 8.0f) && (fDist <= 20.0f))
	{
		bJump = TRUE;
	}
	}
	else
	{
	if ((fDist >= 10.0f) && (fDist <= 40.0f))
	{
		bJump = TRUE;
	}
	}

	if (!bJump)
	{
	if (bCloseIn)
	{
		oExit   = GetNearestObjectByTag("X2_WP_BEHOLDER_TUNNEL",oTargetFrom,2);
	}
	else
	{
		oExit   = GetNearestObjectByTag("X2_WP_BEHOLDER_TUNNEL",OBJECT_SELF,2);
	}

	if (!GetIsObjectValid(oExit))
	{
		return FALSE;
	}
	else
	{
		fDist = GetDistanceBetween(oExit,oTargetFrom);
		if (bCloseIn)
		{
			if ((fDist >= 6.0f) && (fDist <= 15.0f))
			{
				bJump = TRUE;
			}
		}
		else
		{
			if ((fDist >= 8.0f) && (fDist <= 50.0f))
			{
				bJump = TRUE;
			}
		}
	}

	}

	if (bJump)
	{
	if (!GetIsDead(OBJECT_SELF))
	{
		int bImmortal = GetImmortal(OBJECT_SELF);
		int nAni = GetLocalInt(oExit,"X2_L_BEH_USE_ANI");
		if (nAni ==0)
		{
			nAni = 1;
		}
		effect eAppear = EffectDisappearAppear(GetLocation(oExit), nAni) ;
		eAppear = SupernaturalEffect(eAppear);
		object oSelf = OBJECT_SELF;
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAppear,oSelf,4.0f);
		// make the beholder enter combat again
		DelayCommand(4.1f, ActionCastSpellAtObject(736,oTargetFrom,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
	}
	return TRUE;
	}
	else
	{
	return FALSE;
	}


	return TRUE;
}


// 1 - Attack and use rays
// 2 - Attack and dont use rays
// 4 - Flee
// 5 - Flee immediatly
int  GetBeholderTactics(object oTarget)
{
	int nCheck = GetLocalInt(OBJECT_SELF, "X2_BEHOLDER_AI_NOJUMP");
	int nRet  = FALSE;

	// we go melee against petrified targets
	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_PETRIFY ) == TRUE)
	{
		nRet  = 6;
	}

	// if the target is down below 10 hp and AC is below 23, we go into melee as well
	if ( GetCurrentHitPoints(oTarget) < 10 && GetAC(oTarget) < 23)
	{

	nRet  = 1;
	}

	if (GetHasSpellEffect(727,OBJECT_SELF)) // antimagic
	{
	nRet = 2;
	}
	else if (SCGetIsMeleeAttacker(oTarget))
	{
		int nHP = GetCurrentHitPoints(OBJECT_SELF);

		// some attack randomization
		if (nHP > FloatToInt(GetMaxHitPoints(OBJECT_SELF)*0.8) && GetHitDice(oTarget) <= GetHitDice(OBJECT_SELF)+d4())
		{

			nRet =1; // attack
		}
		else if (nHP < GetMaxHitPoints(OBJECT_SELF)/3)
		{

		if (d3()>1)
		{
		if(nCheck == 1)
	{
		nRet = 4;
	}
	else
	{
			nRet =5; //fly;
	}
		}
		else
		{
			nRet = 1;
		}
		}
		else if (nHP < FloatToInt(GetMaxHitPoints(OBJECT_SELF)*0.5))
		{

		nRet =4; //run;

		}
	}
	else if (GetDistanceBetween(oTarget,OBJECT_SELF)>25.0 && GetCurrentHitPoints(OBJECT_SELF)> GetMaxHitPoints(OBJECT_SELF)/2 )
	{

	nRet = 3;
	}

	if( SCGetIsRangedAttacker(oTarget) && GetCurrentHitPoints(OBJECT_SELF) < GetMaxHitPoints(OBJECT_SELF)/3 )
	{
		if (d2()==1)
		{
		nRet = 5;
		}
		else
		{
		nRet = 0;
		}
	}



	return nRet;
}

void main()
{
	//return;
	//The following two lines should not be touched
	object oIntruder = GetCreatureOverrideAIScriptTarget();


	ClearCreatureOverrideAIScriptTarget();
	SetCreatureOverrideAIScriptFinished();

	/*if (GetLocalString(OBJECT_SELF,"UID") =="")
	{
				SetLocalString(OBJECT_SELF,"UID",RandomName());
	}
	string UID =   GetLocalString(OBJECT_SELF,"UID");

	if (GetLocalInt(GetModule(),"TEST")>0 )
	{
	if (GetLocalInt(GetModule(),"TEST") ==2)
	{
		if (!GetLocalInt (OBJECT_SELF,"IN_DEBUG") ==0)
		{
			return;
		}
	}
	SetLocalInt(GetModule(),"TEST",2);
	SpawnScriptDebugger();
	SetLocalInt (OBJECT_SELF,"IN_DEBUG",TRUE);
	}
	*/



	// ********************* Start of custom AI script ****************************


	// Here you can write your own AI to run in place of DetermineCombatRound.
	// The minimalistic approach would be something like
	//
	// TalentFlee(oTarget); // flee on any combat activity


	if(CSLGetAssociateState(CSL_ASC_IS_BUSY))
	{
		return;
	}

	if(SCBashDoorCheck(oIntruder)) {return;}

	// * BK: stop fighting if something bizarre that shouldn't happen, happens
	if (SCEvaluationSanityCheck(oIntruder, CSLGetFollowDistance()) == TRUE)
	{
		return;
	}

	int nDiff = SCGetCombatDifficulty();
	SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);


	if (GetIsObjectValid(oIntruder) == FALSE)
	{
		oIntruder = SCAcquireTarget();
	}

	if (GetIsObjectValid(oIntruder) == FALSE)
	{

		oIntruder = SCGetNearestSeenOrHeardEnemyNotDead();
	}


	if (GetIsObjectValid(oIntruder) == FALSE)
	{
		oIntruder = GetLastAttacker();
	}


	if (GetIsObjectValid(oIntruder) && GetIsDead(oIntruder) == TRUE)
	{
	return;
	}


	if (__SCInCombatRound() == TRUE)
	{
	return;
	}

	__SCTurnCombatRoundOn(TRUE);


	//SpeakString("AI Target: " + GetName(oIntruder));

	if(GetIsObjectValid(oIntruder))
	{


	// * Will put up things like Auras quickly
	if(SCTalentPersistentAbilities())
	{

	__SCTurnCombatRoundOn(FALSE);
		return;
	}

	if(SCTalentHealingSelf() == TRUE)
	{

		__SCTurnCombatRoundOn(FALSE);
		return;
	}


	if(SCTalentUseProtectionOnSelf() == TRUE)
	{
		__SCTurnCombatRoundOn(FALSE);
		return;
	}


	//Used for Potions of Enhancement and Protection
	if(SCTalentBuffSelf() == TRUE)
	{
		__SCTurnCombatRoundOn(FALSE);
		return;
	}

	if(SCTalentAdvancedProtectSelf() == TRUE)
	{
		__SCTurnCombatRoundOn(FALSE);
		return;
	}




	// From here things start to get cheesy...

	int nMelee = GetBeholderTactics(oIntruder);

	if (nMelee>0)
	{

		if (nMelee == 2) // do not use ray attacks
		{
			BehClearFleeState();     // If we decided to attack, no reason to flee
			ActionAttack(oIntruder);
		}
		else if (nMelee ==3)
		{
			BehClearFleeState(); // If we decided to attack, no reason to flee
			if (!TryToLevitateAway(oIntruder,TRUE))
			{
			BehClearState();
					ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
			}
		}
		else if (nMelee ==4)
		{
			if (d2() ==1)
			{
					BehClearState();
					ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
			}
			else
			{
					int nFlee = GetLocalInt(OBJECT_SELF,"X2_BEHOLDER_AI_FLEEING") ;
					if (nFlee <d2())
					{
						BehClearState();
				ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
				BehClearState();
						ActionMoveAwayFromObject(oIntruder,TRUE, 13.0f);
						nFlee ++;
						SetLocalInt(OBJECT_SELF,"X2_BEHOLDER_AI_FLEEING",nFlee);
					}
					else
					{
						BehClearFleeState();
						if (!TryToLevitateAway(oIntruder))
						{
							BehClearState();
							ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
						}else
						{
							CSLTurnToFaceObject(oIntruder);
							__SCTurnCombatRoundOn(FALSE);
							return;
						}

					}

			}

		}
		else if (nMelee ==5)
		{

			BehClearFleeState();
			if (!TryToLevitateAway(oIntruder))
			{
					BehClearState();
					ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
			}
			else
			{
					CSLTurnToFaceObject(oIntruder);
					__SCTurnCombatRoundOn(FALSE);
				return;

			}

		}
	else if (nMelee ==6)
		{
		if(d6()>1)
		{
			BehClearState();
			ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
		}
		else
		{
			BehClearState();
			ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
		}
	}
		else
		{

			// can not get attack to work properly in the same round, so I do 2 rays for 1 attack
			if(d3()>1)
			{
					BehClearFleeState();
					ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
			}
			else
			{
					BehClearState();
					BehClearFleeState();
					ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
			}
		}

	}
	else
	{
			BehClearState();
			ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);

	}

		__SCTurnCombatRoundOn(FALSE);
		return;
	}
	else
	{
		BehClearState();
	ActionCastSpellAtObject(736,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
	}
		__SCTurnCombatRoundOn(FALSE);

	//This is a call to the function which determines which
	// way point to go back to.
	ClearAllActions(TRUE);
	SetLocalObject(OBJECT_SELF, "NW_GENERIC_LAST_ATTACK_TARGET", OBJECT_INVALID);
	SCWalkWayPoints();

}