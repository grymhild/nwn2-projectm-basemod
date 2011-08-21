//::///////////////////////////////////////////////
//:: Name 	Devil's Eye
//:: FileName sp_devils_eye.nss
//:://////////////////////////////////////////////
/**@file Devil's Eye
Divination [Evil]
Level: Blk 2, Clr 3, Diabolic 2, Sor/Wiz 3
Components: V, S
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 1 minute/level

The caster gains the visual acuity of a devil. He
can see not only in darkness, but also in magical
darkness, with a range of 30 feet.

Author: 	Tenjac
Created:
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
	int iSpellId = SPELL_DEVILS_EYE; // put spell constant here
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

	
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	effect eUltra = EffectUltravision();
	effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	effect eLink = EffectLinkEffects(eUltra, eVis);
	//float fDur = (60.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
	CSLSpellEvilShift(oCaster);
}

