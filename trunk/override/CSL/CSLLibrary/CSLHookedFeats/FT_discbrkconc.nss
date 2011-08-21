//::///////////////////////////////////////////////
//:: Dissonant Chord - Break Concentration
//:: cmi_s2_brkconc
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: October 18, 2009
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_DISCHORD_BREAK_CONC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(30, SC_DURCATEGORY_DAYS) );
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, TRUE  );
	

	if (!GetHasSpellEffect(SPELLABILITY_DISCHORD_BREAK_CONC, oCaster))
	{
		effect eAOE = EffectAreaOfEffect(VFX_PER_BREAK_CONC, "", "", "", sAOETag);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_DISCHORD_BREAK_CONC, FALSE));
		DelayCommand(0.0f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget));
	}
	HkPostCast(oCaster);
}