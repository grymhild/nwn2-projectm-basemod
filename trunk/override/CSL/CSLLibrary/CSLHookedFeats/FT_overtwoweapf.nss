//::///////////////////////////////////////////////
//:: Oversized Two-Weapon Fighting
//:: cmi_s2_over2wpnft
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_overtwoweapf();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	//int iSpellId = HkGetSpellId();
	//int iClass = CLASS_TYPE_NONE;
	//int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	// HkPreCast( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes );

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	EvaluateOver2WpnFight();
	
	// HkPostCast(oCaster);
}