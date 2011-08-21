//::///////////////////////////////////////////////
//:: Gaze: Dominate (Shifter)
//:: x2_s2_shiftdom
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cone shape that affects all within the AoE if they
	fail a Will Save.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct, 2003
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Polymorph"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//-------------------------------------------------------------------------
	// If blinded, I am not able to use this attack
	//--------------------------------------------------------------------------
	if( CSLIsGazeAttackBlocked(OBJECT_SELF))
	{
			return;
	}

	//--------------------------------------------------------------------------
	// Enforce artifical use limit on that ability
	//--------------------------------------------------------------------------
	/*if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
	{
			FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
			return;
	}*/

	//--------------------------------------------------------------------------
	// Set up save DC and duration
	//--------------------------------------------------------------------------
	int iDuration = Random(GetAbilityModifier(ABILITY_WISDOM))+d4();
	int iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_VERY_EASY) + GetAbilityModifier(ABILITY_WISDOM) ;

	location lTargetLocation = HkGetSpellTargetLocation();
	effect eGaze = EffectDominated();
	effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
	effect eLink = EffectLinkEffects(eDur, eVisDur);


	//--------------------------------------------------------------------------
	// Loop through all targets in the cone, but only dominate one!
	//--------------------------------------------------------------------------
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	int bBreak = FALSE;
	while(GetIsObjectValid(oTarget) && !bBreak)
	{
			if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DOMINATE));
				float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				if(GetIsEnemy(oTarget))
				{
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
					{
							//--------------------------------------------------------------------------
							// Effects do not stack
							//--------------------------------------------------------------------------
							if (!GetHasSpellEffect(GetSpellId(),oTarget))
							{
								eGaze = HkGetScaledEffect(eGaze, oTarget);
								eLink = EffectLinkEffects(eLink, eGaze);
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
								bBreak = TRUE;
							}
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
}