//::///////////////////////////////////////////////
//:: x1_s2_hailarrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	One arrow per arcane archer level at all targets
*/

#include "_HkSpell"
#include "_SCInclude_ArcaneArcher"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCaster);
	int iBonus = (iCasterLevel/2)+1;
	object oTarget;
	float fDelay = 0.0;
	float fTravelTime;
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	location lCaster = GetLocation(oCaster);
	location lTarget;
	int iTouch;
	int i = 0;
	for (i = 1; i <= iCasterLevel; i++)
	{
		oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCaster, i);
		if (GetIsObjectValid(oTarget))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			if (i==1 && GetDistanceBetween(oCaster, oTarget)>20.0f) nPathType = PROJECTILE_PATH_TYPE_BALLISTIC; // IF VERY FAR AWAY, CHANGE PATH TYPE
			lTarget = GetLocation(oTarget);
			fDelay += 0.1f;
			fTravelTime = GetProjectileTravelTime(lCaster, lTarget, nPathType);
			iTouch = CSLTouchAttackRanged(oTarget, TRUE, iBonus);
			DelayCommand(fDelay, SCArcaneArcherArrowLaunch(oCaster, oTarget, fTravelTime, iTouch, nPathType, 0));
		}
	}
}