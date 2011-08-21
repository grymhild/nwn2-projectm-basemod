//::///////////////////////////////////////////////////////////////////////////
//::
//:: nwn2_s1_truename3.nss
//::
//:: Insert comment about this file here.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//:: Created by: Brian Fox
//:: Created on: 8/18/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TRUE_NAME_THREE;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = GetLocalObject( OBJECT_SELF, "NWN2_TRUE_NAME_TARGET" );
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Fire cast spell at event for the specified target
		SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE) );
			
	effect eImmortalEffects = GetFirstEffect( oTarget );
	while ( GetIsEffectValid(eImmortalEffects) )
	{
		int iSpellId = GetEffectSpellId( eImmortalEffects );
		int iDurationType = GetEffectDurationType( eImmortalEffects );
		int nEffectType = GetEffectType( eImmortalEffects );
		object oEffectCreator = GetEffectCreator( eImmortalEffects );
		
		if ( iSpellId == SPELL_ALL_SPELLS &&
			iDurationType == DURATION_TYPE_PERMANENT &&
			nEffectType == EFFECT_TYPE_TURN_RESISTANCE_INCREASE &&
			oEffectCreator == oTarget )
		{
			RemoveEffect( oTarget, eImmortalEffects );
			break;
		}
		
		eImmortalEffects = GetNextEffect( oTarget );
	}
	

	SCDispelTarget(oTarget, oCaster, SCGetDispellCount(SPELL_TRUE_NAME, TRUE), SPELL_TRUE_NAME );
	HkApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_SPELL_ABJURATION ), oTarget );
	//SetPlotFlag( oTarget, FALSE ); // The meat and potatoes
	SetImmortal( oTarget, FALSE ); // The meat and potatoes
	AssignCommand( oTarget, ClearAllActions(TRUE) ); // Disrupt the target's current action (simulating a concentration check failure)
		
	// Caster clean-up section below //
/*
	// The gameplay mechanism for NWN2 offical campaign is designed such that the caster is unpossessable during casting
	// and that the spell itself is cast only from within a custom AI (DetermineCombatRound) script.  Revert to defaults here.
	// We also call ClearAllActions(TRUE) to clear any queued castings of the spell, as its 30-second casting time is likely
	// to cause multiple ActionCastSpellAtObject's to get queued before the spell completes.
	// Finally, we kickstart the caster's DetermineCombatRound so that they are re-inserted into default combat behavior ASAP.
	SetIsCompanionPossessionBlocked( OBJECT_SELF, FALSE );
	SetCreatureOverrideAIScript( OBJECT_SELF, "" );
	AssignCommand( OBJECT_SELF, SetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE) );
	AssignCommand( OBJECT_SELF, ClearAllActions() );
	AssignCommand( OBJECT_SELF, DetermineCombatRound() );
*/
	// End of caster clean-up //
}

