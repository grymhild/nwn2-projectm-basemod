#include "elu_functions_i"

void MakeTrapAtLocation(location loc)
{
	 CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, loc, 1.0, "mytrap", STANDARD_FACTION_COMMONER);
}


void main()
{
	object oPC = GetLastUsedBy();

	GiveXPToCreature(oPC, 1000);

	int nInt = GetSkillRank(SKILL_INTIMIDATE, oPC, FALSE);
	
	SendMessageToPC(oPC, "Intimidate: " + IntToString(nInt));
	
	string sTag = GetTag(GetFirstItemInInventory(OBJECT_SELF));
	SendMessageToPC(oPC, "Tag: " + sTag);
	SetTag(GetFirstItemInInventory(OBJECT_SELF), sTag + sTag);
	SendMessageToPC(oPC, "TagLength: " + IntToString(GetStringLength(sTag)));
	AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
}