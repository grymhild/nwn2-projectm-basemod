//:://////////////////////////////////////////////
//:: FileName: "ss_ep_champvalor"
/* 	Purpose: Champion's Valor - grants the target immunity to mind-affecting
		spells, knockdown, sneak attacks, and critical hits for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_CHAMP_V;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_CHAMP_V))
	{
		object oTarget = HkGetSpellTarget();
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		int nDuration = nCasterLvl / 4;
		if (nDuration < 5)
		nDuration = 5;
		float fDuration = TurnsToSeconds(nDuration);
		if(CSLGetPreferenceSwitch("PNPChampionsValor"))
		{
			fDuration = HoursToSeconds(20);
		}
		effect eImm1 = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
		effect eImm2 = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
		effect eImm3 = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eImm4 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		effect eVis = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
		effect eVis2 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR );
		effect eLink = EffectLinkEffects(eImm1, eImm2);
		eLink = EffectLinkEffects(eLink, eImm3);
		eLink = EffectLinkEffects(eLink, eImm4);
		eLink = EffectLinkEffects(eLink, eDur);
		eLink = EffectLinkEffects(eLink, eVis);
		eLink = EffectLinkEffects(eLink, eVis2);
		eLink = ExtraordinaryEffect(eLink); // No dispelling it.

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	}
	HkPostCast(oCaster);
}

