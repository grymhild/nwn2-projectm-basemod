//::///////////////////////////////////////////////////////////////////////////
//::
//:: nw_s1_kos_dota.nss
//::
//:: This is the OnEnter script for a AOE_MOB_SHADOW_PLAGUE effect.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//:: Created by: Brian Fox
//:: Created on: 8/30/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

const int NEGATIVE_LEVEL_AMOUNT = 1;
const int NEGATIVE_ENERGY_DAM_AMOUNT = 5;

void ApplyInstantPlagueEffects( object oTarget )
{
	effect eNegativeLevel = EffectNegativeLevel( NEGATIVE_LEVEL_AMOUNT );
	effect eDuration = EffectLinkEffects( eNegativeLevel, EffectVisualEffect( 889 ) ); // VFX_DUR_SHADOW_PLAGUE

	effect eDamage = EffectDamage( NEGATIVE_ENERGY_DAM_AMOUNT, DAMAGE_TYPE_NEGATIVE );
	effect eImpact = EffectLinkEffects( eDamage, EffectVisualEffect( VFX_HIT_SPELL_EVIL ) );
	
	HkApplyEffectToObject( DURATION_TYPE_PERMANENT, eDuration, oTarget );
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
}

void main()
{
	//scSpellMetaData = SCMeta_FT_shadowdot(); //SPELLABILITY_KOS_DOT;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCreator) )
	{
		SignalEvent( oTarget, EventSpellCastAt(oCreator, GetSpellId()) );
		ApplyInstantPlagueEffects( oTarget );
	}
}