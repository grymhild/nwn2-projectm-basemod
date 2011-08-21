//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLASHBURST; // put spell constant here
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
	effect eImpact = EffectVisualEffect(VFX_NONE);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	// Create needed effects.
	effect eDazzle = EffectLinkEffects(EffectAttackDecrease(1),
		EffectVisualEffect(VFX_IMP_STUN));
	effect eBlindness = EffectLinkEffects(EffectBlindness(),
		EffectVisualEffect(VFX_DUR_BLIND));

		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

			// Apply impact vfx.
			HkApplyEffectToObject(DURATION_TYPE_INSTANT,
				EffectVisualEffect(VFX_IMP_SONIC), oTarget);

			// Creatures are dazzled whether they save or not.
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, RoundsToSeconds(1) );

			// Let the creature make a will save, if it fails it's blinded.
			if (!HkResistSpell(OBJECT_SELF, oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF)))
			{
				// Determine the spell's duration, the duration can be empower,
				// maximized, or extended (since it's variable, empower/maximize
				// apply.
				int nRounds = HkApplyMetamagicVariableMods(d8(2), 16);
				float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(nRounds, SC_DURCATEGORY_ROUNDS) );
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
				
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDuration );
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
