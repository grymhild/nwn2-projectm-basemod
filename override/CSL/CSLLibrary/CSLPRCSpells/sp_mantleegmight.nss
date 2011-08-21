/*
	sp_megmht

	Mangle of Egregious Might - +4 bonus to stats, attacks,
	saves, AC for 10 min / level.

	By: ???
	Created: ???
	Modified: Jul 2, 2006
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
#include "_HkSpell"

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
	int iSpellId = SPELL_MANTLE_OF_EGREG_MIGHT; // put spell constant here
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
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);
	// Boost stats, AC, attacks, stats, and saves by 4, and add the buff visual effect.
	// Shouldn't stack with itself. ~ Lock.
	if (!GetHasSpellEffect(SPELL_MANTLE_OF_EGREG_MIGHT, oTarget))
	{
		effect eList = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
		eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
		eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
		eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4));
		eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_WISDOM, 4));
		eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
		eList = EffectLinkEffects(eList, EffectACIncrease(4));
		eList = EffectLinkEffects(eList, EffectAttackIncrease(4));
		eList = EffectLinkEffects(eList, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4));
		eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		//SetLocalInt(oTarget, "EgragiousM", 2); Does not seem to be used anywhere else - Ornedan
		// Get duration, 10 min / level unless extended.
		int iDuration = HkGetSpellDuration( oCaster, 30 );
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
		// Build the list of fancy visual effects to apply when the spell goes off.
		effect eVisList = EffectLinkEffects(EffectVisualEffect(VFX_IMP_AC_BONUS), EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
		// Apply effects and VFX to target
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration );
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisList, oTarget);
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}