//::///////////////////////////////////////////////
//:: Name 	Storm of Shards
//:: FileName sp_strm_shard.nss
//:://////////////////////////////////////////////
/**@file Storm of Shards
Evocation [Good]
Level: Sanctified 6
Components: V, S, Sacrifice
Casting Time: 1 standard action
Range: 0 ft.
Area: 80-ft.-radius spread
Duration: Instantaneous
Saving Throw: Fortitude negates (blinding),
Reflex half (shards)
Spell Resistance: Yes

Shards of heavenly light rain down from above.
Evil creatures within the spell's area that fail
a Fortitude save are blinded permanently. The
light shards also slice the flesh of evil
creatures, dealing 1d6 points of damage per caster
level (maximum 20d6). A successful Reflex save
halves the damage, which is of divine origin.

Sacrifice: 1d3 points of Strength drain.

Author: 	Tenjac
Created: 	6/28/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STORM_OF_SHARDS; // put spell constant here
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
	location lLoc = GetLocation(oCaster);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nAlign;
	int nMetaMagic = HkGetMetaMagicFeat();
	int iSpellPower = HkGetSpellPower( oCaster, 20 ); 

	//VFX
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc);

	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			nAlign = GetAlignmentGoodEvil(oTarget);

			if(nAlign == ALIGNMENT_EVIL)
			{
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DIVINE))
				{
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget);
				}

				int nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				
				

				if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_DIVINE))
				{
					nDam = nDam/2;
				}

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_DIVINE), oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	CSLSpellGoodShift(oCaster);
	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d3(1), 1);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


