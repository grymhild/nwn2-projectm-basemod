//:://////////////////////////////////////////////////
//:: dstl_ex_music
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

Changes music track (day+night) in the area of object
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
	object a;
	
	para1=GetLocalInt(OBJECT_SELF,"dstl_ex_music_p1");
	
	a=GetArea(OBJECT_SELF);
	MusicBackgroundChangeDay(a,para1);
	MusicBackgroundChangeNight(a,para1);

}