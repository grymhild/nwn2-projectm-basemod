//#include "spinc_common"
//#include "_CSLCore_Time"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VISCID_GLOB; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	object oTarget = HkGetSpellTarget();

	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		int CasterLvl = HkGetCasterLevel();

		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
			// Make touch attack, saving result for possible critical
			int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				// Impact vfx.
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);

				if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_SPELL))
				{
					// Target cannot move no matter what.
					effect eEffect = EffectCutsceneImmobilize();
					eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN));
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration );
					// If target is medium or smaller may not take any actions either.
					if (CSLGetSizeCategory(oTarget) <= CREATURE_SIZE_MEDIUM)
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oTarget, fDuration,TRUE,-1,CasterLvl);
					}
				}
				else
				{
					// Show that the target made it's save.
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget);
				}
			}
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
