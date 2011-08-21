//::///////////////////////////////////////////////
//:: Name 	Augment Familiar
//:: FileName sp_aug_famil.nss
//:://////////////////////////////////////////////
/**@file Augment Familiar
Transmutation
Level: Sor/Wiz 2, Hexblade 1
Components: V,S
Casting Time: 1 action
Range: Personal
Target: Your familiar
Duration: 1 round/level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

This spell grants your familiar a +4 enhancement bonus
to Strength, Dexterity and Constitution, damage
reduction 5/magic, and a +2 resistance bonus on
saving throws.

**/

/////////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date: 	8.9.2006
/////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AUGMENT_FAMILIAR; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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

	//


	object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oFamiliar, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oCaster,FALSE, SPELL_AUGMENT_FAMILIAR, oCaster);

	
	if(!GetIsObjectValid(oFamiliar))
	{
		FloatingTextStringOnCreature("Your familiar is not present.", oCaster, FALSE);
		
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
		return;
	}

	effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
			eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
			eBuff = EffectLinkEffects(eBuff, EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE, 0));
			eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));


	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oFamiliar, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}