//::///////////////////////////////////////////////
//:: Bolt: Web
//:: NW_S1_BltWeb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Glues a single target to the ground with
	sticky strands of webbing.
*/

#include "_HkSpell"
#include "x2_inc_switches"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(oCaster);
	int iDC = 15 + (iHD/2);
	int iDamage = d2(iDC/2);
	int iDuration = iDC/2;
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_BOLT_WEB));
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if (iTouch==TOUCH_ATTACK_RESULT_CRITICAL)
		{
			iDC += 5;
			iDuration *= 2;
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		}
		float fDelay = GetDistanceBetween(oCaster, oTarget)/20;
		iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_ACID);
		if (iDamage)
		{
			effect eLink = EffectVisualEffect(VFX_DUR_WEB);
			eLink = EffectLinkEffects(eLink, EffectEntangle());
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, IntToFloat(iDuration)));
			effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_ACID);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
		
	}
}