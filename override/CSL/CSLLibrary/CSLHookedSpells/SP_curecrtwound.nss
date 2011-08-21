//::///////////////////////////////////////////////
//:: Cure Critical Wounds
//:: NW_S0_CurCrWn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure critical wounds
// cures 4d8 points of damage plus 1 point per
// caster level (up to +20).
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
	//scSpellMetaData = SCMeta_SP_curecrtwound();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURE_CRITICAL_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Cure_Critical_Wounds )
	{
		iSpellId = SPELL_BG_Cure_Critical_Wounds;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	SCspellsCure(d8(4), 20, 32, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G, GetSpellId());
	
	HkPostCast(oCaster);
}

