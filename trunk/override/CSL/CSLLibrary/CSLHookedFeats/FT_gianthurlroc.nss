//::///////////////////////////////////////////////
//:: Name x2_s1_hurlrock
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Impact script for tossed boulders

	Non magical attack, so no spell resistance
	applies
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner, Georg Zoeller
//:: Created On: Sept 9/10
//:://////////////////////////////////////////////

void RockDamage(location lImpact);

#include "_SCInclude_Polymorph"
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Do damage here...//354 for impact
	effect eImpact = EffectVisualEffect(354);
	effect eImpac1 = EffectVisualEffect(460);
	int iDamage;
	location lImpact = HkGetSpellTargetLocation();
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lImpact);
	DelayCommand(0.2f,HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpac1, lImpact));
	RockDamage(lImpact);
}

void RockDamage(location lImpact)
{
	float fDelay;
	int iDamage;
	effect eDam;
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.

	int iDC;

	int bShifter = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>10);

	if (bShifter)
	{
			iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL);
	}
	else
	{
			iDC = HkGetSpellSaveDC();
	}

		int iDice = GetHitDice(OBJECT_SELF) / 5;
		if (iDice <1)
		{
			iDice =1;
		}


	int nDamageAdjustment = GetAbilityModifier (ABILITY_STRENGTH,OBJECT_SELF);
	while (GetIsObjectValid(oTarget))
	{

			if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lImpact, GetLocation(oTarget))/20;
				//Roll damage for each target, but doors are always killed


				iDamage = d6(iDice) + nDamageAdjustment;



				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_NONE);
				//Set the damage effect
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_PLUS_ONE);
				if(iDamage > 0)
				{
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the flame that erupts on the target not on the ground.
					//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}