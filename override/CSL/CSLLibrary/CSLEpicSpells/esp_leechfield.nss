/////////////////////////////////////////////////
// Leech Field
// tm_s0_epleech.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: An AoE that saps the life of those in the
// field and transfers it to the caster.
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
	int iSpellId = SPELL_EPIC_LEECH_F;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_LEECH_F))
	{

		//Declare variables
		int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
		int nToAffect = nCasterLevel;
		location lTarget = HkGetSpellTargetLocation();

		// Visual effect creations
		effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
		effect eImpact2 = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
		effect eImpact3 = EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD );

		// Linking visuals
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );

		effect eAOE = EffectAreaOfEffect ( AOE_PER_EVARDS_BLACK_TENTACLES, "tm_s0_epleecha", "tm_s0_epleechb", "****" );

		//Create an instance of the AOE Object
		HkApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nCasterLevel) );
	}
	HkPostCast(oCaster);
}
