//:://////////////////////////////////////////////////
//:: dstl_ex_eventhan
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Event handler for objects. Use this as a framework

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	object sender;
	int para1;
	float para2;
	string para3;
	
	effect e;
	
	sender=GetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"sender");
	
	para1=GetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"p1");
	para2=GetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"p2");
	para3=GetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"p3");

	switch (GetUserDefinedEventNumber())
	{
		case 500:
			// emit a beam to sender
			e=EffectNWN2SpecialEffectFile("sp_divination_ray",sender);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e,OBJECT_SELF,5.0f);
			break;
		case 999:
			// do debug
			SpeakString("* event 999 on dstl_ex_eventhan. sender was (tag)= "+
			GetTag(sender)+", p1= "+IntToString(para1)+", p2= "+
			FloatToString(para2)+", p3= "+para3+". *");
	}

}