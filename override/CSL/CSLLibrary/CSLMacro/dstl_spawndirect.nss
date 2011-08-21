//:://////////////////////////////////////////////////
//:: dstl_spawndirect
/*
v2.07
	The DS-TL (see dstl_hbdirector)

This is supposed to be the OnSpawn Event of the director

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	SetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"dividersecs",DSTL_DIVIDERSECS);
	SetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"obj",OBJECT_SELF);
}