//::///////////////////////////////////////////////
//:: Sassone Leaf Residue On Hit
//:: NW_S0_1Sassone
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Does 2d12 damage on hit.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////
//#include "prc_alterations"
//:: modified by mr_bumpkin Dec 4, 2003
//#include "spinc_common"

#include "_SCInclude_Disease"

#include "_HkSpell"

void main()
{	
	
	object oTarget = OBJECT_SELF;
	effect eDam = HkEffectDamage(d12(2), DAMAGE_TYPE_ACID);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}
