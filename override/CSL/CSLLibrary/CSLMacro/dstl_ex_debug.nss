//:://////////////////////////////////////////////////
//:: dstl_ex_debug
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

This script has the sole purpose of showing parameters
*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{

	string script;
	int para1;
	float para2;
	string para3;
	
	script="dstl_ex_debug";
	
	para1=GetLocalInt(OBJECT_SELF,script+"_p1");
	para2=GetLocalFloat(OBJECT_SELF,script+"_p2");
	para3=GetLocalString(OBJECT_SELF,script+"_p3");
	
	SpeakString("* dstl_ex_debug.nss speaking. p1 was= "+IntToString(para1)+", p2= "+
	FloatToString(para2)+", p3= "+para3+". *");

}