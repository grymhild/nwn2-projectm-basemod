//::///////////////////////////////////////////////
//:: x2_s1_shadow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The shadow gets  special strength drain
	attack, once per round.

	The shifter's spectre form can use this ability
	but is not as effective as a real shadow
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "_HkSpell"

void ApplyShadow(int iDamage, object oTarget)
{
	effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, iDamage);

	// * Delaying the command to sever the connection between this effect and
	// * the spell, so its effects stack
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
}

void DoShadowHit(object oTarget, int iTouch, object oCaster = OBJECT_SELF )
{
	int iDamage = Random(6) + 1;
	iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCH_MELEE, oCaster );
			
	int nTargetStrength = GetAbilityScore(oTarget, ABILITY_STRENGTH);

	effect eVis;
	
	int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
	if ( iSneakDamage > 0 )
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
	}
	
	// * Target is slain in Hardcore mode or higher if Strength is reduced to 0
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE) == FALSE)
	{
			//--------------------------------------------------------------------
			// On Hardcore rules, kill target if strength would fall below 0
			// This does not work for PCs (shiifter) it would be too unbalancing
			//--------------------------------------------------------------------
			if (((nTargetStrength - iDamage)  <= 0)  && GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
			{
					FloatingTextStrRefOnCreature(84482, oTarget,FALSE);
					int nHitPoints = GetCurrentHitPoints(oTarget);
					effect eHitDamage = EffectDamage(nHitPoints, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHitDamage, oTarget);
			}
			else
			{
				DelayCommand(0.1, ApplyShadow(iDamage, oTarget));
				FloatingTextStrRefOnCreature(84483, oTarget, FALSE);
			}
			eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY) ;
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

	}
	else
	{

			eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}

}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackMelee(oTarget,TRUE);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		DoShadowHit(oTarget, iTouch, oCaster);
	}
}


