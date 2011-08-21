//:://////////////////////////////////////////////
//:: FileName: "ss_ep_deadeye"
/* 	Purpose: Deadeye Sense - Increases the target's AB by +20 for 20 hours.
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
	int iSpellId = SPELL_EPIC_DEADEYE;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DEADEYE))
	{
		object oTarget = HkGetSpellTarget();
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		int nDuration = nCasterLvl / 4;
		if (nDuration < 5)
		nDuration = 5;

		effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
		effect eAttack = EffectAttackIncrease(20);
		effect eLink = EffectLinkEffects(eAttack, eDur);
		float fDelay;
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
		if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
		{
			fDelay = CSLRandomBetweenFloat(0.4, 1.1);
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration) ));
		}
	}
	HkPostCast(oCaster);
}

