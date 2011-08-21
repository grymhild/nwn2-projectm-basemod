/*
	----------------
	Sword of Conscience

	sp_swordconsc
	----------------

	25/2/05 by Stratovarius

Enchantment
Level: Clr 4, Rgr 4
Components: V, DF
Casting Time: 1 action
Range: Close.
Target: One Evil Creature.
Duration: Instantaneous
Saving Throw: Will Negates
Spell Resistance: Yes

The target creature takes Wisdom and Charisma damage equal to its Evil Power rating.

Creature/Object 	Evil Power
Evil creature 		HD / 5
Undead creature 	HD / 2
Evil elemental 	HD / 2
Evil outsider 		HD
Cleric of an evil deity 	Caster Level
*/
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SWORD_OF_CONSCIENCE; // put spell constant here
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
	
	

	

	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();

			int nRawStrength = 0;
	if ( GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL )
	{
			if( CSLGetIsOutsider(oTarget) )
				nRawStrength = GetHitDice(oTarget);
			else if( CSLGetIsUndead(oTarget) || CSLGetIsElemental(oTarget))
				nRawStrength = GetHitDice(oTarget)/2;
			else
				nRawStrength = GetHitDice(oTarget)/5;
			if(HkGetCasterLevel(oTarget,CLASS_TYPE_CLERIC) > nRawStrength)
			{
				nRawStrength = HkGetCasterLevel(CLASS_TYPE_CLERIC, oTarget);
			}
		}
		else
	{
	// End the spell, it only works on evils
	FloatingTextStringOnCreature("The Target is not evil, spell failed", oCaster, FALSE);
	return;
	}

	int nDC = HkGetSpellSaveDC(oTarget,OBJECT_SELF);
	int nCaster = HkGetCasterLevel(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
	if (!HkResistSpell(OBJECT_SELF, oTarget))
	{
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SCApplyAbilityDrainEffect( ABILITY_WISDOM, nRawStrength, oTarget, DURATION_TYPE_PERMANENT );
			SCApplyAbilityDrainEffect( ABILITY_CHARISMA, nRawStrength, oTarget, DURATION_TYPE_PERMANENT );
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}