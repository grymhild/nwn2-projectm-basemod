//::///////////////////////////////////////////////
//:: Implacable Foe
//:: NW_S2_ImpFoe
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	The Warpriests grants all allies within 30'
	+20 HP, while he takes a -50% movement penalty for
	10 rounds.

	(This ability burns Turn Undead attempts.)
*/

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_TURNABLE;

	object oCaster = OBJECT_SELF;
	float fDuration =  RoundsToSeconds(10);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oCaster, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);

	eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(20)); // ALLIES GET +20 HP

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster));
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && oTarget != oCaster)
		{
			float fDelay = GetDistanceToObject(oTarget)/10;
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE ));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, fDuration));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster));
	}
}