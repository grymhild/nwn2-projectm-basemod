//::///////////////////////////////////////////////
//:: Fearsome Reputation
//:: cmi_s2_fearrep
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: November 23, 2009
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nSpellId = SPELLABILITY_DRPIRATE_FEARSOME_REPUTATION;
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, nSpellId );

	int nBonus = 2;
	if (GetLevelByClass(CLASS_DREAD_PIRATE, oCaster) > 9)
	{
		nBonus = 6;
	}
	else if (GetLevelByClass(CLASS_DREAD_PIRATE, oCaster) > 5)
	{
		nBonus = 4;
	}
	effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, nBonus);
	eDiplomacy = SetEffectSpellId(eDiplomacy,nSpellId);
	eDiplomacy = SupernaturalEffect(eDiplomacy);
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDiplomacy, oCaster, HoursToSeconds(72)));
}