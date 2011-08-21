//::///////////////////////////////////////////////
//:: Deathless Master Touch
//:: X2_S2_dthmsttch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Pale Master may use their undead arm to
	kill their foes.

	-Requires melee Touch attack
	-Save vs DC 17 to resist

	Epic:
	-SaveDC raised by +1 for each 2 levels past 10th
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
		//iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE, oCaster );
			
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE))
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
		}
	}
}