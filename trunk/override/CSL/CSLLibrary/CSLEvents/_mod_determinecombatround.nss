#include "_SCInclude_AI" // for determinecombatround function

void main()
{
   object oPC = OBJECT_SELF;
   DelayCommand(5.2, AssignCommand(oPC, SCAIDetermineCombatRound(GetLocalObject(oPC, "CSL_INTRUDER"),GetLocalInt(oPC, "CSL_AIDIFFICULTY"),oPC )));
}