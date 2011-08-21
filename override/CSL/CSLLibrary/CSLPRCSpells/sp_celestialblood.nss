//::///////////////////////////////////////////////
//:: Name 	Celestial blood
//:: FileName sp_celest_bld.nss
//:://////////////////////////////////////////////
/**@file Celestial Blood
Abjuration [Good]
Level: Apostle of peace 6, Clr 6, Pleasure 6
Components: V, S, M
Casting Time: 1 round
Range: Touch
Target: Non-evil creature touched
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: Yes (harmless)

You channel holy power to grant the subject some of
the protection enjoyed by celestial creatures. The
subject gains resistance 10 to acid, cold, and
electricity, a +4 bonus on saving throws against
poison, and damage reduction 10/evil.

Material Component: A vial of holy water, with
which you anoint the subject's head.

Author: 	Tenjac
Created: 	6/16/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CELESTIAL_BLOOD; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	//float fDur = (60.0f * nCasterLevel);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
	{

		effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 0), EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0));
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0));
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_POISON));

		//Can't do DR 10/evil
		eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO));

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}