//::///////////////////////////////////////////////
//:: Dragon Breath Cold
//:: NW_S1_DragCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper damage and DC Save for the
	breath weapon based on the HD of the dragon.
*/

#include "_HkSpell"
#include "_SCInclude_Monster"
////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	SCDragonBreath(DAMAGE_TYPE_COLD, SHAPE_SPELLCONE, 0.0, VFX_IMP_FROST_S, VFX_DUR_CONE_ICE);
}