//::///////////////////////////////////////////////
//:: Sacred Vow
//:: cmi_s2_sacredvow
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Feb 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sacredvow();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_Sacred_Vow;
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_Sacred_Vow );
	
	
	 
	effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, 2);
	eDiplomacy = SetEffectSpellId(eDiplomacy,iSpellId);
	eDiplomacy = SupernaturalEffect(eDiplomacy);
	
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDiplomacy, OBJECT_SELF, HkApplyDurationCategory(3, SC_DURCATEGORY_DAYS), iSpellId ));	

		//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDiplomacy, OBJECT_SELF, HkApplyDurationCategory(3, SC_DURCATEGORY_DAYS) );
	
	
	HkPostCast(oCaster);
}