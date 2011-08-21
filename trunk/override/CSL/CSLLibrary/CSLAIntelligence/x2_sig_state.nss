//::///////////////////////////////////////////////
//:: x2_sig_state
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sends an event to every party member
    saying I've been put into a disabling state
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

#include "_SCInclude_AI"

void main()
{
     // TK removed SCSendForHelp
//    SCSendForHelp();
	SCInitializeCreatureInformation(OBJECT_SELF);
}