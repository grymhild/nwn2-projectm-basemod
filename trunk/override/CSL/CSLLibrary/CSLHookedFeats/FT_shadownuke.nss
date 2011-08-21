//::///////////////////////////////////////////////
//:: Special Ability King Of Shadows: Nuke
//:: nw_s1_kos_nuke
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/13/06
//:://////////////////////////////////////////////
// BMA-OEI 8/23/06 -- Implemented as Cradle of Rime
// BMA-OEI 8/28/06 -- Increased range to 100.0f, corrected damage type

#include "_HkSpell" 
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




const string SEF_KOS_NUKE = "fx_kos_power_spell";
const string SEF_KOS_NUKE_IMPACT = "fx_cradle_hit";
const float KOS_NUKE_RADIUS = 100.0f;

void KoSNukeTarget( object oTarget );

void main()
{
	//scSpellMetaData = SCMeta_FT_shadownuke();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	location lTarget = HkGetSpellTargetLocation();
	
	// Nuke visual effect
	//effect eVisual = EffectNWN2SpecialEffectFile( SEF_KOS_NUKE );
	effect eVisual = EffectVisualEffect( 886 ); // VFX_AOE_CRADLE_OF_RIME
	HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVisual, lTarget );
	
	// Find targets to nuke
	float fDelay;
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, KOS_NUKE_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE );

	while ( GetIsObjectValid( oTarget ) == TRUE )
	{
		// Determine if object within sphere is hostile
		if ( CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ) )
		{
			fDelay = 0.1f * GetDistanceBetweenLocations( lTarget, GetLocation( oTarget ) );
			DelayCommand( fDelay, KoSNukeTarget( oTarget ) );
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, KOS_NUKE_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	}
	HkPostCast(oCaster);
}

void KoSNukeTarget( object oTarget )
{
	SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_KOS_NUKE, TRUE ) );
	
	int nSpellSaveDC = HkGetSpellSaveDC();
	int nDamage1 = 100;
	int nDamage2 = 100;
	
	nDamage1 = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE, nDamage1, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD );
	nDamage2 = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE, nDamage2, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE );
	
	effect eDamage1 = EffectDamage( nDamage1, DAMAGE_TYPE_COLD );
	effect eDamage2 = EffectDamage( nDamage2, DAMAGE_TYPE_NEGATIVE );
	
	//effect eVisual = EffectNWN2SpecialEffectFile( SEF_KOS_NUKE_IMPACT );
	effect eVisual = EffectVisualEffect( 885 ); // VFX_HIT_CRADLE_OF_RIME
	//effect eKnockdown = EffectKnockdown();
	
	// Apply the massive damage
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oTarget );
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage1, oTarget );
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage2, oTarget );
	//HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f );
}