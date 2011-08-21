//::///////////////////////////////////////////////
//:: Bolt: Fire
//:: NW_S1_BoltFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature must make a ranged touch attack to hit
	the intended target.  Reflex or Will save is
	needed to halve damage or avoid effect.
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
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + (iHD/2);
	int nCount = CSLGetMin(1, iHD /2);

	int iDamage = d6(nCount);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_FIRE));
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if (iTouch==2) iDamage *= 2;
		if (iDamage) {
			//Apply the VFX impact and effects
			int bFireGiant = CSLStringStartsWith(GetTag(OBJECT_SELF), "firegiant");
			if (bFireGiant)
			{
				iDamage /= 2;
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget);
			}  
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_FIRE), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget);
		}
	}
}