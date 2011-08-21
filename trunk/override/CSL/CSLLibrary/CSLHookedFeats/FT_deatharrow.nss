//::///////////////////////////////////////////////
//:: x1_s2_deatharrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
*/
#include "_HkSpell"
#include "_SCInclude_ArcaneArcher"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCaster);
	int iBonus = (iCasterLevel/2)+1;
	location lCaster = GetLocation(oCaster);
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
		location lTarget = GetLocation(oTarget);
		float fTravelTime = GetProjectileTravelTime(lCaster, lTarget, PROJECTILE_PATH_TYPE_HOMING);
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, iBonus);
		if (iTouch!=TOUCH_ATTACK_RESULT_CRITICAL) iTouch = TOUCH_ATTACK_RESULT_HIT; // ALWAYS HITS!
		SCArcaneArcherArrowLaunch(oCaster, oTarget, fTravelTime, iTouch, PROJECTILE_PATH_TYPE_HOMING, 0);
		int iDC = 10 + iCasterLevel + HkGetBestCasterModifier(oCaster, TRUE, FALSE);
		if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster)) iDC++;
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster)) iDC++;
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster)) iDC+=4;
		if (iTouch==TOUCH_ATTACK_RESULT_CRITICAL) iDC += 2;
		if (HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DEATH)==SAVING_THROW_CHECK_FAILED)
		{
			effect eDeath = EffectDeath();
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
		}
	}
}

