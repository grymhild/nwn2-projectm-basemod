/////////////////////////////////////////////////
// Tolodine's Killing Wind
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_TOLO_KW;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_TOLO_KW))
	{
		//Declare variables
		int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
		int nToAffect = nCasterLevel;
		location lTarget = HkGetSpellTargetLocation();

		// Visual effect creations
		effect eImpact = EffectVisualEffect( 262 );
		effect eImpact2 = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_MIND );
		effect eImpact3 = EffectVisualEffect( VFX_FNF_HOWL_WAR_CRY );
		effect eImpact4 = EffectVisualEffect( VFX_FNF_SOUND_BURST );

		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact4, lTarget );

		effect eAOE = EffectAreaOfEffect
			( AOE_PER_FOG_OF_BEWILDERMENT, "tm_s0_epkillwnda", "tm_s0_epkillwndb", "****" );

		//Create an instance of the AOE Object
		HkApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(10) );
	}
	HkPostCast(oCaster);
}
