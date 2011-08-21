//::///////////////////////////////////////////////
//:: Actuvate Item Script
//:: x0_s3_portal
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This directly teleports the user back to their last
	ANCHOR.

*/
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = 0;
	object oItem = GetSpellCastItem();
	object oTarget = HkGetSpellTarget();
	location lLocal = HkGetSpellTargetLocation();
	SetLocalInt(oTarget, "NW_L_PORTALINSTANT", 10);
	SignalEvent(GetModule(), EventActivateItem(oItem, lLocal, oTarget));
}