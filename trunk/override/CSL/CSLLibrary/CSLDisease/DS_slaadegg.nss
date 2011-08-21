//::///////////////////////////////////////////////
//:: Disease: Red Slaad, Incubation
//:: NW_S3_SlaadEgg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If by the end of the incubation period the
	character is not cured they take 4d6 damage
	and a Red Slaad bursts from their body and
	matures.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_Disease"

#include "_HkSpell"

void main()
{	
		
	object oTarget = OBJECT_SELF;
	effect eSummon = EffectSummonCreature("NW_SP_SLAADRED");
	effect eDam = EffectDamage(d6(4));
	effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	effect eKnockdown = EffectKnockdown();

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(2));
	CreateObject(OBJECT_TYPE_CREATURE, "NW_SP_SLAADRED", GetLocation(oTarget));

}
