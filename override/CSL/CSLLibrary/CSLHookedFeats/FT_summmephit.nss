//::///////////////////////////////////////////////
//:: Summon Mephit
//:: NW_S1_SummMeph
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons a Steam Mephit
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//:: Updated creature blueprint
//:: Changed duration to 10 minutes
#include "_HkSpell"
void main()
{
	int iAttributes =67969;
	//Declare major variables
	effect eSummon = EffectSummonCreature("csl_sum_elem_fire_mephit",VFX_FNF_SUMMON_MONSTER_1);
	// effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
	//Apply the VFX impact and summon effect
	//HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), 600.0f);
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
}