//::///////////////////////////////////////////////
//:: Bolt: Acid
//:: NW_S1_BltAcid
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
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
	effect eBolt;
	int iDC = 10 + (iHD/2);
	int nCount = iHD /2;
	if (nCount == 0)
	{
		nCount = 1;
	}
	
	
	int iDamage = d6(nCount);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_ACID, TRUE ));
	//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
	//iDamage = HkGetReflexAdjustedDamage(iDamage, oTarget, iDC,SAVING_THROW_TYPE_ACID);
	//Make a ranged touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
			
			//Set damage effect
			eBolt = EffectDamage(iDamage, DAMAGE_TYPE_ACID);
			if(iDamage > 0)
			{
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
	}
}