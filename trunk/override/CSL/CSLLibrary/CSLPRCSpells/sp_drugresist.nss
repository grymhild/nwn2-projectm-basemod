//::///////////////////////////////////////////////
//:: Name 	Drug Resistance
//:: FileName sp_drug_resist.nss
//:://////////////////////////////////////////////
/**@file Drug Resistance
Enchantment
Level: Clr 1, Sor/Wiz 1
Components: V, M
Casting Time: 1 action
Range: Touch
Target: One living creature
Duration: 1 hour/level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

The creature touched is immune to the possibility
of addiction to drugs. He still experiences the
negative and positive effects of drugs during the
spell's duration. This spell does not free the
target from the effects of an addiction already
incurred. If the spell ends before the effects of
a drug wear off, the normal chance for addiction
applies.

Material Component: Three drops of pure water.

Author: 	Tenjac
Created: 	04/28/06
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
	int iSpellId = SPELL_DRUG_RESISTANCE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = HoursToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eMarker = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMarker, oTarget, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




