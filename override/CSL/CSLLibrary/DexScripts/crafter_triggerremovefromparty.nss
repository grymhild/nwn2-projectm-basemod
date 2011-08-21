#include "crafter_include"
//#include "pawnshopscan"

void main ()
{
	object oPC=GetEnteringObject(), oNPC;
	string RosterName;
	
	if (oPC==OBJECT_INVALID || GetIsPC(oPC)==FALSE) return;
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	//PawnShopScan(oPC);

	RosterName=GetFirstRosterMember();
	
	while (RosterName!="")
	{
		//SendMessageToPC(oPC, "RosterName=" + RosterName);

		//oNPC=GetObjectFromRosterName(RosterName);
		/*
		Commented - A Pawn Shop Scan of a NPC is making the script crash on execution and therefor causes the crafter to not be removed.
		if (GetIsObjectValid(oNPC)==TRUE)
		{
			PawnShopScan(oNPC);
		}
		*/

		if (GetSubString(RosterName,0,5)=="craft")
		{
			SendMessageToPC(GetFirstPC(), "TriggerRemoveFromParty: Found a Crafter (" + RosterName + ")");
			oNPC=GetObjectFromRosterName(RosterName);
			if (GetIsObjectValid(oNPC)==TRUE)
			{
				SendMessageToPC(GetFirstPC(), "TriggerRemoveFromParty: Crafter is a valid object (" + GetName(oNPC) + "/" + GetTag(oNPC) + ")");
				if (GetLocalObject(oNPC, "Crafter_PCOwner")==oPC)
				{
					SendMessageToPC(GetFirstPC(), "TriggerRemoveFromParty: PC (" + GetName(GetLocalObject(oNPC, "Crafter_PCOwner")) + ") Owns this Crafter, Removing");
					RemoveCrafterFromParty(oPC, oNPC, RosterName);
				}
			}
		}
		RosterName=GetNextRosterMember();
	}
}