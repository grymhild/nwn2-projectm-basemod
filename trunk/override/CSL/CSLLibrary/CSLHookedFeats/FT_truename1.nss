//:://////////////////////////////////////////////////////////////////////////
//:: NWN2 Special Case Spell - True Name
//:: nwn2_s1_truename.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 11/02/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
	
//:: Modified By: Brian Fox - OEI
//:: Modified On: 11/11/05
//:://////////////////////////////////////////////////////////////////////////
/*
	This is a special case spell script that removes the immortal
	flag of certain NPCs.
*/
//:://////////////////////////////////////////////////////////////////////////
// 11/22/05 - BDF: added ClearAllActions() to final effect so that any queued castings of this spell are cleared.
// 3/1/06 - BDF: Moved all the clean-up code that was originally in the target's OnSpellCastAt handler
// 7/20/06 - BDF: modified to check/dispell immortality instead of plotness
// 9/14/06 - ChazM: removed kinc_globals dependency so script can remain global

#include "_HkSpell"
#include "_SCInclude_Abjuration"
//#include "ginc_debug"
//#include "kinc_globals"
const string IMMUNE_TO_TRUE_NAME = "bImmuneToTrueName"; // whether a creature is susceptible to the True Name spell

void main()
{
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TRUE_NAME;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = HkGetSpellTarget();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if ( GetIsObjectValid(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && GetImmortal(oTarget) && !GetLocalInt(oTarget, IMMUNE_TO_TRUE_NAME) )
	{
		/*
		SetLocalObject( OBJECT_SELF, "NWN2_TRUE_NAME_TARGET", oTarget );
		ActionCastSpellAtObject( 989, oTarget, METAMAGIC_ANY, TRUE );
		*/
		
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
		

		SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), iSpellId );
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
	else
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
			//PrettyError( "True Name spell targeting invalid object" );
	}
}

