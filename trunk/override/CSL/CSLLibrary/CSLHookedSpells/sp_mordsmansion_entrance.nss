// Placeable OnUsed Template	
/*
	Required: Static=FALSE, Usable=TRUE, CurrentHP>0, attach script to the OnUsed event
	Suggested: Plot=TRUE, DefaultActionPreference="Use"
*/
//
// wp_tp_mordsmansion
#include "_CSLCore_Position"

void main()
{
	object oPC = GetLastUsedBy();
	//string sTag = GetTag(OBJECT_SELF);
	object oPortal = OBJECT_SELF;
	//SendMessageToPC( oPC, "You ("+GetName(oPC)+")are Entering "+GetName(oPortal));
	
	//SendMessageToPC( GetFirstPC(), "sp_mordsmansion_entrance");

	object oCaster = GetLocalObject(oPortal, "MANSION_CASTER" );
	if ( oCaster != oPC && GetReputation( oCaster, oPC ) < 90 )
	{
		SendMessageToPC( oPC, "The owner of this mansion does not know you");
		SendMessageToPC( oCaster, GetName(oPC)+" is unable to enter your mansion");
		int nUses = CSLDecrementLocalInt(oPortal, "USES", 1);
		if (nUses<1)
		{
			DestroyObject(oPortal);
		}
		return;
	}
	 
	if ( !CSLGetCanTeleport( oPC ) )
	{
		SendMessageToPC( oPC, "You are Dimensionally Anchored");
		return;
	}
	
	//PrettyDebug( GetName( OBJECT_SELF ) + "'s was used by " + GetName( oUser ) );
	location lWP = GetLocation(GetObjectByTag(GetLocalString(oPortal, "DESTINATION")));
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
		
	location lPortal = GetLocation(oPortal);
	SetLocalLocation(oPC, "MORDMANSION_RETURN", lPortal);
	effect eDisappear = EffectNWN2SpecialEffectFile("fx_altargen");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDisappear, lPortal, 5.0f);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(oPortal));
	AssignCommand(oPC, ActionJumpToLocation(lWP));
		
	int nUses = CSLDecrementLocalInt(oPortal, "USES", 1);
	if (nUses<1)
	{
		DestroyObject(oPortal);
	}
}