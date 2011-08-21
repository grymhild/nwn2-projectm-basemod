//::///////////////////////////////////////////////
//:: Bladesinger's Battle Caster
//:: cmi_s2_bsbattcast
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_bsbattlecast();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	//int iSpellId = SPELLABILITY_Battle_Caster;
	/*
	object oCaster = OBJECT_SELF;
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	*/
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	EvaluateBattleCaster();
	
}