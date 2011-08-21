/** @file
* @brief Include File for Healing Spells
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//::///////////////////////////////////////////////
//:: _SCInclude_Healing.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Include file for Healing  #include "_SCInclude_Healing"
*/
//:://////////////////////////////////////////////
// ChazM 1/2/07 Added Placeholder effect for CSLEffectFatigue()
// ChazM 1/8/07 removed CSLEffectFatigue(), changed includes

#include "_HkSpell"

void SCspellsHealOrHarmTarget(object oTarget, int nDamageTotal, int vfx_impactNormalHurt, int vfx_impactUndeadHurt, int vfx_impactHeal, int iSpellId, int bIsHealingSpell=TRUE, int bHarmTouchAttack=TRUE);

/*
int SCGetCureDamageTotal(object oTarget, int iDamage, int nMaxExtraDamage, int nMaximized, int iSpellId);
void SCspellsCure(int iDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int iSpellId);
void SCDoHealing(object oTarget, int nDamageTotal, int vfx_impactHeal);
void SCDoHarming (object oTarget, int nDamageTotal, int iDamageType, int vfx_impactHurt, int bTouchAttack);

// used by Mass Heal/Mass Harm
int SCHealHarmObject( object oTarget, effect eVis, effect eVis2, int iCasterLevel, int iSpellId );
int SCHealHarmFaction( int nMaxToHealHarm, effect eVis, effect eVis2, int iCasterLevel, int iMetaMagic );
int SCHealHarmNearby( int nMaxToHealHarm, effect eVis, effect eVis2, int iCasterLevel, int iMetaMagic );
void SCCurePC(object oPC, object oTarget, int nHeal = 0);
*/

// Used in Alcohol
void SCCurePC(object oPC, object oTarget, int nHeal = 0)
{
	int nEffect = VFX_IMP_HEALING_M;
	nHeal += GetSkillRank(SKILL_HEAL, oPC);
	
	if (GetHasFeat(FEAT_AUGMENT_HEALING, oPC)) { nHeal += 5; }
	
	if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oPC)) { nHeal += 5; }
	
	nHeal = CSLGetMin(35, nHeal) / 2; // max of 25
	if (!GetIsInCombat(oPC))  // NOT IN COMBAT
	{
		object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
		if (oCreature==OBJECT_INVALID || GetDistanceBetween(oPC, oCreature) > 25.0)  // NO NEARBY ENEMIES
		{
			nHeal *= 2;
			nEffect = VFX_IMP_HEALING_L;
			
			CSLRemoveEffectByType( oTarget, EFFECT_TYPE_WOUNDING);
		}
	}
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), oTarget);
}


int SCGetCureDamageTotal(object oTarget, int iDamage, int nMaxExtraDamage, int nMaximized, int iSpellId)
{
	int nExtraDamage = HkGetSpellPower( OBJECT_SELF ); //GetCasterLevel(OBJECT_SELF); // * figure out the bonus damage

	if (nExtraDamage > nMaxExtraDamage)
	{
		nExtraDamage = nMaxExtraDamage;
	}

	// * if low or normal difficulty is treated as MAXIMIZED
	if( GetIsPC(GetFactionLeader(oTarget)) && (GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES) )
	{
			iDamage = nMaximized + nExtraDamage;
	}
	else
	{
			iDamage = iDamage + nExtraDamage;
	}

	int iMetaMagic = HkGetMetaMagicFeat();
	//Make metamagic checks
	if (iMetaMagic == METAMAGIC_MAXIMIZE)
	{
		// iDamage = 8 + nExtraDamage;
		iDamage = nMaximized + nExtraDamage;
		// * if low or normal difficulty then MAXMIZED is doubled.
		if(GetIsPC(GetFactionLeader(oTarget)) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
		{
			iDamage = iDamage + nMaximized;
		}
	}
	
	// 8/9/06 - BDF-OEI: added the GetSpellCastItem() check to the GetHasFeat() check to make sure that
	//    clerics with the healing domain power don't get a bonus when using a healin potion
	if ( iMetaMagic == METAMAGIC_EMPOWER || (GetHasFeat( FEAT_HEALING_DOMAIN_POWER ) && !GetIsObjectValid( GetSpellCastItem() )) )
	{
		iDamage = iDamage + (iDamage/2);
	}


	// JLR - OEI 06/06/05 NWN2 3.5
	if ( GetHasFeat(FEAT_AUGMENT_HEALING) && !GetIsObjectValid(GetSpellCastItem()) )
	{
			int nSpellLvl = HkGetSpellLevel(iSpellId);
			iDamage = iDamage + (2 * nSpellLvl);
	}
	
	// Drammel - 5/8/2009 Support for the Crusader's Delayed Damage Pool.
	if (GetLevelByClass(70, oTarget) > 0) //CLASS_TYPE_CRUSADER
	{
		object oToB = CSLGetDataStore(oTarget);
		if ((GetIsObjectValid(oToB)) && (GetLocalInt(oToB, "FuriousCounterstrike") == 0))
		{
			int nHp = GetCurrentHitPoints(oTarget);
			int nMaxHp = GetMaxHitPoints(oTarget);
			int nSurplus = nHp + iDamage;

			if (nSurplus > nMaxHp)
			{
				int nHeal = nMaxHp - nSurplus;

				SetLocalInt(oToB, "DDPoolCanHeal", 1);
				SetLocalInt(oToB, "DDPoolHealValue", nHeal);
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolCanHeal", 1));
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolHealValue", 0));
			}
		}
	}
	
	return (iDamage);
}


// SCspellsCure
//    Used by the 'cure' series of spells.
//    Will do max heal/damage if at normal or low difficulty.  Random rolls occur at higher difficulties.
// 8/9/06 - BDF-OEI: added the GetSpellCastItem() check to the GetHasFeat() check to make sure that
//    clerics with the healing domain power don't get a bonus when using a healin potion
//
// Heal spells typically do a random amount +1/level up to a max.
//
// Parameters:
// int iDamage       - base amount of damage to heal (or cause)
// int nMaxExtraDamage - an extra amount equal to the Caster's Level is applied, cappen by nMaxExtraDamage
// int nMaximized       - This is the max base amount.  (Do not include nMaxExtraDamage)
//  int vfx_impactHurt  - Impact effect to use for when a creature is harmed
//    int vfx_impactHeal   - Impact effect to use for when a creature is healed
//    int iSpellId      - The SpellID that is being cast (Spell cast event will be triggered on target).
void SCspellsCure(int iDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int iSpellId)
{
	object oTarget = HkGetSpellTarget();
	int nDamageTotal = SCGetCureDamageTotal(oTarget, iDamage, nMaxExtraDamage, nMaximized, iSpellId);
	int bIsHealingSpell=TRUE;
	int bHarmTouchAttack=TRUE;
	SCspellsHealOrHarmTarget(oTarget, nDamageTotal, vfx_impactHurt, vfx_impactHurt, vfx_impactHeal, iSpellId, bIsHealingSpell, bHarmTouchAttack);

}

// this could be a harm spell cast on undead or a heal spell cast on non-undead
void SCDoHealing(object oTarget, int nDamageTotal, int vfx_impactHeal)
{
	//Set the heal effect
	//eWound- Cure spells now remove the wounding effect, which causes targets to bleed out - PKM-OEI 09.06.06
	effect eHeal = EffectHeal(nDamageTotal);
	CSLRemoveEffectByType(oTarget, EFFECT_TYPE_WOUNDING);
	//Apply heal effect and VFX impact
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
	effect eVis2 = EffectVisualEffect(vfx_impactHeal);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
}

// this could be a harm spell cast on non-undead or a heal spell cast on undead
void SCDoHarming (object oTarget, int nDamageTotal, int iDamageType, int vfx_impactHurt, int bTouchAttack)
{
	if (bTouchAttack)
	{
		// Returns 0 on a miss, 1 on a hit, and 2 on a critical hit.
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch == TOUCH_ATTACK_RESULT_MISS )
		{
			return;
		}
		nDamageTotal = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDamageTotal, SC_TOUCHSPELL_MELEE );
	}

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
			
			nDamageTotal = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, nDamageTotal, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF );
			if ( nDamageTotal > 0 )
			{
				effect eDam = EffectDamage(nDamageTotal, iDamageType);
				//Apply the VFX impact and effects
				DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				effect eVis = EffectVisualEffect(vfx_impactHurt);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
			/*
			// Returns 0 if the saving throw roll failed, 1 if the saving throw roll succeeded and 2 if the target was immune
			
			int iSave = WillSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF);
			if (iSave != 2)
			{
				// successful save = half damage
				if  (iSave == 1)
				{
					nDamageTotal = nDamageTotal/2;
				}
				
				
				
				
			}
			*/
		}
	}
}


// This spell routes healing and harming out depending on whether we are undead or not.
void SCspellsHealOrHarmTarget(object oTarget, int nDamageTotal, int vfx_impactNormalHurt, int vfx_impactUndeadHurt, int vfx_impactHeal, int iSpellId, int bIsHealingSpell=TRUE, int bHarmTouchAttack=TRUE)
{
	int bHarmful = FALSE;
	
	if ( CSLGetIsImmuneToMagicalHealing( oTarget) )
	{
		return;
	}


	// abort for creatures immune to heal.
	if (GetLocalInt(oTarget, SCVAR_IMMUNE_TO_HEAL))
	{
		return;
	}

	int bIsUndead = ( CSLGetIsUndead( oTarget, TRUE ) );
	if (!bIsUndead) // target is normal folks.
	{
		if (bIsHealingSpell) // healing spell
		{
			SCDoHealing(oTarget, nDamageTotal, vfx_impactHeal);
		}
		else // harming spell
		{
			SCDoHarming(oTarget, nDamageTotal, DAMAGE_TYPE_NEGATIVE, vfx_impactNormalHurt, bHarmTouchAttack);
			bHarmful = TRUE;
		}
	}
	else // target is undead
	{
		if (bIsHealingSpell) // heal spell on undead harms
		{
			SCDoHarming(oTarget, nDamageTotal, DAMAGE_TYPE_POSITIVE, vfx_impactUndeadHurt, bHarmTouchAttack);
			bHarmful = TRUE;
		}
		else // harming spell on undead heals!
		{
			SCDoHealing(oTarget, nDamageTotal, vfx_impactHeal);
		}

	}

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, bHarmful));
}

//-----------------------------------------------------------------------------
// Heal / Harm Target
//-----------------------------------------------------------------------------
// Handler for The Heal Spell and Harm Spell
// Description: Heals/Harms the target for 10 hit points per level of the caster,
//              capped at 150.
//-----------------------------------------------------------------------------
void SCHealHarmTarget( object oTarget, int iCasterLevel, int iSpellId, int bIsHealingSpell, int bHarmTouchAttack = TRUE )
{
	int nHealAmt;
	
	if ( iSpellId == SPELL_MASS_HEAL || iSpellId == SPELLABILITY_WARPRIEST_MASS_HEAL )
	{
		nHealAmt = CSLGetWithinRange(10*iCasterLevel,0,250);
	}
	else
	{
		nHealAmt = CSLGetWithinRange(10*iCasterLevel, 0, 150);
	}
	//int bHarmTouchAttack = FALSE; //No touch attack is needed to zap people 
	//if (!bIsHealingSpell)
	// bHarmTouchAttack = TRUE;
	SCspellsHealOrHarmTarget(oTarget, nHealAmt, VFX_HIT_SPELL_INFLICT_6, VFX_IMP_HEALING_G, VFX_IMP_HEALING_X, iSpellId, bIsHealingSpell, bHarmTouchAttack);
}




// This won't effect oTarget unless it is a friendly non-undead or enemy undead
// returns TRUE if effecting Target, FALSE otherwise.
int SCHealHarmObject( object oTarget, effect eVis, effect eVis2, int iCasterLevel, int iSpellId )
{
	float fDelay = CSLRandomBetweenFloat();
	int nRacialType = GetRacialType(oTarget);
	int bIsHealingSpell = TRUE;
	int bRet = FALSE;
	
	if (( CSLGetIsUndead( oTarget )  && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		|| ( !CSLGetIsUndead( oTarget ) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF)))
	{
		bRet = TRUE;
		SCHealHarmTarget(oTarget, iCasterLevel, iSpellId, bIsHealingSpell, FALSE );
	} 
	return (bRet);

}

int SCHealHarmFaction( int nMaxToHealHarm, effect eVis, effect eVis2, int iCasterLevel, int iSpellId ) // returns the # HealHarmd
{
	int nNumEffected = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, bPCOnly );
	while ( GetIsObjectValid(oTarget) && nNumEffected < nMaxToHealHarm )
	{
	if ( !CSLGetIsUndead( oTarget ) )
	{
		SCHealHarmObject( oTarget, eVis, eVis2, iCasterLevel, iSpellId );
		nNumEffected++;
	}
		oTarget = GetNextFactionMember( OBJECT_SELF, bPCOnly );
	}

	return nNumEffected;
}


int SCHealHarmNearby( int nMaxToHealHarm, effect eVis, effect eVis2, int iCasterLevel, int iSpellId ) // returns the # HealHarmd
{
	int nNumEffected = 0;

	//Get first target in shape
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	while ( GetIsObjectValid(oTarget) && nNumEffected < nMaxToHealHarm )
	{
		if ( !GetFactionEqual( oTarget, OBJECT_SELF ) || CSLGetIsUndead( oTarget )) // We've already done faction characters
		{
			// this won't effect oTarget unless it is a friendly non-undead or enemy undead
			if (SCHealHarmObject( oTarget, eVis, eVis2, iCasterLevel, iSpellId ) == TRUE)
				nNumEffected++;
		}

			//Get next target in the shape
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	}

	return nNumEffected;
}

void CureObject(object oCaster, object oTarget, effect eVis, effect eVis2, int iDice, int iBonus) {
	int nHeal;
	effect eHeal;
	float fDelay = CSLRandomBetweenFloat();
	 
	if ( CSLGetIsUndead( oTarget, TRUE ) )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{        
				nHeal = HkApplyMetamagicVariableMods(d8(iDice) + iBonus, 8 * iDice + iBonus);
				nHeal = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, nHeal, oTarget, HkGetSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_NONE, oCaster );
				if ( nHeal > 0 )
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nHeal, DAMAGE_TYPE_POSITIVE), oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
	}
	else
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			if (GetHasFeat(FEAT_AUGMENT_HEALING) && !GetIsObjectValid(GetSpellCastItem()))
			{
				nHeal += 2 * HkGetSpellLevel(GetSpellId());
			}
			eHeal = EffectHeal(nHeal);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
		}
	}
}

int CureFaction(object oCaster, int nMaxToCure, effect eVis, effect eVis2, int iDice, int iBonus) {
	int nNumCured = 0;
	object oTarget = GetFirstFactionMember(oCaster, FALSE);
	while (GetIsObjectValid(oTarget) && nNumCured<nMaxToCure)
	{
		if (CSLPCIsClose(oCaster, oTarget, 25) && !CSLGetIsUndead( oTarget, TRUE ) )
		{
			CureObject(oCaster, oTarget, eVis, eVis2, iDice, iBonus);
			nNumCured++;
		}
		oTarget = GetNextFactionMember( oCaster, FALSE);
	}
	return nNumCured;
}


int CureNearby(object oCaster, int nMaxToCure, effect eVis, effect eVis2, int iDice, int iBonus)
{
	int nNumCured = 0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	while (GetIsObjectValid(oTarget) && nNumCured < nMaxToCure)
	{
		if (!GetFactionEqual(oTarget, oCaster) || CSLGetIsUndead( oTarget, TRUE ) ) // We've already done faction checks
		{
			CureObject(oCaster, oTarget, eVis, eVis2, iDice, iBonus);
			nNumCured++;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	}
	return nNumCured;
}

/*
void cmi_HealHarmNearby(effect eVis, effect eVis2, int nCasterLvl, int nSpellId )
{
    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
		// this won't effect oTarget unless it is a friendly non-undead or enemy undead
 		HealHarmObject( oTarget, eVis, eVis2, nCasterLvl, nSpellId );

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }
}
*/