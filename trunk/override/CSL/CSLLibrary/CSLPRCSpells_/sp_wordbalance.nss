//#include "spinc_common"
//#include "_CSLCore_Time"


#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_SCInclude_BarbRage"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WORD_OF_BALANCE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	// Apply a burst visual effect at the target location.
	location lTarget = HkGetSpellTargetLocation();
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), lTarget);

	// Build effects
	effect eDeath = EffectDeath();
	eDeath = EffectLinkEffects(eDeath, EffectVisualEffect(VFX_IMP_DEATH_L));
	effect eParalyzed = EffectParalyze();
	eParalyzed = EffectLinkEffects(eParalyzed, EffectVisualEffect(VFX_DUR_PARALYZED));

	// Determine the spell's duration.
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_GARGANTUAN);
	
	int nCasterLevel = HkGetCasterLevel();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			//SPRaiseSpellCastAt(oTarget);

			// Apply effects as follows, based on differences between caster's level
			// and target creature's hit dice.
			// up to caster level : slowed 1 round
			// up to caster level - 1 : 2d6 str drain for 2d4 rounds
			// up to caster level - 5 : paralyzed for 1d10 minutes
			// up to caster level - 10 : killed
			// effects are cumulative.
			int nHitDice = GetHitDice(oTarget);
			if (nHitDice <= nCasterLevel - 10)
			{
				SCDeathlessFrenzyCheck(oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
			}

			// No point in doing anything else if we killed the target, but even
			// if we apply the effect they could be immune.
			if (!GetIsDead(oTarget))
			{
				if (nHitDice <= nCasterLevel - 5)
				{
					// Determine duration (base 1d10 minutes) taking metamagic into
					// account.
					int nMinutes = HkApplyMetamagicVariableMods(d10(),10);
					float fDuration = HkApplyMetamagicDurationMods(HkApplyDurationCategory(nMinutes, SC_DURCATEGORY_MINUTES));

					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyzed, oTarget, fDuration );
				}

				if (nHitDice <= nCasterLevel - 1)
				{
					// Determine duration (base 1d10 minutes) taking metamagic into
					// account.
					int nRounds = HkApplyMetamagicVariableMods(d4(2),8);
					float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(nRounds));

					// Roll 2d6 str drain and apply it to the target, along with impact
					// vfx.
					int nStrDrain = HkApplyMetamagicVariableMods(d6(2), 12);
					/*HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,
						EffectAbilityDecrease(ABILITY_STRENGTH, nStrDrain), oTarget, fDuration,TRUE,-1,nCasterLevel);*/
					SCApplyAbilityDrainEffect( ABILITY_STRENGTH, nStrDrain, oTarget, DURATION_TYPE_TEMPORARY, fDuration, TRUE, -1, nCasterLevel);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
				}

				if (nHitDice <= nCasterLevel)
				{
					// Slow the target for 1 round.
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLevel);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);
				}
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
