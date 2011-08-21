//::///////////////////////////////////////////////
//:: Disease: Blind Sickness, After Rest
//:: NW_S3_BlindSick
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Every time the character takes Str damage
	they must roll or be blinded.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_Disease"

#include "_HkSpell"

void main()
{	
		
	effect eBlind = EffectBlindness();
	effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	object oTarget = OBJECT_SELF;
	int nRoll = d100();
	//Roll randomly for chance to be blinded
	if(nRoll > 60)
	{
		//Apply the VFX impact and effects
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
}
