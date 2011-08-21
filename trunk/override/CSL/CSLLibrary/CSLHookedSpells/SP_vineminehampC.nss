//::///////////////////////////////////////////////
//:: Vine Mine, Hamper Movement: Heartbeat
//:: X2_S0_VineMHmpC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of Vine Mine, Hamper
    Movement have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Now 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "_HkSpell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
}