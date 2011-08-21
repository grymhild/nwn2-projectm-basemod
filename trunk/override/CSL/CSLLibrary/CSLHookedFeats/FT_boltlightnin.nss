//::///////////////////////////////////////////////
//:: Bolt: Lightning
//:: NW_S1_BltLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Does 1d6 per level to a single target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 10, 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(OBJECT_SELF);
	effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF,BODY_NODE_HAND);
	effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
	effect eBolt;
	int iDC = 10 + (iHD/2);
	int nCount = iHD /2;
	if (nCount == 0)
	{
			nCount = 1;
	}

	int iDamage = d6(nCount);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_LIGHTNING, TRUE ));
	//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
	//iDamage = HkGetReflexAdjustedDamage(iDamage, oTarget, iDC,SAVING_THROW_TYPE_ELECTRICITY);
	//Make a ranged touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
			if(iTouch == 2)
			{
				iDamage *= 2;
			}
			//Set damage effect
			eBolt = EffectDamage(iDamage, DAMAGE_TYPE_ELECTRICAL);
			if(iDamage > 0)
			{
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
			}
	}
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.8);
}