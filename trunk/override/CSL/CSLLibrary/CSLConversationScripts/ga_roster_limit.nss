/*
	This function will set the roster limit
	
	ga_roster_limit 7

*/

void main(string sParameters)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iOldRosterLimit = GetRosterNPCPartyLimit();
	int iNewRosterLimit = iOldRosterLimit;
	
	if ( sParameters != "" && IntToString(StringToInt(sParameters)) == sParameters )
	{
		iNewRosterLimit = StringToInt(sParameters);
	}
	
	if ( iOldRosterLimit != iNewRosterLimit && iNewRosterLimit > 0 )
	{
		SetRosterNPCPartyLimit( iNewRosterLimit );
		SendMessageToPC(oPC, "<color=indianred>"+"Set Roster Limit of "+IntToString(iNewRosterLimit)+" from "+IntToString(iOldRosterLimit)+"</color>");
	}
	else
	{
		SendMessageToPC(oPC, "<color=indianred>"+"Roster Limit is "+IntToString(iOldRosterLimit)+"</color>");
	}
}