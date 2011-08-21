//:://////////////////////////////////////////////////
//:: dstl_ex_SEFlocation
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

applies SEF-file para3 to location of object. if para2=0.0 it is applied
instantly, if not, it's applied temporarily for para2 seconds
if theres a second token in para3 (behind a DSTL_DELIMITER), its
the target

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
	effect e;
	
	para2=GetLocalFloat(OBJECT_SELF,"dstl_ex_seflocation_p2");
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_seflocation_p3");
	
	string s1;
	string s2;
	
	if (CSLNth_GetCount(para3, DSTL_DELIMITER)==2)
	{
		string s;
		s1=CSLNth_GetNthElement(para3,1,DSTL_DELIMITER);
		s2=CSLNth_GetNthElement(para3,2,DSTL_DELIMITER);
	}
	else
	{
		s1=para3;
		s2="";
	}
	
	object target;
	if (s2=="")
	{
		target==OBJECT_INVALID;
	}
	else
	{
		target=dstl_getobjectbytagwrapper(s2);
	}
		
	e=EffectNWN2SpecialEffectFile(s1,target);
	
	if (para2==0.0)
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e,GetLocation(OBJECT_SELF));
	}
	else
	{
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e,GetLocation(OBJECT_SELF),para2);
	}	
}