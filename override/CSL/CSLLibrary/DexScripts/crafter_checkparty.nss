int StartingConditional()
{
	object oPC=GetPCSpeaker(), oNPC, oPCOwner;
	string RosterName;
	int HasCrafter=FALSE;
	
	RosterName=GetFirstRosterMember();
	
	while (RosterName!="" && HasCrafter==FALSE)
	{
		if (GetSubString(RosterName,0,5)=="craft")
		{
			oNPC=GetObjectFromRosterName(RosterName);
			if (GetIsObjectValid(oNPC)==TRUE)
			{
				SendMessageToPC(GetFirstPC(), "CheckParty: RosterMember " + RosterName + " is Present");
				oPCOwner=GetLocalObject(oNPC, "Crafter_PCOwner");
				if (GetIsObjectValid(oPCOwner)==TRUE)
				{
					SendMessageToPC(GetFirstPC(), "CheckParty: RosterMember " + RosterName + " is Owned by PC (" + GetName(oPC) + ")");
					if (oPCOwner==oPC) HasCrafter=TRUE;
				}	
			}
		}
		RosterName=GetNextRosterMember();
	}

	return HasCrafter;
}