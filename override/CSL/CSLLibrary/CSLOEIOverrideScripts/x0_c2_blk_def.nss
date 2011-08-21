//::///////////////////////////////////////////////
//:: Default On Blocked
//:: NW_C2_DEFAULTE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "_SCInclude_Doors"

void main()
{
    SCHandleBlockedDoor( GetBlockingDoor(), OBJECT_SELF );
}