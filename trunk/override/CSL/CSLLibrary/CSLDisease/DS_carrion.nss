//::///////////////////////////////////////////////
//:: Carrions Crawler Brain Juice
//:: NW_S0_1Carrion
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Induces Paralysis
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
	effect eParal = EffectParalyze(13, SAVING_THROW_FORT);
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink = EffectLinkEffects(eParal, eVis );

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
}