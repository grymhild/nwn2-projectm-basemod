//::///////////////////////////////////////////////
//:: x1_s2_seeker
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Seeker Arrow
		- creates an arrow that automatically hits target.
		- normal arrow damage, based on base item type

		- Must have shortbow or longbow in hand.

*/
#include "_HkSpell"
#include "_SCInclude_ArcaneArcher"
#include "_SCInclude_Abjuration"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCaster);
	int iBonus = (iCasterLevel/2)+1;
	location lCaster = GetLocation(oCaster);
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
		location lTarget = GetLocation(oTarget);
		float fTravelTime = GetProjectileTravelTime(lCaster, lTarget, PROJECTILE_PATH_TYPE_HOMING);
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, iBonus);
		if (iTouch!=TOUCH_ATTACK_RESULT_CRITICAL) iTouch = TOUCH_ATTACK_RESULT_HIT; // ALWAYS HITS!
		SCArcaneArcherArrowLaunch(oCaster, oTarget, fTravelTime, iTouch, PROJECTILE_PATH_TYPE_HOMING, 0);
		int nStripCnt = SCGetDispellCount(GetSpellId());
		DelayCommand(fTravelTime, SCDispelTarget(oTarget, oCaster, nStripCnt));
	}
	
	HkPostCast(oCaster);
}