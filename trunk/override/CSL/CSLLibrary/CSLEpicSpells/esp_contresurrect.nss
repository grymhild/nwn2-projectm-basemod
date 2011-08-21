//:://////////////////////////////////////////////
//:: FileName: "ss_ep_cont_resur"
/* 	Purpose: Contingent Resurrection - sets a variable on the target, so that
		in the case of their death, they will automatically resurrect.
		NOTE: This contingency will last indefinitely, unless it triggers or the
		player dispels it in the pre-rest conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"

// Brings oPC back to life, via the contingency of 'Contingent Resurrection'.
void ContingencyResurrect(object oTarget, int nCount, object oCaster);


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_CSLCore_Nwnx"
void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_CON_RES;
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
	
	if (GetCanCastSpell(oCaster, SPELL_EPIC_CON_RES))
	{
		object oTarget 	= HkGetSpellTarget();
		location lTarget = GetLocation(oTarget);
		effect eVis 	= EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
		effect eVisFail = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		// If the target is of a race that could be resurrected, go ahead.
		int bRaise = FALSE;
		if( CSLGetIsUndead(oTarget)   || CSLGetIsOutsider(oTarget)   || CSLGetIsConstruct(oTarget)  || CSLGetIsElemental(oTarget ) ) // elemental savants are raisable
		{
			bRaise = FALSE;
		}
		else
		{
			bRaise = TRUE;
		}

		if(bRaise)
		{
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
			PenalizeSpellSlotForCaster(oCaster);
			// Start the contingency.
			SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") + 1);
			ContingencyResurrect(oTarget, 1, oCaster);
		}
		else
		{
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisFail, lTarget);
			SendMessageToPC(oCaster, "Spell failed - Invalid target!");
		}
	}
	HkPostCast(oCaster);
}

void ContingencyResurrect(object oTarget, int nCount, object oCaster)
{
	// If the contingency has been turned off, terminate HB
	if(!GetLocalInt(oCaster, "nContingentRez"))
		return;

	// If the target isn't dead, just toss out a notice that the heartbeat is running and schedule next beat
	if(!GetIsDead(oTarget))
	{
		if((nCount++ % 10) == 0)
			FloatingTextStringOnCreature("*Contingency active*", oTarget, FALSE);
		DelayCommand(6.0, ContingencyResurrect(oTarget, nCount, oCaster));
	}
	else // Resurrect the target, and end the contingency.
	{
		effect eRez = EffectResurrection();
		effect eHea = EffectHeal(GetMaxHitPoints(oTarget) + 10);
		effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

		// Resurrect the target
		FloatingTextStringOnCreature("*Contingency triggered*", oTarget);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHea, oTarget);

		// Bookkeeping of epic spell slots in contingent use
		RestoreSpellSlotForCaster(oCaster);
		SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") - 1);

		//ContingencyResurrect(oTarget, nCount); // Methinks this particular HB should end now - Ornedan

		// PW death stuff
		ExecuteScript("prc_pw_contress", oTarget);
		//if(CSLGetPreferenceSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
		//	CSLSetPersistentInt(oTarget, "persist_dead", FALSE);
	}
}

