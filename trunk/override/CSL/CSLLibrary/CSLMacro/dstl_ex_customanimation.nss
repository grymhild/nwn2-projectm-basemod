//:://////////////////////////////////////////////////
//:: dstl_ex_customanimation
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Object plays custom animation.
Para3 is custom animation-string, para1 "looping", para2 "speed"
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
	float para2;
	string para3;
	
	para1=GetLocalInt(OBJECT_SELF,"dstl_ex_customanimation_p1");
	para2=GetLocalFloat(OBJECT_SELF,"dstl_ex_customanimation_p2");
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_customanimation_p3");
	
	PlayCustomAnimation(OBJECT_SELF,para3,para1,para2); //is it an "action"?

}