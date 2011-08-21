/////////////////////////////////////////////////
// Magma Burst
// tm_s0_epMagmaBu.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save. If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"
//#include "_SCSpell"
//#include "_HkSpell"
#include "_SCInclude_Epic"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_MAGMA_B;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MAGMA_B))
	{

		object oCaster = OBJECT_SELF;
		object oTarget;
		// Boneshank - Added in the nDC formula.
		float fDelay;
		int nDamage;
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		effect eAOE = EffectAreaOfEffect
			( AOE_PER_FOGFIRE, "tm_s0_epmagmabua", "tm_s0_epmagmabub", "tm_s0_epmagmabuc" );
		location lTarget = HkGetSpellTargetLocation();
		int nDuration = HkGetCasterLevel(OBJECT_SELF) / 5; //B- changed.
		effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_FIRE );
		effect eImpact2 = EffectVisualEffect( VFX_FNF_IMPLOSION );
		effect eImpact3 = EffectVisualEffect( VFX_FNF_STRIKE_HOLY );
		effect eImpact4 = EffectVisualEffect( VFX_FNF_FIRESTORM );
		effect eVis = EffectVisualEffect( VFX_IMP_FLAME_M );
		effect eDam;
		// Direct Impact is handled first. (20d8) - reflex.
		// Apply the explosion at the location captured above.
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact4, lTarget );

		// Declare the spell shape, size and the location. Capture the first target .
		oTarget = GetFirstObjectInShape
			( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
		// Cycle through the targets within the spell shape until an invalid object is captured.
		while( GetIsObjectValid(oTarget) )
		{
			if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
			{
				//Fire cast spell at event for the specified target
				SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL) );
				// Set the delay for the explosion.
				fDelay = CSLRandomBetweenFloat( 0.5f, 2.0f );
				if( !HkResistSpell(OBJECT_SELF, oTarget, fDelay) )
				{
				nDamage = d8(20);
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				nDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE, nDamage, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_FIRE );
				//Set the damage effect
				eDam = HkEffectDamage( nDamage, DAMAGE_TYPE_FIRE );
				if( nDamage > 0 )
				{
					// Apply effects to the currently selected target (dmg & visual)
					DelayCommand( fDelay,
						HkApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget) );
					DelayCommand( fDelay,
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
				}
				}
			}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape
				( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
		}

		//Create the AoE object at the location for the next effects
		HkApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration) );
	}
	HkPostCast(oCaster);
}
