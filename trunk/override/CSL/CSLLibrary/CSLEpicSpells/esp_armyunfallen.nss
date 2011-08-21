//:://////////////////////////////////////////////
//:: FileName: "ss_ep_armyunfall"
/* 	Purpose: Army Unfallen epic spell - heals/resurrects all allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "nw_i0_generic"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_CSLCore_Nwnx"
void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ARMY_UN;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ARMY_UN))
	{
		effect eRez, eHeal, eBLD, eLink;
		effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
		effect eVis2 = EffectVisualEffect(VFX_FNF_PWSTUN);
		effect eVis3 = EffectVisualEffect(VFX_IMP_HEALING_G);
		int nX, nAlly, nBLD;
		object oTarget = GetFirstFactionMember(OBJECT_SELF, FALSE);
		while (GetIsObjectValid(oTarget))
		{
			nX = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
			if(nX < 0) //account for temporary HP
				nX = 0;
			eRez = EffectResurrection();
			eHeal = EffectHeal(nX);
			eLink = EffectLinkEffects(eHeal, eVis);
			eLink = EffectLinkEffects(eLink, eVis2);
			eLink = EffectLinkEffects(eLink, eVis3);
			if (nX && CSLGetIsLiving(oTarget))
			{
				if (nX > 0)
				{
				if (GetIsDead(oTarget))
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
					ExecuteScript("prc_pw_armyunfall", oTarget);
					//if(CSLGetPreferenceSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
					//{
					///	CSLSetPersistentInt(oTarget, "persist_dead", FALSE);
					//}
				}
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				nAlly++;
				}
			}
			oTarget = GetNextFactionMember(OBJECT_SELF, FALSE);
		}
		if ( CSLGetPreferenceSwitch("EpicBacklashDamage") )
		{
			nBLD = d6(nAlly);
			eBLD = HkEffectDamage(nBLD);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBLD, oTarget);
		}
	}
	HkPostCast(oCaster);
}
