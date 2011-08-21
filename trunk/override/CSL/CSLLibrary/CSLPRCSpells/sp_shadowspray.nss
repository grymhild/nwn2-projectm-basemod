//#include "spinc_common"

//School: Illusion
//Area of Effect / Target: Small
//Save: Fortitude negates
//Spell Resistance: Yes
//You cause a multitude of ribbonlike shadows to explode outward in the
//target area. Creatures in the area take 2 points of strength
//damage, are dazed for 1 round, and suffer a -2 penalty to saves vs.
//fear effects. The fear penalty lasts for 1 round / level.

#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADOW_SPRAY; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	// Apply a burst visual effect at the target location.
	location lTarget = HkGetSpellTargetLocation();
//TODO: NEED VFX
	effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

	// Determine the spell's duration.
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);
	
	// Build all of the detrimental effectsd, any target that fails its save takes
	// 2 points of strength damage, is dazed for 1 round, and has it's save against
	// fear effects lowered by 2.
	//effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect eDaze = EffectDazed();
	effect eFear = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

			// Let the creature make a fort save, if it fails it's apply the
			// detrimental effects.
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF)))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				SCApplyAbilityDrainEffect( ABILITY_STRENGTH, 2, oTarget, DURATION_TYPE_PERMANENT );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1) );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration );
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
