#include "elu_functions_i"

void MakeTrapAtLocation(location loc)
{
	 CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, loc, 1.0, "mytrap", STANDARD_FACTION_COMMONER);
}


void main()
{
	object oPC = GetLastUsedBy();

	GiveXPToCreature(oPC, 1000);

	int nSpot = GetSkillRank(SKILL_SPOT, oPC, FALSE);	
	SendMessageToPC(oPC, "Spot: " + IntToString(nSpot));
	nSpot = GetSkillRank(SKILL_SPOT, oPC, TRUE);	
	SendMessageToPC(oPC, "Spot (Base Rank): " + IntToString(nSpot));
	
	AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
}