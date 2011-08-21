//::///////////////////////////////////////////////
//:: x2_door_death
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    On death of a door it spawns in an appropriate
    item component.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: August 2003
//:://////////////////////////////////////////////
// MDiekmann 5/21/07 - Modified so door explosion effect plays

#include "x2_inc_compon"
#include "_SCInclude_Doors"

void main()
{
    SConDoorDeath( OBJECT_SELF ); 
	craft_drop_placeable();
	effect eDoorExplode = EffectNWN2SpecialEffectFile( "fx_wooden_explosion_big");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDoorExplode, OBJECT_SELF);
	SConDoorDeath( OBJECT_SELF ); 
}