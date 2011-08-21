//::///////////////////////////////////////////////
//:: Pulse: Holy
//:: NW_S1_PulsHoly
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A wave of energy emanates from the creature which affects
	all within 10ft.  Damage can be reduced by half for all
	damaging variants.  Undead are damaged, allies are healed.
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
	int iDamage;
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect eHowl;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + iHD;
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{

			//Determine effect delay
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			//Roll the amount to heal or damage
			iDamage = d4(iHD);
			//If the target is not undead
			if ( !CSLGetIsUndead( oTarget, TRUE ) )
			{
				//Make a faction check
				if(oTarget != OBJECT_SELF)
				{
					if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
					{
							//Fire cast spell at event for the specified target
							SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_HOLY, FALSE));
							//Set heal effect
							eHowl = EffectHeal(iDamage);
							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
			else
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_DIVINE);
					//Set damage effect
					eHowl = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE) ;
					if(iDamage > 0)
					{
							//Fire cast spell at event for the specified target
							SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_HOLY));
							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}