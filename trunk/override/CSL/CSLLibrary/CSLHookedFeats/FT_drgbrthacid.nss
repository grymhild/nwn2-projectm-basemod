//::///////////////////////////////////////////////
//:: Dragon Breath Acid
//:: NW_S1_DragAcid
//:://////////////////////////////////////////////
/*
	Does 1d10 per level in a 5ft tube for 30m
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"



void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	SCDragonBreath(DAMAGE_TYPE_ACID, SHAPE_SPELLCYLINDER, 60.0, VFX_IMP_ACID_L, VFX_BEAM_GREEN_DRAGON_ACID);
}