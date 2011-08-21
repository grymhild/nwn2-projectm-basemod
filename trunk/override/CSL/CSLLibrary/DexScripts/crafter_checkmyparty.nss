int StartingConditional()
{
	object oPC=GetPCSpeaker(), oPCOwner;
	object oNPC=GetNearestObjectByTag("craft", oPC, 1);
	int HasCrafter=FALSE;
	
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);
	
	if (GetIsObjectValid(oNPC)==TRUE)
	{
		SendMessageToPC(GetFirstPC(), "CheckMyParty: Crafter is Present");
		if (GetIsRosterMember(oNPC)==TRUE)
		{
			SendMessageToPC(GetFirstPC(), "CheckMyParty: Crafter is a Roster Member (" + GetRosterNameFromObject(oNPC) + ")");
			oPCOwner=GetLocalObject(oNPC, "Crafter_PCOwner");
			if (GetIsObjectValid(oPCOwner)==TRUE)
			{
				SendMessageToPC(GetFirstPC(), "CheckMyParty: Crafter is a Roster Member (" + GetRosterNameFromObject(oNPC) + ") and owned by PC (" + GetName(oPCOwner) + ")");
				if (oPCOwner==oPC) HasCrafter=TRUE;
			}	
		}
	}
	return HasCrafter;
}