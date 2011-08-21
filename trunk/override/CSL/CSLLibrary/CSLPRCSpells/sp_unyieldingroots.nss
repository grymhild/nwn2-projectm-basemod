/*
	sp_unyieldroots

	The target you touch grow thick tree roots that
	anchor him to the ground and provide him with
	life-sustaining healing. The creature can't move
	but gains immunity to Bigby's Forceful Hand,
	Earthquake, Poison, Negative level (as the
	Restoration spell ) and healing up 30 point of
	damage per round. The Target gets a +4 to Fort
	and Will saves, but -4 to Ref saves.

	By: ???
	Created: ???
	Modified: Jul 2, 2006
*/
//#include "prc_sp_func"

#include "_HkSpell"

int GetIsSupernaturalCurse(effect eEff)
{
	object oCreator = GetEffectCreator(eEff);
	if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
		return TRUE;
	return FALSE;
}

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
		
	

	return TRUE; 	//return TRUE if spell charges should be decremented
}
*/

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNYIELDING_ROOTS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	effect eHold = EffectCutsceneImmobilize();
	effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eBad = GetFirstEffect(oTarget);
	//Search for negative effects
	while(GetIsEffectValid(eBad))
	{
		if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
			GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
			GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
			GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
			{
				//Remove effect if it is negative.
				if(!GetIsSupernaturalCurse(eBad))
				RemoveEffect(oTarget, eBad);
			}
		eBad = GetNextEffect(oTarget);
	}

	//Link Entangle and Hold effects
	effect eLink = EffectLinkEffects(eHold, eEntangle);
	eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND));
	eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_EARTHQUAKE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_AC_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ATTACK_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SKILL_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
	eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_POISON));
	eLink = EffectLinkEffects(eLink,EffectRegenerate(30,6.0));

	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT,4);
	eSave = EffectLinkEffects(eSave,EffectSavingThrowIncrease(SAVING_THROW_WILL,4));
	eSave = EffectLinkEffects(eSave,EffectSavingThrowDecrease(SAVING_THROW_REFLEX,4));

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, fDuration );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration  );
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}