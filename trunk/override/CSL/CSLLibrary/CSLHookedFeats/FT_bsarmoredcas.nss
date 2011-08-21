//::///////////////////////////////////////////////
//:: Bladesinger's Armored Caster
//:: cmi_s2_bsarmrcast
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_bsarmoredcas();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	//object oCaster = OBJECT_SELF;
	//int iSpellId = SPELLABILITY_Armored_Caster;
	//int iClass = CLASS_TYPE_NONE;
	//int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	//if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	//{
	//	return;
	//}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	EvaluateArmoredCaster();
	
	//HkPostCast(oCaster);
}