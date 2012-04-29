//::///////////////////////////////////////////////
//:: Bolt: Death
//:: NW_S1_BltDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature must make a ranged touch attack to hit
	the intended target.
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
	object oCaster = OBJECT_SELF;
	
	int iHD = GetHitDice(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
	effect eBolt = EffectDeath();
	int iDC = 20 + (iHD);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_BOLT_DEATH));
	//Make a saving throw check
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_DEATH, oCaster );
		if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
		{
			
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
}