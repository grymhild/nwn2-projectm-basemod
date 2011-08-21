/*
Undetectable alignment
Abjuration
Level: Brd 2, Clr 2, Pal 2
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature or object
Duration: 24 hours
Saving Throw: Will negates (object)
Spell Resistance: Yes (object)
Conceals the alignment of an object or a creature from all forms of divination.


*/
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNDETECTABLE_ALINGMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	//VFX alone cant be gotten later, so incrase & decrases a minor skill by 1 point
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