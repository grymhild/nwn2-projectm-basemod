//::///////////////////////////////////////////////
//:: Epic Spell: Greater Spell Resistance
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_GR_SP_RE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_GR_SP_RE))
	{
		object oTarget = HkGetSpellTarget();
		effect eSR = EffectSpellResistanceIncrease(35);
		effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eDur2 = EffectVisualEffect(249);
		effect eLink = EffectLinkEffects(eSR, eDur);
		eLink = EffectLinkEffects(eLink, eDur2);
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELL_RESISTANCE, FALSE));
		//Apply VFX impact and SR bonus effect
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(20) );
	}
	HkPostCast(oCaster);
}
