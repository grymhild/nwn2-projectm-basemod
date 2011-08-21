//::///////////////////////////////////////////////
//:: Melodic Casting
//:: SOZ UPDATE BTM
//:: cmi_s2_melodcast
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Nov 17, 2008
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FEAT_MELODIC_CASTING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );	
		
	int nPerform = GetSkillRank(SKILL_PERFORM, oCaster, TRUE);
	int nConc = GetSkillRank(SKILL_CONCENTRATION, oCaster, TRUE);
	int iBonus = nPerform - nConc;
	
	if (iBonus > 0)
	{
		effect eSkill = EffectSkillIncrease(SKILL_CONCENTRATION, iBonus);
		eSkill = SetEffectSpellId(eSkill,iSpellId);
		eSkill = SupernaturalEffect(eSkill);
		DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, oCaster ));	
	}   
	//else
	//{
	//	return;
	//}
	
	HkPostCast(oCaster);
}   

