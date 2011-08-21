//::///////////////////////////////////////////////
//:: Name 	Rouse
//:: FileName sp_rouse.nss
//:://////////////////////////////////////////////
/**@file Rouse
Enchantment (Compulsion) [Mind-Affecting]
Level: Beguiler 1, duskblade 1, sorcerer/wizard 1
Components: V,S
Casting Time: 1 standard action
Range: Close
Area 10-ft radius burst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

This spell has no effect on creatures that are
unconscious due to being reduced to negative hit
points or that have taken nonlethal damage in
excess of their current hit points.

**/
/////////////////////////////////////////////////
// Author: Tenjac
// Date: 	26.9.06
/////////////////////////////////////////////////

void RemoveSleep(object oTarget);
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ROUSE; // put spell constant here
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
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);

	while(GetIsObjectValid(oTarget))
	{
		RemoveSleep(oTarget);
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

void RemoveSleep(object oTarget)
{
	effect eTest = GetFirstEffect(oTarget);

	while(GetIsEffectValid(eTest))
	{
		if(eTest == EffectSleep())
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
}