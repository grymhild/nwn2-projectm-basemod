/*
	sp_soulscour

	This spell deal 2d6 points of charisma damage
	and 1d6 points of wisdom damage. It then deals
	an additional 1d6 charisma damage 1 minute later.

	By: ???
	Created: ???
	Modified: Jul 3, 2006
*/
//#include "prc_sp_func"
#include "_CSLCore_Time"
#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_CSLCore_Combat"

//
// Does the secondary charisma drain that happens 1 minute after initial effect.
//
void DoSecondaryDrain(object oTarget, int nChaDrain)
{
	// Build the drain effect.
	/*effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
	eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));*/
	effect eVFX = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

	// Apply the damage and the damage visible effect to the target.
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
	SCApplyAbilityDrainEffect( ABILITY_CHARISMA, nChaDrain,oTarget, DURATION_TYPE_PERMANENT );
}

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return iTouch; 	//return TRUE if spell charges should be decremented
}
//#include "_HkSpell"
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SOULSCOUR; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------

	int nCasterLvl = nCasterLevel;
	int nDice = nCasterLvl;
	if (nDice > 5) nDice = 5;
	///int nPenetr = nCasterLvl + SPGetPenetr();

	int nTouchAttack;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		// Make touch attack, saving result for possible critical
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if (!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				// 2d6 cha drain, 1d6 wis drain.
				int nChaDrain = HkApplyMetamagicVariableMods(d6(2),6*2);
				nChaDrain = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nChaDrain, SC_TOUCH_RANGED, oCaster );
		
				int nWisDrain = HkApplyMetamagicVariableMods(d6(1),6*1);
				nWisDrain = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nWisDrain, SC_TOUCH_RANGED, oCaster );
		
				int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				if ( iSneakDamage > 0 )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
				}
				// Build the drain effect.
				/*effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
				eDebuff = EffectLinkEffects(eDebuff,
					EffectAbilityDecrease(ABILITY_WISDOM, nWisDrain));
				eDebuff = EffectLinkEffects(eDebuff,
					EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));*/
				effect eVFX = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

				// Apply the damage and the damage visible effect to the target.
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
				SCApplyAbilityDrainEffect( ABILITY_CHARISMA, nChaDrain, oTarget, DURATION_TYPE_PERMANENT );
				SCApplyAbilityDrainEffect( ABILITY_WISDOM, nWisDrain, oTarget, DURATION_TYPE_PERMANENT );

				// Target takes secondary 1d6 cha drain 1 minute later.
				nChaDrain = HkApplyMetamagicVariableMods(d6(1), 6);
				nChaDrain = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nChaDrain, SC_TOUCHSPELL_RANGED, oCaster );
				DelayCommand(CSLMinutesToSeconds(1), DoSecondaryDrain(oTarget, nChaDrain));

				// apply sneak damage if appropriate
				int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				if ( iSneakDamage > 0 )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
				}
			}
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}