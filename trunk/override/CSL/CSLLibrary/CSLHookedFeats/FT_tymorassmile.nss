//::///////////////////////////////////////////////
//:: Tymora's Smile
//:: x0_s2_HarpSmile
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	+2 luck bonus on all saving throws for 5 turns.

	past 5
	Gain an additional +2 on saving throws vs. spells every 3levels (6, 9, 12 et cetera )
*/

#include "_HkSpell"


void main()
{
	int iAttributes =84356;

	object oTarget = HkGetSpellTarget();
	object oCaster = OBJECT_SELF;
	int iLevel = GetLevelByClass(CLASS_TYPE_HARPER, oTarget);
	int nLevelB = CSLGetMax(0, iLevel/3 - 1);
	int nAmount = 2 + (nLevelB*2); // +2 to saves every 3 levels past 3
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_TYMORAS_SMILE, FALSE));
	effect eLink = EffectVisualEffect( VFX_DUR_SPELL_ENDURE_ELEMENTS );
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAmount, SAVING_THROW_TYPE_ALL));
	eLink = SupernaturalEffect(eLink);
	CSLUnstackSpellEffects(oTarget, GetSpellId());
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(5));
}