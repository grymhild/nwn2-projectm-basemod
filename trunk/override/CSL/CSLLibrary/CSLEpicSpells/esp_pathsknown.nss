//:://////////////////////////////////////////////
//:: FileName: "ss_ep_pathsknown"
/* 	Purpose: Paths Become Known - Explores the area and reveals the entire map
		for the area the caster is currently in. As well, the caster gains a
		bonus of +50 to both Spot and Search skills, but only for 30 seconds!
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_PATHS_B;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PATHS_B))
	{
		object oArea = GetArea(OBJECT_SELF);
		effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
		effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_MIND);
		effect eSkill = EffectSkillIncrease(SKILL_SEARCH, 50);
		effect eSkill2 = EffectSkillIncrease(SKILL_SPOT, 50);
		effect eLink = EffectLinkEffects(eVis, eSkill);
		eLink = EffectLinkEffects(eLink, eSkill2);
		DelayCommand(1.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, OBJECT_SELF));
		DelayCommand(1.5, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 30.0));
		DelayCommand(6.0, ExploreAreaForPlayer(oArea, OBJECT_SELF));
	}
	HkPostCast(oCaster);
}
