//::///////////////////////////////////////////////
//:: Pulse: Disease
//:: NW_S1_PulsDis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A wave of disease spreads out from the creature
	and infects all those within 10ft
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2000
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//Declare major variables
	int iDamage = d6(GetHitDice(OBJECT_SELF));
	int nRacial = GetRacialType(OBJECT_SELF);
	int nDisease;
	float fDelay;
	effect eDisease;
	effect ePulse = EffectVisualEffect(266);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePulse, GetLocation(OBJECT_SELF));

	//Determine the disease type based on the Racial Type
	switch (nRacial)
	{
			case RACIAL_TYPE_VERMIN:
				nDisease = DISEASE_VERMIN_MADNESS;
			break;
			case RACIAL_TYPE_UNDEAD:
				nDisease = DISEASE_FILTH_FEVER;
			break;
			case RACIAL_TYPE_OUTSIDER:
				nDisease = DISEASE_DEMON_FEVER;
			break;
			case RACIAL_TYPE_MAGICAL_BEAST:
				nDisease = DISEASE_SOLDIER_SHAKES;
			break;
			case RACIAL_TYPE_ABERRATION:
				nDisease = DISEASE_BLINDING_SICKNESS;
			break;
			default:
				nDisease = DISEASE_MINDFIRE;
			break;
	}
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
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_DISEASE));
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					eDisease = SupernaturalEffect(EffectDisease(nDisease));
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDisease, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}