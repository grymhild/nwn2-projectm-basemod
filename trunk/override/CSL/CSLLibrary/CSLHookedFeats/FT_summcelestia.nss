//::///////////////////////////////////////////////
//:: Summon Celestial
//:: NW_S0_SummCeles
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons a Lantern Archon to aid the threatened
	Celestial
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: Dec 14, 2001
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//Declare major variables
	effect eSummon = EffectSummonCreature("csl_sum_archon_lantern",VFX_FNF_SUMMON_MONSTER_3);
	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
	//Apply the VFX impact and summon effect
	//HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
}