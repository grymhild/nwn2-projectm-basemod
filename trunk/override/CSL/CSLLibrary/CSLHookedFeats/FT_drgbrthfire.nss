//::///////////////////////////////////////////////
//:: Dragon Breath Fire
//:: NW_S1_DragFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper damage and DC Save for the
	breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Modified By: Constant Gaw - 8/9/06
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"

////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	SCDragonBreath(DAMAGE_TYPE_FIRE, SHAPE_SPELLCONE, 0.0, VFX_IMP_FLAME_M, VFX_NONE, "fx_red_dragon_breath.sef");
}