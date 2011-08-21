//::///////////////////////////////////////////////
//:: Name 	Abyssal Might
//:: FileName sp_abyssal_mght.nss
//:://////////////////////////////////////////////
/**@file Abyssal Might
Conjuration (Summoning) [Evil]
Level: Blk 3, Clr 4, Demonologist 3, Sor/Wiz 4
Components: V, S, M, Demon
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster summons evil energy from the Abyss and
imbues himself with its might. The caster gains a
+2 enhancement bonus to Strength, Constitution,
and Dexterity. The caster's existing spell
resistance improves by +2.

Material Component: The heart of a dwarf child.

Author: 	Tenjac
Created: 	1/27/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ABYSSAL_MIGHT; // put spell constant here
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

	object oTarget = HkGetSpellTarget();
	int nAlignEvil = GetAlignmentGoodEvil(oCaster);
	int nAlignChaotic = GetAlignmentLawChaos(oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ABYSSAL_MIGHT, oCaster);

	if( CSLGetIsDemon(oTarget) )
	{
		int nBonus = HkApplyMetamagicVariableMods(2,3);

		//Str, Dex, Con increases
		effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBonus);
		effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nBonus);
		effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nBonus);

		//SR increase by 2... yippee
		effect eResist = EffectSpellResistanceIncrease(nBonus);

		//Some sort of VFX
		effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

		//Link 'em up
		effect eLink = EffectLinkEffects(eStr, eDex);
		eLink = EffectLinkEffects(eLink, eCon);
		eLink = EffectLinkEffects(eLink, eResist);
		eLink = EffectLinkEffects(eLink, eVis);

	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


		//Apply
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

