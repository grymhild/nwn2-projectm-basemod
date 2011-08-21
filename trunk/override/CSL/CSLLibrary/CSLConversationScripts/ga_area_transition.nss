// ga_area_transition
/*
	Performs an area transition the same as per the standard area transition rules.
	
		string sDestination - tag of the location to be transferred to.
		int bIsPartyTranstion - determines whether single party transition is used.
*/	
// ChazM 7/13/07

#include "_CSLCore_Messages"
#include "_CSLCore_Position"
//#include "ginc_transition"

void main(string sDestination, int bIsPartyTranstion)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
 	object oDestination	= CSLGetTarget(sDestination);
	CSLStandardAttemptAreaTransition(oPC, oDestination, bIsPartyTranstion);
}