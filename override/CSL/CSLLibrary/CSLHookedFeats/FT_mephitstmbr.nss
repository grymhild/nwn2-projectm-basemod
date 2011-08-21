//::///////////////////////////////////////////////
//:: Steam Mephit Breath
//:: NW_S1_MephSteam
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Steam Mephit shoots out a bolt of steam
	that causes 1d4 damage and reduces AC by 4
	and Attack by 2
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
	effect eBolt, eAttack, eAC;
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	//Roll damage
	int iDamage = d4();
	//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
	iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	//Make a ranged touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if(iDamage == 0) {iTouch = 0;}
	if(iTouch !=  TOUCH_ATTACK_RESULT_MISS)
	{
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MEPHIT_STEAM_BREATH, TRUE ));

			//Set damage, AC mod and attack mod effects
			eBolt = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
			eAC = EffectACDecrease(4);
			eAttack = EffectAttackDecrease(2);
			effect eLink = EffectLinkEffects(eAC, eAttack);
			eLink = EffectLinkEffects(eLink, eDur);

			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
}