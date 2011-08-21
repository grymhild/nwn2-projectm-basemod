//::///////////////////////////////////////////////
//:: Name 	Crushing Fist of Spite
//:: FileName sp_crush_fs.nss
//:://////////////////////////////////////////////
/**@Crushing Fist of Spite
Evocation [Evil, Force]
Level: Sor/Wiz 9
Components: V, S, M, Disease
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Area: 5-ft.-radius cylinder, 30 ft. high
Duration: 1 round/level
Saving Throw: Reflex half or Reflex negates (see text)
Spell Resistance: Yes

A fist of darkness appears 30 feet above the ground
and begins smashing down with incredible power.
All creatures and objects within the area take 1d6
points of damage per caster level (maximum 20d6).
A successful Reflex saving throw reduces damage by
half. Each round, as a free action, the caster can
direct the fist to another area within range, where
it smashes downward again. It continues to attack
the same area unless otherwise directed.

The fist does not need to strike the ground. It can
attack airborne targets as well. Airborne targets
that succeed at a Reflex save take no damage and
are forcibly ejected from the spell's area.

Material Component: A severed hand from a
good-aligned humanoid cleric.

Disease Component: Festering anger.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Summon"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CRUSHING_FIST_OF_SPITE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	
	location lLoc = HkGetSpellTargetLocation();
	int nCasterLvl = HkGetCasterLevel();
			
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	

	// Apply summon and vfx at target location.
	CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lLoc);

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature("prc_crush_fist"), lLoc, fDuration);

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}