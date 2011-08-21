//::///////////////////////////////////////////////
//:: Harpies Captivating Song
//:: x2_s1_harpycry
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Will charm any creature failing saving a will throw DC 15 x
	Charm song in a RADIUS_SIZE_HUGE radius for 6 rounds

	If cast by a Shifter Character, the DC is
	15 + Shifter Level /3

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/07/08
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	object oTarget;
	effect eCharm = EffectCharmed();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eCharm);
	eLink = EffectLinkEffects(eLink, eDur);
	effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
	int nRacial;
	int iDuration = 6;
	float fDelay;
	int iSaveDC;
	if (GetIsPC(OBJECT_SELF))
	{
		int nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) / 3 ;
		if (nShifter<1)
		{
			nShifter = 0;
		}
		iSaveDC = 15 + nShifter;
	}
	else
	{
		iSaveDC = 15;
	}



	// Apply song Effect on Self
	effect eSong = EffectVisualEffect(VFX_DUR_BARD_SONG);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSong, OBJECT_SELF, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget) )
	{

		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			fDelay = CSLRandomBetweenFloat();
			//Check that the target is humanoid or animal
			if ( CSLGetIsHumanoid(oTarget) )
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				//Make an SR check
				if (HkResistSpell(OBJECT_SELF, oTarget) <1)
				{
					//Make a Will save to negate
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
					{
						//Apply the linked effects and the VFX impact
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}

			}
		}
		//Get next target in spell area
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, HkGetSpellTargetLocation());
	}

}