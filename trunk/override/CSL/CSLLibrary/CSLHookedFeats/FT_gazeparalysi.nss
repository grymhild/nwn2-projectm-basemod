//::///////////////////////////////////////////////
//:: Gaze: Paralysis
//:: NW_S1_GazeParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cone shape that affects all within the AoE if they
	fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

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
	effect eGaze = EffectParalyze(iDC, SAVING_THROW_WILL);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVisDur = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

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
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_PARALYSIS));
				//Determine effect delay
				float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
}