/*

    Companion and Monster AI

    Just does a simple melee attack of intruder, used by commoners

*/

#include "_SCInclude_AI"

void main()
{
    object oIntruder = GetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    DeleteLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    
    SCHenchEquipDefaultWeapons();
    ActionAttack(oIntruder);
}