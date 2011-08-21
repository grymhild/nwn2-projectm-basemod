//::///////////////////////////////////////////////
//:: Howl: Fear
//:: NW_S1_HowlFear
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A howl emanates from the creature which affects
	all within 10ft unless they make a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////
//:: Updated By: Andrew Nobbs
//:: Updated On: FEb 26, 2003
//:: Note: Changed the faction check to GetIsEnemy
//:://////////////////////////////////////////////

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CAUSE_FEAR);
	effect eHowl = EffectFrightened();
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur2 = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	//effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

	effect eLink = EffectLinkEffects(eHowl, eDur2);
	//eLink = EffectLinkEffects(eLink, eDur2);
	
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + (iHD/4);
	int iDuration = 1 + (iHD/4);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if (  oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
				fDelay = GetDistanceToObject(oTarget)/10;
				iDuration = HkGetScaledDuration(iDuration , oTarget);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_FEAR));

				//Make a saving throw check
				if(!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
}