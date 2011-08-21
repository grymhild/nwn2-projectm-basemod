//#include "spinc_common"

//Duration: 1 round / level
//You cloak yourself in an aura that gives you a +1 bonus per 3 caster levels
//(maximum +5) on saving throws against spells and spell like abilities,
//and you gain electricity resistance 10.

#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ILYYKURS_MANTLE; // put spell constant here
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
		
	object oTarget = HkGetSpellTarget();

	// Signal the spell cast at event
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);

	int nCasterLevel = HkGetCasterLevel();

	int nIncrease = nCasterLevel / 3;
	if (nIncrease > 5) nIncrease = 5;
	effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, nIncrease,
		SAVING_THROW_TYPE_SPELL);
	eBuff = EffectLinkEffects(eBuff, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_GLOW_WHITE));

	// Get duration, 1 hour / level unless extended.
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVFX = EffectVisualEffect(VFX_IMP_HEAD_ELECTRICITY);

	// Remove existing effect, if any.
	//RemoveEffectsFromSpell(oTarget, HkGetSpellId());
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );

	// Apply effects and VFX to target
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
