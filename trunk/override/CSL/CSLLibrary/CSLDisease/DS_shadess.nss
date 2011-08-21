//::///////////////////////////////////////////////
//:: Shadow Essence On Hit
//:: NW_S0_1ShadEss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	1 Point Permenent Strength Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

#include "_SCInclude_Disease"

#include "_HkSpell"

void main()
{	
	
	object oTarget = OBJECT_SELF;

	effect eDrain = EffectAbilityDecrease(ABILITY_STRENGTH, -1);
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
