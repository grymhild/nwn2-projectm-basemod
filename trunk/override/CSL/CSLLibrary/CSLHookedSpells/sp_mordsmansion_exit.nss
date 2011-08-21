#include "_CSLCore_Position"

void main()
{
	object oPC = GetLastUsedBy();
	//string sTag = GetTag(OBJECT_SELF);
	//		SendMessageToPC( oPC, "You are exiting "+GetName(oPC));

	if ( !CSLGetCanTeleport( oPC ) )
	{
		SendMessageToPC( oPC, "You are Dimensionally Blocked and Cannot Teleport");
		return;
	}
	
	location lWP = GetLocalLocation(oPC, "MORDMANSION_RETURN" );
	if ( !GetIsLocationValid( lWP ) )
	{
		lWP = GetStartingLocation(); // error use module start location and hope its a good spot
	}
	
	if ( GetIsLocationValid( lWP ) )
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
		
		effect eDisappear = EffectNWN2SpecialEffectFile("fx_altargen");
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDisappear, lWP, 5.0f);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), lWP );
		AssignCommand(oPC, ActionJumpToLocation(lWP));
	}
}