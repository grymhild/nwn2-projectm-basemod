//::///////////////////////////////////////////////
//:: Name 	Blinding Glory
//:: FileName sp_blnd_glory.nss
//:://////////////////////////////////////////////
/**@file Blinding Glory
Conjuration (Creation) [Good]
Level: Glory 9, Sor/Wiz 9
Components: V, S, M/DF
Casting Time: 1 hour
Range: Close (25 ft. + 5 ft./2 levels)
Area: 100-ft./level radius spread, centered on you
Duration: 1 hour/level
Saving Throw: None
Spell Resistance: No

A brilliant radiance spreads from you, brightly
illuminating the area. The light is similar to that
created by the daylight spell, but no magical
darkness counters or dispels it. Furthermore,
evil-aligned creatures are blinded within this light.

Blinding glory brought into an area of magical
darkness (or vice versa), including an utterdark
spell, is temporarily negated, so that the otherwise
prevailing light conditions exist in the overlapping
areas of effect.

Arcane Material Component: A polished rod of pure
silver.

Author: 	Tenjac
Created: 	6/13/06
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
	int iSpellId = SPELL_BLINDING_GLORY; // put spell constant here
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
	
	


	int nCasterLvl = HkGetCasterLevel(oCaster);
	effect eAOE = EffectAreaOfEffect(AOE_PER_BLNDGLORY);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eVis = EffectVisualEffect(VFX_FNF_SUNBEAM);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration);

	//Create an instance of the AOE Object using the Apply Effect function

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);

	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}