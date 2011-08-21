//::///////////////////////////////////////////////
//:: Citadel Training
//:: cmi_s2_cittrain
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 26, 2008
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/



//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_darklantcitt();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_DARKLANT_CIT_TRAIN;
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
	if (GetHasSpellEffect(iSpellId,oCaster))
	{
		return;
		//RemoveSpellEffects(iSpellId, OBJECT_SELF, OBJECT_SELF);
	}	
	
	effect eDiplo = EffectSkillIncrease(SKILL_DIPLOMACY, 2);
	effect eSearch = EffectSkillIncrease(FEAT_SKILL_FOCUS_SEARCH, 2);
	effect eLink = EffectLinkEffects(eDiplo, eSearch);	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster, 0.0f, iSpellId));
	
	// HkPostCast(oCaster);
}      

