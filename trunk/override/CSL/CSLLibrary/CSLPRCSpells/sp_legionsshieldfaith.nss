/////////////////////////////////////////////////////////////////////
//
// Legion's Curse of Petty Failing - Target takes a -2 penalty to
// attacks and saves.
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
	int iSpellId = SPELL_LEGIONS_SHIELD_OF_FAITH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();

	// Determine the save bonus.
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	int nBonus = 2 + (nCasterLvl / 6);
	if (nBonus > 5) nBonus = 5;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	// Determine the spell's duration, taking metamagic feats into account.
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// Declare the spell shape, size and the location. Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);

			float fDelay = CSLGetSpellEffectDelay(lTarget, oTarget);

			// Apply the curse and vfx.
			effect eBuff = EffectACIncrease(nBonus, AC_DEFLECTION_BONUS);
			eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration ));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget));
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
