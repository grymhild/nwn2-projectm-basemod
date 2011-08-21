//#include "spinc_common"
//#include "_CSLCore_Time"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId =  SPELL_LOWER_SR; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		// Let the target attempte to make a fort save. (good luck since there is a penalty equal to the
		// caster's level on the save).
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF) + nCasterLvl, SAVING_THROW_TYPE_SPELL))
		{

			// Generate a SR decrease for the caster level, up to a max of 15.
			int nSRReduction = nCasterLvl;
			if (nSRReduction > 15) nSRReduction = 15;
			effect eSR = EffectLinkEffects(
				EffectSpellResistanceDecrease(nSRReduction),
				EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSR, oTarget, fDuration );
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

