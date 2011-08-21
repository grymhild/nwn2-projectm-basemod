//::///////////////////////////////////////////////
//:: Default On Heartbeat
//:: NW_C2_DEFAULT1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI_IntellDev"


void main()
{
	object oCreature = OBJECT_SELF;
	CW_Heartbeat( oCreature );
}