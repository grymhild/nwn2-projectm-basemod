//::///////////////////////////////////////////////
//:: Dragon Breath Negative Energy
//:: NW_S1_DragNeg
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
	SCDragonBreath(DAMAGE_TYPE_NEGATIVE, SHAPE_SPELLCONE, 0.0, VFX_IMP_NEGATIVE_ENERGY, VFX_DUR_CONE_EVIL);
}