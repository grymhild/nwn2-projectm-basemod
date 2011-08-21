//:://////////////////////////////////////////////////
//:: dstl_ex_onconver
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

OnConversation-Script for actors and director, that remembers his/hers location (see dstl_ex_aftconve)

* this would be the place to pause your director, but I don't know your
director's tag

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{
	location loc;
	
	// save location
	loc=GetLocation(OBJECT_SELF);
	SetLocalLocation(OBJECT_SELF,DSTL_DSTLPREFIX+"formerloc",loc);
	
	ExecuteScript("nw_c2_default4",OBJECT_SELF);
}