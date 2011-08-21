//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLESSING_OF_BAHAMUT; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	object oTarget = HkGetSpellTarget();

	// Signal the spell cast at event
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);

	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);

	// DR 10/-.
	effect eStone = EffectDamageReduction(10, DAMAGE_POWER_ENERGY);
	eStone = EffectLinkEffects(eStone, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));

	// Get duration, 1 round / level unless extended.
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVFX = EffectVisualEffect(VFX_IMP_DEATH_WARD);

	// Remove existing effect, if any.
	//RemoveEffectsFromSpell(oTarget, HkGetSpellId());
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	// Apply effects and VFX to target
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, fDuration );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
