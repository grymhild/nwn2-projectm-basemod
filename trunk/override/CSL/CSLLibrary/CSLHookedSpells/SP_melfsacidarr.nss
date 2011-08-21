//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	An acidic arrow springs from the caster's hands
	and does 3d6 acid damage to the target.  For
	every 3 levels the caster has the target takes an
	additional 1d6 per round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"







void RunImpact(object oTarget, object oCaster, int iDamageType, int iMetaMagic)
{
	if (CSLGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW, oTarget, oCaster)) return;
	if (GetIsDead(oTarget)) return;
	int iDamage = HkApplyMetamagicVariableMods(d6(), 6);
	effect eLink = EffectVisualEffect( CSLGetHitEffectByDamageType(iDamageType) );
	eLink = EffectLinkEffects(eLink, EffectDamage(iDamage, iDamageType)); // flare up
	HkApplyEffectToObject (DURATION_TYPE_INSTANT, eLink, oTarget);
	DelayCommand(6.0f, RunImpact(oTarget, oCaster, iDamageType, iMetaMagic));
}


void main()
{
	//scSpellMetaData = SCMeta_SP_melfsacidarr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MELFS_ACID_ARROW;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool=SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool=SPELL_SUBSCHOOL_CREATION|SPELL_SUBSCHOOL_ELEMENTAL;
	if ( GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(CSLGetMax(1, HkGetSpellDuration( oCaster )/3)));
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iContinuousDamageEffect = HkGetShapeEffect( VFX_DUR_SPELL_MELFS_ACID_ARROW, SC_SHAPE_CONTDAMAGE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
		float fDist = GetDistanceToObject(oTarget);
		float fDelay = (fDist/25.0);
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE);
		if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
		{
			int bDoImpact = !GetHasSpellEffect(GetSpellId(), oTarget);
			effect eDur = ExtraordinaryEffect(EffectVisualEffect( iContinuousDamageEffect ));  // Set the VFX to be non dispelable, because the acid is not magic
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration); // Apply the VFX that is used to track the spells duration
			int iDamage = HkApplyMetamagicVariableMods(d6(3), 18);
			iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCH_RANGED );
			effect eDam = HkEffectDamage(iDamage, iDamageType);
			effect eVis = EffectVisualEffect(iHitEffect);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
			// ALREADY HAS SPELL, REAPPLIED VISUAL WILL KEEP RUNIMPACT FIRING
			if (bDoImpact) 
			{
				DelayCommand(6.0f, RunImpact(oTarget, oCaster, iDamageType, GetMetaMagicFeat()));
			}
		}
	}
	
	HkPostCast(oCaster);
}

