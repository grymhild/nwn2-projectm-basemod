//::///////////////////////////////////////////////
//:: Name 	Apocalypse from the Sky
//:: FileName sp_apoc_sky.nss
//:://////////////////////////////////////////////
/**@file Apocalypse from the Sky
Conjuration (Creation) [Evil]
Level: Corrupt 9
Components: V, S, M, Corrupt
Casting Time: 1 day
Range: Personal
Area: 10-mile radius/level, centered on caster
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

The caster calls upon the darkest forces in all
existence to rain destruction down upon the land.
All creatures and objects in the spell's area take
10d6 points of fire, acid, or sonic damage
(caster's choice). This damage typically levels
forests, sends mountains tumbling, and wipes out
entire populations of living creatures. The caster
is subject to the damage as well as the corruption
cost.

Material Component: An artifact, usually one of good
perverted to this corrupt use.

Corruption Cost: 3d6 points of Constitution damage
and 4d6 points of Wisdom drain. Just preparing this
spell deals 1d3 points of wisdom damage, with another
1d3 points of Wisdom damage for each day it remains
among the caster's prepared spells.

SPELL_APOCALYPSE_FROM_THE_SKY_ACID
SPELL_APOCALYPSE_FROM_THE_SKY_FIRE
SPELL_APOCALYPSE_FROM_THE_SKY_SONIC

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"
//#include "prc_spell_const"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_APOCALYPSE_FROM_THE_SKY; // put spell constant here
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

	//define vars
	object oArea = GetArea(oCaster);
	int nDam;
	int nDamType;
	int nSpell = HkGetSpellId();

	//Handle damage types
	if(nSpell == SPELL_APOCALYPSE_FROM_THE_SKY_FIRE)
	{
		nDamType = DAMAGE_TYPE_FIRE;
	}

	if(nSpell == SPELL_APOCALYPSE_FROM_THE_SKY_ACID)
	{
		nDamType = DAMAGE_TYPE_ACID;
	}

	if(nSpell == SPELL_APOCALYPSE_FROM_THE_SKY_SONIC)
	{
		nDamType = DAMAGE_TYPE_SONIC;
	}

	object oObject = GetFirstObjectInArea(oArea);

	//Loop
	while(GetIsObjectValid(oObject))
	{
		nDam = d6(10);
		effect eDam = HkEffectDamage(nDam, nDamType);

		//Apply
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObject);

		oObject = GetNextObjectInArea();
	}

	CSLSpellEvilShift(oCaster);

	//Corruption cost
	int nDam1 = d6(3);
	int nDam2 = d6(4);

	SCApplyCorruptionCost(oCaster, ABILITY_CONSTITUTION, nDam1, 0);
	SCApplyCorruptionCost(oCaster, ABILITY_WISDOM, nDam2, 1);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

