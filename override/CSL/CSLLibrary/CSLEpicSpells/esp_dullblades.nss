//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dullblades"
/* 	Purpose: Dullblades - grants 100% protection against slashing
		damage for 24 hours.
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
	int iSpellId = SPELL_EPIC_DULBLAD;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DULBLAD))
	{
		object oTarget = HkGetSpellTarget();
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		int nDuration = 10 + nCasterLvl;
		float fDuration = RoundsToSeconds(nDuration);
		effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
		effect eDur = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
		effect eProt = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 50);
		if(CSLGetPreferenceSwitch("PNPDullblades"))
		{
			eProt = EffectDamageImmunityIncrease
				(DAMAGE_TYPE_SLASHING, 100);
			fDuration = HoursToSeconds(20);
		}
		effect eLink = EffectLinkEffects(eProt, eDur);
		// if this option has been enabled, the caster will take backlash damage
		if ( CSLGetPreferenceSwitch("EpicBacklashDamage") )
		{
			int nDamage = d6(10);
			effect eDamVis = EffectVisualEffect(VFX_IMP_SONIC);
			effect eDam = HkEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
			DelayCommand(2.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamVis, OBJECT_SELF));
			DelayCommand(2.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF));
		}
		if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
		{
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
		}
	}
	HkPostCast(oCaster);
}
