//:://////////////////////////////////////////////////
//:: dstl_ex_pickup
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Pickup object para3
*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	string para3;
	object a;
	object destobj;
	
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_pickup_p3");
	
	destobj=dstl_getobjectbytagwrapper(para3);
	
	ActionForceMoveToObject(destobj,FALSE,DSTL_MOVETODISTANCE, DSTL_FORCETIMEOUT);
	
	ActionPickUpItem(destobj);
}