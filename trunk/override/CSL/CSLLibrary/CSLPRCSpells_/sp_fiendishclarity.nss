//::///////////////////////////////////////////////
//:: Name 	Fiendish Clarity
//:: FileName sp_fiend_clarity.nss
//:://////////////////////////////////////////////
/**@file Fiendish Clarity
Divination [Evil]
Level: Clr 7, Demonic 7, Sor/Wiz 7
Components: V, S
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/ level

The caster develops the senses of a powerful fiend.
He has darkvision to a range of 60 feet. The caster
can see in magical darkness as if it were normal
darkness. He can see invisible creatures and objects
as if he had a see invisibility spell cast on him.
The caster can detect good at will.

Author: 	Tenjac
Created: 	5/17/06
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
	int iSpellId = SPELL_FIENDISH_CLARITY; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = (600.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);



	itemproperty nDarkvis = ItemPropertyBonusFeat(FEAT_DARKVISION);
	effect eTrueSee = EffectTrueSeeing();
	itemproperty nDetGood = ItemPropertyBonusFeat(FEAT_DETECT_GOOD_AT_WILL);

	CSLSafeAddItemProperty(oCaster, nDarkvis, fDuration);
	CSLSafeAddItemProperty(oCaster, nDetGood, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrueSee, oCaster, fDuration);

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

