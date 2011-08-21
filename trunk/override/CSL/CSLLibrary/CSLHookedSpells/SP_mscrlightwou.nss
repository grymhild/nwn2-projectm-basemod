//::///////////////////////////////////////////////
//:: Mass Cure Light Wounds (WAS: Healing Circle)
//:: NW_S0_MaCurLigt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, Mass Cure damages undead in
// its area rather than curing them.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




#include "_SCInclude_Healing"

void main()
{
	//scSpellMetaData = SCMeta_SP_mscrlightwou();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_CURE_LIGHT_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eImpact = EffectVisualEffect(VFX_HIT_CURE_AOE);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
	int iBonus = CSLGetMin(20, iSpellPower);
	iSpellPower -= CureFaction(oCaster, iSpellPower, eVis, eVis2, 1, iBonus);
	CureNearby(oCaster, iSpellPower, eVis, eVis2, 1, iBonus);
	
	HkPostCast(oCaster);
}

