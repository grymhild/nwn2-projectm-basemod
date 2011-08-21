/*
	sp_nondetection

	Abjuration
	Level: Rgr 4, Sor/Wiz 3, Trickery 3
	Components: V, S, M
	Casting Time: 1 standard action
	Range: Touch
	Target: Creature or object touched
	Duration: 1 hour/level
	Saving Throw: Will negates (harmless, object)
	Spell Resistance: Yes (harmless, object)
	The warded creature or object becomes difficult to detect by divination spells such as clairaudience/clairvoyance, locate object, and detect spells. Nondetection also prevents location by such magic items as crystal balls. If a divination is attempted against the warded creature or item, the caster of the divination must succeed on a caster level check (1d20 + caster level) against a DC of 11 + the caster level of the spellcaster who cast nondetection. If you cast nondetection on yourself or on an item currently in your possession, the DC is 15 + your caster level.
	If cast on a creature, nondetection wards the creature's gear as well as the creature itself.
	Material Component: A pinch of diamond dust worth 50 gp.

	By: Flaming_Sword
	Created: Oct 1, 2006
	Modified: Oct 5, 2006
*/
//#include "prc_sp_func"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NONDETECTION; // put spell constant here
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
	
	
	//int nCasterLevel = HkGetCasterLevel(oCaster);
	//int iSpellPower = HkGetSpellPower( oCaster, 30 ); 


	object oTarget = HkGetSpellTarget();
	int nMetaMagic = HkGetMetaMagicFeat();
	effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
	//VFX for start & end of the effect
	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
	//get duration

	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//apply the effect
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}