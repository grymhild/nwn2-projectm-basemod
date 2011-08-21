//#include "spinc_common"
//#include "inc_utility"


#include "_HkSpell"
#include "_SCInclude_Summon"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPHERE_OF_ULTIMATE_DESTRUCTION; // put spell constant here
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
	
	

	// Calculate spell duration.
	int nCasterLvl = HkGetCasterLevel();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(CSLGetPreferenceSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
			fDuration = RoundsToSeconds(nCasterLvl*CSLGetPreferenceSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
	fDuration = HkApplyMetamagicDurationMods(fDuration);

	// Apply summon and vfx at target location.
	location lTarget = HkGetSpellTargetLocation();
		CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
		EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
		EffectSummonCreature("sp_sphereofud"), lTarget, fDuration);

	// Save the spell DC for the spell so the sphere can use it.
	int nSaveDC = HkGetSpellSaveDC(OBJECT_SELF,OBJECT_SELF);
	SetLocalInt(OBJECT_SELF, "SP_SPHEREOFUD_DC", nSaveDC);
}
