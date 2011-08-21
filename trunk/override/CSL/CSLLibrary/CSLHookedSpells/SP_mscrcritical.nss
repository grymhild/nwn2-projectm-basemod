//::///////////////////////////////////////////////
//:: Mass Cure Moderate Wounds
//:: NW_S0_MaCurMod
//:://////////////////////////////////////////////
/*
	Mass Cure Critical Wounds
	PHB, pg. 215
	School:        Conjuration (Healing)
	Components:    Verbal, Somatic
	Range:         Close
	Target:        One creature/level
	Duration:      Instantaneous

	This uses positive energy to cure 4d8 points of damage +1 point
	per caster level (maximum +40). This affects first the caster
	and his immediate party, then the nearest non-hostile targets
	(Neutral targets exempt) within range of the caster. This
	spell can be spontaneously cast.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




#include "_SCInclude_Healing"

void main()
{
	//scSpellMetaData = SCMeta_SP_mscrcritical();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_CURE_CRITICAL_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_CURE_AOE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_POSITIVE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
	effect eImpact = EffectVisualEffect(VFX_HIT_CURE_AOE);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
	int iBonus = CSLGetMin(40, iSpellPower);
	iSpellPower -= CureFaction(oCaster, iSpellPower, eVis, eVis2, 4, iBonus);
	CureNearby(oCaster, iSpellPower, eVis, eVis2, 4, iBonus);
	
	HkPostCast(oCaster);
}

