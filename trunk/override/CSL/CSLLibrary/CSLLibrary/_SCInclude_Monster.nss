/** @file
* @brief Include File for Monsters and Monster spells and feats
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




#include "_HkSpell"


const int BEHOLDER_RAY_DEATH = 1;
const int BEHOLDER_RAY_TK = 2;
const int BEHOLDER_RAY_PETRI= 3;
const int BEHOLDER_RAY_CHARM_MONSTER = 4;
const int BEHOLDER_RAY_SLOW = 5;
const int BEHOLDER_RAY_WOUND = 6;
const int BEHOLDER_RAY_FEAR = 7;
const int BEHOLDER_RAY_CHARM_PERSON = 8;
const int BEHOLDER_RAY_SLEEP = 9;
const int BEHOLDER_RAY_DISINTIGRATE = 10;

struct beholder_target_struct
{
			object oTarget1;
			int nRating1;
			object oTarget2;
			int nRating2;
			object oTarget3;
			int nRating3;
			int nCount;
};


/*
int   GetAntiMagicRayMakesSense ( object oTarget );
void  OpenAntiMagicEye          ( object oTarget );
void  CloseAntiMagicEye         ( object oTarget );
int   BehGetTargetThreatRating  ( object oTarget );
int   BehDetermineHasEffect     ( int nRay, object oCreature );
void  BehDoFireBeam             ( int nRay, object oTarget );
*/

struct beholder_target_struct GetRayTargets ( object oTarget );





//------------------------------------------------------------------------------
//Keith Warner
//   Do a mind blast
//   nHitDice - HitDice/Caster Level of the creator
//   iDC      - DC of the Save to resist
//   nRounds  - Rounds the stun effect holds
//   fRange   - Range of the EffectCone
//------------------------------------------------------------------------------
void SCDoMindBlast(int iDC, int iDuration, float fRange)
{
	int nStunTime;
	float fDelay;

	location lTargetLocation = GetSpellTargetLocation();
	object oTarget;
	effect eCone;
	//effect eVis = EffectVisualEffect(VFX_IMP_SONIC); // NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SONIC );

	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);

	while(GetIsObjectValid(oTarget))
	{
			int nApp = GetAppearanceType(oTarget);
			int bImmune = FALSE;
			//----------------------------------------------------------------------
			// Hack to make mind flayers immune to their psionic attacks...
			//----------------------------------------------------------------------
			if (nApp == 413 ||nApp== 414 || nApp == 415)
			{
				bImmune = TRUE;
			}

			if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF && !bImmune )
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				// already stunned
				if (GetHasSpellEffect(GetSpellId(),oTarget))
				{
						// only affects the targeted object
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
					int iDamage;
					if (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>0)
					{
							iDamage = d6(GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)/3);
					}
					else
					{
							iDamage = d6(GetHitDice(OBJECT_SELF)/2);
					}
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage), oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND), oTarget);
				}
				else if (WillSave(oTarget, iDC) < 1)
				{
					//Calculate the length of the stun
					nStunTime = iDuration;
					//Set stunned effect
					eCone = EffectStunned();
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, RoundsToSeconds(nStunTime)));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);
	}
}


// * Gelatinous Cube Paralyze attack
int  SCDoCubeParalyze(object oTarget, object oSource, int iSaveDC = 16)
{
	if (GetIsImmune(oTarget,IMMUNITY_TYPE_PARALYSIS) )
	{
			return FALSE;
	}

	if (FortitudeSave(oTarget,iSaveDC, SAVING_THROW_TYPE_POISON,oSource) == 0)
	{
		effect ePara =  EffectParalyze(iSaveDC, SAVING_THROW_FORT);
		effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
		ePara = EffectLinkEffects(eDur,ePara);
		ePara = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),ePara);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePara,oTarget,RoundsToSeconds(3+d3())); // not 3 d6, thats not fun
		return TRUE;
	}
	else
	{
		effect eSave = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oTarget);
	}
	return FALSE;
}


// --------------------------------------------------------------------------------
// GZ: Gel. Cube special abilities
// --------------------------------------------------------------------------------
void SCEngulfAndDamage(object oTarget, object oSource)
{

	if (ReflexSave(oTarget, 13 + GetHitDice(oSource) - 4, SAVING_THROW_TYPE_NONE,oSource) == 0)
	{

		FloatingTextStrRefOnCreature(84610,oTarget); // * Engulfed
		int iDamage = d6(1);

		effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_ACID);
		effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
		if (!GetIsImmune(oTarget,IMMUNITY_TYPE_PARALYSIS) )
		{
			if (SCDoCubeParalyze(oTarget,oSource,16))
			{
					FloatingTextStrRefOnCreature(84609,oTarget);
			}
		}

	} else
	{
		effect eSave = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oTarget);
	}
}


//=========================================================================
// Functions
//=========================================================================



//::///////////////////////////////////////////////
//:: SCGetDragonFearDC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Adding a function, we were using two different
	sets of numbers before. Standardizing it to be
	closer to 3e.
	iAge - hit dice
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
int SCGetDragonFearDC(int iAge)
{
	//hmm... not sure what's up with all these nCount variables, they're not
	//actually used... so I'm gonna comment them out

	int iDC = 13;
//    int nCount = 1;
	//Determine the duration and save DC
	//wyrmling meant no change from default, so we don't need it
/*
	if (iAge <= 6) //Wyrmling
	{
			iDC = 13;
			nCount = 1;
	}
	else
*/
	if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDC = 15;
//        nCount = 2;
	}
	else if (/*iAge >= 10 &&*/ iAge <= 12) //Young
	{
			iDC = 17;
//        nCount = 3;
	}
	else if (/*iAge >= 13 &&*/ iAge <= 15) //Juvenile
	{
			iDC = 19;
//        nCount = 4;
	}
	else if (/*iAge >= 16 &&*/ iAge <= 18) //Young Adult
	{
			iDC = 21;
//        nCount = 5;
	}
	else if (/*iAge >= 19 &&*/ iAge <= 21) //Adult
	{
			iDC = 24;
//        nCount = 6;
	}
	else if (/*iAge >= 22 &&*/ iAge <= 24) //Mature Adult
	{
			iDC = 27;
//        nCount = 7;
	}
	else if (/*iAge >= 25 &&*/ iAge <= 27) //Old
	{
			iDC = 28;
//        nCount = 8;
	}
	else if (/*iAge >= 28 &&*/ iAge <= 30) //Very Old
	{
			iDC = 30;
//        nCount = 9;
	}
	else if (/*iAge >= 31 &&*/ iAge <= 33) //Ancient
	{
			iDC = 32;
//        nCount = 10;
	}
	else if (/*iAge >= 34 &&*/ iAge <= 37) //Wyrm
	{
			iDC = 34;
//        nCount = 11;
	}
	else if (iAge > 37) //Great Wyrm
	{
			iDC = 37;
//        nCount = 12;
	}

	return iDC;
}


int GetAntiMagicRayMakesSense(object oTarget)
{
	int bRet = TRUE;
	int nType;
	
	object oNear = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oTarget);
	float fDistance = GetDistanceBetween(oTarget, oNear);

	effect eTest = GetFirstEffect(oTarget);

	if (!GetIsEffectValid(eTest))
	{
		int nMag = GetLevelByClass(CLASS_TYPE_WIZARD,oTarget) + GetLevelByClass(CLASS_TYPE_SORCERER,oTarget) + GetLevelByClass(CLASS_TYPE_BARD,oTarget) + GetLevelByClass(CLASS_TYPE_RANGER,oTarget) + GetLevelByClass(CLASS_TYPE_PALADIN,oTarget);
		// at least 3 levels of magic user classes... we better use anti magic anyway
		if (nMag < 4)
		{
			bRet = FALSE;
		}
	}
		
	else
	{
			while (GetIsEffectValid(eTest) && bRet == TRUE )
			{
				nType = GetEffectType(eTest);
				if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE  ||
					nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_PETRIFY  ||
					nType == EFFECT_TYPE_CHARMED  || nType == EFFECT_TYPE_CONFUSED ||
					nType == EFFECT_TYPE_FRIGHTENED || nType == EFFECT_TYPE_SLOW )
				{
					bRet = FALSE;
				}

				eTest = GetNextEffect(oTarget);
			}
	}
	
	if(fDistance > 30.0 || !GetIsInCombat(oNear))
	{
		bRet = FALSE;
	}
	if(GetHasSpellEffect(SPELL_LEAST_SPELL_MANTLE, oTarget) || GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) ||
		GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) || GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) ||
		GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) || GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) ||
		GetHasSpellEffect(SPELL_REGENERATE, oTarget) || GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oTarget) ||
		GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) || GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) ||
		GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_PREMONITION, oTarget) ||
		GetHasSpellEffect(SPELL_POLYMORPH_SELF, oTarget) || GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget) ||
		GetHasSpellEffect(SPELL_HEROISM, oTarget) || GetHasSpellEffect(SPELL_GREATER_HEROISM, oTarget) ||
		GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget) || GetHasSpellEffect(SPELL_SHADES_TARGET_CASTER, oTarget))
		{
			bRet = TRUE;
		}
	if (GetHasSpellEffect(727,oTarget)) // already antimagic
	{
			bRet = FALSE;
	}

	return bRet;
}


void OpenAntiMagicEye (object oTarget)
{
	if (GetAntiMagicRayMakesSense(oTarget))
	{
			ClearAllActions();
			ActionCastSpellAtObject(727 , HkGetSpellTarget(),METAMAGIC_ANY,TRUE,0, PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
	}
}

// being a badass beholder, we close our antimagic eye only to attack with our eye rays
// and then reopen it...
void CloseAntiMagicEye(object oTarget)
{
	//RemoveSpellEffects (727,OBJECT_SELF,oTarget);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, 727 );
}


// stacking protection
int BehDetermineHasEffect(int nRay, object oCreature)
{
	switch (nRay)
	{
		case BEHOLDER_RAY_FEAR :     if (CSLGetHasEffectType( oCreature, EFFECT_TYPE_FRIGHTENED ))
													return TRUE;

		case BEHOLDER_RAY_DEATH :    if (GetIsDead(oCreature))
													return TRUE;

		case BEHOLDER_RAY_CHARM_MONSTER:      if (CSLGetHasEffectType( oCreature, EFFECT_TYPE_CHARMED ))
													return TRUE;

		case BEHOLDER_RAY_SLOW:      if (CSLGetHasEffectType( oCreature, EFFECT_TYPE_SLOW))
													return TRUE;

		case BEHOLDER_RAY_PETRI:       if (CSLGetHasEffectType( oCreature, EFFECT_TYPE_PETRIFY ))
													return TRUE;
										
		case BEHOLDER_RAY_SLEEP:       if (CSLGetHasEffectType( oCreature, EFFECT_TYPE_SLEEP ))
													return TRUE;
	}

	return FALSE;
}


int BehGetTargetThreatRating(object oTarget)
{
	if (oTarget == OBJECT_INVALID)
	{
			return 0;
	}

	int nRet = 20;

	if (GetDistanceBetween(oTarget,OBJECT_SELF) <5.0f)
	{
			nRet += 5;
		
		if(GetHitDice(OBJECT_SELF) <= GetHitDice(oTarget) - 3)
		{
			nRet += 3;
		}
	}
	if (GetDistanceBetween(oTarget,OBJECT_SELF) >15.0f)
	{
			nRet += 3;
	}

	nRet += (GetHitDice(oTarget)-GetHitDice(OBJECT_SELF) /2);
	
	if (GetLevelByClass(CLASS_TYPE_FIGHTER, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_BARBARIAN, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_RANGER, oTarget) > 3)
	{
		nRet += 3;
	}
	if (GetLevelByClass(CLASS_TYPE_ROGUE, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_WARLOCK, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_BARD, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 3)
	{
		nRet += 4;
	}
	if (GetLevelByClass(CLASS_TYPE_CLERIC, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oTarget) > 3 ||
		GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oTarget) > 3)
	{
		nRet += 5;
	}

	if (GetPlotFlag(oTarget)) //
	{
			nRet -= 6 ;
	}

	if (GetMaster(oTarget)!= OBJECT_INVALID)
	{
			nRet -= 4;
	}

	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_PETRIFY ))
	{
			nRet -=10;
	}
	
	if (GetArcaneSpellFailure(oTarget) == 100)
	{
			nRet -=10;
	}
	
	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_SLEEP ))
	{
			nRet -=3;
	}
	
	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_FRIGHTENED ))
	{
			nRet -=5;
	}
	
	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_SLOW ))
	{
			nRet -=5;
	}

	if (GetIsDead(oTarget))
	{
			nRet = 0;
	}

	return nRet;

}


struct beholder_target_struct GetRayTargets(object oTarget)
{

	struct beholder_target_struct stRet;
	object oTarget1;
	object oTarget2;
	object oTarget3;
	int nTarget1;
	int nTarget2;
	int nTarget3;
	int nCount = 0;
	int nNth = 1;
	int nCheck = 0;
	if (oTarget != OBJECT_INVALID)
	{
		oTarget1 = oTarget;
			nCount ++;
			nTarget1 = BehGetTargetThreatRating(oTarget1);

			oTarget2 =  GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_TRUE,oTarget1,nNth);
			while(GetIsObjectValid(oTarget2) && nCheck != 1)
			{
			if(GetIsFriend(oTarget1, oTarget2))
			{
					nTarget2 = BehGetTargetThreatRating(oTarget2);
					nCount ++;
				nCheck = 1;
			}
			else
			{
				nNth++;
				oTarget2 =  GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_TRUE,oTarget1,nNth);
			}
			}
		nCheck=0;
		nNth=1;
			oTarget3 =  GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_TRUE,oTarget2,nNth);
			while(GetIsObjectValid(oTarget3) && nCheck != 1)
			{
			if(GetIsFriend(oTarget1, oTarget3))
			{
					nTarget3 = BehGetTargetThreatRating(oTarget3);
					nCount ++;
				nCheck = 1;
			}
			else
			{
				nNth++;
				oTarget3 =  GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_TRUE,oTarget2,nNth);
			}
			}
	}


	stRet.oTarget1 = oTarget1;
	stRet.nRating1 = nTarget1;
	if (oTarget2 != OBJECT_INVALID)
	{
			stRet.oTarget2 = oTarget2;
			stRet.nRating2 = nTarget2;
	}
	else
	{
			stRet.oTarget2 = oTarget1;
			stRet.nRating2 = nTarget1;
			nCount =2;
	}

	if (nCount ==3)
	{
			stRet.oTarget3 = oTarget3;
			stRet.nRating3 = nTarget3;
	}
	stRet.nCount =  nCount;


	return stRet;

}


void BehDoFireBeam(int nRay, object oTarget)
{

	// don't use a ray if the target already has that effect
	if (BehDetermineHasEffect(nRay,oTarget))
	{
			return;
	}

	int bHit   = CSLTouchAttackRanged( oTarget,FALSE, 0, TRUE )>0;
	int nProj;
	switch (nRay)
	{
			case BEHOLDER_RAY_DEATH: nProj = 776;
									break;
			case BEHOLDER_RAY_TK:    nProj = 777;
									break;
			case BEHOLDER_RAY_PETRI: nProj = 778;
									break;
			case BEHOLDER_RAY_CHARM_MONSTER: nProj = 779;
									break;
			case BEHOLDER_RAY_SLOW:  nProj = 780;
									break;
			case BEHOLDER_RAY_WOUND: nProj = 783;
									break;
			case BEHOLDER_RAY_FEAR:  nProj = 784;
									break;
		case BEHOLDER_RAY_CHARM_PERSON:  nProj = 785;
									break;
		case BEHOLDER_RAY_SLEEP:  nProj = 786;
									break;
		case BEHOLDER_RAY_DISINTIGRATE:  nProj = 787;
									break;

	}

	if (bHit)
	{
			ActionCastSpellAtObject(nProj,oTarget,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
	}
			else
	{
			location lFail = GetLocation(oTarget);
			vector vFail = GetPositionFromLocation(lFail);

			if (GetDistanceBetween(OBJECT_SELF,oTarget) > 6.0f)
			{

				vFail.x += IntToFloat(Random(3)) - 1.5;
				vFail.y += IntToFloat(Random(3)) - 1.5;
				vFail.z += IntToFloat(Random(2));
				lFail = Location(GetArea(oTarget),vFail,0.0f);

			}
			//----------------------------------------------------------------------
			// if we are fairly near, calculating a location could cause us to
			// spin, so we use the same location all the time
			//----------------------------------------------------------------------
			else
			{
					vFail.z += 0.8;
					vFail.y += 0.2;
					vFail.x -= 0.2;
			}
		object oIpoint = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lFail, FALSE, "beh_ip_ray_targ");
			ActionCastSpellAtObject(nProj,oIpoint,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
		DestroyObject(oIpoint, 1.0);
	}


}


/**
* Dragon Breath Weapon support which relates to some other code in this library
* @see SCDragonBreath
* @todo Move to a supporting library
* @replaces
*/
void SCPlayDragonBattleCry()
{
	if(d100() > 50)
	{
		PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
	}
	else
	{
		PlayVoiceChat(VOICE_CHAT_BATTLECRY2);
	}
}


/**
* Dragon Breath weapon support which relates to some other code in this library
* @param iDamageType
* @param VFXShape=SHAPE_SPELLCONE
* @param fRange=0.0
* @param iVFXImpact=VFX_NONE
* @param iVFXBreath=VFX_NONE
* @param sVFXBreath=""
* @see
* @replaces
*/
void SCDragonBreath( int iDamageType, int VFXShape=SHAPE_SPELLCONE, float fRange=0.0, int iVFXImpact=VFX_NONE, int iVFXBreath=VFX_NONE, string sVFXBreath="" )
{
	object oCaster = OBJECT_SELF;
	int iAge = GetHitDice(oCaster);
	int iDice = iAge;
	int iDC = 13 + iAge/2 + GetAbilityModifier( ABILITY_CONSTITUTION, oCaster);
	int iDamage;
	float fDelay;
	if (fRange==0.0) fRange=10.0 + iAge/2.0;
	int iSaveType = CSLGetSaveTypeByDamageType(iDamageType);
	effect eImpact = EffectVisualEffect(iVFXImpact);
	effect eBreath;
	SCPlayDragonBattleCry();
	PlayCustomAnimation(oCaster, "Una_breathattack01", 0, 0.7f);
	if (sVFXBreath!="") { // NWN2 EFFECT
		eBreath = EffectNWN2SpecialEffectFile(sVFXBreath);
		DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oCaster, 3.0f));
	} else if (iVFXBreath!=VFX_NONE) { // NWN1 BEAM
		eBreath = EffectVisualEffect(iVFXBreath);
		object oEndTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", CSLGetAheadLocation(oCaster, fRange));
		DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oEndTarget, 4.0f));
		DelayCommand(1.0f, DestroyObject(oEndTarget));
	}
	location lLocation = GetLocation(GetSpellTargetObject());
	object oTarget = GetFirstObjectInShape(VFXShape, fRange, lLocation, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if ( oTarget != oCaster && CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));

			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, d6(iDice), oTarget, iDC, iSaveType, oCaster );
	
			//if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, iSaveType))
			//{
			//	iDamage = iDamage/2;
			//	if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)) iDamage = 0;
			//}
			//else if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
			//{
			//	iDamage = iDamage/2;
			//}
			if (iDamage)
			{
				fDelay = GetDistanceBetween(oCaster, oTarget)/20.0f;
				eBreath = EffectDamage(iDamage, iDamageType);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, oTarget, 3.0 ));
				DelayCommand(fDelay+0.5, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, oTarget, 3.0 ));
				DelayCommand(fDelay+1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, oTarget, 3.0 ));
			}
		}
		oTarget = GetNextObjectInShape(VFXShape, fRange, lLocation, TRUE);
	}
}