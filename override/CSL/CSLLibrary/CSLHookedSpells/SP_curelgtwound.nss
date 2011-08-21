//::///////////////////////////////////////////////
//:: Cure Light Wounds
//:: NW_S0_CurLgtW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// When laying your hand upon a living creature,
// you channel positive energy that cures 1d8 points
// of damage plus 1 point per caster level (up to +5).
// Since undead are powered by negative energy, this
// spell inflicts damage on them instead of curing
// their wounds. An undead creature can attempt a
// Will save to take half damage.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Healing"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_curelgtwound();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURE_LIGHT_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
	if ( GetSpellId() == SPELL_BG_Cure_Light_Wounds )
	{
		iSpellId = SPELL_BG_Cure_Light_Wounds;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELLABILITY_LESSER_BODY_ADJUSTMENT )
	{
		iSpellId = SPELLABILITY_LESSER_BODY_ADJUSTMENT;
		iSpellSchool = SPELL_SCHOOL_EVOCATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_PSIONIC;
	}
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_POSITIVE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	SCspellsCure(d8(), 5, 8, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_M, GetSpellId());
	
	HkPostCast(oCaster);
}

