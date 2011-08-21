// ga_blackout
// 
// wrapper function for FadeToBlackParty() to instantly make screen black.  Useful for the
// first node of conversations.

// CGaw & BMa 2/13/06 - Created.

#include "_SCInclude_Overland"
// moved code here out of include since it was trivial


void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	object oPCFacMem = GetFirstFactionMember(oPC);	
	while(GetIsObjectValid(oPCFacMem))
    {
		FadeToBlack(oPCFacMem, 0.0 );
        oPCFacMem = GetNextFactionMember(oPC);
    }
	
}