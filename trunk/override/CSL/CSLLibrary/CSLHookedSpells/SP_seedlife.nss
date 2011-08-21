//::///////////////////////////////////////////////
//:: Seed of Life
//:: cmi_s0_seedlife
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEED_LIFE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int iSpellPower = (HkGetSpellPower( oCaster, 20 )/2)+10;

	int nHeal = d4(iSpellPower);

	effect eHeal = EffectHeal(nHeal);
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId(), FALSE));
	CSLRemoveEffectByType(oTarget, EFFECT_TYPE_WOUNDING);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}