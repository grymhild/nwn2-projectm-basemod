//::///////////////////////////////////////////////
//:: Gaze: Destroy Law
//:: NW_S1_GazeChaos
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cone shape that affects all within the AoE if they
	fail a Will Save and are of Lawful alignment.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 13, 2001
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
	effect eGaze = EffectDeath();
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				if(GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL)
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DESTROY_LAW));
					//Determine effect delay
					float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					if(!/*WillSave*/HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
					{
							//Apply the VFX impact and effects
							//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eGaze, oTarget));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
	
}