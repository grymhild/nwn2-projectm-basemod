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
#include "_SCInclude_Polymorph"
#include "_SCInclude_Necromancy"

//void DoDrain(object oTarget, int nDrain)
//{
//	effect eDrain = EffectNegativeLevel(nDrain);
//	eDrain = SupernaturalEffect(eDrain);
//	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
//}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oCaster = OBJECT_SELF;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	object oTarget = HkGetSpellTarget();
	int nDrain = d2();

	int iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY_MEDIUM);
	if(oTarget != OBJECT_SELF)
	{
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			
			
			
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE))
			{
				nDrain = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDrain, SC_TOUCH_MELEE, oCaster );
				
				int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				SCApplyDeadlyAbilityLevelEffect( nDrain, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster, iSneakDamage );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				//if (GetHitDice(oTarget)-nDrain<1)
				//{
				//		effect eDeath = EffectDeath(TRUE);
				//		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget);
				//}
				//else
				//{
				//	DelayCommand(0.1f,DoDrain(oTarget,nDrain));
				//	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				//	
				//	// sneak damage on a attribute draining attack is added as negative damage
				//	int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				//	if ( iSneakDamage > 0 )
				//	{
			//			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
				//	}
				//	
				//}
			}
		}
	}
}