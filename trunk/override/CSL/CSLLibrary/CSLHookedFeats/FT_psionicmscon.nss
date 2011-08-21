//::///////////////////////////////////////////////
//:: Psionics: Mass Concussion
//:: x2_s1_psimconc
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Mindflayer Power
	Cause hit dice / 2 points of damage to hostile creatures
	and objects in a RADIUS_SIZE_MEDIUM area around the caster

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	int iAttributes =106625;
	//Declare major variables
	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetHitDice(OBJECT_SELF);

	int iDamage;
	float fDelay;
	effect eExplode = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	eExplode = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_10),eExplode);
	effect eVis = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
	effect eDam;
	//Get the spell target location as opposed to the spell tar get.
	location lTarget = HkGetSpellTargetLocation();
	//Apply the explosion at the location captured above.
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE);
	//Cycle through the targets within the spell shape until an invalid object is captured.

	effect eKnockdown = EffectKnockdown();
	effect eAbilityDamage = EffectAbilityDecrease(ABILITY_WISDOM,3);
	effect eVisDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eVisDur,eAbilityDamage);

	int iDC = 15 + (iCasterLevel/2);
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				//Roll damage for each target
				iDamage = d6(iCasterLevel/2) + GetAbilityModifier(ABILITY_WISDOM);
				//Resolve metamagic
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				//Set the damage effect
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_ENERGY);
				if(iDamage > 0)
				{
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the flame that erupts on the target not on the ground.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
				if (!HkSavingThrow(SAVING_THROW_WILL,oTarget,iDC, SAVING_THROW_TYPE_MIND_SPELLS))
				{
					float fDuration = RoundsToSeconds(d6()+3 );
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnockdown,oTarget,4.0f);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,fDuration);
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}

			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget,FALSE);
	}
}