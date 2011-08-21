//:://////////////////////////////////////////////
//:: FileName: "ss_ep_fleetness"
/* 	Purpose: Fleetness of Foot - grants the target double the movement rate
		for 20 hours. Yowza!
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
	int iSpellId = SPELL_EPIC_FLEETNS;
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
	
	if (GetCanCastSpell(OBJECT_SELF, iSpellId))
	{
		object oTarget = HkGetSpellTarget();
		int nDuration = 20;

		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
		effect eImpact = EffectVisualEffect(VFX_IMP_GOOD_HELP);
		effect eSpeed = EffectMovementSpeedIncrease(99);
		effect eLink = EffectLinkEffects(eSpeed, eDur);
		float fDelay;
		if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
		{
			fDelay = CSLRandomBetweenFloat(0.4, 1.1);
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,HoursToSeconds(nDuration) ));
		}
	}
	HkPostCast(oCaster);
}