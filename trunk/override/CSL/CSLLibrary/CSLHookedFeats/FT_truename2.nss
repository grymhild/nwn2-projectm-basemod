//::///////////////////////////////////////////////////////////////////////////
//::
//:: nwn2_s1_truename2.nss
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
	int iSpellId = SPELL_TRUE_NAME_TWO;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
			
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetLocalObject( OBJECT_SELF, "NWN2_TRUE_NAME_TARGET" );
	ActionCastSpellAtObject( 990, oTarget, METAMAGIC_ANY, TRUE );
}

