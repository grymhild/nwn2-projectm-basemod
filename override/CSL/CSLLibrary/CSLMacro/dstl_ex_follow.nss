//:://////////////////////////////////////////////////
//:: dstl_ex_follow
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Current object follows para3 using
ActionForceFollowObject(); in the dist of para2 (leave free for 0.0) meters.
Use [CLEARALLACTIONS:] to cancel this.

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	float para2;
	string para3;
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_follow_p3");
	para2=GetLocalFloat(OBJECT_SELF,"dstl_ex_follow_p2");
	
	ActionForceFollowObject(dstl_getobjectbytagwrapper(para3),para2);
}