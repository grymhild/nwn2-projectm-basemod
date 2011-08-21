//::///////////////////////////////////////////////
//:: Visage of the Deity
//:: nx_s0_visage.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Components: V, S
	Range: Personal
	Duration: 1 round/level
	
	Caster gains:
	+4 CHA (enhancement bonus; doesn't stack with similar)
	
	If Good:
	Resistance 10 to acid, cold, electricity
	
	If Neutral (with respect to good & evil):
	Resistance 15 to acid and electricity
	
	If Evil:
	Resistance 10 to cold and fire
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 06/28/2007: Add Lesser Visage aura VFX.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VISAGE_OF_THE_DEITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	switch (nAlign)
	{
		case ALIGNMENT_EVIL:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_EVIL;
			break;
		case ALIGNMENT_GOOD:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_GOOD;
			break;
		case ALIGNMENT_NEUTRAL:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_NONE;
			break;
	}
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
	effect eAcid;
	effect eCold;
	effect eElec;
	effect eFire;
	effect eGood;
	effect eEvil;
	effect eNeut;
	effect eGoodVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect eEvilVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect eNeutVis = EffectVisualEffect(VFX_HIT_AOE_TRANSMUTATION);
	effect eDurVis = EffectVisualEffect(VFX_DUR_SPELL_LESSER_VISAGE);
	float fDuration = RoundsToSeconds(HkGetSpellDuration(oCaster));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	if (GetIsObjectValid(oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
		if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
		{
			eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
			eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
			
			eGood = EffectLinkEffects(eAcid, eCold);
			eGood = EffectLinkEffects(eGood, eElec);
			eGood = EffectLinkEffects(eGood, eCha);
			eGood =   EffectLinkEffects(eGood, eDurVis);
			
			HkApplyEffectToObject(iDurType, eGood, oCaster, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eGoodVis, oCaster);
		}
		else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL)
		{
			eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
			
			eEvil = EffectLinkEffects(eCold, eFire);
			eEvil = EffectLinkEffects(eEvil, eCha);
			eEvil = EffectLinkEffects(eEvil, eDurVis);
			
			HkApplyEffectToObject(iDurType, eEvil, oCaster, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEvilVis, oCaster);
		}
		else
		{
			eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 15);
			eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 15);
			
			eNeut = EffectLinkEffects(eAcid, eElec);
			eNeut = EffectLinkEffects(eNeut, eCha);
			eNeut = EffectLinkEffects(eNeut, eDurVis);
			
			HkApplyEffectToObject(iDurType, eNeut, oCaster, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eNeutVis, oCaster);
		}
	}
	HkPostCast(oCaster);
}
	

