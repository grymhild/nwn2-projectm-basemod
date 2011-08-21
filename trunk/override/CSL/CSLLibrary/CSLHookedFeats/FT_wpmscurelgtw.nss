//::///////////////////////////////////////////////
//:: Warpriest Mass Cure Light Wounds
//:: NW_S2_WPMaCLW
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, Mass Cure damages undead in
// its area rather than curing them.
//
// This incarnation is for the Warpriest's spell-like
// ability.  It is based on the regular Mass Cure Light
// wounds; the only difference is that caster level stuff
// is replaced by Warpriest levels.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Healing"

void main()
{
	//scSpellMetaData = SCMeta_FT_wpmscurelgtw();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iImpactSEF = VFX_HIT_CURE_AOE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST) * 2;
	effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eImpact = EffectVisualEffect(VFX_HIT_AOE_CONJURATION);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
	int iBonus = CSLGetMin(20, iCasterLevel);
	iCasterLevel -= CureFaction(oCaster, iCasterLevel, eVis, eVis2, 1, iBonus);
	CureNearby(oCaster, iCasterLevel, eVis, eVis2, 1, iBonus);
	
	HkPostCast(oCaster);
}

