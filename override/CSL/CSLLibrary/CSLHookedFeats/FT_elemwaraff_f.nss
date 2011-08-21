//::///////////////////////////////////////////////
//:: Elemental Affinity - Fire
//:: cmi_s2_elemafinf
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: August 4th, 2008
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/



//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_elemwaraff_f();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ELEMWAR_AFFINITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iAttributes = 0;
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
	

	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	 	
	effect eDR = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
	eDR = SetEffectSpellId(eDR,iSpellId);
	eDR = SupernaturalEffect(eDR);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, OBJECT_SELF, 0.0f,  iSpellId));	
	
	// HkPostCast(oCaster);
}