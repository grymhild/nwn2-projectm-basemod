//::///////////////////////////////////////////////
//:: Gaze: Daze
//:: NW_S1_GazeDaze
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cone shape that affects all within the AoE if they
	fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes =123012;
	if( CSLIsGazeAttackBlocked(OBJECT_SELF))
	{
			return;
	}

	//Declare major variables
	int iHD = GetHitDice(OBJECT_SELF);
	int iDuration = 1 + (iHD / 3);
	int iDC = 10 + (iHD/2);
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	effect eGaze = EffectDazed();
	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVisDur = EffectVisualEffect( VFX_DUR_SPELL_DAZE );

	effect eLink = EffectLinkEffects(eGaze, eVisDur);
	eLink = EffectLinkEffects(eLink, eDur);
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				iDuration = HkGetScaledDuration(iDuration , oTarget);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DAZE));
				//Determine effect delay
				float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				if(!/*WillSave*/HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
}