//::///////////////////////////////////////////////
//:: Special Ability King Of Shadows: Protection
//:: nw_s1_kos_prot
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/13/06
//:://////////////////////////////////////////////
// BMA-OEI 8/22/06 -- Implemented as Cloak of Shadows
// BMA-OEI 10/10/06 -- Patch 1: Apply to Inner Sanctum Statues

#include "_HkSpell" 
#include "_HkSpell"


const string SEF_KOS_PROTECTION_IMP = "fx_shockwave";
//const string SEF_KOS_PROTECTION_DUR = "fx_shadow_cloak";


// Shadow Cloak impact visual effect
void ApplyShadowCloakImpact( object oObject );

// Shadow Cloak gameplay effect + duration visual
void ApplyShadowCloakEffect( object oObject );

// Attempt to apply Shadow Cloak to object sTag
void ApplyShadowCloakByTag( string sTag );


void main()
{
	//scSpellMetaData = SCMeta_FT_shadowprot();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	// Apply protection to Inner Sanctum statues
	ApplyShadowCloakByTag( "34_p_stat_aurora_chain" );
	ApplyShadowCloakByTag( "34_p_stat_cleansing_nova" );
	ApplyShadowCloakByTag( "34_p_stat_shining_shield" );
	ApplyShadowCloakByTag( "34_p_stat_soothing_light" );
	ApplyShadowCloakByTag( "34_p_stat_web_of_purity" );
	
	HkPostCast(oCaster);
}


// Shadow Cloak impact visual effect
void ApplyShadowCloakImpact( object oObject )
{
	effect eVisual = EffectNWN2SpecialEffectFile( SEF_KOS_PROTECTION_IMP );
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oObject );
}

// Shadow Cloak gameplay effect + duration visual
void ApplyShadowCloakEffect( object oObject )
{
	effect eVisual = EffectVisualEffect( 887 ); // VFX_DUR_SHADOW_CLOAK
	effect eDR = EffectDamageReduction( 50, ALIGNMENT_GOOD, 0, DR_TYPE_ALIGNMENT );
	effect eLink = EffectLinkEffects( eVisual, eDR );
	eLink = SupernaturalEffect( eLink );
	HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oObject, RoundsToSeconds( 10 ) );
}

// Attempt to apply Shadow Cloak to object sTag
void ApplyShadowCloakByTag( string sTag )
{
	object oTarget = GetNearestObjectByTag( sTag );
	if ( GetIsObjectValid( oTarget ) == TRUE )
	{
		SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
		ApplyShadowCloakImpact( oTarget );
		ApplyShadowCloakEffect( oTarget );
	}
}

