//::///////////////////////////////////////////////
//:: Name 	Tongue of Baalzebul
//:: FileName sp_tng_baalz.nss
//:://////////////////////////////////////////////
/**@file Tongue of Baalzebul
Transmutation [Evil]
Level: Clr 1
Components: V, S, M, Drug
Casting Time: 1 full round
Range: Personal
Target: Caster
Duration: 1 hour/level

The caster gains the ability to lie, seduce and
beguile with devil's skill. He gains a +2 competence
bonus on Bluff, Diplomacy, and Gather information
checks.

Material Component: A tongue from any creature
capable of speech.

Drug Component: Mushroom powder.

Author: 	Tenjac
Created: 	5/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TONGUE_OF_BAALZEBUL; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nBonus = 2;
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = HoursToSeconds(nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	//if(is using mushroom powder)
	if(GetHasSpellEffect(SPELL_MUSHROOM_POWDER, oCaster))
	{
		//eval metamagic
		if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nBonus += (nBonus/2);
		}

		effect eLink = EffectSkillIncrease(SKILL_BLUFF, nBonus);
				eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DIPLOMACY, nBonus));

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}