//::///////////////////////////////////////////////
//:: Krenshar Fear Stare
//:: NW_S1_KrenScare
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Causes those in the gaze to be struck with fear
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
	effect eFear = EffectFrightened();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	//Link the fear and mind effects
	effect eLink = EffectLinkEffects(eFear, eMind);
	eLink = EffectLinkEffects(eLink, eDur);
	object oTarget;
	float fDelay;
	//Get first target in the spell cone
	oTarget = GetFirstObjectInShape(SHAPE_CONE, 10.0, HkGetSpellTargetLocation(), TRUE);
	while(GetIsObjectValid(oTarget))
	{
			//Make faction check
			if(GetIsEnemy(oTarget))
			{
				fDelay = GetDistanceToObject(oTarget)/20;
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_KRENSHAR_SCARE));
				//Make a will save
				if(!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, 12, SAVING_THROW_TYPE_FEAR))
				{
					//Apply the linked effects and the VFX impact
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3)));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Get next target in the spell cone
			oTarget = GetNextObjectInShape(SHAPE_CONE, 10.0, HkGetSpellTargetLocation(), TRUE);
	}
}