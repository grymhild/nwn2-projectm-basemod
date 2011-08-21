//::///////////////////////////////////////////////
//:: Reduce Person, Greater
//:: NX2_S0_GreatReducePer.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Based on Enlarge Person script (opposite, obviously)
	by Jesse Reynolds (JLR - OEI).
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 09/05/2008
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REDUCE_PERSON_GREATER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	float fDuration = TurnsToSeconds(nCasterLvl)*10; // longer duration than the usual

	//	Make sure the target is humanoid
	if ( !CSLGetIsHumanoid(oTarget)  )
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget ); //"*Failure-Invalid Target*"
		return;
	}

	// Metamagic?
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// check and make sure you aren't already shrank!

	// if you're enlarged, this will cancel that buff.

	// DO I need this??
	CSLRemoveEffectSpellIdGroup(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId, SPELL_REDUCE_PERSON, SPELL_REDUCE_ANIMAL, SPELL_REDUCE_PERSON_MASS, SPELL_REDUCE_PERSON_GREATER );
	// RemovePermanencySpells(oTarget);

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_REDUCE_PERSON); // visual effect

	effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eAtk = EffectAttackIncrease(1, ATTACK_BONUS_MISC);
	effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
		// effect eDmg = EffectDamageDecrease(3, DAMAGE_TYPE_MAGICAL);
	effect eScale = EffectSetScale(0.63);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eStr, eDex);
	eLink = EffectLinkEffects(eLink, eAtk);
	eLink = EffectLinkEffects(eLink, eAC);
	// 	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eScale);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = EffectLinkEffects(eLink, eVis);

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

	DelayCommand(1.5, HkApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
	
	HkPostCast(oCaster);
}

