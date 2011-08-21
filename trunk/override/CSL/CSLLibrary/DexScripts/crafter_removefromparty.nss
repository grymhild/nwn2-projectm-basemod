#include "crafter_include"

void main ()
{
	object oPC=GetPCSpeaker(), oPCOwner;
	//object oNPC=GetLastSpeaker();
	object oNPC=GetNearestObjectByTag("craft", oPC, 1);
	
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	if (GetIsObjectValid(oNPC)==TRUE)
	{
		SendMessageToPC(GetFirstPC(), "RemoveFromParty: Crafter is Present");
		if (GetIsRosterMember(oNPC)==TRUE)
		{
			SendMessageToPC(GetFirstPC(), "RemoveFromParty: Crafter is a Roster Member (" + GetRosterNameFromObject(oNPC) + ")");
			oPCOwner=GetLocalObject(oNPC, "Crafter_PCOwner");
			if (GetIsObjectValid(oPCOwner)==TRUE)
			{
				SendMessageToPC(GetFirstPC(), "RemoveFromParty: Crafter is a Roster Member (" + GetRosterNameFromObject(oNPC) + ") and owned by PC (" + GetName(oPCOwner) + "), Removing");
				RemoveCrafterFromParty(oPC, oNPC, GetRosterNameFromObject(oNPC));
			}
		}
	}
}