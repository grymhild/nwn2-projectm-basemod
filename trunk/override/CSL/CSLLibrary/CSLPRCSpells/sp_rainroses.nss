//::///////////////////////////////////////////////
//:: Name 	Rain of Roses
//:: FileName sp_rain_rose.nss
//:://////////////////////////////////////////////
/**@file Rain of Roses
Evocation [Good]
Level: Drd 7
Components: V, S, M
Casting Time: 1 standard action
Range: Long (400 ft. + 40 ft./level)
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D)
Saving Throw: None (ability damage) and Fortitude
negates (sickening)
Spell Resistance: Yes

Red roses fall from the sky. Their sharp thorns
graze the flesh of evil creatures, dealing 1d4
points of temporary Wisdom damage per round. A
creature reduced to 0 Wisdom falls unconscious as
its mind succumbs to horrible nightmares. In
addition, the beautiful rose petals sicken evil
creatures touched by them; those that fail a
Fortitude save are sickened (-2 penalty on attack
rolls, weapon damage rolls, saving throws,
ability checks, and skill checks) until they
leave the spell's area. A successful Fortitude
save renders a creature immune to the sickening
effect of the roses, but not the ability damage
caused by their thorns.

Material Component: A red rose.

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
	int iSpellId = SPELL_RAIN_OF_ROSES; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	effect eAOE = EffectAreaOfEffect(VFX_AOE_RAIN_OF_ROSES);
	location lLoc = GetLocation(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	//float fDur = RoundsToSeconds(nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Create AoE
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}