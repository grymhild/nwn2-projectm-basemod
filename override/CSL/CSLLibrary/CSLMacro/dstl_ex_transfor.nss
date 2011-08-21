//:://////////////////////////////////////////////////
//:: dstl_ex_transfor
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Transform object using SetCreatureAppearanceType
para1 is AppearanceType

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{

	int para1;
	effect e;
	
	para1=GetLocalInt(OBJECT_SELF,"dstl_ex_transfor_p1");
	
	e=EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
	ApplyEffectToObject(DURATION_TYPE_INSTANT,e,OBJECT_SELF);
	SetCreatureAppearanceType(OBJECT_SELF,para1);

}