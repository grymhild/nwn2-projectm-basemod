//::///////////////////////////////////////////////
//:: Bolt: Dominated
//:: NW_S1_BltDomn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature must make a ranged touch attack to hit
	the intended target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	object oCaster = OBJECT_SELF;
	
	int iHD = GetHitDice(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	effect eBolt = EffectDominated();
	eBolt = HkGetScaledEffect(eBolt, oTarget);
	effect eVis2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
	eBolt = HkGetScaledEffect(eBolt, oTarget);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eBolt, eDur);
	eLink = EffectLinkEffects(eLink, eVis2);

	int iDC = 20 + (iHD);
	int nCount = (iHD + 1) / 2;
	if (nCount == 0)
	{
		nCount = 1;
	}
	nCount = HkGetScaledDuration(nCount, oTarget);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_BOLT_DOMINATE ));
	//Make a saving throw check
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster );
		if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
		{	
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
}