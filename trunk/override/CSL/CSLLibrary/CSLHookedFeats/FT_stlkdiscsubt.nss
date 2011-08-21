//::///////////////////////////////////////////////
//:: Discover Subterfuge
//:: cmi_s2_discsbtfg
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: December 22, 2008
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SHDWSTLKR_DISCOVER_SUBTERFUGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );

	int nClass = GetLevelByClass(CLASS_SHADOWBANE_STALKER, OBJECT_SELF);
	int nBonus = 2;

	if (nClass > 7) //8th
	{
		nBonus = 6;
	}
	else if (nClass > 4) //5th
	{
		nBonus = 4;
	}
	effect eSkill = EffectSkillIncrease(SKILL_SEARCH, nBonus);
	eSkill = SetEffectSpellId(eSkill,iSpellId);
	eSkill = SupernaturalEffect(eSkill);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, OBJECT_SELF));
}