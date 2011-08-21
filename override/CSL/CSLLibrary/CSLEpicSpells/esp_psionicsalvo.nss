//:://////////////////////////////////////////////
//:: FileName: "ss_ep_psionicsal"
/* 	Purpose: Psionic Salvo - subject loses WIS and INT until both are at 3, or
		until the subject makes a Will saving throw.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"

void DoSalvo(object oTarget, int nDC);


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_PSION_S;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PSION_S))
	{
		object oTarget = HkGetSpellTarget();
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget,
			EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE, FALSE));
		//Make SR Check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
			DoSalvo(oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget));
		}
	}
	HkPostCast(oCaster);
}

void DoSalvo(object oTarget, int nDC)
{
	//Make a Will save each time
	if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC))
	{
		effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
		effect eWIS = EffectAbilityDecrease(ABILITY_WISDOM, 1);
		effect eINT = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
		eWIS = EffectLinkEffects(eWIS, eVis);
		eINT = EffectLinkEffects(eINT, eVis);
		eWIS = SupernaturalEffect(eWIS);
		eINT = SupernaturalEffect(eINT);
		if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3)
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eWIS, oTarget);
		if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eINT, oTarget);
		if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3 ||
			GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
			DelayCommand(6.0, DoSalvo(oTarget, nDC));
	}
}
