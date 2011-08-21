//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellrefle"
/* 	Purpose: Epic Spell Reflection - Grants immunity to all spells level 9 and
		lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_CSLCore_Items"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_EP_SP_R;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_EP_SP_R))
	{
		object oTarget = HkGetSpellTarget();
		//object oSkin;
		int nDuration = HkGetCasterLevel(OBJECT_SELF);
		effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
		effect eImp = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
		effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);
		//itemproperty ipImm = ItemPropertyImmunityToSpellLevel(9);
		effect eImm = EffectSpellLevelAbsorption(9, 9999);

		//oSkin = CSLGetPCSkin(oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration),-2);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImm, oTarget, RoundsToSeconds(nDuration),-2);
		//CSLSafeAddItemProperty(oSkin, ipImm);
	}
	HkPostCast(oCaster);
}