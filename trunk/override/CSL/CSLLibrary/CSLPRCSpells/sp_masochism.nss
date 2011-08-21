//::///////////////////////////////////////////////
//:: Name 	Masochism
//:: FileName sp_masochism.nss
//:://////////////////////////////////////////////
/**@file Masochism
Enchantment [Evil]
Level: Asn 3, Blk 3, Clr 3, Sor/Wiz 2
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 1 round/level

For every 10 points of damage the caster takes in a
given round, he gains a +1 luck bonus on attack
rolls, saving throws, and skill checks made in
the following round. The more damage the caster
takes, the greater the luck bonus. It's possible to
get a luck bonus in multiple rounds if the caster
takes damage in more than one round during the spell's
duration.

Material Component: A leather strap that has been
soaked in the caster's blood.

Author: 	Tenjac
Created: 	6/13/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void MasochLoop(object oCaster, int nHP, int nCounter);
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASOCHISM; // put spell constant here
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
	
	int nCounter = HkGetCasterLevel(oCaster);
	int nHP = GetCurrentHitPoints(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();

	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		nCounter += nCounter;
	}

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oCaster);

	MasochLoop(oCaster, nHP, nCounter);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
	CSLSpellEvilShift(oCaster);
}

void MasochLoop(object oCaster, int nHP, int nCounter)
{
	if(nCounter > 0)
	{
		int nHPChange = (nHP - GetCurrentHitPoints(oCaster));
		nHP = GetCurrentHitPoints(oCaster);
		int nBonus = nHPChange/10;

		effect eLink = EffectAttackIncrease(nBonus);
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, 6.0f);

		nCounter--;

		DelayCommand(6.0f, MasochLoop(oCaster, nHP, nCounter));
	}
}