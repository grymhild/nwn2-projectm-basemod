//::///////////////////////////////////////////////
//:: Undead Graft
//:: X2_S2_UndGraft1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Pale Master may use their undead arm to paralyze
	foes for 1d6+2 rounds on a successful melee touch attack

	Save is 14 + pale master level/2


	Elves immune to this effect
	TaB pg 66;
*/

#include "_HkSpell"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster);
	if (iCasterLevel>10) iCasterLevel = 10+(iCasterLevel-10)/2;
	int nNecro = GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster) ? 2 : (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster) ? 1 : 0);
	int iDC = 10 + iCasterLevel + HkGetBestCasterModifier(oCaster, TRUE, FALSE) + nNecro;
	int iSpellId = GetSpellId();


	object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackMelee(oTarget,TRUE);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
		//if (GetRacialType(oTarget)==RACIAL_TYPE_ELF)
		//{
		//	FloatingTextStrRefOnCreature(85591, oTarget, FALSE);
		//	FloatingTextStrRefOnCreature(85591, oCaster, FALSE);
		//	return;  
		//}
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE)) {
			effect ePara = EffectParalyze(iDC, SAVING_THROW_FORT);
			ePara = EffectLinkEffects(ePara, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
			ePara = EffectLinkEffects(ePara, EffectVisualEffect(VFX_DUR_PARALYZED));
			ePara = EffectLinkEffects(ePara, EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePara, oTarget);
		}
	} else  {
		if (iSpellId==625) IncrementRemainingFeatUses(oCaster, 892);
		else if (iSpellId==626) IncrementRemainingFeatUses(oCaster, 893);
	}
}