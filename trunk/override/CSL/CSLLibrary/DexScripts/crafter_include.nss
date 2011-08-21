//****************************************

void AddCrafterToParty (object oPC, object oNPC)
{
	string RosterName;
	int Status=0;
	
	RosterName=GetLocalString(oNPC, "RosterName");
	Status=AddRosterMemberByCharacter(RosterName, oNPC);
	SetIsRosterMemberSelectable(RosterName, TRUE);
	Status=AddRosterMemberToParty(RosterName, oPC);
	SetLocalObject(oNPC, "Crafter_PCOwner", oPC);
}

//****************************************

void RemoveCrafterFromParty (object oPC, object oNPC, string RosterName)
{
	object oNPC;
	string Tag;
	int Status=0;

	if (GetIsPC(oNPC)) SetOwnersControlledCompanion(oNPC, oPC);	
	RemoveRosterMemberFromParty(RosterName, oPC, TRUE);
	oNPC=SpawnRosterMember(RosterName, GetLocation(GetObjectByTag("wp_"+RosterName)));
	//SendMessageToPC(GetFirstPC(), "Testing DeleteLocalObject: GetName(GetLocalObject(oNPC, 'Crafter_PCOwner'))=" + GetName(GetLocalObject(oNPC, "Crafter_PCOwner")));
	SetIsRosterMemberSelectable(RosterName, FALSE);
	Status=RemoveRosterMember(RosterName);
	DeleteLocalObject(oNPC, "Crafter_PCOwner");
}

//****************************************