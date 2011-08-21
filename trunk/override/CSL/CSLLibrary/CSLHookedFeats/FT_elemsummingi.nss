//::///////////////////////////////////////////////
//:: Summon Huge Elemental
//:: x0_s3_summonelem
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
	This spell is used for the various elemental-summoning
	items.
	It does not consider metamagic as it is only used for
	item properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 12/13/02
//:://////////////////////////////////////////////
//:: Latest Update: Andrew Nobbs April 9, 2003
//:: AFW-OEI 05/31/2006:
//:: Updated creature blueprints.
//:: Changed duration to 10 minutes

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	// Level 1: Air elemental
	// Level 2: Water elemental
	// Level 3: Earth elemental
	// Level 4: Fire elemental

	//Declare major variables
	object oCaster = OBJECT_SELF;
	string sResRef = "csl_sum_elem_air_08large";
	int iLevel = HkGetSpellPower( oCaster ) - 4;
	float fDuration = 600.0; // Ten minutes
	
	// Figure out which creature to summon
	switch (iLevel)
	{
			case 1: sResRef = "csl_sum_elem_air_08large"; break;
			case 2: sResRef = "csl_sum_elem_wat_04medium"; break;
			case 3: sResRef = "csl_sum_elem_eart_08large"; break;
			case 4: sResRef = "csl_sum_elem_fire_08large"; break;
		case 16: sResRef = "csl_sum_elem_orglash"; break;
	}

	// 0.5 sec delay between VFX and creature creation
	effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);


	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), fDuration);
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
}