//::///////////////////////////////////////////////
//:: Cure Moderate Wounds
//:: NW_S0_CurModW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure moderate wounds
// cures 2d8 points of damage plus 1 point per
// caster level (up to +10).
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
	//scSpellMetaData = SCMeta_SP_curemodwound();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURE_MODERATE_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Cure_Moderate_Wounds )
	{
		iSpellId = SPELL_BG_Cure_Moderate_Wounds;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = 2;
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
	

	SCspellsCure(d8(2), 10, 16, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_L, GetSpellId());
	
	HkPostCast(oCaster);
}

