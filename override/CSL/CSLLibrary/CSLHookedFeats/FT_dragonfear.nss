//::///////////////////////////////////////////////
//:: Dragon Breath Fear
//:: NW_S1_DragFear
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper DC Save for the
	breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iAge = GetHitDice(OBJECT_SELF);
	int nCount;
	int iDC = SCGetDragonFearDC(iAge);
	float fDelay;
	object oTarget;
	
	effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
		
	effect eFear = EffectFrightened();
	eFear = EffectLinkEffects( eFear, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR) );
	eFear = EffectLinkEffects( eFear, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );	
	eFear = SetEffectSpellId(eFear, SPELLABILITY_DRAGON_BREATH_FEAR);

	SCPlayDragonBattleCry();
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	//Get first target in spell area
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
			{
				nCount = HkGetScaledDuration(GetHitDice(OBJECT_SELF), oTarget);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FEAR));
				//Determine the effect delay time
				fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/20;
				//Make a saving throw check
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(nCount)));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	}
}