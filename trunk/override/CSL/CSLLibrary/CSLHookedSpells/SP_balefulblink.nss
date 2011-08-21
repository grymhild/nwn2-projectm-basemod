//::///////////////////////////////////////////////
//:: Baleful Blink
//:: cmi_s0_baleblink
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BALEFUL_BLINK;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	object oTarget = HkGetSpellTarget();
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL))
	{		
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DISPLACEMENT);
		effect eMiss = EffectMissChance(50);
		effect eASF = EffectArcaneSpellFailure(50);
		effect eLink = EffectLinkEffects(eVis, eMiss);
		eLink = EffectLinkEffects(eLink, eASF);

		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	
	HkPostCast(oCaster);
}