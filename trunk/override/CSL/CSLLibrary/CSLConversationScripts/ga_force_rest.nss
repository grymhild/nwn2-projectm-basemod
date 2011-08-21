/*
This is a SP Official campaign script for features in the single player game
*/
// ga_force_rest(int bAllPartyMembers))
/*
	Do a force rest on PC Speaker
	
		int bAllPartyMembers - 1 = force rest every one in party 
	
*/
// ChazM 7/11/07
// TDE 10/708 - New version for NX2 that causes the time to pass
#include "_CSLCore_Messages"

void AdvanceTime(object oPC, int nHours)
{
	int nCurrentHour = GetTimeHour();
	int nNewHour;

	nNewHour = nCurrentHour + nHours;
	
	if ( nNewHour > 23 )
		nNewHour -= 24;
	
	SetTime(nNewHour, GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());
	
	//PrettyDebug("ga_force_rest: Time Advanced to hour " + IntToString(nNewHour));
}

void main(int bAllPartyMembers)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
    if ( bAllPartyMembers == 0 )
		ForceRest(oPC);
    else
    {
        object oTarget = GetFirstFactionMember(oPC, FALSE);
        while(GetIsObjectValid(oTarget))
        {
            ForceRest(oTarget);
			
            oTarget = GetNextFactionMember(oPC, FALSE);
        }
        
        if ( GetIsSinglePlayer() ) // add in support for getting the campaign so this only works in certain modules, or perhaps a flag
        {
			int nHours = 8;
			if(GetHasFeat(FEAT_TW_GROUP_TRANCE, oPC, TRUE))	//Group Trance halves the amount of time required for the party to rest.
			{
				nHours /= 2;
			}
				
			AdvanceTime(oPC, nHours);
		}
        
    }
	
	
}