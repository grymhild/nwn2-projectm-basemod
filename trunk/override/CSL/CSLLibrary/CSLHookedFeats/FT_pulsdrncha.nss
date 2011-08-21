//::///////////////////////////////////////////////
//:: Pulse: Charisma Drain
//:: NW_S1_PulsDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A wave of energy emanates from the creature which affects
	all within 10ft.  Damage can be reduced by half for all
	damaging variants.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes =106884;
	//Declare major variables
	int iDamage = GetHitDice(OBJECT_SELF)/5;
	if (iDamage == 0)
	{
			iDamage = 1;
	}
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + iHD;
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eHowl;
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF)
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{

					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA, TRUE));
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					//Make a saving throw check
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay, SAVING_THROW_RESULT_REMEMBER))
					{
							//Set the Ability mod and change to supernatural effect
							eHowl = EffectAbilityDecrease(ABILITY_CHARISMA, iDamage);
							eHowl = SupernaturalEffect(eHowl);
							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHowl, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
			//Get first target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}