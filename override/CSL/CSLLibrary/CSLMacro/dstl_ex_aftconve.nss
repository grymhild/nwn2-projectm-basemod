//:://////////////////////////////////////////////////
//:: dstl_ex_aftconver
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

ought to be called
after conversation of director and actors that restores
the location. Set this in both fields in the conversation properties.
(see dstl_ex_onconver)

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
	
	// after conversation: restore location
	loc=GetLocalLocation(OBJECT_SELF,DSTL_DSTLPREFIX+"formerloc");
	JumpToLocation(loc);

}