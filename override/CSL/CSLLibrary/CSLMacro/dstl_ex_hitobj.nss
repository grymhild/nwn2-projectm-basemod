//:://////////////////////////////////////////////////
//:: dstl_ex_hitobj
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

object hits object para3 for para2 seconds

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
	
	para2=GetLocalFloat(OBJECT_SELF,"dstl_ex_hitobj_p2");
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_hitobj_p3");
	
	object attackee;
	attackee=dstl_getobjectbytagwrapper(para3);
	
	ActionForceMoveToObject(attackee, FALSE,DSTL_MOVETODISTANCE, DSTL_FORCETIMEOUT);
	
	ActionAttack(attackee,FALSE);
	
	DelayCommand(para2, ClearAllActions(TRUE));

}