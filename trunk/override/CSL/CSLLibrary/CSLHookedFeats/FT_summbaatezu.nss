//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: x2_s1_summbaatez
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons an Erinyes to aid the caster in combat
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-24
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//:: Update creature blueprints.
//:: Change duration to 10 minutes.
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN; // int iAttributes =98688;
	//scSpellMetaData = SCMeta_FT_summbaatezu();
	effect eSummon = EffectSummonCreature("csl_sum_baat_erinyes1",VFX_FNF_SUMMON_MONSTER_3);
	//Summon
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), 600.0f);
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
}


