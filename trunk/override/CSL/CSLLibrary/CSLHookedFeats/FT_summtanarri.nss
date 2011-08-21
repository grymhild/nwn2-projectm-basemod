//::///////////////////////////////////////////////
//:: Summon Tanarri
//:: NW_S0_SummSlaad
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons a Quasit to aid the threatened Demon
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 05/31/2006:
//:: Updated creature blueprint
//:: Changed duration to 10 minutes
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eSummon = EffectSummonCreature("csl_sum_tanar_succubus2",VFX_FNF_SUMMON_MONSTER_3);
	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
	//Apply the VFX impact and summon effect
	//HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), 600.0f);
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
}