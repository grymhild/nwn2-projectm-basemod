//:://////////////////////////////////////////////////
//:: dstl_ex_dlyclear
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Speaks a delayed ClearAllActions(para1), in para2 seconds.
leave para1 free for =FALSE
*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 28/04/2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	int para1;
	float para2;
	para1=GetLocalInt(OBJECT_SELF,"dstl_ex_dlyclear_p1");
	para2=GetLocalFloat(OBJECT_SELF,"dstl_ex_dlyclear_p2");
	
	DelayCommand(para2,ClearAllActions(para1));
}