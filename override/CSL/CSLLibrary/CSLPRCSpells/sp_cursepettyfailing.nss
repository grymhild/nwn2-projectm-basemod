/////////////////////////////////////////////////////////////////////
//
// Curse of Petty Failing - Target takes a -2 penalty to attacks
// and saves.
//
/////////////////////////////////////////////////////////////////////
//#include "spinc_common"
//#include "_CSLCore_Time"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURSE_OF_PETTY_FAILING; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nCasterLevel = HkGetCasterLevel();
	object oTarget = HkGetSpellTarget();
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Get the target and raise the spell cast event.
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		// Determine the spell's duration, taking metamagic feats into account.
		
		
		// Determine the save bonus.
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		int nBonus = 2 + (nCasterLvl / 6);
		if (nBonus > 5) nBonus = 5;

		// Apply the curse and vfx.
		effect eCurse = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
		eCurse = EffectLinkEffects(eCurse, EffectAttackDecrease(2));
		eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
		eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, fDuration );
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
