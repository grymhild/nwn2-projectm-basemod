//::///////////////////////////////////////////////
//:: Vrock Spores
//:: NW_S1_PulsSpore
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A wave of disease spreads out from the creature
	and infects all those within 10ft
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes =106884;
	//Declare major variables
	float fDelay;
	effect eDisease;
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
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
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_DISEASE, TRUE ));
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					eDisease = SupernaturalEffect(EffectDisease(DISEASE_SOLDIER_SHAKES));
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDisease, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}