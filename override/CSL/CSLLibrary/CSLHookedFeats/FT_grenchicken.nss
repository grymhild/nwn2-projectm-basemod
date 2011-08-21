//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grenade.
	Fires at a target. If hit, the target takes
	direct damage. If missed, all enemies within
	an area of effect take splash damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDamage = 0;
	
	int nCnt;
	effect eMissile;
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	location lTarget = HkGetSpellTargetLocation();
	effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
		//Apply the fireball explosion at the location captured above.
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);


	float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
	int iTouch;
	float fDelay = fDist/(3.0 * log(fDist) + 2.0);

	if (GetIsObjectValid(oTarget) == TRUE)
	{
		iTouch = CSLTouchAttackRanged(oTarget);
	}
	else
	{
		iTouch = -1; // * this means that target was the ground, so the user
						// * intended to splash
	}
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
		//Roll damage
		int nDam = d6(1);

		nDam = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDam, SC_TOUCHSPELL_RANGED, oCaster );
		

		//Set damage effect
		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
		//Apply the MIRV and damage effect

		// * only damage enemies
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
		}

	//    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
	}
	else
	{
		// * Splash damage
		eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
		SpeakString("splash");
		// * need to determine by own 'miss' area
		// * and do an explosion from that point

		// TEMP: assume miss is on object?

	//   HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMissile, HkGetSpellTargetLocation());

	}

}