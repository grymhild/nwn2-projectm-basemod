//::///////////////////////////////////////////////
//:: Name 	Chaav's Laugh
//:: FileName sp_chaavs_lgh.nss
//:://////////////////////////////////////////////
/**@file Chaav's Laugh
Enchantment (Compulsion)[Good, Mind-Affecting]
Level: Cleric 5, Joy 5
Components: V
Casting Time: 1 standard action
Range: 40ft
Area: 40-ft-radius spread centered on you
Duration: 1 minute/level
Saving Throw: Will negates
Spell Resistance: Yes

You release a joyous, boistrous laugh that
strengthens the resolve of good creatures and
weakens the resolve of evil creatures.

Good creatures within the spell's area gain the
following benefits for the duration of the spell:
a +2 morale bonus on attack rolls an saves against
fear effects. plus temporary hit points equal to
1d8 + caster level(to a maximum of 1d8 +20 at level
20).

Evil creatures within the spell's are that fail a
Will save take a -2 morale penalty on attack rolls
and saves against fear effects for the duration of
the spell.

Creatures must beable to hear the laugh to be
affected by the spell. Creatures that are neither
good nor evil are anaffected by Chaav's Laugh.

Author: 	Tenjac
Created: 	7/10/06
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
	int iSpellId = SPELL_CHAAVS_LAUGH; // put spell constant here
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

	//


	
	location lLoc = GetLocation(oCaster);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC;
	int nAlign;
	int nMetaMagic = HkGetMetaMagicFeat();
	int nModify = 2;
	//float fDur = (60.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nModify = 3;
	}

	effect eVilLink = EffectLinkEffects(EffectAttackDecrease(nModify, ATTACK_BONUS_MISC), EffectSavingThrowDecrease(SAVING_THROW_ALL, nModify, SAVING_THROW_TYPE_FEAR));
	effect eGoodLink = EffectLinkEffects(EffectAttackIncrease(nModify, ATTACK_BONUS_MISC), EffectSavingThrowIncrease(SAVING_THROW_ALL, nModify, SAVING_THROW_TYPE_FEAR));
			eGoodLink = EffectLinkEffects(eGoodLink, EffectTemporaryHitpoints(d8(1) + CSLGetMin(20, nCasterLvl)));

	while(GetIsObjectValid(oTarget))
	{
		nAlign = GetAlignmentGoodEvil(oTarget);
		nDC = HkGetSpellSaveDC(oCaster,oTarget);

		if(!CSLGetHasEffectType(oTarget,EFFECT_TYPE_DEAF))
		{

			if (nAlign == ALIGNMENT_EVIL)
			{
				//SR
				if(!HkResistSpell(oCaster, oTarget ))
				{
					//Save
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVilLink, oTarget, fDuration);
					}
				}
			}

			if(nAlign == ALIGNMENT_GOOD)
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGoodLink, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





