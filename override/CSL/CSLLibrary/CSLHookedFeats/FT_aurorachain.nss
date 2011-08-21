//::///////////////////////////////////////////////
//:: Feat: Aurora Chain
//:: nw_s2_aurorachain
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	All nearby party members' equipped weapons or
	hands radiate light.  Any attack, whether melee,
	ranged or spell-based, will deal +1 holy damage
	for every 4 character levels.
	The Target glows for the duration of the effect
	The effect lasts for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/09/06
//:://////////////////////////////////////////////
//:: AFW-OEI 04/26/2006: Changed to match
//:: GDD modifications:
//:: * All Ritual abilities now stack
//:: * Damage bonus is now +1 holy / 4 character levels.
//:: * Caster is treated the same as everyone else in the party.
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox
//:: Modified On: 9/01/06
//:: Removed the distance check; this now affects ALL party members
//:: regardless of distance.
//:://////////////////////////////////////////////
// BMA-OEI 10/10/06 -- Patch 1: Modified bonus to +1*Caster/4 Attack & Damage vs. Evil to all equipped weapons


#include "_HkSpell" 


//const float fAURORA_MAX_DIST = 30.0f; // (meters)


// Applies Aurora Chain gameplay/visual effects to oObject
// * Attack and Damage Bonus vs. Evil for equipped weapons
void ApplyAuroraChainToObject( object oObject, int iBonus, float fDuration );


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel =  HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels( oCaster, TRUE );
	
	
	int iBonus = iCasterLevel/4; // +1 Attack and Damage vs. Evil per 4 caster levels
	float fDuration = RoundsToSeconds( 5 ); // Spell duration is a fixed 5 rounds.
	float fDist;
	float fDelay;

	object oTarget = GetFirstFactionMember( oCaster, FALSE );
	while ( GetIsObjectValid( oTarget ) )
	{
		if ( CSLPCIsClose(oCaster, oTarget, 10) )
		{
			fDist = GetDistanceBetween( oCaster, oTarget ); // returns 0.0 if they're in different areas
			fDelay = 0.1 * fDist;
	
			DelayCommand( fDelay, SignalEvent( oTarget, EventSpellCastAt( oCaster, iSpellId, FALSE ) ) );
			DelayCommand( fDelay, ApplyAuroraChainToObject( oTarget, iBonus, fDuration ) );
		}
		oTarget = GetNextFactionMember( oCaster, FALSE );
	}
	
	HkPostCast(oCaster);
}

// Applies Aurora Chain gameplay/visual effects to oObject
// * Attack and Damage Bonus vs. Evil for equipped weapons
void ApplyAuroraChainToObject( object oObject, int iBonus, float fDuration )
{
	effect eVisHit = EffectVisualEffect( 890 ); // VFX_HIT_AURORA_CHAIN
	effect eVisPersist = EffectVisualEffect( 891 ); // VFX_DUR_AURORA_CHAIN
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eVisHit, oObject );
	HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVisPersist, oObject, fDuration );

	itemproperty ipAttack = ItemPropertyAttackBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, iBonus );
	itemproperty ipDamage = ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, iBonus );
	object oLeft = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oObject );
	object oRight = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oObject );

	if ( GetIsObjectValid( oLeft ) == TRUE )
	{
		AddItemProperty( DURATION_TYPE_TEMPORARY, ipAttack, oLeft, fDuration );
		AddItemProperty( DURATION_TYPE_TEMPORARY, ipDamage, oLeft, fDuration );
	}
	
	if ( GetIsObjectValid( oRight ) == TRUE )
	{
		AddItemProperty( DURATION_TYPE_TEMPORARY, ipAttack, oRight, fDuration );
		AddItemProperty( DURATION_TYPE_TEMPORARY, ipDamage, oRight, fDuration );
	}
}