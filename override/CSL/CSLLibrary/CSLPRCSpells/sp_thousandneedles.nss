//::///////////////////////////////////////////////
//:: Name 	Thousand Needles
//:: FileName sp_thous_ndls.nss
//:://////////////////////////////////////////////
/**@file Thousand Needles
Conjuration (Creation) [Evil]
Level: Pain 5, Clr 6
Components: V, S, M
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./levels)
Target: One living creature
Duration: 1 minute/level
Saving Throw: Fortitude partial
Spell Resistance: Yes

A thousand needles surround the subject and pierce
his flesh, worming through armor or any type of
protection, although creatures with damage reduction
are immune to this spell. The subject takes 2d6
points of damage immediately and takes a -4
circumstance penalty on attack rolls, saving throws,
skill checks, and ability checks for the rest of the
spell's duration. A successful Fortitude save reduces
damage to half and negates the circumstance penalty.

Material Component: A handful of needles all of
which have drawn blood.

Author: 	Tenjac
Created: 	5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_THOUSAND_NEEDLES; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nPenalty = 4;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iDamage = d6(2);
	//float fDur = (60.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	int iAdjustedDamage;
	int iSave;
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_THOUSAND_NEEDLES, oCaster);

	if (!HkResistSpell(OBJECT_SELF, oTarget))
	{
		//metamagic
		

		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			iDamage = 12;
		}

		if(nMetaMagic == METAMAGIC_EMPOWER)
		{
			iDamage += (iDamage/2);
		}

		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

		//Save
		iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster);
		iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
		if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
		{
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE && !CSLGetHasEffectType(oTarget,EFFECT_TYPE_DAMAGE_REDUCTION) )
			{
				effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
				eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
				eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
		/*
		if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			iDamage = iDamage/2;

			if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				return;
		}

		else
		{
			if(!CSLGetHasEffectType(oTarget,EFFECT_TYPE_DAMAGE_REDUCTION))
			{
				effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
				eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
				eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
		*/

		//Apply damage
		if ( iDamage > 0 )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





