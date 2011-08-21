//::///////////////////////////////////////////////
//:: Name 	Diamond Spray
//:: FileName sp_dmnd_spray
//:://////////////////////////////////////////////
/**@file Diamond Spray
Evocation [Good]
Level: Sanctified 4
Components: V, S, M
Casting Time: 1 standard action
Range: 60 ft.
Area: Cone-shaped burst
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

A blast of diamond-like shards springs from your
hand and extends outward in a glittering cone. The
cone dazzles evil creatures in the area for 2d6
rounds. The spell also deals 1d6 points of damage
per caster level (maximum 10d6). The damage
affects only evil creatures. A successful Reflex
save reduces the damage by half but does not
negate the dazzling effect.

Material Component: Diamond dust worth at least 100 gp.

Author: 	Tenjac
Created: 	6/11/06
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
	int iSpellId = SPELL_DIAMOND_SPRAY; // put spell constant here
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
	int nDC;
	int nMetaMagic = HkGetMetaMagicFeat();
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	//float fDur = RoundsToSeconds(d6(2));
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d6(2), SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	
	//VFX
	//effect eVis = EffectVisualEffect(?????);
	//SPApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

	//make sure it's not the PC
	if(oTarget == oCaster)
	{
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}

	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(oCaster, oTarget ))
		{
			int nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
			

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				nDC = HkGetSpellSaveDC(oCaster,oTarget);

				if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
				{
					nDam = nDam/2;
				}

				//Apply appropriate damage
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

				//Dazzled = -1 to Attack, Spot, and search
				effect eDazzle = EffectLinkEffects(EffectAttackDecrease(1), EffectSkillDecrease(SKILL_SPOT, 1));
				eDazzle = EffectLinkEffects(eDazzle, EffectSkillDecrease(SKILL_SEARCH, 1));

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
}




