//::///////////////////////////////////////////////
//:: Activate Item Script
//:: x0_s3_portal
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This directly teleports the user back to their last
    ANCHOR.

*/
//:://////////////////////////////////////////////

void main()
{
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    location lLocal = GetSpellTargetLocation();
    SetLocalInt(oTarget, "NW_L_PORTALINSTANT", 10);
	
	object oPC = GetItemActivator();
	//SendMessageToPC(oPC, "Activating portal s3" );
	
    SignalEvent(GetModule(), EventActivateItem(oItem, lLocal, oTarget));
}