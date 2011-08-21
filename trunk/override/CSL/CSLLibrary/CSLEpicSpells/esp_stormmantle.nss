//::///////////////////////////////////////////////
//:: Storm Mantle
//:: tm_s0_epstrmmant.nss
//:://////////////////////////////////////////////
/*
	Grants all within the casters party within a radius of 10
	to receive a Greater Spell Mantle.
*/
//:://////////////////////////////////////////////
//:: Created By: Nron Ksr
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_STORM_M;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	if (GetCanCastSpell(OBJECT_SELF, iSpellId))
	{
		
		object oTarget = GetFirstObjectInShape( SHAPE_SPHERE,
			RADIUS_SIZE_HUGE, HkGetSpellTargetLocation() );
		effect eVis = EffectVisualEffect( VFX_DUR_SPELLTURNING );
		effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
		int nDuration = HkGetCasterLevel( OBJECT_SELF ); // Bone - changed

		effect eImpact = EffectVisualEffect( VFX_FNF_LOS_NORMAL_20 );
		HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation() );

		while( GetIsObjectValid(oTarget) )
		{
			if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) )
			{
				//Link Effects are inside the IF to cause a d12 roll on each mantle
				int nAbsorb = d12() + 10;
				effect eAbsob = EffectSpellLevelAbsorption( 9, nAbsorb );
				effect eLink = EffectLinkEffects( eVis, eAbsob );
				eLink = EffectLinkEffects( eLink, eDur );

				//Fire cast spell at event for the specified target
				SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF,
				SPELL_GREATER_SPELL_MANTLE, FALSE) );
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId );
				//Apply the VFX impact and effects
				HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
			}
			oTarget = GetNextObjectInShape( SHAPE_SPHERE,
				RADIUS_SIZE_HUGE, HkGetSpellTargetLocation() );
		}
	}
	HkPostCast(oCaster);
}

