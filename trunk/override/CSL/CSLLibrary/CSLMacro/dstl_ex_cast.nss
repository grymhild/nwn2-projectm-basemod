//:://////////////////////////////////////////////////
//:: dstl_ex_cast
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

object casts spell para1 on object para3. The script "cheats"

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
	string para3;
	
	para1=GetLocalInt(OBJECT_SELF,"dstl_ex_cast_p1");
	para3=GetLocalString(OBJECT_SELF,"dstl_ex_cast_p3");
	
	object deso;
	if ((para3!="")&&(para3!=GetTag(OBJECT_SELF)))
	deso=dstl_getobjectbytagwrapper(para3);
	else
	deso=OBJECT_SELF;
	
	ActionCastSpellAtObject(para1,deso,METAMAGIC_ANY,TRUE);

}