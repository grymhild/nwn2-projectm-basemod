/*

    Companion and Monster AI

    This file contains routines used to initialize creatures for combat - setting
    up inventory items, auto cast long duration buffs, etc.

*/

#include "_SCInclude_AI"


void main()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " running initialization");
	if (DEBUGGING >= 10) { CSLDebug(  "hench_SCPreprocess Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC() ); }
	
	object oTarget = OBJECT_SELF;
	
	if (SCAIIsCachedCreatureInformationExpired(oTarget,oTarget))
    {
        SCAIInitCachedCreatureInformation(oTarget);
        SetLocalInt(oTarget, "HenchLastEffectQuery", GetTimeSecond() + 24); //  reduce the load when they are just spawned
    }
    if (DEBUGGING >= 10) { CSLDebug(  "hench_SCPreprocess End", GetFirstPC() ); }
}